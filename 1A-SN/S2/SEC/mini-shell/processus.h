#ifndef _PROCESSUS
    #define _PROCESSUS

    typedef enum {ACTIF, SUSPENDU} Etat;
    typedef struct processus *liste_processus;

#endif

/* renvoie une nouvelle liste de processus*/
liste_processus nouvelle_liste();

/* affiche une liste des processus */
void afficher(liste_processus liste);

/* procécure permettant d'ajouter un processus à une liste */
int inserer_processus(int pid, int identifiant, Etat etat, liste_processus *liste);

/* supprimer un processus d'une liste */
int supprimer(int pid, liste_processus *liste);

/* suspendre un processus */
void susprendre(liste_processus *liste);

/* renvoie -1 si les processus de la liste sont actifs, 0 sinon */
int estActif(liste_processus *liste);

/* Obtenir le pid d'un processus à partir de son identifiantdans la liste de processus */
int id_to_pid(int identifiant, liste_processus *liste);
