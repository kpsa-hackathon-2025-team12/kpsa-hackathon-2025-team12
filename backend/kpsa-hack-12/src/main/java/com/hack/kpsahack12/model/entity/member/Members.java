package com.hack.kpsahack12.model.entity.member;

import jakarta.persistence.*;
import lombok.*;

@Entity
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
@Table(name = "member")
public class Members {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long idx;

    @Column(nullable = false, unique = true)
    private Long id;

    private String email;

    private String name;

    private String nickname;

    private String birth;

    private String gender;

    @Column(nullable = false, length = 20)
    private String status;

    @Column(nullable = false)
    private Long visited;

    @Column(nullable = false)
    private Long responseCnt;
}