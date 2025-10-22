package com.projet.jee.servlet;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.OutputStream;

@WebServlet("/view-certificate")
public class CertificateViewServlet extends HttpServlet {
    
    private static final String UPLOAD_DIR = "certifications";

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String fileName = request.getParameter("file");
        
        // Log pour debug
        System.out.println("Paramètre 'file' reçu: " + fileName);
        
        if (fileName == null || fileName.isEmpty()) {
            System.err.println("ERREUR: Nom de fichier manquant");
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Nom de fichier manquant");
            return;
        }

        // Décoder le nom de fichier
        fileName = java.net.URLDecoder.decode(fileName, "UTF-8");
        System.out.println("Nom de fichier décodé: " + fileName);

        // Sécurité : vérifier que le fichier ne contient pas de chemins relatifs
        if (fileName.contains("..") || fileName.contains("/") || fileName.contains("\\")) {
            System.err.println("ERREUR: Tentative d'accès non autorisé: " + fileName);
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Accès non autorisé");
            return;
        }

        String uploadPath = getServletContext().getRealPath("") + File.separator + UPLOAD_DIR;
        File file = new File(uploadPath + File.separator + fileName);

        System.out.println("Chemin complet: " + file.getAbsolutePath());
        System.out.println("Fichier existe: " + file.exists());

        if (!file.exists()) {
            System.err.println("ERREUR: Fichier non trouvé: " + fileName);
            response.sendError(HttpServletResponse.SC_NOT_FOUND, "Fichier non trouvé: " + fileName);
            return;
        }

        // Définir les headers pour l'affichage PDF
        response.setContentType("application/pdf");
        response.setHeader("Content-Disposition", "inline; filename=\"" + fileName + "\"");
        response.setContentLength((int) file.length());

        // Stream le fichier vers la réponse
        try (FileInputStream in = new FileInputStream(file);
             OutputStream out = response.getOutputStream()) {

            byte[] buffer = new byte[4096];
            int bytesRead;
            while ((bytesRead = in.read(buffer)) != -1) {
                out.write(buffer, 0, bytesRead);
            }
            
            System.out.println("Fichier envoyé avec succès: " + fileName);
            
        } catch (IOException e) {
            System.err.println("Erreur lors de l'envoi du fichier: " + e.getMessage());
            throw e;
        }
    }
}