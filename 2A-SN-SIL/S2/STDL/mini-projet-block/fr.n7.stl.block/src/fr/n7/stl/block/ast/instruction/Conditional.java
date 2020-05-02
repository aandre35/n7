/**
 * 
 */
package fr.n7.stl.block.ast.instruction;

import java.util.Optional;

import fr.n7.stl.block.ast.Block;
import fr.n7.stl.block.ast.SemanticsUndefinedException;
import fr.n7.stl.block.ast.expression.Expression;
import fr.n7.stl.block.ast.scope.Declaration;
import fr.n7.stl.block.ast.scope.HierarchicalScope;
import fr.n7.stl.block.ast.scope.SymbolTable;
import fr.n7.stl.block.ast.type.AtomicType;
import fr.n7.stl.tam.ast.Fragment;
import fr.n7.stl.tam.ast.Register;
import fr.n7.stl.tam.ast.TAMFactory;
import fr.n7.stl.tam.ast.impl.FragmentImpl;

/**
 * Implementation of the Abstract Syntax Tree node for a conditional instruction.
 * @author Marc Pantel
 *
 */
public class Conditional implements Instruction {

	protected Expression condition;
	protected Block thenBranch;
	protected Block elseBranch;

	public Conditional(Expression _condition, Block _then, Block _else) {
		this.condition = _condition;
		this.thenBranch = _then;
		this.elseBranch = _else;
	}

	public Conditional(Expression _condition, Block _then) {
		this.condition = _condition;
		this.thenBranch = _then;
		this.elseBranch = null;
	}

	/* (non-Javadoc)
	 * @see java.lang.Object#toString()
	 */
	@Override
	public String toString() {
		return "if (" + this.condition + " )" + this.thenBranch + ((this.elseBranch != null)?(" else " + this.elseBranch):"");
	}
	
	/* (non-Javadoc)
	 * @see fr.n7.stl.block.ast.instruction.Instruction#collect(fr.n7.stl.block.ast.scope.Scope)
	 */
	@Override
	public boolean collectAndPartialResolve(HierarchicalScope<Declaration> _scope) {
		Boolean _ok = this.condition.collectAndPartialResolve(_scope) && this.thenBranch.collectAndPartialResolve(_scope);
		if (this.elseBranch == null) {
			return _ok;
		} else {
			return _ok && this.elseBranch.collectAndPartialResolve(_scope);
		}
	}
	
	/* (non-Javadoc)
	 * @see fr.n7.stl.block.ast.instruction.Instruction#resolve(fr.n7.stl.block.ast.scope.Scope)
	 */
	@Override
	public boolean completeResolve(HierarchicalScope<Declaration> _scope) {
		Boolean _ok = this.condition.completeResolve(_scope) && this.thenBranch.completeResolve(_scope);
		if (this.elseBranch == null) {
			return _ok;
		} else {
			return _ok && this.elseBranch.completeResolve(_scope);
		}
	}

	/* (non-Javadoc)
	 * @see fr.n7.stl.block.ast.Instruction#checkType()
	 */
	@Override
	public boolean checkType() {
		boolean _ok =  this.condition.getType().equals(AtomicType.BooleanType) && this.thenBranch.checkType();
		if(this.elseBranch != null) {
			return _ok && this.elseBranch.checkType();
		}
		return _ok;
	}
	/* (non-Javadoc)
	 * @see fr.n7.stl.block.ast.Instruction#allocateMemory(fr.n7.stl.tam.ast.Register, int)
	 */
	@Override
	public int allocateMemory(Register _register, int _offset) {
		this.thenBranch.allocateMemory(_register, _offset);
		if (this.elseBranch != null) {
			this.elseBranch.allocateMemory(_register, _offset);
		}
		return 0;
	}

	/* (non-Javadoc)
	 * @see fr.n7.stl.block.ast.Instruction#getCode(fr.n7.stl.tam.ast.TAMFactory)
	 */
	@Override
	public Fragment getCode(TAMFactory _factory) {
		// Création d'un id de condition
		String id = Integer.toString(_factory.createLabelNumber());
		// Création du fragment de code 
		Fragment code = _factory.createFragment();
		
		// Création des sous-fragments
		Fragment condition_code = this.condition.getCode(_factory);
		Fragment then_code = this.thenBranch.getCode(_factory);
		
		
		code.append(condition_code);
		
		code.addComment("--------------------------------------------");
		code.addComment("IF "+id+" : condition : " + condition);
		code.addComment("--------------------------------------------");
		System.out.println("code then : " + then_code);
		if (then_code.getSize()>0) {
			then_code.addComment("--------------");
			then_code.addComment("THEN " + id);
			then_code.addComment("--------------");			
		}

		
		if (this.elseBranch != null) {
			code.add(_factory.createJumpIf("etiq_debut_else_"+id,0));
			code.append(then_code);
			code.add(_factory.createJump("etiq_fin_if_"+id));
			code.addSuffix("etiq_debut_else_"+id);
			Fragment else_code = this.elseBranch.getCode(_factory);
			else_code.addComment("--------------");
			else_code.addComment("ELSE " + id);
			else_code.addComment("--------------");
			code.append(else_code);
		} else {
			code.add(_factory.createJumpIf("etiq_fin_if_"+id,0));
			code.append(then_code);

		}
		
		code.addSuffix("etiq_fin_if_"+id);
		return code;
	}

}
