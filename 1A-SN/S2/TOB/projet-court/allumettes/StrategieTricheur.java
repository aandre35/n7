package allumettes;

public class StrategieTricheur implements Strategie {
	public StrategieTricheur() {
	}

	public int getPrise(Jeu jeu) {
		try {
			while (jeu.getNombreAllumettes() > 2) {
				jeu.retirer(1);
			}
		} catch (CoupInvalideException error) {
		}
		return 1;
	}

	public String toString() {
		return "tricheur";
	}
}
