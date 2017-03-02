package amway.com.academy.manager.lms.test.service.impl;

import java.util.List;
import java.util.Map;
import java.util.Vector;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import amway.com.academy.manager.lms.test.service.LmsTestPoolService;
import framework.com.cmm.lib.DataBox;
import framework.com.cmm.lib.RequestBox;

@Service
public class LmsTestPoolServiceImpl implements LmsTestPoolService {

	@Autowired
	private LmsTestPoolMapper lmsTestPoolServiceMapper;
	
	@Override
	public int selectCategoryTestCount(RequestBox requestBox) throws Exception {
		return lmsTestPoolServiceMapper.lmsSelectCategoryTestCount(requestBox);
	}
	
	@Override
	public int selectMaxCategoryTestId(RequestBox requestBox) throws Exception {
		return lmsTestPoolServiceMapper.lmsSelectMaxCategoryTestId(requestBox);
	}
	
	@Override
	public List<DataBox> selectCategoryTestList(RequestBox requestBox) throws Exception {
		return lmsTestPoolServiceMapper.lmsSelectCategoryTestList(requestBox);
	}
	
	@Override
	public List<Map<String, String>> selectCategoryTestExcelList(RequestBox requestBox) throws Exception {
		return lmsTestPoolServiceMapper.lmsSelectCategoryTestExcelList(requestBox);
	}	

	@Override
	public int deleteCategoryTest(RequestBox requestBox) throws Exception {
		return lmsTestPoolServiceMapper.lmsDeleteCategoryTest(requestBox);
	}
	
	@Override
	public int insertCategoryTestAjax(RequestBox requestBox) throws Exception {
		return lmsTestPoolServiceMapper.lmsInsertCategoryTestAjax(requestBox);
	}
	
	@Override
	public int updateCategoryTestAjax(RequestBox requestBox) throws Exception {
		return lmsTestPoolServiceMapper.lmsUpdateCategoryTestAjax(requestBox);
	}
	
	@Override
	public DataBox selectCategoryTestDetail(RequestBox requestBox) throws Exception {
		return lmsTestPoolServiceMapper.lmsSelectCategoryTestDetail(requestBox);
	}
	
	@Override
	public int selectTestPoolCount(RequestBox requestBox) throws Exception {
		return lmsTestPoolServiceMapper.lmsSelectTestPoolCount(requestBox);
	}
	
	@Override
	public List<DataBox> selectTestPoolList(RequestBox requestBox) throws Exception {
		return lmsTestPoolServiceMapper.lmsSelectTestPoolList(requestBox);
	}
	
	@Override
	public List<Map<String, String>> selectTestPoolExcelList(RequestBox requestBox) throws Exception {
		return lmsTestPoolServiceMapper.lmsSelectTestPoolExcelList(requestBox);
	}
	
	@Override
	public DataBox selectTestPoolDetail(RequestBox requestBox) throws Exception {
		return lmsTestPoolServiceMapper.lmsSelectTestPoolDetail(requestBox);
	}
	
	@Override
	public List<DataBox> selectTestPoolAnswerList(RequestBox requestBox) throws Exception {
		return lmsTestPoolServiceMapper.lmsSelectTestPoolAnswerList(requestBox);
	}
	
	@SuppressWarnings("rawtypes")
	@Override
	public int insertTestPoolAjax(RequestBox requestBox) throws Exception {
		
		String answertype = requestBox.get("answertype");
		String objectanswer = "";
		String blankStr = "";
		String str1 = "1";
		String str2 = "2";
		if( "1".equals(answertype) ) {
			objectanswer = requestBox.get("testpoolanswerseqRadio");
		} else if( "2".equals(answertype) ) {
			Vector testpoolanswerseqCheckboxVec = requestBox.getVector("testpoolanswerseqCheckbox");
			for( int i=0; i<testpoolanswerseqCheckboxVec.size(); i++ ){
				StringBuffer objectanswerBuffer = new StringBuffer(objectanswer);
				objectanswerBuffer.append( testpoolanswerseqCheckboxVec.get(i).toString() + "," );
				objectanswer = objectanswerBuffer.toString();
			}
			if(!blankStr.equals(objectanswer)) {
				objectanswer = objectanswer.substring(0, objectanswer.length()-1);
			}
		}
		requestBox.put("objectanswer", objectanswer);

		// 문제 등록
		int testpoolCnt = lmsTestPoolServiceMapper.lmsInsertTestPoolAjax(requestBox);
		requestBox.put("testpoolid",requestBox.get("maxtestpoolid"));
		
		int testpoolAnswerCnt = 0;
		if( str1.equals(answertype) || str2.equals(answertype) ) {
			int answercount = requestBox.getInt("answercount");
			Vector testpoolanswernameVec = requestBox.getVector("testpoolanswername");
			for( int i=0; i<answercount; i++ ){
				// 문제 답변 등록
				requestBox.put("testpoolanswerseq", (i+1)+"");
				requestBox.put("testpoolanswername", testpoolanswernameVec.get(i));
				testpoolAnswerCnt += lmsTestPoolServiceMapper.lmsInsertTestPoolAnswerAjax(requestBox);
			}
		}
		
		return testpoolCnt + testpoolAnswerCnt;
	}
	
