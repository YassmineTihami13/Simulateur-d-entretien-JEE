package com.projet.jee.model;

public class Formateur extends Utilisateur {
    private String specialite;
    private int anneeExperience;
    private String certifications;
    private double tarifHoraire;
    private String description;

    public Formateur() {}

    public Formateur(long id, String nom, String prenom, String email, String motDePasse,
                     String specialite, int anneeExperience, String certifications,
                     double tarifHoraire, String description) {
        super(id, nom, prenom, email, motDePasse, Role.FORMATEUR);
        this.specialite = specialite;
        this.anneeExperience = anneeExperience;
        this.certifications = certifications;
        this.tarifHoraire = tarifHoraire;
        this.description = description;
    }

    public String getSpecialite() { return specialite; }
    public void setSpecialite(String specialite) { this.specialite = specialite; }
    public int getAnneeExperience() { return anneeExperience; }
    public void setAnneeExperience(int anneeExperience) { this.anneeExperience = anneeExperience; }
    public String getCertifications() { return certifications; }
    public void setCertifications(String certifications) { this.certifications = certifications; }
    public double getTarifHoraire() { return tarifHoraire; }
    public void setTarifHoraire(double tarifHoraire) { this.tarifHoraire = tarifHoraire; }
    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }

    @Override
    public String toString() {
        return super.toString() + " Formateur [specialite=" + specialite + ", tarifHoraire=" + tarifHoraire + "]";
    }
}
