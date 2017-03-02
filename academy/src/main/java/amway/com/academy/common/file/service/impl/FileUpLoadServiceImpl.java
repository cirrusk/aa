package amway.com.academy.common.file.service.impl;

import java.io.File;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.ui.ModelMap;
import org.springframework.web.multipart.MultipartFile;

import amway.com.academy.common.file.service.FileUpLoadService;
import egovframework.com.cmm.EgovWebUtil;
import egovframework.com.utl.fcc.service.EgovStringUtil;
import framework.com.cmm.lib.RequestBox;
import framework.com.cmm.util.StringUtil;

@Service
public class FileUpLoadServiceImpl implements FileUpLoadService{
	@Autowired
	private FileUpLoadMapper fileUpLoadDAO;
	
	/** log */
	private static final Logger LOGGER = LoggerFactory.getLogger(FileUpLoadServiceImpl.class);
	final static  String FILE_SEPARATOR = System.getProperty("file.separator");
	
	/**
	 * @DESC  : File Management Insert method - DB insert <br/>
	 * @param Map<String, Object>
	 * @return Map<String, Object>
	 * @throws Exception
	 */
	@Override
	public Map<String, Object> getInsertFile(Map<String, MultipartFile> files, RequestBox requestBox)	throws Exception {

		Calendar c = Calendar.getInstance();
		Map<String,String> inf = new HashMap<String,String>();
		Map<String,Object> rtn = new HashMap<String,Object>();

		// File 저장 경로
		String uploadPathMain = StringUtil.uploadPath()+"/TRFEE/";
		String uploadPath     = (uploadPathMain + c.get(Calendar.YEAR) + "/").replace("/", FILE_SEPARATOR);
		String userId         = requestBox.getSession("abono");
		String work           = requestBox.get("work"); // 업무구분
		String sFileName      = "";
		
		inf.put("storeFullPath", uploadPath);
		inf.put("work", work);
		inf.put("userId", userId);
		
		int fileKey = 0;
		int i = 0;
		boolean chk = false;
		
		// upload file 이 존재하면
		if (!files.isEmpty()) {

			// 파일 저장 후 정보를  records 로 받는다
			List<Map<String,Object>> records = parseFileInf(files, inf);
			Iterator<Map<String, Object>> itr = records.iterator();
			
			if( requestBox.get("fileKey") != null && !"".equals( requestBox.get("fileKey") )){
                fileKey = Integer.parseInt( requestBox.get("fileKey") );
            }else{
                // FileKey Select
            	fileKey = this.fileUpLoadDAO.selectFileKey(requestBox);
                requestBox.put("fileKey", "" + fileKey);
            }
			
		    while (itr.hasNext()) {
			    Map<String, Object> entry = itr.next();
                
                if("Y".equals((String)requestBox.get("others"))){
                	fileKey = this.fileUpLoadDAO.selectFileKey(requestBox);
                	requestBox.put("fileKey", "" + fileKey);
                    entry.put("uploadSeq", "" + 0); 
                } else {
                	entry.put("uploadSeq", ""+i);
                }

			    // FileSeq Select
			    entry.put("grpCd", work);
			    entry.put("fileKey", ""+ fileKey);
			    entry.put("fileFullUrl", uploadPath);
			    entry.put("userId", userId); 

				rtn.put("fileInputName_" + i, "" + entry.get("inputNm"));
				rtn.put("fileKey_" + i, "" + fileKey);
				rtn.put("realFileNm_" + i, records.get(0).get("realFileNm"));
				
			    // 파일 정보 DB저장
			    this.fileUpLoadDAO.insertFile(entry);
			    i += 1;
		    }
		    
		    if(i > 0 && i == records.size()){
			    sFileName = (String) records.get(0).get("realFileNm") ;
		    	chk = true;		// File Upload 성공
		    }
		    else{
		    	chk = false;	// File Upload 실패
		    	fileKey = 0;
		    }

		    rtn.put("realFileNm", sFileName);
		    rtn.put("fileKey", ""+fileKey);
	        rtn.put("chk", chk);
		}
		
		/*
		 * Controller return value
		 * put : fileKey
		 * put : chk - 파일 업로드 성공여부
		 */
		return rtn;
	}

