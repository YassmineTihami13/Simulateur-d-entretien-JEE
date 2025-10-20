package com.projet.jee.models;

public class Administrateur extends Utilisateur {

    public Administrateur() {
        super();
        setRole(Role.ADMIN);
    }

    public Administrateur(long id, String nom, String prenom, String email, String motDePasse) {
        super(id, nom, prenom, email, motDePasse, Role.ADMIN);
    }


}