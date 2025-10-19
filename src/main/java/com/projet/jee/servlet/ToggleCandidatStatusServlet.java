package com.projet.jee.servlet;

import com.projet.jee.dao.CandidatDAO;
import com.google.gson.Gson;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.HashMap;
import java.util.Map;

@WebServlet("/admin/toggle-candidat-status")
public class ToggleCandidatStatusServlet extends HttpServlet {

    private CandidatDAO candidatDAO;
    private Gson gson;

    @Override
    public void init() throws ServletException {
        super.init();
        candidatDAO = new CandidatDAO();
        gson = new Gson();
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        try {
            long candidatId = Long.parseLong(request.getParameter("id"));
            boolean newStatus = Boolean.parseBoolean(request.getParameter("status"));

            boolean success = candidatDAO.toggleCandidatStatus(candidatId, newStatus);

            Map<String, Object> result = new HashMap<>();
            result.put("success", success);
            if (success) {
                result.put("message", "Statut du candidat modifié avec succès");
            } else {
                result.put("error", "Impossible de modifier le statut du candidat");
            }

            response.getWriter().write(gson.toJson(result));

        } catch (NumberFormatException e) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            Map<String, Object> error = new HashMap<>();
            error.put("success", false);
            error.put("error", "Paramètres invalides");
            response.getWriter().write(gson.toJson(error));
        } catch (Exception e) {
            e.printStackTrace();
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            Map<String, Object> error = new HashMap<>();
            error.put("success", false);
            error.put("error", "Erreur serveur: " + e.getMessage());
            response.getWriter().write(gson.toJson(error));
        }
    }
}