package allumettes;

import java.util.Random;

public class StrategieNaive implements Strategie {
	private Random r;

	/**
	 * Le Constructeur
	 */
	public StrategieNaive() {
		this.r = new Random();
	}

	public int getPrise(Jeu jeu) {
		int prise = this.r.nextInt(jeu.PRISE_MAX) + 1;
		return prise;
	}

	public String toString() {
		return "naive";
	}
}
