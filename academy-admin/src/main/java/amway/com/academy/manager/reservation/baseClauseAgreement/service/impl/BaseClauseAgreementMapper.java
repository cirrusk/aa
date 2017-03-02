package amway.com.academy.manager.reservation.baseClauseAgreement.service.impl;

import java.util.List;

import egovframework.rte.psl.dataaccess.mapper.Mapper;
import framework.com.cmm.lib.DataBox;
import framework.com.cmm.lib.RequestBox;

@Mapper
public interface BaseClauseAgreementMapper {

	public List<DataBox> baseClauseAgreementListAjax(RequestBox requestBox) throws Exception;
	
	public int baseClauseAgreementListCount(RequestBox requestBox) throws Exception;
}
