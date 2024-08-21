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

    // 새로운 멤버 행동을 저장하고, 기본 상태를 '진행중'으로 설정하여 반환하는 메서드
    @Override
    public MemberAction save(MemberAction memberAction) {
        memberActionMapper.preSave(memberAction);
        memberActionMapper.save(memberAction);
        return memberActionMapper.findNewMemberAction();
    }

    // 행동 후 감정 변화를 갱신하고, 상태를 '완료'로 바꾸는 메서드
    @Override
    public MemberAction completeMemberAction(Integer memberActionId, MemberActionUpdateApiDto updateParam) {
        memberActionMapper.completeMemberAction(memberActionId, updateParam);
        return memberActionMapper.selectMemberActionById(memberActionId);
    }

    // 주어진 회원 ID의 상태가 '진행중'인 행동을 반환하는 메서드
    @Override
    public List<MemberAction> findOngoingActionsByMemberId(String memberId) {
        return memberActionMapper.findOngoingActionsByMemberId(memberId);
    }

    // 주어진 회원 ID의 상태가 '완료'인 행동을 반환하는 메서드
    @Override
    public List<MemberAction> findCompletedActionsByMemberId(String memberId) {
        return memberActionMapper.findCompletedActionsByMemberId(memberId);
    }

    // 특정 멤버의 기분을 나아지게 한 행동 2개를 반환하는 메서드
    @Override
    public List<MemberAction> findFeelBetterActions(String memberId) {
        return memberActionMapper.findFeelBetterActions(memberId);
    }
}
