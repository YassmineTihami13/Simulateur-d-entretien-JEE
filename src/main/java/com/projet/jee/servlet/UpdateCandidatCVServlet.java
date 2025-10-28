package com.projet.jee.servlet;

import com.projet.jee.dao.ProfileCandidatDAO;
import com.projet.jee.models.Candidat;

import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import javax.servlet.http.Part;
import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.nio.file.StandardCopyOption;
import java.util.UUID;

@WebServlet("/UpdateCandidatCVServlet")
@MultipartConfig(
        fileSizeThreshold = 1024 * 1024 * 1,  // 1 MB
        maxFileSize = 1024 * 1024 * 5,        // 5 MB
        maxRequestSize = 1024 * 1024 * 10     // 10 MB
)
public class UpdateCandidatCVServlet extends HttpServlet {
    private ProfileCandidatDAO profileCandidatDAO;
    private static final String UPLOAD_DIR = "cv";
    private static final long MAX_FILE_SIZE = 5 * 1024 * 1024; // 5 MB

    @Override
    public void init() throws ServletException {
        profileCandidatDAO = new ProfileCandidatDAO();
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);

        // Vérifier si l'utilisateur est connecté
        if (session == null || session.getAttribute("userId") == null) {
            response.sendRedirect(request.getContextPath() + "/jsp/login.jsp");
            return;
        }

        try {
            Long userId = (Long) session.getAttribute("userId");

            // Récupérer le candidat depuis la base de données
            Candidat candidat = profileCandidatDAO.getCandidatById(userId);

            if (candidat == null) {
                session.setAttribute("errorMessage", "Candidat introuvable");
                response.sendRedirect(request.getContextPath() + "/CandidatProfileServlet");
                return;
            }

            // Récupérer le fichier uploadé
            Part cvPart = request.getPart("cvFile");

            if (cvPart == null || cvPart.getSize() == 0) {
                session.setAttribute("errorMessage", "Veuillez sélectionner un fichier");
                response.sendRedirect(request.getContextPath() + "/CandidatProfileServlet");
                return;
            }

            // Vérifier la taille du fichier
            if (cvPart.getSize() > MAX_FILE_SIZE) {
                session.setAttribute("errorMessage", "Le fichier est trop volumineux (max 5 MB)");
                response.sendRedirect(request.getContextPath() + "/CandidatProfileServlet");
                return;
            }

            // Récupérer le nom du fichier
            String fileName = extractFileName(cvPart);

            if (fileName == null || fileName.trim().isEmpty()) {
                session.setAttribute("errorMessage", "Nom de fichier invalide");
                response.sendRedirect(request.getContextPath() + "/CandidatProfileServlet");
                return;
            }

            // Vérifier l'extension
            String fileExtension = "";
            int dotIndex = fileName.lastIndexOf(".");
            if (dotIndex > 0) {
                fileExtension = fileName.substring(dotIndex).toLowerCase();
            }

            if (!fileExtension.equals(".pdf") && !fileExtension.equals(".doc") && !fileExtension.equals(".docx")) {
                session.setAttribute("errorMessage", "Format de fichier non autorisé. Utilisez PDF, DOC ou DOCX");
                response.sendRedirect(request.getContextPath() + "/CandidatProfileServlet");
                return;
            }

            // Créer le répertoire d'upload s'il n'existe pas
            String uploadPath = getServletContext().getRealPath("") + File.separator + UPLOAD_DIR;
            File uploadDir = new File(uploadPath);
            if (!uploadDir.exists()) {
                uploadDir.mkdirs();
            }

            // Générer un nom de fichier unique
            String uniqueFileName = UUID.randomUUID().toString() + "_" + fileName;
            String filePath = uploadPath + File.separator + uniqueFileName;

            // Supprimer l'ancien CV s'il existe
            if (candidat.hasCv()) {
                String oldCvPath = uploadPath + File.separator + candidat.getCv();
                File oldCvFile = new File(oldCvPath);
                if (oldCvFile.exists()) {
                    oldCvFile.delete();
                    System.out.println("Ancien CV supprimé: " + oldCvPath);
                }
            }

            // Sauvegarder le nouveau fichier
            try (InputStream inputStream = cvPart.getInputStream()) {
                Files.copy(inputStream, Paths.get(filePath), StandardCopyOption.REPLACE_EXISTING);
                System.out.println("Nouveau CV enregistré: " + filePath);
            }

            // Mettre à jour uniquement le CV dans la base de données
            boolean updated = profileCandidatDAO.updateCandidatCV(userId, uniqueFileName);

            if (updated) {
                // Recharger le candidat avec les données fraîches
                Candidat updatedCandidat = profileCandidatDAO.getCandidatById(userId);
                session.setAttribute("candidat", updatedCandidat);
                session.setAttribute("successMessage", "CV mis à jour avec succès !");
            } else {
                // Supprimer le fichier uploadé en cas d'erreur
                new File(filePath).delete();
                session.setAttribute("errorMessage", "Erreur lors de la mise à jour du CV");
            }

        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("errorMessage", "Erreur lors de l'upload du CV: " + e.getMessage());
        }

        response.sendRedirect(request.getContextPath() + "/CandidatProfileServlet");
    }

    // Méthode pour extraire le nom du fichier depuis le header
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

    @Override
    public void destroy() {
        if (profileCandidatDAO != null) {
            profileCandidatDAO.closeConnection();
        }
    }
}