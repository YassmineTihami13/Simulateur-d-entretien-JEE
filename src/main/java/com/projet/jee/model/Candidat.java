package com.projet.jee.model;

public class Candidat extends Utilisateur {

    public enum DomaineProfessionnel {
        INFORMATIQUE("Informatique"),
        MECATRONIQUE("Mécatronique"),
        INTELLIGENCE_ARTIFICIELLE("Intelligence Artificielle"),
        CYBERSECURITE("Cybersécurité"),
        GSTR("GSTR"),
        SUPPLY_CHAIN_MANAGEMENT("Supply Chain Management"),
        GENIE_CIVIL("Génie Civil");

        private final String displayName;

        DomaineProfessionnel(String displayName) {
            this.displayName = displayName;
        }

        public String getDisplayName() {
            return displayName;
        }

        public static DomaineProfessionnel fromString(String text) {
            for (DomaineProfessionnel d : DomaineProfessionnel.values()) {
                if (d.name().equalsIgnoreCase(text)) {
                    return d;
                }
            }
            throw new IllegalArgumentException("Aucun domaine trouvé pour : " + text);
        }
    }

    private DomaineProfessionnel domaineProfessionnel;
    private String cv;

    public Candidat() {
        super();
    }

    public Candidat(long id, String nom, String prenom, String email, String motDePasse,
                    DomaineProfessionnel domaineProfessionnel, String cv) {
        super(id, nom, prenom, email, motDePasse, Role.CANDIDAT);
        this.domaineProfessionnel = domaineProfessionnel;
        this.cv = cv;
    }

    public Candidat(long id, String nom, String prenom, String email, String motDePasse,
                    String domaineProfessionnel, String cv) {
        super(id, nom, prenom, email, motDePasse, Role.CANDIDAT);
        this.domaineProfessionnel = DomaineProfessionnel.fromString(domaineProfessionnel);
        this.cv = cv;
    }


    public DomaineProfessionnel getDomaineProfessionnel() {
        return domaineProfessionnel;
    }

    public void setDomaineProfessionnel(DomaineProfessionnel domaineProfessionnel) {
        this.domaineProfessionnel = domaineProfessionnel;
    }

    public void setDomaineProfessionnel(String domaineProfessionnel) {
        this.domaineProfessionnel = DomaineProfessionnel.fromString(domaineProfessionnel);
    }

    public String getDomaineProfessionnelDisplayName() {
        return domaineProfessionnel != null ? domaineProfessionnel.getDisplayName() : "";
    }

    public String getDomaineProfessionnelEnumName() {
        return domaineProfessionnel != null ? domaineProfessionnel.name() : "";
    }

    public String getCv() {
        return cv;
    }

    public void setCv(String cv) {
        this.cv = cv;
    }


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

    public boolean hasCv() {
        return cv != null && !cv.trim().isEmpty();
    }

    @Override
    public String toString() {
        return super.toString() + " Candidat [domaineProfessionnel=" + getDomaineProfessionnelDisplayName() + 
               ", cv=" + cv + "]";
    }
}
