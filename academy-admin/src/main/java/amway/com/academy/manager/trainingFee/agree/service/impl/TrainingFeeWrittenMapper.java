package amway.com.academy.manager.trainingFee.agree.service.impl;

import java.util.List;

import egovframework.rte.psl.dataaccess.mapper.Mapper;
import framework.com.cmm.lib.DataBox;
import framework.com.cmm.lib.RequestBox;

@Mapper
public interface TrainingFeeWrittenMapper {

	int selectWrittenListCount(RequestBox requestBox);

	List<DataBox> selectWrittenList(RequestBox requestBox);
	
	DataBox selectWrittenData(RequestBox requestBox);

	int saveWrittenEdit(RequestBox requestBox);
	
	
	
}