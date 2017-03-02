package amway.com.academy.manager.common.searchabo.service;

import java.util.List;
import java.util.Map;

import framework.com.cmm.lib.DataBox;
import framework.com.cmm.lib.RequestBox;

public interface SearchAboService {
	
	/**
	 * abo검색 카운트
	 * @param requestBox
	 * @return
	 */
	public Map<String, Object> selectAboData(RequestBox requestBox);

	/**
	 * 검색조건 입력 값 존재 여부 체크
	 * @param requestBox
	 * @return
	 */
	public int selectAboDataCount(RequestBox requestBox);

	/**
	 * 검색 리스트 count
	 * @param requestBox
	 * @return
	 */
	public int selectAboListCount(RequestBox requestBox);

	/**
	 * 검색 리스트
	 * @param requestBox
	 * @return
	 */
	public List<DataBox> selectAboList(RequestBox requestBox);
	
}
