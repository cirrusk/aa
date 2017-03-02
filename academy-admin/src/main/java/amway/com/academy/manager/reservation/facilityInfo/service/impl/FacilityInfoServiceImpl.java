package amway.com.academy.manager.reservation.facilityInfo.service.impl;

import amway.com.academy.manager.reservation.facilityInfo.service.FacilityInfoService;
import framework.com.cmm.lib.DataBox;
import framework.com.cmm.lib.RequestBox;

import framework.com.cmm.util.StringUtil;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * Created by KR620248 on 2016-08-08.
 */
@Service
public class FacilityInfoServiceImpl implements FacilityInfoService {

    @Autowired
    FacilityInfoMapper facilityInfoMapper;

    //list
    @Override
    public List<DataBox> facilityInfoList(RequestBox requestBox) throws Exception {
        return facilityInfoMapper.facilityInfoList(requestBox);
    }

    //list count
    @Override
    public int facilityInfoListCount(RequestBox requestBox) throws Exception {
        return facilityInfoMapper.facilityInfoListCount(requestBox);
    }

    @Override
    public List<Map<String, String>> facilityinfoExcelDownload(RequestBox requestBox) throws Exception {
        return facilityInfoMapper.facilityinfoExcelDownload(requestBox);
    }

    //codeCombo
    @Override
    public List<DataBox> codeCombo(RequestBox requestBox) throws Exception {
        return facilityInfoMapper.codeCombo(requestBox);
    }

    //rsvType
    @Override
    public List<DataBox> rsvType(RequestBox requestBox) throws Exception {
        return facilityInfoMapper.rsvType(requestBox);
    }

    @Override
    public List<DataBox> updateType(RequestBox requestBox) throws Exception {
        return facilityInfoMapper.updateType(requestBox);
    }

    //detail one save
    @Override
    public int facilityInfoDetailOneInsert(RequestBox requestBox) throws Exception {
        Map<String, Object> fileMap = new HashMap<String, Object>();
        int result = 0;

        String textValue = "";
        String intro = "";
        String comboValue = "";

        String facilityText = "";
        String facility = "";
        String facilityCombo = "";

        for(int i=0;i< requestBox.getVector("ppseq").size();i++){

            textValue = java.util.regex.Matcher.quoteReplacement(StringUtil.htmlSpecialChar((String)requestBox.getVector("intro").get(0)));
            intro = "".equals(textValue) ? comboValue : textValue;
            requestBox.put("intro", intro);

            facilityText = java.util.regex.Matcher.quoteReplacement(StringUtil.htmlSpecialChar((String)requestBox.getVector("facility").get(0)));
            facility = "".equals(facilityText) ? facilityCombo : facilityText;
            requestBox.put("facility", facility); 

            result = facilityInfoMapper.facilityInfoDetailOneInsert(requestBox);
        }

        for(int j=0; j < 10; j++){
            if(!requestBox.get("filekey"+(j+1)).toString().equals("0")) {
                fileMap.put("fileKey", requestBox.get("filekey" + (j + 1)));
                fileMap.put("altText", requestBox.get("alt" + (j + 1)));

                facilityInfoMapper.fileUpdate(fileMap);
            }
        }

       return result;
     }

    @Override
    public DataBox typesearch(RequestBox requestBox) throws Exception {
        return facilityInfoMapper.typesearch(requestBox);
    }

    //detail one save seq call
    @Override
    public int facilityInfoDetailOneSeq(RequestBox requestBox) throws Exception {
        int result = facilityInfoMapper.facilityInfoDetailOneSeq(requestBox);
        requestBox.put("roomseq",result);
        // 공휴일추가
    	facilityInfoMapper.facilityInfoInsertHoliday(requestBox);
    	
        return result;
    }

    @Override
    public DataBox ptype(RequestBox requestBox) throws Exception {
        return facilityInfoMapper.ptype(requestBox);
    }

