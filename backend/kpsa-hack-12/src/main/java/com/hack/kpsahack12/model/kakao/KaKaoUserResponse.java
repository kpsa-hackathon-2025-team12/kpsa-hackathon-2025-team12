package com.hack.kpsahack12.model.kakao;

import com.hack.kpsahack12.oauth2.Interface.OAuht2.OAuth2UserResponse;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.Objects;


@Data
@NoArgsConstructor
@AllArgsConstructor
public class KaKaoUserResponse implements OAuth2UserResponse {
    private Long id; // 카카오 ID는 숫자 형태
    private Properties properties;
    private KakaoAccount kakao_account;

    @Data
    @NoArgsConstructor
    @AllArgsConstructor
    public static class Properties {
        private String nickname;
        private String profile_image;
        private String thumbnail_image;
    }

    @Data
    @NoArgsConstructor
    @AllArgsConstructor
    public static class KakaoAccount {
        private Boolean profile_nickname_needs_agreement;
        private Boolean profile_image_needs_agreement;
        private Profile profile;
        private Boolean name_needs_agreement;
        private String name;
        private Boolean email_needs_agreement;
        private String email;
        private Boolean is_email_valid;
        private Boolean is_email_verified;
        private Boolean age_range_needs_agreement;
        private String age_range;
        private Boolean birthday_needs_agreement;
        private String birthday;
        private Boolean gender_needs_agreement;
        private String gender;

        @Data
        @NoArgsConstructor
        @AllArgsConstructor
        public static class Profile {
            private String nickname;
            private String thumbnail_image_url;
            private String profile_image_url;
        }
    }

    @Override
    public String getId() {
        return id != null ? id.toString() : null;
    }

    @Override
    public String getName() {
        if (kakao_account != null && kakao_account.getName() != null) {
            return kakao_account.getName();
        }else if(Objects.requireNonNull(kakao_account).getProfile() != null && kakao_account.getProfile().getNickname() != null){
            return kakao_account.getProfile().getNickname();
        }
        else if (properties != null && properties.getNickname() != null) {
            return properties.getNickname();
        }
        return null;
    }

    @Override
    public String getEmail() {
        return kakao_account != null ? kakao_account.getEmail() : null;
    }

    public String getProfileImageUrl() {
        if (kakao_account != null && kakao_account.getProfile() != null) {
            return kakao_account.getProfile().getProfile_image_url();
        } else if (properties != null) {
            return properties.getProfile_image();
        }
        return null;
    }


}
