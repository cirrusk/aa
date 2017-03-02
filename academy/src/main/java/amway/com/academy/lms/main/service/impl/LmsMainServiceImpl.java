package amway.com.academy.lms.main.service.impl;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import framework.com.cmm.lib.RequestBox;
import amway.com.academy.lms.common.LmsUtil;
import amway.com.academy.lms.common.service.impl.LmsCommonMapper;
import amway.com.academy.lms.main.service.LmsMainService;
import amway.com.academy.lms.myAcademy.service.impl.LmsMySurveyMapper;

@Service
public class LmsMainServiceImpl  implements LmsMainService{
	@Autowired
	private LmsMainMapper lmsMainMapper;

	@Autowired
	private LmsMySurveyMapper lmsMySurveyMapper;
	
	@Autowired
	private LmsCommonMapper lmsCommonMapper;
	
	/**
	 * 과정조회조건 count
	 * @param requestBox
	 * @return
	 */
	@Override
	public int selectCourseListCount(RequestBox requestBox) {
		
		return (int) lmsMainMapper.selectCourseListCount(requestBox);
	}
	
	/**
	 * 과정조회조건
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	@Override
	public List<Map<String, Object>> selectCourseList(RequestBox requestBox) throws Exception {
		
		// 과정조회 12건 조회
		List<Map<String, Object>> courseTopList = lmsMainMapper.selectCourseList(requestBox);
		
		return courseTopList;
	}

	/**
	 * 회원 쪽지 count
	 * @param requestBox
	 * @return
	 */
	@Override
	public int selectMemberMessageCount(RequestBox requestBox) {
		
		return (int) lmsMainMapper.selectMemberMessageCount(requestBox);
	}
	
	/**
	 * 회원 쪽지 조회
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	@Override
	public List<Map<String, Object>> selectMemberMessageList(RequestBox requestBox) throws Exception {
		
		// 과정조회 12건 조회
		List<Map<String, Object>> memberMessageList = lmsMainMapper.selectMemberMessageList(requestBox);
		
		return memberMessageList;
	}

	
	/**
	 *  과정 기본정보 조회
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	@Override
	public List<Map<String, Object>> selectCourseDetail(RequestBox requestBox) throws Exception {
		
		List<Map<String, Object>> courseDetail = lmsMainMapper.selectCourseDetail(requestBox);
		
		return courseDetail;
	}

	/**
	 * 수강신청정보 체크
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	@Override
	public List<Map<String, Object>> selectCourseStudentView(RequestBox requestBox) throws Exception {
		
		List<Map<String, Object>> courseDetail = lmsMainMapper.selectCourseStudentView(requestBox);
		
		return courseDetail;
	}

	/**
	 * 교육수강생 - 수강신청 등록
	 * @param Map
	 * @return
	 */
	@Override
	public int insertLmsCourseStudentRequest(RequestBox requestBox) throws Exception {
		return (int) lmsMainMapper.insertLmsCourseStudentRequest(requestBox);
	}

	/**
	 * 교육수강생 - 수강신청 수정
	 * @param Map
	 * @return
	 */
	@Override
	public int updateLmsCourseStudentRequest(RequestBox requestBox) throws Exception {
		return (int) lmsMainMapper.updateLmsCourseStudentRequest(requestBox);
	}

	/**
	 * 교육수강생 - 수강신청 등록,수정
	 * @param Map
	 * @return
	 */
	@Override
	public int mergeLmsCourseStudentRequest(RequestBox requestBox) throws Exception {
		return (int) lmsMainMapper.mergeLmsCourseStudentRequest(requestBox);
	}
	
	/**
	 * 카테고리 분류 1,2,3 단계를 1단계 CATEGORYID 값을 가져온다
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	@Override
	public List<Map<String, Object>> selectCategoryLevelONE(RequestBox requestBox) throws Exception {
		
		List<Map<String, Object>> courseDetail = lmsMainMapper.selectCategoryLevelONE(requestBox);
		
		return courseDetail;
	}
	
	/**
	 * 강의자료 보기전 허용여부 체크
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	@Override
	public List<Map<String, Object>> selectCourseViewAcces(RequestBox requestBox) throws Exception {
		
		List<Map<String, Object>> courseDetail = lmsMainMapper.selectCourseViewAcces(requestBox);
		
		return courseDetail;
	}
		
	/**
	 * 교육수강생 - 수료처리 수정
	 * @param Map
	 * @return
	 */
	@Override
	public int updateLmsStudentFinish(RequestBox requestBox) throws Exception {
		int lmsCnt = 0;
		lmsCnt += lmsMainMapper.updateLmsStudentFinish(requestBox);
		lmsCnt += lmsCommonMapper.insertLmsStamp(requestBox);
		return lmsCnt;
	}
	

	/**
	 * COMPLIANCEFLAG 조회 count 
	 * @param Map
	 * @return
	 */
	@Override
	public int selectComplianceCount(RequestBox requestBox) {
		
		return (int) lmsMainMapper.selectComplianceCount(requestBox);
	}