    @Override
    public int facilityInfoDetailOneUpdate(RequestBox requestBox) throws Exception {
        Map<String, Object> fileMap = new HashMap<String, Object>();
        int result = 0;

        String textValue = "";
        String intro = "";
        String comboValue = "";

        String facilityText = "";
        String facility = "";
        String facilityCombo = "";

        for(int i=0;i< requestBox.getVector("ppseq").size();i++){

            textValue = java.util.regex.Matcher.quoteReplacement(StringUtil.htmlSpecialChar((String)requestBox.getVector("intro").get(0)));
            intro = "".equals(textValue) ? comboValue : textValue;
            requestBox.put("intro", intro);

            facilityText = java.util.regex.Matcher.quoteReplacement(StringUtil.htmlSpecialChar((String)requestBox.getVector("facility").get(0)));
            facility = "".equals(facilityText) ? facilityCombo : facilityText;
            requestBox.put("facility", facility);

            result = facilityInfoMapper.facilityInfoDetailOneUpdate(requestBox);
        }

        for(int j=0; j < 10; j++){
            if(!requestBox.get("filekey"+(j+1)).toString().equals("0")) {
                fileMap.put("fileKey", requestBox.get("filekey" + (j + 1)));
                fileMap.put("altText", requestBox.get("alt" + (j + 1)));

                facilityInfoMapper.fileUpdate(fileMap);
            }
        }

        return result;
    }

    //datail two delete:day
    @Override
    public void facilityInfoDelete(RequestBox requestBox) throws Exception {
        facilityInfoMapper.facilityInfoDelete(requestBox);
    }

    //datail two delete:all
    @Override
    public void facilityInfoDeleteAll(RequestBox requestBox) throws Exception {
        facilityInfoMapper.facilityInfoDeleteAll(requestBox);
    }

    //datail two save:day
    @Override
    public void facilityInfoInsert(RequestBox requestBox) throws Exception {
        facilityInfoMapper.facilityInfoInsert(requestBox);
        facilityInfoMapper.rsvroominfoUpdate(requestBox);
    }

    //datail two save:day
    @Override
    public void facilityInfoUpdate(RequestBox requestBox) throws Exception {
        facilityInfoMapper.facilityInfoUpdate(requestBox);
        facilityInfoMapper.rsvroominfoUpdate(requestBox);        
    }

    //detail two select:mon
    @Override
    public List<DataBox> facilityInfoSelectWeek(RequestBox requestBox) throws Exception {
        return facilityInfoMapper.facilityInfoSelectWeek(requestBox);
    }

    @Override
    public int allSessionTypeSearch(RequestBox requestBox) throws Exception {
        return facilityInfoMapper.allSessionTypeSearch(requestBox);
    }

    //detail two popup save : early
    @Override
    public void facilityInfoInsertEarly(RequestBox requestBox) throws Exception {
        facilityInfoMapper.facilityInfoInsertEarly(requestBox);
        facilityInfoMapper.rsvroominfoUpdate(requestBox);
    }

    @Override
    public void facilityinfoInsertRoomrole(RequestBox requestBox) throws Exception {
        facilityInfoMapper.facilityinfoInsertRoomrole(requestBox);
    }

    @Override
    public void facilityInfoEarlyDel(RequestBox requestBox) throws Exception {
        facilityInfoMapper.facilityInfoEarlyDel(requestBox);
        facilityInfoMapper.rsvroominfoUpdate(requestBox);
    }

    //detail two popup date check
    @Override
    public DataBox facilityInfoDetailTwoDateCheck(RequestBox requestBox) throws Exception {
        return facilityInfoMapper.facilityInfoDetailTwoDateCheck(requestBox);
    }

    //detail two list
    @Override
    public List<DataBox> facilityInfoDetailTwoList(RequestBox requestBox) throws Exception {
        return facilityInfoMapper.facilityInfoDetailTwoList(requestBox);
    }

    @Override
    public DataBox facilityInfoDetailSessionPop(RequestBox requestBox) throws Exception {
        return facilityInfoMapper.facilityInfoDetailSessionPop(requestBox);
    }

