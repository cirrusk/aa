package amway.com.academy.manager.lms.statistics.service.impl;



import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import framework.com.cmm.lib.DataBox;
import framework.com.cmm.lib.RequestBox;
import amway.com.academy.manager.lms.statistics.service.LmsStatisticsService;


@Service
public class LmsStatisticsServiceImpl implements LmsStatisticsService {
	
	@Autowired
	private LmsStatisticsMapper lmsStatisticsMapper;
	
	//회계년도 가져오기
	@Override
	public int selectLmsYear() throws Exception {
		return lmsStatisticsMapper.selectLmsYear();
	}
	
	//월별 아카데미 현황
	@Override
	public List<DataBox> lmsStatisticsAcademyStatusPerMonth(RequestBox requestBox) throws Exception {
		
		int year = requestBox.getInt("date");
		
		requestBox.put("startdate", (year-1)+"09");
		requestBox.put("enddate", year+"08");
		
		List<DataBox> dataList = new ArrayList<DataBox>();
		
		DataBox data = new DataBox();
		//월별 접속(누적)
		data =lmsStatisticsMapper.lmsStatisticsConnectPerMonth(requestBox);
		dataList.add(data);
		
		//월별 순수접속(UV)
		data =lmsStatisticsMapper.lmsStatisticsConnectUVPerMonth(requestBox);
		dataList.add(data);

		//콘텐츠 조회
		data =lmsStatisticsMapper.lmsStatisticsContentsViewCount(requestBox);
		dataList.add(data);

		//온라인 수료
		data =lmsStatisticsMapper.lmsStatisticsOnlineFinishCount(requestBox);
		dataList.add(data);

		//오프라인 출석
		data =lmsStatisticsMapper.lmsStatisticsOfflineFinishCount(requestBox);
		dataList.add(data);

		//스탬프 획득
		data =lmsStatisticsMapper.lmsStatisticsStampObtainCount(requestBox);
		dataList.add(data);

		
		
		return dataList;
	}
	
	//월별 아카데미 현황 엑셀 다운
	@SuppressWarnings("unchecked")
	@Override
	public List<Map<String, String>> lmsStatisticsAcademyStatusPerMonthExcelDown(RequestBox requestBox) throws Exception {
		int year = requestBox.getInt("date");
		
		requestBox.put("startdate", (year-1)+"09");
		requestBox.put("enddate", year+"08");
		
		List<Map<String, String>> dataList = new ArrayList<Map<String, String>>();
		
		Map<String, String> data = new HashMap<String, String>();
		//월별 접속(누적)
		data =lmsStatisticsMapper.lmsStatisticsConnectPerMonth(requestBox);
		dataList.add(data);
		
		//월별 순수접속(UV)
		data =lmsStatisticsMapper.lmsStatisticsConnectUVPerMonth(requestBox);
		dataList.add(data);

		//콘텐츠 조회
		data =lmsStatisticsMapper.lmsStatisticsContentsViewCount(requestBox);
		dataList.add(data);

		//온라인 수료
		data =lmsStatisticsMapper.lmsStatisticsOnlineFinishCount(requestBox);
		dataList.add(data);

		//오프라인 출석
		data =lmsStatisticsMapper.lmsStatisticsOfflineFinishCount(requestBox);
		dataList.add(data);

		//스탬프 획득
		data =lmsStatisticsMapper.lmsStatisticsStampObtainCount(requestBox);
		dataList.add(data);

		return dataList;
	}
	
	//교육자료,온라인 조회수 상위 20
	@Override
	public List<DataBox> lmsStatisticsPerMonthTop20(RequestBox requestBox) throws Exception {
		return lmsStatisticsMapper.lmsStatisticsPerMonthTop20(requestBox);
	}
	
	//교육자료,온라인 조회수 상위 20 엑셀 다운
	@Override
	public List<Map<String, String>> lmsStatisticsPerMonthTop20ExcelDown(RequestBox requestBox) throws Exception {
		return lmsStatisticsMapper.lmsStatisticsPerMonthTop20ExcelDown(requestBox);
	}

	//오프라인과정 참석자 상위 10
	@Override
	public List<DataBox> lmsStatistisOfflineAttendPerMonthTop10(RequestBox requestBox) throws Exception {
		return lmsStatisticsMapper.lmsStatistisOfflineAttendPerMonthTop10(requestBox);
	}
	
