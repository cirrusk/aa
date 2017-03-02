package amway.com.academy.lms.common;

import java.io.IOException;
import java.io.InputStream;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Properties;


public class LmsCode {

	//나중에 세션 키 값 설정되면 변경할 것
	public static String adminSessionId = "admin";
	
	public static String userSessionUid = "uid";
	public static String userSessionName = "name";
	public static String userSessionAboTypeCode = "abotypecode"; // 회원타입 MEMBER 테이블의 CUSTOMERGUBUN
	public static String userSessionAboTypeOrder = "abotypeorder";
	public static String userSessionPinCode = "pincode";    // 핀코드  MEMBER 테이블의 GROUPS
	public static String userSessionPinOrder = "pinorder";
	public static String userSessionBonusCode = "bonuscode";    // 보너스코드  MEMBER 테이블에 없음 현재 쿼리에 하드코딩 상태
	public static String userSessionBonusOrder = "bonusorder";
	public static String userSessionAgeOrder = "ageorder";    // 나이  MEMBER 테이블의 SSN
	public static String userSessionLoaCode = "loacode";    // LOA  MEMBER 테이블의 LOAGROUP
	public static String userSessionDiaCode = "diacode";    // 다이아  MEMBER 테이블의 QUALIFYDIA
	public static String userSessionCreationtime = "diacode";    // 가입일자  MEMBER 테이블의 CREATIONTIME
	
	public static String userSessionCustomerCode = "customercode";    // DW customer
	public static String userSessionConsecutiveCode = "consecutivecode";    // DW consecutivecode
	public static String userSessionBusinessStatusCode1 = "businessstatuscode1";    // DW businessstatuscode1
	public static String userSessionBusinessStatusCode2 = "businessstatuscode2";    // DW businessstatuscode2
	public static String userSessionBusinessStatusCode3 = "businessstatuscode3";    // DW businessstatuscode3
	public static String userSessionBusinessStatusCode4 = "businessstatuscode4";    // DW businessstatuscode4
	
	// categoryId 설정
	public static String categoryIdOnlineBiz = "1"; 						//LMSCATEGORY 테이블- 온라인강의 비즈니스 이해
	public static String categoryIdOnlineBizSolution = "2"; 			//LMSCATEGORY 테이블- 온라인강의 비즈니스 솔루션
	public static String categoryIdOnlineNutrilite = "3"; 				//LMSCATEGORY 테이블- 온라인강의 뉴트리라이트
	public static String categoryIdOnlineArtistry = "4"; 				//LMSCATEGORY 테이블- 온라인강의  아티스트리
	public static String categoryIdOnlineHomeliving = "5"; 			//LMSCATEGORY 테이블- 온라인강의 홈리빙
	public static String categoryIdOnlinePersonalcare = "6"; 		//LMSCATEGORY 테이블- 온라인강의 퍼스널케어
	public static String categoryIdOnlineRecipe = "7"; 				//LMSCATEGORY 테이블- 온라인강의 레시피
	public static String categoryIdOnlineHealthNutrition = "8"; 	//LMSCATEGORY 테이블- 온라인강의 건강영양
	
	public static String categoryIdEduResourceBiz = "9"; 					//LMSCATEGORY 테이블- 교육자료 비즈니스
	public static String categoryIdEduResourceNutrilite = "10"; 			//LMSCATEGORY 테이블- 교육자료 뉴트리라이트
	public static String categoryIdEduResourceArtistry = "11"; 			//LMSCATEGORY 테이블- 교육자료  아티스트리
	public static String categoryIdEduResourcePersonalcare = "12"; 	//LMSCATEGORY 테이블- 교육자료 퍼스널케어
	public static String categoryIdEduResourceHomeliving = "13"; 		//LMSCATEGORY 테이블- 교육자료 홈리빙
	public static String categoryIdEduResourceRecipe = "14"; 			//LMSCATEGORY 테이블- 교육자료 레시피
	public static String categoryIdEduResourceHealthNutrition = "15";	//LMSCATEGORY 테이블- 교육자료 건강영양
	public static String categoryIdEduResourceMusic = "16"; 			//LMSCATEGORY 테이블- 교육자료 음원자료실
	
