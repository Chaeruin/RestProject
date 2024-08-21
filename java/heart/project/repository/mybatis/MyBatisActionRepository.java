package heart.project.repository.mybatis;

import heart.project.domain.Action;
import heart.project.repository.action.ActionRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
@RequiredArgsConstructor
public class MyBatisActionRepository implements ActionRepository {

    private final ActionMapper actionMapper;

    // 랜덤으로 행동을 1개 추천하는 메서드
    @Override
    public Action recommendAction() {
        return actionMapper.recommendAction();
    }

    // 회원 ID와 감정 유형에 따라 추천된 행동 목록을 반환하는 메서드
    @Override
    public List<Action> recommendActionsByCategory(String memberId, String emotionType) {
        return actionMapper.recommendActionsByCategory(memberId, emotionType);
    }

    // 주어진 행동 ID에 해당하는 행동을 찾아 반환하는 메서드
    @Override
    public Optional<Action> findByActionId(Integer actionId) {
        return actionMapper.findByActionId(actionId);
    }
}
