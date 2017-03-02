package amway.com.academy.common.file.service;

import java.sql.SQLException;
import java.util.Map;

import org.springframework.ui.ModelMap;
import org.springframework.web.multipart.MultipartFile;

import framework.com.cmm.lib.RequestBox;

public interface FileUpLoadService {
	
	/**
	 * 
	 * @DESC  : File Management Insert method
	 *
	 * @return Map<String, Object>
	 * @throws Exception
	 */
	public Map<String, Object> getInsertFile(Map<String, MultipartFile> files, RequestBox requestBox) throws Exception;
	
	/**
	 * 교육비 지출 증빙 항목별 파일업로드 컨트롤
	 * @param files
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	public Map<String, Object> getInsertTrFeeSpendFile(Map<String, MultipartFile> files, RequestBox requestBox) throws Exception;
	
	public String getInsertTrFeeSpendFileKey(Map<String, MultipartFile> files, RequestBox requestBox) throws Exception;

	public Map<String, Object> getSelectFileDetail(ModelMap model) throws SQLException;
	
	public Map<String, Object> getSelectFileDetailByFileName(ModelMap model) throws SQLException;

	/**
	 * filekey 생성
	 * @return
	 */
	public String selectFileKey(RequestBox requestBox);
	
}
