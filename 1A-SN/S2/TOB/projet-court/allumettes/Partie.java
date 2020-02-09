package allumettes;

/**
 * Lance une partie des 13 allumettes en fonction des arguments fournis sur la
 * ligne de commande.
 * @author Xavier Crégut
 * @version $Revision: 1.5 $
 */
public class Partie {
	/**
	 * Permet d'obtenir la stratégie choisie par l'utilisateur
	 * @param nom, nom de la stratégie
	 * @return
	 */
	public static Strategie getStrategie(String nom) {
		String nomStrategie = nom.toLowerCase();
		switch (nomStrategie) {
		case "naif":
			return new StrategieNaive();
		case "rapide":
			return new StrategieRapide();
		case "expert":
			return new StrategieExpert();
		case "tricheur":
			return new StrategieTricheur();
		default:
			return new StrategieHumaine();
		}
	}

	/**
	 * Permet de vérifier si le nom de la stratégie saisie est valide ou non
	 * @param saisieStrategie
	 * @return valide
	 */
	private static boolean estValide(String saisieStrategie) {
		boolean valide = (saisieStrategie.equals("naif") || saisieStrategie.equals("expert")
				|| saisieStrategie.equals("rapide") || saisieStrategie.equals("humain"))
				|| saisieStrategie.equals("tricheur");
		return valide;
	}

	/**
	 * Lancer une partie. En argument sont donnés les deux joueurs sous la forme
	 * nom@stratégie.
	 * @param args la description des deux joueurs
	 */
	public static void main(String[] args) {
		try {
			verifierNombreArguments(args);
			/* Création du jeu */
			final int nbAllumettesInitial = 13;
			Jeu jeu = new JeuAllumettes(nbAllumettesInitial);
			/* Création des joueurs */
			Joueur joueur1;
			Joueur joueur2;
			/* Création des joueurs dans le cas confiant */
			final int nbArgumentMax = 3;
			int ajoutPlus1 = 0;
			if (args[0].equals("-confiant") && args.length == nbArgumentMax) {
				ajoutPlus1 = 1;
			}
			/* Création des joueurs */
			String[][] joueurs = new String[2][];
			Joueur[] joueursTab = new Joueur[2];
			for (int i = 0; i < 2; i++) {
				joueurs[i] = args[ajoutPlus1 + i].split("@");
				if (!estValide(joueurs[i][1])) {
					throw new ConfigurationException("Strategie invalide");
				} else {
					joueursTab[i] = new Joueur(joueurs[i][0], getStrategie(joueurs[i][1]));
				}
			}
			joueur1 = joueursTab[0];
			joueur2 = joueursTab[1];
			/* Création de l'arbitre */
			Arbitre arbitre = new Arbitre(joueur1, joueur2, ajoutPlus1 == 1);
			arbitre.arbitrer(jeu);
		} catch (OperationInterditeException error) {
		} catch (ConfigurationException e) {
			System.out.println();
			System.out.println("Erreur : " + e.getMessage());
			afficherUsage();
			System.exit(1);
		}
	}

	private static void verifierNombreArguments(String[] args) {
		final int nbJoueurs = 2;
		if (args.length < nbJoueurs) {
			throw new ConfigurationException("Trop peu d'arguments : " + args.length);
		}
		if (args.length > nbJoueurs + 1) {
			throw new ConfigurationException("Trop d'arguments : " + args.length);
		}
		if (args.length == nbJoueurs + 1 && !args[0].equals("-confiant")) {
			throw new ConfigurationException("Argument confiant mal écrit");
		}
	}

	/** Afficher des indications sur la manière d'exécuter cette classe. */
	public static void afficherUsage() {
		System.out.println("\n" + "Usage :"
				+ "\n\t" + "java allumettes.Partie joueur1 joueur2"
				+ "\n\t\t" + "joueur est de la forme nom@stratégie"
				+ "\n\t\t" + "strategie = naif | rapide | expert | humain | tricheur"
				+ "\n"
				+ "\n\t" + "Exemple :"
				+ "\n\t" + "	java allumettes.Partie Xavier@humain " + "Ordinateur@naif"
				+ "\n");
	}
}
