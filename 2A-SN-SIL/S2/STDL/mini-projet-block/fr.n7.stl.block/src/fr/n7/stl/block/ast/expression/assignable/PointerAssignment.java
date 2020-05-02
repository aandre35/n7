/**
 * 
 */
package fr.n7.stl.block.ast.expression.assignable;

import fr.n7.stl.block.ast.SemanticsUndefinedException;
import fr.n7.stl.block.ast.expression.AbstractPointer;
import fr.n7.stl.block.ast.expression.Expression;
import fr.n7.stl.tam.ast.Fragment;
import fr.n7.stl.tam.ast.Register;
import fr.n7.stl.tam.ast.TAMFactory;

/**
 * Abstract Syntax Tree node for an expression whose computation assigns the content of a pointed cell.
 * @author Marc Pantel
 *
 */
public class PointerAssignment extends AbstractPointer implements AssignableExpression {

	/**
	 * Construction for the implementation of a pointer content assignment expression Abstract Syntax Tree node.
	 * @param _pointer Abstract Syntax Tree for the pointer expression in a pointer content assignment expression.
	 */
	public PointerAssignment(Expression _pointer) {
		super(_pointer);
	}
	
	/* (non-Javadoc)
	 * @see fr.n7.stl.block.ast.impl.PointerAccessImpl#getCode(fr.n7.stl.tam.ast.TAMFactory)
	 */
	@Override
	public Fragment getCode(TAMFactory _factory) {
		Fragment f = _factory.createFragment();
		int _offset = ((VariableAssignment) this.pointer).declaration.getOffset();
		Register _register = ((VariableAssignment) this.pointer).declaration.getRegister();
		int _sizes = this.getType().length();
		f.add(_factory.createLoad(_register, _offset, _sizes));
		f.add(_factory.createStoreI(this.getType().length()));
		return f;	
	}
	
}
