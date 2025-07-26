package com.hack.kpsahack12.config.OAUth2;

import lombok.Getter;
import lombok.Setter;
import org.springframework.boot.context.properties.ConfigurationProperties;
import org.springframework.context.annotation.Configuration;

@Configuration
@ConfigurationProperties(prefix = "oauth2")
@Getter
@Setter
public class OAuth2Config {
    private OAuth2ProviderValues Kakao;
    private OAuth2ProviderValues Google;
    private OAuth2ProviderValues Naver;

    public OAuth2ProviderValues getProvider(String providerName) {
        if ("KAKAO".equals(providerName)) {
            return Kakao;
        } else if ("NAVER".equals(providerName)) {
            return Naver;
        }
        return null;
    }

}

