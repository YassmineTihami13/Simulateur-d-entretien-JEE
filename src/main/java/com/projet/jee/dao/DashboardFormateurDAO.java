package com.projet.jee.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import com.projet.jee.models.Formateur;

public class DashboardFormateurDAO {

    /**
     * Compte le nombre de candidats ayant la même spécialité que le formateur connecté
     */
    public int getNombreCandidatsParSpecialite(String specialiteFormateur) {
        String domaine = convertirSpecialiteVersDomaine(specialiteFormateur);

        String query = "SELECT COUNT(*) as total FROM candidat c " +
                       "JOIN utilisateur u ON c.id = u.id " +
                       "WHERE UPPER(TRIM(c.domaineProfessionnel)) = UPPER(TRIM(?)) " +
                       "AND u.role = 'CANDIDAT'";

        try (Connection con = ConnectionBD.getConnection();
             PreparedStatement ps = con.prepareStatement(query)) {

            ps.setString(1, domaine);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                return rs.getInt("total");
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    /**
     * Compte le nombre total de réservations du formateur connecté
     */
    public int getTotalReservations(long formateurId) {
        String query = "SELECT COUNT(*) as total FROM reservation WHERE formateur_id = ?";

        try (Connection con = ConnectionBD.getConnection();
             PreparedStatement ps = con.prepareStatement(query)) {

            ps.setLong(1, formateurId);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                return rs.getInt("total");
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    /**
     * Convertit la spécialité ENUM du formateur vers le format utilisé dans le domaine du candidat
     */
    private String convertirSpecialiteVersDomaine(String specialite) {
        if (specialite == null) return "";

        switch (specialite.toUpperCase()) {
            case "INFORMATIQUE": return "Informatique";
            case "MECATRONIQUE": return "Mécatronique";
            case "INTELLIGENCE_ARTIFICIELLE": return "Intelligence Artificielle";
            case "CYBERSECURITE": return "Cybersécurité";
            case "GSTR": return "GSTR";
            case "SUPPLY_CHAIN_MANAGEMENT": return "Supply Chain Management";
            case "GENIE_CIVIL": return "Génie Civil";
            default: return specialite;
        }
    }

    /**
     * Récupère les informations complètes du formateur par son ID
     */
    public Formateur getFormateurById(long userId) {
        String query = "SELECT u.id, u.nom, u.prenom, u.email, u.motDePasse, f.specialite, " +
                       "f.anneeExperience, f.certifications, f.tarifHoraire, f.description " +
                       "FROM utilisateur u " +
                       "JOIN formateur f ON u.id = f.id " +
                       "WHERE u.id = ?";

        try (Connection con = ConnectionBD.getConnection();
             PreparedStatement ps = con.prepareStatement(query)) {

            ps.setLong(1, userId);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                return new Formateur(
                    rs.getLong("id"),
                    rs.getString("nom"),
                    rs.getString("prenom"),
                    rs.getString("email"),
                    rs.getString("motDePasse"),
                    rs.getString("specialite"),
                    rs.getInt("anneeExperience"),
                    rs.getString("certifications"),
                    rs.getDouble("tarifHoraire"),
                    rs.getString("description")
                );
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }
    
    
    public int getEntretiensPasses(long formateurId) {
        String query = "SELECT COUNT(*) as total FROM reservation " +
                       "WHERE formateur_id = ? AND dateReservation < CURDATE()";

        try (Connection con = ConnectionBD.getConnection();
             PreparedStatement ps = con.prepareStatement(query)) {
            ps.setLong(1, formateurId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt("total");
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    public int[] getStatutReservations(long formateurId) {
        String query = "SELECT " +
                       "SUM(CASE WHEN statut = 'ACCEPTEE' THEN 1 ELSE 0 END) AS acceptees, " +
                       "SUM(CASE WHEN statut = 'REFUSEE' THEN 1 ELSE 0 END) AS refusees " +
                       "FROM reservation WHERE formateur_id = ?";

        try (Connection con = ConnectionBD.getConnection();
             PreparedStatement ps = con.prepareStatement(query)) {

            ps.setLong(1, formateurId);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                int acceptees = rs.getInt("acceptees");
                int refusees = rs.getInt("refusees");
                return new int[]{acceptees, refusees};
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return new int[]{0, 0};
    }


}
