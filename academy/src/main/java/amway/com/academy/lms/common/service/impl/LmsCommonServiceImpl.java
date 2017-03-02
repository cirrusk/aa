package amway.com.academy.lms.common.service.impl;

import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import amway.com.academy.lms.common.LmsCode;
import amway.com.academy.lms.common.service.LmsCommonService;
import framework.com.cmm.lib.DataBox;
import framework.com.cmm.lib.RequestBox;

@Service
public class LmsCommonServiceImpl implements LmsCommonService {

	@SuppressWarnings("unused")
	private static final Logger LOGGER = LoggerFactory.getLogger(LmsCommonServiceImpl.class);
	
	@Autowired
	private LmsCommonMapper lmsCommonMapper;
	
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

	// 로그인 테스트
	@Override
	public DataBox selectLmsLogin(RequestBox requestBox) throws Exception {
		
		//1. 회원 읽기
		DataBox data = lmsCommonMapper.selectLmsLogin(requestBox); 
		if( data != null && !data.isEmpty() ) {
			//2. 회원 DW 읽기
			DataBox data2 = lmsCommonMapper.selectLmsDW(requestBox);
			if( data2 != null && !data2.isEmpty() ) {
				data.put("bonuscode", data2.getString("bonuscode"));
				data.put("bonusorder", data2.getString("bonusorder"));
				data.put("customercode", data2.getString("customercode"));
				data.put("consecutivecode", data2.getString("consecutivecode"));
				data.put("businessstatuscode1", data2.getString("businessstatuscode1"));
				data.put("businessstatuscode2", data2.getString("businessstatuscode2"));
				data.put("businessstatuscode3", data2.getString("businessstatuscode3"));
				data.put("businessstatuscode4", data2.getString("businessstatuscode4"));
			} else {
				data.put("bonuscode", "");
				data.put("bonusorder", "0");
				data.put("customercode", "");
				data.put("consecutivecode", "");
				data.put("businessstatuscode1", "N/A");
				data.put("businessstatuscode2", "N/A");
				data.put("businessstatuscode3", "N/A");
				data.put("businessstatuscode4", "N/A");
			}
		}
		
		return data;
	}
	
	// SNS 카운트 증가하기
	@Override
	public int mergeSnsShareCount(RequestBox requestBox) throws Exception {
		String blankStr = "";
		if(!blankStr.equals(requestBox.get("uid"))){
			
			//deadlock 해결 위해 sns 카운트 증가 및 스탬프 발행(8)을 하나의 프로시저로 만들어서 실행할 것
			requestBox.put("stampid", LmsCode.stampIdSns);
			lmsCommonMapper.insertLmsStampSns(requestBox);
			
			/*
			// 카운트 증가
			int i = lmsCommonMapper.mergeSnsShareCount(requestBox);

			// 스탬프 발행
			requestBox.put("stampid", LmsCode.stampIdSns);
			lmsCommonMapper.insertLmsStamp(requestBox);
			
			*/
			return 1;
			
		}else{
			return 0;
		}
	}
	
	@Override
	public int updateLmsLoginStamp(RequestBox requestBox) throws Exception {
		
		//1. 회원 접속 로그 및 스탬프 획득 
		return lmsCommonMapper.insertLmsconnectStamp(requestBox);
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
		 * 116. 안내컨텐트 커리큘럼상의 다음단계 알림
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
		paramMap.put("modifier", requestBox.get("uid"));
		paramMap.put("registrant", requestBox.get("uid"));
		
		if("101".equals(noteitem)){ // 오프라인교육 신청완료, 라이브과정, 정규과정 추가됨 AKL ECM 1.5 AI SITAKEAISIT-1502 
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

			paramMap.put("notecontent", notecontent);
		}else if("102".equals(noteitem)){ // 오프라인교육 교육 1일전
			senddate = "now";
			
			notecontent = "오프라인 교육 안내입니다. " + "\r\n"
								+ "[과정명] " + requestBox.getString("coursename") + "\r\n"
								+ "[교육장소] " + requestBox.getString("apname") + "\r\n"
								+ "[교육일] " + requestBox.getString("startdate") + "\r\n";
		}else if("103".equals(noteitem)){ // 오프라인교육 신청완료
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
			

			paramMap.put("notecontent", notecontent);
		}
		
		if(paramMap.get("senddate") != null && paramMap.get("notecontent") != null){
			try{
				cnt = lmsCommonMapper.insertLmsNoteSend(paramMap);
			}catch(SQLException e){
				LOGGER.error("lmsCommonMapper.insertLmsNoteSend(paramMap) 에러");
			}
			
		}
		return cnt;
		
		
	}	
	
	
	//  회원정보 잃기
	@Override
	public DataBox selectLmsMemberInfo(RequestBox requestBox) throws Exception {
		return lmsCommonMapper.selectLmsMemberInfo(requestBox);
	}
	
	//  교육자료 첨부파일 잃기
	@Override
	public DataBox selectLmsCourseDataFileInfo(RequestBox requestBox) throws Exception {
		return lmsCommonMapper.selectLmsCourseDataFileInfo(requestBox);
	}
}

