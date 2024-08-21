package heart.project.repository.mybatis;

import heart.project.domain.Action;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;
import java.util.Optional;

@Mapper
public interface ActionMapper {

    // 랜덤으로 행동을 1개 추천하는 메서드
    Action recommendAction();

    // 회원 ID와 감정 유형에 따라 추천된 행동 목록을 반환하는 메서드
    List<Action> recommendActionsByCategory(@Param("memberId") String memberId, @Param("emotionType") String emotionType);

    // 주어진 행동 ID에 해당하는 행동을 찾아 반환하는 메서드
    Optional<Action> findByActionId(Integer actionId);
}
