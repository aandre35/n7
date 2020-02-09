dans le traitant
{ 
    alarm(1);
    afficher();
    dernier = discussion[0].numero
}

dans le main:
{
    alarm(1);
    signal(SIG_alarm, traitant)

    fd1 = open("discussion", O_CREAT | O_RDWR);
    lseek(--------------);
    write(qq);

    base1 = mmap(0, taille, PROT_READ | PROT_WRITE , MAP_SHARE, fdisc, 0)
    fd2 = open("f2", O_CREAT | O_TRUNC | O_RDWR, S_IRUSR | S_IWUSR);
    for(inti=0, i<NB_ligne, i++) {
        bzero(discussion[i].texte);
        bzero(discussion[i].auteur);
    }
    while(!"au revoir") {
        mlu = read(0, buf, TAILLE_TEXTE);
        memcpy(&direction[1], )
    }
}
