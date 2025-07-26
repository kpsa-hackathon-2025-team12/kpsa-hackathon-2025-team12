package com.hack.kpsahack12.oauth2.Interface.OAuht2;

public interface OAuth2TokenResponse {
    String getAccessToken();
    String getRefreshToken();
    long getExpiresIn();
}
