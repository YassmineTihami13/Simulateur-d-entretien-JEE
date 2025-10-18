package com.projet.jee.model;

public class Candidat extends Utilisateur {
    private String domaineProfessionnel;
    private String cv;

    public Candidat() {}

    public Candidat(long id, String nom, String prenom, String email, String motDePasse, String domaineProfessionnel, String cv) {
        super(id, nom, prenom, email, motDePasse, Role.CANDIDAT);
        this.domaineProfessionnel = domaineProfessionnel;
        this.cv = cv;
    }

    public String getDomaineProfessionnel() { return domaineProfessionnel; }
    public void setDomaineProfessionnel(String domaineProfessionnel) { this.domaineProfessionnel = domaineProfessionnel; }
    public String getCv() { return cv; }
    public void setCv(String cv) { this.cv = cv; }

    @Override
    public String toString() {
        return super.toString() + " Candidat [domaineProfessionnel=" + domaineProfessionnel + "]";
    }
}