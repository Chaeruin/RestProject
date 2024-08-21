package heart.project.controller.action;

import heart.project.domain.Action;
import heart.project.service.action.ActionService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequiredArgsConstructor
@RequestMapping("/api/actions")
public class ActionApiController {

    private final ActionService actionService;

    /**
     * 랜덤으로 행동을 1개 추천하는 엔드포인트
     */
    @GetMapping("/recommendation")
    public ResponseEntity<Action> recommendAction() {
        Action action = actionService.recommendAction();
        return new ResponseEntity<>(action, HttpStatus.OK);
    }

    /**
     * 특정 행동 ID로 행동을 조회하는 엔드포인트
     */
    @GetMapping("/{actionId}")
    public ResponseEntity<Action> getActionById(@PathVariable("actionId") Integer actionId) {
        return actionService.findByActionId(actionId)
                .map(ResponseEntity::ok)
                .orElse(ResponseEntity.notFound().build());
    }

}
