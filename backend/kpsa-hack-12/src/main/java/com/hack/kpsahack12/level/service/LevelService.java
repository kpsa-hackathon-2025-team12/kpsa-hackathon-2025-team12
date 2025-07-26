package com.hack.kpsahack12.level.service;


import com.hack.kpsahack12.enums.ErrorCode;
import com.hack.kpsahack12.exception.CustomException;
import com.hack.kpsahack12.model.dto.LevelDto;
import com.hack.kpsahack12.model.entity.member.MemberLevel;
import com.hack.kpsahack12.model.entity.member.Members;
import com.hack.kpsahack12.model.repository.LevelInfoRepository;
import com.hack.kpsahack12.model.repository.MemberLevelRepository;
import com.hack.kpsahack12.model.repository.MembersRepository;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;

import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.Optional;

@RequiredArgsConstructor
@Service
@Slf4j
public class LevelService {
    private final LevelInfoRepository levelInfoRepository;
    private final MemberLevelRepository memberLevelRepository;
    private final MembersRepository membersRepository;

    public MemberLevel saveLevelInfo(LevelDto levelDto) {
        log.info("levelDto : {}", levelDto);

        String userId = levelDto.getUserId();
        String level = "";
        Optional<Members> members = membersRepository.findById(userId);

        if (!members.isPresent()) {
            throw new CustomException(ErrorCode.NOT_FOUND_USER_NAME);
        }

        // 점수에 따른 레벨 결정
        if (levelDto.getTotalScore() >= 0 && levelDto.getTotalScore() <= 4) {
            level = "1";
        } else if (levelDto.getTotalScore() >= 5 && levelDto.getTotalScore() <= 7) {
            level = "2";
        } else if (levelDto.getTotalScore() >= 8 && levelDto.getTotalScore() <= 10) {
            level = "3";
        } else {
            level = "4";
        }


        String today = LocalDate.now().format(DateTimeFormatter.ofPattern("yyyyMMdd"));

        Optional<MemberLevel> existingRecord = memberLevelRepository
                .findByMemberIdAndCreatedAt(userId, today);

        MemberLevel memberLevel;

        if (existingRecord.isPresent()) {
            // 기존 기록이 있으면 업데이트
            memberLevel = existingRecord.get();
            memberLevel.setLevel(level);
            memberLevel.setChoiceSpace(levelDto.getChoiceSpace());
            memberLevel.setTotalScore(String.valueOf(levelDto.getTotalScore()));
        } else {
            // 기존 기록이 없으면 새로 생성
            memberLevel = MemberLevel.create(
                    members.get(),
                    level,
                    levelDto.getChoiceSpace(),
                    String.valueOf(levelDto.getTotalScore()),
                    today
            );
        }

        return memberLevelRepository.save(memberLevel);
    }
}
