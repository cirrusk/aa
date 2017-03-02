package amway.com.academy.lms.liveedu.service.impl;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.mapper.Mapper;
import framework.com.cmm.lib.RequestBox;

@Mapper
public interface LmsLiveEduMapper {

	/**
	 * 라이브교육 시청
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	List<Map<String, Object>> selectLiveEduList(RequestBox requestBox) throws Exception;

}
