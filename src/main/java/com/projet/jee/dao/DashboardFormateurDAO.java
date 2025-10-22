
package com.projet.jee.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import com.projet.jee.models.Formateur;

public class DashboardFormateurDAO {

    /**
     * Compte le nombre de candidats ayant le même domaine que le formateur
     * @param specialiteFormateur La spécialité ENUM du formateur (ex: "INFORMATIQUE")
     * @return Le nombre de candidats dans ce domaine
     */
    public int getNombreCandidatsParDomaine(String specialiteFormateur) {
        // Convertir l'ENUM du formateur vers le format texte du candidat
        String domaineCandidat = convertirSpecialiteVersDomaine(specialiteFormateur);

        String query = "SELECT COUNT(*) FROM candidat c " +
                "INNER JOIN utilisateur u ON c.id = u.id " +
                "WHERE UPPER(TRIM(c.domaineProfessionnel)) = UPPER(?) " +
                "AND u.role = 'CANDIDAT'";

        try (Connection con = ConnectionBD.getConnection();
             PreparedStatement ps = con.prepareStatement(query)) {

            ps.setString(1, domaineCandidat);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            System.err.println("Erreur lors du comptage des candidats pour le domaine: " + domaineCandidat);
            e.printStackTrace();
        }
        return 0;
    }

    /**
     * Convertit la spécialité ENUM du formateur vers le format du domaine candidat
     */
    private String convertirSpecialiteVersDomaine(String specialite) {
        if (specialite == null) return "";

        switch (specialite.toUpperCase()) {
            case "INFORMATIQUE":
                return "Informatique";
            case "MECATRONIQUE":
                return "Mécatronique";
            case "INTELLIGENCE_ARTIFICIELLE":
                return "Intelligence Artificielle";
            case "CYBERSECURITE":
                return "Cybersécurité";
            case "GSTR":
                return "GSTR";
            case "SUPPLY_CHAIN_MANAGEMENT":
                return "Supply Chain Management";
            case "GENIE_CIVIL":
                return "Génie Civil";
            default:
                return specialite;
        }
    }

    public int getTotalReservations(long formateurId) {
        String query = "SELECT COUNT(*) FROM reservation WHERE formateur_id = ?";
        try (Connection con = ConnectionBD.getConnection();
             PreparedStatement ps = con.prepareStatement(query)) {
            ps.setLong(1, formateurId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return rs.getInt(1);
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    public int getEntretiensPasses(long formateurId) {
        String query = "SELECT COUNT(*) FROM reservation " +
                "WHERE formateur_id = ? AND dateReservation < CURDATE()";
        try (Connection con = ConnectionBD.getConnection();
             PreparedStatement ps = con.prepareStatement(query)) {
            ps.setLong(1, formateurId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return rs.getInt(1);
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    public int[] getStatutReservations(long formateurId) {
        // Si vous n'avez pas de colonne statut, retournez des valeurs par défaut
        String query = "SELECT COUNT(*) as total FROM reservation WHERE formateur_id = ?";
        try (Connection con = ConnectionBD.getConnection();
             PreparedStatement ps = con.prepareStatement(query)) {
            ps.setLong(1, formateurId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                int total = rs.getInt("total");
                // Pour l'instant, considérons que 80% sont confirmées et 20% annulées
                return new int[]{(int)(total * 0.8), (int)(total * 0.2)};
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return new int[]{0, 0};
    }

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
}
