package com.hack.kpsahack12.model.naver;

import com.hack.kpsahack12.oauth2.Interface.OAuht2.OAuth2UserResponse;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
public class NaverUserResponse implements OAuth2UserResponse {

    private String resultCode;
    private String message;
    private Response response;


    @Data
    @NoArgsConstructor
    @AllArgsConstructor
    public static class Response{ //  https://developers.naver.com/docs/login/devguide/devguide.md#3-4-2-%EB%84%A4%EC%9D%B4%EB%B2%84-%EB%A1%9C%EA%B7%B8%EC%9D%B8-%EC%97%B0%EB%8F%99-url-%EC%83%9D%EC%84%B1%ED%95%98%EA%B8%B0
        private String id;
        private String nickname;
        private String name;
        private String email;
        private String gender;
        private String age;
        private String birthday;
        private String profile_image;
        private String birthyear;
        private String mobile;
        private String mobile_e164;
    }

    @Override
    public String getId() {
        return response.getId();
    }

    @Override
    public String getEmail() {
        return response.getEmail() != null ? response.getEmail() : "";
    }

    @Override
    public String getName() {

        return response.getName() != null ?
                response.getName() : response.getNickname() != null ?
                response.getNickname() : "";
    }
}
