package amway.com.academy.manager.common.systemCode.service.impl;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import amway.com.academy.manager.common.systemCode.service.SystemCodeService;
import framework.com.cmm.lib.DataBox;
import framework.com.cmm.lib.RequestBox;

import javax.xml.crypto.Data;

@Service
public class SystemCodeServiceImpl implements SystemCodeService {
	
	@Autowired
	private SystemCodeMapper systemCodeMapper;

	//코드분류 리스트
	@Override
	public List<DataBox> codeListScope(RequestBox requestBox) throws Exception {
		return systemCodeMapper.codeListScope(requestBox);
	}

	//count
	@Override
	public int systemCodeListCount(RequestBox requestBox) throws Exception {
		return (int) systemCodeMapper.systemCodeListCount(requestBox);
	}

	//list
	@Override
	public List<DataBox> systemCodeList(RequestBox requestBox) throws Exception {
		return systemCodeMapper.systemCodeList(requestBox);
	}

	// list popup
	@Override
	public DataBox systemCodeListPop(RequestBox requestBox) throws Exception {
		return systemCodeMapper.systemCodeListPop(requestBox);
	}

	// list insert
	@Override
	public int systemCodeInsert(RequestBox requestBox) throws Exception{
		int result = 0;
		DataBox checkResult = systemCodeMapper.systemCodeListPop(requestBox);

		if(checkResult != null){
			result = 2;
		} else {
			result = systemCodeMapper.systemCodeInsert(requestBox);
		}

		return result;
	}

	// list update
	@Override
	public int systemCodeUpdate(RequestBox requestBox) throws  Exception{
		return systemCodeMapper.systemCodeUpdate(requestBox);
	}

	@Override
	public int existyn(RequestBox requestBox) throws Exception {
		return systemCodeMapper.existyn(requestBox);
	}

	// list delete
	@Override
	public int systemCodeDelete(RequestBox requestBox) throws Exception{
		return systemCodeMapper.systemCodeDelete(requestBox);
	}


	// detail
	@Override
	public DataBox codeListDetail(RequestBox requestBox) throws Exception {
		return systemCodeMapper.codeListDetail(requestBox);
	}


	// detail list
	@Override
	public List<DataBox> systemCodeDetail(RequestBox requestBox) throws Exception {
		return systemCodeMapper.systemCodeDetail(requestBox);
	}

	// detail popup
	@Override
	public DataBox systemCodeDetailPop(RequestBox requestBox) throws Exception {
		return systemCodeMapper.systemCodeDetailPop(requestBox);
	}

	// detail insert
	@Override
	public int systemCodeDetailInsert(RequestBox requestBox) throws Exception {
		int result = 0;
		DataBox checkResult = systemCodeMapper.systemCodeDetailPop(requestBox);

		if(checkResult != null){
			result = 2;
		} else {
			result = systemCodeMapper.systemCodeDetailInsert(requestBox);
		}
		return result;
	}

	// detail update
	@Override
	public int systemCodeDetailUpdate(RequestBox requestBox) throws Exception {
		return systemCodeMapper.systemCodeDetailUpdate(requestBox);
	}

	// detail delete
	@Override
	public int systemCodeDetailDelete(RequestBox requestBox) throws Exception {
		return systemCodeMapper.systemCodeDetailDelete(requestBox);
	}

	// detail order
	@Override
	public int systemCodeDetailOrder(RequestBox requestBox) throws Exception {
		return systemCodeMapper.systemCodeDetailOrder(requestBox);
	}

}