package com.hack.kpsahack12.member.service;


import com.hack.kpsahack12.model.entity.member.Members;
import com.hack.kpsahack12.model.repository.MembersRepository;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;

import java.util.Map;
import java.util.Optional;

@Service
@RequiredArgsConstructor
@Slf4j
public class MemberService {

    private final MembersRepository membersRepository;

    // 첫 회원 정보 저장
    public int saveRegisterMember( Map<String,Object> req) {

        Members members = Members.create(req);
        membersRepository.save(members);

        Optional<Members> memberCheck = membersRepository.findById(members.getId());

        return memberCheck.isPresent() ? 1 : 0;
    }

    // 유저 접속 로그인
    public boolean visitedMember(String userId) {

        Optional<Members> members = findById(userId);


        if(members.isPresent()){
            return true;
        }
        return false;
    }



    public Optional<Members> findById(String id) {
        return membersRepository.findById(id);
    }
}
