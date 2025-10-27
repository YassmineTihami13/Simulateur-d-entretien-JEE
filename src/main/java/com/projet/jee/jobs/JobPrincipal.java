package com.projet.jee.jobs;

import java.util.concurrent.Executors;
import java.util.concurrent.ScheduledExecutorService;
import java.util.concurrent.TimeUnit;
import javax.servlet.ServletContextEvent;
import javax.servlet.ServletContextListener;
import javax.servlet.annotation.WebListener;
import java.util.logging.Logger;

@WebListener
public class JobPrincipal implements ServletContextListener {

    private static final Logger logger = Logger.getLogger(JobPrincipal.class.getName());
    private ScheduledExecutorService scheduler;

    @Override
    public void contextInitialized(ServletContextEvent event) {
        logger.info("🚀 DÉMARRAGE - Job d'activation des évaluations");
        
        try {
            scheduler = Executors.newSingleThreadScheduledExecutor();
            
            // Pour les TESTS : Toutes les 2 minutes
            scheduler.scheduleAtFixedRate(new ActivationEvaluationJob(), 0, 2, TimeUnit.MINUTES);
            
            // Pour la PRODUCTION : Toutes les heures
            // scheduler.scheduleAtFixedRate(new ActivationEvaluationJob(), 0, 1, TimeUnit.HOURS);
            
            logger.info("✅ Job programmé avec succès - Exécution toutes les 2 minutes");
            
        } catch (Exception e) {
            logger.severe("❌ Erreur lors du démarrage du job: " + e.getMessage());
        }
    }

    @Override
    public void contextDestroyed(ServletContextEvent event) {
        logger.info("🛑 ARRÊT - Job d'activation des évaluations");
        if (scheduler != null && !scheduler.isShutdown()) {
            try {
                scheduler.shutdownNow();
                logger.info("✅ Job arrêté avec succès");
            } catch (Exception e) {
                logger.severe("❌ Erreur lors de l'arrêt du job: " + e.getMessage());
            }
        }
    }
}