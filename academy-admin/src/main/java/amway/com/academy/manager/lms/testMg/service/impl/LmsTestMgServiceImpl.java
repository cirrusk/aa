package amway.com.academy.manager.lms.testMg.service.impl;

import java.util.List;
import java.util.Map;
import java.util.Vector;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import amway.com.academy.manager.lms.course.service.impl.LmsCourseMapper;
import amway.com.academy.manager.lms.testMg.service.LmsTestMgService;
import framework.com.cmm.lib.DataBox;
import framework.com.cmm.lib.RequestBox;

@Service
public class LmsTestMgServiceImpl implements LmsTestMgService {
	
	@Autowired
	private LmsTestMgMapper lmsTestMgMapper;
	
	@Autowired
	private LmsCourseMapper lmsCourseMapper;
	
	@Override
	public List<DataBox> selectLmsTestMgCategoryList() {
		return lmsTestMgMapper.selectLmsTestMgCategoryList();
	}

	@Override
	public int selectLmsTestMgCount(RequestBox requestBox) {
		return lmsTestMgMapper.selectLmsTestMgCount(requestBox);
	}
	
	@Override
	public List<Map<String, String>> selectLmsTestMgExcelList(RequestBox requestBox) throws Exception {
		return lmsTestMgMapper.selectLmsTestMgExcelList(requestBox);
	}	

	@Override
	public List<DataBox> selectLmsTestMgList(RequestBox requestBox) {
		return lmsTestMgMapper.selectLmsTestMgList(requestBox);
	}

	@Override
	public DataBox selectLmsTestMgDetail(RequestBox requestBox) {
		return lmsTestMgMapper.selectLmsTestMgDetail(requestBox);
	}
	
	@Override
	public List<Map<String,String>> selectLmsTestPoolTotalList(RequestBox requestBox) {
		return lmsTestMgMapper.selectLmsTestPoolTotalList(requestBox);
	}
	
	@Override
	public List<Map<String,String>> selectLmsTestMgSubmitList(RequestBox requestBox) {
		return lmsTestMgMapper.selectLmsTestMgSubmitList(requestBox);
	}
	
	@Override
	public int insertLmsTestMgAjax(RequestBox requestBox) throws Exception {
		
		//1. insert lmsCourse
		requestBox.put("coursetype", "T");
		requestBox.put("requeststartdate", requestBox.get("startdate"));
		requestBox.put("requestenddate", requestBox.get("enddate"));
		
		int courseCnt = lmsCourseMapper.insertLmsCourse(requestBox);
		requestBox.put("courseid", requestBox.get("maxcourseid"));

		//2. insert lmsTest
		int resultCount = 0;
		resultCount = lmsTestMgMapper.insertLmsTest(requestBox);

		//3. insert lmsTestSubmit (3set)
		Vector<Object> testcountArr = requestBox.getVector("testcount");
		Vector<Object> testpointArr = requestBox.getVector("testpoint");
		Vector<Object> answertypeArr = requestBox.getVector("answertype");
		
		for(int i=0; i<testcountArr.size(); i++ ) {
		
			requestBox.put("submitseq", (i+1)+"");
			requestBox.put("testcount", testcountArr.get(i).toString());
			requestBox.put("testpoint", testpointArr.get(i).toString());
			requestBox.put("answertype", answertypeArr.get(i).toString());
			
			lmsTestMgMapper.insertLmsTestSubmit(requestBox);
			
			resultCount ++;
		}
		
		return courseCnt + resultCount;
	}
	
	@Override
	public int updateLmsTestMgAjax(RequestBox requestBox) throws Exception {
		
		//1. update lmsCourse
		requestBox.put("coursetype", "T");
		requestBox.put("requeststartdate", requestBox.get("startdate"));
		requestBox.put("requestenddate", requestBox.get("enddate"));
		
		int courseCnt = lmsCourseMapper.updateLmsCourse(requestBox);
		
		//2. update lmsTest
		int resultCount = 0;
		resultCount = lmsTestMgMapper.updateLmsTest(requestBox);
		
		//3. delete lmsTestSubmit
		resultCount = lmsTestMgMapper.deleteLmsTestSubmit(requestBox);
		
		//4. insert lmsTestSubmit (3set)
		Vector<Object> testcountArr = requestBox.getVector("testcount");
		Vector<Object> testpointArr = requestBox.getVector("testpoint");
		Vector<Object> answertypeArr = requestBox.getVector("answertype");
		
		for(int i=0; i<testcountArr.size(); i++ ) {
		
			requestBox.put("submitseq", (i+1)+"");
			requestBox.put("testcount", testcountArr.get(i).toString());
			requestBox.put("testpoint", testpointArr.get(i).toString());
			requestBox.put("answertype", answertypeArr.get(i).toString());
			
			lmsTestMgMapper.insertLmsTestSubmit(requestBox);
			
			resultCount ++;
		}
		
		return courseCnt + resultCount;
	}
	
	@Override
	public int deleteLmsTestMgAjax(RequestBox requestBox) throws Exception {
		return lmsCourseMapper.deleteLmsCourse(requestBox);
	}
	
}
