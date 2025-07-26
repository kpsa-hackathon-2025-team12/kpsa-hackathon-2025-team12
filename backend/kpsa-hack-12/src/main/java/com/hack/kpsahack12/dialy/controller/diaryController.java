package com.hack.kpsahack12.dialy.controller;

import com.hack.kpsahack12.common.ApiResponseV2;
import com.hack.kpsahack12.dialy.service.DiaryService;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.web.bind.annotation.*;


@RestController
@RequestMapping("/diary")
@Slf4j
@RequiredArgsConstructor
@Tag(name = "diary info", description = "사용자 diary 정보 관련 API")
public class diaryController {
    private final DiaryService diaryService;

    @PutMapping("/set/breath")
    public ApiResponseV2<?> setBreath(@RequestParam String userId, @RequestParam int breath) {
        return ApiResponseV2.success(diaryService.setCompliteCount(userId, breath));
    }

    @GetMapping("/get/diary")
    public ApiResponseV2<?> getDiary(@RequestParam String userId) {
        return ApiResponseV2.success(diaryService.getDiaryDataInfo(userId));
    }

    @PostMapping("/set/diary/text")
    public ApiResponseV2<?> setDiaryText(@RequestParam String userId, @RequestParam String text) {
        return ApiResponseV2.success(diaryService.setDiaryText(userId, text));
    }
}
