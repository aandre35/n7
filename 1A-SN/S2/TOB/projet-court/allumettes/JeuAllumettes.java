package allumettes;

public class JeuAllumettes implements Jeu {
	/** Nombre d'allumettes encore en jeu */
	private int allumettesRestantes;

	/**
	 * Le constructeur de la classe JeuAllumettes
	 * @param nbAllumettesInitial, le nombre initial d'allumettes
	 */
	public JeuAllumettes(int nbAllumettesInitial) {
		assert (nbAllumettesInitial > 0);
		this.allumettesRestantes = nbAllumettesInitial;
	}

	/**
	 * Retourne le nombre d'Allumetes restantes dans le jeu
	 */
	public int getNombreAllumettes() {
		return allumettesRestantes;
	}

	public String toString() {
		return "Nombre d'allumettes restantes : " + this.allumettesRestantes;
	}

	/**
	 * Retire un certain nombre d'Allumettes si celui-ci est valide
	 * @param nbPrises, le nombre d'allumettes a retiré
	 */
	public void retirer(int nbPrises) throws CoupInvalideException {
		if (this.allumettesRestantes - nbPrises < 0) {
			throw new CoupInvalideException(nbPrises, "> " + allumettesRestantes);
		} else if (nbPrises > PRISE_MAX) {
			throw new CoupInvalideException(nbPrises, ">" + PRISE_MAX);
		} else if (nbPrises < 1) {
			throw new CoupInvalideException(nbPrises, "< 1");
		} else {
			this.allumettesRestantes -= nbPrises;
		}
	}
}
