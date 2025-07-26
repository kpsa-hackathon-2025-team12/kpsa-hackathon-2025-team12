package com.hack.kpsahack12.model.repository;

import com.hack.kpsahack12.model.entity.member.MemberLevel;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;
import java.util.Optional;

public interface MemberLevelRepository extends JpaRepository<MemberLevel, Long> {
    Optional<MemberLevel> findByMemberIdAndCreatedAt(String memberId, String createdAt);

    List<MemberLevel> findByMemberId(String userId);
}