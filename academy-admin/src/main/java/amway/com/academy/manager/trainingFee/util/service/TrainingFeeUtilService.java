package amway.com.academy.manager.trainingFee.util.service;

import java.util.List;

import framework.com.cmm.lib.DataBox;
import framework.com.cmm.lib.RequestBox;

public interface TrainingFeeUtilService {
	
	/**
	 * SMS발송이력 COUNT
	 * @param requestBox
	 * @return
	 */
	public int selectSMSLogListCount(RequestBox requestBox);

	/**
	 * SMS발송이력
	 * @param requestBox
	 * @return
	 */
	public List<DataBox> selectSMSLogList(RequestBox requestBox);
	
	/**
	 * 시스템로그 COUNT
	 * @param requestBox
	 * @return
	 */
	public int selectSystemLogListCount(RequestBox requestBox);

	/**
	 * 시스템로그
	 * @param requestBox
	 * @return
	 */
	public List<DataBox> selectSystemLogList(RequestBox requestBox);
	
}