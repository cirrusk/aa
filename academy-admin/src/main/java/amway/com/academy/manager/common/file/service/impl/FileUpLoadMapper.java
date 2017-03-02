package amway.com.academy.manager.common.file.service.impl;

import java.util.Map;

import egovframework.rte.psl.dataaccess.mapper.Mapper;
import framework.com.cmm.lib.RequestBox;

@Mapper
public interface FileUpLoadMapper {

	public int selectFileKey(RequestBox requestBox);

	public void insertFile(Map<String, Object> entry);

	public Map<String, Object> selectFileDetail(Map<String, Object> params);

}
