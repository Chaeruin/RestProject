package heart.project.repository.mybatis;

import heart.project.domain.Action;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;
import java.util.Optional;

@Mapper
public interface ActionMapper {

    Action recommendAction();

    List<Action> recommendActionsByCategory(@Param("memberId") String memberId, @Param("emotionType") String emotionType);

    Optional<Action> findByActionId(Integer actionId);
}
