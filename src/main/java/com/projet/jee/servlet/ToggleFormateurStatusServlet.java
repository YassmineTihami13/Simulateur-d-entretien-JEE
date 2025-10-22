package com.projet.jee.servlet;

import com.projet.jee.dao.FormateurDAO;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.SQLException;

@WebServlet("/admin/toggle-formateur-status")
public class ToggleFormateurStatusServlet extends HttpServlet {

    private FormateurDAO formateurDAO;

    @Override
    public void init() throws ServletException {
        super.init();
        formateurDAO = new FormateurDAO();
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        
        try {
            long formateurId = Long.parseLong(request.getParameter("id"));
            boolean newStatus = Boolean.parseBoolean(request.getParameter("status"));
            
            boolean success = formateurDAO.toggleFormateurStatus(formateurId, newStatus);
            
            if (success) {
                response.getWriter().write("{\"success\": true, \"message\": \"Statut modifié avec succès\"}");
            } else {
                response.setStatus(HttpServletResponse.SC_NOT_FOUND);
                response.getWriter().write("{\"success\": false, \"error\": \"Formateur non trouvé\"}");
            }
            
        } catch (NumberFormatException e) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            response.getWriter().write("{\"success\": false, \"error\": \"ID de formateur invalide\"}");
        } catch (SQLException e) {
            e.printStackTrace();
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().write("{\"success\": false, \"error\": \"Erreur base de données: " + e.getMessage() + "\"}");
        }
    }
}