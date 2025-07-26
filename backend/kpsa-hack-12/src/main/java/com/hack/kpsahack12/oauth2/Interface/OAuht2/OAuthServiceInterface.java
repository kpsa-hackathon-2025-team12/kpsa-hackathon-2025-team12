package com.hack.kpsahack12.oauth2.Interface.OAuht2;

import java.io.IOException;

public interface OAuthServiceInterface {
    String getProviderName();
    String getPermissionCodeUrl();
    OAuth2TokenResponse getAccessToken(String code) throws IOException;
    OAuth2UserResponse getUserInfo(String accessToken);
}

