package amway.com.academy.manager.lms.offlineMg.service.impl;

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
import amway.com.academy.manager.lms.common.service.impl.LmsCommonMapper;
import amway.com.academy.manager.lms.course.service.impl.LmsCourseMapper;
import amway.com.academy.manager.lms.offline.service.impl.LmsOfflineMapper;
import amway.com.academy.manager.lms.offlineMg.service.LmsOfflineMgService;
import framework.com.cmm.lib.DataBox;
import framework.com.cmm.lib.RequestBox;

@Service
public class LmsOfflineMgServiceImpl implements LmsOfflineMgService {

	@SuppressWarnings("unused")
	private static final Logger LOGGER = LoggerFactory.getLogger(LmsOfflineMgServiceImpl.class);
	
	@Autowired
	private LmsCommonService lmsCommonService;
	
	@Autowired
	private PushSend pushSend;
	
	@Autowired
	private LmsOfflineMgMapper lmsOfflineMgMapper;
	
	@Autowired
	private LmsCourseMapper lmsCourseMapper;

	@Autowired
	private LmsOfflineMapper lmsOfflineMapper;
	
	@Autowired
	private LmsCommonMapper lmsCommonMapper;
	
	// 오프라인 목록 카운트
	@Override
	public int selectLmsOfflineMgCount(RequestBox requestBox) throws Exception {
		return lmsOfflineMgMapper.selectLmsOfflineMgCount(requestBox);
	}
	
	// 오프라인 목록 
	@Override
	public List<DataBox> selectLmsOfflineMgList(RequestBox requestBox) throws Exception {
		return lmsOfflineMgMapper.selectLmsOfflineMgList(requestBox);
	}	
	
	//교육상태 리스트
	@Override
	public List<DataBox> selectLmsEduStatusCodeList(RequestBox requestBox) throws Exception {
		 
		return lmsOfflineMgMapper.selectLmsEduStatusCodeList(requestBox);
	}

	// 오프라인 목록 엑셀다운
	@Override
	public List<Map<String, String>> selectLmsOfflineMgListExcelDown(RequestBox requestBox) throws Exception {
		return lmsOfflineMgMapper.selectLmsOfflineMgListExcelDown(requestBox);
	}
	
	//오프라인Mg 상세 applicant 목록 카운트
	@Override
	public int selectLmsOfflineMgDetailApplicantCount(RequestBox requestBox) throws Exception {
		return lmsOfflineMgMapper.selectLmsOfflineMgDetailApplicantCount(requestBox);
	}
	
	//오프라인Mg 상세 applicant 목록
	@Override
	public List<DataBox> selectLmsOfflineMgApplicantListAjax(RequestBox requestBox) throws Exception{
		return lmsOfflineMgMapper.selectLmsOfflineMgApplicantListAjax(requestBox);
	}
	
	//오프라인Mg 상세
	@Override
	public DataBox selectLmsOfflineDetail(RequestBox requestBox) throws Exception {
		return lmsOfflineMgMapper.selectLmsOfflineDetail(requestBox);
	}
	
	//applicant 신청 취소
	@Override
	public int deleteLmsOfflineMgApplicant(RequestBox requestBox)throws Exception {
		
		//수강취소;
		int result =  lmsOfflineMgMapper.deleteLmsOfflineMgApplicant(requestBox);
		//좌석삭제
		lmsOfflineMgMapper.deleteLmsOfflineMgSeat(requestBox);
		
		// 맞춤쪽지
		// 103. 오프라인교육 신청취소
		@SuppressWarnings("rawtypes")
		Vector uids = requestBox.getVector("uid");
		requestBox.put("noteitem", "103");
		requestBox.put("coursetype", "F");
		// 교육명 가져오기
		String courseName = "";
		String apName = "";
		DataBox courseInfo = lmsCourseMapper.selectLmsCourse(requestBox);
		if(courseInfo != null){
			requestBox.put("coursename", courseInfo.getString("coursename"));
			courseName = courseInfo.getString("coursename");
		}
		DataBox offInfo = lmsOfflineMapper.selectLmsOffline(requestBox);
		if(offInfo != null){
			requestBox.put("apname", offInfo.getString("apname"));
			apName = offInfo.getString("apname");
		}
		for(int i=0; i<uids.size(); i++){
			requestBox.put("uid", uids.get(i));
			lmsCommonService.insertLmsNoteSend(requestBox);	
		}

		//AmwayGo 그룹방 연동
		for(int i=0; i<uids.size(); i++){
			requestBox.put("uid", uids.get(i));
			lmsCommonMapper.lmsAmwayGoDataSynch(requestBox);	
		}

		String pushTitle = "오프라인과정신청이 취소되었습니다.";
		String pushMsg = courseName+ "["+apName+"] 오프라인과정신청이 취소되었습니다.";
		String pushUrl = "weblink|/lms/myAcademy/lmsMyRequest";
		requestBox.put("pushTitle", pushTitle);
		requestBox.put("pushMsg", pushMsg);
		requestBox.put("pushUrl", pushUrl);
		requestBox.put("pushCategory", "ACADEMY");
		
		
		
		requestBox.put("pushUserIdVector", uids);
		DataBox resultBox = pushSend.sendPushByFile(requestBox);
		LOGGER.debug("XXXXXXXXXXXXXX 	status XXXXXXXXXXXXXXX = " + resultBox.getString("status") );

		return result;
	}

