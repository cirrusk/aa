package amway.com.academy.mypage.service.impl;

import java.util.List;

import framework.com.cmm.lib.DataBox;
import framework.com.cmm.lib.RequestBox;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import amway.com.academy.mypage.service.MyPageMessageVO;
import amway.com.academy.mypage.service.MyPageService;

import javax.xml.crypto.Data;

@Service
public class MyPageServiceImpl implements MyPageService{
	@Autowired
	private MyPageMapper mypageMapper;

	@Override
	public List<MyPageMessageVO> selectMessageList(RequestBox requestBox) throws Exception {
		// TODO Auto-generated method stub
		return mypageMapper.selectMessageList(requestBox);
	}

	@Override
	public int selectMessageListCount(RequestBox requestBox) {
		// TODO Auto-generated method stub
		return mypageMapper.selectMessageListCount(requestBox);
	}

	@Override
	public DataBox checkList(RequestBox requestBox) throws Exception {
		return mypageMapper.checkList(requestBox);
	}

	@Override
	public DataBox checkListCount(RequestBox requestBox) throws Exception {
		return mypageMapper.checkListCount(requestBox);
	}

	@Override
	public List<MyPageMessageVO> selectMobileMessageList(MyPageMessageVO myPageMessageVO) throws Exception {
		return mypageMapper.selectMobileMessageList(myPageMessageVO);
	}

	@Override
	public int selectMobileMessageListCount(MyPageMessageVO myPageMessageVO) throws Exception {
		return mypageMapper.selectMobileMessageListCount(myPageMessageVO);
	}


}
