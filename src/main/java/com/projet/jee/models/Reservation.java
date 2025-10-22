package com.projet.jee.models;

import java.time.LocalDate;

public class Reservation {

    public enum Statut {
        EN_ATTENTE("En attente"),
        ACCEPTEE("Acceptée"),
        REFUSEE("Refusée");

        private final String displayName;

        Statut(String displayName) {
            this.displayName = displayName;
        }

        public String getDisplayName() {
            return displayName;
        }
    }
    private String candidatNom;
    private String formateurNom;
    private long id;
    private LocalDate dateReservation;
    private double duree;
    private double prix;
    private long candidatId;
    private long formateurId;
    private Long disponibiliteId;
    private Statut statut;

    public Reservation() {
        this.statut = Statut.EN_ATTENTE;
    }

    public Reservation(long id, LocalDate dateReservation, double duree, double prix,
                       long candidatId, long formateurId, Long disponibiliteId, Statut statut) {
        this.id = id;
        this.dateReservation = dateReservation;
        this.duree = duree;
        this.prix = prix;
        this.candidatId = candidatId;
        this.formateurId = formateurId;
        this.disponibiliteId = disponibiliteId;
        this.statut = statut != null ? statut : Statut.EN_ATTENTE;
    }

    // Getters & Setters
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

    public Statut getStatut() { return statut; }
    public void setStatut(Statut statut) { this.statut = statut; }

    public String getStatutDisplayName() {
        return statut != null ? statut.getDisplayName() : "Inconnu";
    }

    public String getCandidatNom() { return candidatNom; }
    public void setCandidatNom(String candidatNom) { this.candidatNom = candidatNom; }

    public String getFormateurNom() { return formateurNom; }
    public void setFormateurNom(String formateurNom) { this.formateurNom = formateurNom; }
    @Override
    public String toString() {
        return "Reservation [id=" + id + ", date=" + dateReservation +
                ", statut=" + getStatutDisplayName() + "]";
    }
}