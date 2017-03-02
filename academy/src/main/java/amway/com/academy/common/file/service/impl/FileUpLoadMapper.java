package amway.com.academy.common.file.service.impl;

import java.util.Map;

import org.springframework.ui.ModelMap;

import egovframework.rte.psl.dataaccess.mapper.Mapper;
import framework.com.cmm.lib.RequestBox;

@Mapper
public interface FileUpLoadMapper {

	public int selectFileKey(RequestBox requestBox);

	public void insertFile(Map<String, Object> entry);

	public Map<String, Object> selectFileDetail(ModelMap model);
	
	public Map<String, Object> selectFileDetailByFileName(ModelMap model);

}
