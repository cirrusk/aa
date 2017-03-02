package amway.com.academy.manager.reservation.baseType.service.impl;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import amway.com.academy.manager.reservation.baseType.service.ReservationTypeService;
import framework.com.cmm.lib.DataBox;
import framework.com.cmm.lib.RequestBox;

@Service
public class ReservationTypeServiceImpl implements ReservationTypeService {
	
	@Autowired
	private ReservationTypeMapper reservationTypeDAO;

	@Override
	public List<DataBox> reservationTypeListAjax(RequestBox requestBox) throws Exception {
		return reservationTypeDAO.reservationTypeListAjax(requestBox);
	}

	@Override
	public int reservationTypeListCountAjax(RequestBox requestBox) throws Exception {
		return reservationTypeDAO.reservationTypeListCountAjax(requestBox);
	}

	@Override
	public int reservationTypeInsertAjax(RequestBox requestBox) throws Exception {
		
		int result = reservationTypeDAO.reservationTypeInsertAjax(requestBox);
		
		return result;
	}

	@Override
	public int reservationTypeUpdateAjax(RequestBox requestBox) throws Exception {
		int result = reservationTypeDAO.reservationTypeUpdateAjax(requestBox);
		
		return result;

	}

	@Override
	public DataBox reservationTypeDetailAjax(RequestBox requestBox) throws Exception {
		return reservationTypeDAO.reservationTypeDetailAjax(requestBox);
	}

}
