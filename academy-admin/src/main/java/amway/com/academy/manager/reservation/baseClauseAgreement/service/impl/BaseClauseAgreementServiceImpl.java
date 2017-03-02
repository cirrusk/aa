package amway.com.academy.manager.reservation.baseClauseAgreement.service.impl;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import framework.com.cmm.lib.DataBox;
import framework.com.cmm.lib.RequestBox;
import amway.com.academy.manager.reservation.baseClauseAgreement.service.BaseClauseAgreementService;

@Service
public class BaseClauseAgreementServiceImpl implements BaseClauseAgreementService {

	@Autowired
	private BaseClauseAgreementMapper baseClauseAgreementDAO;
	
	@Override
	public List<DataBox> baseClauseAgreementListAjax(RequestBox requestBox) throws Exception {
		
		return baseClauseAgreementDAO.baseClauseAgreementListAjax(requestBox);
	}

	@Override
	public int baseClauseAgreementListCount(RequestBox requestBox) throws Exception {
		
		return baseClauseAgreementDAO.baseClauseAgreementListCount(requestBox);
	}

}
