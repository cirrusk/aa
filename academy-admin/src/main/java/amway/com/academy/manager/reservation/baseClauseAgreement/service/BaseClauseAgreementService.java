package amway.com.academy.manager.reservation.baseClauseAgreement.service;

import java.util.List;

import framework.com.cmm.lib.DataBox;
import framework.com.cmm.lib.RequestBox;

/**
 * 약관 동의 현황
 * @author KR620225
 *
 */
public interface BaseClauseAgreementService {

	public List<DataBox> baseClauseAgreementListAjax(RequestBox requestBox) throws Exception;
	
	public int baseClauseAgreementListCount(RequestBox requestBox) throws Exception;
}
