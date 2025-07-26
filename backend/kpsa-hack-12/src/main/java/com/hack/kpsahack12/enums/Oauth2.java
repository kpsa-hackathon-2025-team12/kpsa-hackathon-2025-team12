package com.hack.kpsahack12.enums;

import lombok.Getter;

@Getter
public enum Oauth2 {
    KAKAO_OAUTH("KAKAO","카카오"),
    NAVER_OAUTH("NAVER","네이버"),
    ;


    private String provider;
    private String name;

    Oauth2(String provider, String name) {
        this.provider = provider;
        this.name = name;
    }
}
