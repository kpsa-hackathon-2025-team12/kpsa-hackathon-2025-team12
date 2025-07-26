package com.hack.kpsahack12.config.OAUth2;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.Setter;

@Getter
@AllArgsConstructor
@Setter
public class OAuth2ProviderValues {
    private final String clientId;
    private final String clientSecret;
    private final String redirectUri;
    private final AuthUrlValues authUrl;
    private final ApiUrlValues apiUrl;
}
