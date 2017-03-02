package amway.com.academy.manager.reservation.baseRegion.service;

import java.util.List;

import framework.com.cmm.lib.DataBox;
import framework.com.cmm.lib.RequestBox;

public interface BaseRegionService {
	
	/**
	 * 지역군 정보 목록 조회
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	public List<DataBox> reservationRegionList(RequestBox requestBox) throws Exception;
	
	/**
	 * 조회건수 취득 기능
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	public int reservationRegionListCount(RequestBox requestBox) throws Exception;
	
	/**
	 * 지역군에 포함된 도시 목록 조회
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	public List<DataBox> cityGroupDetailList(RequestBox requestBox) throws Exception;
	
	/**
	 * 지역군에 포함된 도시 목록건수 취득
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	public int cityGroupDetailListCount(RequestBox requestBox) throws Exception;
	
	/**
	 * 단건 조회
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	public DataBox cityGroupDetail(RequestBox requestBox) throws Exception;
	
	/**
	 * [기준정보] 행정구역내 도시들의 목록을 받아오는 기능
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	public List<DataBox> allCityCodeList(RequestBox requestBox) throws Exception;

	/**
	 * 지역군 팝업에서 지역군 정보 신규로 등록
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	public int cityGroupInsert(RequestBox requestBox) throws Exception;
	
	/**
	 * 지역군 팝업에서 지역군 정보 수정&추가 기능
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	public int cityGroupUpdate(RequestBox requestBox) throws Exception;

	/**
	 * 지역군 삭제
	 * @param requestBox
	 * @throws Exception
	 */
	public int deleteRegion(RequestBox requestBox) throws Exception;
	

}
