package com.hack.kpsahack12.dataInfo.controller;


import com.hack.kpsahack12.common.ApiResponseV2;
import com.hack.kpsahack12.dataInfo.service.dataInfoService;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/data")
@RequiredArgsConstructor
@Tag(name = "data", description = "기초 데이터 정보 ")
@Slf4j
public class dataInfoController {
    private final dataInfoService dataInfoService;

    @GetMapping("/symptoms")
    public ApiResponseV2<?> getSymptoms(){
        return ApiResponseV2.success(dataInfoService.getSymptoms());
    }

    @GetMapping("/location")
    public ApiResponseV2<?> getLocation(){
        return ApiResponseV2.success(dataInfoService.getLocationSpot());
    }
}
