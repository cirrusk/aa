package amway.com.academy.manager.common.targetUpload.service;

import framework.com.cmm.lib.DataBox;
import framework.com.cmm.lib.RequestBox;

import javax.xml.crypto.Data;
import java.util.List;
import java.util.Map;

public interface TargetUploadService {

	/**
	 * 대상자일괄 업로드 카운트
	 * @param requestBox
	 * @throws Exception
	 */
	public int targetUploadListCount(RequestBox requestBox) throws Exception;

	/**
	 * 대상자일괄 업로드 리스트
	 * @param requestBox
	 * @throws Exception
	 */
	public List<DataBox> targetUploadList(RequestBox requestBox) throws Exception;

	/**
	 * 대상자일괄 업로드 디테일팝업 리스트호출
	 * @param requestBox
	 * @throws Exception
	 */
	public DataBox targetUploadDetailPop(RequestBox requestBox) throws Exception;

	/**
	 * 대상자일괄 등록인원 조회
	 * @param requestBox
	 * @throws Exception
	 */
	public List<DataBox> targetUploadListCntPop(RequestBox requestBox) throws Exception;

	/**
	 * 대상자일괄 업로드 디테일카운트
	 * @param requestBox
	 * @throws Exception
	 */
	public int targetUploadListCntPopCount(RequestBox requestBox) throws Exception;

	/**
	 * 대상자일괄 업로드 등록
	 * @param requestBox
	 * @throws Exception
	 */
	public int targeterUploadInsert(RequestBox requestBox) throws Exception;

	/**
	 * 대상자일괄 업로드 삭제(rsvrolegroup)
	 * @param requestBox
	 * @throws Exception
	 */
	public int targetUploadDelete(RequestBox requestBox) throws  Exception;

	/**
	 * 대상자일괄 업로드 삭제(rsvrolegroup)
	 * @param requestBox
	 * @throws Exception
	 */
	public int targetUploadDetailDelete(RequestBox requestBox) throws  Exception;

	/**
	 * 대상자일괄 업로드 삭제(rsvroletarget)
	 * @param requestBox
	 * @throws Exception
	 */
	public int targetUploadDelseq(RequestBox requestBox) throws Exception;

	/**
	 * 대상자 일괄 엑셀 업로드
	 * @param params
	 * @return
	 * @throws Exception
	 */
	public int insertExcelData(Map<String, Object> params) throws Exception;

	/**
	 * 대상자 일괄 엑셀 업로드 - 유효성체크
	 * @param
	 * @return
	 * @throws Exception
	 */
	String[][] validExcel(String[][] importData, RequestBox requestBox);
}
