package allumettes;

/**
 * Interface de Stratégie
 * @author aandre2
 */

public interface Strategie {
	/**
	 * Renvoie le nombres d'allumettes que le joueur souhaite enlever
	 * @param JeuAllumettes
	 * @return
	 */
	int getPrise(Jeu jeu);
}
