package com.projet.jee.dao;

import com.projet.jee.models.Reservation;
import com.projet.jee.models.Reservation.Statut;
import java.sql.*;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;

public class ReservationadminDAO {

    /** Conversion SQL → Enum */
    private Statut statutFromDb(String dbValue) {
        if (dbValue == null) return Statut.EN_ATTENTE;
        switch (dbValue.toUpperCase()) {
            case "EN_ATTENTE": return Statut.EN_ATTENTE;
            case "CONFIRMEE":  return Statut.ACCEPTEE;
            case "REFUSEE":    return Statut.REFUSEE;
            default: return Statut.EN_ATTENTE;
        }
    }

    /** Conversion Enum → SQL */
    private String statutToDb(Statut s) {
        if (s == null) return "EN_ATTENTE";
        switch (s) {
            case EN_ATTENTE: return "EN_ATTENTE";
            case ACCEPTEE:   return "CONFIRMEE";
            case REFUSEE:    return "REFUSEE";
            default: return s.name();
        }
    }

    /**
     * 🔹 Récupère toutes les réservations (vue administrateur)
     */
    public List<Reservation> getAllReservations() {
        List<Reservation> reservations = new ArrayList<>();

        String query = "SELECT r.id, r.dateReservation, r.duree, r.prix, r.statut, " +
                "r.candidat_id, r.formateur_id, r.disponibilite_id, " +
                "uc.nom AS candidat_nom, uc.prenom AS candidat_prenom, " +
                "uf.nom AS formateur_nom, uf.prenom AS formateur_prenom " +
                "FROM reservation r " +
                "LEFT JOIN candidat c ON r.candidat_id = c.id " +
                "LEFT JOIN utilisateur uc ON c.id = uc.id " +
                "LEFT JOIN formateur f ON r.formateur_id = f.id " +
                "LEFT JOIN utilisateur uf ON f.id = uf.id " +
                "ORDER BY r.dateReservation DESC, r.id DESC";

        try (Connection con = ConnectionBD.getConnection();
             PreparedStatement ps = con.prepareStatement(query);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                Reservation r = new Reservation();

                r.setId(rs.getLong("id"));

                Date dateResa = rs.getDate("dateReservation");
                if (dateResa != null)
                    r.setDateReservation(dateResa.toLocalDate());

                r.setDuree(rs.getDouble("duree"));
                r.setPrix(rs.getDouble("prix"));
                r.setCandidatId(rs.getLong("candidat_id"));
                r.setFormateurId(rs.getLong("formateur_id"));
                r.setDisponibiliteId(rs.getLong("disponibilite_id"));

                String statutStr = rs.getString("statut");
                r.setStatut(statutFromDb(statutStr));

                reservations.add(r);
            }

            System.out.println("✅ Total réservations récupérées (admin) : " + reservations.size());

        } catch (SQLException e) {
            System.err.println("❌ Erreur SQL dans getAllReservations()");
            e.printStackTrace();
        }

        return reservations;
    }

    /**
     * 🔹 Supprime une réservation par son ID
     */
    public boolean deleteReservation(long id) {
        String query = "DELETE FROM reservation WHERE id = ?";

        try (Connection con = ConnectionBD.getConnection();
             PreparedStatement ps = con.prepareStatement(query)) {

            ps.setLong(1, id);
            int rows = ps.executeUpdate();

            if (rows > 0) {
                System.out.println("🗑️ Réservation #" + id + " supprimée avec succès");
                return true;
            } else {
                System.out.println("⚠️ Aucune réservation trouvée avec l’ID #" + id);
                return false;
            }

        } catch (SQLException e) {
            System.err.println("❌ Erreur SQL lors de la suppression de la réservation #" + id);
            e.printStackTrace();
            return false;
        }
    }

    /**
     * 🔹 Met à jour le statut d'une réservation
     */
    public boolean updateReservationStatus(long reservationId, Statut nouveauStatut) {
        String query = "UPDATE reservation SET statut = ? WHERE id = ?";
        try (Connection con = ConnectionBD.getConnection();
             PreparedStatement ps = con.prepareStatement(query)) {

            ps.setString(1, statutToDb(nouveauStatut));
            ps.setLong(2, reservationId);

            int rows = ps.executeUpdate();
            return rows > 0;

        } catch (SQLException e) {
            System.err.println("❌ Erreur SQL lors de la mise à jour du statut de la réservation #" + reservationId);
            e.printStackTrace();
            return false;
        }
    }
}
