package heart.project.repository.mybatis;

import heart.project.domain.MemberAction;
import heart.project.repository.memberaction.MemberActionUpdateApiDto;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;

@Mapper
public interface MemberActionMapper {

    void preSave(MemberAction memberAction);

    void save(MemberAction memberAction);

    MemberAction findNewMemberAction();

    void completeMemberAction(@Param("memberActionId") Integer memberActionId, @Param("updateParam") MemberActionUpdateApiDto updateParam);

    MemberAction selectMemberActionById(@Param("memberActionId") Integer memberActionId);

    List<MemberAction> findOngoingActionsByMemberId(String memberId);

    List<MemberAction> findCompletedActionsByMemberId(String memberId);

    List<MemberAction> findFeelBetterActions(String memberId);
}
