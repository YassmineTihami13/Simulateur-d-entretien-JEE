package com.projet.jee.models;

import java.time.LocalDateTime;

public class Administrateur extends Utilisateur {

    // Constructeur par défaut
    public Administrateur() {
        super();
        setRole(Role.ADMIN);
    }

    // Constructeur sans dateCreation
    public Administrateur(long id, String nom, String prenom, String email, String motDePasse) {
        super(id, nom, prenom, email, motDePasse, Role.ADMIN);
    }

    // Constructeur avec dateCreation
    public Administrateur(long id, String nom, String prenom, String email, String motDePasse, LocalDateTime dateCreation) {
        super(id, nom, prenom, email, motDePasse, Role.ADMIN, dateCreation);
    }
}