	/**
	 * 조회로그 count
	 * @param Map
	 * @return
	 */
	@Override
	public int selectViewLogCount(RequestBox requestBox) {
		
		return (int) lmsMainMapper.selectViewLogCount(requestBox);
	}

	/**
	 * 조회로그 count - 등록
	 * @param Map
	 * @return
	 */
	@Override
	public int insertLmsViewLogCnt(RequestBox requestBox) throws Exception {
		
		return (int) lmsMainMapper.insertLmsViewLogCnt(requestBox);
	}
	
	/**
	 * 로그 count 1증가 - 수정
	 * @param Map
	 * @return
	 */
	@Override
	public int updateLmsViewLogCnt(RequestBox requestBox) throws Exception {
		
		return (int) lmsMainMapper.updateLmsViewLogCnt(requestBox);
	}
	
	/**
	 * 로그 count 1증가 - 등록,수정
	 * @param Map
	 * @return
	 */
	@Override
	public int mergeViewLogCount(RequestBox requestBox) throws Exception {
		
		return (int) lmsMainMapper.mergeViewLogCount(requestBox);
	}
	
	/**
	 * 교육과정 좋아요 count 1증가 - 수정
	 * @param Map
	 * @return
	 */
	@Override
	public int updateLmsCourseLikeCnt(RequestBox requestBox) throws Exception {
		
		return (int) lmsMainMapper.updateLmsCourseLikeCnt(requestBox);
	}
	
	/**
	 * 교육과정 조회수 1증가 - 수정
	 * @param Map
	 * @return
	 */
	@Override
	public int updateLmsCourseViewCnt(RequestBox requestBox) throws Exception {
		
		return (int) lmsMainMapper.updateLmsCourseViewCnt(requestBox);
	}
	

	/**
	 * 교육과정 좋아요 count
	 * @param Map
	 * @return
	 */
	@Override
	public List<Map<String, Object>> selectCourseLikeCount(RequestBox requestBox) {
		
		return (List<Map<String, Object>>) lmsMainMapper.selectCourseLikeCount(requestBox);
	}

	/**
	 * 교육과정 조회수
	 * @param Map
	 * @return
	 */
	@Override
	public List<Map<String, Object>> selectCourseViewCount(RequestBox requestBox) {
		
		return (List<Map<String, Object>>) lmsMainMapper.selectCourseViewCount(requestBox);
	}
	
	/**
	 * 저장로그 count
	 * @param Map
	 * @return
	 */
	@Override
	public int selectSaveLogCount(RequestBox requestBox) {
		
		return (int) lmsMainMapper.selectSaveLogCount(requestBox);
	}

	/**
	 * 저장로그 - 수정
	 * @param Map
	 * @return
	 */
	@Override
	public int updateLmsSaveLog(RequestBox requestBox) throws Exception {
		
		return (int) lmsMainMapper.updateLmsSaveLog(requestBox);
	}

	/**
	 * 저장로그 - 등록
	 * @param Map
	 * @return
	 */
	@Override
	public int insertLmsSaveLog(RequestBox requestBox) throws Exception {
		
		return (int) lmsMainMapper.insertLmsSaveLog(requestBox);
	}

	/**
	 * 저장로그 - 등록,수정
	 * @param Map
	 * @return
	 */
	@Override
	public int mergeSaveLog(RequestBox requestBox) throws Exception {
		
		return (int) lmsMainMapper.mergeSaveLog(requestBox);
	}

	/**
	 * 저장로그 - 삭제
	 * @param Map
	 * @return
	 */
	@Override
	public int deleteLmsSaveLog(RequestBox requestBox) throws Exception {
		
		return (int) lmsMainMapper.deleteLmsSaveLog(requestBox);
	}
	

	/**
	 * 저작권 동의 count - 온라인강의.
	 * @param RequestBox
	 * @return
	 */
	@Override
	public int selectCategoryAgree(RequestBox requestBox) {
		
		return (int) lmsMainMapper.selectCategoryAgree(requestBox);
	}

	/**
	 * 저작권 동의 count
	 * @param RequestBox
	 * @return
	 */
	@Override
	public int selectAgreeCount(RequestBox requestBox) {
		
		return (int) lmsMainMapper.selectAgreeCount(requestBox);
	}

	/**
	 * 저작권동의 - 등록
	 * @param Map
	 * @return
	 */
	@Override
	public int insertLmsCategoryAgree(RequestBox requestBox) throws Exception {
		
		return (int) lmsMainMapper.insertLmsCategoryAgree(requestBox);
	}
	

	/**
	 * 개인정보활용동의 count
	 * @param RequestBox
	 * @return
	 */
	@Override
	public int selectOnlinePersonInfoAgreeCnt(RequestBox requestBox) {
		
		return (int) lmsMainMapper.selectOnlinePersonInfoAgreeCnt(requestBox);
	}

	/**
	 * 개인정보활용동의 - 등록
	 * @param RequestBox
	 * @return
	 */
	@Override
	public int insertLmsOnlinePersonInfoAgree(RequestBox requestBox) throws Exception {
		
		return (int) lmsMainMapper.insertLmsOnlinePersonInfoAgree(requestBox);
	}

