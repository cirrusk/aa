package amway.com.academy.manager.reservation.basePlaza.service.impl;

import java.util.List;

import egovframework.rte.psl.dataaccess.mapper.Mapper;
import framework.com.cmm.lib.DataBox;
import framework.com.cmm.lib.RequestBox;

@Mapper
public interface BasePlazaMapper {

	public List<DataBox> basePlazaListAjax(RequestBox requestBox) throws Exception;
	
	public int basePlazaListCountAjax(RequestBox requestBox) throws Exception;

	public int basePlazaInsertAjax(RequestBox requestBox) throws Exception;

	public List<?> basePlazaRowChangeListAjax(RequestBox requestBox) throws Exception;

	public int basePlazaRowChangeUpdateAjax(RequestBox requestBox) throws Exception;

	public DataBox basePlazaDetailAjax(RequestBox requestBox) throws Exception;

	public int basePlazaUpdateAjax(RequestBox requestBox) throws Exception;

	public List<DataBox> basePlazaHistoryListAjax(RequestBox requestBox) throws Exception;

	public int basePlazaHistoryInsert(RequestBox requestBox) throws Exception;
}
