package com.projet.jee.servlet;

import com.projet.jee.dao.CandidatDAO;
import com.projet.jee.models.Candidat;
import com.google.gson.Gson;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet("/admin/candidat-details")
public class CandidatDetailsServlet extends HttpServlet {

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
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        try {
            long candidatId = Long.parseLong(request.getParameter("id"));
            Candidat candidat = candidatDAO.getCandidatById(candidatId);

            if (candidat != null) {
                CandidatDetailsDTO detailsDTO = new CandidatDetailsDTO(candidat);
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

    public static class CandidatDetailsDTO {
        private long id;
        private String nom;
        private String prenom;
        private String email;
        private String domaineProfessionnel;
        private String cvFileName;
        private boolean hasCv;
        private boolean statut;
        private boolean estVerifie;

        public CandidatDetailsDTO(Candidat candidat) {
            this.id = candidat.getId();
            this.nom = candidat.getNom();
            this.prenom = candidat.getPrenom();
            this.email = candidat.getEmail();
            this.domaineProfessionnel = candidat.getDomaineProfessionnel();
            this.cvFileName = candidat.getCvFileName();
            this.hasCv = candidat.hasCv();
            this.statut = candidat.getStatut();
            this.estVerifie = candidat.isEstVerifie();
        }

        public long getId() { return id; }
        public String getNom() { return nom; }
        public String getPrenom() { return prenom; }
        public String getEmail() { return email; }
        public String getDomaineProfessionnel() { return domaineProfessionnel; }
        public String getCvFileName() { return cvFileName; }
        public boolean isHasCv() { return hasCv; }
        public boolean isStatut() { return statut; }
        public boolean isEstVerifie() { return estVerifie; }
    }
}