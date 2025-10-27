package com.projet.jee.dao;

import java.sql.*;
import java.util.*;
import com.projet.jee.models.*;
 

public class CandidatDashboardDAO {

    /**
     * 🔹 Retourne le nombre total de séances réservées par le candidat
     */
    public int getNombreReservations(Long candidatId) {
        String sql = "SELECT COUNT(*) FROM reservation WHERE candidat_id = ?";
        try (Connection con = ConnectionBD.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setLong(1, candidatId);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) return rs.getInt(1);

        } catch (SQLException e) {
            System.err.println("❌ Erreur SQL dans getNombreReservations");
            e.printStackTrace();
        }
        return 0;
    }

    /**
     * 🔹 Retourne la prochaine séance programmée pour le candidat
     */
    public Reservation getProchaineSeance(Long candidatId) {
        String sql = "SELECT * FROM reservation " +
                     "WHERE candidat_id = ? AND dateReservation >= CURDATE() " +
                     "ORDER BY dateReservation ASC LIMIT 1";

        try (Connection con = ConnectionBD.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setLong(1, candidatId);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                Reservation r = new Reservation();
                r.setId(rs.getLong("id"));
                r.setDateReservation(rs.getDate("dateReservation").toLocalDate());

                r.setDuree(rs.getDouble("duree"));
                r.setPrix(rs.getDouble("prix"));
                return r;
            }

        } catch (SQLException e) {
            System.err.println("❌ Erreur SQL dans getProchaineSeance");
            e.printStackTrace();
        }
        return null;
    }

    /**
     * 🔹 Liste des formateurs ayant le même domaine que le candidat
     */
    public List<Formateur> getFormateursDuDomaine(Long candidatId) {
        Map<Long, Formateur> formateurMap = new LinkedHashMap<>();

        // CORRECTION : Requête SQL améliorée
        String sql = "SELECT DISTINCT f.id AS formateur_id, u.nom, u.prenom, u.email, " +
                     "f.specialite, f.anneeExperience, f.tarifHoraire, f.description, " +
                     "d.jour, d.heureDebut, d.heureFin " +
                     "FROM formateur f " +
                     "JOIN utilisateur u ON f.id = u.id " +
                     "JOIN candidat c ON c.id = ? " +  // On récupère d'abord le candidat
                     "LEFT JOIN disponibilite d ON d.formateur_id = f.id " +
                     "WHERE f.specialite = c.domaineProfessionnel " +  // Comparaison directe
                     "ORDER BY u.nom, u.prenom, d.jour";

        try (Connection con = ConnectionBD.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setLong(1, candidatId);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                long formateurId = rs.getLong("formateur_id");
                Formateur f = formateurMap.get(formateurId);
                
                if (f == null) {
                    f = new Formateur();
                    f.setId(formateurId);
                    f.setNom(rs.getString("nom"));
                    f.setPrenom(rs.getString("prenom"));
                    f.setEmail(rs.getString("email"));
                    f.setSpecialite(rs.getString("specialite"));
                    f.setAnneeExperience(rs.getInt("anneeExperience"));
                    f.setTarifHoraire(rs.getDouble("tarifHoraire"));
                    f.setDescription(rs.getString("description"));
                    formateurMap.put(formateurId, f);
                }

                // Ajouter la disponibilité si elle existe
                if (rs.getDate("jour") != null) {
                    Disponibilite dispo = new Disponibilite();
                    dispo.setJour(rs.getDate("jour").toLocalDate());
                    dispo.setHeureDebut(rs.getTime("heureDebut").toLocalTime());
                    dispo.setHeureFin(rs.getTime("heureFin").toLocalTime());
                    f.addDisponibilite(dispo);
                }
            }

        } catch (SQLException e) {
            System.err.println("❌ Erreur dans getFormateursDuDomaine: " + e.getMessage());
            e.printStackTrace();
        }

        return new ArrayList<>(formateurMap.values());
    }


    /**
     * 🔹 Calcule le score du candidat à partir de ses feedbacks
     */
    public Score getScoreCandidat(Long candidatId) {
        Score score = new Score();

        String sql = "SELECT AVG(fb.note) AS moyenne, COUNT(fb.id) AS total_feedbacks, " +
                     "MAX(fb.dateFeedback) AS derniere_date, " +
                     "(SELECT fb2.note FROM feedbackcandidat fb2 " +
                     "JOIN reservation r2 ON fb2.reservation_id = r2.id " +
                     "WHERE r2.candidat_id = ? ORDER BY fb2.dateFeedback DESC LIMIT 1) AS derniere_note " +
                     "FROM feedbackcandidat fb " +
                     "JOIN reservation r ON fb.reservation_id = r.id " +
                     "WHERE r.candidat_id = ?";

        try (Connection con = ConnectionBD.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setLong(1, candidatId);
            ps.setLong(2, candidatId);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                score.setMoyenne(rs.getDouble("moyenne"));
                score.setTotalFeedbacks(rs.getInt("total_feedbacks"));
                score.setDerniereDate(rs.getDate("derniere_date"));
                score.setDerniereNote(rs.getInt("derniere_note"));
            }

        } catch (SQLException e) {
            System.err.println("❌ Erreur SQL dans getScoreCandidat");
            e.printStackTrace();
        }

        return score;
    }
}

