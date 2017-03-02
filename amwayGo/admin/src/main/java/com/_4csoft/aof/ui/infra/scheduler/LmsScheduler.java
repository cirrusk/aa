package com._4csoft.aof.ui.infra.scheduler;

import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.List;
import java.util.Date;

import javax.annotation.Resource;

import org.apache.commons.lang.ArrayUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.scheduling.concurrent.ThreadPoolTaskScheduler;
import org.springframework.stereotype.Component;

import com._4csoft.aof.infra.support.Constants;
import com._4csoft.aof.infra.support.util.DateUtil;
import com._4csoft.aof.infra.support.util.StringUtil;
import com._4csoft.aof.infra.vo.base.ResultSet;
import com._4csoft.aof.ui.univ.vo.condition.UIUnivCourseActiveCondition;
import com._4csoft.aof.ui.univ.vo.condition.UIUnivCourseApplyCondition;
import com._4csoft.aof.ui.univ.vo.resultset.UIUnivCourseActiveRS;
import com._4csoft.aof.ui.univ.vo.resultset.UIUnivCourseApplyRS;
import com._4csoft.aof.univ.mapper.UnivCourseActiveMapper;
import com._4csoft.aof.univ.mapper.UnivCourseApplyMapper;


@Component
public class LmsScheduler  {
	
	@Resource (name = "UIThreadPoolTaskScheduler")
	protected ThreadPoolTaskScheduler tps;
	
	@Resource (name = "UnivCourseActiveMapper")
	private UnivCourseActiveMapper courseActiveMapper;
	
	@Resource (name = "UnivCourseApplyMapper")
	private UnivCourseApplyMapper courseApplyMapper;

	@SuppressWarnings("unused")
	private static final Logger LOGGER = LoggerFactory.getLogger(LmsScheduler.class);
	
	// 계정 삭제 및 과정 변경
	@Scheduled(cron = "0 59 23 * * *") // 매일 59분 23시
	public void lmsSchedulerOffLineNoteSend() throws Exception {
		tps.setPoolSize(1);
		Long[] afterMemberseq = {};	//정보폐기 기간이 된 멤버
		Long[] beforeMemberseq = {}; //정보폐기 기간이 안된 멤버
		Long[] resultMemberseq = {}; //두가지를 비교하여 비교되어진 삭제될 멤버
		UIUnivCourseActiveCondition conditionVO = new UIUnivCourseActiveCondition();
		UIUnivCourseApplyCondition condition = new UIUnivCourseApplyCondition();
		
		List<ResultSet> list = courseActiveMapper.getList(conditionVO);//과정 리스트 전부 가져오기
		Date date; //날짜 비교를 위한 선언
		int a=0;int b=0;int c=0; //temp변수
		for(ResultSet rs : list){
			UIUnivCourseActiveRS activeRs = (UIUnivCourseActiveRS)rs;
			date = DateUtil.getFormatDate(activeRs.getCourseActive().getStudyEndDate(), Constants.FORMAT_DBDATETIME); //학습이 끝난 과정 중
			
			if(StringUtil.isNotEmpty(activeRs.getCourseActive().getExpireStartDate())){ //정보폐기 기간이 비어있지 않으면
				int expire = Integer.parseInt(activeRs.getCourseActive().getExpireStartDate()); //String -> int로 변환
				date = DateUtil.addDate(date, (expire*365)); //학습이 끝난날 + 폐기기간*365(1년)
			}
			
			if(DateUtil.getToday().after(date)){ //오늘날짜가 폐기기간보다 크면
				condition.setSrchCourseActiveSeq(activeRs.getCourseActive().getCourseActiveSeq());
				List<ResultSet> list2 = courseApplyMapper.getList(condition);
				for(ResultSet rs2 : list2){
					UIUnivCourseApplyRS applyRs = (UIUnivCourseApplyRS)rs2;
					afterMemberseq = (Long[]) ArrayUtils.add(afterMemberseq, applyRs.getApply().getMemberSeq());
				}
				b++;
			}else{ //오늘날짜가 폐기기간보다 크지않으면
				condition.setSrchCourseActiveSeq(activeRs.getCourseActive().getCourseActiveSeq());
				List<ResultSet> list3 = courseApplyMapper.getList(condition);
				for(ResultSet rs3 : list3){
					UIUnivCourseApplyRS applyRs2 = (UIUnivCourseApplyRS)rs3;
					beforeMemberseq = (Long[]) ArrayUtils.add(beforeMemberseq, applyRs2.getApply().getMemberSeq());
				}
				c++;
			}
			a++;
		}
		//resultMemberseq
		if(afterMemberseq != null && beforeMemberseq != null){
			for(int i=0; i<afterMemberseq.length; i++){
				boolean flag = true; //정보폐기 기간이 된 멤버를 걸러내는 플레그
				for(int j=0; j<beforeMemberseq.length; j++){
						//System.out.println("값1 : " + afterMemberseq[i] + " | 값2 : " +beforeMemberseq[j]);
					if(afterMemberseq[i].equals(beforeMemberseq[j])){ //정보폐기 기간이 된 멤버중에 더 들어야하는 멤버가 있다면
						flag = false; //삭제해야하는 것에 담지 않기위해 변경
					}
				}
				if(flag){
					System.out.println("flag True : " + afterMemberseq[i]);
					resultMemberseq = (Long[]) ArrayUtils.add(resultMemberseq, afterMemberseq[i]);
				}
			}
		}
		
		//삭제해야 하는 회원들
		if(resultMemberseq != null){
			for(int i=0; i<resultMemberseq.length; i++){
				System.out.println("출력 : " + resultMemberseq[i]);
			}
		}
		System.out.println("A : " + a + " / " + "B : " + b + " / " + "C : " + c);
		System.out.println("after : " + afterMemberseq.length + " / " + "before : " + beforeMemberseq.length);
		
		LOGGER.debug("MemberSchedule Delete running : " + DateUtil.getToday("yyyy/MM/dd HH:mm:ss"));
	}

/*	0 59 23 * * *
	// GLMS 연동
	@Scheduled(cron = "0 0 10 * * *") // 매일 10시00분
	public void lmsSchedulerGLMSInterface() throws Exception {
		
	}
	
	
	// MEMBER DW 연동
	@Scheduled(cron = "0 25 10 * * *") // 매일 10시25분
	public void lmsSchedulerMemberDwInterface() throws Exception {
		
	}	
	
	@Scheduled(cron = "0/10 * * * * *") // 10초 마다
	public void lmsScheduleTest() throws Exception {
		LOGGER.debug("=============10초마다==================");
	}
*/	
}