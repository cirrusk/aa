package amway.com.academy.manager.reservation.baseType.service.impl;

import java.util.List;

import egovframework.rte.psl.dataaccess.mapper.Mapper;
import framework.com.cmm.lib.DataBox;
import framework.com.cmm.lib.RequestBox;

@Mapper
public interface ReservationTypeMapper {

	public List<DataBox> reservationTypeListAjax(RequestBox requestBox) throws Exception;
	
	public int reservationTypeListCountAjax(RequestBox requestBox) throws Exception;
	
	public int reservationTypeInsertAjax(RequestBox requestBox) throws Exception;
	
	public DataBox reservationTypeDetailAjax(RequestBox requestBox) throws Exception;
	
	public int reservationTypeUpdateAjax(RequestBox requestBox) throws Exception;
}
