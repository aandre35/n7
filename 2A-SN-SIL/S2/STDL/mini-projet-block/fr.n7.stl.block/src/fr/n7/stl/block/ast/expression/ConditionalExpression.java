/**
 * 
 */
package fr.n7.stl.block.ast.expression;

import fr.n7.stl.block.ast.SemanticsUndefinedException;
import fr.n7.stl.block.ast.scope.Declaration;
import fr.n7.stl.block.ast.scope.HierarchicalScope;
import fr.n7.stl.block.ast.type.AtomicType;
import fr.n7.stl.block.ast.type.Type;
import fr.n7.stl.tam.ast.Fragment;
import fr.n7.stl.tam.ast.TAMFactory;
import fr.n7.stl.util.Logger;

/**
 * Abstract Syntax Tree node for a conditional expression.
 * @author Marc Pantel
 *
 */
public class ConditionalExpression implements Expression {

	/**
	 * AST node for the expression whose value is the condition for the conditional expression.
	 */
	protected Expression condition;
	
	/**
	 * AST node for the expression whose value is the then parameter for the conditional expression.
	 */
	protected Expression thenExpression;
	
	/**
	 * AST node for the expression whose value is the else parameter for the conditional expression.
	 */
	protected Expression elseExpression;
	
	/**
	 * Builds a binary expression Abstract Syntax Tree node from the left and right sub-expressions
	 * and the binary operation.
	 * @param _left : Expression for the left parameter.
	 * @param _operator : Binary Operator.
	 * @param _right : Expression for the right parameter.
	 */
	public ConditionalExpression(Expression _condition, Expression _then, Expression _else) {
		this.condition = _condition;
		this.thenExpression = _then;
		this.elseExpression = _else;
	}

	/* (non-Javadoc)
	 * @see fr.n7.stl.block.ast.expression.Expression#collect(fr.n7.stl.block.ast.scope.Scope)
	 */
	@Override
	public boolean collectAndPartialResolve(HierarchicalScope<Declaration> _scope) {
		boolean _ok = this.condition.collectAndPartialResolve(_scope) && this.thenExpression.collectAndPartialResolve(_scope);
		if (this.elseExpression == null) {
			return _ok;
		} else {
		return _ok && this.elseExpression.collectAndPartialResolve(_scope);
		}
	}

	/* (non-Javadoc)
	 * @see fr.n7.stl.block.ast.expression.Expression#resolve(fr.n7.stl.block.ast.scope.Scope)
	 */
	@Override
	public boolean completeResolve(HierarchicalScope<Declaration> _scope) {
		boolean _ok = this.condition.completeResolve(_scope) && this.thenExpression.completeResolve(_scope);
		if (this.elseExpression ==null) {
			return _ok;
		} else {
			return _ok && this.elseExpression.completeResolve(_scope);
		}
	}

	/* (non-Javadoc)
	 * @see java.lang.Object#toString()
	 */
	@Override
	public String toString() {
		return "(" + this.condition + " ? " + this.thenExpression + " : " + this.elseExpression + ")";
	}
	
	/* (non-Javadoc)
	 * @see fr.n7.stl.block.ast.Expression#getType()
	 */
	@Override
	public Type getType() {
		Type typeCond = this.condition.getType();
		Type typeThen = this.thenExpression.getType();
		Type typeElse = this.elseExpression.getType();
		if (! typeCond.compatibleWith(AtomicType.BooleanType)){
			Logger.error("Une expression booléenne est attendue mais une expression de type " + typeCond.toString() + " a été trouvée.");
			return AtomicType.ErrorType;
		} else {
			if (typeThen.compatibleWith(typeElse)){
				return typeThen.merge(typeElse);
			} else{
				Logger.error("Les types des blocks else et then différents. then : " + typeThen.toString() + " != else : " + typeElse.toString() + ").");
				return AtomicType.ErrorType;
			}
		}
	}

	/* (non-Javadoc)
	 * @see fr.n7.stl.block.ast.Expression#getCode(fr.n7.stl.tam.ast.TAMFactory)
	 */
	@Override
	public Fragment getCode(TAMFactory _factory) {
		String id = String.valueOf(_factory.createLabelNumber());
		Fragment code = _factory.createFragment();
		code.append(this.condition.getCode(_factory));
		code.add(_factory.createJumpIf("etiq_debut_else_" + id, 0));
		code.append(this.thenExpression.getCode(_factory));
		code.add(_factory.createJump("etiq_fin_if_" + id));
		code.addSuffix("etiq_debut_else_" + id);
		code.append(this.elseExpression.getCode(_factory));
		code.addSuffix("etiq_fin_if_" + id);
		return code;	
	}

}
