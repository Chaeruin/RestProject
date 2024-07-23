package heart.project.repository.memberaction;

import heart.project.domain.MemberAction;

public interface MemberActionRepository {

    MemberAction save(MemberAction memberAction);

    void completeMemberAction(Integer memberActionId, MemberActionUpdateApiDto updateParam);
}
