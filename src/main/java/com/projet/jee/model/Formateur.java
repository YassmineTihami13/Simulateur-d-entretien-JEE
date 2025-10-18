package com.projet.jee.model;

public class Formateur extends Utilisateur {

    public enum Specialite {
        INFORMATIQUE("Informatique"),
        MECATRONIQUE("Mécatronique"),
        INTELLIGENCE_ARTIFICIELLE("Intelligence Artificielle"),
        CYBERSECURITE("Cybersécurité"),
        GSTR("GSTR"),
        SUPPLY_CHAIN_MANAGEMENT("Supply Chain Management"),
        GENIE_CIVIL("Génie Civil");

        private final String displayName;

        Specialite(String displayName) {
            this.displayName = displayName;
        }

        public String getDisplayName() {
            return displayName;
        }

        public static Specialite fromString(String text) {
            for (Specialite s : Specialite.values()) {
                if (s.name().equalsIgnoreCase(text)) {
                    return s;
                }
            }
            throw new IllegalArgumentException("Aucune spécialité trouvée pour : " + text);
        }
    }

    private Specialite specialite;
    private int anneeExperience;
    private String certifications;
    private double tarifHoraire;
    private String description;

    public Formateur() {}

    public Formateur(long id, String nom, String prenom, String email, String motDePasse,
                     Specialite specialite, int anneeExperience, String certifications,
                     double tarifHoraire, String description) {
        super(id, nom, prenom, email, motDePasse, Role.FORMATEUR);
        this.specialite = specialite;
        this.anneeExperience = anneeExperience;
        this.certifications = certifications;
        this.tarifHoraire = tarifHoraire;
        this.description = description;
    }

    public Formateur(long id, String nom, String prenom, String email, String motDePasse,
                     String specialite, int anneeExperience, String certifications,
                     double tarifHoraire, String description) {
        this(id, nom, prenom, email, motDePasse,
                Specialite.fromString(specialite), anneeExperience, certifications,
                tarifHoraire, description);
    }

    public Specialite getSpecialite() {
        return specialite;
    }

    public void setSpecialite(Specialite specialite) {
        this.specialite = specialite;
    }

    public void setSpecialite(String specialite) {
        this.specialite = Specialite.fromString(specialite);
    }

    public String getSpecialiteDisplayName() {
        return specialite != null ? specialite.getDisplayName() : "";
    }

    public String getSpecialiteEnumName() {
        return specialite != null ? specialite.name() : "";
    }

    public int getAnneeExperience() {
        return anneeExperience;
    }

    public void setAnneeExperience(int anneeExperience) {
        this.anneeExperience = anneeExperience;
    }

    public String getCertifications() {
        return certifications;
    }

    public void setCertifications(String certifications) {
        this.certifications = certifications;
    }

    public String[] getCertificationFiles() {
        if (certifications == null || certifications.isEmpty()) {
            return new String[0];
        }
        return certifications.split(";");
    }

    public boolean hasCertifications() {
        return certifications != null && !certifications.isEmpty();
    }

    public double getTarifHoraire() {
        return tarifHoraire;
    }

    public void setTarifHoraire(double tarifHoraire) {
        this.tarifHoraire = tarifHoraire;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    @Override
    public String toString() {
        return super.toString() + " Formateur [specialite=" + getSpecialiteDisplayName() +
                ", anneeExperience=" + anneeExperience +
                ", tarifHoraire=" + tarifHoraire + " MAD]";
    }
}