package heart.project.service.memberaction;

import heart.project.domain.MemberAction;
import heart.project.repository.memberaction.MemberActionRepository;
import heart.project.repository.memberaction.MemberActionUpdateApiDto;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
@RequiredArgsConstructor
public class MemberActionService {

    private final MemberActionRepository memberActionRepository;

    // 새로운 멤버 행동을 저장하고, 기본 상태를 '진행중'으로 설정하여 반환하는 메서드
    public MemberAction save(MemberAction memberAction) {
        return memberActionRepository.save(memberAction);
    }

    // 행동 후 감정 변화를 갱신하고, 상태를 '완료'로 바꾸는 메서드
    public MemberAction completeMemberAction(Integer memberActionId, MemberActionUpdateApiDto updateParam) {
        return memberActionRepository.completeMemberAction(memberActionId, updateParam);
    }

    // 주어진 회원 ID의 상태가 '진행중'인 행동을 반환하는 메서드
    public List<MemberAction> getOngoingActionsByMemberId(String memberId) {
        return memberActionRepository.findOngoingActionsByMemberId(memberId);
    }

    // 주어진 회원 ID의 상태가 '완료'인 행동을 반환하는 메서드
    public List<MemberAction> getCompletedActionsByMemberId(String memberId) {
        return memberActionRepository.findCompletedActionsByMemberId(memberId);
    }

    // 특정 멤버의 기분을 나아지게 한 행동 2개를 반환하는 메서드
    public List<MemberAction> getFeelBetterActions(String memberId) {
        return memberActionRepository.findFeelBetterActions(memberId);
    }
}
