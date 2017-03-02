package amway.com.academy.manager.common.systemCode.service;

import java.util.List;

import framework.com.cmm.lib.DataBox;
import framework.com.cmm.lib.RequestBox;

public interface SystemCodeService {

	/*public DataBox selectInfo(RequestBox requestBox) throws Exception;*/

	/**
	 * 코드관리 분류리스트
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	public List<DataBox> codeListScope(RequestBox requestBox) throws Exception;

	/**
	 * 코드관리 리스트 카운트
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	public int systemCodeListCount(RequestBox requestBox) throws Exception;

	/**
	 * 코드관리 리스트
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	public List<DataBox> systemCodeList(RequestBox requestBox) throws Exception;

	/**
	 * 코드관리 팝업
	 * @param requestBox
	 * @throws Exception
	 */
	public DataBox systemCodeListPop(RequestBox requestBox) throws Exception;

	/**
	 * 코드관리 등록
	 * @param requestBox
	 * @throws Exception
	 */
	public int systemCodeInsert(RequestBox requestBox) throws Exception;

	/**
	 * 코드관리 수정
	 * @param requestBox
	 * @throws Exception
	 */
	public int systemCodeUpdate(RequestBox requestBox) throws Exception;

	/**
	 * 코드관리 중복체크
	 * @param requestBox
	 * @throws Exception
	 */
	public int existyn(RequestBox requestBox) throws Exception;

	/**
	 * 코드관리 삭제
	 * @param requestBox
	 * @throws Exception
	 */
	public int systemCodeDelete(RequestBox requestBox) throws Exception;


	/**
	 * 코드상세 분류리스트
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	public DataBox codeListDetail(RequestBox requestBox) throws Exception;


	/**
	 * 코드상세 리스트
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	public List<DataBox> systemCodeDetail(RequestBox requestBox) throws Exception;

	/**
	 * 코드상세 팝업
	 * @param requestBox
	 * @throws Exception
	 */
	public DataBox systemCodeDetailPop(RequestBox requestBox) throws Exception;

	/**
	 * 코드상세 등록
	 * @param requestBox
	 * @throws Exception
	 */
	public int systemCodeDetailInsert(RequestBox requestBox) throws Exception;

	/**
	 * 코드상세 수정
	 * @param requestBox
	 * @throws Exception
	 */
	public int systemCodeDetailUpdate(RequestBox requestBox) throws  Exception;

	/**
	 * 코드상세 삭제
	 * @param requestBox
	 * @throws Exception
	 */
	public int systemCodeDetailDelete(RequestBox requestBox) throws Exception;

	/**
	 * 코드상세 순서정렬
	 * @param requestBox
	 * @throws Exception
	 */
	public int systemCodeDetailOrder(RequestBox requestBox) throws  Exception;


}