	@Override
	public List<DataBox> selectLmsOfflineMgDetailApplicantPop(RequestBox requestBox) throws Exception {
		return lmsOfflineMgMapper.selectLmsOfflineMgDetailApplicantPop(requestBox);
	}
	
	//오프라인 Mg 상세 applicant Pop Count
	@Override
	public int selectLmsOfflineMgDetailApplicantPopCount(RequestBox requestBox) throws Exception {
		return lmsOfflineMgMapper.selectLmsOfflineMgDetailApplicantPopCount(requestBox);
	}
	
	//PINCODE LIST 조회
	@Override
	public List<DataBox> selectLmsPinCodeList(RequestBox requestBox) throws Exception {
		return lmsOfflineMgMapper.selectLmsPinCodeList(requestBox);
	}

	//멤버테이블에 해당 uid 존재하는지 check
	@Override
	public String lmsOfflineMgAddApplicantCheck(RequestBox requestBox) throws Exception {
		return lmsOfflineMgMapper.lmsOfflineMgAddApplicantCheck(requestBox);
	}
	

	//엑셀로 수강생 신청하기
	@Override
	public int lmsOfflineMgAddApplicantExcelAjax(RequestBox requestBox,List<Map<String, String>> retSuccessList) throws Exception {
		
		int count = 0;
		
		for(int i=0; i<retSuccessList.size();i++)
		{
			Map<String,String> retMap = (Map<String,String>)retSuccessList.get(i);
			
			requestBox.put("uid",retMap.get("col0"));
			requestBox.put("togetherrequestflag",retMap.get("col1"));
			
			lmsOfflineMgMapper.lmsOfflineMgAddApplicantExcelAjax(requestBox);
			count++;
			
			//AmwayGo 그룹방 연동
			lmsCommonMapper.lmsAmwayGoDataSynch(requestBox);
		}
		// 115. 안내컨텐트 교육오픈 - 타켓(대상자 한정)
		requestBox.put("noteitem", "115");
		requestBox.put("retSuccessList",retSuccessList);
		lmsCommonService.insertLmsNoteSend(requestBox);
		
		
		
		return count;
	}
	
	//오프라인Mg 상세 seat 목록 카운트
	@Override
	public int selectLmsOfflineMgDetailSeatCount(RequestBox requestBox) throws Exception {
		return lmsOfflineMgMapper.selectLmsOfflineMgDetailSeatCount(requestBox);
	}
	
	
	//오프라인Mg 상세 seat 목록
	@Override
	public List<DataBox> selectLmsOfflineMgDetailSeat(RequestBox requestBox) throws Exception {
		return lmsOfflineMgMapper.selectLmsOfflineMgDetailSeat(requestBox);
	}
	
	//오프라인 Mg Seat Update
	@Override
	public int lmsOfflineMgSeatUpdate(RequestBox requestBox) throws Exception {
		return lmsOfflineMgMapper.lmsOfflineMgSeatUpdate(requestBox);
	}

	@Override
	public String lmsOfflineMgSeatAssignCheck(RequestBox requestBox) throws Exception {
		return lmsOfflineMgMapper.lmsOfflineMgSeatAssignCheck(requestBox);
	}

	//좌석 재등록일 경우 해당 과정 좌석 삭제
	@Override
	public int deleteLmsOfflineMgSeatExcelAjax(RequestBox requestBox) throws Exception {
		int result = lmsOfflineMgMapper.deleteLmsOfflineMgSeatExcelAjax(requestBox);
		
		
		return result;
	}
	
	//엑셀로 좌석 등록하기
	@Override
	public int lmsOfflineMgSeatRegisterExcelAjax(RequestBox requestBox,List<Map<String, String>> retSuccessList) throws Exception {
		int count = 0;
				
				for(int i=0; i<retSuccessList.size();i++)
				{
					Map<String,String> retMap = (Map<String,String>)retSuccessList.get(i);
					
					requestBox.put("seatnumber",retMap.get("col0"));
					if(retMap.get("col1").equals("Y"))
					{
						requestBox.put("seattype","V");
					}
					else
					{
						requestBox.put("seattype","N");
					}
					
					lmsOfflineMgMapper.lmsOfflineMgSeatRegisterExcelAjax(requestBox);
					count++;
				}
				return count;
	}
	
	//Attend List 조회
	@Override
	public List<DataBox> selectLmsOfflineMgAttendListAjax(RequestBox requestBox) throws Exception {
		
		//lmsstudent테이블 조회
		List<DataBox> dataList =  lmsOfflineMgMapper.selectLmsOfflineMgAttendListAjax(requestBox);
		//lmsseatstudent테이블 조회
		List<DataBox> dataList2 = lmsOfflineMgMapper.selectLmsOfflineMgAttendList2Ajax(requestBox);
		
		//테이블 조립
		for(int i =0 ; i<dataList.size();i++)
		{
			String uid = dataList.get(i).getString("uid");
			String seatnumber = "";
			for(int j=0;j<dataList2.size();j++)
			{	
				String uid2 = dataList2.get(j).getString("uid");
				
				
				if(uid.equals(uid2))
				{	
					
					if(seatnumber.equals(""))
					{
						seatnumber = "주:" + dataList2.get(j).getString("seatnumber");
					}
					else
					{
						StringBuffer seatnumberBuffer = new StringBuffer(seatnumber);
						seatnumberBuffer.append("&nbsp;&nbsp;&nbsp;부:"+dataList2.get(j).getString("seatnumber"));
						seatnumber = seatnumberBuffer.toString();
						//seatnumber += "&nbsp;&nbsp;&nbsp;부:"+dataList2.get(j).getString("seatnumber"); // 버퍼로 변경
					}
				}
			}
			dataList.get(i).put("seatnumber", seatnumber);
		}
		
		
		return dataList;
	}
	
