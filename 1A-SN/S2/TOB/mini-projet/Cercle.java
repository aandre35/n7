import java.awt.Color;

/** Cercle modélise un cercle géométrique dans un plan équipé d'un
 * repère cartésien.  Un cercle peut être affiché et translaté.
 * 
 *
 * @author  Adrien ANDRÉ <adrien.andre@etu.enseeiht.fr>
 */

public class Cercle implements Mesurable2D{
	private double rayon;
	private Point centre;
	private Color couleur;
	

	public final static double PI = Math.PI;
	
	
	/** Construire un cercle à partir de son centre et de son rayon.
	 * 
	 * @param vrayon rayon
	 * @param vc centre
	 */
	public Cercle(Point vcentre, double vrayon){
		assert vcentre != null;
		assert vrayon > 0;
		Point nouveauCentre = new Point(vcentre.getX(), vcentre.getY());
		this.rayon = vrayon;
		this.centre = nouveauCentre;
		this.couleur = Color.blue;
	}

	/** Construire un cercle à partir de deux points diamétralements opposés.
	 * 
	 * @param Point A
	 * @param Point B
	 */
	public Cercle (Point A, Point B){
		assert A != null;
		assert B != null;
		assert A.distance(B) != 0;
		this.rayon = A.distance(B)/2;
		this.centre = new Point( (A.getX() + B.getX())/2 , (A.getY() + B.getY())/2 );
		this.couleur = Color.blue;
	}
	
	/** Construire un cercle à partir de deux points diamétralements opposés et de sa couleur.
	 * 
	 * @param A point 
	 * @param B point
	 * @param couleurCercle
	 */
	public Cercle (Point A, Point B, Color couleurCercle){
		assert A != null;
		assert B != null;
		assert A.distance(B) != 0;
		assert couleurCercle != null;
		this.rayon = A.distance(B)/2;
		this.centre = new Point( (A.getX() + B.getX())/2 , (A.getY() + B.getY())/2 );
		this.couleur = couleurCercle;
	}
	

	/** Translater un cercle
	 * 
	 * @param dx, translation selon x
	 * @param dy, translation selon y
	 */
	
	public void translater(double dx, double dy) {
		this.centre.translater(dx, dy);
	}
	
	/** Obtenir le centre d'un cercle
	 * 
	 * @return le centre d'un cercle
	 */
	public Point getCentre(){
		Point nouveauCentre = new Point (this.centre.getX(), this.centre.getY());
		return nouveauCentre;
	}
	
	/** Obtenir le rayon d'un cercle
	 * 
	 * @return le rayon du cercle
	 */
	public double getRayon(){
		return this.rayon;
	}
	
	/** Obtenir le diametre d'un cercle
	 * 
	 * @return diametre du cercle
	 */
	public double getDiametre() {
		return 2*this.rayon;
	}
	
	/** Savoir si un point à l'intérieur du cercle
	 * 
	 * @param A, point du cercle
	 * @return booléen
	 */
	public boolean contient(Point A) {
		assert A!= null;
		return (this.centre.distance(A) <= this.rayon);
	}
	
	public double perimetre() {
		return 2*PI*this.rayon;
	}
	
	public double aire(){
		return PI*(this.rayon)*(this.rayon);
	}
	
	/** Obtenir la couleur du cercle
	 * @return couleur, couleur du cercle
	 */
	public Color getCouleur(){
		return this.couleur;
	}
	
	/** Changer la couleur du point.
	  * @param nouvelleCouleur nouvelle couleur
	  */
	public void setCouleur(Color nouvelleCouleur) {
		assert nouvelleCouleur != null;
		this.couleur = nouvelleCouleur;
	}
	
	/** Creer un cercle à partir de son centre et d'un point siitué sur sa circonférence
	 * @param center, centre du cercle
	 * @param pointcirconference, point situé sur la circonference du cercle
	 * @return Cercle, le cercle crée
	 */
	public static Cercle creerCercle(Point center, Point pointCirconference){
		assert center != null;
		assert pointCirconference != null;
		assert pointCirconference != center;
		return new Cercle(center, center.distance(pointCirconference));
	}

	
	/** Afficher les paramètres d'un cercle sous la forme "Cr@(a,b)"
	 * 
	 * @return string, affichage du cercle 
	 */
	public String toString(){
		return "C" + this.rayon + "@" + this.centre.toString();
	}

	/** Changer le rayon d'un cercle
	 * @param newrayon
	 */
	public void setRayon(double newrayon) {
		assert newrayon > 0;
		this.rayon = newrayon;
	}
	
	/** Changer le diamétre d'un cercle
	 * @param newdiametre
	 */
	public void setDiametre(double newdiametre) {
		assert newdiametre > 0;
		this.rayon = newdiametre/2;
	}

}
