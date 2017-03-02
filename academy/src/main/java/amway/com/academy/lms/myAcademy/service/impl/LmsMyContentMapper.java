package amway.com.academy.lms.myAcademy.service.impl;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.mapper.Mapper;
import framework.com.cmm.lib.RequestBox;

@Mapper
public interface LmsMyContentMapper {

	public int selectLmsSaveLogCount(RequestBox requestBox) throws Exception;
	public List<Map<String, Object>> selectLmsSaveLogList(RequestBox requestBox) throws Exception;
	public int deleteLmsSaveLog(RequestBox requestBox) throws Exception;
}