	//오프라인과정 참석자 상위 10 엑셀다운
	@Override
	public List<Map<String, String>> lmsStatistisOfflineAttendPerMonthTop10ExcelDown(RequestBox requestBox) throws Exception {
		return lmsStatisticsMapper.lmsStatistisOfflineAttendPerMonthTop10ExcelDown(requestBox);
	}
	
	//온라인,라이브과정보고서 목록
	@Override
	public List<DataBox> lmsReportListAjax(RequestBox requestBox)throws Exception {
		return lmsStatisticsMapper.lmsReportListAjax(requestBox);
	}

	//온라인,라이브과정보고서 목록 카운트
	@Override
	public int lmsReportListCount(RequestBox requestBox)throws Exception {
		return lmsStatisticsMapper.lmsReportListCount(requestBox);
	}
	
	//보고서 팝업용 Data
	@Override
	public DataBox selectLmsReportPopData(RequestBox requestBox)throws Exception {
		return lmsStatisticsMapper.selectLmsReportPopData(requestBox);
	}

	//핀코드리스트 조회
	@Override
	public List<DataBox> selectLmsPinCodeList(RequestBox requestBox)throws Exception {
		return lmsStatisticsMapper.selectLmsPinCodeList(requestBox);
	}

	// 레이어팝업 리스트 
	@Override
	public List<DataBox> lmsReportPopListAjax(RequestBox requestBox)throws Exception {
		return lmsStatisticsMapper.lmsReportPopListAjax(requestBox);
	}

	// 레이어팝업 리스트 카운트
	@Override
	public int lmsReportPopListCount(RequestBox requestBox) throws Exception {
		return lmsStatisticsMapper.lmsReportPopListCount(requestBox);
	}
	
	//과정보고서 엑셀용 데이터
	@Override
	public List<Map<String, String>> lmsReportExcelDownload(RequestBox requestBox) throws Exception {
		return lmsStatisticsMapper.lmsReportExcelDownload(requestBox);
	}
	
	//단계수 조회
	@Override
	public int selectLmsRegularStepCount(RequestBox requestBox)throws Exception {
		return lmsStatisticsMapper.selectLmsRegularStepCount(requestBox);
	}
	
	// 정규과정보고서 리스트 카운트
	@Override
	public int lmsReportRegularCourseListCount(RequestBox requestBox)throws Exception {
		return lmsStatisticsMapper.lmsReportRegularCourseListCount(requestBox);
	}

	// 정규과정보고서 리스트
	@Override
	public List<DataBox> lmsReportRegularCourseListAjax(RequestBox requestBox)throws Exception {
		StringBuffer sb = new StringBuffer();
		StringBuffer sb2 = new StringBuffer();
		
		for(int i =1;i<=requestBox.getInt("stepcount");i++)
		{
				sb.append(",ISNULL(MAX(CASE WHEN STEPSEQ = "+i+" THEN STEPFINISHCOUNT END),0) AS 'STEP"+i+"'");
				sb2.append(",CASE WHEN A.MAXSTEPSEQ<"+i+" THEN '-' ELSE CONVERT(varchar(100),ISNULL(B.STEP"+i+",0)) END AS 'STEP"+i+"'");
		}
		requestBox.put("dynamicQuery", sb.toString());
		requestBox.put("dynamicQuery2", sb2.toString());
		return lmsStatisticsMapper.lmsReportRegularCourseListAjax(requestBox);
	}
	
	//정규과정보고서 엑셀용 데이터
	@Override
	public List<Map<String, String>> lmsReportRegularCurseExcelDownload(RequestBox requestBox) throws Exception {
		StringBuffer sb = new StringBuffer();
		StringBuffer sb2 = new StringBuffer();
		
		for(int i =1;i<=requestBox.getInt("stepcount");i++)
		{
				sb.append(",ISNULL(MAX(CASE WHEN STEPSEQ = "+i+" THEN STEPFINISHCOUNT END),0) AS 'STEP"+i+"'");
				sb2.append(",CASE WHEN A.MAXSTEPSEQ<"+i+" THEN '-' ELSE CONVERT(varchar(100),ISNULL(B.STEP"+i+",0)) END AS 'STEP"+i+"'");
		}
		requestBox.put("dynamicQuery", sb.toString());
		requestBox.put("dynamicQuery2", sb2.toString());
		
		return lmsStatisticsMapper.lmsReportRegularCurseExcelDownload(requestBox);
	}
 
}



































