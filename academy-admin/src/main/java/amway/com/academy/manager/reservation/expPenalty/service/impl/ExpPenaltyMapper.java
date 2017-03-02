package amway.com.academy.manager.reservation.expPenalty.service.impl;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.mapper.Mapper;
import framework.com.cmm.lib.DataBox;
import framework.com.cmm.lib.RequestBox;

@Mapper
public interface ExpPenaltyMapper {

	int expPenaltyListCountAjax(RequestBox requestBox) throws Exception;

	List<DataBox> expPenaltyListAjax(RequestBox requestBox) throws Exception;

	DataBox expPenaltyDetailAjax(RequestBox requestBox) throws Exception;

	int expPenaltyCancelLimitUpdateAjax(RequestBox requestBox) throws Exception;

	List<Map<String, String>> expPenaltyExcelListSelect(RequestBox requestBox) throws Exception;

}
