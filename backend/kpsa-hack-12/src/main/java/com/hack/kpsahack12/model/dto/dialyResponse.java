package com.hack.kpsahack12.model.dto;

import com.hack.kpsahack12.model.entity.member.dialy;
import lombok.*;
import lombok.experimental.SuperBuilder;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@SuperBuilder
public class dialyResponse extends dialy {
    private String avg_score;
    private String complite_per;
    private String nickname;
    private String most_spot;

    public static dialyResponse response(dialy dialy, String avg_score, String complite_per, String nickname, String most_spot) {
        return dialyResponse.builder()
                .idx(dialy.getIdx())
                .memberId(dialy.getMemberId())
                .complite_cnt(dialy.getComplite_cnt())
                .before_score(dialy.getBefore_score())
                .after_score(dialy.getAfter_score())
                .dialyText(dialy.getDialyText())
                .createdAt(dialy.getCreatedAt())
                .avg_score(avg_score)
                .complite_per(complite_per)
                .nickname(nickname)
                .most_spot(most_spot)
                .build();
    }
}

