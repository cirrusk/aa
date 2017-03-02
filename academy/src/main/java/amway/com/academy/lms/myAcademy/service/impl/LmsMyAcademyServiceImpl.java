package amway.com.academy.lms.myAcademy.service.impl;

import java.util.List;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import amway.com.academy.common.push.PushSend;
import amway.com.academy.lms.common.LmsUtil;
import amway.com.academy.lms.common.service.LmsCommonService;
import amway.com.academy.lms.common.service.impl.LmsCommonMapper;
import amway.com.academy.lms.myAcademy.service.LmsMyAcademyService;
import amway.com.academy.lms.request.service.impl.LmsRequestMapper;
import framework.com.cmm.lib.DataBox;
import framework.com.cmm.lib.RequestBox;

@Service
public class LmsMyAcademyServiceImpl  implements LmsMyAcademyService{

	@SuppressWarnings("unused")
	private static final Logger LOGGER = LoggerFactory.getLogger(LmsMyAcademyServiceImpl.class);
	
	@Autowired
	private LmsMyAcademyMapper lmsMyAcademyMapper;
	
	@Autowired
	private PushSend pushSend;
	
	@Autowired
	private LmsRequestMapper lmsRequestMapper;
	
	@Autowired
	private LmsCommonService lmsCommonService;
	
	@Autowired
	private LmsCommonMapper lmsCommonMapper;

