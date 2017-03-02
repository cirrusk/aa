package amway.com.academy.lms.myAcademy.service.impl;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import amway.com.academy.lms.common.service.impl.LmsCommonMapper;
import amway.com.academy.lms.myAcademy.service.LmsMyTestService;
import framework.com.cmm.lib.RequestBox;

@Service
public class LmsMyTestServiceImpl  implements LmsMyTestService{
	@Autowired
	private LmsMyTestMapper lmsMyTestMapper;

	@Autowired
	private LmsCommonMapper lmsCommonMapper;
	
	public Map<String, Object> selectLmsTest(RequestBox requestBox) throws Exception {
		
		return lmsMyTestMapper.selectLmsTest(requestBox);
	}
	
	@Override
	public int insertLmsTestAnswer(RequestBox requestBox) throws Exception {
		
		int insertCount = 0;
		
		//1. 해당 시험의 출제 정보 읽어서 랜덤하게 출제 번호 읽어오기
		List<Map<String, String>> testSubmitList = lmsMyTestMapper.selectLmsTestSubmitTestPoolList(requestBox);
		for(int i=0;i<testSubmitList.size();i++) {
			Map<String,String> testSubmitMap = testSubmitList.get(i);
			
			requestBox.put("answerseq", (i+1)+"");
			requestBox.put("testpoolid", testSubmitMap.get("testpoolid"));
			requestBox.put("testpoolpoint", testSubmitMap.get("testpoint"));
			
			insertCount = lmsMyTestMapper.insertLmsTestAnswer(requestBox);
		}
		return insertCount;
	}
	
	@Override
	public List<Map<String, Object>> selectLmsTestAnswerList(RequestBox requestBox) throws Exception {
		
		//1. 시험지 읽기
		List<Map<String, Object>> answerList = lmsMyTestMapper.selectLmsTestAnswerList(requestBox);
		
		//2. 보기 읽기
		List<Map<String, String>> answerSampleList = lmsMyTestMapper.selectLmsTestAnswerSampleList(requestBox);
		
		for( int i=0; i<answerList.size(); i++ ) {
			Map<String,Object> tempAnswerMap = answerList.get(i);
			
			List<Map<String,String>> sampleList = new ArrayList<Map<String,String>>();
			for( int k=0;k<answerSampleList.size(); k++) {
				Map<String,String> tempSampleMap = answerSampleList.get(k);
				if( tempAnswerMap.get("testpoolid").equals( tempSampleMap.get("testpoolid")) ) {
					sampleList.add(tempSampleMap);
				}
			}
			
			tempAnswerMap.put("sampleList", sampleList);
			answerList.set(i, tempAnswerMap);
		}
		
		return answerList;
	}
	
	@Override
	public int updateLmsMyTestInit(RequestBox requestBox) throws Exception {
		return lmsMyTestMapper.updateLmsMyTestInit(requestBox);
	}
	
	@Override
	public int updateLmsTestAnswer(RequestBox requestBox) throws Exception {
		return lmsMyTestMapper.updateLmsTestAnswer(requestBox);
	}
	
	@Override
	public int submitLmsTestAnswer(RequestBox requestBox) throws Exception {
		
		int resultCount = 0;
		
		//시험에 주관식 문제가 없다면 문제 수정 및 수료 처리 진행
		//시험에 주관식 있으면 수료 처리 미 진행 --> 관리자에서 주관식 채점시 수료 처리 진행함
		String testFlag = lmsMyTestMapper.selectLmsTestStudent(requestBox);
		
		//마지막 문제 수정하기
		resultCount = lmsMyTestMapper.updateLmsTestAnswer(requestBox);

		//1. 답안지 점수 업데이트 하기
		resultCount = lmsMyTestMapper.updateLmsTestAnswerPoint(requestBox);

		//2. 온라인 점수 합계 입력하기
		resultCount = lmsMyTestMapper.updateLmsStudentPoint(requestBox);

		if( "Y".equals(testFlag) ) {
	
			//3. 시험 수료 확인
			resultCount = lmsMyTestMapper.updateLmsStudentFinish(requestBox);
			
			//4. 과정 step 수료 여부 확인하기 : courseid, stepseq, uid 필요함
			resultCount = lmsCommonMapper.updatetLmsStepFinish(requestBox);
			
			//5. 전체 수료 여부 확인하기 : courseid, uid 필요함
			resultCount = lmsCommonMapper.updatetLmsTotalFinish(requestBox);
			
			//6.정규과정 스탬프 발행
			//uid, courseid
			lmsCommonMapper.insertLmsRegularStamp(requestBox);
		} else {
			//3. 시험 수료 확인 : finishFlag update
			resultCount = lmsMyTestMapper.updateLmsStudentFinish2(requestBox);
		}
		
		return resultCount;
	}
	
	@Override
	public int selectLmsTestLimitTime(RequestBox requestBox) throws Exception {
		return lmsMyTestMapper.selectLmsTestLimitTime(requestBox);
	}
}
