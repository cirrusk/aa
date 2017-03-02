package amway.com.academy.manager.lms.common.service.impl;

import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Vector;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import amway.com.academy.manager.common.push.PushSend;
import amway.com.academy.manager.lms.common.service.LmsCommonService;
import amway.com.academy.manager.lms.course.service.impl.LmsCourseMapper;
import framework.com.cmm.lib.DataBox;
import framework.com.cmm.lib.RequestBox;

@Service
public class LmsCommonServiceImpl implements LmsCommonService {

	@SuppressWarnings("unused")
	private static final Logger LOGGER = LoggerFactory.getLogger(LmsCommonServiceImpl.class);
	
	@Autowired
	private LmsCourseMapper lmsCourseMapper;
	
	@Autowired
	private LmsCommonMapper lmsCommonMapper;
	
	@Autowired
	private PushSend pushSend;
	
	// 공통코드 리스트
	@Override
	public List<DataBox> selectLmsCommonCodeList(RequestBox requestBox) throws Exception {
		return lmsCommonMapper.selectLmsCommonCodeList(requestBox);
	}
	
	
	// 교육분류 리스트
	@Override
	public List<DataBox> selectLmsCategoryCodeList(RequestBox requestBox) throws Exception {
		return lmsCommonMapper.selectLmsCategoryCodeList(requestBox);
	}

	// 교육분류 3단
	@Override
	public DataBox selectLmsCategoryCode3Depth(RequestBox requestBox) throws Exception {
		return lmsCommonMapper.selectLmsCategoryCode3Depth(requestBox);
	}
	
	// 교육장소 코드 리스트
	@Override
	public List<DataBox> selectLmsApCodeList(RequestBox requestBox) throws Exception {
		return lmsCommonMapper.selectLmsApCodeList(requestBox);
	}
	
	// 교육장소강의실 코드 리스트
	@Override
	public List<DataBox> selectLmsRoomCodeList(RequestBox requestBox) throws Exception {
		return lmsCommonMapper.selectLmsRoomCodeList(requestBox);
	}

