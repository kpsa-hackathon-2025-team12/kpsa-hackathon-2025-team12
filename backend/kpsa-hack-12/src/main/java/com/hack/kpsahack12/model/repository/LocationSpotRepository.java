package com.hack.kpsahack12.model.repository;

import com.hack.kpsahack12.model.entity.member.LocationSpot;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.Optional;

public interface LocationSpotRepository extends JpaRepository<LocationSpot, Long> {
    Optional<LocationSpot> findByNumberListStr(String numberListStr);
}