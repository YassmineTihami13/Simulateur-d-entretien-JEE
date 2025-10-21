package com.projet.jee.dao;

import com.projet.jee.model.Reservation;
import com.projet.jee.model.Reservation.Statut;

import java.sql.*;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;

public class ReservationDAO {

    private Statut statutFromDb(String dbValue) {
        if (dbValue == null) return null;
        switch (dbValue.toUpperCase()) {
            case "EN_ATTENTE": return Statut.EN_ATTENTE;
            case "CONFIRMEE":  return Statut.ACCEPTEE;   // DB: CONFIRMEE -> our enum ACCEPTEE
            case "REFUSEE":    return Statut.REFUSEE;
            // si tu as ANNULEE en BDD et que tu veux le gérer, ajoute un case ici
            default: return null;
        }
    }

    private String statutToDb(Statut s) {
        if (s == null) return null;
        switch (s) {
            case EN_ATTENTE: return "EN_ATTENTE";
            case ACCEPTEE:   return "CONFIRMEE"; // mappe ACCEPTEE -> CONFIRMEE en base
            case REFUSEE:    return "REFUSEE";
            default: return s.name();
        }
    }

    /**
     * Récupère toutes les réservations liées à un formateur (ordre décroissant)
     */
    public List<Reservation> getReservationsByFormateurId(long formateurId) throws SQLException {
        List<Reservation> list = new ArrayList<>();
        String sql = "SELECT id, dateReservation, duree, prix, candidat_id, formateur_id, statut " +
                     "FROM reservation WHERE formateur_id = ? ORDER BY dateReservation DESC, id DESC";
        try (Connection conn = ConnectionBD.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setLong(1, formateurId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Reservation r = new Reservation();
                    r.setId(rs.getLong("id"));
                    Date d = rs.getDate("dateReservation");
                    if (d != null) r.setDateReservation(d.toLocalDate());
                    r.setDuree(rs.getDouble("duree"));
                    r.setPrix(rs.getDouble("prix"));
                    r.setCandidatId(rs.getLong("candidat_id"));
                    r.setFormateurId(rs.getLong("formateur_id"));
                    // pas de disponibilite_id dans ta structure actuelle -> laisse null
                    String statutStr = rs.getString("statut");
                    if (statutStr != null) {
                        Statut st = statutFromDb(statutStr);
                        r.setStatut(st != null ? st : Statut.EN_ATTENTE);
                    }
                    list.add(r);
                }
            }
        }
        return list;
    }

    /**
     * Met à jour le statut d'une réservation.
     * Si tu veux stocker la raison de rejet il faut ajouter la colonne correspondante en base.
     */
    public boolean updateReservationStatus(long reservationId, Statut nouveauStatut, String rejectionReason) throws SQLException {
        // Ici mise à jour uniquement du statut (colonne 'statut'). 
        // Si tu as ajouté 'rejection_reason' en base, adapte la requête.
        String sql = "UPDATE reservation SET statut = ? WHERE id = ?";
        try (Connection conn = ConnectionBD.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, statutToDb(nouveauStatut));
            ps.setLong(2, reservationId);
            return ps.executeUpdate() > 0;
        }
    }

    /**
     * Récupère l'email et le nom du candidat pour une réservation donnée (join utilisateur/reservation).
     * Retourne un tableau [email, prenom + ' ' + nom] ou null si introuvable.
     */
    public String[] getCandidatContactByReservationId(long reservationId) throws SQLException {
        String sql = "SELECT u.email, u.prenom, u.nom FROM utilisateur u " +
                     "INNER JOIN reservation r ON u.id = r.candidat_id WHERE r.id = ?";
        try (Connection conn = ConnectionBD.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setLong(1, reservationId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    String email = rs.getString("email");
                    String prenom = rs.getString("prenom");
                    String nom = rs.getString("nom");
                    return new String[]{ email, prenom + " " + nom };
                }
            }
        }
        return null;
    }

    /**
     * Récupère les détails d'une réservation (pour inclure dans l'email)
     */
    public Reservation getReservationById(long id) throws SQLException {
        String sql = "SELECT id, dateReservation, duree, prix, candidat_id, formateur_id, statut " +
                     "FROM reservation WHERE id = ?";
        try (Connection conn = ConnectionBD.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setLong(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Reservation r = new Reservation();
                    r.setId(rs.getLong("id"));
                    Date d = rs.getDate("dateReservation");
                    if (d != null) r.setDateReservation(d.toLocalDate());
                    r.setDuree(rs.getDouble("duree"));
                    r.setPrix(rs.getDouble("prix"));
                    r.setCandidatId(rs.getLong("candidat_id"));
                    r.setFormateurId(rs.getLong("formateur_id"));
                    String statutStr = rs.getString("statut");
                    if (statutStr != null) r.setStatut(statutFromDb(statutStr));
                    return r;
                }
            }
        }
        return null;
    }
}
