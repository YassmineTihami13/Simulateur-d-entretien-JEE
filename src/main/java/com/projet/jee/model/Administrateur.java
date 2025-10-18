package com.projet.jee.model;

import java.time.LocalDateTime;

public class Administrateur extends Utilisateur {
    
    public Administrateur() {
        super();
        setRole(Role.ADMIN);
    }
    
    public Administrateur(long id, String nom, String prenom, String email, String motDePasse) {
        super(id, nom, prenom, email, motDePasse, Role.ADMIN);
    }
    
    public Administrateur(long id, String nom, String prenom, String email, String motDePasse, LocalDateTime dateCreation) {
        super(id, nom, prenom, email, motDePasse, Role.ADMIN, dateCreation);
    }
}