package amway.com.academy.manager.common.targetUpload.service.impl;

import egovframework.rte.psl.dataaccess.EgovAbstractMapper;
import egovframework.rte.psl.dataaccess.mapper.Mapper;

import java.util.Map;

/**
 * Created by KR620248 on 2016-10-11.
 */
@Mapper
public class ExcelMapper extends EgovAbstractMapper {
    public int selectValidAgree(Map<String, Object> paramMap) {
        return selectOne("ExcelMapper.selectValidAgree", paramMap);
    }
}
