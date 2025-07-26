package com.hack.kpsahack12.dialy.service;

import com.hack.kpsahack12.level.service.LevelService;
import com.hack.kpsahack12.model.dto.dialyResponse;
import com.hack.kpsahack12.model.entity.member.LocationSpot;
import com.hack.kpsahack12.model.entity.member.MemberLevel;
import com.hack.kpsahack12.model.entity.member.Members;
import com.hack.kpsahack12.model.entity.member.dialy;
import com.hack.kpsahack12.model.repository.LocationSpotRepository;
import com.hack.kpsahack12.model.repository.MemberLevelRepository;
import com.hack.kpsahack12.model.repository.MembersRepository;
import com.hack.kpsahack12.model.repository.dialyRepository;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.text.SimpleDateFormat;
import java.util.*;

@Service
@RequiredArgsConstructor
@Slf4j
public class DiaryService {

    private final dialyRepository diaryRepository;
    private final MembersRepository membersRepository;
    private final MemberLevelRepository memberLevelRepository ;
    private final LocationSpotRepository locationSpotRepository;

    @Transactional
    public int setCompliteCount(String userId, int breath){

        Optional<dialy> dialyOptional = diaryRepository.findByMemberId(userId);

        if (dialyOptional.isPresent()) {
            dialy diary = dialyOptional.get();

            if(breath > 0){
                diary.setComplite_cnt(diary.getComplite_cnt() + 1);
            }else{
                diary.setFail_cnt(diary.getFail_cnt() + 1);
            }

            diaryRepository.save(diary);
            return diary.getComplite_cnt();
        }
        return 0;

    }

    public dialyResponse getDiaryDataInfo(String userId) {
        String today = new SimpleDateFormat("yyyyMMdd").format(new Date());

        Double avg_score = 0.0;
        String complite_per = "0%";
        String most_spot_number = "";
        String most_spot_name = "";

        // 오늘 날짜의 일기 목록 조회 (여러 개가 있을 수 있음)
        List<dialy> todayDiaries = diaryRepository.findAllByMemberIdAndCreatedAt(userId, today);

        // 오늘 일기가 없는 경우
        if (todayDiaries == null || todayDiaries.isEmpty()) {
            return dialyResponse.builder()
                    .avg_score(String.format("%.1f", avg_score))
                    .complite_per(complite_per)
                    .nickname(membersRepository.findById(userId).get().getNickname())
                    .most_spot(most_spot_name)
                    .build();
        }

        // 가장 최근 일기 사용 (또는 다른 기준으로 선택할 수 있음)
        dialy todayDiary = todayDiaries.get(todayDiaries.size() - 1);

        // 평균 점수 계산
        List<dialy> userDiaries = diaryRepository.findAllByMemberId(userId);

        if(userDiaries.size() == 1){
            avg_score = userDiaries.get(0).getBefore_score().equals("0") ? Double.parseDouble(userDiaries.get(0).getAfter_score())
                    :
                    (Double.parseDouble(userDiaries.get(0).getBefore_score()) + Double.parseDouble(userDiaries.get(0).getAfter_score())) / 2;
        }else {

            if (!userDiaries.isEmpty()) {
                double totalAfterScore = 0.0;
                int validScoreCount = 0;

                for (dialy diary : userDiaries) {
                    String afterScore = diary.getAfter_score();
                    if (afterScore != null && !afterScore.isEmpty()) {
                        try {
                            double score = Double.parseDouble(afterScore);
                            totalAfterScore += score;
                            validScoreCount++;
                        } catch (NumberFormatException e) {
                            // 숫자 변환 실패 시 무시
                        }
                    }
                }

                avg_score = validScoreCount > 0 ? totalAfterScore / validScoreCount : 0.0;
            }
        }

        // 완료율 계산
        int compliteCnt = todayDiary.getComplite_cnt();
        int totalGoal = 10;
        double complitePercentage = (compliteCnt * 100.0) / totalGoal;
        complite_per = String.format("%.0f%%", complitePercentage);

        // 가장 많이 선택된 공간 번호 찾기
        most_spot_number = findMostFrequentSpot(userId);

        // 공간 번호를 이용해 실제 장소명 찾기
        most_spot_name = findSpotNameByNumber(most_spot_number);

        // 사용자 정보 가져오기
        String nickname = membersRepository.findById(userId).get().getNickname();

        // dialyResponse 객체 생성 및 반환
        return dialyResponse.builder()
                .idx(todayDiary.getIdx())
                .memberId(todayDiary.getMemberId())
                .complite_cnt(todayDiary.getComplite_cnt())
                .before_score(todayDiary.getBefore_score())
                .after_score(todayDiary.getAfter_score())
                .dialyText(todayDiary.getDialyText())
                .createdAt(todayDiary.getCreatedAt())
                .avg_score(String.format("%.1f", avg_score))
                .complite_per(complite_per)
                .nickname(nickname)
                .most_spot(most_spot_name)
                .build();
    }

    @Transactional
    public dialy setDiaryText(String userId, String text) {
        SimpleDateFormat dateFormat = new SimpleDateFormat("yyyyMMdd");
        String today = dateFormat.format(new Date());

        Optional<dialy> dialyOptional = diaryRepository.findByMemberIdAndCreatedAt(userId,today);

        if (dialyOptional.isPresent()) {
            dialy diary = dialyOptional.get();
            diary.setDialyText(text);

            diary.setCreatedAt(today);

            return diaryRepository.save(diary);
        }

        // 사용자의 다이어리가 없는 경우 새로 생성
        dialy newDiary = dialy.builder()
                .memberId(userId)
                .dialyText(text)
                .complite_cnt(0)
                .createdAt(new SimpleDateFormat("yyyyMMdd").format(new Date()))
                .build();

        return diaryRepository.save(newDiary);
    }


    private String findMostFrequentSpot(String userId) {
        List<MemberLevel> memberLevels = memberLevelRepository.findByMemberId(userId);

        if (memberLevels == null || memberLevels.isEmpty()) {
            return ""; // 데이터가 없을 경우 빈 문자열 반환
        }

        // 모든 choiceSpace 리스트의 요소를 하나의 리스트로 통합
        List<String> allChoices = new ArrayList<>();
        for (MemberLevel level : memberLevels) {
            List<String> choices = level.getChoiceSpace();
            if (choices != null && !choices.isEmpty()) {
                allChoices.addAll(choices);
            }
        }

        if (allChoices.isEmpty()) {
            return ""; // 선택된 공간이 없을 경우 빈 문자열 반환
        }

        // 각 공간별 출현 빈도 계산
        Map<String, Integer> frequencyMap = new HashMap<>();
        for (String spot : allChoices) {
            frequencyMap.put(spot, frequencyMap.getOrDefault(spot, 0) + 1);
        }

        // 가장 많이 출현한 공간 찾기
        String mostFrequentSpot = "";
        int maxFrequency = 0;

        for (Map.Entry<String, Integer> entry : frequencyMap.entrySet()) {
            if (entry.getValue() > maxFrequency) {
                maxFrequency = entry.getValue();
                mostFrequentSpot = entry.getKey();
            }
        }

        return mostFrequentSpot;
    }

    private String findSpotNameByNumber(String numberListStr) {

        if (numberListStr == null || numberListStr.isEmpty()) {
            return ""; // 번호가 없으면 빈 문자열 반환
        }

        Optional<LocationSpot> locationSpotOpt = locationSpotRepository.findByNumberListStr(numberListStr);

        return locationSpotOpt.map(LocationSpot::getSpot).orElse("");
    }

}
