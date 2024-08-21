package heart.project.repository.mybatis;

import heart.project.domain.MemberAction;
import heart.project.repository.memberaction.MemberActionUpdateApiDto;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;

@Mapper
public interface MemberActionMapper {

    // 동일한 회원과 날짜에 진행중 상태의 공개 행동이 있으면 비공개로 변경하는 메서드
    void preSave(MemberAction memberAction);

    // 새로운 멤버 행동을 저장하고, 기본 상태를 '진행중'으로 설정하여 반환하는 메서드
    void save(MemberAction memberAction);

    // 방금 저장된 멤버 행동을 조회하여 반환하는 메서드
    MemberAction findNewMemberAction();

    // 행동 후 감정 변화를 갱신하고, 상태를 '완료'로 바꾸는 메서드
    void completeMemberAction(@Param("memberActionId") Integer memberActionId, @Param("updateParam") MemberActionUpdateApiDto updateParam);

    // 주어진 멤버 행동 ID에 해당하는 멤버 행동을 조회하는 메서드
    MemberAction selectMemberActionById(@Param("memberActionId") Integer memberActionId);

    // 주어진 회원 ID의 상태가 '진행중'인 행동을 반환하는 메서드
    List<MemberAction> findOngoingActionsByMemberId(String memberId);

    // 주어진 회원 ID의 상태가 '완료'인 행동을 반환하는 메서드
    List<MemberAction> findCompletedActionsByMemberId(String memberId);

    // 특정 멤버의 기분을 나아지게 한 행동 2개를 반환하는 메서드
    List<MemberAction> findFeelBetterActions(String memberId);
}
