package com.projet.jee.servlet;

import com.projet.jee.dao.CandidatDAO;
import com.projet.jee.model.Candidat;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

@WebServlet("/admin/candidats")
public class CandidatManagementServlet extends HttpServlet {

    private CandidatDAO candidatDAO;

    @Override
    public void init() throws ServletException {
        super.init();
        candidatDAO = new CandidatDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            List<Candidat> candidats = candidatDAO.getAllCandidats();
            request.setAttribute("candidats", candidats);
            request.getRequestDispatcher("/jsp/adminCandidats.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Erreur lors du chargement des candidats: " + e.getMessage());
            request.getRequestDispatcher("/jsp/adminCandidats.jsp").forward(request, response);
        }
    }
}