package amway.com.academy.manager.common.scheduler;

import java.util.HashMap;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;

import amway.com.academy.manager.common.util.CommomCodeUtil;
import amway.com.academy.manager.lms.common.service.impl.LmsCommonMapper;
import amway.com.academy.manager.lms.common.service.impl.LmsCommonServiceImpl;

@Component
public class LmsScheduler  {

	@SuppressWarnings("unused")
	private static final Logger LOGGER = LoggerFactory.getLogger(LmsCommonServiceImpl.class);
	
	@Autowired
	private CommomCodeUtil commonCodeUtil;
	
	@Autowired
	private LmsCommonMapper lmsCommonMapper;
	
	// 오프라인 1일전 리마인드 쪽지
	@Scheduled(cron = "0 45 10 * * *") // 매일 10시45분
	public void lmsSchedulerOffLineNoteSend() throws Exception {
		if( commonCodeUtil.getSchedulerUseYn() ){ // 스케줄러 실행 설정 된 서버만 실행한다.
			Map<String, Object> map = new HashMap<String, Object>();
			map.put("RETURN", "");
			lmsCommonMapper.lmsSchedulerOffLineNoteSend(map);
			LOGGER.debug("============= 오프라인 1일전 리마인드 쪽지 매일 10시45분 ==================   " + map.get("RETURN") + "    =====================");
		}
	}

	// GLMS 연동
	@Scheduled(cron = "0 0 10,12 * * *") // 매일 10시00분, 12시00분
	public void lmsSchedulerGLMSInterface() throws Exception {
		if( commonCodeUtil.getSchedulerUseYn() ){ // 스케줄러 실행 설정 된 서버만 실행한다.
			Map<String, Object> map = new HashMap<String, Object>();
			map.put("NOWDATE", "");
			map.put("RETURN", "");
			lmsCommonMapper.lmsSchedulerGLMSInterface(map);
			LOGGER.debug("============= GLMS 연동 매일 10시00분 ==================   " + map.get("RETURN") + "    =====================");
		}
	}
	
	
	// MEMBER DW 연동
	@Scheduled(cron = "0 25 10 * * *") // 매일 10시25분
	public void lmsSchedulerMemberDwInterface() throws Exception {
		if( commonCodeUtil.getSchedulerUseYn() ){ // 스케줄러 실행 설정 된 서버만 실행한다.
			Map<String, Object> map = new HashMap<String, Object>();
			map.put("NOWDATE", "");
			map.put("RETURN", "");
			lmsCommonMapper.lmsSchedulerMemberDwInterface(map);
			LOGGER.debug("============= MEMBER DW 연동 매일 10시25분 ==================   " + map.get("RETURN") + "    =====================");
		}
	}	
	
/*	
	@Scheduled(cron = "0/10 * * * * *") // 10초 마다
	public void lmsScheduleTest() throws Exception {
		LOGGER.debug("=============10초마다==================");
	}
*/	
}