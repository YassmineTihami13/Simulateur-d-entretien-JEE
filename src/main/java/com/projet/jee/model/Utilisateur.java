package com.projet.jee.model;

import java.time.LocalDateTime;

public class Utilisateur {
    private long id;
    private String nom;
    private String prenom;
    private String email;
    private String motDePasse;
    private Role role;
    private LocalDateTime dateCreation;

    public enum Role {
        ADMIN, FORMATEUR, CANDIDAT
    }

    // Constructeur par défaut
    public Utilisateur() {
        this.dateCreation = LocalDateTime.now();
    }

    // Constructeur complet
    public Utilisateur(long id, String nom, String prenom, String email, String motDePasse, Role role, LocalDateTime dateCreation) {
        this.id = id;
        this.nom = nom;
        this.prenom = prenom;
        this.email = email;
        this.motDePasse = motDePasse;
        this.role = role;
        this.dateCreation = dateCreation != null ? dateCreation : LocalDateTime.now();
    }

    // Constructeur sans date (utilise la date actuelle)
    public Utilisateur(long id, String nom, String prenom, String email, String motDePasse, Role role) {
        this(id, nom, prenom, email, motDePasse, role, LocalDateTime.now());
    }

    // Getters et Setters
    public long getId() { return id; }
    public void setId(long id) { this.id = id; }
    
    public String getNom() { return nom; }
    public void setNom(String nom) { this.nom = nom; }
    
    public String getPrenom() { return prenom; }
    public void setPrenom(String prenom) { this.prenom = prenom; }
    
    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }
    
    public String getMotDePasse() { return motDePasse; }
    public void setMotDePasse(String motDePasse) { this.motDePasse = motDePasse; }
    
    public Role getRole() { return role; }
    public void setRole(Role role) { this.role = role; }
    
    public LocalDateTime getDateCreation() { return dateCreation; }
    public void setDateCreation(LocalDateTime dateCreation) { this.dateCreation = dateCreation; }

    @Override
    public String toString() {
        return "Utilisateur [id=" + id + ", nom=" + nom + ", prenom=" + prenom + ", email=" + email + ", role=" + role + ", dateCreation=" + dateCreation + "]";
    }
}