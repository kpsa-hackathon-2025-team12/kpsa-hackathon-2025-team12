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
    @Query("UPDATE Members m SET m.nickname = :nickname WHERE m.id = :userId")
    int updateUserNickname(@Param("nickname") String nickname, @Param("userId") String userId);


}