package com.hack.kpsahack12.model.entity.member;

import jakarta.persistence.*;
import lombok.*;

@Entity
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
@Table(name = "dialy")
public class dialy {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long idx;

    private String memberId;

    private int complite_cnt;

    private String before_score;

    private String after_score;

    private String dialyText;

    private String createdAt;


    public static dialy create(String memberId, String before_score, String after_score) {
        return dialy.builder()
                .memberId(memberId)
                .complite_cnt(0)
                .before_score(before_score)
                .after_score(after_score)
                .build();
    }
}
