package amway.com.academy.manager.common.menu.service.impl;

import java.util.List;

import egovframework.rte.psl.dataaccess.mapper.Mapper;
import framework.com.cmm.lib.DataBox;
import framework.com.cmm.lib.RequestBox;

@Mapper
public interface MenuMapper {
	/**
	 * 메뉴 목록을 조회한다.(트리)
	 * @param RequestBox requestBox
	 * @return 메뉴 목록
	 * @exception Exception
	 */
	List<DataBox> selectMenuList(RequestBox requestBox) throws Exception;

	List<DataBox> selectMainMenuList(RequestBox requestBox) throws Exception;

	void insertMenu(RequestBox requestBox) throws Exception;

	int updateMenu(RequestBox requestBox) throws Exception;

	void deleteMenu(RequestBox requestBox) throws Exception;
}