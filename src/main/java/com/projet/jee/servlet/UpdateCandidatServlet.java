package com.projet.jee.servlet;

import com.projet.jee.dao.CandidatDAO;
import com.projet.jee.dao.UtilisateurDAO;
import com.projet.jee.models.Candidat;
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

@WebServlet("/admin/update-candidat")
@MultipartConfig(
        fileSizeThreshold = 1024 * 1024 * 2,  // 2MB
        maxFileSize = 1024 * 1024 * 10,       // 10MB
        maxRequestSize = 1024 * 1024 * 50     // 50MB
)
public class UpdateCandidatServlet extends HttpServlet {

    private static final String UPLOAD_DIR = "cv"; // Correspond à RegisterCandidatServlet
    private CandidatDAO candidatDAO;
    private UtilisateurDAO utilisateurDAO;
    private Gson gson;

    @Override
    public void init() throws ServletException {
        super.init();
        candidatDAO = new CandidatDAO();
        utilisateurDAO = new UtilisateurDAO();
        gson = new Gson();
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        Map<String, Object> result = new HashMap<>();
        String newCvFileName = null;

        try {
            // Récupérer l'ID du candidat
            long candidatId = Long.parseLong(request.getParameter("id"));

            // Vérifier si le candidat existe
            Candidat existingCandidat = candidatDAO.getCandidatById(candidatId);
            if (existingCandidat == null) {
                result.put("success", false);
                result.put("message", "Candidat non trouvé");
                response.getWriter().write(gson.toJson(result));
                return;
            }

            // Récupérer les données du formulaire
            String nom = request.getParameter("nom");
            String prenom = request.getParameter("prenom");
            String email = request.getParameter("email");
            String domaineProfessionnel = request.getParameter("domaineProfessionnel");
            String motDePasse = request.getParameter("motDePasse");

            // Validation des champs obligatoires
            if (nom == null || nom.trim().isEmpty() ||
                    prenom == null || prenom.trim().isEmpty() ||
                    email == null || email.trim().isEmpty()) {

                result.put("success", false);
                result.put("message", "Les champs nom, prénom et email sont obligatoires");
                response.getWriter().write(gson.toJson(result));
                return;
            }

            // Vérifier si l'email existe déjà pour un autre utilisateur
            if (!email.equalsIgnoreCase(existingCandidat.getEmail())) {
                if (utilisateurDAO.emailExists(email)) {
                    result.put("success", false);
                    result.put("message", "Cet email est déjà utilisé par un autre utilisateur");
                    response.getWriter().write(gson.toJson(result));
                    return;
                }
            }

            // Valider le domaine professionnel (si fourni)
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

            // Gérer l'upload du CV (si un nouveau fichier est fourni)
            String cvFileName = existingCandidat.getCv(); // Garder l'ancien par défaut
            Part cvPart = request.getPart("cv");

            if (cvPart != null && cvPart.getSize() > 0) {
                String fileName = extractFileName(cvPart);

                // Vérifier l'extension
                if (fileName == null || !fileName.toLowerCase().endsWith(".pdf")) {
                    result.put("success", false);
                    result.put("message", "Seuls les fichiers PDF sont acceptés pour le CV");
                    response.getWriter().write(gson.toJson(result));
                    return;
                }

                // Supprimer l'ancien fichier CV s'il existe
                if (existingCandidat.getCv() != null && !existingCandidat.getCv().isEmpty()) {
                    deleteUploadedFile(existingCandidat.getCv());
                }

                // Créer le répertoire s'il n'existe pas
                String uploadPath = getServletContext().getRealPath("") + File.separator + UPLOAD_DIR;
                File uploadDir = new File(uploadPath);
                if (!uploadDir.exists()) {
                    uploadDir.mkdir();
                }

                // Générer un nom unique pour le nouveau fichier
                String uniqueFileName = UUID.randomUUID().toString() + "_" + fileName;
                String filePath = uploadPath + File.separator + uniqueFileName;

                // Sauvegarder le nouveau fichier
                try (InputStream inputStream = cvPart.getInputStream()) {
                    Files.copy(inputStream, Paths.get(filePath), StandardCopyOption.REPLACE_EXISTING);
                    cvFileName = uniqueFileName;
                    newCvFileName = uniqueFileName;
                }
            }

            // Mettre à jour le candidat
            Candidat candidat = new Candidat();
            candidat.setId(candidatId);
            candidat.setNom(nom.trim());
            candidat.setPrenom(prenom.trim());
            candidat.setEmail(email.trim().toLowerCase());

            // Définir le domaine professionnel (utilise l'enum)
            if (domaineProfessionnel != null && !domaineProfessionnel.trim().isEmpty()) {
                candidat.setDomaineProfessionnel(domaineProfessionnel.trim());
            }

            candidat.setCv(cvFileName);

            // Déterminer si on met à jour le mot de passe
            boolean updatePassword = false;
            if (motDePasse != null && !motDePasse.trim().isEmpty()) {
                if (motDePasse.length() < 6) {
                    result.put("success", false);
                    result.put("message", "Le mot de passe doit contenir au moins 6 caractères");

                    // Supprimer le nouveau CV en cas d'erreur
                    if (newCvFileName != null) {
                        deleteUploadedFile(newCvFileName);
                    }

                    response.getWriter().write(gson.toJson(result));
                    return;
                }
                candidat.setMotDePasse(motDePasse);
                updatePassword = true;
            }

            // Mettre à jour dans la base de données
            boolean updated = candidatDAO.updateCandidat(candidat, updatePassword);

            if (updated) {
                result.put("success", true);
                result.put("message", "Candidat modifié avec succès");
            } else {
                result.put("success", false);
                result.put("message", "Erreur lors de la modification du candidat");

                // Supprimer le nouveau CV et restaurer l'ancien en cas d'erreur
                if (newCvFileName != null) {
                    deleteUploadedFile(newCvFileName);
                }
            }

            response.getWriter().write(gson.toJson(result));

        } catch (NumberFormatException e) {
            result.put("success", false);
            result.put("message", "ID de candidat invalide");
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            response.getWriter().write(gson.toJson(result));

            // Supprimer le nouveau CV
            if (newCvFileName != null) {
                deleteUploadedFile(newCvFileName);
            }

        } catch (IllegalArgumentException e) {
            result.put("success", false);
            result.put("message", "Domaine professionnel invalide: " + e.getMessage());
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            response.getWriter().write(gson.toJson(result));

            // Supprimer le nouveau CV
            if (newCvFileName != null) {
                deleteUploadedFile(newCvFileName);
            }

        } catch (Exception e) {
            e.printStackTrace();
            result.put("success", false);
            result.put("message", "Erreur serveur: " + e.getMessage());
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().write(gson.toJson(result));

            // Supprimer le nouveau CV en cas d'erreur
            if (newCvFileName != null) {
                deleteUploadedFile(newCvFileName);
            }
        }
    }

    /**
     * Extrait le nom du fichier depuis la partie multipart
     */
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

    /**
     * Supprime un fichier uploadé
     */
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