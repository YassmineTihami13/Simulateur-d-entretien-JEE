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

        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        request.setCharacterEncoding("UTF-8");

        try {
            // Récupération des paramètres
            String nom = request.getParameter("nom");
            String prenom = request.getParameter("prenom");
            String email = request.getParameter("email");
            String motDePasse = request.getParameter("motDePasse");
            String confirmMotDePasse = request.getParameter("confirmMotDePasse");
            String specialite = request.getParameter("specialite");
            String anneeExperienceStr = request.getParameter("anneeExperience");
            String tarifHoraireStr = request.getParameter("tarifHoraire");
            String description = request.getParameter("description");

            // Validation des champs obligatoires
            if (nom == null || prenom == null || email == null || motDePasse == null ||
                    nom.trim().isEmpty() || prenom.trim().isEmpty() || email.trim().isEmpty() ||
                    motDePasse.trim().isEmpty()) {

                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                response.getWriter().write("{\"success\": false, \"error\": \"Tous les champs obligatoires doivent être remplis.\"}");
                return;
            }

            // Validation du mot de passe
            if (!motDePasse.equals(confirmMotDePasse)) {
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                response.getWriter().write("{\"success\": false, \"error\": \"Les mots de passe ne correspondent pas.\"}");
                return;
            }

            // Gestion des fichiers uploadés
            List<String> uploadedFiles = new ArrayList<>();
            try {
                String uploadPath = getServletContext().getRealPath("") + File.separator + UPLOAD_DIR;
                File uploadDir = new File(uploadPath);
                if (!uploadDir.exists()) {
                    uploadDir.mkdir();
                }

                for (Part part : request.getParts()) {
                    if (part.getName().equals("certifications") && part.getSize() > 0) {
                        String fileName = extractFileName(part);
                        if (fileName != null && fileName.toLowerCase().endsWith(".pdf")) {
                            String uniqueFileName = UUID.randomUUID().toString() + "_" + fileName;
                            String filePath = uploadPath + File.separator + uniqueFileName;

                            try (InputStream inputStream = part.getInputStream()) {
                                Files.copy(inputStream, Paths.get(filePath), StandardCopyOption.REPLACE_EXISTING);
                                uploadedFiles.add(uniqueFileName);
                            }
                        }
                    }
                }
            } catch (Exception e) {
                response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
                response.getWriter().write("{\"success\": false, \"error\": \"Erreur lors de l'upload des fichiers : \" + e.getMessage()}");
                return;
            }

            String certifications = String.join(";", uploadedFiles);

            // Conversion des nombres
            int anneeExperience = Integer.parseInt(anneeExperienceStr);
            double tarifHoraire = Double.parseDouble(tarifHoraireStr);
            String motDePasseHache = hashPassword(motDePasse);

            // Génération du code de vérification
            String verificationCode = EmailUtil.generateVerificationCode();
            long expirationTime = System.currentTimeMillis() + (15 * 60 * 1000); // 15 minutes

            // Insertion en base de données
            try (Connection conn = ConnectionBD.getConnection()) {
                conn.setAutoCommit(false);

                try {
                    // Insertion dans la table utilisateur
                    String sqlUtilisateur = "INSERT INTO utilisateur (nom, prenom, email, motDePasse, role, verificationCode, codeExpiration, estVerifie, statut) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";
                    PreparedStatement psUtilisateur = conn.prepareStatement(sqlUtilisateur, PreparedStatement.RETURN_GENERATED_KEYS);
                    psUtilisateur.setString(1, nom);
                    psUtilisateur.setString(2, prenom);
                    psUtilisateur.setString(3, email);
                    psUtilisateur.setString(4, motDePasseHache);
                    psUtilisateur.setString(5, Utilisateur.Role.FORMATEUR.name());
                    psUtilisateur.setString(6, verificationCode);
                    psUtilisateur.setLong(7, expirationTime);
                    psUtilisateur.setBoolean(8, false); // Non vérifié par défaut
                    psUtilisateur.setBoolean(9, true); // Statut actif par défaut
                    psUtilisateur.executeUpdate();

                    // Récupération de l'ID généré
                    long userId = 0;
                    var rs = psUtilisateur.getGeneratedKeys();
                    if (rs.next()) {
                        userId = rs.getLong(1);
                    }

                    // Insertion dans la table formateur
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

                    // Envoi de l'email de vérification
                    boolean emailSent = EmailUtil.sendVerificationEmail(email, prenom + " " + nom, verificationCode);

                    if (emailSent) {
                        response.setStatus(HttpServletResponse.SC_OK);
                        response.getWriter().write("{\"success\": true, \"message\": \"Formateur ajouté avec succès. Un email de vérification a été envoyé.\"}");
                    } else {
                        response.setStatus(HttpServletResponse.SC_OK);
                        response.getWriter().write("{\"success\": true, \"message\": \"Formateur ajouté avec succès, mais l'email de vérification n'a pas pu être envoyé.\"}");
                    }

                } catch (SQLException e) {
                    conn.rollback();
                    // Suppression des fichiers uploadés en cas d'erreur
                    deleteUploadedFiles(uploadedFiles, getServletContext().getRealPath("") + File.separator + UPLOAD_DIR);

                    if (e.getMessage().contains("Duplicate entry")) {
                        response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                        response.getWriter().write("{\"success\": false, \"error\": \"Cet email est déjà utilisé.\"}");
                    } else {
                        throw e;
                    }
                }
            }

        } catch (NumberFormatException e) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            response.getWriter().write("{\"success\": false, \"error\": \"Les années d'expérience et le tarif horaire doivent être des nombres valides.\"}");
        } catch (SQLException e) {
            e.printStackTrace();
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().write("{\"success\": false, \"error\": \"Erreur lors de l'ajout en base de données: \" + e.getMessage()}");
        } catch (Exception e) {
            e.printStackTrace();
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().write("{\"success\": false, \"error\": \"Erreur serveur: \" + e.getMessage()}");
        }
    }

    private String extractFileName(Part part) {
        String contentDisp = part.getHeader("content-disposition");
        String[] items = contentDisp.split(";");
        for (String item : items) {
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
            } catch (IOException e) {
                e.printStackTrace();
            }
        }
    }

    private String hashPassword(String password) {
        try {
            MessageDigest md = MessageDigest.getInstance("SHA-256");
            byte[] hash = md.digest(password.getBytes());
            StringBuilder hexString = new StringBuilder();
            for (byte b : hash) {
                String hex = Integer.toHexString(0xff & b);
                if (hex.length() == 1) hexString.append('0');
                hexString.append(hex);
            }
            return hexString.toString();
        } catch (NoSuchAlgorithmException e) {
            throw new RuntimeException("Erreur lors du hachage du mot de passe", e);
        }
    }
}