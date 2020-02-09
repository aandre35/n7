package allumettes;

public class Joueur {
	private String nomJoueur;
	private Strategie strategie;

	/**
	 * Initialise un nouveau joueur
	 * @param Le nom du joueur, String
	 */
	public Joueur(String nom, Strategie strat) {
		this.nomJoueur = nom;
		this.strategie = strat;
	}

	/**
	 * Obtenir le nom d'un joueur
	 * @return le nom du joueur
	 */
	public String getNom() {
		return nomJoueur;
	}

	/**
	 * Obtenir le nombre de prise qu'un joueur a choisi de faire
	 * @return la prise du joueur, un entier compris entre 1 et 3
	 */
	public int getPrise(Jeu jeu) {
		assert (jeu != null);
		assert (jeu.getNombreAllumettes() > 0);
		return this.strategie.getPrise(jeu);
	}

	public Strategie getStrategie() {
		return this.strategie;
	}

	public void setStrategie(Strategie newStrategie) {
		this.strategie = newStrategie;
	}
}
