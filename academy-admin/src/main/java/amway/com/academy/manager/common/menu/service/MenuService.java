package amway.com.academy.manager.common.menu.service;

import java.util.List;

import framework.com.cmm.lib.DataBox;
import framework.com.cmm.lib.RequestBox;

public interface MenuService {
	public List<DataBox> selectMenuList(RequestBox requestBox) throws Exception;

	public List<DataBox> selectMainMenuList(RequestBox requestBox) throws Exception;

	public void insertMenu(RequestBox requestBox) throws Exception;

	public int updateMenu(RequestBox requestBox) throws Exception;

	public void deleteMenu(RequestBox requestBox) throws Exception;
}