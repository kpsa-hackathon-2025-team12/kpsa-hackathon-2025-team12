package com.hack.kpsahack12.model.entity.member;

import jakarta.persistence.*;
import lombok.*;

@Entity
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
@Table(name = "actions")
public class Actions {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long idx;

    private String space;
}
