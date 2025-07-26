package com.hack.kpsahack12.member.service;


import com.hack.kpsahack12.model.entity.member.Members;
import com.hack.kpsahack12.model.repository.MembersRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.Map;
import java.util.Optional;

@Service
@RequiredArgsConstructor
public class MemberService {

    private final MembersRepository membersRepository;

    /**
     * 응답 카운트를 증가시키는 메서드
     */
    @Transactional
    public boolean incrementResponseCount(String userId) {
        // DB에서 직접 업데이트 쿼리 실행
        int updatedRows = membersRepository.incrementResponseCnt(userId);
        return updatedRows > 0; // 업데이트된 행이 있으면 true 반환
    }

    /**
     * 멤버가 이미 방문했는지 확인하는 메서드
     */
    @Transactional(readOnly = true)
    public boolean visitedMember(String userId) {
        return membersRepository.findById(userId).isPresent();
    }

    /**
     * 새 멤버 저장 메서드
     */
    @Transactional
    public int saveRegisterMember(Map<String, Object> req) {
        // 이미 존재하는지 확인
        String userId = req.get("userId").toString();

        // 이미 존재하면 업데이트
        if (membersRepository.findById(userId).isPresent()) {
            incrementResponseCount(userId);
            return 1; // 성공
        }
        // 존재하지 않으면 새로 생성
        else {
            Members newMember = Members.create(req);
            membersRepository.save(newMember);
            return 1; // 성공
        }
    }

    @Transactional
    public int updateUserInfoToNickName(String nickname, String userId) {
        int updatedRows = membersRepository.updateUserNickname(nickname, userId);

        if (updatedRows == 0) {
            throw new IllegalArgumentException("해당 ID의 사용자를 찾을 수 없습니다: " + userId);
        }

        return updatedRows;
    }

}