	//Attend List 카운트 조회
	@Override
	public int selectLmsOfflineMgAttendListCount(RequestBox requestBox) throws Exception {
		return lmsOfflineMgMapper.selectLmsOfflineMgAttendListCount(requestBox);
	}
	
	//출석처리 업데이트
	@Override
	public int updateLmsOfflineMgAttendHandle(RequestBox requestBox) throws Exception {
		int cnt = 0;
		
		for(int i=0; i<requestBox.getVector("uids").size(); i++)
		{	
			String beforeAttendFlag = (String) requestBox.getVector("beforeattendflags").get(i);
			String attendFlag = (String) requestBox.getVector("attendflags").get(i);
			String beforeFinishFlag = (String) requestBox.getVector("beforefinishflags").get(i);
			String finishFlag = (String) requestBox.getVector("finishflags").get(i);
			requestBox.put("uid", requestBox.getVector("uids").get(i));
			
			
			if(!beforeAttendFlag.equals(attendFlag) || !beforeFinishFlag.equals(finishFlag))
			{
				requestBox.put("attendflag", attendFlag);
				requestBox.put("finishflag", finishFlag);
				
				/* 
				 * 20161201 AKL ECM 1.5 AI SITAKEAISIT-1539
				 * 바코드인경우(C)와 출석인경우(Y) 에 미출석(N)로 업데이트 하면
				 * 수동(M)으로 업데이트 한다.
				 * 불출석으로 업데이트한다는 것은 수동 처리이므로 불출석 업데이트의 경우는 모두 수동으로 업데이트 한다.
				*/
				if(finishFlag.equals("N")){
					requestBox.put("attendflag", "M");
				}
				//수료날짜 있는지 조회하기
				String existFinishDate = lmsOfflineMgMapper.lmsOfflineMgExistFinishDateCheck(requestBox);

				requestBox.put("existfinishdate", existFinishDate);
				
				lmsOfflineMgMapper.updateLmsOfflineMgAttendHandle(requestBox);
				//오프라인 스탬프 처리
				lmsOfflineMgMapper.lmsOfflineMgStampInsert(requestBox);
				
				//좌석 개별 삭제
				if(finishFlag.equals("N"))
				{	
					lmsOfflineMgMapper.deleteLmsOfflineMgSeatEach(requestBox);
				}
				cnt++;
			}
			
			
		}

		
		
		
		return cnt;
	}
	
	//출석처리 엑셀등록
	@Override
	public int insertLmsOfflineMgAttendHandle(RequestBox requestBox,List<Map<String, String>> retSuccessList) throws Exception {
		int count = 0;
		
		for(int i=0; i<retSuccessList.size();i++)
		{
			Map<String,String> retMap = (Map<String,String>)retSuccessList.get(i);
			
			requestBox.put("uid",retMap.get("col0"));
			
			String existFinishDate = lmsOfflineMgMapper.lmsOfflineMgExistFinishDateCheck(requestBox);

			requestBox.put("existfinishdate", existFinishDate);
			
			lmsOfflineMgMapper.updateLmsOfflineMgAttendHandle(requestBox);
			
			//오프라인 스탬프 처리
			lmsOfflineMgMapper.lmsOfflineMgStampInsert(requestBox);
			count++;
		}
		return count;
	}
	
	//수강생테이블에 해당 uid 존재 여부 조회
	@Override
	public String lmsOfflineMgAttendRegisterCheck(RequestBox requestBox) throws Exception {
		return lmsOfflineMgMapper.lmsOfflineMgAttendRegisterCheck(requestBox);
	}
		