    @Override
    public List<DataBox> facilityInfoDetailTwoPreview(RequestBox requestBox) throws Exception {
        return facilityInfoMapper.facilityInfoDetailTwoPreview(requestBox);
    }

    @Override
    public DataBox cookType(RequestBox requestBox) throws Exception {
        return facilityInfoMapper.cookType(requestBox);
    }

    @Override
    public List<DataBox> checkList(RequestBox requestBox) throws Exception {
        return facilityInfoMapper.checkList(requestBox);
    }

    @Override
    public List<DataBox> rsvCheckList(RequestBox requestBox) throws Exception {
        return facilityInfoMapper.rsvCheckList(requestBox);
    }

    @Override
    public DataBox facilityType(RequestBox requestBox) throws Exception {
        return facilityInfoMapper.facilityType(requestBox);
    }

    //detail three area
    @Override
    public List<DataBox> facilityInfoDetailThreeAreaInfo(RequestBox requestBox) throws Exception {
        return facilityInfoMapper.facilityInfoDetailThreeAreaInfo(requestBox);
    }

    //detail three pin info
    @Override
    public List<DataBox> facilityInfoDetailThreePinInfo(RequestBox requestBox) throws Exception {
        return facilityInfoMapper.facilityInfoDetailThreePinInfo(requestBox);
    }

    //detail three age info
    @Override
    public List<DataBox> facilityInfoDetailThreeAgeInfo(RequestBox requestBox) throws Exception {
        return facilityInfoMapper.facilityInfoDetailThreeAgeInfo(requestBox);
    }


    //detail three sessionseq
    @Override
    public List<DataBox> facilityInfoDetailThreeSession(RequestBox requestBox) throws Exception {
        return facilityInfoMapper.facilityInfoDetailThreeSession(requestBox);
    }


    //detail three target group
    @Override
    public List<DataBox> facilityInfoDetailThreeSpecialInfo(RequestBox requestBox) throws Exception {
        return facilityInfoMapper.facilityInfoDetailThreeSpecialInfo(requestBox);
    }

    @Override
    public List<DataBox> facilityInfoDetailThreeSpecialCookInfo(RequestBox requestBox) throws Exception {
        return facilityInfoMapper.facilityInfoDetailThreeSpecialCookInfo(requestBox);
    }

    //detail three term popup insert
    @Override
    public void facilityInfoDetailThreeTermInsert(RequestBox requestBox) throws Exception {
        facilityInfoMapper.facilityInfoDetailThreeTermInsert(requestBox);
        facilityInfoMapper.rsvroominfoUpdate(requestBox);
    }

    @Override
    public List<DataBox> facilityInfoAllSession(RequestBox requestBox) throws Exception {
        return facilityInfoMapper.facilityInfoAllSession(requestBox);
    }

    //detail three term list
    @Override
    public List<DataBox> facilityInfoDetailThreeTermList(RequestBox requestBox) throws Exception {
        return facilityInfoMapper.facilityInfoDetailThreeTermList(requestBox);
    }

    @Override
    public void termListDelete(RequestBox requestBox) throws Exception {
        facilityInfoMapper.termListDelete(requestBox);
    }

    //detail three dis popup list
    @Override
    public List<DataBox> facilityInfoDetailThreeDisPopList(RequestBox requestBox) throws Exception {
        return facilityInfoMapper.facilityInfoDetailThreeDisPopList(requestBox);
    }

    //detail three dis insert
    @Override
    public int facilityInfoDetailThreeDisInsert(RequestBox requestBox) throws Exception {
    	facilityInfoMapper.rsvroominfoUpdate(requestBox);
        return facilityInfoMapper.facilityInfoDetailThreeDisInsert(requestBox);
    }

    //detail three dis list
    @Override
    public List<DataBox> facilityInfoDetailThreeDisList(RequestBox requestBox) throws Exception {
        return facilityInfoMapper.facilityInfoDetailThreeDisList(requestBox);
    }

