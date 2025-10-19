// DownloadCertificationServlet.java
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
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;

@WebServlet("/admin/download-certification")
public class DownloadCertificationServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String fileName = request.getParameter("file");
        if (fileName == null || fileName.isEmpty()) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Nom de fichier manquant");
            return;
        }

        // Sécuriser le nom de fichier
        fileName = Paths.get(fileName).getFileName().toString();
        
        String uploadPath = getServletContext().getRealPath("") + File.separator + "certifications";
        Path filePath = Paths.get(uploadPath, fileName);

        if (!Files.exists(filePath) || !Files.isRegularFile(filePath)) {
            response.sendError(HttpServletResponse.SC_NOT_FOUND, "Fichier non trouvé");
            return;
        }

        // Configurer la réponse pour le téléchargement
        response.setContentType("application/pdf");
        response.setHeader("Content-Disposition", 
            "attachment; filename=\"" + fileName.substring(fileName.indexOf("_") + 1) + "\"");
        response.setContentLength((int) Files.size(filePath));

        // Stream le fichier
        try (FileInputStream in = new FileInputStream(filePath.toFile());
             OutputStream out = response.getOutputStream()) {
            
            byte[] buffer = new byte[4096];
            int bytesRead;
            while ((bytesRead = in.read(buffer)) != -1) {
                out.write(buffer, 0, bytesRead);
            }
        }
    }
}