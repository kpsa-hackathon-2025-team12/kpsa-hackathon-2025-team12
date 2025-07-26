package com.hack.kpsahack12.model.entity.member;


import jakarta.persistence.*;
import lombok.*;

@Entity
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
@Table(name = "member_llm_data")
public class MemberLlmData {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long idx;

    @ManyToOne
    @JoinColumn(name = "member_id", nullable = false, referencedColumnName = "id")
    private Members member;

    private String memberLogs;
}