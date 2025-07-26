package com.hack.kpsahack12.member.controller;

import com.hack.kpsahack12.common.ApiResponseV2;
import com.hack.kpsahack12.enums.ErrorCode;
import com.hack.kpsahack12.member.service.MemberService;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/user")
@Slf4j
@RequiredArgsConstructor
@Tag(name = "user info", description = "사용자 정보 관련 API")
public class UserController {

    private final MemberService memberService;

    @PutMapping("/set/nickname")
    public ApiResponseV2<?> setNicname(@RequestParam(name = "nickname", required = true) String nickname,
                                    @RequestParam(name = "userId", required = true) String userId) {
        try {
            log.info("====== setNicname ======");

            int result =  memberService.updateUserInfoToNickName(nickname , userId);

            if(result == 1){
                return ApiResponseV2.success(
                        userId
                );
            }else{
                return ApiResponseV2.error(
                        ErrorCode.SERVER_ERROR, userId
                );
            }

        }catch (Exception e) {
            log.error("====== setNicname ======", e);
            return ApiResponseV2.error(ErrorCode.SERVER_ERROR, e.getMessage());
        }
    }
}
