package amway.com.academy.manager.reservation.basePlaza.service.impl;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import amway.com.academy.manager.reservation.basePlaza.service.BasePlazaService;
import framework.com.cmm.lib.DataBox;
import framework.com.cmm.lib.RequestBox;

@Service
public class BasePlazaServiceImpl implements BasePlazaService {
	
	@Autowired
	private BasePlazaMapper basePlazaDAO;

	/**
	 * pp정보 목록 조회
	 * 
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	@Override
	public List<DataBox> basePlazaListAjax(RequestBox requestBox) throws Exception {
		return basePlazaDAO.basePlazaListAjax(requestBox);
	}

	/**
	 * pp정보 목록 카운트
	 * 
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	@Override
	public int basePlazaListCountAjax(RequestBox requestBox) throws Exception {
		return basePlazaDAO.basePlazaListCountAjax(requestBox);
	}

	/**
	 * pp정보 등록
	 * 
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	@Override
	public int basePlazaInsertAjax(RequestBox requestBox) throws Exception {
		return basePlazaDAO.basePlazaInsertAjax(requestBox);
	}

	/**
	 * pp 노출순서 지정 팝업
	 * 
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	@Override
	public List<?> basePlazaRowChangeListAjax(RequestBox requestBox) throws Exception {
		return basePlazaDAO.basePlazaRowChangeListAjax(requestBox);
	}

	/**
	 * pp 노출순서 지정
	 * 
	 * basePlazaRowChangeUpdateAjax
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	@Override
	public int basePlazaRowChangeUpdateAjax(RequestBox requestBox) throws Exception {
		
		int result = 0;
		
		for(int i = 0; i < requestBox.getVector("tempPpSeq").size(); i++){
			requestBox.put("ppSeq", requestBox.getVector("tempPpSeq").get(i));
			requestBox.put("orderNumber", requestBox.getVector("tempOrderNumber").get(i));
			
			result = basePlazaDAO.basePlazaRowChangeUpdateAjax(requestBox);
			
		}
		
//		Map<String, String> map = new HashMap<String, String>();
//		
//		String[] highArray = requestBox.get("data").split(" ");
//		for( int i = 0; i < highArray.length; i++){
//			String[] middleArray = highArray[i].split(",");
//			for( int y = 0; y < middleArray.length; y++){
//				String[] lowArray = middleArray[y].split("=");
//				map.put(lowArray[0], lowArray[1]);
//			}
//			basePlazaDAO.basePlazaRowChangeUpdateAjax(map);
//			map.clear();
//		}
		    
		return result;
	}

	/**
	 * pp정보 상세 조회
	 * 
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	@Override
	public DataBox basePlazaDetailAjax(RequestBox requestBox) throws Exception {
		return basePlazaDAO.basePlazaDetailAjax(requestBox);
	}

	/**
	 * pp정보 수정
	 * 
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	@Override
	public int basePlazaUpdateAjax(RequestBox requestBox) throws Exception {
		return basePlazaDAO.basePlazaUpdateAjax(requestBox);
	}

	/**
	 * pp정보 수정 이력 조회
	 * 
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	@Override
	public List<DataBox> basePlazaHistoryListAjax(RequestBox requestBox) throws Exception {
		return basePlazaDAO.basePlazaHistoryListAjax(requestBox);
	}

	/**
	 * pp정보 수정 이력 등록
	 * 
	 * @param requestBox
	 * @return
	 * @throws Exception
	 */
	@Override
	public int basePlazaHistoryInsert(RequestBox requestBox) throws Exception {
		return basePlazaDAO.basePlazaHistoryInsert(requestBox);
	}

	
//	@Override
//	public int reservationTypeUpdateAjax(RequestBox requestBox) throws Exception {
//		// TODO Auto-generated method stub
//		return 0;
//	}
//
//	@Override
//	public DataBox reservationTypeDetailAjax(RequestBox requestBox) throws Exception {
//		// TODO Auto-generated method stub
//		return null;
//	}
}