    @Override
    public void disListDelete(RequestBox requestBox) throws Exception {
        facilityInfoMapper.disListDelete(requestBox);
        facilityInfoMapper.rsvroominfoUpdate(requestBox);
    }

    //detail three cancel popup list
    @Override
    public List<DataBox> facilityInfoDetailThreeCancelPopList(RequestBox requestBox) throws Exception {
        return facilityInfoMapper.facilityInfoDetailThreeCancelPopList(requestBox);
    }

    @Override
    public List<DataBox> facilityInfoDetailThreeCookCancelPopList(RequestBox requestBox) throws Exception {
        return facilityInfoMapper.facilityInfoDetailThreeCookCancelPopList(requestBox);
    }

    //detail three cancel insert
    @Override
    public void facilityInfoDetailThreeCancelInsert(RequestBox requestBox) throws Exception {
        facilityInfoMapper.facilityInfoDetailThreeCancelInsert(requestBox);
        facilityInfoMapper.rsvroominfoUpdate(requestBox);
    }

    //detail three cancel list
    @Override
    public List<DataBox> facilityInfoDetailThreeCancelList(RequestBox requestBox) throws Exception {
        return facilityInfoMapper.facilityInfoDetailThreeCancelList(requestBox);
    }

    //detail three cancel delete
    @Override
    public void facilityInfoDetailThreeCancelDelete(RequestBox requestBox) throws Exception {
        facilityInfoMapper.facilityInfoDetailThreeCancelDelete(requestBox);
    }

    //detail three cook cancel  pop list
    @Override
    public List<DataBox> comparedataa(RequestBox requestBox) throws Exception {
        return facilityInfoMapper.comparedataa(requestBox);
    }

    //detail three cook cancel  pop list
    @Override
    public List<DataBox> comparedatab(RequestBox requestBox) throws Exception {
        return facilityInfoMapper.comparedatab(requestBox);
    }

    @Override
    public DataBox facilityInfoDetailOne(RequestBox requestBox) throws Exception {
        return facilityInfoMapper.facilityInfoDetailOne(requestBox);
    }

    @Override
    public DataBox facilityInfoCheckType(RequestBox requestBox) throws Exception {
        return facilityInfoMapper.facilityInfoCheckType(requestBox);
    }

    @Override
    public List<DataBox> facilityInfoDetailDate(RequestBox requestBox) throws Exception {
        return facilityInfoMapper.facilityInfoDetailDate(requestBox);
    }

    @Override
    public int facilityInfoDetailPageListCount(RequestBox requestBox) throws Exception {
        return facilityInfoMapper.facilityInfoDetailPageListCount(requestBox);
    }

    @Override
    public List<DataBox> facilityInfoDetailPageList(RequestBox requestBox) throws Exception {
        return facilityInfoMapper.facilityInfoDetailPageList(requestBox);
    }

    //detail page list
    @Override
    public int facilityInfoDetailPageResListCount(RequestBox requestBox) throws Exception{
        return facilityInfoMapper.facilityInfoDetailPageResListCount(requestBox);
    }

    @Override
    public List<DataBox> facilityInfoDetailPageResList(RequestBox requestBox) throws Exception {
        return facilityInfoMapper.facilityInfoDetailPageResList(requestBox);
    }

    @Override
    public int facilityInfoDetailPageLimitListCount(RequestBox requestBox) throws Exception {
        return facilityInfoMapper.facilityInfoDetailPageLimitListCount(requestBox);
    }

    @Override
    public List<DataBox> facilityInfoDetailPageLimitList(RequestBox requestBox) throws Exception {
        return facilityInfoMapper.facilityInfoDetailPageLimitList(requestBox);
    }

    @Override
    public int facilityInfoDetailPageCancelListCount(RequestBox requestBox) throws Exception {
        return facilityInfoMapper.facilityInfoDetailPageCancelListCount(requestBox);
    }

