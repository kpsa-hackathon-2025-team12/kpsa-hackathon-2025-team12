package com.hack.kpsahack12.model.repository;

import com.hack.kpsahack12.model.entity.member.MemberLlmData;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

public interface MemberLlmDataRepository extends JpaRepository<MemberLlmData, Long> {
    List<MemberLlmData> findByMemberIdAndButtonTypeOrderByIdxAsc(String memberId, int buttonType);
}