package com.hack.kpsahack12.model.entity.member;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.Id;
import jakarta.persistence.Table;
import lombok.*;

@Entity
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
@Table(name = "level_info")
public class LevelInfo {
    @Id
    @Column(nullable = false)
    private String level;

    private String oneLineText;

    private String emotionText;

    private String courageText;
}

