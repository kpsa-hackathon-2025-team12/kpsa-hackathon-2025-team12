package com.hack.kpsahack12.model.entity.member;

import jakarta.persistence.*;
import lombok.*;
import lombok.experimental.SuperBuilder;

import java.text.SimpleDateFormat;
import java.util.Date;

@Entity
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@SuperBuilder
@Table(name = "dialy")
public class dialy {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long idx;

    private String memberId;

    private int complite_cnt;

    private int fail_cnt;

    private String before_score;

    private String after_score;

    private String dialyText;

    private String createdAt;


    public static dialy create(String memberId, String before_score, String after_score) {

        SimpleDateFormat dateFormat = new SimpleDateFormat("yyyyMMdd");
        String today = dateFormat.format(new Date());

        return dialy.builder()
                .memberId(memberId)
                .complite_cnt(0)
                .fail_cnt(0)
                .before_score(before_score)
                .after_score(after_score)
                .createdAt(today)
                .build();
    }
}
