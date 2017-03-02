package com._4csoft.aof.ui.infra.mapper;

import java.util.List;

import com._4csoft.aof.infra.vo.LoginStatusVO;
import com._4csoft.aof.infra.vo.MemberVO;
import com._4csoft.aof.ui.infra.vo.UIMemberVO;
import com._4csoft.aof.ui.univ.vo.UIUnivCourseMasterVO;
import com._4csoft.aof.univ.vo.UnivCourseApplyVO;

import egovframework.rte.psl.dataaccess.mapper.Mapper;

@Mapper ("UIMemberMapper")
public interface UIMemberMapper {
	
	int countNickname(UIMemberVO memberVO);
	
	int countNameCheckNickname(UIMemberVO memberVO);
	
	void updateNickname(UIMemberVO memberVO);
	
	MemberVO academyMember(MemberVO memberVO);
	
	void academyCourse(LoginStatusVO vo);
	
	/** 과정 생성하기 */
	List<UIUnivCourseMasterVO> getMasters();
	
	/** 기수 생성하기 */
	void academyCourseActive(LoginStatusVO vo);
	
	/** 기본 집계정보 삽입 */
	void academyCourseActiveSummary();
	
	List<UIMemberVO> getLmsMember();
	
	/** LMS를 수강한 멤버 정보가져오기 */
	List<UnivCourseApplyVO> getLmsCourseMember();
	
	/** 게시판 설정 기본셋팅*/
	void boardNoticeInsert();
	void boardQnaInsert();
	void boardChattingInsert();
	void boardHomeworkInsert();
	void boardCourseTeamInsert();
	void boardTeamProjectInsert();
	void boardFreeInsert();
	void boardAskInsert();
	void boardDiscussInsert();
}
