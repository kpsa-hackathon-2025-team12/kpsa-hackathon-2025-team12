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
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long idx;

    @Column(name = "member_id", insertable = false, updatable = false)
    private String memberId;

    private String token;

    @OneToOne
    @JoinColumn(name = "member_id", referencedColumnName = "id")
    private Members member;

}
