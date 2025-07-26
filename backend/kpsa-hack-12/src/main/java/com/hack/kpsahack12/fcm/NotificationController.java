package com.hack.kpsahack12.fcm;

import com.hack.kpsahack12.common.ApiResponseV2;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.Parameter;
import io.swagger.v3.oas.annotations.media.Content;
import io.swagger.v3.oas.annotations.media.Schema;
import io.swagger.v3.oas.annotations.responses.ApiResponse;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/fcm")
@RequiredArgsConstructor
@Slf4j
@Tag(name = "알림", description = "fcm 푸시 알림 API")
public class NotificationController {

    private final FCMService fcmService;

    @Operation(
            summary = "푸시 알림 전송",
            description = "특정 디바이스에 FCM 푸시 알림을 전송합니다.",
            responses = {
                    @ApiResponse(
                            responseCode = "200",
                            description = "알림 전송 성공",
                            content = @Content(
                                    mediaType = "application/json",
                                    schema = @Schema(implementation = ApiResponseV2.class)
                            )
                    )
            }
    )
    @PostMapping("/send")
    public ApiResponseV2<String> sendNotification(
            @Parameter(description = "FCM 토큰", required = true, example = "xhzmsxhzmsxhzmsxhzmsxhzms")
            @RequestParam String token,

            @Parameter(description = "알림 제목", required = true, example = "새로운 메시지")
            @RequestParam String title,

            @Parameter(description = "알림 내용", required = true, example = "안녕하세요!")
            @RequestParam String body) {

        log.info("====== send ====== : {} {} {} ",  token, title , body);

        fcmService.sendNotification(token, title, body);

        return ApiResponseV2.success("알림 전송 성공");
    }


}
