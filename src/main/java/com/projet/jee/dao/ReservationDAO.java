package com.projet.jee.dao;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import com.projet.jee.models.Reservation;

public class ReservationDAO {

    public List<Reservation> getAllReservations() {
        List<Reservation> reservations = new ArrayList<>();

        String query = "SELECT r.id, r.dateReservation, r.duree, r.prix, r.statut, " +
                "uc.nom AS candidat_nom, uc.prenom AS candidat_prenom, " +
                "uf.nom AS formateur_nom, uf.prenom AS formateur_prenom " +
                "FROM reservation r " +
                "LEFT JOIN candidat c ON r.candidat_id = c.id " +
                "LEFT JOIN utilisateur uc ON c.id = uc.id " +
                "LEFT JOIN formateur f ON r.formateur_id = f.id " +
                "LEFT JOIN utilisateur uf ON f.id = uf.id " +
                "ORDER BY r.dateReservation DESC";

        System.out.println("🔍 Exécution de la requête SQL...");

        try (Connection con = ConnectionBD.getConnection();
             PreparedStatement ps = con.prepareStatement(query);
             ResultSet rs = ps.executeQuery()) {

            int count = 0;
            while (rs.next()) {
                Reservation r = new Reservation();
                r.setId(rs.getLong("id"));
                r.setDateReservation(rs.getDate("dateReservation"));
                r.setDuree(rs.getDouble("duree"));
                r.setPrix(rs.getDouble("prix"));
                r.setStatut(rs.getString("statut"));

                String candidatNom = rs.getString("candidat_nom");
                String candidatPrenom = rs.getString("candidat_prenom");
                r.setCandidatNom((candidatNom != null ? candidatNom : "Inconnu") + " " +
                        (candidatPrenom != null ? candidatPrenom : ""));

                String formateurNom = rs.getString("formateur_nom");
                String formateurPrenom = rs.getString("formateur_prenom");
                r.setFormateurNom((formateurNom != null ? formateurNom : "Inconnu") + " " +
                        (formateurPrenom != null ? formateurPrenom : ""));

                reservations.add(r);
                count++;

                System.out.println("✅ Réservation #" + r.getId() + ": " + r.getCandidatNom() + " -> " + r.getFormateurNom());
            }

            System.out.println("📊 Total réservations récupérées: " + count);

        } catch (SQLException e) {
            System.err.println("❌ Erreur SQL dans getAllReservations:");
            e.printStackTrace();
        }

        return reservations;
    }

    /**
     * Supprime une réservation par son ID
     * @param id L'identifiant de la réservation à supprimer
     * @return true si la suppression a réussi, false sinon
     */
    public boolean deleteReservation(Long id) {
        String query = "DELETE FROM reservation WHERE id = ?";

        System.out.println("🗑️ Tentative de suppression de la réservation #" + id);

        try (Connection con = ConnectionBD.getConnection();
             PreparedStatement ps = con.prepareStatement(query)) {

            ps.setLong(1, id);
            int rowsAffected = ps.executeUpdate();

            if (rowsAffected > 0) {
                System.out.println("✅ Réservation #" + id + " supprimée avec succès");
                return true;
            } else {
                System.out.println("⚠️ Aucune réservation trouvée avec l'ID #" + id);
                return false;
            }

        } catch (SQLException e) {
            System.err.println("❌ Erreur SQL lors de la suppression de la réservation #" + id);
            e.printStackTrace();
            return false;
        }
    }
}
