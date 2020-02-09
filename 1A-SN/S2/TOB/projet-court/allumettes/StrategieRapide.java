package allumettes;

public class StrategieRapide implements Strategie {
	/** Le Contructeur */
	public StrategieRapide() {
	}

	public int getPrise(Jeu jeu) {
		return Math.min(jeu.PRISE_MAX, jeu.getNombreAllumettes());
	}

	public String toString() {
		return "rapide";
	}
}
