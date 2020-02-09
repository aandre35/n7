package allumettes;

public class StrategieExpert implements Strategie {
	public StrategieExpert() {
	}

	public int getPrise(Jeu jeu) {
		int prise;
		final int modulo4 = 4;
		if (jeu.getNombreAllumettes() - 1 % modulo4 == 1) {
			prise = 1;
		} else if (jeu.getNombreAllumettes() - 2 % modulo4 == 1) {
			prise = 2;
		} else if (jeu.getNombreAllumettes() - jeu.PRISE_MAX % modulo4 == 1) {
			prise = jeu.PRISE_MAX;
		} else {
			prise = 1;
		}
		return prise;
	}

	public String toString() {
		return "expert";
	}
}
