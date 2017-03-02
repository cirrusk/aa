package amway.com.academy.manager.common.noteSet.service.impl;

import egovframework.rte.psl.dataaccess.mapper.Mapper;
import framework.com.cmm.lib.DataBox;
import framework.com.cmm.lib.RequestBox;

import java.util.List;

@Mapper
public interface NoteSetMapper {

	int noteSetListCount(RequestBox requestBox) throws Exception;

	List<DataBox> noteSetList(RequestBox requestBox) throws Exception;

	DataBox noteSetPop(RequestBox requestBox) throws Exception;

	int noteSetInsert(RequestBox requestBox) throws Exception;

	int noteSetUpdate(RequestBox requestBox)throws Exception;

	void noteSetDelete(RequestBox requestBox) throws Exception;

}