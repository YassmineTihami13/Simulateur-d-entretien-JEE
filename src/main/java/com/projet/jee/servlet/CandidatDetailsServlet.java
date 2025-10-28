package com.projet.jee.servlet;

import com.projet.jee.dao.CandidatDAO;
import com.projet.jee.models.Candidat;
import com.google.gson.Gson;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.File;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;

@WebServlet("/admin/candidat-details")
public class CandidatDetailsServlet extends HttpServlet {

    private static final String CV_DIR = "cv";
    private CandidatDAO candidatDAO;
    private Gson gson;

    @Override
    public void init() throws ServletException {
        super.init();
        candidatDAO = new CandidatDAO();
        gson = new Gson();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");

        if ("downloadCV".equals(action)) {
            downloadCV(request, response);
            return;
        }

        getCandidatDetails(request, response);
    }


    private void getCandidatDetails(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        try {
            long candidatId = Long.parseLong(request.getParameter("id"));
            Candidat candidat = candidatDAO.getCandidatById(candidatId);

            if (candidat != null) {
                CandidatDetailsDTO detailsDTO = new CandidatDetailsDTO(candidat, request.getContextPath());
                response.getWriter().write(gson.toJson(detailsDTO));
            } else {
                response.setStatus(HttpServletResponse.SC_NOT_FOUND);
                response.getWriter().write("{\"error\": \"Candidat non trouvé\"}");
            }
        } catch (NumberFormatException e) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            response.getWriter().write("{\"error\": \"ID de candidat invalide\"}");
        } catch (Exception e) {
            e.printStackTrace();
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().write("{\"error\": \"Erreur serveur: " + e.getMessage() + "\"}");
        }
    }


    private void downloadCV(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            long candidatId = Long.parseLong(request.getParameter("id"));
            Candidat candidat = candidatDAO.getCandidatById(candidatId);

            if (candidat == null) {
                response.setStatus(HttpServletResponse.SC_NOT_FOUND);
                response.getWriter().write("Candidat non trouvé");
                return;
            }

            String cvFileName = candidat.getCv();
            if (cvFileName == null || cvFileName.isEmpty()) {
                response.setStatus(HttpServletResponse.SC_NOT_FOUND);
                response.getWriter().write("Aucun CV disponible pour ce candidat");
                return;
            }

            String uploadPath = getServletContext().getRealPath("") + File.separator + CV_DIR;
            Path cvPath = Paths.get(uploadPath, cvFileName);

            if (!Files.exists(cvPath)) {
                response.setStatus(HttpServletResponse.SC_NOT_FOUND);
                response.getWriter().write("Fichier CV introuvable sur le serveur");
                return;
            }

            String viewMode = request.getParameter("view");

            response.setContentType("application/pdf");
            response.setContentLengthLong(Files.size(cvPath));

            if ("inline".equals(viewMode)) {
                response.setHeader("Content-Disposition", "inline; filename=\"" + candidat.getCvFileName() + "\"");
            } else {
                response.setHeader("Content-Disposition", "attachment; filename=\"" + candidat.getCvFileName() + "\"");
            }

            Files.copy(cvPath, response.getOutputStream());
            response.getOutputStream().flush();

        } catch (NumberFormatException e) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            response.getWriter().write("ID de candidat invalide");
        } catch (Exception e) {
            e.printStackTrace();
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().write("Erreur lors de la récupération du CV: " + e.getMessage());
        }
    }


    public static class CandidatDetailsDTO {
        private long id;
        private String nom;
        private String prenom;
        private String email;
        private String domaineProfessionnel;
        private String domaineProfessionnelEnum;
        private String cvFileName;
        private String cvDownloadUrl;
        private String cvViewUrl;
        private boolean hasCv;
        private boolean statut;
        private boolean estVerifie;

        public CandidatDetailsDTO(Candidat candidat, String contextPath) {
            this.id = candidat.getId();
            this.nom = candidat.getNom();
            this.prenom = candidat.getPrenom();
            this.email = candidat.getEmail();

            this.domaineProfessionnel = candidat.getDomaineProfessionnelDisplayName();

            this.domaineProfessionnelEnum = candidat.getDomaineProfessionnelEnumName();

            this.cvFileName = candidat.getCvFileName();
            this.hasCv = candidat.hasCv();
            this.statut = candidat.getStatut();
            this.estVerifie = candidat.isEstVerifie();

            if (this.hasCv) {
                this.cvDownloadUrl = contextPath + "/admin/candidat-details?action=downloadCV&id=" + candidat.getId();
                this.cvViewUrl = contextPath + "/admin/candidat-details?action=downloadCV&id=" + candidat.getId() + "&view=inline";
            }
        }

        public long getId() { return id; }
        public String getNom() { return nom; }
        public String getPrenom() { return prenom; }
        public String getEmail() { return email; }
        public String getDomaineProfessionnel() { return domaineProfessionnel; }
        public String getDomaineProfessionnelEnum() { return domaineProfessionnelEnum; }
        public String getCvFileName() { return cvFileName; }
        public String getCvDownloadUrl() { return cvDownloadUrl; }
        public String getCvViewUrl() { return cvViewUrl; }
        public boolean isHasCv() { return hasCv; }
        public boolean isStatut() { return statut; }
        public boolean isEstVerifie() { return estVerifie; }
    }
}