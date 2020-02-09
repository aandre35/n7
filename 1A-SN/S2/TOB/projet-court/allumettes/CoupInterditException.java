package allumettes;

public class CoupInterditException extends RuntimeException {
	public CoupInterditException() {
		super("Ce coup n'est pas autorisé!");
	}
}
