package com.projet.jee.model;

public class Candidat extends Utilisateur {
    private String domaineProfessionnel;
    private String cv;

    // SUPPRIMÉ: statut et estVerifie car ils sont déjà dans Utilisateur

    public Candidat() {
        super();
    }

    public Candidat(long id, String nom, String prenom, String email, String motDePasse,
                    String domaineProfessionnel, String cv) {
        super(id, nom, prenom, email, motDePasse, Role.CANDIDAT);
        this.domaineProfessionnel = domaineProfessionnel;
        this.cv = cv;
    }

    public String getDomaineProfessionnel() {
        return domaineProfessionnel;
    }

    public void setDomaineProfessionnel(String domaineProfessionnel) {
        this.domaineProfessionnel = domaineProfessionnel;
    }

    public String getCv() {
        return cv;
    }

    public void setCv(String cv) {
        this.cv = cv;
    }

    // Méthode pour obtenir le nom du fichier CV (sans le préfixe UUID)
    public String getCvFileName() {
        if (cv == null || cv.isEmpty()) {
            return null;
        }
        int underscoreIndex = cv.indexOf('_');
        if (underscoreIndex != -1 && underscoreIndex < cv.length() - 1) {
            return cv.substring(underscoreIndex + 1);
        }
        return cv;
    }

    // Méthode pour vérifier si un CV est disponible
    public boolean hasCv() {
        return cv != null && !cv.trim().isEmpty();
    }

    @Override
    public String toString() {
        return super.toString() + " Candidat [domaineProfessionnel=" + domaineProfessionnel + "]";
    }
}