	//교육과정 마감 페널티처리하기
	@Override
	public String lmsOfflineMgAttendFinishPenaltyAjax(RequestBox requestBox)	throws Exception {
		int count = 0;
		String result = "";
		
		//교육과정이 페널티 허용인지 체크하기
		String checkPenaltyFlag = lmsOfflineMgMapper.lmsOfflineMgAttendPenaltyFlagCheck(requestBox);
		//해당과정 마감일 체크하기(Y : 마감일 지남 , N:안지남)
		String checkEndDate = lmsOfflineMgMapper.lmsOfflineMgAttendEndDateCheck(requestBox);
		//미출석인 수강생 조회해오기
		List<DataBox> dataList = lmsOfflineMgMapper.lmsOfflineMgAttendNoFinishStudentList(requestBox);
		
		//마감일이 지나고 페널티 적용인 경우 페널티처리하기
		if(checkPenaltyFlag.equals("Y"))
		{
			if(checkEndDate.equals("Y"))
			{	
				for(int i = 0; i<dataList.size();i++)
				{
						requestBox.put("uid",dataList.get(i).getString("uid"));
						
						//해당 uid가 이미 페널티 처리 되었는지 확인하기
						String penaltyCheck = lmsOfflineMgMapper.lmsOfflineMgAttendAlreadyPenaltyCheck(requestBox);
						
						//페널티 처리 안되었으면 아래 처리
						if(penaltyCheck.equals("N"))
						{
							int result2 = lmsOfflineMgMapper.lmsOfflineMgAttendFinishPenaltyAjax(requestBox);
							int check1 = 1;
							if(result2==check1)
							{
								count++;
							}
						}
						else
						{
							StringBuffer resultBuffer = new StringBuffer(result);
							resultBuffer.append("ABO번호 "+dataList.get(i).getString("uid")+" 고객은 이미 페널티 처리되었습니다.\r\n");
							result = resultBuffer.toString();
							//result += "ABO번호 "+dataList.get(i).getString("uid")+" 고객은 이미 페널티 처리되었습니다.\r\n"; // 버퍼로 변경함
						}
						
						
					}
				StringBuffer resultBuffer = new StringBuffer(result);
				resultBuffer.append(count+"건 페널티처리하였습니다.");
				result = resultBuffer.toString();
				// result += count+"건 페널티처리하였습니다."; //버퍼로 변경함
				
			}
			else
			{
				StringBuffer resultBuffer = new StringBuffer(result);
				resultBuffer.append("해당과정은 아직 교육이 종료 되지 않았습니다.");
				result = resultBuffer.toString();
				//result += "해당과정은 아직 교육이 종료 되지 않았습니다."; // 버퍼로 변경함
			}
		}
		else
		{
			StringBuffer resultBuffer = new StringBuffer(result);
			resultBuffer.append("해당과정은 페널티 허용과정이 아닙니다.");
			result = resultBuffer.toString();
			//result += "해당과정은 페널티 허용과정이 아닙니다."; // 버퍼로 변경함
		}
		return result;
	}

	//페널티대상자 리스트 카운트 조회
	@Override
	public int selectLmsOfflineMgPenaltyListCount(RequestBox requestBox) throws Exception {
		return lmsOfflineMgMapper.selectLmsOfflineMgPenaltyListCount(requestBox);
	}
	
	//페널티대상자 리스트 조회
	@Override
	public List<DataBox> selectLmsOfflineMgPenaltyListAjax(RequestBox requestBox) throws Exception {
		return lmsOfflineMgMapper.selectLmsOfflineMgPenaltyListAjax(requestBox);
	}

	
	//동반신청과정이면서 동반신청인 경우 CHECK
	@Override
	public String lmsOfflineMgAttendBarcodeTogetherCheck(RequestBox requestBox) throws Exception {
		
		String result;
		String blankStr = "";
		//동반자허용과정인지 CHECK
		String togetherFlag = lmsOfflineMgMapper.lmsOfflineMgAttendBarcodeTogetherFlagCheck(requestBox);
		
		if(togetherFlag.equals("Y"))
		{	
			//동반자신청여부 CHECK
			result = lmsOfflineMgMapper.lmsOffineMgAttendBarcodeTogetherFinalCheck(requestBox);
			if(result == null || blankStr.equals(result))
			{
				result = "N";
			}
		}
		else
		{
			result = "N";
		}
		
		return result;
	}

	//바코드 팝업 창  confirm구역에 보여줄 리스트 조회하기
	@Override
	public DataBox lmsOfflineMgAttendBarcodeConfirmInfo(RequestBox requestBox) throws Exception{
		return lmsOfflineMgMapper.lmsOfflineMgAttendBarcodeConfirmInfo(requestBox);
	}
	
