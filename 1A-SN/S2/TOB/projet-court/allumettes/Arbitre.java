package allumettes;

public class Arbitre {
	private Joueur joueur1;
	private Joueur joueur2;
	private boolean estConfiant;

	/** Initialise un Arbitre
	 * @param j1, joueur 1
	 * @param j2, joueur 2
	 * @param estConf, savoir si l'arbitre est confiant.
	 */
	public Arbitre(Joueur j1, Joueur j2, boolean estConf) {
		assert (j1 != null);
		assert (j2 != null);
		this.joueur1 = j1;
		this.joueur2 = j2;
		this.estConfiant = estConf;
	}

	/**
	 * Initialise un Arbitre confiant
	 * @param j1, joueur 1
	 * @param j2, joueur 2
	 */
	public Arbitre(Joueur j1, Joueur j2) {
		this(j1, j2, true);
	}

	public String toString() {
		return "Le joueur 1 est : " + this.joueur1 + " Le joueur 2 est: " + this.joueur2;
	}

	/**
	 * Arbitrer une partie
	 * @param jeu
	 */
	public void arbitrer(Jeu jeu) {
		assert (jeu != null);
		assert (jeu.getNombreAllumettes() > 0);
		JeuProxy proxy = new JeuProxy(jeu);
		Joueur joueurActuel = this.joueur1;
		while (jeu.getNombreAllumettes() > 0) {
			System.out.println(jeu.toString());
			System.out.println("Au tour de " + joueurActuel.getNom() + ".");
			int nbPrises = joueurActuel.getPrise(jeu);
			try {
				if (!this.estConfiant
					&& joueurActuel.getStrategie().toString() == "tricheur") {
					proxy.retirer(nbPrises);
				} else {

					if (nbPrises > 1) {
						System.out.println(joueurActuel.getNom() + " prend "
								+ nbPrises + " allumettes." + "\n");
					} else {
						System.out.println(joueurActuel.getNom() + " prend "
								+ nbPrises + " allumette." + "\n");
					}
					jeu.retirer(nbPrises);
					/* On change de joueur */
					if (joueurActuel == this.joueur1) {
						joueurActuel = this.joueur2;
					} else {
						joueurActuel = this.joueur1;
					}
				}
			} catch (OperationInterditeException error) {
				System.out.println("Partie abandonnée car "
						+ joueurActuel.getNom() + " a triché !");
				throw new OperationInterditeException("Vous avez triché!");
			} catch (CoupInvalideException error) {
				System.out.println("Erreur ! " + error.getMessage());
				System.out.println("Recommencez !" + "\n");
			}
		}
		/* On annonce le gagnant et le perdant */
		Joueur gagnant = joueurActuel;
		Joueur perdant = joueurActuel;
		if (this.joueur1 == joueurActuel) {
			perdant = this.joueur2;
		} else {
			perdant = this.joueur1;
		}
		System.out.println(perdant.getNom() + " a perdu !" + "\n"
				+ gagnant.getNom() + " a gagné !");
	}
}
