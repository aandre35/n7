import java.awt.Color;
import org.junit.*;
import org.junit.rules.*;
import static org.junit.Assert.*;

/**
 * Classe de test des exigences E12, E13 et E14.
 * @author	Adrien André
 * @version	$Revision$
 */

public class CercleTest{
	// précision pour les comparaisons réelle
	public final static double EPSILON = 0.001;

	// Les points du sujet
	private Point A, B, C, D, E;

	// Les cercles du sujet
	private Cercle C1, C2, C3, C4;

	@Before public void setUp() {
		// Construire les points
		A = new Point(1, 2);
		B = new Point(2, 1);
		C = new Point(4, 1);
		D = new Point(8, 1);
		E = new Point(8, 4);

		// Construire les cercles
		C1 = new Cercle(A, C);
		C2 = new Cercle(A, B, Color.red);
		C3 = new Cercle(B, D);
		C4 = Cercle.creerCercle(C, E);
	}

	/** Vérifier si deux points ont mêmes coordonnées.
	  * @param p1 le premier point
	  * @param p2 le deuxième point
	  */
	static void memesCoordonnees(String message, Point p1, Point p2) {
		assertEquals(message + " (x)", p1.getX(), p2.getX(), EPSILON);
		assertEquals(message + " (y)", p1.getY(), p2.getY(), EPSILON);
	}
	
	@Test public void testerE12() {
		assertEquals(C1.getCouleur(), Color.blue);
		Point p = new Point (0,0);
		p.setX((A.getX() + C.getX())/2);
		p.setY((A.getY() + C.getY())/2);
		memesCoordonnees("E12 : Centre de C1 incorrect", C1.getCentre(), p);
		assertEquals(C.distance(A)/2, C1.getRayon(), EPSILON);

	}

	@Test public void testerE13() {
		assertEquals(C2.getCouleur(), Color.red);
		Point p = new Point ((A.getX()+B.getX())/2 , 1/2*(A.getY() + B.getY())/2);
		//memesCoordonnees("E13 : Centre de C2 incorrect", p, C1.getCentre());
		assertEquals(B.distance(A)/2, C2.getRayon(), EPSILON);
	}
	
	@Test public void TesterE14() {
		assertEquals(C.distance(E), C4.getRayon(), EPSILON);
		memesCoordonnees("E14", C4.getCentre(), C);
		assertEquals(C4.getCouleur(), Color.blue);
				
	}
}