	// categoryId 에 따른 타이틀이미지명
	public static String categoryIdNewImg = "h1_w030400100.gif"; 					//신규
	public static String categoryIdBestImg = "h1_w030400200.gif"; 					//인기
	public static String categoryIdBizImg = "h1_w030400300.gif"; 					//비즈니스 이해
	public static String categoryIdBizSolutionImg = "h1_w030400400.gif"; 		//비즈니스 솔루션
	public static String categoryIdNutriliteImg = "h1_w030400500.gif"; 				//뉴트리라이트
	public static String categoryIdArtistryImg = "h1_w030400600.gif"; 				//아티스트리
	public static String categoryIdHomelivingImg = "h1_w030400700.gif"; 			//홈리빙
	public static String categoryIdPersonalcareImg = "h1_w030400800.gif"; 		//퍼스널케어
	public static String categoryIdRecipeImg = "h1_w030400900.gif"; 				//레시피
	public static String categoryIdHealthNutritionImg = "h1_w030401000.gif"; 	//건강영양
	public static String categoryIdEduBizImg = "h1_w030600300.gif"; 				//비즈니스
	public static String categoryIdMusicImg = "h1_w030601000.gif"; 				//음원자료실
	
	// 일반스탬프
	public static String stampId4 = "1"; 		//stamp 4주 개근 번호			
	public static String stampId12 = "2";		//stamp 12주 개근 번호
	public static String stampId24 = "3";		//stamp 24주 개근 번호
	public static String stampId48 = "4";		//stamp 48주 개근 번호
	public static String stampIdOnline = "5";	//온라인 100회 수강완료
	public static String stampIdOffline = "6";	//오프라인 30회 수강완료
	public static String stampIdData = "7";	//교육자료 200회 수료
	public static String stampIdSns = "8";		//sns 공유 100회
	

	//숫자 고정값
	//public static final int ZERO = 0;
	//public static final int ONE = 1;
	//public static final int TWO = 2;
	//public static final int THREE = 3;
	//public static final int FOUR = 4;
	//public static final int FIVE = 5;
	//public static final int SIX = 6;
	//public static final int SEVEN = 7;
	//public static final int EIGHT = 8;
	//public static final int NINE = 9;
	public static final int TEN = 10;
	//public static final int TWENTY = 20;
	public static final int TWENTYFIVE = 25;
	
	
	public static String abnHttpDomain = "http://qa2.abnkorea.co.kr"; 				//abnkorea http qa 도메인(임시)
	
	private static String courseTypeTxt = "온라인과정,오프라인과정,교육자료,라이브과정,정규과정,설문";
	private static String courseTypeVal = "O,F,D,L,R,V";
	
	private static String openTxt = "공개,비공개";
	private static String openVal = "Y,N";

	private static String complianceTxt = "적용,비적용";
	private static String complianceVal = "Y,N";

	private static String courseOpenTxt = "공개,비공개,정규과정 공개";
	private static String courseOpenVal = "Y,N,C";

	private static String dataTxt = "동영상,오디오,문서,링크,이미지";
	private static String dataVal = "M,S,F,L,I";
	
	private static String statusTxt = "교육대기,진행중,취소,완료,미완료";
	private static String statusVal = "A,S,C,Y,N";

	private static String snsTxt = "공유,비공유";
	private static String snsVal = "Y,N";

	private static String workTypeTxt = "이용권한,수강생,좌석등록,주관식점수,문제은행,VIP좌석,일반좌석,교육안내";
	private static String workTypeVal = "1,2,3,4,5,6,7,8";

	private static String placeTxt = "허용,불허";
	private static String placecVal = "Y,N";

	private static String penaltyTxt = "적용,해제";
	private static String penaltyVal = "Y,N";

	private static String seatTypeTxt = "VIP,일반";
	private static String seatTypeVal = "V,N";

	private static String seatUseTxt = "사용,비사용";
	private static String seatUseVal = "Y,N";
	
	private static String stampTypeTxt = "일반,정규과정,개인목표";
	private static String stampTypeVal = "N,C,U";

	private static String mustTxt = "필수,선택";
	private static String mustVal = "Y,N";

	private static String finishTxt = "수료,미수료";
	private static String finishVal = "Y,N";

	private static String togetherRequestTxt = "신청,미신청";
	private static String togetherRequestVal = "Y,N";
	
	private static String requestChannelTxt = "온라인,매뉴얼,현장등록";
	private static String requestChannelVal = "O,M,D";

	private static String studyTxt = "시작,미시작";
	private static String studyVal = "Y,N";

	private static String attendTxt = "바코드,매뉴얼";
	private static String attendVal = "Y,N";

	private static String surveyTypeTxt = "선일형,선다형,단답형,서술형";
	private static String surveyTypeVal = "1,2,3,4";

	private static String testTypeTxt = "온라인,오프라인";
	private static String testTypeVal = "O,F";

	private static String answerTypeTxt = "선일형,선다형,주관식";
	private static String answerTypeVal = "1,2,3";

	private static String useTxt = "사용,중지";
	private static String useVal = "Y,S";

