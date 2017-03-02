package amway.com.academy.manager.common.menuApi.service.impl;

import egovframework.rte.psl.dataaccess.mapper.Mapper;

import java.util.Map;

/**
 * Created by KR620242 on 2016-10-18.
 */
@Mapper
public interface MenuApiMapper {

    int navigationInsert(Map<String, Object> params) throws Exception;
}
