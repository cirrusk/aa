package amway.com.academy.manager.reservation.baseRegion.service.impl;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.google.gson.JsonArray;
import com.google.gson.JsonObject;
import com.google.gson.JsonParser;

import amway.com.academy.manager.reservation.baseRegion.service.BaseRegionService;
import framework.com.cmm.lib.DataBox;
import framework.com.cmm.lib.RequestBox;

@Service
public class BaseRegionServiceImpl implements BaseRegionService {

	@Autowired
	private BaseRegionMapper baseRegionDAO;
	
	@Override
	public List<DataBox> reservationRegionList(RequestBox requestBox) throws Exception {
		return baseRegionDAO.reservationRegionList(requestBox);
	}

	@Override
	public int reservationRegionListCount(RequestBox requestBox) throws Exception {
		return baseRegionDAO.reservationRegionListCount(requestBox);
	}

	@Override
	public List<DataBox> cityGroupDetailList(RequestBox requestBox) throws Exception {
		return baseRegionDAO.cityGroupDetailList(requestBox);
	}

	@Override
	public int cityGroupDetailListCount(RequestBox requestBox) throws Exception {
		return baseRegionDAO.cityGroupDetailListCount(requestBox);
	}
	
	@Override
	public DataBox cityGroupDetail(RequestBox requestBox) throws Exception {
		return baseRegionDAO.cityGroupDetail(requestBox);
	}
	
	@Override
	public List<DataBox> allCityCodeList(RequestBox requestBox) throws Exception {
		return baseRegionDAO.allCityCodeList(requestBox);
	}
	
	@Override
	public int cityGroupInsert(RequestBox requestBox) throws Exception {

		int insertedRowCount = 0;
		
		/* gridObject 객체 추출 */
		String gridRquest = requestBox.get("grid").replaceAll("&quot;", "\"");
		JsonObject gridObject = new JsonParser().parse(gridRquest).getAsJsonObject();
		
		/* 지역군명 등록 (마스터테이블) */
		JsonObject cityGroupInfo = gridObject.get("cityGroupInfo").getAsJsonObject();
		String cityGroupName = cityGroupInfo.get("cityGroupName").getAsString();
		String statusCode = cityGroupInfo.get("statusCode").getAsString();
		
		requestBox.put("citygroupname", cityGroupName);
		requestBox.put("statuscode", statusCode);
		baseRegionDAO.cityGroupMasterInsert(requestBox);
		
		/* mapping table 내용 갱신 */
		insertedRowCount = deleteAndInsertCityList(requestBox, gridObject);
		
		return insertedRowCount;
	}
	
	@Override
	public int cityGroupUpdate(RequestBox requestBox) throws Exception {
		
		int insertedRowCount = 0;
		
		/*
		System.out.println("requestBox " + requestBox.keys());
		Enumeration<?> en = requestBox.keys();
		while(en.hasMoreElements()){
			System.out.println("en.nextElement() : " + en.nextElement());
		}
		*/
		
		String gridRquest = requestBox.get("grid").replaceAll("&quot;", "\"");
		
		//System.out.println("gridRquest : " + gridRquest.replaceAll("&quot;", "\""));
		
		JsonObject gridObject = new JsonParser().parse(gridRquest).getAsJsonObject();
		
		//System.out.println("" + gridObject.getAsJsonArray("list").size());
		//System.out.println("" + gridObject.getAsJsonArray("list"));
		
		/* 지역군명 수정 (마스터테이블) */
		//JsonArray cityGroupInfo = (JsonArray)gridObject.getAsJsonArray("cityGroupInfo");
		
		JsonObject cityGroupInfo = gridObject.get("cityGroupInfo").getAsJsonObject();
		
		String cityGroupCode = cityGroupInfo.get("cityGroupCode").getAsString();
		String cityGroupName = cityGroupInfo.get("cityGroupName").getAsString();
		String statusCode = cityGroupInfo.get("statusCode").getAsString();
		
		requestBox.put("citygroupcode", cityGroupCode);
		requestBox.put("citygroupname", cityGroupName);
		requestBox.put("statuscode", statusCode);
		baseRegionDAO.cityGroupMasterUpdate(requestBox);
		
		/* mapping table 내용 갱신 */
		insertedRowCount = deleteAndInsertCityList(requestBox, gridObject);
		
		return insertedRowCount;
	}
	
	/**
	 * 맵핑 테이블의 내용을 갱신하는 기능
	 * 
	 * insert transaction 과 update transaction 의 맵핑테이블의 로직은 동일하기 때문에
	 * 메소드를 분리해 내어 재사용을 하도록 했음.
	 * 
	 * @param requestBox
	 * @param gridObject
	 * @return
	 * @throws Exception
	 */
	private int deleteAndInsertCityList(RequestBox requestBox, JsonObject gridObject) throws Exception {
		
		int insertedRowCount = 0;

		/* 선택된 목록 행정구역 및 도시 수정 ( 맵핑테이블 - 삭제 & 입력) */
		baseRegionDAO.cityGroupDelete(requestBox); // 삭제
		
		JsonArray cityList = gridObject.getAsJsonArray("list");
		
		int arraySize = cityList.size();
		for(int arrayCount = 0 ; arrayCount < arraySize ; arrayCount++){
			String arrayRegionCode = cityList.get(arrayCount).getAsJsonObject().get("regioncode").getAsString();
			String arrayRegionName = cityList.get(arrayCount).getAsJsonObject().get("regionname").getAsString();
			requestBox.put("regioncode", arrayRegionCode);
			requestBox.put("regionname", arrayRegionName);
			
			String arrayCityCode = null;
			if (null != cityList.get(arrayCount).getAsJsonObject().get("citycode")){
				arrayCityCode = cityList.get(arrayCount).getAsJsonObject().get("citycode").getAsString();
				requestBox.put("citycode", arrayCityCode);
			}else{
				requestBox.put("citycode", "");
			}

			String arrayCityName = null;
			if(null != cityList.get(arrayCount).getAsJsonObject().get("cityname")){
				arrayCityName = cityList.get(arrayCount).getAsJsonObject().get("cityname").getAsString();
				requestBox.put("cityname", arrayCityName);
			}else{
				requestBox.put("cityname", "");
			}
			
			insertedRowCount = baseRegionDAO.cityGroupInsert(requestBox);	// 입력
		}
		
		return insertedRowCount;
	}

	@Override
	public int deleteRegion(RequestBox requestBox) throws Exception {
		
		baseRegionDAO.cityGroupDelete(requestBox); // 삭제
		
		baseRegionDAO.deleteRegion(requestBox);
		
		return 0;
	}

}
