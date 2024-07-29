package heart.project.repository.mybatis;

import heart.project.domain.MemberAction;
import heart.project.repository.memberaction.MemberActionRepository;
import heart.project.repository.memberaction.MemberActionUpdateApiDto;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
@RequiredArgsConstructor
public class MyBatisMemberActionRepository implements MemberActionRepository {

    private final MemberActionMapper memberActionMapper;

    @Override
    public MemberAction save(MemberAction memberAction) {
        memberActionMapper.save(memberAction);
        return memberActionMapper.findNewMemberAction();
    }

    @Override
    public void completeMemberAction(Integer memberActionId, MemberActionUpdateApiDto updateParam) {
        memberActionMapper.completeMemberAction(memberActionId, updateParam);
    }

    @Override
    public List<MemberAction> findOngoingActionsByMemberId(String memberId) {
        return memberActionMapper.findOngoingActionsByMemberId(memberId);
    }

    @Override
    public List<MemberAction> findCompletedActionsByMemberId(String memberId) {
        return memberActionMapper.findCompletedActionsByMemberId(memberId);
    }

    @Override
    public List<MemberAction> findFeelBetterActions(String memberId) {
        return memberActionMapper.findFeelBetterActions(memberId);
    }
}