	@SuppressWarnings("rawtypes")
	@Override
	public int updateTestPoolAjax(RequestBox requestBox) throws Exception {
		
		String answertype = requestBox.get("answertype");
		String objectanswer = "";
		String blankStr = "";
		String str1 = "1";
		String str2 = "2";
		if( "1".equals(answertype) ) {
			objectanswer = requestBox.get("testpoolanswerseqRadio");
		} else if( "2".equals(answertype) ) {
			Vector testpoolanswerseqCheckboxVec = requestBox.getVector("testpoolanswerseqCheckbox");
			for( int i=0; i<testpoolanswerseqCheckboxVec.size(); i++ ){
				StringBuffer objectanswerBuffer = new StringBuffer(objectanswer);
				objectanswerBuffer.append( testpoolanswerseqCheckboxVec.get(i) + "," );
				objectanswer = objectanswerBuffer.toString();
			}
			if(!blankStr.equals(objectanswer)) {
				objectanswer = objectanswer.substring(0, objectanswer.length()-1);
			}
		}
		requestBox.put("objectanswer", objectanswer);
		
		// 문제 수정
		int testpoolCnt = lmsTestPoolServiceMapper.lmsUpdateTestPoolAjax(requestBox);
		
		testpoolCnt += lmsTestPoolServiceMapper.lmsDeleteTestPoolAnswerAjax(requestBox);
		
		int testpoolAnswerCnt = 0;
		if( str1.equals(answertype) || str2.equals(answertype) ) {
			int answercount = requestBox.getInt("answercount");
			Vector testpoolanswernameVec = requestBox.getVector("testpoolanswername");
			for( int i=0; i<answercount; i++ ){
				// 문제 답변 등록
				requestBox.put("testpoolanswerseq", (i+1)+"");
				requestBox.put("testpoolanswername", testpoolanswernameVec.get(i));
				testpoolAnswerCnt += lmsTestPoolServiceMapper.lmsInsertTestPoolAnswerAjax(requestBox);
			}
		}
		
		return testpoolCnt + testpoolAnswerCnt;
		
	}
	
	@Override
	public int deleteTestPool(RequestBox requestBox) throws Exception {
		return lmsTestPoolServiceMapper.lmsDeleteTestPool(requestBox);
	}
	
	@Override
	public int insertTestPoolExcelAjax(RequestBox requestBox, List<Map<String,String>> list) throws Exception {
		
		int cnt = 0;
		String str1 = "1";
		String str2 = "2";
		for( int i=0; i<list.size(); i++ ) {
			Map<String,String> retMap = (Map<String,String>)list.get(i);
			
			requestBox.put("testpoolname", retMap.get("col1"));
			requestBox.put("testpoolnote", retMap.get("col2"));
			
			String answertype = retMap.get("col0");
			requestBox.put("answertype", answertype);
			
			int answercount = 0;
			if( str1.equals(answertype) || str2.equals(answertype) ) {
				requestBox.put("objectanswer", retMap.get("col3"));
				requestBox.put("subjectanswer", "");
				
				answercount = Integer.parseInt(retMap.get("col4"));
				
			} else {
				requestBox.put("objectanswer", "");
				requestBox.put("subjectanswer", retMap.get("col3"));
			}

			// 문제 등록
			int testpoolCnt = lmsTestPoolServiceMapper.lmsInsertTestPoolAjax(requestBox);
			requestBox.put("testpoolid",requestBox.get("maxtestpoolid"));

			int testpoolAnswerCnt = 0;
			if( str1.equals(answertype) || str2.equals(answertype) ) {
				for( int k=0; k<answercount; k++ ){
					// 문제 답변 등록
					requestBox.put("testpoolanswerseq", (k+1)+"");
					requestBox.put("testpoolanswername", retMap.get("col" + (5+k) ) );

					testpoolAnswerCnt += lmsTestPoolServiceMapper.lmsInsertTestPoolAnswerAjax(requestBox);
				}
			}

			cnt += testpoolCnt + testpoolAnswerCnt;
		}
		
		return cnt;
		
	}
}
