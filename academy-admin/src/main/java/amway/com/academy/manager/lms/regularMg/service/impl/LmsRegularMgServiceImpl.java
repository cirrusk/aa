package amway.com.academy.manager.lms.regularMg.service.impl;


import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Vector;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import amway.com.academy.manager.lms.common.service.LmsCommonService;
import amway.com.academy.manager.lms.common.service.impl.LmsCommonMapper;
import amway.com.academy.manager.lms.course.service.impl.LmsCourseMapper;
import amway.com.academy.manager.lms.offlineMg.service.impl.LmsOfflineMgMapper;
import amway.com.academy.manager.lms.regularMg.service.LmsRegularMgService;
import framework.com.cmm.lib.DataBox;
import framework.com.cmm.lib.RequestBox;

@Service
public class LmsRegularMgServiceImpl implements LmsRegularMgService {

	@Autowired
	private LmsCommonService lmsCommonService;
	
	@Autowired
	private LmsRegularMgMapper lmsRegularMgMapper;
	
	@Autowired
	private LmsOfflineMgMapper lmsOfflineMgMapper;
	
	@Autowired
	private LmsCourseMapper lmsCourseMapper;
	
	@Autowired
	private LmsCommonMapper lmsCommonMapper;
	
	//정규과정 운영 List 카운트
	@Override
	public int selectLmsRegularMgCount(RequestBox requestBox) throws Exception {
		return lmsRegularMgMapper.selectLmsRegularMgCount(requestBox);
	}
	
	//정규과정 운영 List 카운트
	@Override
	public List<DataBox> selectLmsRegularMgList(RequestBox requestBox) throws Exception {
		return lmsRegularMgMapper.selectLmsRegularMgList(requestBox);
	}
	
	//교육상태 리스트
	@Override
	public List<DataBox> selectLmsEduStatusCodeList(RequestBox requestBox) throws Exception {
		return lmsRegularMgMapper.selectLmsEduStatusCodeList(requestBox);
	}
	
	//정규과정 운영 목록 엑셀 다운
	@Override
	public List<Map<String, String>> selectLmsRegularMgListExcelDown(RequestBox requestBox) throws Exception {
		return lmsRegularMgMapper.selectLmsRegularMgListExcelDown(requestBox);
	}
	
	//정규과정Mg 상세 Info
	@Override
	public DataBox lmsRegularMgDetail(RequestBox requestBox) throws Exception {
		return lmsRegularMgMapper.lmsRegularMgDetail(requestBox);
	}
	
	//교육현황 탭 리스트 가져오기
	@Override
	public List<DataBox> lmsRegularMgDetailEduStatusListAjax(RequestBox requestBox) throws Exception {
		List<DataBox> stepList = lmsRegularMgMapper.selectLmsRegularMgStepList(requestBox);
		List<DataBox> newStepList = new ArrayList<DataBox>();
		List<DataBox> unitList = lmsRegularMgMapper.selectLmsRegularStepMgUnitList(requestBox);
		for(int i=0; i<stepList.size() ; i++){
			DataBox step = stepList.get(i);
			String stepseq = step.getString("stepseq");
			List<DataBox> newUnitList = new ArrayList<DataBox>();
			for(int j = 0; j < unitList.size(); j++){
				DataBox unit = unitList.get(j);
				String unitstepseq = unit.getString("stepseq");
				if(stepseq.equals(unitstepseq)){
					newUnitList.add(unit);
				}
			}
			step.put("unitlist", newUnitList);
			newStepList.add(step);
		}
		
		return newStepList;
	}
	
	//교육신청자 탭 리스트 가져오기
	@Override
	public List<DataBox> lmsRegularMgApplicantListAjax(RequestBox requestBox) throws Exception {
		List<DataBox> dataList = lmsRegularMgMapper.lmsRegularMgApplicantListAjax(requestBox);
		String blankStr = "";
		for(int i =0;i<dataList.size();i++)
		{
			String apname = dataList.get(i).getString("apname");
			if(apname == null || blankStr.equals(apname) )
			{
				dataList.get(i).put("apname", "");
				dataList.get(i).put("apseq", "");
			}
			
		}
		
		return dataList;
	}
	
	//교육신청자 탭 리스트 카운트 가져오기
	@Override
	public int lmsRegularMgApplicantListCount(RequestBox requestBox) throws Exception {
		return lmsRegularMgMapper.lmsRegularMgApplicantListCount(requestBox);
	}
	
	
	//PINCODE LIST 조회
	@Override
	public List<DataBox> selectLmsPinCodeList(RequestBox requestBox) throws Exception {
		return lmsRegularMgMapper.selectLmsPinCodeList(requestBox);
	}
	//정규과정 applicant 신청 취소
	@Override
	public int lmsRegularMgApplicantDeleteAjax(RequestBox requestBox) throws Exception {
		
		int cnt = 0;
		
		// 맞춤쪽지
		// 103. 오프라인교육 신청취소
		@SuppressWarnings("rawtypes")
		Vector uids = requestBox.getVector("uids");
		requestBox.put("noteitem", "103");
		requestBox.put("coursetype", "R");
		// 교육명 가져오기
		DataBox courseInfo = lmsCourseMapper.selectLmsCourse(requestBox);
		if(courseInfo != null){
			requestBox.put("coursename", courseInfo.getString("coursename"));
		}
		for(int i=0; i<uids.size(); i++){
			requestBox.put("uid", uids.get(i));
			lmsCommonService.insertLmsNoteSend(requestBox);	
		}
		
		for(int i = 0; i<requestBox.getVector("uids").size();i++)
		{
			//하위과정 List
			requestBox.put("apseq", requestBox.getVector("apseqs").get(i));
			List<DataBox> list = lmsRegularMgMapper.lmsRegularMgChildrenCourseList(requestBox);
			
			for(int j = 0; j < list.size(); j++)
			{
				DataBox data = list.get(j);
				requestBox.put("targetcourseid", data.get("courseid")) ;
				requestBox.put("uid", requestBox.getVector("uids").get(i));
				//하위 과정 중 Offline과정이 있을 경우 좌석삭제
				lmsRegularMgMapper.deleteLmsOfflineMgSeat(requestBox);
				//하위 과정 수강 취소(LMSSTUDENT 테이블)
				lmsRegularMgMapper.lmsRegularMgApplicantLmsStudentDelete(requestBox);
				//정규과정 수강 취소
				lmsRegularMgMapper.lmsRegularMgApplicantDeleteAjax(requestBox);
				//하위 과정 수강 취소(LMSSTEPFINISH 테이블)
				lmsRegularMgMapper.lmsRegularMgApplicantLmsStepUnitDelete(requestBox);
				
			}
			cnt++;

			//AmwayGo 그룹방 연동
			lmsCommonMapper.lmsAmwayGoDataSynch(requestBox);
		}
		
		return cnt;
	}
		
	//정규과정 내에 오프라인 과정이 있을 경우 apList가져오기
	@Override
	public List<DataBox> lmsRegularMgApplicantPopApList(RequestBox requestBox) throws Exception {
		return lmsRegularMgMapper.lmsRegularMgApplicantPopApList(requestBox);
	}
	
	//applicant팝용 정보
	@Override
	public Map<String, Object> selectLmsRegularMgApplicantPopDetail(RequestBox requestBox) throws Exception {
		return lmsRegularMgMapper.selectLmsRegularMgApplicantPopDetail(requestBox);
	}
	
