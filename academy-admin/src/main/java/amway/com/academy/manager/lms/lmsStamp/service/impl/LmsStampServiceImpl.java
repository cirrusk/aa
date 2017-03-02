package amway.com.academy.manager.lms.lmsStamp.service.impl;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import amway.com.academy.manager.lms.course.service.impl.LmsKeywordMapper;
import amway.com.academy.manager.lms.lmsStamp.service.LmsStampService;
import framework.com.cmm.lib.DataBox;
import framework.com.cmm.lib.RequestBox;

@Service
public class LmsStampServiceImpl implements LmsStampService {

	@SuppressWarnings("unused")
	private static final Logger LOGGER = LoggerFactory.getLogger(LmsStampServiceImpl.class);
	
	@Autowired
	private LmsStampMapper lmsStampMapper;
	
	@Autowired
	private LmsKeywordMapper lmsKeywordMapper;
	
	@Override
	public int selectLmsStampCount(RequestBox requestBox) throws Exception {
		return lmsStampMapper.selectLmsStampCount(requestBox);
	}
	
	@Override
	public List<DataBox> selectLmsStampList(RequestBox requestBox) throws Exception {
		return lmsStampMapper.selectLmsStampList(requestBox);
	}	
	
	@Override
	public List<Map<String, String>> selectLmsStampListExcelDown(RequestBox requestBox) throws Exception {
		return lmsStampMapper.selectLmsStampListExcelDown(requestBox);
	}
	
	@Override
	public int deleteLmsStamp(RequestBox requestBox) throws Exception {
		int result = lmsStampMapper.deleteLmsStamp(requestBox);
		
		lmsKeywordMapper.deleteLmsKeywordStamp(requestBox);
		
		return result;
	}
	
	@Override
	public DataBox selectLmsStamp(RequestBox requestBox) throws Exception {
		return lmsStampMapper.selectLmsStamp(requestBox);
	}

	@Override
	public int insertLmsStamp(RequestBox requestBox) throws Exception {
		
		int result = lmsStampMapper.insertLmsStamp(requestBox);
		String url = "/lms/myAcademy/lmsMyEducation";
		
		//스탬프 SEARCHLMS 등록
		requestBox.put("academyurl", url+".do");
		requestBox.put("hybrisurl", url);
		lmsKeywordMapper.mergeKeywordSearchLmsStamp(requestBox);
		//End SEARCHLMS등록
		
		return result;
	}
	
	@Override
	public int updateLmsStamp(RequestBox requestBox) throws Exception {
		int result= lmsStampMapper.updateLmsStamp(requestBox);
		requestBox.put("maxstampid", requestBox.get("stampid"));
		
		lmsKeywordMapper.mergeKeywordSearchLmsStamp(requestBox);
		return result;
	}
	
	//스탬프 종류 가져오기
	@Override
	public List<DataBox> seletLmsStampList() throws Exception {
		return lmsStampMapper.seletLmsStampList();
	}
	
	//기본 회계기간 가져오기
	@Override
	public Map<String, String> selectLmsStampDate() throws Exception {
		int year = lmsStampMapper.selectLmsStampDate();
		
		Map<String,String> date = new HashMap<String, String>();
		
		date.put("searchstartdate", (year-1)+"-09-01");
		date.put("searchenddate", year+"-08-31");
		
		
		return date;
	}
	
	//스탬프 통계 정보 가져오기
	@Override
	public DataBox selectLmsStampRankingInfo(RequestBox requestBox)throws Exception {
		return lmsStampMapper.selectLmsStampRankingInfo(requestBox);
	}
	//회원 목록
	@Override
	public List<DataBox> lmsStampMemberListAjax(RequestBox requestBox)throws Exception {
		return lmsStampMapper.lmsStampMemberListAjax(requestBox);
	}
	//회원 목록 카운트
	@Override
	public int lmsStampMemberListCount(RequestBox requestBox) throws Exception {
		return lmsStampMapper.lmsStampMemberListCount(requestBox);
	}
	//스탬프 목록
	@Override
	public List<DataBox> lmsStampKindListAjax(RequestBox requestBox)throws Exception {
		return lmsStampMapper.lmsStampKindListAjax(requestBox);
	}
	//스탬프 목록 카운트
	@Override
	public int lmsStampKindListCount(RequestBox requestBox) throws Exception {
		return lmsStampMapper.lmsStampKindListCount(requestBox);
	}
	//스탬프 통계 정보 가져오기(스탬프종류 탭)
	@Override
	public DataBox selectLmsStampKindInfo(RequestBox requestBox)throws Exception {
		return lmsStampMapper.selectLmsStampKindInfo(requestBox);
	}
	
	//스탬프 획득자 목록
	@Override
	public List<DataBox> lmsStampObtainMemberPopAjax(RequestBox requestBox)throws Exception {
		return lmsStampMapper.lmsStampObtainMemberPopAjax(requestBox);
	}
	
	//스탬프 획득자 목록 카운트
	@Override
	public int lmsStampObtainMemberPopAjaxCount(RequestBox requestBox)throws Exception {
		return lmsStampMapper.lmsStampObtainMemberPopAjaxCount(requestBox);
	}
	
	//StampKind Excel  다운로드
	@Override
	public List<Map<String, String>> lmsStampKindListExcelDown(RequestBox requestBox) throws Exception {
		return lmsStampMapper.lmsStampKindListExcelDown(requestBox);
	}
	//스탬프현황 목록
	@Override
	public List<DataBox> lmsStampStatusListAjax(RequestBox requestBox) throws Exception {
		return lmsStampMapper.lmsStampStatusListAjax(requestBox);
	}
	//스탬프현황 목록 카운트
	@Override
	public int lmsStampStatusListCount(RequestBox requestBox) throws Exception {
		return lmsStampMapper.lmsStampStatusListCount(requestBox);
	}

	//페널티관리 목록
	@Override
	public List<DataBox> lmsPenaltyManageListAjax(RequestBox requestBox)throws Exception {
		return lmsStampMapper.lmsPenaltyManageListAjax(requestBox);
	}
	
	//페널티관리 목록 카운트
	@Override
	public int lmsPenaltyManageListCount(RequestBox requestBox)throws Exception {
		return lmsStampMapper.lmsPenaltyManageListCount(requestBox);
	}
	
	//페널티 해제
	@Override
	public void lmsPenaltyClearAjax(RequestBox requestBox) throws Exception {
		lmsStampMapper.lmsPenaltyClearAjax(requestBox);
	}
}
