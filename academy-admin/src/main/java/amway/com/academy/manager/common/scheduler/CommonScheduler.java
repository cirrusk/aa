package amway.com.academy.manager.common.scheduler;

import amway.com.academy.manager.common.commoncode.service.impl.ManageCodeMapper;
import amway.com.academy.manager.common.util.CommomCodeUtil;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;

import java.util.HashMap;
import java.util.Map;

@Component
public class CommonScheduler {

	@SuppressWarnings("unused")
	private static final Logger LOGGER = LoggerFactory.getLogger(CommonScheduler.class);

	@Autowired
	private CommomCodeUtil commonCodeUtil;

	@Autowired
	private ManageCodeMapper manageCodeMapper;
	
	// 탈퇴회원 관련 테이블 update
	@Scheduled(cron = "0 40 4 * * *") // 매일 4시40분
	public void memberDropUpdate() throws Exception {
		if( commonCodeUtil.getSchedulerUseYn() ){ // 스케줄러 실행 설정 된 서버만 실행한다.
			Map<String, Object> map = new HashMap<String, Object>();
			map.put("RETURN", "");
			manageCodeMapper.memberDropUpdate(map);
			LOGGER.debug("============= 탈퇴회원 관련 테이블 update 매일 4시40분 ==================   " + map.get("RETURN") + "    =====================");
		}
	}

}