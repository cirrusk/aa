package amway.com.academy.mypage.service;

import framework.com.cmm.lib.DataBox;
import framework.com.cmm.lib.RequestBox;

import java.util.List;

public interface MyPageService {
	
	/**
	 * 마이페이지 - 맞춤메세지
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	public List<MyPageMessageVO> selectMessageList(RequestBox requestBox) throws Exception;

	/**
	 * 마이페이지 - 맞춤메세지 count
	 * @param requestBox
	 * @return
	 */
	public int selectMessageListCount(RequestBox requestBox);

	/**
	 * 마이페이지 - 맞춤메세지 ABONO로 쪽지여부확인
	 * @param requestBox
	 * @return
	 */
	public DataBox checkList(RequestBox requestBox) throws Exception;

	public DataBox checkListCount(RequestBox requestBox) throws Exception;
	/**
	 * 마이페이지 - 모바일 맞춤메세지 리스트
	 * @param requestBox
	 * @return
	 */
	public List<MyPageMessageVO> selectMobileMessageList(MyPageMessageVO myPageMessageVO) throws Exception;

	/**
	 * 마이페이지 - 모바일 맞춤메세지 카운트
	 * @param requestBox
	 * @return
	 */
	public int selectMobileMessageListCount(MyPageMessageVO myPageMessageVO) throws Exception;

}
