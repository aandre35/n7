#include <stdlib.h>
#include <stdio.h>
#include "processus.h"

struct processus {
    int pid;
    int identifiant;
    Etat etat;
    liste_processus suivant;
};

liste_processus nouvelle_liste() {
    return NULL;
}

void afficher(liste_processus liste) {
	while (liste!=NULL) {
		if (liste-> etat==ACTIF) {
			printf ("%d Programme ACTIF %d\n",liste->identifiant, liste -> pid);
		} else {
		   	printf ("%d Programme SUSPENDU %d\n",liste->identifiant, liste -> pid);
		}
		liste = liste->suivant;
	}
}

int inserer_processus(int pid, int identifiant, Etat etat, liste_processus *liste) {
    liste_processus nouvelle_liste = (liste_processus)malloc(sizeof(struct processus));
    if (nouvelle_liste == NULL) {
        return 1;
    }
    nouvelle_liste->pid = pid;
    nouvelle_liste->identifiant = identifiant;
    nouvelle_liste->etat = etat;
    nouvelle_liste->suivant = *liste;
    *liste= nouvelle_liste;
    return 0;
}

int supprimer(int pid, liste_processus *liste) {
    liste_processus souhaitee, actuelle;
    if (*liste == NULL) {
        printf("liste vide\n");
        return 1;
    }
    if ((*liste)->pid == pid) {
        (*liste) = (*liste)->suivant;
        return 0;
    }
    souhaitee = *liste;
    actuelle = *liste;
    while ((souhaitee!=NULL) && (souhaitee->pid!=pid)) {
        actuelle = souhaitee;
        souhaitee = actuelle->suivant;
    }
    if (souhaitee!=NULL) {
        actuelle->suivant = souhaitee->suivant;
        free(souhaitee);
    } else {
        return 1;
    }
    return 0;
}

void suspendre(liste_processus *liste) {
    liste_processus l = *liste;
    while (l !=NULL && l->etat != ACTIF) {
        l= l->suivant;
    }
    if (l==NULL){
        printf("Il n'y a pas de processus actif \n");
    } else {
        l->etat= SUSPENDU;
    }
}

int estActif(liste_processus *liste) {
    liste_processus l = *liste;
    while (l !=NULL && l->etat != ACTIF) {
        l= l->suivant;
    }
    if (l==NULL){
        return 1;
    } else {
        return 0;
    }
}

int id_to_pid(int identifiant, liste_processus *liste){
    liste_processus processus_actuel;
    if (*liste == NULL){
        printf("liste vide\n");
        return 1;
    }
    if ((*liste)->identifiant==identifiant) {
        return (*liste)->identifiant;
    }
    processus_actuel = *liste;
    while ((processus_actuel!=NULL) && (processus_actuel->identifiant == identifiant)) {
        processus_actuel = processus_actuel->suivant;
    }
    if (processus_actuel !=NULL) {
        return processus_actuel->pid;
    } else {
        return 1;
    }
    return 0;
}