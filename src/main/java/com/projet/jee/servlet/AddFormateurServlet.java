package com.projet.jee.servlet;

import com.projet.jee.dao.ConnectionBD;
import com.projet.jee.models.Utilisateur;
import com.projet.jee.service.EmailUtil;

import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.nio.file.StandardCopyOption;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.UUID;

@WebServlet("/admin/add-formateur")
@MultipartConfig(
        fileSizeThreshold = 1024 * 1024 * 2,
        maxFileSize = 1024 * 1024 * 10,
        maxRequestSize = 1024 * 1024 * 50
)
public class AddFormateurServlet extends HttpServlet {

  
	 private static final String UPLOAD_DIR = "certifications";
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        System.out.println("=== [LOG] Démarrage du servlet AddFormateurServlet ===");

        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        request.setCharacterEncoding("UTF-8");

        try {
            // --- Paramètres ---
            String nom = request.getParameter("nom");
            String prenom = request.getParameter("prenom");
            String email = request.getParameter("email");
            String motDePasse = request.getParameter("motDePasse");
            String confirmMotDePasse = request.getParameter("confirmMotDePasse");
            String specialite = request.getParameter("specialite");
            String anneeExperienceStr = request.getParameter("anneeExperience");
            String tarifHoraireStr = request.getParameter("tarifHoraire");
            String description = request.getParameter("description");

            System.out.println("[LOG] Paramètres reçus : nom=" + nom + ", prenom=" + prenom + ", email=" + email
                    + ", specialite=" + specialite + ", experience=" + anneeExperienceStr + ", tarif=" + tarifHoraireStr);

            // --- Validation ---
            if (nom == null || prenom == null || email == null || motDePasse == null ||
                    nom.trim().isEmpty() || prenom.trim().isEmpty() || email.trim().isEmpty() ||
                    motDePasse.trim().isEmpty()) {
                System.out.println("[ERREUR] Champs manquants");
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                response.getWriter().write("{\"success\": false, \"error\": \"Tous les champs obligatoires doivent être remplis.\"}");
                return;
            }

            if (!motDePasse.equals(confirmMotDePasse)) {
                System.out.println("[ERREUR] Les mots de passe ne correspondent pas");
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                response.getWriter().write("{\"success\": false, \"error\": \"Les mots de passe ne correspondent pas.\"}");
                return;
            }

            List<String> uploadedFiles = new ArrayList<>();
            String uploadPath = getServletContext().getRealPath("") + File.separator + UPLOAD_DIR;
            

            File uploadDir = new File(uploadPath);
            if (!uploadDir.exists()) {
                boolean created = uploadDir.mkdirs();
                System.out.println("[LOG] Dossier certifications créé : " + created);
            } else {
                System.out.println("[LOG] Dossier certifications existe déjà");
            }

            for (Part part : request.getParts()) {
                if (part.getName().equals("certifications") && part.getSize() > 0) {
                    String fileName = extractFileName(part);
                    System.out.println("[LOG] Fichier détecté : " + fileName);
                    if (fileName != null && fileName.toLowerCase().endsWith(".pdf")) {
                        String uniqueFileName = UUID.randomUUID().toString() + "_" + fileName;
                        File file = new File(uploadDir, uniqueFileName);
                        try (InputStream inputStream = part.getInputStream()) {
                            Files.copy(inputStream, file.toPath(), StandardCopyOption.REPLACE_EXISTING);
                            uploadedFiles.add(uniqueFileName);
                            System.out.println("[LOG] Fichier sauvegardé : " + uniqueFileName);
                        } catch (IOException ex) {
                            System.err.println("[ERREUR] Impossible de sauvegarder le fichier : " + ex.getMessage());
                            throw ex;
                        }
                    }
                }
            }

            String certifications = String.join(";", uploadedFiles);
            System.out.println("[LOG] Fichiers enregistrés en base : " + certifications);

            // --- Conversion ---
            int anneeExperience = Integer.parseInt(anneeExperienceStr);
            double tarifHoraire = Double.parseDouble(tarifHoraireStr);
            String motDePasseHache = hashPassword(motDePasse);
            String verificationCode = EmailUtil.generateVerificationCode();
            long expirationTime = System.currentTimeMillis() + (15 * 60 * 1000);

            System.out.println("[LOG] Données prêtes pour insertion SQL");

            // --- Insertion base ---
            try (Connection conn = ConnectionBD.getConnection()) {
                conn.setAutoCommit(false);
                try {
                    String sqlUtilisateur = "INSERT INTO utilisateur (nom, prenom, email, motDePasse, role, verificationCode, codeExpiration, estVerifie, statut) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";
                    PreparedStatement psUtilisateur = conn.prepareStatement(sqlUtilisateur, PreparedStatement.RETURN_GENERATED_KEYS);
                    psUtilisateur.setString(1, nom);
                    psUtilisateur.setString(2, prenom);
                    psUtilisateur.setString(3, email);
                    psUtilisateur.setString(4, motDePasseHache);
                    psUtilisateur.setString(5, Utilisateur.Role.FORMATEUR.name());
                    psUtilisateur.setString(6, verificationCode);
                    psUtilisateur.setLong(7, expirationTime);
                    psUtilisateur.setBoolean(8, false);
                    psUtilisateur.setBoolean(9, true);
                    psUtilisateur.executeUpdate();

                    long userId = 0;
                    var rs = psUtilisateur.getGeneratedKeys();
                    if (rs.next()) userId = rs.getLong(1);
                    System.out.println("[LOG] Nouvel utilisateur ID : " + userId);

                    String sqlFormateur = "INSERT INTO formateur (id, specialite, anneeExperience, certifications, tarifHoraire, description) VALUES (?, ?, ?, ?, ?, ?)";
                    PreparedStatement psFormateur = conn.prepareStatement(sqlFormateur);
                    psFormateur.setLong(1, userId);
                    psFormateur.setString(2, specialite);
                    psFormateur.setInt(3, anneeExperience);
                    psFormateur.setString(4, certifications);
                    psFormateur.setDouble(5, tarifHoraire);
                    psFormateur.setString(6, description);
                    psFormateur.executeUpdate();

                    conn.commit();
                    System.out.println("[LOG] Insertion réussie en base pour le formateur ID=" + userId);

                    boolean emailSent = EmailUtil.sendVerificationEmail(email, prenom + " " + nom, verificationCode);
                    if (emailSent)
                        System.out.println("[LOG] Email de vérification envoyé à " + email);
                    else
                        System.out.println("[AVERTISSEMENT] Échec de l'envoi de l'email à " + email);

                    response.setStatus(HttpServletResponse.SC_OK);
                    response.getWriter().write("{\"success\": true, \"message\": \"Formateur ajouté avec succès.\"}");

                } catch (SQLException e) {
                    conn.rollback();
                    deleteUploadedFiles(uploadedFiles, uploadPath);
                    System.err.println("[ERREUR SQL] " + e.getMessage());
                    throw e;
                }
            }

        } catch (NumberFormatException e) {
            System.err.println("[ERREUR] Format numérique invalide : " + e.getMessage());
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            response.getWriter().write("{\"success\": false, \"error\": \"Années d'expérience et tarif horaire invalides.\"}");
        } catch (Exception e) {
            System.err.println("[ERREUR] Exception inattendue : " + e.getMessage());
            e.printStackTrace();
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().write("{\"success\": false, \"error\": \"" + e.getMessage() + "\"}");
        }

      
    }

    private String extractFileName(Part part) {
        String contentDisp = part.getHeader("content-disposition");
        for (String item : contentDisp.split(";")) {
            if (item.trim().startsWith("filename")) {
                return item.substring(item.indexOf("=") + 2, item.length() - 1);
            }
        }
        return null;
    }

    private void deleteUploadedFiles(List<String> fileNames, String uploadPath) {
        for (String fileName : fileNames) {
            try {
                Files.deleteIfExists(Paths.get(uploadPath + File.separator + fileName));
                System.out.println("[LOG] Fichier supprimé suite à rollback : " + fileName);
            } catch (IOException e) {
                System.err.println("[ERREUR] Impossible de supprimer " + fileName + " : " + e.getMessage());
            }
        }
    }

    private String hashPassword(String password) {
        try {
            MessageDigest md = MessageDigest.getInstance("SHA-256");
            byte[] hash = md.digest(password.getBytes());
            StringBuilder hex = new StringBuilder();
            for (byte b : hash) hex.append(String.format("%02x", b));
            return hex.toString();
        } catch (NoSuchAlgorithmException e) {
            throw new RuntimeException(e);
        }
    }
}