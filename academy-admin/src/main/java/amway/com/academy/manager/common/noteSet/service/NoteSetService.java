package amway.com.academy.manager.common.noteSet.service;

import framework.com.cmm.lib.DataBox;
import framework.com.cmm.lib.RequestBox;

import java.util.List;

public interface NoteSetService {

	/*public DataBox selectInfo(RequestBox requestBox) throws Exception;*/

	/**
	 * 쪽지설정 리스트 카운트
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	public int noteSetListCount(RequestBox requestBox) throws Exception;

	/**
	 * 쪽지설정 리스트
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	public List<DataBox> noteSetList(RequestBox requestBox) throws Exception;

	/**
	 * 쪽지설정 팝업
	 * @param requestBox
	 * @throws Exception
	 */
	public DataBox noteSetPop(RequestBox requestBox) throws Exception;

	/**
	 * 쪽지설정 등록
	 * @param requestBox
	 * @throws Exception
	 */
	public int noteSetInsert(RequestBox requestBox) throws Exception;

	/**
	 * 쪽지설정 수정
	 * @param requestBox
	 * @throws Exception
	 */
	public int noteSetUpdate(RequestBox requestBox) throws Exception;

	/**
	 * 쪽지설정 삭제
	 * @param requestBox
	 * @throws Exception
	 */
	public void noteSetDelete(RequestBox requestBox) throws Exception;

}