	//동반자신청이 아닌 경우 출석 처리하고 좌석배정한뒤 회원정보 조회
	@Override
	public DataBox lmsOfflineMgAttendBarcodeMemberInfo(RequestBox requestBox, int step) throws Exception {
		DataBox memberInfo = new DataBox();
		String comment = "";
		String comment2 = "";
		String blankStr = "";
		
		//출석처리 정보
		String yStr = "Y";
		String exceptionFlag = requestBox.get("exceptionFlag");
		if( exceptionFlag != null && yStr.equals(exceptionFlag) ) {
			requestBox.put("attendflag", "M"); //강제입력은 수동으로 체크함
		} else {
			requestBox.put("attendflag", "C");
		}
		
		requestBox.put("finishflag", "Y");
		String existFinishDate = lmsOfflineMgMapper.lmsOfflineMgExistFinishDateCheck(requestBox);

		requestBox.put("existfinishdate", existFinishDate);
		
		//VIP회원인지 CHECK
		//String[] vipArray = {"3","Z","4","K","5","L","6","M","7","N","8","O"};
		List<DataBox> pinList = lmsOfflineMgMapper.lmsOfflneMgAttendBarcodePinList(requestBox);
		int zero = 0;
		StringBuffer bufPin = new StringBuffer();
		if( pinList != null && pinList.size() > zero) {
			for( int i=0; i<pinList.size(); i++ ) {
				bufPin.append(pinList.get(i).get("targetcodeseq").toString());
				if( i < pinList.size() - 1 ) {
					bufPin.append(",");
				}
			}
		} else {
			bufPin.append("");
		}
		String[] vipArray = bufPin.toString().split("[,]");
		
		String pinlevel = lmsOfflineMgMapper.lmsOfflneMgAttendBarcodePinlevelGet(requestBox);
		String seattype = "N";
		for(int i=0;i<vipArray.length;i++)
		{
			if(pinlevel.equals(vipArray[i]))
			{
				seattype="V";
				break;
			}
		}
		requestBox.put("seattype", seattype);
		
		//좌석등록이 되었는지 체크하기
		String checkSeatRegister = lmsOfflineMgMapper.lmsOfflineMgAttendBarcodeCheckSeatRegister(requestBox);
		
		//해당 UID로 해당 과정에 좌석 카운트 가져오기
		int seatCount = lmsOfflineMgMapper.lmsOfflineMgAttendBarcodeSeatRegisterCount(requestBox);
		//출석자인지 아닌지 확인하기
		String finishflag = lmsOfflineMgMapper.selectLmsOfflineMgFinishFlag(requestBox);
		// 부사업자 과정이면서 신청한 경우
		String togetherYn = lmsOfflineMgAttendBarcodeTogetherCheck(requestBox);
		
		if(checkSeatRegister.equals("Y"))
		{
			//좌석배정 안 된 좌석 가져오기
			String seatSeq = lmsOfflineMgMapper.lmsOfflineMgAttendBarcodeNoAssignSeatGet(requestBox);
			
			//VIP좌석 할당 끝난경우 일반 좌석가져오기
			if(seatSeq == null || blankStr.equals(seatSeq))
			{	
				requestBox.put("seattype", "N");
				seatSeq = lmsOfflineMgMapper.lmsOfflineMgAttendBarcodeNoAssignSeatGet(requestBox);
				comment2 = "VIP좌석의 할당이 끝나서 일반좌석으로 배정되었습니다.";
				if(seatSeq == null || blankStr.equals(seatSeq))
				{		
					//출석처리
					lmsOfflineMgMapper.updateLmsOfflineMgAttendHandle(requestBox);
					
					//해당사업자가 부사업자 신청한 경우에 처리할 것
					if( finishflag.equals("Y") && togetherYn.equals("Y") ) {
						lmsOfflineMgMapper.updateLmsOfflineMgAttendHandleTogether(requestBox);	
						
						comment = "해당과정은 모든 좌석배정이 끝났습니다. \r\n부사업자 출석처리 되었습니다.";
						memberInfo.put("comment", comment);
						return memberInfo;
					}
					
					//오프라인 스탬프 처리
					lmsOfflineMgMapper.lmsOfflineMgStampInsert(requestBox);
					
					comment = "해당과정은 모든 좌석배정이 끝났습니다. \r\n출석처리 되었습니다.";
					
					memberInfo.put("comment", comment);
									
					return memberInfo;
				}
			}
			
			int check1 = 1;
			int check2 = 2;
			int check3 = 3;
			//동반자 신청 아닌 경우
			if(step == check1)
			{
				if(seatCount == 0)
				{	
					
					if(finishflag.equals("Y"))
					{	
						comment = "해당 ABO번호로 이미 출석되었습니다.";
					}
					else
					{
						//출석처리
						lmsOfflineMgMapper.updateLmsOfflineMgAttendHandle(requestBox);
						//오프라인 스탬프 처리
						lmsOfflineMgMapper.lmsOfflineMgStampInsert(requestBox);
						//좌석 배정
						requestBox.put("seatseq",seatSeq);
						lmsOfflineMgMapper.lmsOfflineMgAttendBarcodeSeatRegister(requestBox);
					}
					
				}
				else
				{
					comment = "해당 ABO번호로 이미 출석되었습니다.";
				}
			}
			//동반자 신청인 경우
			else if(step == check2)
			{	
				if(seatCount < check2 )
				{
					if(seatCount == 0 && finishflag.equals("Y"))
					{
						comment = "해당 ABO번호로 이미 출석되었습니다.";
					}
					else
					{
						//출석처리
						lmsOfflineMgMapper.updateLmsOfflineMgAttendHandle(requestBox);
						//오프라인 스탬프 처리
						lmsOfflineMgMapper.lmsOfflineMgStampInsert(requestBox);
						//좌석 배정
						requestBox.put("seatseq",seatSeq);
						lmsOfflineMgMapper.lmsOfflineMgAttendBarcodeSeatRegister(requestBox);
						if(seatCount == check1){
							//부사업자 출석처리
							lmsOfflineMgMapper.updateLmsOfflineMgAttendHandleTogether(requestBox);	
						}
					}
				}
				else if(seatCount==check2)
				{
					comment = "해당 ABO번호로 이미 2좌석이 배정되었습니다.";
				}
			}
			//예외처리버튼
			else if(step==check3)
			{
				if(seatCount < check2 )
				{
						//출석처리하기
						lmsOfflineMgMapper.lmsOfflineMgAttendBarcodePlaceAskRegister(requestBox);
						//오프라인 스탬프 처리
						lmsOfflineMgMapper.lmsOfflineMgStampInsert(requestBox);
						//좌석 배정
						requestBox.put("seatseq",seatSeq);
						lmsOfflineMgMapper.lmsOfflineMgAttendBarcodeSeatRegister(requestBox);
						if(seatCount == check1){
							//부사업자 출석처리
							lmsOfflineMgMapper.updateLmsOfflineMgAttendHandleTogether(requestBox);	
						}
				}
				else if(seatCount==check2)
				{
					comment = "해당 ABO번호로 이미 2좌석이 배정되었습니다.";
				}
			}
			
			//회원정보 조회
			memberInfo = lmsOfflineMgMapper.lmsOfflineMgAttendBarcodeMemberInfo(requestBox);
			
			memberInfo.put("membertype", "일반");
			for(int i=0;i<vipArray.length;i++)
			{
				if(memberInfo.get("groups").equals(vipArray[i]))
				{
					memberInfo.put("membertype", "VIP");
					break;
				}
			}
			
			memberInfo.put("comment2", comment2);
			memberInfo.put("comment", comment);
			return memberInfo;
		}
		else
		{	
			if(finishflag.equals("Y"))
			{	
				comment = "해당 ABO번호로 이미 출석되었습니다.";
				if(step == 2 || step == 3){


					if(seatCount == 1 && togetherYn.equals("Y") )
					{
						//부사업자 출석처리
						lmsOfflineMgMapper.updateLmsOfflineMgAttendHandleTogether(requestBox);
						comment = "부사업자 출석처리 되었습니다.";
					}
				}
			}
			else
			{
				//출석처리
				lmsOfflineMgMapper.updateLmsOfflineMgAttendHandle(requestBox);
				//오프라인 스탬프 처리
				lmsOfflineMgMapper.lmsOfflineMgStampInsert(requestBox);
				// 좌석없는 경우 그냥 보여준다
				//comment = "해당과정은 좌석등록이 되어 있지 않아서 출석처리만 됩니다.";
				comment = "";
			}
			
			//회원정보 조회
			memberInfo = lmsOfflineMgMapper.lmsOfflineMgAttendBarcodeMemberInfo(requestBox);
			
			memberInfo.put("membertype", "일반");
			for(int i=0;i<vipArray.length;i++)
			{
				if(memberInfo.get("groups").equals(vipArray[i]))
				{
					memberInfo.put("membertype", "VIP");
					break;
				}
			}
			
			memberInfo.put("comment",comment);
			return memberInfo;
		}
	}
	
