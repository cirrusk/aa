package amway.com.academy.mypage.service.impl;

import java.util.List;

import amway.com.academy.mypage.service.MyPageMessageVO;
import egovframework.rte.psl.dataaccess.mapper.Mapper;
import framework.com.cmm.lib.DataBox;
import framework.com.cmm.lib.RequestBox;

@Mapper
public interface MyPageMapper {

	List<MyPageMessageVO> selectMessageList(RequestBox requestBox) throws Exception;

	int selectMessageListCount(RequestBox requestBox);

	List<MyPageMessageVO> selectMobileMessageList(MyPageMessageVO myPageMessageVO) throws Exception;

	int selectMobileMessageListCount(MyPageMessageVO myPageMessageVO) throws Exception;

	DataBox checkList(RequestBox requestBox) throws Exception;

	DataBox checkListCount(RequestBox requestBox) throws Exception;
}
