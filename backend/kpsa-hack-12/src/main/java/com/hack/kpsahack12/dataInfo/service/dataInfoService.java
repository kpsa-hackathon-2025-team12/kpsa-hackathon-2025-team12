package com.hack.kpsahack12.dataInfo.service;


import com.hack.kpsahack12.model.entity.member.LocationSpot;
import com.hack.kpsahack12.model.entity.member.Symptoms;
import com.hack.kpsahack12.model.repository.LocationSpotRepository;
import com.hack.kpsahack12.model.repository.SymptomsRepository;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;

import java.util.List;

@RequiredArgsConstructor
@Service
@Slf4j
public class dataInfoService {
    private final SymptomsRepository symptomsRepository;
    private final LocationSpotRepository locationSpotRepository;


    public List<LocationSpot> getLocationSpot(){
        log.info("get location spot");
        return locationSpotRepository.findAll();
    }

    public List<Symptoms> getSymptoms(){
        log.info("get symptoms");
        return symptomsRepository.findAll();
    }
}
