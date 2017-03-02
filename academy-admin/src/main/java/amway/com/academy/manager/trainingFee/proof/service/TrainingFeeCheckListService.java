package amway.com.academy.manager.trainingFee.proof.service;

import java.sql.SQLException;
import java.util.List;

import framework.com.cmm.lib.DataBox;
import framework.com.cmm.lib.RequestBox;

public interface TrainingFeeCheckListService {
	/**
	 * 교육비 체크리스트 count
	 * @param requestBox
	 * @return
	 */
	public int selectTrainingFeeCheckListCount(RequestBox requestBox);
	
	/**
	 * 교육비 체크리스트
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	public List<DataBox> selectTrainingFeeCheckList(RequestBox requestBox) throws Exception;

	/**
	 * as400업로드 처리 여부
	 * @param requestBox
	 * @return
	 */
	public int updateAs400UploadFalg(RequestBox requestBox) throws SQLException;
		
}