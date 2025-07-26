package com.hack.kpsahack12.model.entity.member;

import jakarta.persistence.*;
import lombok.*;

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

    @ManyToOne
    @JoinColumn(name = "member_id", nullable = false, referencedColumnName = "id")
    private Members member;

    private String level;

    private String choiceSpace;

    private String totalScore;
}