	/**
	 * @DESC  : File Upload -file save <br/>
	 *          getInsertFile Method Call
	 * @param Map<String, MultipartFile> files, String storeFullPath
	 * @return List<Map<String,Object>>
	 * @throws Exception
	 */
	  public List<Map<String,Object>> parseFileInf(Map<String, MultipartFile> files, Map<String,String> inf)
	    throws Exception
	  {
		String orginFileName = "";
		String inputNm = "";
	    int i = 0;
	    
	    LOGGER.info(" =============================== inf.get('storeFullPath') ############### " + inf.get("storeFullPath"));
	    File saveFolder = new File(EgovWebUtil.filePathBlackList(inf.get("storeFullPath")));
	    if ((!saveFolder.exists()) || (saveFolder.isFile())) {
	    	LOGGER.info(" =============================== make foler ############### " + saveFolder.toString());
	      saveFolder.mkdirs();
	    }
	    
	    Iterator<Map.Entry<String, MultipartFile>> itr = files.entrySet().iterator();
	    
	    String filePath = "";
	    List<Map<String,Object>> result = new ArrayList<Map<String,Object>>();

	    while (itr.hasNext())
	    {
	      Map.Entry<String, MultipartFile> entry = itr.next();
	      MultipartFile file = entry.getValue();
	      orginFileName = file.getOriginalFilename();
	      inputNm = file.getName();
	      
	      // file name 존재하면 파일 생성
	      if (!orginFileName.equals(""))
	      {
	        int index = orginFileName.lastIndexOf(".");
	        
	        String fileExt = orginFileName.substring(index + 1);
	        i++;

	        String newName = EgovStringUtil.getTimeStamp() + i +  "." + fileExt;

	        if("myProfile".equals(inf.get("work"))) {
	        	newName = inf.get("userId");// + "." + fileExt;
	        }

	        if (!orginFileName.equals(""))
	        {
	          filePath = inf.get("storeFullPath") + newName;
	          file.transferTo(new File(EgovWebUtil.filePathBlackList(filePath)));
	        }

	        // file 정보 return
	        Map<String,Object> fvo = new HashMap<String,Object>();

	        fvo.put("inputNm", inputNm);
	        fvo.put("realFileNm",orginFileName);
	        fvo.put("streFileNm",newName);
	        fvo.put("fileExt",fileExt);

	        result.add(fvo);
	      }
	    }
	    return result;
	  }

	  

