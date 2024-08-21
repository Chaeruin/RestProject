package heart.project.repository.memberaction;

import heart.project.domain.MemberAction;

import java.util.List;

public interface MemberActionRepository {

    // 새로운 멤버 행동을 저장하고, 기본 상태를 '진행중'으로 설정하여 반환하는 메서드
    MemberAction save(MemberAction memberAction);

    // 행동 후 감정 변화를 갱신하고, 상태를 '완료'로 바꾸는 메서드
    MemberAction completeMemberAction(Integer memberActionId, MemberActionUpdateApiDto updateParam);

    // 주어진 회원 ID의 상태가 '진행중'인 행동을 반환하는 메서드
    List<MemberAction> findOngoingActionsByMemberId(String memberId);

    // 주어진 회원 ID의 상태가 '완료'인 행동을 반환하는 메서드
    List<MemberAction> findCompletedActionsByMemberId(String memberId);

    // 특정 멤버의 기분을 나아지게 한 행동 2개를 반환하는 메서드
    List<MemberAction> findFeelBetterActions(String memberId);
}
