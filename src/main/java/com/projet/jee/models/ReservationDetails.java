package com.projet.jee.models;

import java.time.LocalDate;
import java.time.LocalTime;

public class ReservationDetails {
    private long id;
    private LocalDate dateReservation;
    private double duree;
    private double prix;
    private long candidatId;
    private long formateurId;
    private Long disponibiliteId;
    private Reservation.Statut statut;
    private String sessionLink;
    private boolean peutEtreEvaluee; 

    // Nouveaux champs pour la session
    private LocalDate dateSession;
    private LocalTime heureDebut;
    private LocalTime heureFin;

    // Nouveaux champs pour les détails
    private String candidatNom;
    private String candidatPrenom;
    private String candidatEmail;
    private String cv;

    public ReservationDetails() {
        this.statut = Reservation.Statut.EN_ATTENTE;
    }

    // Getters & Setters pour les champs de base
    public long getId() { return id; }
    public void setId(long id) { this.id = id; }

    public LocalDate getDateReservation() { return dateReservation; }
    public void setDateReservation(LocalDate dateReservation) { this.dateReservation = dateReservation; }

    public double getDuree() { return duree; }
    public void setDuree(double duree) { this.duree = duree; }

    public double getPrix() { return prix; }
    public void setPrix(double prix) { this.prix = prix; }

    public long getCandidatId() { return candidatId; }
    public void setCandidatId(long candidatId) { this.candidatId = candidatId; }

    public long getFormateurId() { return formateurId; }
    public void setFormateurId(long formateurId) { this.formateurId = formateurId; }

    public Long getDisponibiliteId() { return disponibiliteId; }
    public void setDisponibiliteId(Long disponibiliteId) { this.disponibiliteId = disponibiliteId; }

    public Reservation.Statut getStatut() { return statut; }
    public void setStatut(Reservation.Statut statut) { this.statut = statut; }

    // Getters & Setters pour les nouveaux champs de session
    public LocalDate getDateSession() { return dateSession; }
    public void setDateSession(LocalDate dateSession) { this.dateSession = dateSession; }

    public LocalTime getHeureDebut() { return heureDebut; }
    public void setHeureDebut(LocalTime heureDebut) { this.heureDebut = heureDebut; }

    public LocalTime getHeureFin() { return heureFin; }
    public void setHeureFin(LocalTime heureFin) { this.heureFin = heureFin; }

    // Getters & Setters pour les champs existants
    public String getSessionLink() { return sessionLink; }
    public void setSessionLink(String sessionLink) { this.sessionLink = sessionLink; }

    public String getCandidatNom() { return candidatNom; }
    public void setCandidatNom(String candidatNom) { this.candidatNom = candidatNom; }

    public String getCandidatPrenom() { return candidatPrenom; }
    public void setCandidatPrenom(String candidatPrenom) { this.candidatPrenom = candidatPrenom; }

    public String getCandidatEmail() { return candidatEmail; }
    public void setCandidatEmail(String candidatEmail) { this.candidatEmail = candidatEmail; }

    public String getCv() { return cv; }
    public void setCv(String cv) { this.cv = cv; }
    
    public boolean isPeutEtreEvaluee() { return peutEtreEvaluee; }
    public void setPeutEtreEvaluee(boolean peutEtreEvaluee) { this.peutEtreEvaluee = peutEtreEvaluee; }

    // Méthodes utilitaires
    public String getNomCompletCandidat() {
        return (candidatPrenom != null ? candidatPrenom : "") + " " +
                (candidatNom != null ? candidatNom : "");
    }

    public String getCvFileName() {
        if (cv == null || cv.isEmpty()) {
            return "Aucun CV";
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

    public String getStatutDisplayName() {
        return statut != null ? statut.getDisplayName() : "Inconnu";
    }
    
    public String getCvDownloadUrl() {
        if (cv == null || cv.isEmpty()) {
            return null;
        }
        try {
            return "/view-cv?file=" + java.net.URLEncoder.encode(cv, "UTF-8");
        } catch (Exception e) {
            return "/view-cv?file=" + cv;
        }
    }

    @Override
    public String toString() {
        return "ReservationDetails [id=" + id +
                ", dateReservation=" + dateReservation +
                ", dateSession=" + dateSession +
                ", candidat=" + getNomCompletCandidat() +
                ", statut=" + getStatutDisplayName() + "]";
    }
}