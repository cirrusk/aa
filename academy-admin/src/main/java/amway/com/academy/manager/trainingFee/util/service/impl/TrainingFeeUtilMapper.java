package amway.com.academy.manager.trainingFee.util.service.impl;

import java.util.List;

import egovframework.rte.psl.dataaccess.mapper.Mapper;
import framework.com.cmm.lib.DataBox;
import framework.com.cmm.lib.RequestBox;

@Mapper
public interface TrainingFeeUtilMapper {
	int selectSystemLogListCount(RequestBox requestBox);

	List<DataBox> selectSystemLogList(RequestBox requestBox);

	int selectSMSLogListCount(RequestBox requestBox);

	List<DataBox> selectSMSLogList(RequestBox requestBox);
}