	/**
	 * 쪽지 등록
	 * @param Map
	 * @return
	 */
	@Override
	public int insertLmsNoteSend(RequestBox requestBox) throws Exception {
		
		/* noteservice
		 * 1. LMS 
		 * 2.비즈니스(교육비)  
		 * 3.비즈니스(시설)  
		 * 4.비즈니스(체험)  
		 * 5.비즈니스(측정)
		 * */
		
		/*noteitem
		 * 101. 오프라인교육 신청완료, 라이브과정, 정규과정 추가됨 AKL ECM 1.5 AI SITAKEAISIT-1502
		 * 102. 오프라인교육 교육일 1일전 리마인드
		 * 103. 오프라인교육 신청취소, 라이브과정, 정규과정 추가됨 AKL ECM 1.5 AI SITAKEAISIT-1502
		 * 
		 * 111. 오프라인교육 좌석배치
		 * 112. 안내컨텐트 배지획득
		 * 113. 안내컨텐트 개인화 컨텐츠 알림- 회사제공
		 * 114. 안내컨텐트 개인화 컨텐츠 알림 - 본인구독
		 * 115. 안내컨텐트 교육오픈 - 타켓(대상자 한정)
		 * 116. 안내컨텐트 커리큘럼상의 다음단계 알림 (삭제됨)
		 * */
		
		/* senddate 전송예정일
		 * 즉시전송인 경우 문자열 now
		 * 일정시점인 경우 날짜형식의 String
		 */
		
		Map<String, Object> paramMap = new HashMap<String, Object>();

		int cnt = 0;
		String senddate = null;
		String notecontent = null;
		String nowdate = (String) lmsCommonMapper.selectNowDate(requestBox).get("nowdate");
		
		String fStr = "F";
		String lStr = "L";
		String rStr = "R";
		
		paramMap.put("noteservice", "1"); // 1. LMS 2.비즈니스(교육비)  3.비즈니스(시설)  4.비즈니스(체험)  5.비즈니스(측정)
		paramMap.put("name", requestBox.get("name"));
		paramMap.put("uid", requestBox.get("uid"));
		String noteitem = requestBox.getString("noteitem");
		paramMap.put("noteitem", noteitem);
		paramMap.put("modifier", requestBox.get("adminid"));
		paramMap.put("registrant", requestBox.get("adminid"));
		
		
		
		if("101".equals(noteitem)){ // 오프라인교육 신청완료
			senddate = "now";
			paramMap.put("senddate", senddate);
			
			if(fStr.equals(requestBox.get("coursetype"))){
				notecontent = "오프라인 교육 신청이 완료되었습니다. " + "\r\n"
									+ "[과정명] " + requestBox.getString("coursename") + "\r\n"
									+ "[교육장소] " + requestBox.getString("apname") + "\r\n"
									+ "[교육일] " + requestBox.getString("startdate") + "\r\n";
			}else if(lStr.equals(requestBox.get("coursetype"))){
				notecontent = "라이브 교육 신청이 완료되었습니다. " + "\r\n"
						+ "[과정명] " + requestBox.getString("coursename") + "\r\n"
						+ "[교육일] " + requestBox.getString("startdate") + "\r\n";
			}else if(rStr.equals(requestBox.get("coursetype"))){
				notecontent = "정규과정 교육 신청이 완료되었습니다. " + "\r\n"
						+ "[과정명] " + requestBox.getString("coursename") + "\r\n"
						+ "[교육일] " + requestBox.getString("startdate") + "\r\n";
			}
			/*
			notecontent = "오프라인 교육 신청이 완료되었습니다. " + "\r\n"
								+ "[과정명] " + requestBox.getString("coursename") + "\r\n"
								+ "[교육장소] " + requestBox.getString("apname") + "\r\n"
								+ "[교육일] " + requestBox.getString("startdate") + "\r\n";
			*/
			paramMap.put("notecontent", notecontent);
			
			if(paramMap.get("senddate") != null && paramMap.get("notecontent") != null){
				try{
					cnt = lmsCommonMapper.insertLmsNoteSend(paramMap);
				}catch(SQLException e){
					LOGGER.error("lmsCommonMapper.insertLmsNoteSend(paramMap) 에러");
				}
			}
		}else if("102".equals(noteitem)){ // 오프라인교육 교육 1일전
			notecontent = "";
		}else if("103".equals(noteitem)){ // 오프라인교육 신청취소
			senddate = "now";
			paramMap.put("senddate", senddate);
			
			if(fStr.equals(requestBox.get("coursetype"))){
				notecontent = "오프라인 교육 취소가 완료되었습니다. " + "\r\n"
						+ "[과정명] " + requestBox.getString("coursename") + "\r\n"
						+ "[교육장소] " + requestBox.getString("apname") + "\r\n"
						+ "[취소일] " + nowdate + "\r\n";
			}else if(lStr.equals(requestBox.get("coursetype"))){
				notecontent = "라이브 교육 취소가 완료되었습니다. " + "\r\n"
						+ "[과정명] " + requestBox.getString("coursename") + "\r\n"
						+ "[취소일] " + nowdate + "\r\n";
			}else if(rStr.equals(requestBox.get("coursetype"))){
				notecontent = "정규과정 교육 취소가 완료되었습니다. " + "\r\n"
						+ "[과정명] " + requestBox.getString("coursename") + "\r\n"
						+ "[취소일] " + nowdate + "\r\n";
			}
			/*
			notecontent = "오프라인 교육 취소가 완료되었습니다. " + "\r\n"
								+ "[과정명] " + requestBox.getString("coursename") + "\r\n"
								+ "[교육장소] " + requestBox.getString("apname") + "\r\n"
								+ "[취소일] " + nowdate + "\r\n";
			*/
			paramMap.put("notecontent", notecontent);
			DataBox member = lmsCommonMapper.selectLmsMemberInfo(requestBox);
			if(member != null){
				paramMap.put("name",member.getString("name"));
				try{
					cnt = lmsCommonMapper.insertLmsNoteSend(paramMap);
				}catch(SQLException e){
					LOGGER.error("lmsCommonMapper.insertLmsNoteSend(paramMap) 에러");
				}
			}
		}else if("114".equals(noteitem)){ // 안내컨텐트 개인화 컨텐츠 알림 - 본인구독

			senddate = "now";
			paramMap.put("senddate", senddate);
			paramMap.put("categoryid", requestBox.get("categoryid"));
			paramMap.put("courseid", requestBox.get("courseid"));
			notecontent = "카테고리 구독한 과정이 신규 등록되었습니다. " + "\r\n"
								+ "[과정명] " + requestBox.getString("coursename") + " 과정이 신규 등록 되었습니다.";
			paramMap.put("notecontent", notecontent);
		
			if(paramMap.get("senddate") != null && paramMap.get("notecontent") != null){
				try{
					cnt = lmsCommonMapper.insertLmsNoteSendLmsSubsribe(paramMap);
				}catch(SQLException e){
					LOGGER.error("lmsCommonMapper.insertLmsNoteSendLmsSubsribe(paramMap) 에러");
				}
			}

		}else if("115".equals(noteitem)){ // 안내컨텐트 교육오픈 - 타켓(대상자 한정)

			senddate = "now";
			paramMap.put("senddate", senddate);
			notecontent = " 과정에 대상자로 등록되었습니다.";			
			DataBox data = lmsCourseMapper.selectLmsCourse(requestBox);
			if(data != null){
				notecontent = data.getString("coursename") + " 과정에 대상자로 등록되었습니다.";
			}
			paramMap.put("notecontent", notecontent);
			@SuppressWarnings("unchecked")
			List<Map<String, String>> retSuccessList = (List<Map<String, String>>) requestBox.getObject("retSuccessList");
			for(int i=0; i<retSuccessList.size();i++)
			{
				Map<String,String> retMap = (Map<String,String>)retSuccessList.get(i);
				requestBox.put("uid",retMap.get("col0"));
				paramMap.put("uid", retMap.get("col0"));
				
				DataBox member = lmsCommonMapper.selectLmsMemberInfo(requestBox);
				if(member != null){
					paramMap.put("name",member.getString("name"));
					try{
						cnt = lmsCommonMapper.insertLmsNoteSend(paramMap);
					}catch(SQLException e){
						LOGGER.error("lmsCommonMapper.insertLmsNoteSend(paramMap) 에러");
					}
				}
			}
		}

		return cnt;

		
	}	
	
