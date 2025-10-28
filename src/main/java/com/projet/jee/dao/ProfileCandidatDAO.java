package com.projet.jee.dao;

import com.projet.jee.models.Candidat;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ProfileCandidatDAO {
    private Connection connection;

    public ProfileCandidatDAO() {
        try {
            this.connection = ConnectionBD.getConnection();
        } catch (SQLException e) {
            throw new RuntimeException("Erreur lors de la connexion à la base de données", e);
        }
    }

    // Récupérer un candidat par son ID - CORRIGÉ
    public Candidat getCandidatById(long id) {
        String sql = "SELECT u.*, c.domaine_professionnel, c.cv " +
                "FROM utilisateurs u " +
                "LEFT JOIN candidats c ON u.id = c.utilisateur_id " +
                "WHERE u.id = ? AND u.role = 'CANDIDAT'";

        try (PreparedStatement statement = connection.prepareStatement(sql)) {
            statement.setLong(1, id);
            ResultSet resultSet = statement.executeQuery();

            if (resultSet.next()) {
                return mapResultSetToCandidat(resultSet);
            }
        } catch (SQLException e) {
            System.err.println("Erreur SQL dans getCandidatById: " + e.getMessage());
            e.printStackTrace();
        } catch (Exception e) {
            System.err.println("Erreur générale dans getCandidatById: " + e.getMessage());
            e.printStackTrace();
        }
        return null;
    }

    // Mettre à jour les informations du candidat - CORRIGÉ
    public boolean updateCandidat(Candidat candidat, boolean updatePassword) {
        String updateUserSql = "UPDATE utilisateurs SET nom = ?, prenom = ?, email = ? " +
                (updatePassword ? ", mot_de_passe = ? " : "") +
                "WHERE id = ?";

        String updateCandidatSql = "UPDATE candidats SET domaine_professionnel = ? WHERE utilisateur_id = ?";

        try {
            connection.setAutoCommit(false);

            // Mise à jour de la table utilisateurs
            try (PreparedStatement userStatement = connection.prepareStatement(updateUserSql)) {
                userStatement.setString(1, candidat.getNom());
                userStatement.setString(2, candidat.getPrenom());
                userStatement.setString(3, candidat.getEmail());

                int paramIndex = 4;
                if (updatePassword) {
                    userStatement.setString(4, candidat.getMotDePasse());
                    paramIndex = 5;
                }
                userStatement.setLong(paramIndex, candidat.getId());

                int userRows = userStatement.executeUpdate();
                if (userRows == 0) {
                    connection.rollback();
                    return false;
                }
            }

            // Mise à jour de la table candidats
            try (PreparedStatement candidatStatement = connection.prepareStatement(updateCandidatSql)) {
                candidatStatement.setString(1, candidat.getDomaineProfessionnelEnumName());
                candidatStatement.setLong(2, candidat.getId());

                int candidatRows = candidatStatement.executeUpdate();
                if (candidatRows == 0) {
                    // Si pas de ligne dans candidats, on l'insère
                    insertCandidatData(candidat);
                }
            }

            connection.commit();
            return true;

        } catch (SQLException e) {
            try {
                connection.rollback();
            } catch (SQLException ex) {
                System.err.println("Erreur lors du rollback: " + ex.getMessage());
            }
            System.err.println("Erreur SQL dans updateCandidat: " + e.getMessage());
            e.printStackTrace();
            return false;
        } finally {
            try {
                connection.setAutoCommit(true);
            } catch (SQLException e) {
                System.err.println("Erreur lors du rétablissement autoCommit: " + e.getMessage());
            }
        }
    }

    // Insérer les données candidat si elles n'existent pas
    private void insertCandidatData(Candidat candidat) throws SQLException {
        String sql = "INSERT INTO candidats (utilisateur_id, domaine_professionnel, cv) VALUES (?, ?, ?)";
        try (PreparedStatement statement = connection.prepareStatement(sql)) {
            statement.setLong(1, candidat.getId());
            statement.setString(2, candidat.getDomaineProfessionnelEnumName());
            statement.setString(3, candidat.getCv());
            statement.executeUpdate();
        }
    }

    // Mettre à jour uniquement le CV - CORRIGÉ
    public boolean updateCandidatCV(long candidatId, String cvFileName) {
        String sql = "UPDATE candidats SET cv = ? WHERE utilisateur_id = ?";

        try (PreparedStatement statement = connection.prepareStatement(sql)) {
            statement.setString(1, cvFileName);
            statement.setLong(2, candidatId);

            int rowsUpdated = statement.executeUpdate();

            // Si aucune ligne mise à jour, on insère
            if (rowsUpdated == 0) {
                return insertCVCandidat(candidatId, cvFileName);
            }

            return rowsUpdated > 0;

        } catch (SQLException e) {
            System.err.println("Erreur SQL dans updateCandidatCV: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }

    // Insérer le CV si pas de ligne existante
    private boolean insertCVCandidat(long candidatId, String cvFileName) {
        String sql = "INSERT INTO candidats (utilisateur_id, cv) VALUES (?, ?)";
        try (PreparedStatement statement = connection.prepareStatement(sql)) {
            statement.setLong(1, candidatId);
            statement.setString(2, cvFileName);
            return statement.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("Erreur SQL dans insertCVCandidat: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }

    // Mapper ResultSet vers objet Candidat - CORRIGÉ
    private Candidat mapResultSetToCandidat(ResultSet resultSet) throws SQLException {
        Candidat candidat = new Candidat();

        // Propriétés de Utilisateur
        candidat.setId(resultSet.getLong("id"));
        candidat.setNom(resultSet.getString("nom"));
        candidat.setPrenom(resultSet.getString("prenom"));
        candidat.setEmail(resultSet.getString("email"));
        candidat.setMotDePasse(resultSet.getString("mot_de_passe"));

        // Gestion sécurisée du rôle
        String roleStr = resultSet.getString("role");
        if (roleStr != null) {
            try {
                candidat.setRole(Candidat.Role.valueOf(roleStr));
            } catch (IllegalArgumentException e) {
                candidat.setRole(Candidat.Role.CANDIDAT); // Valeur par défaut
            }
        } else {
            candidat.setRole(Candidat.Role.CANDIDAT);
        }

        Timestamp dateCreation = resultSet.getTimestamp("date_creation");
        if (dateCreation != null) {
            candidat.setDateCreation(dateCreation.toLocalDateTime());
        }

        candidat.setStatut(resultSet.getBoolean("statut"));
        candidat.setEstVerifie(resultSet.getBoolean("est_verifie"));

        // Propriétés spécifiques à Candidat - CORRECTION ICI
        String domaine = resultSet.getString("domaine_professionnel");
        if (domaine != null && !domaine.trim().isEmpty()) {
            try {
                candidat.setDomaineProfessionnel(domaine);
            } catch (IllegalArgumentException e) {
                // Si le domaine n'est pas valide, on utilise une valeur par défaut
                candidat.setDomaineProfessionnel("INFORMATIQUE");
            }
        } else {
            // Valeur par défaut si null ou vide
            candidat.setDomaineProfessionnel("INFORMATIQUE");
        }

        candidat.setCv(resultSet.getString("cv"));

        return candidat;
    }

    // Vérifier si l'email existe déjà - CORRIGÉ
    public boolean isEmailExists(String email, long currentUserId) {
        String sql = "SELECT COUNT(*) as count FROM utilisateurs WHERE email = ? AND id != ?";

        try (PreparedStatement statement = connection.prepareStatement(sql)) {
            statement.setString(1, email);
            statement.setLong(2, currentUserId);

            ResultSet resultSet = statement.executeQuery();
            if (resultSet.next()) {
                return resultSet.getInt("count") > 0;
            }
        } catch (SQLException e) {
            System.err.println("Erreur SQL dans isEmailExists: " + e.getMessage());
            e.printStackTrace();
            // En cas d'erreur, on retourne false pour ne pas bloquer l'utilisateur
            return false;
        }
        return false;
    }

    // Récupérer tous les candidats (pour admin)
    public List<Candidat> getAllCandidats() {
        List<Candidat> candidats = new ArrayList<>();
        String sql = "SELECT u.*, c.domaine_professionnel, c.cv " +
                "FROM utilisateurs u " +
                "LEFT JOIN candidats c ON u.id = c.utilisateur_id " +
                "WHERE u.role = 'CANDIDAT' " +
                "ORDER BY u.date_creation DESC";

        try (PreparedStatement statement = connection.prepareStatement(sql);
             ResultSet resultSet = statement.executeQuery()) {

            while (resultSet.next()) {
                candidats.add(mapResultSetToCandidat(resultSet));
            }
        } catch (SQLException e) {
            System.err.println("Erreur SQL dans getAllCandidats: " + e.getMessage());
            e.printStackTrace();
        }
        return candidats;
    }

    // Fermer la connexion
    public void closeConnection() {
        if (connection != null) {
            try {
                connection.close();
            } catch (SQLException e) {
                System.err.println("Erreur lors de la fermeture de la connexion: " + e.getMessage());
            }
        }
    }
}