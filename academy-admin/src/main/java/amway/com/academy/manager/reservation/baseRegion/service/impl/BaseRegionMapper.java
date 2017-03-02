package amway.com.academy.manager.reservation.baseRegion.service.impl;

import java.util.List;

import egovframework.rte.psl.dataaccess.mapper.Mapper;
import framework.com.cmm.lib.DataBox;
import framework.com.cmm.lib.RequestBox;

@Mapper
public interface BaseRegionMapper {

	public List<DataBox> reservationRegionList(RequestBox requestBox) throws Exception;
	
	public int reservationRegionListCount(RequestBox requestBox) throws Exception;
	
	public List<DataBox> cityGroupDetailList(RequestBox requestBox) throws Exception;
	
	public int cityGroupDetailListCount(RequestBox requestBox) throws Exception;
	
	public DataBox cityGroupDetail(RequestBox requestBox) throws Exception;
	
	
	public int cityGroupMasterInsert(RequestBox requestBox) throws Exception;
	
	public int cityGroupMasterUpdate(RequestBox requestBox) throws Exception;
	
	public int cityGroupDelete(RequestBox requestBox) throws Exception;
	
	public int cityGroupInsert(RequestBox requestBox) throws Exception;
	
	
	public List<DataBox> allCityCodeList(RequestBox requestBox) throws Exception;

	public int deleteRegion(RequestBox requestBox) throws Exception;
	
}
