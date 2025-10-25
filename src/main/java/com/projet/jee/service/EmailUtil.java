package com.projet.jee.service;

import javax.mail.*;
import javax.mail.internet.*;
import java.util.Properties;
import java.util.Random;

public class EmailUtil {

    private static final String SMTP_HOST = "smtp.gmail.com";
    private static final String SMTP_PORT = "587";
    private static final String EMAIL_FROM = "tihami.yassmine@etu.uae.ac.ma";
    private static final String EMAIL_PASSWORD = "jbbvokuenrhwrafe";

    public static String generateVerificationCode() {
        Random random = new Random();
        int code = 100000 + random.nextInt(900000);
        return String.valueOf(code);
    }

    public static boolean sendVerificationEmail(String toEmail, String userName, String verificationCode) {
        Properties props = new Properties();
        props.put("mail.smtp.auth", "true");
        props.put("mail.smtp.starttls.enable", "true");
        props.put("mail.smtp.host", SMTP_HOST);
        props.put("mail.smtp.port", SMTP_PORT);
        props.put("mail.smtp.ssl.trust", SMTP_HOST);
        props.put("mail.smtp.ssl.protocols", "TLSv1.2");

        Session session = Session.getInstance(props, new Authenticator() {
            @Override
            protected PasswordAuthentication getPasswordAuthentication() {
                return new PasswordAuthentication(EMAIL_FROM, EMAIL_PASSWORD);
            }
        });

        try {
            Message message = new MimeMessage(session);
            message.setFrom(new InternetAddress(EMAIL_FROM, "Simulateur d'Entretien"));
            message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(toEmail));
            message.setSubject("Code de vérification - Inscription Formateur");

            String htmlContent = buildEmailTemplate(userName, verificationCode);
            message.setContent(htmlContent, "text/html; charset=utf-8");

            Transport.send(message);
            return true;

        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    private static String buildEmailTemplate(String userName, String code) {
        return "<!DOCTYPE html>" +
                "<html>" +
                "<head>" +
                "<style>" +
                "body { font-family: Arial, sans-serif; background-color: #f5f0ff; margin: 0; padding: 20px; }" +
                ".container { max-width: 600px; margin: 0 auto; background: white; border-radius: 16px; overflow: hidden; box-shadow: 0 4px 20px rgba(0,0,0,0.1); }" +
                ".header { background: linear-gradient(135deg, #667eea 0%, #b39ddb 100%); padding: 40px 20px; text-align: center; }" +
                ".header h1 { color: white; margin: 0; font-size: 28px; }" +
                ".content { padding: 40px 30px; }" +
                ".code-box { background: linear-gradient(135deg, #f5f0ff 0%, #fff9f0 100%); border-left: 4px solid #b39ddb; padding: 20px; margin: 30px 0; border-radius: 8px; text-align: center; }" +
                ".code { font-size: 36px; font-weight: bold; color: #667eea; letter-spacing: 8px; margin: 10px 0; }" +
                ".info { color: #666; line-height: 1.6; margin: 20px 0; }" +
                ".warning { background: #fff3cd; border-left: 4px solid #ffc107; padding: 15px; margin: 20px 0; border-radius: 8px; color: #856404; }" +
                ".footer { background: #f8f9fa; padding: 20px; text-align: center; color: #999; font-size: 14px; }" +
                "</style>" +
                "</head>" +
                "<body>" +
                "<div class='container'>" +
                "<div class='header'>" +
                "<h1>🎯 Vérification de votre compte</h1>" +
                "</div>" +
                "<div class='content'>" +
                "<p class='info'>Bonjour <strong>" + userName + "</strong>,</p>" +
                "<p class='info'>Merci de vous être inscrit sur notre plateforme ! Pour finaliser votre inscription, veuillez utiliser le code de vérification ci-dessous :</p>" +
                "<div class='code-box'>" +
                "<p style='margin: 0; color: #666; font-size: 14px;'>Votre code de vérification</p>" +
                "<div class='code'>" + code + "</div>" +
                "<p style='margin: 0; color: #999; font-size: 13px;'>Ce code est valide pendant 15 minutes</p>" +
                "</div>" +
                "<p class='info'>Entrez ce code sur la page de vérification pour activer votre compte formateur.</p>" +
                "<div class='warning'>" +
                "<strong>⚠️ Important :</strong> Si vous n'avez pas demandé cette inscription, veuillez ignorer cet email." +
                "</div>" +
                "</div>" +
                "<div class='footer'>" +
                "<p>© 2025 Simulateur d'Entretien - Tous droits réservés</p>" +
                "<p>Cet email a été envoyé automatiquement, merci de ne pas y répondre.</p>" +
                "</div>" +
                "</div>" +
                "</body>" +
                "</html>";
    }

    public static boolean sendVerificationEmailCandidat(String toEmail, String userName, String verificationCode) {
        Properties props = new Properties();
        props.put("mail.smtp.auth", "true");
        props.put("mail.smtp.starttls.enable", "true");
        props.put("mail.smtp.host", SMTP_HOST);
        props.put("mail.smtp.port", SMTP_PORT);
        props.put("mail.smtp.ssl.trust", SMTP_HOST);
        props.put("mail.smtp.ssl.protocols", "TLSv1.2");

        Session session = Session.getInstance(props, new Authenticator() {
            @Override
            protected PasswordAuthentication getPasswordAuthentication() {
                return new PasswordAuthentication(EMAIL_FROM, EMAIL_PASSWORD);
            }
        });

        try {
            Message message = new MimeMessage(session);
            message.setFrom(new InternetAddress(EMAIL_FROM, "Simulateur d'Entretien"));
            message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(toEmail));
            message.setSubject("Code de vérification - Inscription Candidat");

            String htmlContent = buildEmailTemplateCandidat(userName, verificationCode);
            message.setContent(htmlContent, "text/html; charset=utf-8");

            Transport.send(message);
            return true;

        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    private static String buildEmailTemplateCandidat(String userName, String code) {
        return "<!DOCTYPE html>" +
                "<html>" +
                "<head>" +
                "<style>" +
                "body { font-family: Arial, sans-serif; background-color: #f0f8ff; margin: 0; padding: 20px; }" +
                ".container { max-width: 600px; margin: 0 auto; background: white; border-radius: 16px; overflow: hidden; box-shadow: 0 4px 20px rgba(0,0,0,0.1); }" +
                ".header { background: linear-gradient(135deg, #4CAF50 0%, #81C784 100%); padding: 40px 20px; text-align: center; }" +
                ".header h1 { color: white; margin: 0; font-size: 28px; }" +
                ".content { padding: 40px 30px; }" +
                ".code-box { background: linear-gradient(135deg, #f0f8ff 0%, #f9f9f9 100%); border-left: 4px solid #4CAF50; padding: 20px; margin: 30px 0; border-radius: 8px; text-align: center; }" +
                ".code { font-size: 36px; font-weight: bold; color: #4CAF50; letter-spacing: 8px; margin: 10px 0; }" +
                ".info { color: #666; line-height: 1.6; margin: 20px 0; }" +
                ".warning { background: #fff3cd; border-left: 4px solid #ffc107; padding: 15px; margin: 20px 0; border-radius: 8px; color: #856404; }" +
                ".footer { background: #f8f9fa; padding: 20px; text-align: center; color: #999; font-size: 14px; }" +
                "</style>" +
                "</head>" +
                "<body>" +
                "<div class='container'>" +
                "<div class='header'>" +
                "<h1>🎯 Vérification de votre compte Candidat</h1>" +
                "</div>" +
                "<div class='content'>" +
                "<p class='info'>Bonjour <strong>" + userName + "</strong>,</p>" +
                "<p class='info'>Merci de vous être inscrit sur notre plateforme ! Pour finaliser votre inscription, veuillez utiliser le code de vérification ci-dessous :</p>" +
                "<div class='code-box'>" +
                "<p style='margin: 0; color: #666; font-size: 14px;'>Votre code de vérification</p>" +
                "<div class='code'>" + code + "</div>" +
                "<p style='margin: 0; color: #999; font-size: 13px;'>Ce code est valide pendant 15 minutes</p>" +
                "</div>" +
                "<p class='info'>Entrez ce code sur la page de vérification pour activer votre compte candidat.</p>" +
                "<div class='warning'>" +
                "<strong>⚠️ Important :</strong> Si vous n'avez pas demandé cette inscription, veuillez ignorer cet email." +
                "</div>" +
                "</div>" +
                "<div class='footer'>" +
                "<p>© 2025 Simulateur d'Entretien - Tous droits réservés</p>" +
                "<p>Cet email a été envoyé automatiquement, merci de ne pas y répondre.</p>" +
                "</div>" +
                "</div>" +
                "</body>" +
                "</html>";
    }

    public static boolean sendReservationAcceptedEmail(String toEmail, String candidatName, String formateurName, com.projet.jee.models.Reservation reservation) {
        String subject = "Votre réservation a été acceptée - Détails de la session";
        
        // Debug: afficher les informations de la réservation
        System.out.println("=== DEBUG EMAIL ===");
        System.out.println("Envoi email à: " + toEmail);
        System.out.println("Candidat: " + candidatName);
        System.out.println("Formateur: " + formateurName);
        System.out.println("Lien de session: " + (reservation != null ? reservation.getSessionLink() : "NULL"));
        System.out.println("Date: " + (reservation != null ? reservation.getDateReservation() : "NULL"));
        System.out.println("===================");
        
        String html = buildReservationAcceptedTemplate(candidatName, formateurName, reservation);
        return sendHtmlEmail(toEmail, subject, html);
    }

    public static boolean sendReservationRejectedEmail(String toEmail, String candidatName, String formateurName, com.projet.jee.models.Reservation reservation, String reason) {
        String subject = "Votre réservation a été refusée";
        String html = buildReservationRejectedTemplate(candidatName, formateurName, reservation, reason);
        return sendHtmlEmail(toEmail, subject, html);
    }

    /* Méthode utilitaire pour envoyer HTML (réutilise la configuration SMTP existante) */
    private static boolean sendHtmlEmail(String toEmail, String subject, String htmlContent) {
        try {
            Properties props = new Properties();
            props.put("mail.smtp.auth", "true");
            props.put("mail.smtp.starttls.enable", "true");
            props.put("mail.smtp.host", SMTP_HOST);
            props.put("mail.smtp.port", SMTP_PORT);
            props.put("mail.smtp.ssl.trust", SMTP_HOST);

            Session session = Session.getInstance(props, new javax.mail.Authenticator() {
                protected javax.mail.PasswordAuthentication getPasswordAuthentication() {
                    return new javax.mail.PasswordAuthentication(EMAIL_FROM, EMAIL_PASSWORD);
                }
            });
            session.setDebug(false);

            Message message = new MimeMessage(session);
            message.setFrom(new InternetAddress(EMAIL_FROM, "InterviewPro"));
            message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(toEmail));
            message.setSubject(subject);
            message.setContent(htmlContent, "text/html; charset=utf-8");

            Transport.send(message);
            System.out.println("Email envoyé avec succès à: " + toEmail);
            return true;
        } catch (Exception e) {
            System.err.println("Erreur lors de l'envoi de l'email: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }

    /* Template pour l'acceptation avec lien de session */
    private static String buildReservationAcceptedTemplate(String candidatName, String formateurName, com.projet.jee.models.Reservation r) {
        String date = r.getDateReservation() != null ? r.getDateReservation().toString() : "-";
        String sessionLink = r.getSessionLink() != null ? r.getSessionLink() : "Lien non disponible";
        
        // Debug dans le template
        System.out.println("Construction template avec lien: " + sessionLink);
        
        return "<!DOCTYPE html>" +
                "<html>" +
                "<head>" +
                "<style>" +
                "body { font-family: Arial, sans-serif; background-color: #f0f8ff; margin: 0; padding: 20px; }" +
                ".container { max-width: 600px; margin: 0 auto; background: white; border-radius: 16px; overflow: hidden; box-shadow: 0 4px 20px rgba(0,0,0,0.1); }" +
                ".header { background: linear-gradient(135deg, #4CAF50 0%, #81C784 100%); padding: 40px 20px; text-align: center; }" +
                ".header h1 { color: white; margin: 0; font-size: 28px; }" +
                ".content { padding: 40px 30px; }" +
                ".session-box { background: linear-gradient(135deg, #e3f2fd 0%, #f3e5f5 100%); border-left: 4px solid #2196F3; padding: 25px; margin: 25px 0; border-radius: 12px; }" +
                ".btn-primary { background: #2196F3; color: white; padding: 14px 28px; text-decoration: none; border-radius: 8px; display: inline-block; margin: 15px 0; font-weight: bold; font-size: 16px; text-align: center; border: none; cursor: pointer; }" +
                ".btn-primary:hover { background: #1976D2; }" +
                ".info { color: #666; line-height: 1.6; margin: 15px 0; }" +
                ".session-link { background: #f8f9fa; padding: 12px; border-radius: 6px; margin: 10px 0; word-break: break-all; font-size: 14px; color: #2196F3; }" +
                ".footer { background: #f8f9fa; padding: 20px; text-align: center; color: #999; font-size: 14px; }" +
                ".action-section { text-align: center; margin: 20px 0; }" +
                "</style>" +
                "</head>" +
                "<body>" +
                "<div class='container'>" +
                "<div class='header'>" +
                "<h1>✅ Réservation Confirmée</h1>" +
                "</div>" +
                "<div class='content'>" +
                "<p class='info'>Bonjour <strong>" + candidatName + "</strong>,</p>" +
                "<p class='info'>Félicitations ! Votre réservation a été <strong>acceptée</strong> par " + formateurName + ".</p>" +
                "<div class='session-box'>" +
                "<h3 style='margin-top:0; color:#2196F3; text-align: center;'>📅 Détails de la session</h3>" +
                "<p><strong>Date :</strong> " + date + "</p>" +
                "<p><strong>Durée :</strong> " + r.getDuree() + " heure(s)</p>" +
                "<p><strong>Prix :</strong> " + r.getPrix() + " MAD</p>" +
                "<p><strong>Formateur :</strong> " + formateurName + "</p>" +
                "<div style='margin: 20px 0;'>" +
                "<p><strong>Lien de la session :</strong></p>" +
                "<div class='session-link'>" + sessionLink + "</div>" +
                "</div>" +
                "</div>" +
                "<div class='action-section'>" +
                "<p style='margin-bottom: 15px;'><strong>Cliquez sur le bouton ci-dessous pour rejoindre la session :</strong></p>" +
                "<a href='" + sessionLink + "' class='btn-primary' target='_blank' style='text-decoration: none;'>" +
                "🚀 Rejoindre la session" +
                "</a>" +
                "</div>" +
                "<p class='info'>💡 <strong>Conseil :</strong> Testez le lien avant la session et assurez-vous d'être ponctuel.</p>" +
                "<p class='info'>Bonne préparation pour votre entretien !</p>" +
                "</div>" +
                "<div class='footer'>" +
                "<p>© 2025 Simulateur d'Entretien - Tous droits réservés</p>" +
                "</div>" +
                "</div>" +
                "</body>" +
                "</html>";
    }

    private static String buildReservationRejectedTemplate(String candidatName, String formateurName, com.projet.jee.models.Reservation r, String reason) {
        String date = r.getDateReservation() != null ? r.getDateReservation().toString() : "-";
        return "<html><body>" +
                "<h2>Bonjour " + candidatName + ",</h2>" +
                "<p>Nous sommes désolés — votre réservation pour le " + date + " a été <strong>refusée</strong> par " + formateurName + ".</p>" +
                "<p><strong>Raison :</strong> " + reason + "</p>" +
                "<p>N'hésitez pas à proposer un autre créneau.</p>" +
                "<p>Cordialement,<br/>L'équipe InterviewPro</p>" +
                "</body></html>";
    }
}