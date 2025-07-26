package com.hack.kpsahack12.model.entity.member;

import com.hack.kpsahack12.config.ConvertString;
import jakarta.persistence.*;
import lombok.*;

import java.util.Arrays;
import java.util.List;

@Entity
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
@Table(name = "member_level")
public class MemberLevel {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long idx;

//    @ManyToOne
//    @JoinColumn(name = "member_id", nullable = false, referencedColumnName = "id")
//    private Members member;

    private String memberId;

    private String level;

    @Convert(converter = ConvertString.StringListConverter.class)
    @Lob
    @Column(name = "choice_space")
    private List<String> choiceSpace;

    private String totalScore;

    private String createdAt;


    public static MemberLevel create(Members member, String level, List<String> choiceSpace, String totalScore, String createdAt) {
        return MemberLevel.builder()
                .memberId(member.getId())
                .level(level)
                .choiceSpace(choiceSpace)
                .totalScore(totalScore)
                .createdAt(createdAt)
                .build();
    }


}
