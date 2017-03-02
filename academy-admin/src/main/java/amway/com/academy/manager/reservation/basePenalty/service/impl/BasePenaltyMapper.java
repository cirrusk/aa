package amway.com.academy.manager.reservation.basePenalty.service.impl;

import java.util.List;

import egovframework.rte.psl.dataaccess.mapper.Mapper;
import framework.com.cmm.lib.DataBox;
import framework.com.cmm.lib.RequestBox;

@Mapper
public interface BasePenaltyMapper {

	public List<DataBox> basePenaltyListAjax(RequestBox requestBox) throws Exception;
	
	public int basePenaltyListCountAjax(RequestBox requestBox) throws Exception;

	public int basePenaltyCencelInsertAjax(RequestBox requestBox) throws Exception;

	public DataBox basePenaltyDetailAjax(RequestBox requestBox) throws Exception;

	public int basePenaltyUpdateAjax(RequestBox requestBox) throws Exception;
}
