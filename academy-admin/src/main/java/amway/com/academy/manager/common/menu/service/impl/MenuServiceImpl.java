package amway.com.academy.manager.common.menu.service.impl;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import amway.com.academy.manager.common.menu.service.MenuService;
import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import framework.com.cmm.lib.DataBox;
import framework.com.cmm.lib.RequestBox;

@Service
public class MenuServiceImpl extends EgovAbstractServiceImpl implements MenuService {
	@Autowired
	private MenuMapper menuDAO;
	
	/**
	 * 메뉴 목록을 조회한다.(트리)
	 * @param RequestBox requestBox
	 * @return 메뉴 목록
	 * @exception Exception
	 */
	@Override
	public List<DataBox> selectMenuList(RequestBox requestBox) throws Exception {
		return menuDAO.selectMenuList(requestBox);
	}

	@Override
	public List<DataBox> selectMainMenuList(RequestBox requestBox) throws Exception {
		return menuDAO.selectMainMenuList(requestBox);
	}

	@Override
	public void insertMenu(RequestBox requestBox) throws Exception {
		menuDAO.insertMenu(requestBox);
	}

	@Override
	public int updateMenu(RequestBox requestBox) throws Exception{
		return  menuDAO.updateMenu(requestBox);
	}

	@Override
	public void deleteMenu(RequestBox requestBox) throws Exception{
		menuDAO.deleteMenu(requestBox);
	}


}