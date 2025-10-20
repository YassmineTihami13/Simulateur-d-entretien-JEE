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
import java.nio.file.Paths;
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

    private static final String UPLOAD_DIR = "uploads/cv";
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

            // Gérer l'upload du CV (si un nouveau fichier est fourni)
            String cvFileName = existingCandidat.getCv(); // Garder l'ancien par défaut
            Part cvPart = request.getPart("cv");

            if (cvPart != null && cvPart.getSize() > 0) {
                String fileName = Paths.get(cvPart.getSubmittedFileName()).getFileName().toString();

                // Vérifier l'extension
                if (!fileName.toLowerCase().endsWith(".pdf")) {
                    result.put("success", false);
                    result.put("message", "Seuls les fichiers PDF sont acceptés pour le CV");
                    response.getWriter().write(gson.toJson(result));
                    return;
                }

                // Supprimer l'ancien fichier CV s'il existe
                if (existingCandidat.getCv() != null && !existingCandidat.getCv().isEmpty()) {
                    String applicationPath = request.getServletContext().getRealPath("");
                    String oldFilePath = applicationPath + File.separator + UPLOAD_DIR +
                            File.separator + existingCandidat.getCv();
                    File oldFile = new File(oldFilePath);
                    if (oldFile.exists()) {
                        oldFile.delete();
                    }
                }

                // Générer un nom unique pour le nouveau fichier
                String uniqueFileName = UUID.randomUUID().toString() + "_" + fileName;

                // Créer le répertoire s'il n'existe pas
                String applicationPath = request.getServletContext().getRealPath("");
                String uploadPath = applicationPath + File.separator + UPLOAD_DIR;
                File uploadDir = new File(uploadPath);
                if (!uploadDir.exists()) {
                    uploadDir.mkdirs();
                }

                // Sauvegarder le nouveau fichier
                String filePath = uploadPath + File.separator + uniqueFileName;
                cvPart.write(filePath);
                cvFileName = uniqueFileName;
            }

            // Mettre à jour le candidat
            Candidat candidat = new Candidat();
            candidat.setId(candidatId);
            candidat.setNom(nom.trim());
            candidat.setPrenom(prenom.trim());
            candidat.setEmail(email.trim().toLowerCase());
            candidat.setDomaineProfessionnel(domaineProfessionnel != null ? domaineProfessionnel.trim() : null);
            candidat.setCv(cvFileName);

            // Si un nouveau mot de passe est fourni
            if (motDePasse != null && !motDePasse.trim().isEmpty()) {
                if (motDePasse.length() < 6) {
                    result.put("success", false);
                    result.put("message", "Le mot de passe doit contenir au moins 6 caractères");
                    response.getWriter().write(gson.toJson(result));
                    return;
                }
                candidat.setMotDePasse(motDePasse);
            }

            // Mettre à jour dans la base de données
            boolean updated = candidatDAO.updateCandidat(candidat, motDePasse != null && !motDePasse.trim().isEmpty());

            if (updated) {
                result.put("success", true);
                result.put("message", "Candidat modifié avec succès");
            } else {
                result.put("success", false);
                result.put("message", "Erreur lors de la modification du candidat");
            }

            response.getWriter().write(gson.toJson(result));

        } catch (NumberFormatException e) {
            result.put("success", false);
            result.put("message", "ID de candidat invalide");
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            response.getWriter().write(gson.toJson(result));
        } catch (Exception e) {
            e.printStackTrace();
            result.put("success", false);
            result.put("message", "Erreur serveur: " + e.getMessage());
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().write(gson.toJson(result));
        }
    }
}