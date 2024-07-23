package heart.project.service.dailyrecommendation;

import heart.project.domain.Action;
import heart.project.domain.DailyRecommendation;
import heart.project.repository.action.ActionRepository;
import heart.project.repository.dailyrecommendation.DailyRecommendationRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDate;
import java.util.List;

@Service
@RequiredArgsConstructor
public class DailyRecommendationService {

    private final DailyRecommendationRepository dailyRecommendationRepository;
    private final ActionRepository actionRepository;

    // 상태가 '완료'인 것을 제외하고 감정 타입과 카테고리에 맞는 행동을 각각 1개씩 랜덤으로 추천하는 메서드
    // 한 번 추천된 것은 daily_recommends 테이블에 저장하여 다음날이 될 때 까지 갱신되지 않음
    @Transactional
    public List<DailyRecommendation> recommendDailyRecommendationsByCategory(String memberId, String emotionType, LocalDate recommendationDate) {
        List<DailyRecommendation> dailyRecommendations = dailyRecommendationRepository.findDailyRecommendations(memberId, emotionType, recommendationDate);

        if (dailyRecommendations.isEmpty()) {
            List<Action> actions = actionRepository.recommendActionsByCategory(memberId, emotionType);

            for (Action recommendedAction : actions) {
                DailyRecommendation dailyRecommendation = new DailyRecommendation();
                dailyRecommendation.setMemberActionId(recommendedAction.getMemberActionId());
                dailyRecommendation.setMemberId(memberId);
                dailyRecommendation.setActionId(recommendedAction.getActionId());
                dailyRecommendation.setEmotionType(emotionType);
                dailyRecommendation.setCategory(recommendedAction.getCategory());
                dailyRecommendation.setRecommendationDate(recommendationDate);
                dailyRecommendation.setAction(recommendedAction.getAction());
                dailyRecommendation.setStatus(recommendedAction.getStatus());
                dailyRecommendationRepository.insertDailyRecommendation(dailyRecommendation);
            }
            // 새로 생성된 DailyRecommendation 객체 리스트 반환
            return dailyRecommendationRepository.findDailyRecommendations(memberId, emotionType, recommendationDate);
        } else {
            // 이미 존재하는 DailyRecommendation 객체 리스트 반환
            return dailyRecommendations;
        }
    }
}

