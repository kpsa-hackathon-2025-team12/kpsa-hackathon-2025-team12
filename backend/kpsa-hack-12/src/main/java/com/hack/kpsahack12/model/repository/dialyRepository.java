package com.hack.kpsahack12.model.repository;

import com.hack.kpsahack12.model.entity.member.dialy;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface dialyRepository extends JpaRepository<dialy,Long> {
    Optional<dialy> findByMemberId(String userId);

    Optional<dialy> findByMemberIdAndCreatedAt(String userId, String createdAt);

    // 특정 사용자의 모든 일기 목록 가져오기
    List<dialy> findAllByMemberId(String userId);

    List<dialy> findAllByMemberIdAndCreatedAt(String memberId, String createdAt);


}