	//현장접수 가능 과정인지 조회
	@Override
	public String lmsOfflineMgAttendBarcodePlaceFlagCheck(RequestBox requestBox) throws Exception {
		return lmsOfflineMgMapper.lmsOfflineMgAttendBarcodePlaceFlagCheck(requestBox);
	}
	
	//수강신청하고 좌석 배정 하고 정보가져오기
	@Override
	public DataBox lmsOfflineMgAttendBarcodePlaceAsk(RequestBox requestBox,int step) throws Exception {
		DataBox memberInfo = new DataBox();
		String comment = "";
		String blankStr = "";
		
		//VIP회원인지 CHECK
		//String[] vipArray = {"3","Z","4","K","5","L","6","M","7","N","8","O"};
		List<DataBox> pinList = lmsOfflineMgMapper.lmsOfflneMgAttendBarcodePinList(requestBox);
		int zero = 0;
		StringBuffer bufPin = new StringBuffer();
		if( pinList != null && pinList.size() > zero) {
			for( int i=0; i<pinList.size(); i++ ) {
				bufPin.append(pinList.get(i).get("targetcodeseq").toString());
				if( i < pinList.size() - 1 ) {
					bufPin.append(",");
				}
			}
		} else {
			bufPin.append("");
		}
		String[] vipArray = bufPin.toString().split("[,]");		
		
		String pinlevel = lmsOfflineMgMapper.lmsOfflneMgAttendBarcodePinlevelGet(requestBox);
		String seattype = "N";
		for(int i=0;i<vipArray.length;i++)
		{
			if(pinlevel.equals(vipArray[i]))
			{
				seattype="V";
				break;
			}
		}
		
		requestBox.put("seattype", seattype);
		
		//좌석등록이 되었는지 체크하기
		String checkSeatRegister = lmsOfflineMgMapper.lmsOfflineMgAttendBarcodeCheckSeatRegister(requestBox);
		
		if(checkSeatRegister.equals("Y"))
		{
			//좌석배정 안 된 좌석 가져오기
			String seatSeq = lmsOfflineMgMapper.lmsOfflineMgAttendBarcodeNoAssignSeatGet(requestBox);
			
			//VIP좌석 할당 끝난경우 일반 좌석가져오기
			if(seatSeq == null || blankStr.equals(seatSeq))
			{	
				requestBox.put("seattype", "N");
				seatSeq = lmsOfflineMgMapper.lmsOfflineMgAttendBarcodeNoAssignSeatGet(requestBox);
				comment = "VIP좌석의 할당이 끝나서 일반좌석으로 배정되었습니다.";
				if(seatSeq == null || blankStr.equals(seatSeq))
				{
					comment = "해당과정은 모든 좌석배정이 끝났습니다.";
					
					memberInfo.put("comment", comment);
					
					return memberInfo;
				}
			}
			
			//동반자허용과정인지 CHECK
			String togetherFlag = lmsOfflineMgMapper.lmsOfflineMgAttendBarcodeTogetherFlagCheck(requestBox);
			
			//해당 UID로 해당 과정에 좌석 카운트 가져오기
			int seatCount = lmsOfflineMgMapper.lmsOfflineMgAttendBarcodeSeatRegisterCount(requestBox);
			int check1 = 1;
			int check2 = 2;
			int check3 = 3;
			if(step == check1)
			{
				if(togetherFlag.equals("Y"))
				{
					if(seatCount < check2 )
					{	
							//출석처리하기
							lmsOfflineMgMapper.lmsOfflineMgAttendBarcodePlaceAskRegister(requestBox);
							//오프라인 스탬프 처리
							lmsOfflineMgMapper.lmsOfflineMgStampInsert(requestBox);
							//좌석 배정
							requestBox.put("seatseq",seatSeq);
							lmsOfflineMgMapper.lmsOfflineMgAttendBarcodeSeatRegister(requestBox);
					}
					else if(seatCount==check2)
					{
						comment = "해당 ABO번호로 이미 2좌석이 배정되었습니다.";
					}
				}
				else if(togetherFlag.equals("N"))
				{
					if(seatCount == 0)
					{	
							//출석처리하기
							lmsOfflineMgMapper.lmsOfflineMgAttendBarcodePlaceAskRegister(requestBox);
							//오프라인 스탬프 처리
							lmsOfflineMgMapper.lmsOfflineMgStampInsert(requestBox);
							//좌석 배정
							requestBox.put("seatseq",seatSeq);
							lmsOfflineMgMapper.lmsOfflineMgAttendBarcodeSeatRegister(requestBox);
					}
					else
					{
						comment = "해당 ABO번호로 이미 출석되었습니다.";
					}
				}
			}
			//예외처리
			else if(step==check3)
			{
				if(seatCount < check2 )
				{
						//출석처리하기
						lmsOfflineMgMapper.lmsOfflineMgAttendBarcodePlaceAskRegister(requestBox);
						//오프라인 스탬프 처리
						lmsOfflineMgMapper.lmsOfflineMgStampInsert(requestBox);
						//좌석 배정
						requestBox.put("seatseq",seatSeq);
						lmsOfflineMgMapper.lmsOfflineMgAttendBarcodeSeatRegister(requestBox);
				}
				else if(seatCount==check2)
				{
					comment = "해당 ABO번호로 이미 2좌석이 배정되었습니다.";
				}
			}
			
			
			//회원정보 조회
			memberInfo = lmsOfflineMgMapper.lmsOfflineMgAttendBarcodeMemberInfo(requestBox);
					
					memberInfo.put("membertype", "일반");
					for(int i=0;i<vipArray.length;i++)
					{
						if(memberInfo.get("groups").equals(vipArray[i]))
						{
							memberInfo.put("membertype", "VIP");
							break;
						}
					}
					
					memberInfo.put("comment", comment);
					return memberInfo;
		}
		else
		{
			//출석처리하기
			lmsOfflineMgMapper.lmsOfflineMgAttendBarcodePlaceAskRegister(requestBox);
			//오프라인 스탬프 처리
			lmsOfflineMgMapper.lmsOfflineMgStampInsert(requestBox);
			// 좌석없는 경우 그냥 보여준다.
			//comment = "해당과정은 좌석등록이 되어 있지 않아서 출석처리만 됩니다.";
			comment = "";
			
			//회원정보 조회
			memberInfo = lmsOfflineMgMapper.lmsOfflineMgAttendBarcodeMemberInfo(requestBox);
			
			memberInfo.put("membertype", "일반");
			for(int i=0;i<vipArray.length;i++)
			{
				if(memberInfo.get("groups").equals(vipArray[i]))
				{
					memberInfo.put("membertype", "VIP");
					break;
				}
			}
			
			memberInfo.put("comment",comment);
			return memberInfo;
		}
		
	}
	
