package com.projet.jee.models;

public class Utilisateur {
    private long id;
    private String nom;
    private String prenom;
    private String email;
    private String motDePasse;
    private Role role;
    private boolean statut;        // Actif/Inactif (1/0)
    private boolean estVerifie;    // Vérifié/Non vérifié (1/0)

    public enum Role {
        ADMIN, FORMATEUR, CANDIDAT
    }

    public Utilisateur() {}

    public Utilisateur(long id, String nom, String prenom, String email, String motDePasse, Role role) {
        this.id = id;
        this.nom = nom;
        this.prenom = prenom;
        this.email = email;
        this.motDePasse = motDePasse;
        this.role = role;
        this.statut = true;        // Actif par défaut
        this.estVerifie = false;   // Non vérifié par défaut
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

    public boolean getStatut() { return statut; }
    public void setStatut(boolean statut) { this.statut = statut; }

    public boolean isEstVerifie() { return estVerifie; }
    public void setEstVerifie(boolean estVerifie) { this.estVerifie = estVerifie; }

    @Override
    public String toString() {
        return "Utilisateur [id=" + id + ", nom=" + nom + ", prenom=" + prenom +
                ", email=" + email + ", role=" + role + ", statut=" + statut +
                ", estVerifie=" + estVerifie + "]";
    }
}