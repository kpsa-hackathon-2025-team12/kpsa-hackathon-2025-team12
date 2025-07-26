package com.hack.kpsahack12.fcm;

import com.google.auth.oauth2.GoogleCredentials;
import com.google.firebase.FirebaseApp;
import com.google.firebase.FirebaseOptions;
import com.google.firebase.messaging.FirebaseMessaging;
import com.google.firebase.messaging.FirebaseMessagingException;
import com.google.firebase.messaging.Message;
import com.google.firebase.messaging.Notification;
import com.hack.kpsahack12.enums.ErrorCode;
import com.hack.kpsahack12.exception.CustomException;
import jakarta.annotation.PostConstruct;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.core.io.ClassPathResource;
import org.springframework.stereotype.Service;

import java.io.IOException;

@Service
@Slf4j
public class FCMService {

    private FirebaseMessaging firebaseMessaging;

    @Value("${firebase.credentials.path}")
    private String firebaseConfigPath;


    @PostConstruct
    private void initialize() {
        try {

            GoogleCredentials googleCredentials = GoogleCredentials
                    .fromStream(new ClassPathResource(firebaseConfigPath).getInputStream());


            FirebaseOptions options = FirebaseOptions.builder()
                    .setCredentials(googleCredentials)
                    .build();


            if (FirebaseApp.getApps().isEmpty()) {
                FirebaseApp.initializeApp(options);
                log.info("파베 init ");
            }

            firebaseMessaging = FirebaseMessaging.getInstance();

        } catch (IOException e) {
            log.error("Firebase 초기화 중 오류 발생: {} ", e.getMessage());
            throw new CustomException(ErrorCode.SERVER_ERROR);

        }
    }

    public void sendNotification(String token, String title, String body) {
        // 알림 메시지 빌드
        Message message = Message.builder()
                .setToken(token)
                .setNotification(Notification.builder()
                        .setTitle(title)
                        .setBody(body)
                        .build())
                .build();

        try {
            // 메시지 전송
            String response = firebaseMessaging.send(message);
            log.info("Success sent message: " + response);

        } catch (FirebaseMessagingException e) {
            log.error("알림 전송 실패: {} ", e.getMessage());
            throw new CustomException(ErrorCode.DURING_SEND_TO_FCM_ERROR);
        }
    }
}