	/**
	 * 정규과정에서 오프라인 예외처리이므로 수강생 등록 및 좌석배치만 처리함
	 */
	public DataBox lmsOfflineMgAttendBarcodePlaceAsk2(RequestBox requestBox,int step) throws Exception {
		DataBox memberInfo = new DataBox();
		String comment = "";
		String blankStr = "";
		
		//VIP회원인지 CHECK
		//String[] vipArray = {"3","Z","4","K","5","L","6","M","7","N","8","O"};
		List<DataBox> pinList = lmsOfflineMgMapper.lmsOfflneMgAttendBarcodePinList(requestBox);
		int zero = 0;
		StringBuffer bufPin = new StringBuffer();
		if( pinList != null && pinList.size() > zero) {
			for( int i=0; i<pinList.size(); i++ ) {
				bufPin.append(pinList.get(i).get("targetcodeseq").toString());
				if( i < pinList.size() - 1 ) {
					bufPin.append(",");
				}
			}
		} else {
			bufPin.append("");
		}
		String[] vipArray = bufPin.toString().split("[,]");		
		
		String pinlevel = lmsOfflineMgMapper.lmsOfflneMgAttendBarcodePinlevelGet(requestBox);
		String seattype = "N";
		for(int i=0;i<vipArray.length;i++)
		{
			if(pinlevel.equals(vipArray[i]))
			{
				seattype="V";
				break;
			}
		}
		
		requestBox.put("seattype", seattype);
		
		//좌석등록이 되었는지 체크하기
		String checkSeatRegister = lmsOfflineMgMapper.lmsOfflineMgAttendBarcodeCheckSeatRegister(requestBox);
		
		if(checkSeatRegister.equals("Y"))
		{
			//좌석배정 안 된 좌석 가져오기
			String seatSeq = lmsOfflineMgMapper.lmsOfflineMgAttendBarcodeNoAssignSeatGet(requestBox);
			
			//VIP좌석 할당 끝난경우 일반 좌석가져오기
			if(seatSeq == null || blankStr.equals(seatSeq))
			{	
				requestBox.put("seattype", "N");
				seatSeq = lmsOfflineMgMapper.lmsOfflineMgAttendBarcodeNoAssignSeatGet(requestBox);
				comment = "VIP좌석의 할당이 끝나서 일반좌석으로 배정되었습니다.";
				if(seatSeq == null || blankStr.equals(seatSeq))
				{
					comment = "해당과정은 모든 좌석배정이 끝났습니다.";
					
					memberInfo.put("comment", comment);
					
					return memberInfo;
				}
			}
			
			//동반자허용과정인지 CHECK
			//String togetherFlag = lmsOfflineMgMapper.lmsOfflineMgAttendBarcodeTogetherFlagCheck(requestBox);
			
			//해당 UID로 해당 과정에 좌석 카운트 가져오기
			int seatCount = lmsOfflineMgMapper.lmsOfflineMgAttendBarcodeSeatRegisterCount(requestBox);
			int check2 = 2;
			int check3 = 3;
			
			//예외처리
			if(step==check3)
			{
				if(seatCount < check2 )
				{
					//출석처리하기
					lmsOfflineMgMapper.lmsOfflineMgAttendBarcodePlaceAskRegister(requestBox);
					//오프라인 스탬프 처리
					//lmsOfflineMgMapper.lmsOfflineMgStampInsert(requestBox);
					//좌석 배정
					requestBox.put("seatseq",seatSeq);
					lmsOfflineMgMapper.lmsOfflineMgAttendBarcodeSeatRegister(requestBox);
				}
				else if(seatCount==check2)
				{
					comment = "해당 ABO번호로 이미 2좌석이 배정되었습니다.";
				}
			}
			
			//회원정보 조회
			memberInfo = lmsOfflineMgMapper.lmsOfflineMgAttendBarcodeMemberInfo(requestBox);
					
			memberInfo.put("membertype", "일반");
			for(int i=0;i<vipArray.length;i++)
			{
				if(memberInfo.get("groups").equals(vipArray[i]))
				{
					memberInfo.put("membertype", "VIP");
					break;
				}
			}
			
			memberInfo.put("comment", comment);
			return memberInfo;
		}
		else
		{
			//출석처리하기
			lmsOfflineMgMapper.lmsOfflineMgAttendBarcodePlaceAskRegister(requestBox);
			//오프라인 스탬프 처리
			//lmsOfflineMgMapper.lmsOfflineMgStampInsert(requestBox);
			
			// 좌석없는 경우 그냥 보여준다.
			//comment = "해당과정은 좌석등록이 되어 있지 않아서 출석처리만 됩니다.";
			comment = "";
			
			//회원정보 조회
			memberInfo = lmsOfflineMgMapper.lmsOfflineMgAttendBarcodeMemberInfo(requestBox);
			
			memberInfo.put("membertype", "일반");
			for(int i=0;i<vipArray.length;i++)
			{
				if(memberInfo.get("groups").equals(vipArray[i]))
				{
					memberInfo.put("membertype", "VIP");
					break;
				}
			}
			
			memberInfo.put("comment",comment);
			return memberInfo;
		}
		
	}
	
