package com.projet.jee.model;

public class Administrateur extends Utilisateur {
    public Administrateur() {}
    public Administrateur(long id, String nom, String prenom, String email, String motDePasse) {
        super(id, nom, prenom, email, motDePasse, Role.ADMIN);
    }
}
