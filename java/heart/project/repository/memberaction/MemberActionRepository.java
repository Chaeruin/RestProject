package heart.project.repository.memberaction;

import heart.project.domain.MemberAction;

import java.util.List;

public interface MemberActionRepository {

    MemberAction save(MemberAction memberAction);

    MemberAction completeMemberAction(Integer memberActionId, MemberActionUpdateApiDto updateParam);

    List<MemberAction> findOngoingActionsByMemberId(String memberId);

    List<MemberAction> findCompletedActionsByMemberId(String memberId);

    List<MemberAction> findFeelBetterActions(String memberId);
}
