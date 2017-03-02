package amway.com.academy.trainingFee.common.service.impl;

import egovframework.rte.psl.dataaccess.mapper.Mapper;
import framework.com.cmm.lib.RequestBox;

@Mapper
public interface TrainingFeeCommonMapper {

	int inserTrfeeSystemProcessLog(RequestBox requestBox);


}
