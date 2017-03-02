package amway.com.academy.manager.common.targetCode.service.impl;

import amway.com.academy.manager.common.targetCode.service.TargetCodeService;
import framework.com.cmm.lib.DataBox;
import framework.com.cmm.lib.RequestBox;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class TargetCodeServiceImpl implements TargetCodeService {
	
	@Autowired
	private TargetCodeMapper targetcodeMapper;

	//코드분류 리스트
	@Override
	public List<DataBox> codeListScope(RequestBox requestBox) throws Exception {
		return targetcodeMapper.codeListScope(requestBox);
	}

	//count
	@Override
	public int targetCodeListCount(RequestBox requestBox) throws Exception {
		return (int) targetcodeMapper.targetCodeListCount(requestBox);
	}

	//list
	@Override
	public List<DataBox> targetCodeList(RequestBox requestBox) throws Exception {
		return targetcodeMapper.targetCodeList(requestBox);
	}

	//list popup
	@Override
	public DataBox targetCodeListPop(RequestBox requestBox) throws Exception {
		return targetcodeMapper.targetCodeListPop(requestBox);
	}

	//insert
	@Override
	public int targetCodeInsert(RequestBox requestBox) throws Exception{
		int result = 0;

		DataBox checkResult = targetcodeMapper.targetCodeListPop(requestBox);

		if(checkResult != null){
			result = 2;
		} else {
			result = targetcodeMapper.targetCodeInsert(requestBox);
		}
		return result;
	}

	//update
	@Override
	public int targetCodeUpdate(RequestBox requestBox) throws  Exception{
		return targetcodeMapper.targetCodeUpdate(requestBox);
	}

	@Override
	public int existyn(RequestBox requestBox) throws Exception {
		return targetcodeMapper.existyn(requestBox);
	}

	//delete
	@Override
	public int targetCodeDelete(RequestBox requestBox) throws Exception{
		return targetcodeMapper.targetCodeDelete(requestBox);
	}

    //detail page call
	@Override
	public DataBox targetCodeDetail(RequestBox requestBox) throws Exception {
		return targetcodeMapper.targetCodeDetail(requestBox);
	}


	//detail list
	@Override
	public List<DataBox> targetCodeDetailList(RequestBox requestBox) throws Exception {
		return targetcodeMapper.targetCodeDetailList(requestBox);
	}

	//detail popup
	@Override
	public DataBox targetCodeDetailPop(RequestBox requestBox) throws Exception {
		return targetcodeMapper.targetCodeDetailPop(requestBox);
	}

	//detail insert
	@Override
	public int targetCodeDetailInsert(RequestBox requestBox) throws Exception {
		int result = 0;
		DataBox checkResult = targetcodeMapper.targetCodeDetailPop(requestBox);

		if(checkResult != null){
			result = 2;
		} else {
			result = targetcodeMapper.targetCodeDetailInsert(requestBox);
		}
		return  result;
	}

	//detail update
	@Override
	public int targetCodeDetailUpdate(RequestBox requestBox) throws Exception {
		return targetcodeMapper.targetCodeDetailUpdate(requestBox);
	}

	//detail delete
	@Override
	public int targetCodeDetailDelete(RequestBox requestBox) throws Exception {
		return targetcodeMapper.targetCodeDetailDelete(requestBox);
	}

	//detail order
	@Override
	public int targetCodeDetailOrder(RequestBox requestBox) throws Exception {
		return targetcodeMapper.targetCodeDetailOrder(requestBox);
	}

}