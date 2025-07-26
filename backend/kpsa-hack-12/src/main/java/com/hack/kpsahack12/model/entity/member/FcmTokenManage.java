package com.hack.kpsahack12.model.entity.member;

import jakarta.persistence.*;
import lombok.*;

@Entity
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
@Table(name = "fcm_token_manage")
public class FcmTokenManage {
    @Id
    @Column(nullable = false)
    private Long memberId;

    private String token;

    @OneToOne
    @JoinColumn(name = "member_id", referencedColumnName = "id")
    private Members member;
}
