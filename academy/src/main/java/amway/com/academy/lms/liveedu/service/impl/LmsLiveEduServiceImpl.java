package amway.com.academy.lms.liveedu.service.impl;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import framework.com.cmm.lib.RequestBox;
import amway.com.academy.lms.liveedu.service.LmsLiveEduService;
import amway.com.academy.lms.myAcademy.service.impl.LmsMySurveyMapper;
import amway.com.academy.lms.main.service.impl.LmsMainMapper;
import amway.com.academy.lms.common.service.impl.LmsCommonMapper;

@Service
public class LmsLiveEduServiceImpl  implements LmsLiveEduService {
	@Autowired
	private LmsLiveEduMapper lmsLiveEduMapper;
	
	@Autowired
	private LmsMySurveyMapper lmsMySurveyMapper;
	
	@Autowired
	private LmsMainMapper lmsMainMapper;
	
	@Autowired
	private LmsCommonMapper lmsCommonMapper;
	
	int zero = 0;
	/**
	 * 라이브교육 시청
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	@Override
	public List<Map<String, Object>> selectLiveEduList(RequestBox requestBox) throws Exception {
		
		// 교육과정 조회
		List<Map<String, Object>> liveEduList = lmsLiveEduMapper.selectLiveEduList(requestBox);
		
		return liveEduList;
	}
	
	public void updateFinishProcess(RequestBox requestBox) throws Exception {
		lmsMySurveyMapper.updateLmsStudentFinish(requestBox);
	}
	
	public void updateFinishProcess2(RequestBox requestBox) throws Exception {
		
		lmsMySurveyMapper.updateLmsStudentFinish(requestBox); //수료 확인 : stepcourseid, uid 필요함
		
		List<Map<String, Object>> listData = lmsMainMapper.selectStepunitList(requestBox);  // LMSSTEPUNIT에서 stepseq 가져옴.
		if(listData.size() > zero)  {
			requestBox.put("stepseq", (String) listData.get(0).get("stepseq").toString());
			requestBox.put("courseid", (String) listData.get(0).get("courseid").toString());

			lmsCommonMapper.updatetLmsStepFinish(requestBox); //과정 step 수료 여부 확인하기 : courseid, stepseq, uid 필요함
			lmsCommonMapper.updatetLmsTotalFinish(requestBox); //전체 수료 여부 확인하기 : courseid, uid 필요함
		}
	}
	
}
