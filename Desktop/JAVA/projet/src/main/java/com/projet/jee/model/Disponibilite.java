package com.projet.jee.model;

import java.time.LocalDate;
import java.time.LocalTime;

public class Disponibilite {
    private long id;
    private LocalDate jour;
    private LocalTime heureDebut;
    private LocalTime heureFin;
    private long formateurId;

    public Disponibilite() {}

    public Disponibilite(long id, LocalDate jour, LocalTime heureDebut, LocalTime heureFin, long formateurId) {
        this.id = id;
        this.jour = jour;
        this.heureDebut = heureDebut;
        this.heureFin = heureFin;
        this.formateurId = formateurId;
    }

    public long getId() { return id; }
    public void setId(long id) { this.id = id; }

    public LocalDate getJour() { return jour; }
    public void setJour(LocalDate jour) { this.jour = jour; }

    public LocalTime getHeureDebut() { return heureDebut; }
    public void setHeureDebut(LocalTime heureDebut) { this.heureDebut = heureDebut; }

    public LocalTime getHeureFin() { return heureFin; }
    public void setHeureFin(LocalTime heureFin) { this.heureFin = heureFin; }

    public long getFormateurId() { return formateurId; }
    public void setFormateurId(long formateurId) { this.formateurId = formateurId; }

    @Override
    public String toString() {
        return "Disponibilite [jour=" + jour + ", debut=" + heureDebut + ", fin=" + heureFin + "]";
    }
}