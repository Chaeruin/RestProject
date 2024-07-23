package heart.project.service.action;

import heart.project.domain.Action;
import heart.project.domain.DailyRecommendation;
import heart.project.repository.action.ActionRepository;
import heart.project.repository.dailyrecommendation.DailyRecommendationRepository;
import lombok.RequiredArgsConstructor;
import oracle.jdbc.internal.OpaqueString;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDate;
import java.util.List;
import java.util.Optional;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
public class ActionService {

    private final ActionRepository actionRepository;

    // 랜덤으로 행동을 1개 추천하는 메서드
    public Action recommendAction() {
        return actionRepository.recommendAction();
    }

    // 주어진 행동 ID에 해당하는 행동을 찾아 반환하는 메서드
    public Optional<Action> findByActionId(Integer actionId) {
        return actionRepository.findByActionId(actionId);
    }
}
