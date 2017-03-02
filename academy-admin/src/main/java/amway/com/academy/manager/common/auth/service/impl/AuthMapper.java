package amway.com.academy.manager.common.auth.service.impl;

import java.util.List;

import egovframework.rte.psl.dataaccess.mapper.Mapper;
import framework.com.cmm.lib.DataBox;
import framework.com.cmm.lib.RequestBox;

@Mapper
public interface AuthMapper {
	/**
	 * 관리자 권한 그룹 목록을 조회한다.
	 * @param RequestBox requestBox
	 * @return 메뉴 목록
	 * @exception Exception
	 */
	List<DataBox> selectAuthGroupList(RequestBox requestBox) throws Exception;
	
	/**
	 * 관리자 권한 그룹 목록의 TotalCount를 조회한다.
	 * @param RequestBox requestBox
	 * @return 메뉴 목록
	 * @exception Exception
	 */
	int selectAuthGroupListTotalCount(RequestBox requestBox) throws Exception;
	
	/**
	 * //Pop 리스트
	 * @param requestBox
	 * @return List
	 */
	List<DataBox> authGroupListPopAjax(RequestBox requestBox) throws Exception;
	
	/**
	 * //Pop 리스트 카운트
	 * @param requestBox
	 * @return int
	 */
	int authGroupListPopCount(RequestBox requestBox) throws Exception;
	
	/**
	 * //popUp 수정
	 * @param requestBox
	 * @return int
	 * @throws Exception
	 */
	int authGroupListPopUpdateAjax(RequestBox requestBox) throws Exception;
	
	/**
	 * selectPpList
	 * @return List
	 */
	List<DataBox> selectPpList() throws Exception;
	
	/**
	 * //메뉴 리스트 불러오기
	 * @param requestBox
	 * @return List
	 */
	List<DataBox> authGroupListRightDivAjax(RequestBox requestBox) throws Exception;
	
	/**
	 * //오른쪽 DIv 정보
	 * @param requestBox
	 * @return
	 */
	DataBox authGroupListManagerInfo(RequestBox requestBox) throws Exception;
	
	/**
	 * ad계정 중복 체크
	 * @param requestBox
	 * @return String
	 */
	String authGroupListPopCheckAdno(RequestBox requestBox) throws Exception;
	
	/**
	 * //popUp 운영자 개별 등록
	 * @param requestBox
	 * @return int
	 */
	int authGroupListPopInsertAjax(RequestBox requestBox) throws Exception;

	/**
	 * //운영자 로그 등록
	 * @param requestBox
	 * @return int
	 */
	int userLogInsert(RequestBox requestBox) throws Exception;

	/**
	 * //ppseq가 존재하는지 확인하기
	 * @param requestBox
	 * @return String
	 */
	String ppseqExistCheck(RequestBox requestBox) throws Exception;
	
	/**
	 * //EXCEL로 운영자 등록
	 * @param requestBox
	 */
	void authGroupListPopExcelUploadAjax(RequestBox requestBox) throws Exception;
	
	/**
	 * //메뉴 권한 설정
	 * @param requestBox
	 */
	void authGroupListMenuAuthInsert(RequestBox requestBox) throws Exception;

	/**
	 * //메뉴 권한 설정
	 * @param requestBox
	 */
	void authGroupListMenuAuthUpdate(RequestBox requestBox) throws Exception;
	/**
	 * //메뉴권한 초기화
	 * @param requestBox
	 */
	void authLogInsert(RequestBox requestBox) throws Exception;

	/**
	 * //메뉴권한 초기화
	 * @param requestBox
	 */
	int authGroupListMenuAuthDelete(RequestBox requestBox) throws Exception;

	/**
	 * 운영자 삭제
	 * @param requestBox
	 * @return int
	 */
	int authGroupListManagerDeleteAjax(RequestBox requestBox) throws Exception;
}