	//정규과정 Mg 상세 applicant Count
	@Override
	public int selectLmsRegularMgDetailApplicantPopCount(RequestBox requestBox) throws Exception {
		return lmsRegularMgMapper.selectLmsRegularMgDetailApplicantPopCount(requestBox);
	}
	
	//정규과정Mg 상세 applicant Pop 목록
	@Override
	public List<DataBox> selectLmsRegularMgDetailApplicantPop(RequestBox requestBox) throws Exception {
		return lmsRegularMgMapper.selectLmsRegularMgDetailApplicantPop(requestBox);
	}
	
	//정규과정Mg 신청자 추가
	@Override
	public Map<String, Object> lmsRegularMgApplicantAddAjax(RequestBox requestBox) throws Exception {
		
		Map<String, Object> existUid = new HashMap<String, Object>();
		Map<String, Object> rtnMap = new HashMap<String, Object>();
		
		int cnt = 0;
		int t = 0;
		String comment = "";
		boolean checkUid = true;
		requestBox.put("coursetype", "R");
		// 맞춤쪽지
		// 101. 정규과정 신청
		// 교육명 가져오기
		DataBox courseInfo = lmsCourseMapper.selectLmsCourse(requestBox);
		if(courseInfo != null){
			requestBox.put("coursename", courseInfo.getString("coursename"));
			requestBox.put("startdate", courseInfo.getString("startdate5"));
		}
		requestBox.put("noteitem", "101");
		
		//교육신청자에 있는지 확인하기
		List<DataBox> dataList = lmsRegularMgMapper.lmsRegularMgApplicantListAjax(requestBox);
		
		int check0 = 0;
		int check1 = 1;
		if(dataList != null && dataList.size() > check0)
		{
			for(int i = 0; i<dataList.size();i++)
			{	
				for(int j = 0;j<requestBox.getVector("uids").size();j++)
				{
					if(dataList.get(i).get("uid").equals(requestBox.getVector("uids").get(j)))
					{
						StringBuffer commentBuffer = new StringBuffer(comment);
						commentBuffer.append("ABO번호 : "+dataList.get(i).get("uid")+" 회원님은 이미 수강신청 되어있습니다.\r\n");
						comment = commentBuffer.toString();
						existUid.put("existUid"+t, dataList.get(i).get("uid"));
						t++;
					}
				}
			}
		}
		
		
		//하위과정 List
		for(int i = 0; i<requestBox.getVector("apseqs").size();i++)
		{	
			checkUid = true;
			
			for(int j = 0; j<existUid.size();j++)
			{
				if(existUid.get("existUid"+j).equals(requestBox.getVector("uids").get(i)))
				{
					checkUid = false;
				}
			}
			
			if(checkUid)
			{
				if(requestBox.getVector("apseqs").get(i).equals(""))
				{
					requestBox.remove("apseq");
				}
				else
				{
					requestBox.put("apseq", requestBox.getVector("apseqs").get(i));
				}
				
				requestBox.put("pincode", requestBox.getVector("pincodes").get(i));
				requestBox.put("uid", requestBox.getVector("uids").get(i));
				
				List<DataBox> list = lmsRegularMgMapper.lmsRegularMgChildrenCourseList(requestBox);
				
				for(int j = 0; j < list.size(); j++)
				{	
					DataBox data = list.get(j);
					requestBox.put("targetcourseid", data.get("courseid"));
					
					if(data.get("coursetype").equals("F") || data.get("coursetype").equals("R"))
					{
						//동반자 허용과정인지 아닌지 조회
						requestBox.put("stepcourseid", data.get("courseid"));
						
						if(requestBox.getString("togetherflag").equals("Y"))
						{
							//과정이 오프라인인 하위과정 신청
							if(requestBox.getVector("togetherrequestflags").get(i).equals(""))
							{	
								requestBox.put("togetherrequestflag", "N"); //부사업자 없으면 N로 세팅함
								//requestBox.remove("togetherrequestflag");
							}
							else
							{
								requestBox.put("togetherrequestflag", requestBox.getVector("togetherrequestflags").get(i));
							}
							
							int result = lmsRegularMgMapper.lmsRegularMgApplicantAddOffline(requestBox);
							
							//오프라인과정에 togetherrequestflag y입력 성공시 상위 정규과정도 Y입력
							if(result == check1)
							{	
								requestBox.put("targetcourseid", requestBox.get("courseid"));
								lmsRegularMgMapper.lmsRegularMgApplicantAddOffline(requestBox);
							}
							
						}
						else
						{
							requestBox.put("togetherrequestflag", "N"); //부사업자 신청 불허면 N로 세팅함
							//requestBox.put("togetherrequestflag", "");
							lmsRegularMgMapper.lmsRegularMgApplicantAddOffline(requestBox);
						}
						
						// 정규과정인경우 쪽지발송 - 하위과정이 아닌경우
						// 맞춤쪽지
						// 101. 정규교육 신청
						if(data.get("coursetype").equals("R")){
							lmsCommonService.insertLmsNoteSend(requestBox);	
							
							//AmwayGo 그룹방 연동
							lmsCommonMapper.lmsAmwayGoDataSynch(requestBox);	
							
						}
						
					}
					else
					{
						//과정이 오프라인이 아닌 하위과정 신청
						lmsRegularMgMapper.lmsRegularMgApplicantAddNoOffline(requestBox);
					}
				}
				
				//단계 수료(LMSSTEPFINISH) 추가
				lmsRegularMgMapper.lmsRegularMgApplicantAddStep(requestBox);
				
				cnt++;
			
			}
		
		
		}
		
		rtnMap.put("cnt", cnt);
		rtnMap.put("comment", comment);
		
		
		return rtnMap;
	}
	
	//member테이블에 해당 uid가 있는지 Check하기
	@Override
	public String lmsRegularMgAboNumberCheck(RequestBox requestBox) throws Exception {
		return lmsRegularMgMapper.lmsRegularMgAboNumberCheck(requestBox);
	}
	
	//교육장소 존재 여부 Check
	@Override
	public String lmsRegularMgAddApplicantCheckApseq(RequestBox requestBox) throws Exception {
		return lmsRegularMgMapper.lmsRegularMgAddApplicantCheckApseq(requestBox);
	}
	
