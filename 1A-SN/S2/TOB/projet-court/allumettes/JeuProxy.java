package allumettes;

public class JeuProxy implements Jeu {
	/* Le jeu */
	private Jeu jeu;

	/**
	 * Le constructeur du jeu
	 * @param jeu
	 */
	public JeuProxy(Jeu jeu) {
		assert (jeu != null);
		this.jeu = jeu;
	}

	/**
	 * Retourne le nombre actuel d'allumettes
	 */
	public int getNombreAllumettes() {
		return this.jeu.getNombreAllumettes();
	}

	public String toString() {
		return this.jeu + "";
	}

	/**
	 * Retire des allumettes, sauf s'il y a triche une exception apparait
	 * @param nbPrises, nombre d'allumetes à retirer
	 */
	public void retirer(int nbPrises) throws CoupInvalideException {
		throw new OperationInterditeException("Vous avez triché!");
	}
}
