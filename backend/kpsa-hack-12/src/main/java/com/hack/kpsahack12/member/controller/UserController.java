package com.hack.kpsahack12.member.controller;

import com.hack.kpsahack12.common.ApiResponseV2;
import com.hack.kpsahack12.enums.ErrorCode;
import com.hack.kpsahack12.member.service.MemberService;
import com.hack.kpsahack12.model.dto.modifyMembers;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/user")
@Slf4j
@RequiredArgsConstructor
@Tag(name = "user info", description = "사용자 정보 관련 API")
public class UserController {

    private final MemberService memberService;

    @PutMapping("/set/members")
    public ApiResponseV2<?> setNicname(@RequestBody modifyMembers modify) {
        try {
            log.info("====== setNicname ======");

            int result =  memberService.updateUserInfo(modify);

            if(result == 1){
                return ApiResponseV2.success(
                        modify.getUserId()
                );
            }else{
                return ApiResponseV2.error(
                        ErrorCode.SERVER_ERROR, modify.getUserId()
                );
            }

        }catch (Exception e) {
            log.error("====== setNicname ======", e);
            return ApiResponseV2.error(ErrorCode.SERVER_ERROR, e.getMessage());
        }
    }
}