	//EXCEL로 수강신청
	@Override
	public Map<String, Object> lmsRegularMgAddApplicantExcelAjax(RequestBox requestBox,List<Map<String, String>> retSuccessList) throws Exception {
		Map<String, Object> existUid = new HashMap<String, Object>();
		Map<String, Object> rtnMap = new HashMap<String, Object>();
		
		int cnt = 0;
		int t = 0;
		String comment = "";
		boolean checkUid = true;
		String regularCourseid = requestBox.get("courseid");
		
		//교육신청자에 있는지 확인하기
		List<DataBox> dataList = lmsRegularMgMapper.lmsRegularMgApplicantListAjax(requestBox);
		for(int i = 0; i<dataList.size();i++)
		{	
			for(int j=0; j<retSuccessList.size();j++)
			{
				Map<String,String> retMap = (Map<String,String>)retSuccessList.get(j);
				if(dataList.get(i).get("uid").equals(retMap.get("col0")))
					{
						StringBuffer commentBuffer = new StringBuffer(comment);
						commentBuffer.append("ABO번호 : "+dataList.get(i).get("uid")+" 회원님은 이미 수강신청 되어있습니다.\r\n");
						comment = commentBuffer.toString();
						existUid.put("existUid"+t, dataList.get(i).get("uid"));
						t++;
					}
			}
		}
		
		//하위과정 List
		for(int i=0; i<retSuccessList.size();i++)
		{	
			Map<String,String> retMap = (Map<String,String>)retSuccessList.get(i);
			
			checkUid = true;
			for(int j = 0; j<existUid.size();j++)
			{
				if(existUid.get("existUid"+j).equals(retMap.get("col0")))
				{
					checkUid = false;
				}
			}
			
			if(checkUid)
			{
				
				requestBox.put("apseq", retMap.get("col2"));
				requestBox.put("uid",retMap.get("col0"));
				
				List<DataBox> list = lmsRegularMgMapper.lmsRegularMgChildrenCourseList(requestBox);
				
				for(int j = 0; j < list.size(); j++)
				{	
					DataBox data = list.get(j);
					requestBox.put("targetcourseid", data.get("courseid")) ;

					if(data.get("coursetype").equals("F") || data.get("coursetype").equals("R"))
					{
						//과정이 오프라인인 하위과정 신청
						requestBox.put("togetherrequestflag",retMap.get("col1"));
						lmsRegularMgMapper.lmsRegularMgApplicantAddOffline(requestBox);
					}
					else
					{
						//과정이 오프라인이 아닌 하위과정 신청
						lmsRegularMgMapper.lmsRegularMgApplicantAddNoOffline(requestBox);
					}
					
					if(data.get("coursetype").equals("R")){
						//단계 수료(LMSSTEPFINISH) 추가
						lmsRegularMgMapper.lmsRegularMgApplicantAddStep(requestBox);	
						
						//AmwayGo 그룹방 연동
						lmsCommonMapper.lmsAmwayGoDataSynch(requestBox);
					}

				}
				cnt++;
			
			}
		
		
		}
		
		// 115. 안내컨텐트 교육오픈 - 타켓(대상자 한정)
		requestBox.put("noteitem", "115");
		requestBox.put("courseid", regularCourseid);
		requestBox.put("retSuccessList",retSuccessList);
		lmsCommonService.insertLmsNoteSend(requestBox);
		
	
		rtnMap.put("cnt", cnt);
		rtnMap.put("comment", comment);
		return rtnMap;
		
	}
	
	//단계명리스트 조회
	@Override
	public List<DataBox> lmsRegularMgDetailStepList(RequestBox requestBox) throws Exception {
		return lmsRegularMgMapper.selectLmsRegularMgStepList(requestBox);
	}
	
	//하위과정 조회
	@Override
	public List<DataBox> lmsRegularMgDetailStepCourseList(RequestBox requestBox) throws Exception {
		return lmsRegularMgMapper.lmsRegularMgDetailStepCourseList(requestBox);
	}
	
	//courseType 조회
	@Override
	public String lmsRegularMgChagedCourseType(RequestBox requestBox) throws Exception {
		return lmsRegularMgMapper.lmsRegularMgChagedCourseType(requestBox);
	}
	
	//오프라인 과정 정보 조회
	@Override
	public DataBox lmsRegularMgOnlineLiveDataInfo(RequestBox requestBox) throws Exception {
		return lmsRegularMgMapper.lmsRegularMgOnlineLiveDataInfo(requestBox);
	}
	
	//단계정보 조회
	@Override
	public DataBox lmsRegularMgDetailStepInfo(RequestBox requestBox) throws Exception {
		
		DataBox data = lmsRegularMgMapper.lmsRegularMgDetailStepInfo(requestBox);
		
		int selectCourseCount = data.getInt("totalcoursecount")-data.getInt("mustcoursecount");
		
		data.put("selectcoursecount", selectCourseCount);
		
		return data;
	}
	
	// step Student 리스트
	@Override
	public List<DataBox> lmsRegularMgDetailStepStudentListAjax(RequestBox requestBox) throws Exception {
		
		//step Student 리스트
		List<DataBox> dataList = lmsRegularMgMapper.lmsRegularMgDetailStepStudentListAjax(requestBox);
		
		//이수 과정수 조합
		for(int i = 0; i<dataList.size();i++)
		{
			String uid = dataList.get(i).getString("uid");
			requestBox.put("uid", uid);
			
			//이수 과정수 조회
			int finishCount = lmsRegularMgMapper.lmsRegularMgDetailStepStudentFinishCount(requestBox);
			
			dataList.get(i).put("finishcount", finishCount);
			
		}
		
		
		return dataList;
	}
	
	// step Student 리스트 카운트
	@Override
	public int lmsRegularMgDetailStepStudentListCount(RequestBox requestBox) throws Exception {
		return lmsRegularMgMapper.lmsRegularMgDetailStepStudentListCount(requestBox);
	}
	
	// 교육과정 탭 Online Course Student리스트
	@Override
	public List<DataBox> lmsRegularMgOnlineLiveDataStudentListAjax(RequestBox requestBox) throws Exception {
		return lmsRegularMgMapper.lmsRegularMgOnlineLiveDataStudentListAjax(requestBox);
	}
	
	// 교육과정 탭 Online Course Student리스트 카운트
	@Override
	public int lmsRegularMgOnlineLiveDataStudentListAjaxCount(RequestBox requestBox) throws Exception {
		return lmsRegularMgMapper.lmsRegularMgOnlineLiveDataStudentListAjaxCount(requestBox);
	}
	
	//정규과정Mg Detail 온라인,라이브,교육자료 과정 수료 처리
	@Override
	public int lmsRegularMgOnlineLiveDataFinishUpdateAjax(RequestBox requestBox) throws Exception {
		
		int cnt = 0;
		
		
		for(int i=0; i<requestBox.getVector("uids").size(); i++)
		{	
			String uid= (String)requestBox.getVector("uids").get(i);
			String finishFlag = (String) requestBox.getVector("finishflags").get(i);
			String beforeFinishFlag = (String) requestBox.getVector("beforeFinishflags").get(i);
			
			
			if(!finishFlag.equals(beforeFinishFlag))
			{	
				requestBox.put("uid", uid);
				requestBox.put("finishflag", finishFlag);
				//수료날짜 있는지 조회하기
				String existFinishDate = lmsRegularMgMapper.lmsRegularMgExistFinishDateCheck(requestBox);

				requestBox.put("existFinishDate", existFinishDate);
				lmsRegularMgMapper.lmsRegularMgOnlineLiveDataFinishUpdateAjax(requestBox);
				
				//하위 과정 수료 할 때 마다 스텝 수료 로직 확인
				lmsRegularMgMapper.lmsRegularMgStepFinishFlagUpdate(requestBox);
				
				//정규과정 수료 여부 확인
				lmsRegularMgMapper.lmsRegularMgTotalFinishUpdate(requestBox);
				
				//정규과정 스탬프 처리					
				lmsRegularMgMapper.lmsRegularMgStampInsert(requestBox);
				
				cnt++;
			}
			
		}

		
		return cnt;
	}
	
	//오프라인 고정 정보 조회
	@Override
	public DataBox lmsRegularMgOfflineCourseInfo(RequestBox requestBox) throws Exception {
		return lmsRegularMgMapper.lmsRegularMgOfflineCourseInfo(requestBox);
	}
	
