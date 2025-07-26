package com.hack.kpsahack12.model.repository;

import com.hack.kpsahack12.model.entity.member.Members;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import java.util.Optional;

public interface MembersRepository extends JpaRepository<Members, Long> {

    Optional<Members> findById(String id);


    @Modifying
    @Query("UPDATE Members m SET m.responseCnt = m.responseCnt + 1 WHERE m.id = :userId")
    int incrementResponseCnt(@Param("userId") String userId);

    @Modifying
    @Query("UPDATE Members m SET " +
            "m.nickname = CASE WHEN :nickname IS NULL OR :nickname = '' THEN m.nickname ELSE :nickname END, " +
            "m.gender = CASE WHEN :gender IS NULL OR :gender = '' THEN m.gender ELSE :gender END, " +
            "m.birth = CASE WHEN :birth IS NULL OR :birth = '' THEN m.birth ELSE :birth END " +
            "WHERE m.id = :userId")
    int updateUserInfo(@Param("userId") String userId,
                       @Param("nickname") String nickname,
                       @Param("gender") String gender,
                       @Param("birth") String birth);


}