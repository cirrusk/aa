package amway.com.academy.manager.common.noteSend.service.impl;

import egovframework.rte.psl.dataaccess.mapper.Mapper;
import framework.com.cmm.lib.DataBox;
import framework.com.cmm.lib.RequestBox;

import java.util.List;

@Mapper
public interface NoteSendMapper {

    int noteSendListCount(RequestBox requestBox) throws Exception;

    List<DataBox> noteSendList(RequestBox requestBox) throws Exception;

}