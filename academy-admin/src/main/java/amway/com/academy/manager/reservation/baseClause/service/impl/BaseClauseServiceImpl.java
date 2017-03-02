package amway.com.academy.manager.reservation.baseClause.service.impl;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import framework.com.cmm.lib.DataBox;
import framework.com.cmm.lib.RequestBox;
import amway.com.academy.manager.reservation.baseClause.service.BaseClauseService;

@Service
public class BaseClauseServiceImpl implements BaseClauseService {

	@Autowired
	private BaseClauseMapper baseClauseDAO;
	
	@Override
	public List<DataBox> baseClauseListAjax(RequestBox requestBox) throws Exception {
		return baseClauseDAO.baseClauseListAjax(requestBox);
	}

	@Override
	public int baseClauseListCount(RequestBox requestBox) throws Exception {
		return baseClauseDAO.baseClauseListCount(requestBox);
	}

	@Override
	public int baseClauseInsertAjax(RequestBox requestBox) throws Exception {
		
		int result = baseClauseDAO.baseClauseInsertAjax(requestBox);
		
		return result;
	}

	@Override
	public DataBox baseClauseDatail(RequestBox requestBox) throws Exception {
		
		return baseClauseDAO.baseClauseDatail(requestBox);
	}

	@Override
	public int baseClauseUpdate(RequestBox requestBox) throws Exception {
		return baseClauseDAO.baseClauseUpdate(requestBox);
	}

	

	
	
}