	private static String hourTxt = "00시,01시,02시,03시,04시,05시,06시,07시,08시,09시,10시,11시,12시,13시,14시,15시,16시,17시,18시,19시,20시,21시,22시,23시";
	private static String hourVal = "00,01,02,03,04,05,06,07,08,09,10,11,12,13,14,15,16,17,18,19,20,21,22,23";

	private static String minuteTxt = "00분,10분,20분,30분,40분,50분";
	private static String minuteVal = "00,10,20,30,40,50";

	
	//데티어 가져오는 함수
	public static String getMinuteValue( int inVal ) {
		String getValue = "";
		for( int i=0; i<60; i++ ) {
			if( i == inVal ) {
				if( i < TEN ) {
					getValue = "0" + i +"분";
				} else {
					getValue = i +"분";
				}
				break;
			}
		}
		
		return getValue;
	}	
	
	public static String getSecondValue( int inVal ) {
		String getValue = "";
		for( int i=0; i<60; i++ ) {
			if( i == inVal ) {
				if( i < TEN ) {
					getValue = "0" + i +"초";
				} else {
					getValue = i +"초";
				}
				break;
			}
		}
		
		return getValue;
	}	
	
	public static String getMinuteValue( String inVal ) {
		return getValue( minuteVal,minuteTxt, inVal  );
	}	

	public static String getHourValue( String inVal ) {
		return getValue( hourVal,hourTxt, inVal  );
	}	

	public static String getUseValue( String inVal ) {
		return getValue( useVal,useTxt, inVal  );
	}	

	public static String getAnswerTypeValue( String inVal ) {
		return getValue( answerTypeVal,answerTypeTxt, inVal  );
	}	

	public static String getTestTypeValue( String inVal ) {
		return getValue( testTypeVal,testTypeTxt, inVal  );
	}	

	public static String getSurveyTypeValue( String inVal ) {
		return getValue( surveyTypeVal,surveyTypeTxt, inVal  );
	}	

	public static String getAttendValue( String inVal ) {
		return getValue( attendVal,attendTxt, inVal  );
	}	
	
	public static String getStudyValue( String inVal ) {
		return getValue( studyVal,studyTxt, inVal  );
	}	
	
	public static String getRequestChannelValue( String inVal ) {
		return getValue( requestChannelVal,requestChannelTxt, inVal  );
	}	

	public static String getTogetherRequestValue( String inVal ) {
		return getValue( togetherRequestVal,togetherRequestTxt, inVal  );
	}	

	public static String getFinishValue( String inVal ) {
		return getValue( finishVal,finishTxt, inVal  );
	}	

	public static String getMustValue( String inVal ) {
		return getValue( mustVal,mustTxt, inVal  );
	}	

	public static String getStampTypeValue( String inVal ) {
		return getValue( stampTypeVal,stampTypeTxt, inVal  );
	}	

	public static String getSeatUseValue( String inVal ) {
		return getValue( seatUseVal,seatUseTxt, inVal  );
	}	
	
	public static String getSeatTypeValue( String inVal ) {
		return getValue( seatTypeVal,seatTypeTxt, inVal  );
	}	

	public static String getStampValue( String inVal ) {
		return getValue( complianceVal,complianceTxt, inVal  );
	}	

	public static String getPenaltyValue( String inVal ) {
		return getValue( penaltyVal,penaltyTxt, inVal  );
	}	

	public static String getOfflinePenaltyValue( String inVal ) {
		return getValue( complianceVal,placeTxt, inVal  );
	}	
	
	public static String getTogetherValue( String inVal ) {
		return getValue( placecVal,complianceTxt, inVal  );
	}
	
	public static String getPlaceValue( String inVal ) {
		return getValue( placecVal,complianceTxt, inVal  );
	}	
	
	public static String getWorkTypeValue( String inVal ) {
		return getValue( workTypeVal,workTypeTxt, inVal  );
	}	
	
	public static String getOpenValue( String inVal ) {
		return getValue( openVal,openTxt, inVal  );
	}
	
	public static String getComplianceValue( String inVal ) {
		return getValue( complianceVal,complianceTxt, inVal  );
	}

	public static String getCopyrightValue( String inVal ) {
		return getValue( complianceVal,complianceTxt, inVal  );
	}
	
	public static String getCourseOpenValue( String inVal ) {
		return getValue( courseOpenVal,courseOpenTxt, inVal  );
	}
	
	public static String getDataValue( String inVal ) {
		return getValue( dataVal,dataTxt, inVal  );
	}

	public static String getStatusValue( String inVal ) {
		return getValue( statusVal,statusTxt, inVal  );
	}
	
	public static String getSnsValue( String inVal ) {
		return getValue( snsVal,snsTxt, inVal  );
	}

	public static String getGroupValue( String inVal ) {
		return getValue( complianceVal,complianceTxt, inVal  );
	}
	