    @Override
    public List<DataBox> facilityInfoDetailPageCancelList(RequestBox requestBox) throws Exception {
        return facilityInfoMapper.facilityInfoDetailPageCancelList(requestBox);
    }

    @Override
    public int facilityInfoDetailPageCookResListCount(RequestBox requestBox) throws Exception {
        return facilityInfoMapper.facilityInfoDetailPageCookResListCount(requestBox);
    }

    @Override
    public List<DataBox> facilityInfoDetailPageCookResList(RequestBox requestBox) throws Exception {
        return facilityInfoMapper.facilityInfoDetailPageCookResList(requestBox);
    }

    @Override
    public int facilityInfoDetailPageCookLimitListCount(RequestBox requestBox) throws Exception {
        return facilityInfoMapper.facilityInfoDetailPageCookLimitListCount(requestBox);
    }

    @Override
    public List<DataBox> facilityInfoDetailPageCookLimitList(RequestBox requestBox) throws Exception {
        return facilityInfoMapper.facilityInfoDetailPageCookLimitList(requestBox);
    }

    @Override
    public int facilityInfoDetailPageCookCancelListCount(RequestBox requestBox) throws Exception {
        return facilityInfoMapper.facilityInfoDetailPageCookCancelListCount(requestBox);
    }

    @Override
    public List<DataBox> facilityInfoDetailPageCookCancelList(RequestBox requestBox) throws Exception {
        return facilityInfoMapper.facilityInfoDetailPageCookCancelList(requestBox);
    }

    @Override
    public List<DataBox> facilityInfoDetailThreeCookTermList(RequestBox requestBox) throws Exception {
        return facilityInfoMapper.facilityInfoDetailThreeCookTermList(requestBox);
    }

    @Override
    public void cancelListDelete(RequestBox requestBox) throws Exception {
        facilityInfoMapper.cancelListDelete(requestBox);
        facilityInfoMapper.rsvroominfoUpdate(requestBox);
    }

	@Override
	public int facilityInfoAllSessionInsert(RequestBox requestBox) {
		// TODO Auto-generated method stub
		facilityInfoMapper.rsvroominfoUpdate(requestBox);
		return facilityInfoMapper.facilityInfoAllSessionInsert(requestBox);
	}

	@Override
	public int facilityInfoDetailOneInsertTypeSeq(RequestBox requestBox) {
		// TODO Auto-generated method stub
		String typeseq[] = requestBox.get("typeseq").split(",");
		int result = 0;
		for(int i=0;i<typeseq.length;i++){
			requestBox.put("typeseq", typeseq[i]);
			result = facilityInfoMapper.facilityInfoDetailOneInsertTypeSeq(requestBox);
		}
		return result;
	}

	@Override
	public int facilityInfoPartitionDetailDelete(RequestBox requestBox) {
		// TODO Auto-generated method stub
        facilityInfoMapper.rsvroominfoUpdate(requestBox);
		return facilityInfoMapper.facilityInfoPartitionDetailDelete(requestBox);
	}

	@Override
	public int facilityInfoDetailThreeDisDelete(RequestBox requestBox) {
		// TODO Auto-generated method stub
		return facilityInfoMapper.facilityInfoDetailThreeDisDelete(requestBox);
	}

	@Override
	public List<DataBox> facilityInfoDetailOneFile(RequestBox requestBox) {
		// TODO Auto-generated method stub
		return facilityInfoMapper.facilityInfoDetailOneFile(requestBox);
	}

    @Override
    public int facilityInfoSearchRsvInsert(RequestBox requestBox) {
        return facilityInfoMapper.facilityInfoSearchRsvInsert(requestBox);
    }

    @Override
    public String facilityInfoPartitionCheck(RequestBox requestBox) throws Exception {
        return facilityInfoMapper.facilityInfoPartitionCheck(requestBox);
    }

    @Override
    public String facilitySessionTypeCheck(RequestBox requestBox) throws Exception {
        return facilityInfoMapper.facilitySessionTypeCheck(requestBox);
    }

