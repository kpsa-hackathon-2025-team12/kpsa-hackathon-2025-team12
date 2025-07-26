package com.hack.kpsahack12.llm.gemini.response;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.util.List;

@NoArgsConstructor
@AllArgsConstructor
@Getter
@Setter
public class GeminiChatResponseDto {

    private List<GeminiCandidate> candidates;

    public String getSingleText() {
        return candidates.stream().findFirst()
                .flatMap(candidate ->
                        candidate.getContent().getParts().stream().findFirst()
                        .map(part -> part.getText()))
                .orElseThrow();
    }
}
