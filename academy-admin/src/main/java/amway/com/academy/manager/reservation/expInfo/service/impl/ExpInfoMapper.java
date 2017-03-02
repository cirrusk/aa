package amway.com.academy.manager.reservation.expInfo.service.impl;

import java.util.List;


import egovframework.rte.psl.dataaccess.mapper.Mapper;
import framework.com.cmm.lib.DataBox;
import framework.com.cmm.lib.RequestBox;

@Mapper
public interface ExpInfoMapper {

	public List<DataBox> expProgramListAjax(RequestBox requestBox) throws Exception;

	public List<DataBox> expInfoCalendarAjax(RequestBox requestBox) throws Exception;

	public List<DataBox> expInfoListAjax(RequestBox requestBox) throws Exception;

	public DataBox expInfoAdminReservationSelectAjax(RequestBox requestBox) throws Exception;

	public int expInfoAdminReservationInsertAjax(RequestBox requestBox) throws Exception;

	public List<DataBox> expInfoAdminReservationCancelSelectAjax(RequestBox requestBox) throws Exception;

	public int expInfoAdminReservationCancelUpdateAjax(RequestBox requestBox) throws Exception;

	public DataBox expInfoSessionSelectAjax(RequestBox requestBox) throws Exception;

	public List<DataBox> expInfoSessionListAjax(RequestBox requestBox) throws Exception;
	
	public DataBox searchExpTypeSeq(RequestBox requestBox) throws Exception;
}