package allumettes;

import java.util.Scanner;

public class StrategieHumaine implements Strategie {
	/* le scanner */
	private Scanner scanner;

	/** Le constructeur */
	public StrategieHumaine() {
		this.scanner = new Scanner(System.in);
	}

	public int getPrise(Jeu jeu) {
		boolean sortie = false;
		int choix = 0;
		while (!sortie) {
			System.out.print("Combien prenez-vous d'allumettes ? ");
			try {
				choix = Integer.parseInt(this.scanner.nextLine());
				sortie = true;
			} catch (NumberFormatException error) {
				System.out.println("Vous devez donner un entier.");
			}
		}
		return choix;
	}

	public String toString() {
		return "humaine";
	}
}
