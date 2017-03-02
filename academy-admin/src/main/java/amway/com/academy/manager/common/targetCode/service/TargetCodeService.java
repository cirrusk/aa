package amway.com.academy.manager.common.targetCode.service;

import framework.com.cmm.lib.DataBox;
import framework.com.cmm.lib.RequestBox;

import java.util.List;

public interface TargetCodeService {

	/**
	 * 대상자코드 호출 셀렉트박스 값셋팅
	 * @param requestBox
	 * @throws Exception
	 */
	public List<DataBox> codeListScope(RequestBox requestBox) throws Exception;

	/**
	 * 대상자코드 카운트
	 * @param requestBox
	 * @throws Exception
	 */
	public int targetCodeListCount(RequestBox requestBox)throws Exception;

	/**
	 * 대상자코드 리스트
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	public List<DataBox> targetCodeList(RequestBox requestBox)throws Exception;

	/**
	 * 대상자코드 팝업
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	public DataBox targetCodeListPop(RequestBox requestBox) throws Exception;

	/**
	 * 대상자코드 등록
	 * @param requestBox
	 * @throws Exception
	 */
	public int targetCodeInsert(RequestBox requestBox) throws Exception;

	/**
	 * 대상자코드 수정
	 * @param requestBox
	 * @throws Exception
	 */
	public int targetCodeUpdate(RequestBox requestBox) throws Exception;

	/**
	 * 대상자코드 하위코드체크
	 * @param requestBox
	 * @throws Exception
	 */
	public int existyn(RequestBox requestBox) throws Exception;

	/**
	 * 대상자코드 삭제
	 * @param requestBox
	 * @throws Exception
	 */
	public int targetCodeDelete(RequestBox requestBox) throws Exception;

	/**
	 * 대상자코드상세 페이지호출
	 * @param requestBox
	 * @throws Exception
	 */
	public DataBox targetCodeDetail(RequestBox requestBox) throws Exception;


	/**
	 * 대상자코드상세 리스트
	 * @param requestBox
	 * @throws Exception
	 */
	public List<DataBox> targetCodeDetailList(RequestBox requestBox) throws Exception;

	/**
	 * 대상자코드상세 팝업
	 * @param requestBox
	 * @throws Exception
	 */
	public DataBox targetCodeDetailPop(RequestBox requestBox) throws Exception;

	/**
	 * 대상자코드상세 등록
	 * @param requestBox
	 * @throws Exception
	 */
	public int targetCodeDetailInsert(RequestBox requestBox) throws Exception;

	/**
	 * 대상자코드상세 수정
	 * @param requestBox
	 * @throws Exception
	 */
	public int targetCodeDetailUpdate(RequestBox requestBox) throws Exception;

	/**
	 * 대상자코드상세 삭제
	 * @param requestBox
	 * @throws Exception
	 */
	public int targetCodeDetailDelete(RequestBox requestBox) throws Exception;

	/**
	 * 대상자코드상세 순번
	 * @param requestBox
	 * @throws Exception
	 */
	public int targetCodeDetailOrder(RequestBox requestBox) throws Exception;

}
