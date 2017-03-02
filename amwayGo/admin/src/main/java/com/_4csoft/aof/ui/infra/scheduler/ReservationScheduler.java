package com._4csoft.aof.ui.infra.scheduler;

import java.util.List;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.scheduling.concurrent.ThreadPoolTaskScheduler;
import org.springframework.stereotype.Component;

import com._4csoft.aof.infra.mapper.MemberMapper;
import com._4csoft.aof.infra.mapper.RolegroupMemberMapper;
import com._4csoft.aof.infra.support.security.PasswordEncoder;
import com._4csoft.aof.infra.support.util.DateUtil;
import com._4csoft.aof.infra.support.util.StringUtil;
import com._4csoft.aof.infra.vo.LoginStatusVO;
import com._4csoft.aof.infra.vo.RolegroupMemberVO;
import com._4csoft.aof.ui.infra.mapper.UIMemberMapper;
import com._4csoft.aof.ui.infra.vo.UIMemberVO;
import com._4csoft.aof.univ.mapper.UnivCourseActiveMapper;
import com._4csoft.aof.univ.mapper.UnivCourseActiveSummaryMapper;
import com._4csoft.aof.univ.mapper.UnivCourseApplyMapper;
import com._4csoft.aof.univ.service.impl.UnivCourseApplyServiceImpl;
import com._4csoft.aof.univ.vo.UnivCourseApplyVO;

@Component
public class ReservationScheduler  {
	private static final Logger LOGGER = LoggerFactory.getLogger(ReservationScheduler.class);
	
	@Resource (name = "UIThreadPoolTaskScheduler")
	protected ThreadPoolTaskScheduler tps;
	
	@Resource (name = "UnivCourseActiveSummaryMapper")
	private UnivCourseActiveSummaryMapper courseActiveSummaryMapper;
	
	@Resource (name = "UnivCourseApplyMapper")
	private UnivCourseApplyMapper courseApplyMapper;
	
	@Resource (name = "UnivCourseApplyService")
	private UnivCourseApplyServiceImpl UnivCourseApplyService;

	@Resource (name = "UnivCourseActiveMapper")
	private UnivCourseActiveMapper courseActiveMapper;
	
	@Resource (name = "UIMemberMapper")
	protected UIMemberMapper uiMemberMapper;
	
	@Resource (name = "MemberMapper")
	private MemberMapper memberMapper;
	
	@Resource (name = "RolegroupMemberMapper")
	private RolegroupMemberMapper rolegroupMemberMapper;
	
	@Resource (name = "UIPasswordEncoder")
	protected PasswordEncoder passwordEncoder;

	@Scheduled(cron = "0 0 20 * * *") // 2분 마다  0 0/2 * * * *
	public void reservationRegularPurchaseNumberInsert() throws Exception {
		tps.setPoolSize(1);
		
		Long courseActiveSeq = 0L;
		
		LoginStatusVO courseStatus = new LoginStatusVO();
		courseStatus.setRegMemberSeq(new Long(1));
		courseStatus.setRegIp("127.0.0.1");
		courseStatus.setUpdMemberSeq(new Long(1));
		courseStatus.setUpdIp("127.0.0.1");
		
		// 마스터과정 삽입
		uiMemberMapper.academyCourse(courseStatus);
		
		// 마스터과정 삽입 후 기수삽입
		uiMemberMapper.academyCourseActive(courseStatus);
		
		// 기수 삽입 후 게시판 기본셋팅 설정
		uiMemberMapper.boardNoticeInsert();
		uiMemberMapper.boardQnaInsert();
		uiMemberMapper.boardHomeworkInsert();
		uiMemberMapper.boardChattingInsert();
		uiMemberMapper.boardCourseTeamInsert();
		uiMemberMapper.boardTeamProjectInsert();
		uiMemberMapper.boardFreeInsert();
		uiMemberMapper.boardAskInsert();
		uiMemberMapper.boardDiscussInsert();
		
		// 기수 기본 집계정보 삽입
		uiMemberMapper.academyCourseActiveSummary();
		
		// LMS회원 view테이블에서 기존테이블로 삽입
		List<UIMemberVO> lmsMmeber = uiMemberMapper.getLmsMember();
		for(UIMemberVO member : lmsMmeber){
			int existenceCount = memberMapper.countByMemberId(member.getMemberId(), null);
			
			if (existenceCount > 0) {
				continue;
			}
			
			// 필수 정보 픽스저장
			member.setPassword("111111");
			member.setEmailYn("N");
			member.setSmsYn("N");
			member.setMemberStatusCd("MEMBER_STATUS::APPROVAL");
			member.setDeleteYn("N");
			member.setRegMemberSeq(new Long(1));
			member.setUpdMemberSeq(new Long(1));
			member.setCategoryOrganizationSeq(new Long(13));
			member.setRegIp("127.0.0.1");
			member.setUpdIp("127.0.0.1");
			String salt = passwordEncoder.isUseSalt() ? passwordEncoder.encodePassword("admin", "") : "";
			member.setPassword(passwordEncoder.encodePassword(member.getPassword(), salt) + salt);
			
			memberMapper.insert(member);
			
			RolegroupMemberVO rolegroupMember = new RolegroupMemberVO();
			
			rolegroupMember.copyAudit(member);
			
			// 롤그룹 멤버 저장
			rolegroupMember.setMemberSeq(member.getMemberSeq());
			rolegroupMember.setRolegroupSeq(new Long(2));
			
			rolegroupMemberMapper.insert(rolegroupMember);
		}
		
		//view테이블에서 수강신청목록 가져오기
		List<UnivCourseApplyVO> lmsApply = uiMemberMapper.getLmsCourseMember();
		
		// [1]. view테이블의 수강신청 목록 생성
		for(UnivCourseApplyVO apply : lmsApply){
			// [2]. 중복 검사 - 수강취소가 아닌 조건
			if (courseApplyMapper.countCourseApply(apply.getCourseActiveSeq(), apply.getMemberSeq()) > 0) {
				continue;
			}
			apply.setRegMemberSeq(new Long(1));
			apply.setRegIp("127.0.0.1");
			apply.setUpdMemberSeq(new Long(1));
			apply.setUpdIp("127.0.0.1");
			apply.setApplyStatusCd("APPLY_STATUS::002");
			// [3]. 데이타 저장
			courseApplyMapper.insert(apply);

			courseActiveSeq = apply.getCourseActiveSeq();
			
			if (StringUtil.isNotEmpty(courseActiveSeq)) {
				// [4]. course_active 활용수 수정
				courseActiveMapper.updateUseCount(courseActiveSeq);

				// [5]. 집계 테이블 수강생 데이터 수정
				UnivCourseApplyService.updateCourseApplyCountMember(courseActiveSeq);
			}
		}
		
		LOGGER.debug("CourseSchedule insert running : " + DateUtil.getToday("yyyy/MM/dd HH:mm:ss"));
		
	}
	
}