    @Override
    public DataBox facilityInfoPartitionOne(RequestBox requestBox) throws Exception {
        return facilityInfoMapper.facilityInfoPartitionOne(requestBox);
    }

    @Override
    public String facilityInfoRtnType(RequestBox requestBox) throws Exception {
        return facilityInfoMapper.facilityInfoRtnType(requestBox);
    }

    @Override
    public String facilityInfoSameCheck(RequestBox requestBox) throws Exception {
        return facilityInfoMapper.facilityInfoSameCheck(requestBox);
    }

    @Override
    public String facilitySessionPartitionCheck(RequestBox requestBox) throws Exception {
        return facilityInfoMapper.facilitySessionPartitionCheck(requestBox);
    }

    @Override
    public String facilityPartyCheck(RequestBox requestBox) throws Exception {
        return facilityInfoMapper.facilityPartyCheck(requestBox);
    }

    @Override
    public String facilityPartyTypeCheck(RequestBox requestBox) throws Exception {
        return facilityInfoMapper.facilityPartyTypeCheck(requestBox);
    }

    @Override
    public String facilityInfoRoleComparison(RequestBox requestBox) throws Exception {
        return facilityInfoMapper.facilityInfoRoleComparison(requestBox);
    }

    @Override
    public String facilityInfoDisComparison(RequestBox requestBox) throws Exception {
        return facilityInfoMapper.facilityInfoDisComparison(requestBox);
    }

    @Override
    public String facilityInfoCancelComparison(RequestBox requestBox) throws Exception {
        return facilityInfoMapper.facilityInfoCancelComparison(requestBox);
    }

    @Override
    public void facilityInfoPartitionInsert(RequestBox requestBox) throws Exception {
        Map<String, Object> fileMap = new HashMap<String, Object>();

        facilityInfoMapper.facilityInfoPartitionInsert(requestBox);

        for(int j=0; j < 10; j++){
            if(!requestBox.get("filekey"+(j+1)).toString().equals("0")) {
                fileMap.put("fileKey", requestBox.get("filekey" + (j + 1)));
                fileMap.put("altText", requestBox.get("alt" + (j + 1)));

                facilityInfoMapper.fileUpdate(fileMap);
            }
        }
    }

    @Override
    public int facilityinfoSearchSeq(RequestBox requestBox) throws Exception {
        return facilityInfoMapper.facilityinfoSearchSeq(requestBox);
    }

    @Override
    public int facilityinfoSearchSeqTwo(RequestBox requestBox) throws Exception {
        return facilityInfoMapper.facilityinfoSearchSeqTwo(requestBox);
    }

    @Override
    public void facilityInfoSessionInsert(RequestBox requestBox) throws Exception {
        facilityInfoMapper.facilityInfoSessionInsert(requestBox);
    }

    @Override
    public void facilityInfoRoomroleInsert(RequestBox requestBox) throws Exception {
        facilityInfoMapper.facilityInfoRoomroleInsert(requestBox);
    }

    @Override
    public void facilityInfotypemapInsert(RequestBox requestBox) throws Exception {
        facilityInfoMapper.facilityInfotypemapInsert(requestBox);
    }

    @Override
    public void facilityInfopenaltymapInsert(RequestBox requestBox) throws Exception {
        facilityInfoMapper.facilityInfopenaltymapInsert(requestBox);
    }

    @Override
    public void facilityInfoSeqaInsert(RequestBox requestBox) throws Exception {
        facilityInfoMapper.facilityInfoSeqaInsert(requestBox);
    }

    @Override
    public void facilityInfoSeqbInsert(RequestBox requestBox) throws Exception {
        facilityInfoMapper.facilityInfoSeqbInsert(requestBox);
    }

    @Override
    public void facilityInfoSeqInsert(RequestBox requestBox) throws Exception {
        facilityInfoMapper.facilityInfoSeqInsert(requestBox);
    }
}
