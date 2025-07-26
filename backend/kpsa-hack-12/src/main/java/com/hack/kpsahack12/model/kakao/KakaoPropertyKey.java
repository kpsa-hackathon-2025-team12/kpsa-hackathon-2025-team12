package com.hack.kpsahack12.model.kakao;

import lombok.Getter;

import java.util.Arrays;
import java.util.List;
import java.util.stream.Collectors;

@Getter
public enum KakaoPropertyKey {
    // 프로필 정보
    PROFILE("kakao_account.profile", "프로필 정보 (닉네임, 프로필 사진)"),

    // 기본 정보
    NAME("kakao_account.name", "이름"),
    EMAIL("kakao_account.email", "이메일"),

    // 인구통계학적 정보
    AGE_RANGE("kakao_account.age_range", "연령대"),
    BIRTHDAY("kakao_account.birthday", "생일"),
    GENDER("kakao_account.gender", "성별");

    private final String key;
    private final String description;

    KakaoPropertyKey(String key, String description) {
        this.key = key;
        this.description = description;
    }

    public static List<String> toStringList(KakaoPropertyKey... propertyKeys) {
        return Arrays.stream(propertyKeys)
                .map(KakaoPropertyKey::getKey)
                .collect(Collectors.toList());
    }

    public static List<String> getAllKeys() {
        return Arrays.stream(values())
                .map(KakaoPropertyKey::getKey)
                .collect(Collectors.toList());
    }

    public static String getAllKeysAsJsonArrayString() {
        return toJsonArrayString(getAllKeys());
    }

    public static String toJsonArrayString(KakaoPropertyKey... propertyKeys) {
        List<String> keys = toStringList(propertyKeys);
        return toJsonArrayString(keys);
    }

    public static String toJsonArrayString(List<String> keys) {
        if (keys == null || keys.isEmpty()) {
            return "[]";
        }

        StringBuilder sb = new StringBuilder("[");
        for (int i = 0; i < keys.size(); i++) {
            sb.append("\"").append(keys.get(i)).append("\"");
            if (i < keys.size() - 1) {
                sb.append(",");
            }
        }
        sb.append("]");
        return sb.toString();
    }


}