	/**
	 * LMSSTEPUNIT - 조회.
	 * @param Map
	 * @return
	 */
	@Override
	public List<Map<String, Object>> selectStepunitList(RequestBox requestBox)  throws Exception {
		
		return (List<Map<String, Object>>) lmsMainMapper.selectStepunitList(requestBox);
	}
	
	
	/**
	 * 정규과정 수료처리.
	 * @param void
	 * @return
	 */
	public void updateFinishProcess2(RequestBox requestBox) throws Exception {
		
		lmsMySurveyMapper.updateLmsStudentFinish(requestBox); //수료 확인 : stepcourseid, uid 필요함
		
		int zero = 0;
		List<Map<String, Object>> listData = lmsMainMapper.selectStepunitList(requestBox);  // LMSSTEPUNIT에서 stepseq 가져옴.
		if(!listData.isEmpty() && listData.size() > zero)  {
			requestBox.put("stepseq", (String) listData.get(0).get("stepseq").toString());
			requestBox.put("courseid", (String) listData.get(0).get("courseid").toString());

			lmsCommonMapper.updatetLmsStepFinish(requestBox); //과정 step 수료 여부 확인하기 : courseid, stepseq, uid 필요함
			lmsCommonMapper.updatetLmsTotalFinish(requestBox); //전체 수료 여부 확인하기 : courseid, uid 필요함
			lmsCommonMapper.insertLmsRegularStamp(requestBox); //정규과정 스탬프 발행
		}
	}
	
	/**
	 * 배너목록
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	@Override
	public List<Map<String, Object>> selectLmsBannerList(RequestBox requestBox) throws Exception {
		
		// 배너 조회
		List<Map<String, Object>> lmsBannerList = lmsMainMapper.selectLmsBannerList(requestBox);
		
		if(!lmsBannerList.isEmpty()){
			String blankStr = "";
			for(int i=0; i<lmsBannerList.size(); i++){
				Map<String, Object> map = new HashMap<String, Object>();
				map = lmsBannerList.get(i);
				String pcLink = (String) map.get("pclink");
				String mobileLink = (String) map.get("mobilelink");
				String addPcStr = "?";
				if(pcLink.indexOf("?")>0){
					addPcStr = "&";
				}
				String addMobileStr = "?";
				if(mobileLink.indexOf("?")>0){
					addMobileStr = "&";
				}
				
				String pcTarget = (String) map.get("pctarget");
				String mobileTarget = (String) map.get("mobiletarget");
				String inStr = "IN";

				if(blankStr.equals(pcLink)){
					pcLink = "#";
					pcTarget = "";
				}else{
					//pcLink = pcLink + addPcStr + "icid=banner|acdemymainBnr_"+requestBox.get("bannerDate")+"_"+(String) map.get("bannername")+"_"+map.get("bannerid");
					StringBuilder pcLinkB = new StringBuilder(pcLink);
					pcLinkB.append(addPcStr);
					pcLinkB.append("icid=banner|acdemymainBnr_");
					pcLinkB.append(requestBox.get("bannerDate"));
					pcLinkB.append("_");
					pcLinkB.append((String) map.get("bannername"));
					/*
					배너 고유번호는 무의미하다 하여 삭제함
					pcLinkB.append("_"); 
					pcLinkB.append(map.get("bannerid"));
					*/
					pcLink = pcLinkB.toString();
					
					if(inStr.equals(pcTarget)){
						pcTarget = " target=\"_top\"";
					}else{
						pcTarget = " target=\"_blank\"";
					}
				}
				if(blankStr.equals(mobileLink)){
					mobileLink = "#";
					mobileTarget = "";
				}else{
					//mobileLink = mobileLink + addMobileStr + "icid=banner|acdemymainBnr_"+requestBox.get("bannerDate")+"_"+(String) map.get("bannername")+"_"+map.get("bannerid");
					StringBuilder mobileLinkB = new StringBuilder(mobileLink);
					mobileLinkB.append(addMobileStr);
					mobileLinkB.append("icid=banner|acdemymainBnr_");
					mobileLinkB.append((String) map.get("registrantdate"));
					mobileLinkB.append("_");
					mobileLinkB.append((String) map.get("bannername"));
					/*
					배너 고유번호는 무의미하다 하여 삭제함
					mobileLinkB.append("_");
					mobileLinkB.append(map.get("bannerid"));
					*/
					mobileLink = mobileLinkB.toString();
					
					if(inStr.equals(mobileTarget)){
						mobileTarget = " target=\"_top\"";
					}else{
						mobileTarget = " target=\"_blank\"";
					}
				}
				pcLink = LmsUtil.getHtmlStrCnvr(pcLink);
				mobileLink = LmsUtil.getHtmlStrCnvr(mobileLink);				
				map.put("pclink", pcLink);
				map.put("mobilelink", mobileLink);
				map.put("pctargetstr", pcTarget);
				map.put("mobiletargetstr", mobileTarget);
				lmsBannerList.set(i, map);
			}
		}
		
		return lmsBannerList;
	}
	
}
