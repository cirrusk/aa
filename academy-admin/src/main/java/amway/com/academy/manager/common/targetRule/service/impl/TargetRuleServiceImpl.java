package amway.com.academy.manager.common.targetRule.service.impl;

import amway.com.academy.manager.common.targetCode.service.TargetCodeService;
import amway.com.academy.manager.common.targetRule.service.TargetRuleService;
import framework.com.cmm.lib.DataBox;
import framework.com.cmm.lib.RequestBox;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class TargetRuleServiceImpl implements TargetRuleService {
	
	@Autowired
	private TargetRuleMapper targetruleMapper;

	//count
	@Override
	public int targetRuleCount(RequestBox requestBox) throws Exception {
		return (int) targetruleMapper.targetRuleCount(requestBox);
	}

	//list
	@Override
	public List<DataBox> targetRuleList(RequestBox requestBox) throws Exception {
		return targetruleMapper.targetRuleList(requestBox);
	}

	//list popup
	@Override
	public DataBox targetRulePop(RequestBox requestBox) throws Exception {
		return targetruleMapper.targetRulePop(requestBox);
	}

	//코드분류 리스트
	@Override
	public List<DataBox> targetRuleCode(RequestBox requestBox) throws Exception {
		return targetruleMapper.targetRuleCode(requestBox);
	}

	//insert
	@Override
	public int targetRuleInsert(RequestBox requestBox) throws Exception{
		int result = 0;
		DataBox checkResult = targetruleMapper.targetRuleCheck(requestBox);

		if(checkResult != null){
			result = 2;
		} else {
			result = targetruleMapper.targetRuleInsert(requestBox);
		}

		return result;
	}


}