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

@WebServlet("/register")
@MultipartConfig(
        fileSizeThreshold = 1024 * 1024 * 2,
        maxFileSize = 1024 * 1024 * 10,
        maxRequestSize = 1024 * 1024 * 50
)
public class RegisterFormateurServlet extends HttpServlet {

    private static final String UPLOAD_DIR = "certifications";

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("/jsp/registerFormateur.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        String nom = request.getParameter("nom");
        String prenom = request.getParameter("prenom");
        String email = request.getParameter("email");
        String motDePasse = request.getParameter("motDePasse");
        String confirmMotDePasse = request.getParameter("confirmMotDePasse");
        String specialite = request.getParameter("specialite");
        String anneeExperienceStr = request.getParameter("anneeExperience");
        String tarifHoraireStr = request.getParameter("tarifHoraire");
        String description = request.getParameter("description");

        if (nom == null || prenom == null || email == null || motDePasse == null ||
                nom.trim().isEmpty() || prenom.trim().isEmpty() || email.trim().isEmpty() || motDePasse.trim().isEmpty()) {
            request.setAttribute("error", "Tous les champs obligatoires doivent être remplis.");
            request.getRequestDispatcher("/jsp/registerFormateur.jsp").forward(request, response);
            return;
        }

        if (!motDePasse.equals(confirmMotDePasse)) {
            request.setAttribute("error", "Les mots de passe ne correspondent pas.");
            request.getRequestDispatcher("/jsp/registerFormateur.jsp").forward(request, response);
            return;
        }

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
            request.setAttribute("error", "Erreur lors de l'upload des fichiers : " + e.getMessage());
            request.getRequestDispatcher("/jsp/registerFormateur.jsp").forward(request, response);
            return;
        }

        String certifications = String.join(";", uploadedFiles);

        try {
            int anneeExperience = Integer.parseInt(anneeExperienceStr);
            double tarifHoraire = Double.parseDouble(tarifHoraireStr);
            String motDePasseHache = hashPassword(motDePasse);

            String verificationCode = EmailUtil.generateVerificationCode();
            long expirationTime = System.currentTimeMillis() + (15 * 60 * 1000); // 15 minutes

            try (Connection conn = ConnectionBD.getConnection()) {
                conn.setAutoCommit(false);

                try {
                    String sqlUtilisateur = "INSERT INTO utilisateur (nom, prenom, email, motDePasse, role, verificationCode, codeExpiration, estVerifie) VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
                    PreparedStatement psUtilisateur = conn.prepareStatement(sqlUtilisateur, PreparedStatement.RETURN_GENERATED_KEYS);
                    psUtilisateur.setString(1, nom);
                    psUtilisateur.setString(2, prenom);
                    psUtilisateur.setString(3, email);
                    psUtilisateur.setString(4, motDePasseHache);
                    psUtilisateur.setString(5, Utilisateur.Role.FORMATEUR.name());
                    psUtilisateur.setString(6, verificationCode);
                    psUtilisateur.setLong(7, expirationTime);
                    psUtilisateur.setBoolean(8, false);
                    psUtilisateur.executeUpdate();

                    var rs = psUtilisateur.getGeneratedKeys();
                    long userId = 0;
                    if (rs.next()) {
                        userId = rs.getLong(1);
                    }

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

                    boolean emailSent = EmailUtil.sendVerificationEmail(email, prenom + " " + nom, verificationCode);

                    if (emailSent) {
                        HttpSession session = request.getSession();
                        session.setAttribute("pendingEmail", email);
                        session.setAttribute("userName", prenom + " " + nom);

                        response.sendRedirect(request.getContextPath() + "/jsp/verifyCode.jsp");
                    } else {
                        request.setAttribute("error", "Inscription réussie mais l'email n'a pas pu être envoyé. Contactez l'administrateur.");
                        request.getRequestDispatcher("/jsp/registerFormateur.jsp").forward(request, response);
                    }

                } catch (SQLException e) {
                    conn.rollback();
                    deleteUploadedFiles(uploadedFiles, getServletContext().getRealPath("") + File.separator + UPLOAD_DIR);
                    throw e;
                }
            }

        } catch (NumberFormatException e) {
            deleteUploadedFiles(uploadedFiles, getServletContext().getRealPath("") + File.separator + UPLOAD_DIR);
            request.setAttribute("error", "Les années d'expérience et le tarif horaire doivent être des nombres valides.");
            request.getRequestDispatcher("/jsp/registerFormateur.jsp").forward(request, response);
        } catch (SQLException e) {
            deleteUploadedFiles(uploadedFiles, getServletContext().getRealPath("") + File.separator + UPLOAD_DIR);
            if (e.getMessage().contains("Duplicate entry")) {
                request.setAttribute("error", "Cet email est déjà utilisé.");
            } else {
                request.setAttribute("error", "Erreur lors de l'inscription : " + e.getMessage());
            }
            request.getRequestDispatcher("/jsp/registerFormateur.jsp").forward(request, response);
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


    private String getOriginalFileName(String uniqueFileName) {
        if (uniqueFileName == null || !uniqueFileName.contains("_")) {
            return uniqueFileName;
        }
        return uniqueFileName.substring(uniqueFileName.indexOf("_") + 1);
    }
}