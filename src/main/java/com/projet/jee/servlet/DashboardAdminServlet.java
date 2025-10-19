package com.projet.jee.servlet;

import com.projet.jee.dao.DashboardAdminDAO;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.SQLException;
import java.util.Map;

@WebServlet("/admin/dashboard-data")
public class DashboardAdminServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        response.setContentType("application/json;charset=UTF-8");
        response.setCharacterEncoding("UTF-8");
        
        int months = 6;
        String monthsParam = request.getParameter("months");
        try {
            if (monthsParam != null) months = Integer.parseInt(monthsParam);
        } catch (NumberFormatException ignored) {}

        try (PrintWriter out = response.getWriter()) {
            // 🔹 Récupérer UNIQUEMENT les données liées à la BD
            int nbCandidats = DashboardAdminDAO.getNombreCandidats();
            int nbFormateurs = DashboardAdminDAO.getNombreFormateurs();
            int totalUtilisateurs = DashboardAdminDAO.getTotalUtilisateurs();
            Map<String, Integer> formateursParSpec = DashboardAdminDAO.getFormateursParSpecialite();
            Map<String, Integer> nouveauxParMois = DashboardAdminDAO.getNouveauxUtilisateursParMois(months);

            // Construire JSON
            StringBuilder sb = new StringBuilder();
            sb.append("{");
            sb.append("\"success\":true,");
            sb.append("\"nombreCandidats\":").append(nbCandidats).append(",");
            sb.append("\"nombreFormateurs\":").append(nbFormateurs).append(",");
            sb.append("\"totalUtilisateurs\":").append(totalUtilisateurs).append(",");

            // formateursParSpecialite
            sb.append("\"formateursParSpecialite\":{");
            boolean first = true;
            for (Map.Entry<String, Integer> e : formateursParSpec.entrySet()) {
                if (!first) sb.append(",");
                sb.append("\"").append(escapeJson(e.getKey())).append("\":").append(e.getValue());
                first = false;
            }
            sb.append("},");

            // nouveauxParMois
            sb.append("\"nouveauxParMois\":[");
            first = true;
            for (Map.Entry<String, Integer> e : nouveauxParMois.entrySet()) {
                if (!first) sb.append(",");
                sb.append("{\"month\":\"").append(escapeJson(e.getKey())).append("\",\"count\":").append(e.getValue()).append("}");
                first = false;
            }
            sb.append("]");
            sb.append("}");
            
            out.print(sb.toString());
            
        } catch (SQLException e) {
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().print("{\"success\":false,\"error\":\"" + escapeJson(e.getMessage()) + "\"}");
        }
    }

    private String escapeJson(String s) {
        if (s == null) return "";
        return s.replace("\"", "\\\"")
                .replace("\n", "\\n")
                .replace("\r", "\\r")
                .replace("\t", "\\t");
    }
}