	/**
	 * 교육비 지출 증빙 항목별 파일업로드 컨트롤
	 * @param files
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	public Map<String, Object> getInsertTrFeeSpendFile(Map<String, MultipartFile> files, RequestBox requestBox) throws Exception {
		Calendar c = Calendar.getInstance();
		Map<String,String> inf = new HashMap<String,String>();
		Map<String,Object> rtn = new HashMap<String,Object>();
		
		// File 저장 경로
		String uploadPathMain = StringUtil.uploadPath()+"/TRFEE/";
		String uploadPath     = (uploadPathMain + c.get(Calendar.YEAR) + "/").replace("/", FILE_SEPARATOR);
		String work           = requestBox.get("work"); // 업무구분
		String sFileName      = "";
		String rFileKey       = "";
		StringBuffer rFileBuffer = new StringBuffer();
		
		inf.put("storeFullPath", uploadPath);

		int fileKey = 0;
		int i = 0;
		boolean chk = false;
		
		// upload file 이 존재하면
		if (!files.isEmpty()) {
				// 파일 저장 후 정보를  records 로 받는다
				List<Map<String,Object>> records = parseFileInf(files, inf);
				
				Iterator<Map<String, Object>> itr = records.iterator();
				
			    while (itr.hasNext()) {
			    	// FileKey Select
	                fileKey = this.fileUpLoadDAO.selectFileKey(requestBox);
	                
	                if(i==0){
	                	rFileBuffer.append("" + fileKey);
	                } else {
	                	rFileBuffer.append("," + fileKey);
	                }
	                
				    Map<String, Object> entry = itr.next();
	                
				    // 업로드 파일은 무조건 하나씩
				    entry.put("uploadSeq", "" + 0);
				    	
				    // FileSeq Select
				    entry.put("grpCd", work);
				    entry.put("fileKey", ""+ fileKey);
				    entry.put("fileFullUrl", uploadPath);
				    entry.put("userId", inf.get("userId"));
	
					rtn.put("fileInputName_" + i, "" + entry.get("inputNm"));
					rtn.put("fileKey_" + i, "" + fileKey);
					rtn.put("realFileNm_" + i, records.get(0).get("realFileNm"));
					
				    // 파일 정보 DB저장
				    this.fileUpLoadDAO.insertFile(entry);
				    i += 1; 
			    }
			    
			    if(i > 0 && i == records.size()){
				    sFileName = (String) records.get(0).get("realFileNm") ;
			    	chk = true;		// File Upload 성공
			    }
			    else{
			    	chk = false;	// File Upload 실패
			    	fileKey = 0;
			    }
	
			    rtn.put("realFileNm", sFileName);
		        rtn.put("chk", chk);
			}
			rFileKey = rFileBuffer.toString();
			rtn.put("fileKey", rFileKey);
		/*
		 * Controller return value
		 * put : fileKey
		 * put : chk - 파일 업로드 성공여부
		 */
		return rtn;
	}
	
	public String getInsertTrFeeSpendFileKey(Map<String, MultipartFile> files, RequestBox requestBox) throws Exception {
		Calendar c = Calendar.getInstance();
		Map<String,String> inf = new HashMap<String,String>();
		Map<String,Object> rtn = new HashMap<String,Object>();
		
		// File 저장 경로
		String uploadPathMain = StringUtil.uploadPath()+"/TRFEE/";
		String uploadPath     = (uploadPathMain + c.get(Calendar.YEAR) + "/").replace("/", FILE_SEPARATOR);
		String work           = requestBox.get("work"); // 업무구분
		String sFileName      = "";
		String rFileKey       = "";
		StringBuffer rFileBuffer = new StringBuffer();
		
		inf.put("storeFullPath", uploadPath);
		
		int fileKey = 0;
		int i = 0;
		boolean chk = false;
		
		// upload file 이 존재하면
		if (!files.isEmpty()) {
			// 파일 저장 후 정보를  records 로 받는다
			List<Map<String,Object>> records = parseFileInf(files, inf);
			
			Iterator<Map<String, Object>> itr = records.iterator();
			
			while (itr.hasNext()) {
				// FileKey Select
				if( "".equals(requestBox.get("filekey")) ) {
					fileKey = this.fileUpLoadDAO.selectFileKey(requestBox);
				} else {
					fileKey = Integer.parseInt(requestBox.get("filekey"));
				}
				
				if(i==0){
					rFileBuffer.append("" + fileKey);
				} else {
					rFileBuffer.append("," + fileKey);
				}
				
				Map<String, Object> entry = itr.next();
				
				// 업로드 파일은 무조건 하나씩
				entry.put("uploadSeq", "" + 0);
				
				// FileSeq Select
				entry.put("grpCd", work);
				entry.put("fileKey", ""+ fileKey);
				entry.put("fileFullUrl", uploadPath);
				entry.put("userId", requestBox.get("userId"));
				
				rtn.put("fileInputName_" + i, "" + entry.get("inputNm"));
				rtn.put("fileKey_" + i, "" + fileKey);
				rtn.put("realFileNm_" + i, records.get(0).get("realFileNm"));
				
				// 파일 정보 DB저장
				this.fileUpLoadDAO.insertFile(entry);
				i += 1;
			}
			
			if(i > 0 && i == records.size()){
				sFileName = (String) records.get(0).get("realFileNm") ;
				chk = true;		// File Upload 성공
			}
			else{
				chk = false;	// File Upload 실패
				fileKey = 0;
			}
			
			rtn.put("realFileNm", sFileName);
			rtn.put("chk", chk);
		}
		rFileKey = rFileBuffer.toString();
		rtn.put("fileKey", rFileKey);
		/*
		 * Controller return value
		 * put : fileKey
		 * put : chk - 파일 업로드 성공여부
		 */
		return rFileKey;
	}

	@Override
	public Map<String, Object> getSelectFileDetail(ModelMap model) throws SQLException {
		return this.fileUpLoadDAO.selectFileDetail(model);
	}

	@Override
	public Map<String, Object> getSelectFileDetailByFileName(ModelMap model) throws SQLException {
		return this.fileUpLoadDAO.selectFileDetailByFileName(model);
	}
	
	@Override
	public String selectFileKey(RequestBox requestBox) {
		int fileKey = 0;
		String sfileKey = "";
		fileKey = this.fileUpLoadDAO.selectFileKey(requestBox);
		sfileKey = fileKey + "";
		
		return sfileKey;
	}

}
