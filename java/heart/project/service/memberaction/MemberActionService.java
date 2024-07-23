package heart.project.service.memberaction;

import heart.project.domain.MemberAction;
import heart.project.repository.memberaction.MemberActionRepository;
import heart.project.repository.memberaction.MemberActionUpdateApiDto;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

@Service
@RequiredArgsConstructor
public class MemberActionService {

    private final MemberActionRepository memberActionRepository;

    // 새로운 멤버 행동을 저장하고, 기본 상태를 '진행중'으로 설정하여 반환하는 메서드
    public MemberAction save(MemberAction memberAction) {
        return memberActionRepository.save(memberAction);
    }

    // 행동 후 감정 변화를 갱신하고, 상태를 '완료'로 바꾸는 메서드
    public void completeMemberAction(Integer memberActionId, MemberActionUpdateApiDto updateParam) {
        memberActionRepository.completeMemberAction(memberActionId, updateParam);
    }
}
