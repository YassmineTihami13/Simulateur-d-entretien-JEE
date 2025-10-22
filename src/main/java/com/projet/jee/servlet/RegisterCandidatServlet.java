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

@WebServlet("/registerCandidat")
@MultipartConfig(
        fileSizeThreshold = 1024 * 1024 * 2,
        maxFileSize = 1024 * 1024 * 10,
        maxRequestSize = 1024 * 1024 * 50
)
public class RegisterCandidatServlet extends HttpServlet {

    private static final String UPLOAD_DIR = "cv";

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("/jsp/registerCandidat.jsp").forward(request, response);
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
        String domaineProfessionnel = request.getParameter("domaineProfessionnel");

        if (nom == null || prenom == null || email == null || motDePasse == null ||
                nom.trim().isEmpty() || prenom.trim().isEmpty() || email.trim().isEmpty() || motDePasse.trim().isEmpty()) {
            request.setAttribute("error", "Tous les champs obligatoires doivent être remplis.");
            request.getRequestDispatcher("/jsp/registerCandidat.jsp").forward(request, response);
            return;
        }

        if (!motDePasse.equals(confirmMotDePasse)) {
            request.setAttribute("error", "Les mots de passe ne correspondent pas.");
            request.getRequestDispatcher("/jsp/registerCandidat.jsp").forward(request, response);
            return;
        }

        String cvFileName = null;
        try {
            // Gestion de l'upload du CV
            Part cvPart = request.getPart("cv");
            if (cvPart != null && cvPart.getSize() > 0) {
                String uploadPath = getServletContext().getRealPath("") + File.separator + UPLOAD_DIR;
                File uploadDir = new File(uploadPath);
                if (!uploadDir.exists()) {
                    uploadDir.mkdir();
                }

                String fileName = extractFileName(cvPart);
                if (fileName != null && fileName.toLowerCase().endsWith(".pdf")) {
                    String uniqueFileName = UUID.randomUUID().toString() + "_" + fileName;
                    String filePath = uploadPath + File.separator + uniqueFileName;

                    try (InputStream inputStream = cvPart.getInputStream()) {
                        Files.copy(inputStream, Paths.get(filePath), StandardCopyOption.REPLACE_EXISTING);
                        cvFileName = uniqueFileName;
                    }
                }
            }
        } catch (Exception e) {
            request.setAttribute("error", "Erreur lors de l'upload du CV : " + e.getMessage());
            request.getRequestDispatcher("/jsp/registerCandidat.jsp").forward(request, response);
            return;
        }

        try {
            String motDePasseHache = hashPassword(motDePasse);
            String verificationCode = EmailUtil.generateVerificationCode();
            long expirationTime = System.currentTimeMillis() + (15 * 60 * 1000); // 15 minutes

            try (Connection conn = ConnectionBD.getConnection()) {
                conn.setAutoCommit(false);

                try {
                    // Insertion dans la table utilisateur
                    String sqlUtilisateur = "INSERT INTO utilisateur (nom, prenom, email, motDePasse, role, verificationCode, codeExpiration, estVerifie) VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
                    PreparedStatement psUtilisateur = conn.prepareStatement(sqlUtilisateur, PreparedStatement.RETURN_GENERATED_KEYS);
                    psUtilisateur.setString(1, nom);
                    psUtilisateur.setString(2, prenom);
                    psUtilisateur.setString(3, email);
                    psUtilisateur.setString(4, motDePasseHache);
                    psUtilisateur.setString(5, Utilisateur.Role.CANDIDAT.name());
                    psUtilisateur.setString(6, verificationCode);
                    psUtilisateur.setLong(7, expirationTime);
                    psUtilisateur.setBoolean(8, false);
                    psUtilisateur.executeUpdate();

                    var rs = psUtilisateur.getGeneratedKeys();
                    long userId = 0;
                    if (rs.next()) {
                        userId = rs.getLong(1);
                    }

                    // Insertion dans la table candidat
                    String sqlCandidat = "INSERT INTO candidat (id, domaineProfessionnel, cv) VALUES (?, ?, ?)";
                    PreparedStatement psCandidat = conn.prepareStatement(sqlCandidat);
                    psCandidat.setLong(1, userId);
                    psCandidat.setString(2, domaineProfessionnel);
                    psCandidat.setString(3, cvFileName);
                    psCandidat.executeUpdate();

                    conn.commit();

                    // Envoi de l'email de vérification
                    boolean emailSent = EmailUtil.sendVerificationEmailCandidat(email, prenom + " " + nom, verificationCode);

                    if (emailSent) {
                        HttpSession session = request.getSession();
                        session.setAttribute("pendingEmail", email);
                        session.setAttribute("userName", prenom + " " + nom);

                        response.sendRedirect(request.getContextPath() + "/jsp/verifyCode.jsp");
                    } else {
                        // Supprimer le fichier uploadé en cas d'erreur d'envoi d'email
                        if (cvFileName != null) {
                            deleteUploadedFile(cvFileName, getServletContext().getRealPath("") + File.separator + UPLOAD_DIR);
                        }
                        request.setAttribute("error", "Inscription réussie mais l'email n'a pas pu être envoyé. Contactez l'administrateur.");
                        request.getRequestDispatcher("/jsp/registerCandidat.jsp").forward(request, response);
                    }

                } catch (SQLException e) {
                    conn.rollback();
                    // Supprimer le fichier uploadé en cas d'erreur
                    if (cvFileName != null) {
                        deleteUploadedFile(cvFileName, getServletContext().getRealPath("") + File.separator + UPLOAD_DIR);
                    }
                    throw e;
                }
            }

        } catch (SQLException e) {
            // Supprimer le fichier uploadé en cas d'erreur
            if (cvFileName != null) {
                deleteUploadedFile(cvFileName, getServletContext().getRealPath("") + File.separator + UPLOAD_DIR);
            }
            if (e.getMessage().contains("Duplicate entry")) {
                request.setAttribute("error", "Cet email est déjà utilisé.");
            } else {
                request.setAttribute("error", "Erreur lors de l'inscription : " + e.getMessage());
            }
            request.getRequestDispatcher("/jsp/registerCandidat.jsp").forward(request, response);
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

    private void deleteUploadedFile(String fileName, String uploadPath) {
        try {
            Files.deleteIfExists(Paths.get(uploadPath + File.separator + fileName));
        } catch (IOException e) {
            e.printStackTrace();
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