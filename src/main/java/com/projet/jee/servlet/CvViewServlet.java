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

@WebServlet("/view-cv")
public class CvViewServlet extends HttpServlet {
    
    private static final String UPLOAD_DIR = "cv";

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String fileName = request.getParameter("file");
        
        System.out.println("Paramètre 'file' reçu pour CV: " + fileName);
        
        if (fileName == null || fileName.isEmpty()) {
            System.err.println("ERREUR: Nom de fichier manquant pour CV");
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Nom de fichier manquant");
            return;
        }

        fileName = java.net.URLDecoder.decode(fileName, "UTF-8");
        System.out.println("Nom de fichier CV décodé: " + fileName);

        if (fileName.contains("..") || fileName.contains("/") || fileName.contains("\\")) {
            System.err.println("ERREUR: Tentative d'accès non autorisé au CV: " + fileName);
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Accès non autorisé");
            return;
        }

        String uploadPath = getServletContext().getRealPath("") + File.separator + UPLOAD_DIR;
        File file = new File(uploadPath + File.separator + fileName);

        System.out.println("Chemin complet CV: " + file.getAbsolutePath());
        System.out.println("CV existe: " + file.exists());

        if (!file.exists()) {
            System.err.println("ERREUR: CV non trouvé: " + fileName);
            response.sendError(HttpServletResponse.SC_NOT_FOUND, "CV non trouvé: " + fileName);
            return;
        }

        response.setContentType("application/pdf");
        response.setHeader("Content-Disposition", "inline; filename=\"" + fileName + "\"");
        response.setContentLength((int) file.length());

        try (FileInputStream in = new FileInputStream(file);
             OutputStream out = response.getOutputStream()) {

            byte[] buffer = new byte[4096];
            int bytesRead;
            while ((bytesRead = in.read(buffer)) != -1) {
                out.write(buffer, 0, bytesRead);
            }
            
            System.out.println("CV envoyé avec succès: " + fileName);
            
        } catch (IOException e) {
            System.err.println("Erreur lors de l'envoi du CV: " + e.getMessage());
            throw e;
        }
    }
}