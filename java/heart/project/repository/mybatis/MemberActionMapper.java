package heart.project.repository.mybatis;

import heart.project.domain.MemberAction;
import heart.project.repository.memberaction.MemberActionUpdateApiDto;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

@Mapper
public interface MemberActionMapper {

    void save(MemberAction memberAction);

    MemberAction findNewMemberAction();

    void completeMemberAction(@Param("memberActionId") Integer memberActionId, @Param("updateParam") MemberActionUpdateApiDto updateParam);
}
