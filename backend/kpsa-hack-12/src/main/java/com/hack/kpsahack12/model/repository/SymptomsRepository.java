package com.hack.kpsahack12.model.repository;

import com.hack.kpsahack12.model.entity.member.Symptoms;
import org.springframework.data.jpa.repository.JpaRepository;

public interface SymptomsRepository extends JpaRepository<Symptoms, Long> {
}