/**
 * 
 */
package fr.n7.stl.block.ast.instruction;

import fr.n7.stl.block.ast.SemanticsUndefinedException;
import fr.n7.stl.block.ast.expression.Expression;
import fr.n7.stl.block.ast.scope.Declaration;
import fr.n7.stl.block.ast.scope.HierarchicalScope;
import fr.n7.stl.block.ast.type.AtomicType;
import fr.n7.stl.block.ast.type.Type;
import fr.n7.stl.tam.ast.Fragment;
import fr.n7.stl.tam.ast.Library;
import fr.n7.stl.tam.ast.Register;
import fr.n7.stl.tam.ast.TAMFactory;

/**
 * Implementation of the Abstract Syntax Tree node for a printer instruction.
 * @author Marc Pantel
 *
 */
public class Printer implements Instruction {

	protected Expression parameter;

	public Printer(Expression _value) {
		this.parameter = _value;
	}

	/* (non-Javadoc)
	 * @see java.lang.Object#toString()
	 */
	@Override
	public String toString() {
		return "print " + this.parameter + ";\n";
	}
	
	/* (non-Javadoc)
	 * @see fr.n7.stl.block.ast.instruction.Instruction#collect(fr.n7.stl.block.ast.scope.Scope)
	 */
	@Override
	public boolean collectAndPartialResolve(HierarchicalScope<Declaration> _scope) {
		return this.parameter.collectAndPartialResolve(_scope);
	}
	
	/* (non-Javadoc)
	 * @see fr.n7.stl.block.ast.instruction.Instruction#resolve(fr.n7.stl.block.ast.scope.Scope)
	 */
	@Override
	public boolean completeResolve(HierarchicalScope<Declaration> _scope) {
		return this.parameter.completeResolve(_scope);
	}

	/* (non-Javadoc)
	 * @see fr.n7.stl.block.ast.Instruction#checkType()
	 */
	@Override
	public boolean checkType() {
		return true;
	}

	/* (non-Javadoc)
	 * @see fr.n7.stl.block.ast.Instruction#allocateMemory(fr.n7.stl.tam.ast.Register, int)
	 */
	@Override
	public int allocateMemory(Register _register, int _offset) {
		return 0;
	}

	/* (non-Javadoc)
	 * @see fr.n7.stl.block.ast.Instruction#getCode(fr.n7.stl.tam.ast.TAMFactory)
	 */
	@Override
	public Fragment getCode(TAMFactory _factory) {
		Fragment code = _factory.createFragment();
		Fragment code_param = this.parameter.getCode(_factory);
		Type typeOfReturn = this.parameter.getType();
		
		if (typeOfReturn == AtomicType.BooleanType) {
			code.append(code_param);
			code.add(Library.I2B);
			code.add(Library.BOut);
		} else if (typeOfReturn == AtomicType.IntegerType ){
			code.append(code_param);
			code.add(Library.IOut);
		} else if (typeOfReturn == AtomicType.CharacterType) {
			code.add(_factory.createLoadL('\''));
			code.add(Library.COut);
			code.append(code_param);
			code.add(Library.COut);
			code.add(_factory.createLoadL('\''));
			code.add(Library.COut);
		} else if (typeOfReturn == AtomicType.StringType) {
			code.add(_factory.createLoadL('\"'));
			code.add(Library.COut);
			code.append(code_param);
			code.add(Library.SOut);
			code.add(_factory.createLoadL('\"'));
			code.add(Library.COut);
		}
		code.addComment("--------------");
		String _comment = "Printer : print " + this.parameter.toString();
		code.addComment(_comment);
		code.addComment("--------------");

		// TO DO : append getPrintCode
		return code;
	}

}
