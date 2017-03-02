package amway.com.academy.manager.reservation.basicPackage.service.impl;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import amway.com.academy.manager.reservation.basicPackage.service.BasicReservationService;
import amway.com.academy.manager.reservation.basicPackage.web.CommonCodeVO;
import framework.com.cmm.lib.DataBox;
import framework.com.cmm.lib.RequestBox;

@Service
public class BasicReservationServiceImpl implements BasicReservationService {

	@Autowired
	private BasicReservationMapper basicReservationMapper;

	@Override
	public String getCommonCodeName(CommonCodeVO codeVO) throws Exception {
		return basicReservationMapper.getCommonCodeName(codeVO);
	}
	
	@Override
	public List<CommonCodeVO> commonCodeList(CommonCodeVO codeVO) throws Exception {
		return basicReservationMapper.commonCodeList(codeVO);
	}

	@Override
	public List<CommonCodeVO> ppCodeList() throws Exception {
		RequestBox request = new RequestBox("allowApCode");
		request.put("sessionApCode", "");
		return basicReservationMapper.ppCodeList(request);
	}
	
	@Override
	public List<CommonCodeVO> ppCodeList(String allowApCode) throws Exception {
		
		RequestBox request = new RequestBox("allowApCode");
		request.put("sessionApCode", allowApCode);
		return basicReservationMapper.ppCodeList(request);
	}

	@Override
	public List<CommonCodeVO> rervationProgramTypeCodeList() throws Exception {
		return basicReservationMapper.rervationProgramTypeCodeList();
	}

	@Override
	public List<CommonCodeVO> rervationProgramCodeList() throws Exception {
		return basicReservationMapper.rervationProgramCodeList();
	}

	@Override
	public List<CommonCodeVO> regionCodeList() throws Exception {
		return basicReservationMapper.regionCodeList();
	}
	
	@Override
	public List<CommonCodeVO> cityCodeListByRegionCode(String regionCode) throws Exception {
		CommonCodeVO codeVO = new CommonCodeVO();
		codeVO.setCode(regionCode);
		return basicReservationMapper.cityCodeListByRegionCode(codeVO);
	}

	@Override
	public List<CommonCodeVO> roleGroupCodeList() throws Exception {
		return basicReservationMapper.roleGroupCodeList();
	}
	
	@Override
	public List<CommonCodeVO> roleGroupWithCookMasterCodeList() throws Exception {
		return basicReservationMapper.roleGroupWithCookMasterCodeList();
	}

	@Override
	public List<CommonCodeVO> ageCodeList() throws Exception {
		return basicReservationMapper.ageCodeList();
	}

	@Override
	public List<CommonCodeVO> cityGroupCodeList() throws Exception {
		return basicReservationMapper.cityGroupCodeList();
	}

	@Override
	public List<CommonCodeVO> pinCodeList() throws Exception {
		return basicReservationMapper.pinCodeList();
	}

	@Override
	public List<CommonCodeVO> roomTypeInfoCodeList() throws Exception {
		return basicReservationMapper.roomTypeInfoCodeList();
	}
	
	@Override
	public List<CommonCodeVO> expTypeInfoCodeList() throws Exception {
		return basicReservationMapper.expTypeInfoCodeList();
	}
	

	@Override
	public List<DataBox> searchSessionNameList(RequestBox requestBox) throws Exception {
		return basicReservationMapper.searchSessionNameList(requestBox);
	}

	@Override
	public List<DataBox> searchExpSessionNameList(RequestBox requestBox) throws Exception {
		return basicReservationMapper.searchExpSessionNameList(requestBox);
	}

	@Override
	public DataBox reservationToday() throws Exception {
		return basicReservationMapper.reservationToday();
	}

}