	/**
	 * 통합교육 신청 과정 달력
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	public List<DataBox> selectLmsRequestMonthDate(RequestBox requestBox) throws Exception {

		List<DataBox> list = lmsRequestMapper.selectLmsRequestMonthDate(requestBox);
		
		return list;
	}
	
	/**
	 * 통합교육 신청 달력 목록
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	public List<DataBox> selectLmsMyAcademyCourseCalendar(RequestBox requestBox) throws Exception {

		List<DataBox> list = lmsMyAcademyMapper.selectLmsMyAcademyCourseCalendar(requestBox);
		
		return list;
	}
	
	
	/**
	 * 통합교육 신청 페이징 목록 카운트
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	public int selectLmsMyAcademyCourseListCount(RequestBox requestBox) throws Exception {
		
		return lmsMyAcademyMapper.selectLmsMyAcademyCourseListCount(requestBox);
	
	}
	
	/**
	 * 통합교육 신청 페이징 목록
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	public List<DataBox> selectLmsMyAcademyCourseList(RequestBox requestBox) throws Exception {

		List<DataBox> list = lmsMyAcademyMapper.selectLmsMyAcademyCourseList(requestBox);
		
		return list;
	}
	
	/**
	 * 통합교육 신청 정규과정 상세
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	public DataBox selectLmsMyAcademyRegular(RequestBox requestBox) throws Exception {
		DataBox courseMap = lmsMyAcademyMapper.selectLmsMyAcademyRegular(requestBox);
		if(courseMap != null){
			courseMap.put("coursecontent", LmsUtil.getHtmlStrCnvr(courseMap.getString("coursecontent")));
			courseMap.put("note", LmsUtil.getHtmlStrCnvr(courseMap.getString("note")));
			courseMap.put("passnote", LmsUtil.getHtmlStrCnvr(courseMap.getString("passnote")));
			courseMap.put("penaltynote", LmsUtil.getHtmlStrCnvr(courseMap.getString("penaltynote")));
		}
		return courseMap;
	}
	
	/**
	 * 통합교육 신청 정규과정 상세 구성강좌 목록
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	public List<DataBox> selectLmsMyAcademyRegularUnit(RequestBox requestBox) throws Exception {

		List<DataBox> list = lmsMyAcademyMapper.selectLmsMyAcademyRegularUnit(requestBox);
		List<DataBox> list2 = lmsMyAcademyMapper.selectLmsMyAcademyRegularSeat(requestBox);
		
		//테이블 조립
		for(int i =0 ; i<list.size();i++)
		{
			String courseid = list.get(i).getString("courseid");
			String seatnumber = "";
			for(int j=0;j<list2.size();j++)
			{	
				String courseid2 = list2.get(j).getString("courseid");
				if(courseid.equals(courseid2))
				{	
					if(seatnumber.equals(""))
					{
						seatnumber = list2.get(j).getString("seatnumber");
					}
					else
					{
						StringBuffer seatnumberBuffer = new StringBuffer(seatnumber);
						seatnumberBuffer.append(","+list2.get(j).getString("seatnumber"));
						seatnumber = seatnumberBuffer.toString();
					}
				}
			}
			list.get(i).put("seatnumber", seatnumber);
		}
		
		return list;
	}
	
	/**
	 * 통합교육 신청 오프라인강의 상세
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	public DataBox selectLmsMyAcademyOffline(RequestBox requestBox) throws Exception {
		DataBox courseMap = lmsMyAcademyMapper.selectLmsMyAcademyOffline(requestBox);
		if(courseMap != null){
			courseMap.put("coursecontent", LmsUtil.getHtmlStrCnvrBr(courseMap.getString("coursecontent")));
			courseMap.put("detailcontent", LmsUtil.getHtmlStrCnvr(courseMap.getString("detailcontent")));
			courseMap.put("note", LmsUtil.getHtmlStrCnvr(courseMap.getString("note")));
			courseMap.put("penaltynote", LmsUtil.getHtmlStrCnvr(courseMap.getString("penaltynote")));
		}
		return courseMap;
	}
	
	/**
	 * 통합교육 신청 라이브교육 상세
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	public DataBox selectLmsMyAcademyLive(RequestBox requestBox) throws Exception {
		DataBox courseMap = lmsMyAcademyMapper.selectLmsMyAcademyLive(requestBox);
		if(courseMap != null){
			courseMap.put("coursecontent", LmsUtil.getHtmlStrCnvr(courseMap.getString("coursecontent")));
			courseMap.put("note", LmsUtil.getHtmlStrCnvr(courseMap.getString("note")));
			courseMap.put("penaltynote", LmsUtil.getHtmlStrCnvr(courseMap.getString("penaltynote")));
		}
		return courseMap;
	}
	
	/**
	 * 신청현황 교육신청 취소
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	public DataBox updateLmsMyAcademyCancel(RequestBox requestBox) throws Exception {
		DataBox map = new DataBox();
		DataBox possibleMap = lmsMyAcademyMapper.selectLmsMyAcademyCancelPossible(requestBox);
		String yStr = "Y";
		String fStr = "F";
		String lStr = "L";
		String rStr = "R";
		if(possibleMap!=null && possibleMap.get("cancelpossibleflag") != null && yStr.equals(possibleMap.getString("cancelpossibleflag"))){
			int cnt = lmsMyAcademyMapper.updateLmsMyAcademyCancel(requestBox);
			if(cnt > 0){
				map.put("result", "OK");
				map.put("msg", "신청이 취소되었습니다.");	
				/*쪽지 발송*/
				if(fStr.equals(possibleMap.get("coursetype")) || lStr.equals(possibleMap.get("coursetype")) || rStr.equals(possibleMap.get("coursetype"))){
					requestBox.put("coursename", possibleMap.get("coursename")) ;
					requestBox.put("coursetype", possibleMap.get("coursetype")) ;
					requestBox.put("apname", possibleMap.get("apname")) ;
					requestBox.put("noteitem", "103") ; // 오프라인 취소 완료, 라이브 신청완료, 정규과정 신청완료
					lmsCommonService.insertLmsNoteSend(requestBox);
					
					if(fStr.equals(possibleMap.get("coursetype"))){
						String pushTitle = "오프라인과정신청이 취소되었습니다.";
						String pushMsg = possibleMap.get("coursename")+ "["+possibleMap.get("apname")+"] 오프라인과정신청이 취소되었습니다.";
						String pushUrl = "weblink|/lms/myAcademy/lmsMyRequest";
						requestBox.put("pushTitle", pushTitle);
						requestBox.put("pushMsg", pushMsg);
						requestBox.put("pushUrl", pushUrl);
						requestBox.put("pushCategory", "ACADEMY");
						
						requestBox.put("pushUserId", requestBox.get("uid"));
						DataBox resultBox = pushSend.sendPushByUser(requestBox);
						LOGGER.debug("XXXXXXXXXXXXXX 	status XXXXXXXXXXXXXXX = " + resultBox.getString("status") );			
					}
					
				}

				//AmwayGo 그룹방 연동
				lmsCommonMapper.lmsAmwayGoDataSynch(requestBox);
				
			}else{
				map.put("result", "NO");
				map.put("msg", "신청 취소 중 오류가 발생했습니다.");
			}
		}else{
			map.put("result", "NO");
			map.put("msg", "신청 가능한 일자가 아닙니다.");
		}
		return map;
	}
	
	/**
	 * 해당월의 교육과정 일마다 읽어오기
	 */
	public List<DataBox> selectLmsMyAcademyDayCount(RequestBox requestBox) throws Exception {

		List<DataBox> list = lmsMyAcademyMapper.selectLmsMyAcademyDayCount(requestBox);
		
		return list;
	}
	
	/**
	 * 해당일의 교육정보 읽어오기
	 */
	public List<DataBox> selectLmsMyAcademyCourseCalendarDay(RequestBox requestBox) throws Exception {

		List<DataBox> list = lmsMyAcademyMapper.selectLmsMyAcademyCourseCalendarDay(requestBox);
		
		return list;
	}
	
	/**
	 * 신청현황 기본 정보 상세
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	public DataBox selectLmsMyAcademyListView(RequestBox requestBox) throws Exception {
		return lmsMyAcademyMapper.selectLmsMyAcademyListView(requestBox);
	}
	
}
