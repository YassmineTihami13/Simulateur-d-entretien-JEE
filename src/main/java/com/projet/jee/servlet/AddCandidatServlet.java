package com.projet.jee.servlet;

import com.projet.jee.dao.UtilisateurDAO;
import com.projet.jee.models.Candidat;
import com.projet.jee.models.Utilisateur;
import com.google.gson.Gson;

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
import java.util.HashMap;
import java.util.Map;
import java.util.UUID;

@WebServlet("/admin/add-candidat")
@MultipartConfig(
        fileSizeThreshold = 1024 * 1024 * 2,
        maxFileSize = 1024 * 1024 * 10,
        maxRequestSize = 1024 * 1024 * 50
)
public class AddCandidatServlet extends HttpServlet {

    private static final String UPLOAD_DIR = "cv";
    private UtilisateurDAO utilisateurDAO;
    private Gson gson;

    @Override
    public void init() throws ServletException {
        super.init();
        utilisateurDAO = new UtilisateurDAO();
        gson = new Gson();
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        Map<String, Object> result = new HashMap<>();
        String cvFileName = null;

        try {
            String nom = request.getParameter("nom");
            String prenom = request.getParameter("prenom");
            String email = request.getParameter("email");
            String motDePasse = request.getParameter("motDePasse");
            String domaineProfessionnel = request.getParameter("domaineProfessionnel");

            if (nom == null || nom.trim().isEmpty() ||
                    prenom == null || prenom.trim().isEmpty() ||
                    email == null || email.trim().isEmpty() ||
                    motDePasse == null || motDePasse.length() < 6) {

                result.put("success", false);
                result.put("message", "Tous les champs obligatoires doivent être remplis et le mot de passe doit contenir au moins 6 caractères");
                response.getWriter().write(gson.toJson(result));
                return;
            }

            if (utilisateurDAO.emailExists(email)) {
                result.put("success", false);
                result.put("message", "Cet email est déjà utilisé");
                response.getWriter().write(gson.toJson(result));
                return;
            }

            if (domaineProfessionnel != null && !domaineProfessionnel.trim().isEmpty()) {
                try {
                    Candidat.DomaineProfessionnel.valueOf(domaineProfessionnel.trim());
                } catch (IllegalArgumentException e) {
                    result.put("success", false);
                    result.put("message", "Domaine professionnel invalide");
                    response.getWriter().write(gson.toJson(result));
                    return;
                }
            }

            Part cvPart = request.getPart("cv");
            if (cvPart != null && cvPart.getSize() > 0) {
                String fileName = extractFileName(cvPart);

                if (fileName == null || !fileName.toLowerCase().endsWith(".pdf")) {
                    result.put("success", false);
                    result.put("message", "Seuls les fichiers PDF sont acceptés pour le CV");
                    response.getWriter().write(gson.toJson(result));
                    return;
                }

                String uploadPath = getServletContext().getRealPath("") + File.separator + UPLOAD_DIR;
                File uploadDir = new File(uploadPath);
                if (!uploadDir.exists()) {
                    uploadDir.mkdir();
                }

                String uniqueFileName = UUID.randomUUID().toString() + "_" + fileName;
                String filePath = uploadPath + File.separator + uniqueFileName;

                try (InputStream inputStream = cvPart.getInputStream()) {
                    Files.copy(inputStream, Paths.get(filePath), StandardCopyOption.REPLACE_EXISTING);
                    cvFileName = uniqueFileName;
                }
            }

            Candidat candidat = new Candidat();
            candidat.setNom(nom.trim());
            candidat.setPrenom(prenom.trim());
            candidat.setEmail(email.trim().toLowerCase());
            candidat.setMotDePasse(motDePasse);
            candidat.setRole(Utilisateur.Role.CANDIDAT);

            if (domaineProfessionnel != null && !domaineProfessionnel.trim().isEmpty()) {
                candidat.setDomaineProfessionnel(domaineProfessionnel.trim());
            }

            candidat.setCv(cvFileName);
            candidat.setStatut(true);
            candidat.setEstVerifie(false);

            boolean created = utilisateurDAO.createCandidat(candidat);

            if (created) {
                result.put("success", true);
                result.put("message", "Candidat créé avec succès");
            } else {
                result.put("success", false);
                result.put("message", "Erreur lors de la création du candidat");

                deleteUploadedFile(cvFileName);
            }

            response.getWriter().write(gson.toJson(result));

        } catch (IllegalArgumentException e) {
            result.put("success", false);
            result.put("message", "Domaine professionnel invalide: " + e.getMessage());
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            response.getWriter().write(gson.toJson(result));

            deleteUploadedFile(cvFileName);

        } catch (Exception e) {
            e.printStackTrace();
            result.put("success", false);
            result.put("message", "Erreur serveur: " + e.getMessage());
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().write(gson.toJson(result));

            deleteUploadedFile(cvFileName);
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


    private void deleteUploadedFile(String fileName) {
        if (fileName != null) {
            try {
                String uploadPath = getServletContext().getRealPath("") + File.separator + UPLOAD_DIR;
                Files.deleteIfExists(Paths.get(uploadPath + File.separator + fileName));
            } catch (IOException e) {
                e.printStackTrace();
            }
        }
    }
}