	//데이터 가죠오는 리스트
	public static List<HashMap<String,String>> getSecondList() {
		List<HashMap<String,String>> list = new ArrayList<HashMap<String,String>>();
		

			String getValue = "";
			String getName = "";
			for( int i=0; i<60; i++ ) {
				if( i < TEN ) {
					getValue = "0" + i;
					getName = "0" + i +"초";
				} else {
					getValue = i +"";
					getName = i +"초";
				}
				
				HashMap<String,String> hMap = new HashMap<String,String>();
				
				hMap.put("name", getName);
				hMap.put("value", getValue);
				
				list.add(hMap);				
			}			

		
		return list;
	}
	
	public static List<HashMap<String,String>> getMinuteList() {
		List<HashMap<String,String>> list = new ArrayList<HashMap<String,String>>();
		

			String getValue = "";
			String getName = "";
			for( int i=0; i<60; i++ ) {
				if( i < TEN ) {
					getValue = "0" + i;
					getName = "0" + i +"분";
				} else {
					getValue = i +"";
					getName = i +"분";
				}
				
				HashMap<String,String> hMap = new HashMap<String,String>();
				
				hMap.put("name", getName);
				hMap.put("value", getValue);
				
				list.add(hMap);				
			}			
			

		
		return list;
	}
	
	public static List<HashMap<String,String>> getMinute2List() {
		return getArrayList( minuteTxt, minuteVal );
	}
	
	public static List<HashMap<String,String>> getHourList() {
		return getArrayList( hourTxt, hourVal );
	}
	
	public static List<HashMap<String,String>> getCourseOpenList() {
		return getArrayList( courseOpenTxt, courseOpenVal );
	}
	
	public static List<HashMap<String,String>> getWorkTypeList() {
		return getArrayList( workTypeTxt, workTypeVal );
	}
	
	public static List<HashMap<String,String>> getCourseTypeList() {
		return getArrayList( courseTypeTxt, courseTypeVal );
	}
	
	public static List<HashMap<String,String>> getSurveyTypeList() {
		return getArrayList( surveyTypeTxt, surveyTypeVal );
	}
	
	public static List<HashMap<String,String>> getAnswerTypeList() {
		return getArrayList( answerTypeTxt, answerTypeVal );
	}

	public static List<HashMap<String,String>> getUseList() {
		return getArrayList( useTxt, useVal );
	}
	
	
	public static List<HashMap<String,String>> getDataList() {
		return getArrayList( dataTxt, dataVal );
	}
	
	public static List<HashMap<String,String>> getStatusList() {
		return getArrayList( statusTxt, statusVal );
	}
	
	/**
	 * get list
	 * @return
	 */
	public static List<HashMap<String,String>> getArrayList( String inTxt, String inVal ) {
		List<HashMap<String,String>> list = new ArrayList<HashMap<String,String>>();
		
		if( inVal == null || inVal.equals("") || inTxt == null || inTxt.equals("") ) {
			return null;
		}
		

			String[] inValArray = inVal.split("[,]");
			String[] inTxtArray = inTxt.split("[,]");
			
			for( int i=0; i<inValArray.length; i++ ) {
				HashMap<String,String> hMap = new HashMap<String,String>();
				
				hMap.put("name", inTxtArray[i]);
				hMap.put("value", inValArray[i]);
				
				list.add(hMap);
			}
			

		
		return list;
	}
	
	
	public static String getValue( String inVal, String inTxt, String input ) {
		String returnVal = "";
		
		if( inVal == null || inVal.equals("") ) {
			return null;
		}
		
		
			String[] inValArray = inVal.split("[,]");
			String[] inTxtArray = inTxt.split("[,]");
			for( int i=0; i<inValArray.length; i++ ) {
				if( inValArray[i].equals( input ) ) {
					returnVal = inTxtArray[i];
					break;
				}
			}
		
		
		return returnVal;
	}

	public static String getMaxOrder( int cnt ) {
		String returnValue = "A";
		
		String inVal = "A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z";
		String[] inArr = inVal.split("[,]");
		
		if( cnt <= TWENTYFIVE ) {
			returnValue = inArr[cnt];
		}
		
		return returnValue;
	}
	
	public static String getHybrisHttpDomain() {
		String returnValue = "";
		
		String resourceName = "/config/props/framework.properties";
		ClassLoader loader = Thread.currentThread().getContextClassLoader();
		Properties props = new Properties();
		try( InputStream resourceStream = loader.getResourceAsStream(resourceName) ) {
			props.load(resourceStream);
			//삼성 하이브리스 체크 url
			returnValue = props.getProperty("Hybris.httpDomain");
		} catch( IOException e) {
			e.printStackTrace();
		}

		return returnValue;
	}
	
}
