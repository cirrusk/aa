package amway.com.academy.manager.lms.common;

import java.io.File;
import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.UUID;
import java.util.Vector;

import org.springframework.stereotype.Repository;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;

import framework.com.cmm.lib.RequestBox;

/**
 * -----------------------------------------------------------------------------
 * 
 * @PROJ :AI ECM 1.5 
 * @NAME :LmsUtil.java
 * @DESC :유틸리티 관리
 * @Author:김택겸
 * @DATE : 2016-08-11 최초작성
 *      -----------------------------------------------------------------------------
 */

@Repository("lmsUtil")
public class LmsUtil {
	

	/**
	 * 파일업로드
	 * @param request
	 * @param model
	 * @return
	 * @throws Exception
	 */
	public List<Map<String, Object>> setFileMakeToList(MultipartHttpServletRequest request, String uploadFolder,  String childFolder) throws Exception{
		//folder mkdir
		File saveFolder = new File(uploadFolder+File.separator+childFolder);
		if(!saveFolder.exists() || saveFolder.isFile()){
			saveFolder.mkdirs();
		}
		
		//iterator
		Iterator<String> files = request.getFileNames();
		MultipartFile multipartFile;
		String filePath;
		List<Map<String, Object>> fileInfoList = new ArrayList<Map<String,Object>>();
		
		try{
			
			//while
			while(files.hasNext()){			
				
				//file생성
				String uuid = UUID.randomUUID().toString().replaceAll("-", "");
				multipartFile = request.getFile((String)files.next());
				String fieldName = multipartFile.getName();
				String extName = multipartFile.getOriginalFilename().substring(multipartFile.getOriginalFilename().lastIndexOf(".")+1 );
				String filename = uuid+"."+extName;
				filePath = uploadFolder+File.separator+childFolder+File.separator+filename;
				if( filename != null && !"".equals(multipartFile.getOriginalFilename()) ){
					multipartFile.transferTo(new File(filePath));

					//file정보 담기
					
					Map<String, Object> map = new HashMap<String, Object>();
					map.put("fieldName", fieldName);
					map.put("FilePath", filePath);
					map.put("OriginalFilename", multipartFile.getOriginalFilename());
					map.put("extName", extName);
					map.put("FileSize", multipartFile.getSize());
					map.put("FileSavedName", filename);
					fileInfoList.add(map);
				}
			}
			
		}catch(IOException e){
			e.printStackTrace();
		}
		
		return fileInfoList;
	}
	
	/**
	 * 대상자 변수 읽어서 List로 넘기기
	 * @param requestBox
	 * @return
	 */
	public static ArrayList<Map<String,String>> getLmsCourseConditionList(RequestBox requestBox) {
		ArrayList<Map<String,String>> conditionList = new ArrayList<Map<String,String>>();
		try {

			Vector<Object> conditiontypeArr = requestBox.getVector("conditiontypeArr");
			Vector<Object> abotypecodeArr = requestBox.getVector("abotypecodeArr");
			Vector<Object> abotypeaboveArr = requestBox.getVector("abotypeaboveArr");
			Vector<Object> pincodeArr = requestBox.getVector("pincodeArr");
			Vector<Object> pinunderArr = requestBox.getVector("pinunderArr");
			Vector<Object> pinaboveArr = requestBox.getVector("pinaboveArr");
			Vector<Object> bonuscodeArr = requestBox.getVector("bonuscodeArr");
			Vector<Object> bonusunderArr = requestBox.getVector("bonusunderArr");
			Vector<Object> bonusaboveArr = requestBox.getVector("bonusaboveArr");
			Vector<Object> agecodeArr = requestBox.getVector("agecodeArr");
			Vector<Object> ageunderArr = requestBox.getVector("ageunderArr");
			Vector<Object> ageaboveArr = requestBox.getVector("ageaboveArr");
			Vector<Object> loacodeArr = requestBox.getVector("loacodeArr");
			Vector<Object> diacodeArr = requestBox.getVector("diacodeArr");
			Vector<Object> customercodeArr = requestBox.getVector("customercodeArr");
			Vector<Object> consecutivecodeArr = requestBox.getVector("consecutivecodeArr");
			Vector<Object> businessstatuscodeArr = requestBox.getVector("businessstatuscodeArr");
			Vector<Object> targetcodeArr = requestBox.getVector("targetcodeArr");
			Vector<Object> targetmemberArr = requestBox.getVector("targetmemberArr");
			Vector<Object> startdateArr = requestBox.getVector("startdateArr");
			Vector<Object> enddateArr = requestBox.getVector("enddateArr");
			
			for( int i=0; i<conditiontypeArr.size(); i++ ) {
				Map<String,String> retMap = new HashMap<String,String>();
				
				retMap.put("conditiontype", conditiontypeArr.get(i).toString().replace("WNBC", ",").replace("WNB", ""));
				retMap.put("conditionseq", (i+1)+"");
				retMap.put("abotypecode", abotypecodeArr.get(i).toString().replace("WNBC", ",").replace("WNB", ""));
				retMap.put("abotypeabove", abotypeaboveArr.get(i).toString().replace("WNBC", ",").replace("WNB", ""));
				retMap.put("pincode", pincodeArr.get(i).toString().replace("WNBC", ",").replace("WNB", ""));
				retMap.put("pinunder", pinunderArr.get(i).toString().replace("WNBC", ",").replace("WNB", ""));
				retMap.put("pinabove", pinaboveArr.get(i).toString().replace("WNBC", ",").replace("WNB", ""));
				retMap.put("bonuscode", bonuscodeArr.get(i).toString().replace("WNBC", ",").replace("WNB", ""));
				retMap.put("bonusunder", bonusunderArr.get(i).toString().replace("WNBC", ",").replace("WNB", ""));
				retMap.put("bonusabove", bonusaboveArr.get(i).toString().replace("WNBC", ",").replace("WNB", ""));
				retMap.put("agecode", agecodeArr.get(i).toString().replace("WNBC", ",").replace("WNB", ""));
				retMap.put("ageunder", ageunderArr.get(i).toString().replace("WNBC", ",").replace("WNB", ""));
				retMap.put("ageabove", ageaboveArr.get(i).toString().replace("WNBC", ",").replace("WNB", ""));
				retMap.put("loacode", loacodeArr.get(i).toString().replace("WNBC", ",").replace("WNB", ""));
				retMap.put("diacode", diacodeArr.get(i).toString().replace("WNBC", ",").replace("WNB", ""));
				retMap.put("customercode", customercodeArr.get(i).toString().replace("WNBC", ",").replace("WNB", ""));
				retMap.put("consecutivecode", consecutivecodeArr.get(i).toString().replace("WNBC", ",").replace("WNB", ""));
				retMap.put("businessstatuscode", businessstatuscodeArr.get(i).toString().replace("WNBC", ",").replace("WNB", ""));
				retMap.put("targetcode", targetcodeArr.get(i).toString().replace("WNBC", ",").replace("WNB", ""));
				retMap.put("targetmember", targetmemberArr.get(i).toString().replace("WNBC", ",").replace("WNB", ""));
				retMap.put("startdate", startdateArr.get(i).toString().replace("WNBC", ",").replace("WNB", ""));
				retMap.put("enddate", enddateArr.get(i).toString().replace("WNBC", ",").replace("WNB", ""));
				
				conditionList.add(retMap);
			}
		} catch( ArrayIndexOutOfBoundsException e ) {
			conditionList = null;
		}
		
		return conditionList;
	}
}
