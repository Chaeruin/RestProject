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

    @Override
    public Action recommendAction() {
        return actionMapper.recommendAction();
    }

    @Override
    public List<Action> recommendActionsByCategory(String memberId, String emotionType) {
        return actionMapper.recommendActionsByCategory(memberId, emotionType);
    }

    @Override
    public Optional<Action> findByActionId(Integer actionId) {
        return actionMapper.findByActionId(actionId);
    }
}
