package amway.com.academy.manager.trainingFee.agree.service;

import java.sql.SQLException;
import java.util.List;

import framework.com.cmm.lib.DataBox;
import framework.com.cmm.lib.RequestBox;

public interface TrainingFeeWrittenService {
	
	/**
	 * 교육비 약관문서관리 - 교육시서약서 조회 count
	 * @param requestBox
	 * @return
	 */
	public int selectWrittenListCount(RequestBox requestBox);
	
	/**
	 * 교육비 약관문서관리 - 교육시서약서 조회
	 * @param requestBox
	 * @return
	 */
	public List<DataBox> selectWrittenList(RequestBox requestBox) throws Exception;
	
	public DataBox selectWrittenData(RequestBox requestBox) throws Exception;

	public int saveWrittenEdit(RequestBox requestBox) throws SQLException;
	
	
}