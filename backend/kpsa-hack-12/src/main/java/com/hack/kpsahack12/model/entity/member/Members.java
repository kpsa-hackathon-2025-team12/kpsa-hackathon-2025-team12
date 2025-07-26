package com.hack.kpsahack12.model.entity.member;

import com.hack.kpsahack12.enums.Status;
import jakarta.persistence.*;
import lombok.*;

import java.util.Map;

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
    private String id;

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



    public static Members create(Map<String,Object> req) {
        return Members.builder()
                .id(req.get("userId").toString())
                .email(req.get("email").toString())
                .name(req.get("name").toString())
                .status(Status.REGISTER.getCode())
                .visited(1L)
                .build();
    }
}