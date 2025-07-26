package com.hack.kpsahack12.model.repository;

import com.hack.kpsahack12.model.entity.member.MemberLlmData;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

public interface MemberLlmDataRepository extends JpaRepository<MemberLlmData, Long> {
    List<MemberLlmData> findByMemberIdAndButtonTypeOrderByIdxAsc(String memberId, int buttonType);

    @Query(value = "TRUNCATE TABLE member_llm_data", nativeQuery = true)
    @Modifying
    @Transactional
    void truncateTable();

}