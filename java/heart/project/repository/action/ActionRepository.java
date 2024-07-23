package heart.project.repository.action;

import heart.project.domain.Action;

import java.util.List;
import java.util.Optional;

public interface ActionRepository {

    Action recommendAction();

    List<Action> recommendActionsByCategory(String memberId, String emotionType);

    Optional<Action> findByActionId(Integer actionId);
}
