/* Adrien André - groupe F*/
/* Mini-projet shell*/
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <signal.h>
#include <sys/wait.h>
#include "readcmd.h"
#include "processus.h"

/*****VARIABLES GLOBALES*****/
/* Entier qui permet de stocker le pid reel */
int pid;
/* Entier qui permet de stocker l'identifiant */
int identifiant;
/* Commande entrée par l'utilisateur */
struct cmdline *cmd;
/* Status */
int status;
/* Liste des processus */
liste_processus listeProcessus;

/*********** HANDLER ***********/

/* Traite le signal SIGTSTP */
void handler_SIGTSTP(int sig) {
    kill(pid, SIGSTOP);
    identifiant++;
    inserer_processus(pid, identifiant, SUSPENDU, &listeProcessus);
}

/* Traite le signal SIGINT */
void handler_SIGINT(int sig) {
    kill(sig, SIGINT);
}

/*****PROGRAMME PRINCIPAL*****/
int main(){
    /*** initialisation de la liste processus ***/
    listeProcessus= nouvelle_liste();
    identifiant= 0;

    /* Modifications des fonctions des signaux */
    signal(SIGTSTP, handler_SIGTSTP);
    signal(SIGINT, handler_SIGINT);

    /****** Boucle infinie ******/
    do{
        printf("> ");
        cmd = readcmd();

        /*****COMMANDES INTERNES*****/

        /* Commande exit (Q4) */
        if (!strcmp(cmd->seq[0][0], "exit")==0) {
            exit(1);
        }
        /* Commande cd (Q4) */
        else if (!strcmp(cmd->seq[0][0], "cd")==0) {
            /* retour au répertoire principal */
            if (cmd->seq[0][1] == NULL) {
	            chdir(getenv("HOME"));
            }
            else {
	            chdir(cmd->seq[0][1]);
            }
        }
        /* Commande jobs (Q6) */
	    else if (!strcmp(cmd->seq[0][0], "jobs") && cmd->seq[0][1] == NULL) {
		    afficher(listeProcessus);
        }
	    /* Commande stop (Q6) */
	    else if (!strcmp(cmd->seq[0][0], "stop")) {
		    kill(atoi(cmd->seq[0][1]), SIGSTOP);
        }

        /* Commande cont */
	    else if (!strcmp(cmd->seq[0][0], "cont")) {
		    int pid_processus;
		    pid_processus = id_to_pid(pid_processus, &listeProcessus);
		    kill(pid_processus, SIGCONT);
		    supprimer(pid_processus, &listeProcessus);
        }
        /* Execution de la commande (Q1)*/
        else {
            pid = fork();
            switch (pid)
            {
                /*Excution du fils*/
                case 0:
                    execvp(cmd->seq[0][0], cmd->seq[0]);
                    exit(1);
                /*Erreur lors de la création du fils (erreur du fork)*/
                case -1:
                    printf("Erreur lors de la création du fils.\n");
                    exit(2);
                /*On execute le père par défault*/
                default:
                    /* Si la commande est en avant plan, on attend que le fils ait fini de l'exécuter */
		            if (cmd->backgrounded == NULL) {
			            waitpid(pid, &status, WUNTRACED);
			            if (WIFEXITED(status)) {
			                printf("fils termine normalement: status = %d\n", WEXITSTATUS(status));
                        }
                    }
                    break;
            }
        }
    } while (1);
     /* boucle infinie */
    return 0;
}