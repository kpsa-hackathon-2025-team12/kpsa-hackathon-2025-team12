package com.hack.kpsahack12.common;

import lombok.RequiredArgsConstructor;
import org.springframework.http.*;
import org.springframework.stereotype.Component;
import org.springframework.util.MultiValueMap;
import org.springframework.web.client.RestTemplate;

import java.util.Map;

@Component
@RequiredArgsConstructor
public class CallClient {

    private final RestTemplate restTemplate;

    public String GET(String uri, Map<String, String> headers) {
        HttpHeaders httpHeaders = new HttpHeaders();
        headers.forEach(httpHeaders::add);

        HttpEntity<String> entity = new HttpEntity<>(httpHeaders);
        ResponseEntity<String> response = restTemplate.exchange(uri, HttpMethod.GET, entity, String.class);

        return "";
    }

    public String POST(String uri, Map<String, String> headers, Object body) {
        HttpHeaders httpHeaders = new HttpHeaders();
        headers.forEach(httpHeaders::add);

        HttpEntity<Object> entity = new HttpEntity<>(body, httpHeaders);
        ResponseEntity<String> response = restTemplate.exchange(uri, HttpMethod.POST, entity, String.class);

        return "";
    }

    // 폼 데이터 전송을 위한 메서드
    public String POST(String uri, Map<String, String> headers, MultiValueMap<String, String> formData) {
        HttpHeaders httpHeaders = new HttpHeaders();
        headers.forEach(httpHeaders::add);

        // application/x-www-form-urlencoded 컨텐츠 타입 설정 확인
        if (!headers.containsKey("Content-Type")) {
            httpHeaders.setContentType(MediaType.APPLICATION_FORM_URLENCODED);
        }

        HttpEntity<MultiValueMap<String, String>> entity = new HttpEntity<>(formData, httpHeaders);
        ResponseEntity<String> response = restTemplate.exchange(uri, HttpMethod.POST, entity, String.class);

        return "";
    }


    // String 형태의 JSON을 전송하기 위한 메서드
    public String POST(String uri, Map<String, String> headers, String jsonBody) {
        HttpHeaders httpHeaders = new HttpHeaders();
        headers.forEach(httpHeaders::add);
        httpHeaders.add("Content-Type", "application/json");

        HttpEntity<String> entity = new HttpEntity<>(jsonBody, httpHeaders);
        ResponseEntity<String> response = restTemplate.exchange(uri, HttpMethod.POST, entity, String.class);

        return "";
    }

    // 바이너리 데이터를 전송하기 위한 메서드
    public String POST(String uri, Map<String, String> headers, byte[] byteBody) {
        HttpHeaders httpHeaders = new HttpHeaders();
        headers.forEach(httpHeaders::add);

        HttpEntity<byte[]> entity = new HttpEntity<>(byteBody, httpHeaders);
        ResponseEntity<String> response = restTemplate.exchange(uri, HttpMethod.POST, entity, String.class);

        return "";
    }
}