	// 현재 날짜 가져오기 YYYYMMDDHHMMSS
	@Override
	public DataBox selectYYYYMMDDHHMISS(RequestBox requestBox) throws Exception {
		return lmsCommonMapper.selectYYYYMMDDHHMISS(requestBox);
	}

	// 하루전 날짜 가져오기 YYYYMMDDHHMMSSMINUS
	@Override
	public DataBox selectYYYYMMDDHHMISSMINUS(RequestBox requestBox) throws Exception {
		return lmsCommonMapper.selectYYYYMMDDHHMISSMINUS(requestBox);
	}
	
	// 개인화 콘텐츠 푸시 등록
	@Override
	public DataBox insertLmsPushSendSubsribe(RequestBox requestBox) throws Exception {
		String pushUserId = "";
		Vector<String> pushUserIdVector = new Vector<String>();
		List<String> pushUserIdList = new ArrayList<String>();
		List<DataBox> list = lmsCommonMapper.selectLmsPushSendSubsribeMember(requestBox);
		int check0 = 0;
		if(list != null && list.size()>check0){
			for(int i = 0 ; i < list.size(); i++){
				pushUserIdVector.add(list.get(i).getString("uid"));
				pushUserIdList.add(list.get(i).getString("uid"));
			}
		}
		requestBox.put("pushUserId", pushUserId);
		requestBox.put("pushUserIdVector", pushUserIdVector);
		requestBox.put("pushUserIdList", pushUserIdList);
		requestBox.put("pushTitle", "카테고리 구독한 과정이 신규 등록되었습니다.");
		requestBox.put("pushMsg", "카테고리 구독한 과정이 신규 등록되었습니다. [과정명] " + requestBox.getString("coursename") + " 과정이 신규 등록 되었습니다.");
		requestBox.put("pushUrl", "weblink|/lms/myAcademy/lmsMyRecommend");
		requestBox.put("pushCategory", "ACADEMY");
		return pushSend.sendPushByFile(requestBox);
	}
	
}
