/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package utils;

import javax.mail.*;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeMessage;
import java.nio.charset.StandardCharsets;
import java.util.Properties;

/**
 *
 * @author tayho
 */
public class EmailUtil {

    // Return true if sent; throw/return false to let caller show a generic error
    public static boolean send(String smtpHost, int port, boolean useSSL,
            final String username, final String password,
            String to, String subject, String body) {
        try {
            Properties props = new Properties();
            props.put("mail.smtp.auth", "true");
            props.put("mail.smtp.host", smtpHost);
            props.put("mail.smtp.port", String.valueOf(port));
            props.put("mail.debug", "true"); // enable console logs

            if (useSSL) {
                // SSL on 465
                props.put("mail.smtp.ssl.enable", "true");
            } else {
                // STARTTLS on 587
                props.put("mail.smtp.starttls.enable", "true");
            }

            Session session = Session.getInstance(props, new Authenticator() {
                @Override
                protected PasswordAuthentication getPasswordAuthentication() {
                    return new PasswordAuthentication(username, password);
                }
            });

            MimeMessage msg = new MimeMessage(session);
            msg.setFrom(new InternetAddress(username));
            msg.setRecipients(Message.RecipientType.TO, InternetAddress.parse(to, false));
            msg.setSubject(subject, StandardCharsets.UTF_8.name());
            // Vietnamese-friendly UTF-8 body
            msg.setText(body, StandardCharsets.UTF_8.name());
            Transport.send(msg);
            return true;
        } catch (Exception ex) {
            ex.printStackTrace(); // Keep this for now; remove later
            return false;
        }
    }
}
