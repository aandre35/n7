package allumettes;

import org.junit.*;
import static org.junit.Assert.*;

/**
 * Classe de test pour la stratégie rapide
 * 
 * @author aandre2
 */

public class StrategieRapideTest {

	private Strategie strategie;

	public void main(String[] args) {
		org.junit.runner.JUnitCore.main(StrategieRapideTest.class.getName());
	}

	@Before
	public void setUp() {
		this.strategie = new StrategieRapide();
	}

	@Test
	public void testerGetPrise() throws CoupInvalideException {
		Jeu jeu = new JeuAllumettes(13);
		while (jeu.getNombreAllumettes() > 0) {
			if (jeu.getNombreAllumettes() >= jeu.PRISE_MAX) {
				assertEquals(this.strategie.getPrise(jeu), jeu.PRISE_MAX);
				jeu.retirer(jeu.PRISE_MAX);
			} else {
				assertEquals(this.strategie.getPrise(jeu), jeu.getNombreAllumettes());
				jeu.retirer(jeu.getNombreAllumettes());
			}
		}
	}

	@Test
	public void testerToString() {
		assertEquals(this.strategie.toString(), "rapide");
	}

}
