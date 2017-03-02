package amway.com.academy.manager.trainingFee.trainingFeeCommon.service;

import java.util.List;
import java.util.Map;

import framework.com.cmm.lib.DataBox;
import framework.com.cmm.lib.RequestBox;

public interface TrainingFeeCommonService {
	public Map<String, Object> selectTargetInfoList(RequestBox requestBox) throws Exception;
	
	/**
	 * 검색조건 BR
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	public List<DataBox> selectBRList(RequestBox requestBox) throws Exception;
	
	/**
	 * 검색조건 운영그룹
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	public List<DataBox> selectGrpCdList(RequestBox requestBox) throws Exception;
	
	/**
	 * 검색조건 Code
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	public List<DataBox> selectCodeList(RequestBox requestBox) throws Exception;
	
	/**
	 * 검색조건 LOA
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	public List<DataBox> selectLOAList(RequestBox requestBox) throws Exception;
	
	/**
	 * 검색조건 Dept
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	public List<DataBox> selectDeptList(RequestBox requestBox) throws Exception;

	/**
	 * 검색조건 C.Pin
	 * @param requestBox
	 * @return
	 */
	public List<DataBox> selectCPinList(RequestBox requestBox);

	
}