	//출석처리 업데이트
	@Override
	public int lmsRegularMgOfflineAttendUpdateAjax(RequestBox requestBox) throws Exception {
		//출석처리 업데이트
		int cnt = 0;
		
		
		requestBox.put("stampid", "6");
		
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
				String existFinishDate = lmsRegularMgMapper.lmsRegularMgExistFinishDateCheck(requestBox);

				requestBox.put("existfinishdate", existFinishDate);
				
				lmsRegularMgMapper.updateLmsRegularMgAttendHandle(requestBox);
				cnt++;
				
				
				if(finishFlag.equals("N"))
				{
					//개별 좌석삭제
					lmsRegularMgMapper.deleteLmsOfflineMgSeatEach(requestBox);
				}
				
				//하위 과정 수료 할 때 마다 스텝 수료 로직 확인
				lmsRegularMgMapper.lmsRegularMgStepFinishFlagUpdate(requestBox);
				//정규과정 수료 여부 확인
				lmsRegularMgMapper.lmsRegularMgTotalFinishUpdate(requestBox);
				//정규과정 스탬프 처리					
				lmsRegularMgMapper.lmsRegularMgStampInsert(requestBox);
			}
			
		}
	
		return cnt;
	}
	
	//attend팝업용 Info
	@SuppressWarnings("unchecked")
	@Override
	public Map<String, Object> lmsRegularMgDetailOfflineAttendPopInfo(RequestBox requestBox) throws Exception {
		Map<String, Object> rtnMap = new HashMap<String, Object>();
		String blankStr = "";
		if(!blankStr.equals(requestBox.get("courseid"))){
			rtnMap = lmsRegularMgMapper.selectLmsRegularMgOfflineDetail(requestBox);
			
		}
		return rtnMap;
	}
	
	//과정 정보 조회
	@Override
	public DataBox lmsRegularMgTestCourseInfo(RequestBox requestBox) throws Exception {
		return lmsRegularMgMapper.lmsRegularMgTestCourseInfo(requestBox);
	}
	
	// 교육과정 탭 Test Student리스트 카운트
	@Override
	public int lmsRegularMgTestListAjaxCount(RequestBox requestBox) throws Exception {
		return lmsRegularMgMapper.lmsRegularMgTestListAjaxCount(requestBox);
	}
	
	// 교육과정 탭 Test Student리스트
	@Override
	public List<DataBox> lmsRegularMgTestListAjax(RequestBox requestBox) throws Exception {
		return lmsRegularMgMapper.lmsRegularMgTestListAjax(requestBox);
	}
	
	//스텝 하위  Test 과정 수료 처리
	@Override
	public int lmsRegularMgTestFinishUpdateAjax(RequestBox requestBox)throws Exception {
		int cnt = 0;
		String blankStr = "";
		for(int i=0; i<requestBox.getVector("uids").size(); i++)
		{	
			String uid= (String)requestBox.getVector("uids").get(i);
			String finishFlag = (String) requestBox.getVector("finishflags").get(i);
			String beforeFinishFlag = (String) requestBox.getVector("beforefinishflags").get(i);
			String objetPoint = (String) requestBox.getVector("objectpoints").get(i);
			String beforeObjectPoint = (String) requestBox.getVector("beforeobjectpoints").get(i);
			String subjetPoint = (String) requestBox.getVector("subjectpoints").get(i);
			String beforeSubjetPoint = (String) requestBox.getVector("beforesubjectpoints").get(i);
			
			if(!finishFlag.equals(beforeFinishFlag) || !objetPoint.equals(beforeObjectPoint) || !subjetPoint.equals(beforeSubjetPoint))
			{	
				requestBox.put("uid", uid);
				requestBox.put("finishflag", finishFlag);
				requestBox.put("objectpoint", objetPoint);
				requestBox.put("subjectpoint", subjetPoint);
				
				//수료날짜 있는지 조회하기
				String existFinishDate = lmsRegularMgMapper.lmsRegularMgExistFinishDateCheck(requestBox);

				requestBox.put("existFinishDate", existFinishDate);
				lmsRegularMgMapper.lmsRegularMgTestFinishUpdateAjax(requestBox);
				
				
				//자동 수료 처리
				if(!objetPoint.equals(beforeObjectPoint) || !subjetPoint.equals(beforeSubjetPoint))
				{
					//점수 등록한뒤 수료 여부 확인
					String finishflag = lmsRegularMgMapper.lmsRegularMgTestFinishFlagCheck(requestBox);
					
					if(finishflag == null || blankStr.equals(finishflag) )
					{
						finishflag = "N";
					}
					
					requestBox.put("finishflag", finishflag);
				}
				
				//수료날짜 있는지 조회하기
				existFinishDate = lmsRegularMgMapper.lmsRegularMgExistFinishDateCheck(requestBox);
				requestBox.put("existFinishDate", existFinishDate);
				
				//test 수료 처리
				lmsRegularMgMapper.lmsRegularMgTestFinishFlagUpdate(requestBox);
				//하위 과정 수료 할 때 마다 스텝 수료 로직 확인
				lmsRegularMgMapper.lmsRegularMgStepFinishFlagUpdate(requestBox);
				
				//정규과정 수료 여부 확인
				lmsRegularMgMapper.lmsRegularMgTotalFinishUpdate(requestBox);
				
				//정규과정 스탬프 처리					
				lmsRegularMgMapper.lmsRegularMgStampInsert(requestBox);
				cnt++;
			}
			
		}
		return cnt;
	}
	
	//시험 정보 가져오기
	@Override
	public Map<String,Object> lmsRegularMgDetailTestList(RequestBox requestBox) throws Exception {
		Map<String,Object> data = new HashMap<String, Object>();
		
		Vector<String> testPoolIds = new Vector<String>();
		
		//문제 리스트 가져오기
		List<DataBox> testList = lmsRegularMgMapper.lmsRegularMgDetailTestList(requestBox);
		
		for(int i=0;i<testList.size();i++)
		{
			testPoolIds.add(i, testList.get(i).getString("testpoolid"));
		}
		
		requestBox.put("testpoolids", testPoolIds);
		
		//보기,지문 리스트 가져오기
		List<DataBox> answerList = lmsRegularMgMapper.lmsRegularMgDetailTestAnswerList(requestBox);
		
		data.put("answerList", answerList);
		data.put("testList", testList);
		return data;
	}

	//시험 정보 가져오기
	@Override
	public DataBox lmsRegularMgDetailTestStudentInfo(RequestBox requestBox) throws Exception {
		
		return lmsRegularMgMapper.lmsRegularMgDetailTestStudentInfo(requestBox);
	}
	
	//바코드 출석처리
	@Override
	public DataBox lmsRegularMgAttendBarcodeMemberInfo(RequestBox requestBox, int step) throws Exception {
		DataBox memberInfo = new DataBox();
		
		int check1 = 1;
		int check2 = 2;
		int check3 = 3;
		String blankStr = "";
		
		//출석처리하기
		String exceptionFlag = requestBox.get("exceptionFlag");
		String yStr = "Y";
		if( exceptionFlag != null && yStr.equals(exceptionFlag) ) {
			requestBox.put("attendflag", "M"); //강제입력은 수동으로 체크함
		} else {
			requestBox.put("attendflag", "C");
		}
		
		requestBox.put("finishflag", "Y");
		String existFinishDate = lmsRegularMgMapper.lmsRegularMgExistFinishDateCheck(requestBox);

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
		
		String pinlevel = lmsRegularMgMapper.lmsRegularMgAttendBarcodePinlevelGet(requestBox);
		String seattype = "N";
		String comment = "";
		String comment2 = "";
		
		
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
		String checkSeatRegister = lmsRegularMgMapper.lmsRegularMgAttendBarcodeCheckSeatRegister(requestBox);
		//출석자인지 아닌지 조회하기
		String finishflag = lmsRegularMgMapper.selectLmsRegularMgOfflineFinishFlag(requestBox);

		// 부사업자 과정이면서 신청한 경우
		String togetherYn = lmsRegularMgAttendBarcodeTogetherCheck(requestBox);
		
		//해당 UID로 해당 과정에 좌석 카운트 가져오기
		int seatCount = lmsRegularMgMapper.lmsRegularMgAttendBarcodeSeatRegisterCount(requestBox);
		
		if(checkSeatRegister.equals("Y"))
		{
			//좌석배정 안 된 좌석 가져오기
			String seatSeq = lmsRegularMgMapper.lmsRegularMgAttendBarcodeNoAssignSeatGet(requestBox);
			
			//VIP좌석 할당 끝난경우 일반 좌석가져오기
			if(seatSeq == null || blankStr.equals(seatSeq) )
			{	
				requestBox.put("seattype", "N");
				seatSeq = lmsRegularMgMapper.lmsRegularMgAttendBarcodeNoAssignSeatGet(requestBox);
				comment2 = "VIP좌석의 할당이 끝나서 일반좌석으로 배정되었습니다.";
				if(seatSeq == null || blankStr.equals(seatSeq) )
				{
					//출석처리하기
					lmsRegularMgMapper.updateLmsRegularMgAttendHandle(requestBox);
					
					if( finishflag.equals("Y") && togetherYn.equals("Y") ) {
						lmsRegularMgMapper.updateLmsRegularMgAttendHandleTogether(requestBox);

						comment = "해당과정은 모든 좌석배정이 끝났습니다. \r\n부사업자 출석처리 되었습니다.";
						memberInfo.put("comment", comment);
										
						return memberInfo;
					}
					
					//하위 과정 수료 할 때 마다 스텝 수료 로직 확인
					lmsRegularMgMapper.lmsRegularMgStepFinishFlagUpdate(requestBox);
					
					//정규과정 수료 여부 확인
					lmsRegularMgMapper.lmsRegularMgTotalFinishUpdate(requestBox);
					
					requestBox.put("stampid", "6");
					
					//정규과정 스탬프 처리					
					lmsRegularMgMapper.lmsRegularMgStampInsert(requestBox);
					
					comment = "해당과정은 모든 좌석배정이 끝났습니다. \r\n출석처리 되었습니다.";
					
					memberInfo.put("comment", comment);
									
					return memberInfo;
				}
			}
			
		
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
						//출석처리하기
						lmsRegularMgMapper.updateLmsRegularMgAttendHandle(requestBox);
						
						//하위 과정 수료 할 때 마다 스텝 수료 로직 확인
						lmsRegularMgMapper.lmsRegularMgStepFinishFlagUpdate(requestBox);
						
						//정규과정 수료 여부 확인
						lmsRegularMgMapper.lmsRegularMgTotalFinishUpdate(requestBox);
						
						//정규과정 스탬프 처리					
						lmsRegularMgMapper.lmsRegularMgStampInsert(requestBox);
						
						//좌석 배정
						requestBox.put("seatseq",seatSeq);
						lmsRegularMgMapper.lmsRegularMgAttendBarcodeSeatRegister(requestBox);
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
						//출석처리하기
						lmsRegularMgMapper.updateLmsRegularMgAttendHandle(requestBox);
						
						//하위 과정 수료 할 때 마다 스텝 수료 로직 확인
						lmsRegularMgMapper.lmsRegularMgStepFinishFlagUpdate(requestBox);
						
						//정규과정 수료 여부 확인
						lmsRegularMgMapper.lmsRegularMgTotalFinishUpdate(requestBox);
						
						//정규과정 스탬프 처리					
						lmsRegularMgMapper.lmsRegularMgStampInsert(requestBox);
						
						//좌석 배정
						requestBox.put("seatseq",seatSeq);
						lmsRegularMgMapper.lmsRegularMgAttendBarcodeSeatRegister(requestBox);
						
						if(seatCount == check1){
							//부사업자 출석처리
							lmsRegularMgMapper.updateLmsRegularMgAttendHandleTogether(requestBox);	
						}
						
					}
				}
				else if(seatCount==check2)
				{
					comment = "해당 ABO번호로 이미 2좌석이 배정되었습니다.";
				}
			}
			else if(step == check3)
			{
				if(seatCount < check2 )
				{
					//출석처리하기
					lmsRegularMgMapper.updateLmsRegularMgAttendHandle(requestBox);
					
					//하위 과정 수료 할 때 마다 스텝 수료 로직 확인
					lmsRegularMgMapper.lmsRegularMgStepFinishFlagUpdate(requestBox);
					
					//정규과정 수료 여부 확인
					lmsRegularMgMapper.lmsRegularMgTotalFinishUpdate(requestBox);
					
					//정규과정 스탬프 처리					
					lmsRegularMgMapper.lmsRegularMgStampInsert(requestBox);
					
					//좌석 배정
					requestBox.put("seatseq",seatSeq);
					lmsRegularMgMapper.lmsRegularMgAttendBarcodeSeatRegister(requestBox);
					
					if(seatCount == check1){
						//부사업자 출석처리
						lmsRegularMgMapper.updateLmsRegularMgAttendHandleTogether(requestBox);	
					}
					
				}
				else if(seatCount==check2)
				{
					comment = "해당 ABO번호로 이미 2좌석이 배정되었습니다.";
				}
			}
			
			//회원정보 조회
			memberInfo = lmsRegularMgMapper.lmsRegularMgAttendBarcodeMemberInfo(requestBox);
			
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
							lmsRegularMgMapper.updateLmsRegularMgAttendHandleTogether(requestBox);
							comment = "부사업자 출석처리 되었습니다.";
						}
					}
			}
			else
			{
				//출석처리하기
				lmsRegularMgMapper.updateLmsRegularMgAttendHandle(requestBox);
				// 좌석 등록되지 않은 경우 알러트 없음
				//comment = "해당과정은 좌석등록이 되어 있지 않아서 출석처리만 됩니다.";
				comment = "";
				//회원정보 조회
				memberInfo = lmsRegularMgMapper.lmsRegularMgAttendBarcodeMemberInfo(requestBox);
				
				memberInfo.put("membertype", "일반");
				for(int i=0;i<vipArray.length;i++)
				{
					if(memberInfo.get("groups").equals(vipArray[i]))
					{
						memberInfo.put("membertype", "VIP");
						break;
					}
				}
				
				//하위 과정 수료 할 때 마다 스텝 수료 로직 확인
				lmsRegularMgMapper.lmsRegularMgStepFinishFlagUpdate(requestBox);
				
				//정규과정 수료 여부 확인
				lmsRegularMgMapper.lmsRegularMgTotalFinishUpdate(requestBox);
				
				//정규과정 스탬프 처리					
				lmsRegularMgMapper.lmsRegularMgStampInsert(requestBox);
			}
			
			memberInfo.put("comment",comment);
			return memberInfo;
		}
	}
	
	//주관식 점수 엑설 Popup호출
	@Override
	public String lmsRegularMgDetailTestSubjectExcelPop(RequestBox requestBox) throws Exception {
		return lmsRegularMgMapper.lmsRegularMgDetailTestSubjectExcelPop(requestBox);
	}

	
	//주관식 점수 엑셀 등록
	@Override
	public Map<String, Object> lmsRegularMgTestSubjectExcelAjax(RequestBox requestBox, List<Map<String, String>> retSuccessList) throws Exception {
		Map<String, Object> rtnMap = new HashMap<String, Object>();
		
		int cnt = 0;
		String comment = "";
		boolean checkUid = true;
		String blankStr = "";
		for(int j=0; j<retSuccessList.size();j++)
		{
			Map<String,String> retMap = (Map<String,String>)retSuccessList.get(j);
			
			requestBox.put("uid",retMap.get("col0"));
			
			//교육신청자에 있는지 확인하기
			String uidCheck = lmsRegularMgMapper.lmsRegularMgTestStudentList(requestBox);
			
			if(uidCheck == null || blankStr.equals(uidCheck) )
			{	
				StringBuffer commentBuffer = new StringBuffer(comment);
				commentBuffer.append("ABO번호 : "+retMap.get("col0")+" 회원님은 해당 시험의 수강생이 아닙니다.\r\n");
				comment = commentBuffer.toString();
				checkUid = false;
			}
		}
		
		if(checkUid)
		{
			for(int i = 0;i<retSuccessList.size();i++)
			{
				Map<String,String> retMap = (Map<String,String>)retSuccessList.get(i);
				
				requestBox.put("uid", retMap.get("col0"));
				requestBox.put("subjectpoint", retMap.get("col1"));
				
				
				//주관식 점수 등록
				lmsRegularMgMapper.lmsRegularMgTestSubjectExcelAjax(requestBox);
				
				//점수 등록한뒤 수료 여부 확인
				String finishflag = lmsRegularMgMapper.lmsRegularMgTestFinishFlagCheck(requestBox);
				
				if(finishflag == null || blankStr.equals(finishflag) )
				{
					finishflag = "N";
				}
					
				requestBox.put("finishflag", finishflag);
				//수료날짜 있는지 조회하기
				String existFinishDate = lmsRegularMgMapper.lmsRegularMgExistFinishDateCheck(requestBox);
				
				requestBox.put("existFinishDate", existFinishDate);
				
				//test 수료 처리
				lmsRegularMgMapper.lmsRegularMgTestFinishFlagUpdate(requestBox);			
				
				//하위 과정 수료 할 때 마다 스텝 수료 로직 확인
				lmsRegularMgMapper.lmsRegularMgStepFinishFlagUpdate(requestBox);
				
				//정규과정 수료 여부 확인
				lmsRegularMgMapper.lmsRegularMgTotalFinishUpdate(requestBox);
				
				//정규과정 스탬프 처리					
				lmsRegularMgMapper.lmsRegularMgStampInsert(requestBox);
			
				cnt++;
			}
		}
		
		rtnMap.put("cnt", cnt);
		rtnMap.put("comment", comment);
		return rtnMap;
	}
	
	//객관식 재채점
	@Override
	public int lmsRegularMgTestObjectRemarking(RequestBox requestBox) throws Exception {
		Vector<String> yUids = new Vector<String>();
		int yCnt = 0;
		Vector<String> nUids = new Vector<String>();
		int nCnt = 0;
		String blankStr = "";
		
		for(int i=0; i<requestBox.getVector("studyflags").size();i++)
		{
			String studyFlag = (String) requestBox.getVector("studyflags").get(i);
			
			//studyFlag가 Y가 아니면 LMSSTUDENT OBJECTPOINT가 0
			if(studyFlag == null || studyFlag.equals(""))
			{
				nUids.add(nCnt, (String)requestBox.getVector("uids").get(i));
				
				nCnt++;
			}
			else
			{
				if(studyFlag.equals("N"))
				{
					nUids.add(nCnt, (String)requestBox.getVector("uids").get(i));
					
					nCnt++;
				}
				//studyFlag가 Y이면 재채점
				else if(studyFlag.equals("Y"))
				{
					yUids.add(yCnt, (String)requestBox.getVector("uids").get(i));
					yCnt++;
				}
			}
		}
		
		requestBox.put("yUids", yUids);
		requestBox.put("nUids", nUids);
		int check1= 1;
		if(yUids.size()>=check1)
		{
			//studyFlag가 Y일때 객관식 재채점
			lmsRegularMgMapper.lmsRegularMgTestObjectRemarkingY(requestBox);
			
			//객관식 점수 합산해서 STUDENT테이블에 넣기
			for(int i = 0 ; i< yUids.size(); i++)
			{
				requestBox.put("uid", yUids.get(i));
				lmsRegularMgMapper.lmsRegularMgTestObjectPointSum(requestBox);
				
			}
		}
		
		//stduyFlag가 N일때 객관식 재채점
		lmsRegularMgMapper.lmsRegularMgTestObjectRemarkingN(requestBox);
		
		for(int i=0;i<requestBox.getVector("uids").size(); i++)
		{
			requestBox.put("uid", requestBox.getVector("uids").get(i));
			
			//재채점 한 뒤 수료 여부 확인 //자동 처리
			String finishflag = lmsRegularMgMapper.lmsRegularMgTestFinishFlagCheck(requestBox);
			
			if(finishflag == null || blankStr.equals(finishflag) )
			{
				finishflag = "N";
			}
			
			requestBox.put("finishflag", finishflag);
			//수료날짜 있는지 조회하기
			String existFinishDate = lmsRegularMgMapper.lmsRegularMgExistFinishDateCheck(requestBox);
			
			requestBox.put("existFinishDate", existFinishDate);
			
			//test 수료 처리
			lmsRegularMgMapper.lmsRegularMgTestFinishFlagUpdate(requestBox);			
			
			//하위 과정 수료 할 때 마다 스텝 수료 로직 확인
			lmsRegularMgMapper.lmsRegularMgStepFinishFlagUpdate(requestBox);
			
			//정규과정 수료 여부 확인
			lmsRegularMgMapper.lmsRegularMgTotalFinishUpdate(requestBox);
			
			//정규과정 스탬프 처리					
			lmsRegularMgMapper.lmsRegularMgStampInsert(requestBox);
		}
		
		
		return 0;
	}
	
	//시험 개인별 정보 가져오기
	@Override
	public DataBox lmsRegularMgDetailTestSubjectAnswerPop(RequestBox requestBox) throws Exception {
		return lmsRegularMgMapper.lmsRegularMgDetailTestSubjectAnswerPop(requestBox);
	}
	
	//개인별 주관식 답안지
	@Override
	public List<DataBox> lmsRegularMgDetailEachTestSubjectAnswer(RequestBox requestBox) throws Exception {
		return lmsRegularMgMapper.lmsRegularMgDetailEachTestSubjectAnswer(requestBox);
	}
	
	//주관식 개별 채점
	@Override
	public int lmsRegularMgDetailEachSubjectPointUpdate(RequestBox requestBox) throws Exception {
		String blankStr = "";
		for(int i = 0; i<requestBox.getVector("subjectpoints").size();i++)
		{
			requestBox.put("subjectpoint", requestBox.getVector("subjectpoints").get(i));
			requestBox.put("testpoolpoint", requestBox.getVector("testpoolpoints").get(i));
			requestBox.put("answerseq", requestBox.getVector("answerseqs").get(i));
			requestBox.put("testpoolid", requestBox.getVector("testpoolids").get(i));
			
			//주관식 점수 update
			lmsRegularMgMapper.lmsRegularMgDetailEachSubjectPointUpdate(requestBox);
			
		}
		
		//주관식 합계 점수 LMSSTUDENT테이블에 UPDATE
		lmsRegularMgMapper.lmsRegularMgDetailSubjectPointUpdate(requestBox);
		
		//재채점 한 뒤 수료 여부 확인 //자동 처리
		String finishflag = lmsRegularMgMapper.lmsRegularMgTestFinishFlagCheck(requestBox);
		
		if(finishflag == null || blankStr.equals(finishflag))
		{
			finishflag = "N";
		}
		
		requestBox.put("finishflag", finishflag);
		
		//수료날짜 있는지 조회하기
		String existFinishDate = lmsRegularMgMapper.lmsRegularMgExistFinishDateCheck(requestBox);
		
		requestBox.put("existFinishDate", existFinishDate);
		
		//시험 수료 여부 CHECK
		lmsRegularMgMapper.lmsRegularMgTestFinishFlagUpdate(requestBox);	
		
		//STEP 수료 여부 CHECK
		lmsRegularMgMapper.lmsRegularMgStepFinishFlagUpdate(requestBox);
		
		//정규과정 수료 여부 CHECK
		lmsRegularMgMapper.lmsRegularMgTotalFinishUpdate(requestBox);
		
		//정규과정 STAMP
		lmsRegularMgMapper.lmsRegularMgStampInsert(requestBox);
		
		return 0;
	}
	
	//오프라인 출석처리 엑셀 등록
	@Override
	public void insertLmsRegularMgAttendHandle(RequestBox requestBox,List<Map<String, String>> retSuccessList) throws Exception {
		for(int i=0; i<retSuccessList.size();i++)
		{
			Map<String,String> retMap = (Map<String,String>)retSuccessList.get(i);
			
			requestBox.put("uid",retMap.get("col0"));
			
			String existFinishDate = lmsRegularMgMapper.lmsRegularMgExistFinishDateCheck(requestBox);

			requestBox.put("existfinishdate", existFinishDate);
			
			lmsRegularMgMapper.updateLmsRegularMgAttendHandle(requestBox);
			
			//하위 과정 수료 할 때 마다 스텝 수료 로직 확인
			lmsRegularMgMapper.lmsRegularMgStepFinishFlagUpdate(requestBox);
			
			//정규과정 수료 여부 확인
			lmsRegularMgMapper.lmsRegularMgTotalFinishUpdate(requestBox);
			
			//정규과정 스탬프 처리					
			lmsRegularMgMapper.lmsRegularMgStampInsert(requestBox);
		}
	}
	
	//교육신청자인지 아닌지 확인하기
	@Override
	public String lmsRegularMgAttendRegisterCheck(RequestBox requestBox) throws Exception {
		return lmsRegularMgMapper.lmsRegularMgAttendRegisterCheck(requestBox);
	}
	
	//동반신청과정이면서 동반신청인 경우 CHECK
	@Override
	public String lmsRegularMgAttendBarcodeTogetherCheck(RequestBox requestBox) throws Exception {
		String result;
		String blankStr = "";
		//동반자허용과정인지 CHECK
		String togetherFlag = lmsRegularMgMapper.lmsRegularMgAttendBarcodeTogetherFlagCheck(requestBox);
		
		if(togetherFlag.equals("Y"))
		{	
			//동반자신청여부 CHECK
			result = lmsRegularMgMapper.lmsRegularMgAttendBarcodeTogetherFinalCheck(requestBox);
			if(result == null || blankStr.equals(result) )
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
	public DataBox lmsRegularMgAttendBarcodeConfirmInfo(RequestBox requestBox) throws Exception {
		return lmsRegularMgMapper.lmsRegularMgAttendBarcodeConfirmInfo(requestBox);
	}

	@Override
	public DataBox lmsRegularMgAttendBarcodeNoAppllicantInfo(RequestBox requestBox) throws Exception {
		return lmsRegularMgMapper.lmsRegularMgAttendBarcodeNoAppllicantInfo(requestBox);
	}
	
	//설문용 정보 조회
	@Override
	public DataBox lmsRegularMgServeyCourseInfo(RequestBox requestBox)throws Exception {
		return lmsRegularMgMapper.lmsRegularMgServeyCourseInfo(requestBox);
	}
	
	//설문결과 가져오기
	@Override
	public Map<String, Object> lmsRegularMgDetailSurveyList(RequestBox requestBox) throws Exception {
		Map<String,Object> data = new HashMap<String, Object>();
		
		//문제 리스트 가져오기
		List<DataBox> surveyList = lmsRegularMgMapper.lmsRegularMgDetailSurveyList(requestBox);
		
		//척도평균 가져오기
		List<DataBox> avgSampleValue = lmsRegularMgMapper.lmsRegularMgDetailSurveyAvgSampleValue(requestBox);
		
		//문제 리스트에 척도 평균 넣기
		for(int i = 0; i<surveyList.size(); i++)
		{	
			for(int j = 0; j<avgSampleValue.size(); j++)
			{	
				if(surveyList.get(i).getInt("surveyseq") == avgSampleValue.get(j).getInt("surveyseq"))
				{
					surveyList.get(i).put("avgsamplevalue", avgSampleValue.get(j).get("avgvalue"));
				}
			}
		}
		
		//Object 보기,지문 리스트 가져오기
		List<DataBox> sampleObjectList = lmsRegularMgMapper.lmsRegularMgDetailSurveySampleObjectList(requestBox);
		
		//Subject 보기,지문 리스트 가져오기
		List<DataBox> sampleSubjectList = lmsRegularMgMapper.lmsRegularMgDetailSurveySampleSubjectList(requestBox);
		
		data.put("sampleObjectList", sampleObjectList);
		data.put("sampleSubjectList", sampleSubjectList);
		data.put("surveyList", surveyList);
		return data;
	}
	
	// 설문대상자 탭  Student리스트
	@Override
	public List<DataBox> lmsRegularMgDetailSurveyCourseListAjax(RequestBox requestBox) throws Exception {
		return lmsRegularMgMapper.lmsRegularMgDetailSurveyCourseListAjax(requestBox);
	}
	
	// 설문대상자 탭  Student리스트 카운트
	@Override
	public int lmsRegularMgDetailSurveyCourseListCount(RequestBox requestBox)throws Exception {
		return lmsRegularMgMapper.lmsRegularMgDetailSurveyCourseListCount(requestBox);
	}
	
	//스탭정보 읽어오기
	@Override
	public List<DataBox> selectLmsStepList(RequestBox requestBox) throws Exception {
		return lmsRegularMgMapper.selectLmsStepList(requestBox);
	}
  
	// 수료자 및 수강생 갯수
	@Override
	public DataBox selectRegularMgFinishTotal(RequestBox requestBox) throws Exception {
		return lmsRegularMgMapper.selectRegularMgFinishTotal(requestBox);
	}
  
	//수료자 합계
	@Override
	public int lmsRegularMgFinishListCount(RequestBox requestBox) throws Exception {
		return lmsRegularMgMapper.lmsRegularMgFinishListCount(requestBox);
	}
  
	//수료자 정보 읽기
	@Override
	public List<DataBox> lmsRegularMgFinishListAjax(RequestBox requestBox) throws Exception {
		return lmsRegularMgMapper.lmsRegularMgFinishListAjax(requestBox);
	}
  
	//수료자 스탶 수료 정보
	@Override
	public List<DataBox> lmsRegularMgFinishStepList(RequestBox requestBox) throws Exception {
		return lmsRegularMgMapper.lmsRegularMgFinishStepList(requestBox);
	}
	  
	//개인별 설문지 호출
	@Override
	public Map<String, Object> lmsRegularMgDetailSurveyResponsePop(RequestBox requestBox) throws Exception {
		Map<String,Object> data = new HashMap<String, Object>();
		
		//설문 답변 가져오기
		List<DataBox> responseList1 = lmsRegularMgMapper.lmsRegularMgDetailSurveyResponseList1Pop(requestBox);
		
		//선다형 답변 가져오기
		List<DataBox> responseList2 = lmsRegularMgMapper.lmsRegularMgDetailSurveyResponseList2Value(requestBox);
		
		data.put("responseList1", responseList1);
		data.put("responseList2", responseList2);
		return data;
	}
	
	//회원정보
	@Override
	public DataBox lmsRegularMgDetailSurveyResponsePopInfo(RequestBox requestBox) throws Exception {
		return lmsRegularMgMapper.lmsRegularMgDetailSurveyResponsePopInfo(requestBox);
	}
	
	//정규과정 수료 처리
	@Override
	public int lmsRegularMgFinishUpdateAjax(RequestBox requestBox)throws Exception {
		int cnt = 0;
		
		String uidString = requestBox.get("uidString");
		String finishFlagString = requestBox.get("finishFlagString");
		String beforeFinishFlagString = requestBox.get("beforeFinishFlagString");
		String uidArray[] =  uidString.split(",");
		String finishflagArray[] =  finishFlagString.split(",");
		String beforeFinishflagArray[] =  beforeFinishFlagString.split(",");
		
		for(int i=0; i<uidArray.length; i++)
		{	
			String uid= uidArray[i];
			String finishFlag = finishflagArray[i];
			String beforeFinishFlag = beforeFinishflagArray[i];
			
			if(!finishFlag.equals(beforeFinishFlag))
			{	
				requestBox.put("uid", uid);
				requestBox.put("finishflag", finishFlag);
				//정규과정 수료날짜 있는지 조회하기
				String existFinishDate = lmsRegularMgMapper.lmsRegularMgExistFinishDateCheckR(requestBox);

				requestBox.put("existFinishDate", existFinishDate);
				
				//정규과정 수료 처리
				lmsRegularMgMapper.lmsRegularMgFinishUpdateAjax(requestBox);
				
				//정규과정 스탬프 처리					
				lmsRegularMgMapper.lmsRegularMgStampInsert(requestBox);
				
				cnt++;
			}
		}
		return cnt;
	}

	//정규과정Mg Survey Result Excel  다운로드
	@Override
	public List<Map<String, String>> lmsRegularMgSurveyExcelDownload(RequestBox requestBox) throws Exception {
		int idx = 0;
		List<Map<String,String>> dataList = new ArrayList<Map<String,String>>();

		Map<String,String> data ;
		
		//문제 리스트 가져오기
		List<DataBox> surveyList = lmsRegularMgMapper.lmsRegularMgDetailSurveyList(requestBox);
		
		//척도평균 가져오기
		List<DataBox> avgSampleValue = lmsRegularMgMapper.lmsRegularMgDetailSurveyAvgSampleValue(requestBox);
		
		
		//문제 리스트에 척도 평균 넣기
		for(int i = 0; i<surveyList.size(); i++)
		{	
			for(int j = 0; j<avgSampleValue.size(); j++)
			{	
				if(surveyList.get(i).getInt("surveyseq") == avgSampleValue.get(j).getInt("surveyseq"))
				{
					surveyList.get(i).put("avgsamplevalue", avgSampleValue.get(j).get("avgvalue"));
				}
			}
		}
		
		//Object 보기,지문 리스트 가져오기
		List<DataBox> sampleObjectList = lmsRegularMgMapper.lmsRegularMgDetailSurveySampleObjectList(requestBox);
		
		//Subject 보기,지문 리스트 가져오기
		List<DataBox> sampleSubjectList = lmsRegularMgMapper.lmsRegularMgDetailSurveySampleSubjectList(requestBox);
		
		//엑셀용 데이터 조합
		for(int i = 0; i<surveyList.size(); i++)
		{
			String surveySeq = surveyList.get(i).getString("surveyseq");
			if(surveyList.get(i).get("surveytype").equals("1") || surveyList.get(i).get("surveytype").equals("2"))
			{
				for(int j = 0; j<sampleObjectList.size();j++)
				{	
					if(surveySeq.equals(sampleObjectList.get(j).getString("surveyseq")))
					{
						data=new HashMap<String, String>();
						data.put("PCT", sampleObjectList.get(j).getString("pct"));
						data.put("CNT", sampleObjectList.get(j).getString("cnt"));
						data.put("SAMPLENAME", sampleObjectList.get(j).getString("samplename"));
						data.put("AVGVALUE", surveyList.get(i).getString("avgsamplevalue"));
						data.put("SURVEYNAME", surveyList.get(i).getString("surveyname"));
						data.put("SURVEYSEQ", surveyList.get(i).getString("surveyseq"));
						data.put("SURVEYTYPE", surveyList.get(i).getString("surveytype"));
						
						if(data != null && !data.equals(""))
						{
							dataList.add(idx, data);
							idx++;
						}
					}
					
				}
			}
			else if(surveyList.get(i).get("surveytype").equals("3") || surveyList.get(i).get("surveytype").equals("4"))
			{
				for(int j = 0; j<sampleSubjectList.size();j++)
				{
					if(surveySeq.equals(sampleSubjectList.get(j).getString("surveyseq")))
					{
						data=new HashMap<String, String>();
						data.put("PCT",  " ");
						data.put("CNT",  " ");
						data.put("SAMPLENAME", sampleSubjectList.get(j).getString("subjectresponse"));
						data.put("AVGVALUE",  " ");
						data.put("SURVEYNAME", surveyList.get(i).getString("surveyname"));
						data.put("SURVEYSEQ", surveyList.get(i).getString("surveyseq"));
						data.put("SURVEYTYPE", surveyList.get(i).getString("surveytype"));
						
						if(data != null && !data.equals(""))
						{
							dataList.add(idx, data);
							idx++;
						}
					}

				}
			}
			
		}
		
		//중복 삭제
		for(int i =0;i<dataList.size()-1;i++)
		{
			
			if(!dataList.get(i).get("SURVEYSEQ").equals(" "))
			{
				for(int j = i+1;j<dataList.size();j++)
				{
					if(dataList.get(i).get("SURVEYSEQ").equals(dataList.get(j).get("SURVEYSEQ")))
					{	
						if(dataList.get(j).get("SURVEYTYPE").equals("1") || dataList.get(j).get("SURVEYTYPE").equals("2"))
						{
							dataList.get(j).put("SURVEYSEQ", " ");
							dataList.get(j).put("SURVEYNAME", " ");
							dataList.get(j).put("AVGVALUE", " ");
							
						}
						else if(dataList.get(i).get("SURVEYTYPE").equals("3") || dataList.get(j).get("SURVEYTYPE").equals("4"))
						{
							dataList.get(j).put("SURVEYSEQ", " ");
							dataList.get(j).put("SURVEYNAME", " ");
						}
					}
					
				}
			}
		}
		
		return dataList;
	}
	
	//부사업자신청 허용 flag가져오기
	@Override
	public String selectLmsRegularMgOfflineTogetherFlag(RequestBox requestBox)throws Exception {
		return lmsRegularMgMapper.selectLmsRegularMgOfflineTogetherFlag(requestBox);
	}
}