	//alert용 회원정보 조회
	@Override
	public DataBox lmsOfflineMgAttendBarcodeNoAppllicantInfo(RequestBox requestBox) throws Exception {
		return lmsOfflineMgMapper.lmsOfflineMgAttendBarcodeAlertInfo(requestBox);
	}
	
	//교육신청자 추가
	@SuppressWarnings("unchecked")
	@Override
	public Map<String, Object> lmsOfflineMgApplicantAddAjax(RequestBox requestBox) throws Exception {
		Map<String, Object> rtnMap = new HashMap<String, Object>();
		DataBox dataBox = new DataBox();
		requestBox.put("coursetype", "F");
		// 맞춤쪽지
		// 101. 오프라인교육 신청
		// 교육명 가져오기
		DataBox courseInfo = lmsCourseMapper.selectLmsCourse(requestBox);
		if(courseInfo != null){
			requestBox.put("coursename", courseInfo.getString("coursename"));
			requestBox.put("startdate", courseInfo.getString("startdate5"));
		}
		DataBox offInfo = lmsOfflineMapper.selectLmsOffline(requestBox);
		if(offInfo != null){
			requestBox.put("apname", offInfo.getString("apname"));
		}
		requestBox.put("noteitem", "101");
		
		int cnt = 0;
			for(int i=0; i<requestBox.getVector("uids").size(); i++)
			{	
				requestBox.put("pincode", requestBox.getVector("pincodes").get(i));
				requestBox.put("uid", requestBox.getVector("uids").get(i));
				if(requestBox.getString("togetherflag").equals("Y"))
				{		
						if(requestBox.getVector("togetherrequestflags").get(i).equals(""))
						{
							requestBox.remove("togetherrequestflag");
						}
						else
						{
							requestBox.put("togetherrequestflag", requestBox.getVector("togetherrequestflags").get(i));
						}
						lmsOfflineMgMapper.insertLmsOfflineMgApplicant(requestBox);
				}
				else
				{
					lmsOfflineMgMapper.insertLmsOfflineMgApplicant2(requestBox);
					
				}
				
				cnt++;
				
				// 맞춤쪽지
				// 101. 오프라인교육 신청
				lmsCommonService.insertLmsNoteSend(requestBox);	
				
				//AmwayGo 그룹방 연동
				lmsCommonMapper.lmsAmwayGoDataSynch(requestBox);
				
			}
			
		rtnMap.putAll(dataBox);
		rtnMap.put("cnt", cnt);
		
		return rtnMap;
	}
	
	//부사업자신청 허용 flag가져오기
	@Override
	public String selectLmsOfflineMgTogetherFlag(RequestBox requestBox)throws Exception {
		return lmsOfflineMgMapper.selectLmsOfflineMgTogetherFlag(requestBox);
	}
	

}



































