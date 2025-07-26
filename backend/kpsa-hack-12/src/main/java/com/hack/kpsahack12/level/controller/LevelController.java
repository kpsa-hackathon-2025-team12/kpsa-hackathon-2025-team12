package com.hack.kpsahack12.level.controller;

import com.hack.kpsahack12.common.ApiResponseV2;
import com.hack.kpsahack12.enums.ResponseCode;
import com.hack.kpsahack12.level.service.LevelService;
import com.hack.kpsahack12.model.dto.LevelDto;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/level")
@Slf4j
@RequiredArgsConstructor
public class LevelController {

    private final LevelService levelService;

    @PostMapping("/save-level")
    public ApiResponseV2<?> saveLevelData(@RequestBody LevelDto levelDto){
        return ApiResponseV2.success(levelService.saveLevelInfo(levelDto));
    }
}
