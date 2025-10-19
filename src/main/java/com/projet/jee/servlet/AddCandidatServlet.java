package com.projet.jee.servlet;

import com.projet.jee.dao.UtilisateurDAO;
import com.projet.jee.model.Candidat;
import com.projet.jee.model.Utilisateur;
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

@WebServlet("/admin/add-candidat")
@MultipartConfig(
        fileSizeThreshold = 1024 * 1024 * 2,  // 2MB
        maxFileSize = 1024 * 1024 * 10,       // 10MB
        maxRequestSize = 1024 * 1024 * 50     // 50MB
)
public class AddCandidatServlet extends HttpServlet {

    private static final String UPLOAD_DIR = "uploads/cv";
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

        try {
            // Récupérer les données du formulaire
            String nom = request.getParameter("nom");
            String prenom = request.getParameter("prenom");
            String email = request.getParameter("email");
            String motDePasse = request.getParameter("motDePasse");
            String domaineProfessionnel = request.getParameter("domaineProfessionnel");

            // Validation des champs obligatoires
            if (nom == null || nom.trim().isEmpty() ||
                    prenom == null || prenom.trim().isEmpty() ||
                    email == null || email.trim().isEmpty() ||
                    motDePasse == null || motDePasse.length() < 6) {

                result.put("success", false);
                result.put("message", "Tous les champs obligatoires doivent être remplis");
                response.getWriter().write(gson.toJson(result));
                return;
            }

            // Vérifier si l'email existe déjà
            if (utilisateurDAO.emailExists(email)) {
                result.put("success", false);
                result.put("message", "Cet email est déjà utilisé");
                response.getWriter().write(gson.toJson(result));
                return;
            }

            // Gérer l'upload du CV
            String cvFileName = null;
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

                // Générer un nom unique pour le fichier
                String uniqueFileName = UUID.randomUUID().toString() + "_" + fileName;

                // Créer le répertoire s'il n'existe pas
                String applicationPath = request.getServletContext().getRealPath("");
                String uploadPath = applicationPath + File.separator + UPLOAD_DIR;
                File uploadDir = new File(uploadPath);
                if (!uploadDir.exists()) {
                    uploadDir.mkdirs();
                }

                // Sauvegarder le fichier
                String filePath = uploadPath + File.separator + uniqueFileName;
                cvPart.write(filePath);
                cvFileName = uniqueFileName;
            }

            // Créer le candidat
            Candidat candidat = new Candidat();
            candidat.setNom(nom.trim());
            candidat.setPrenom(prenom.trim());
            candidat.setEmail(email.trim().toLowerCase());
            candidat.setMotDePasse(motDePasse); // Le DAO doit hasher le mot de passe
            candidat.setRole(Utilisateur.Role.CANDIDAT);
            candidat.setDomaineProfessionnel(domaineProfessionnel != null ? domaineProfessionnel.trim() : null);
            candidat.setCv(cvFileName);
            candidat.setStatut(true); // Actif par défaut
            candidat.setEstVerifie(false); // Non vérifié par défaut

            // Enregistrer dans la base de données
            boolean created = utilisateurDAO.createCandidat(candidat);

            if (created) {
                result.put("success", true);
                result.put("message", "Candidat créé avec succès");
            } else {
                result.put("success", false);
                result.put("message", "Erreur lors de la création du candidat");

                // Supprimer le fichier uploadé en cas d'erreur
                if (cvFileName != null) {
                    String applicationPath = request.getServletContext().getRealPath("");
                    String filePath = applicationPath + File.separator + UPLOAD_DIR + File.separator + cvFileName;
                    File file = new File(filePath);
                    if (file.exists()) {
                        file.delete();
                    }
                }
            }

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