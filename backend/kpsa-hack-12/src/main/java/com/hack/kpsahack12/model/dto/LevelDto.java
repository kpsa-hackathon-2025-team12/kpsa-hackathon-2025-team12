package com.hack.kpsahack12.model.dto;

import lombok.Getter;
import lombok.Setter;

import java.util.List;

@Getter
@Setter
public class LevelDto {
    private String userId;
    private int totalScore;
    private List<String> choiceSpace;

}

/**
 *  userId : "userId"
 *  list = [0,1,2,3,4,5]
 *  totalScore = 3~7 (계산)
 */

