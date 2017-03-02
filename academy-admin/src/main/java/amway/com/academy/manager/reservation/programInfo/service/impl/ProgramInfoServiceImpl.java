package amway.com.academy.manager.reservation.programInfo.service.impl;

import amway.com.academy.manager.reservation.programInfo.service.ProgramInfoService;
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
public class ProgramInfoServiceImpl implements ProgramInfoService {

    @Autowired
    ProgramInfoMapper programInfoMapper;

    //list
    @Override
    public List<DataBox> programInfoList(RequestBox requestBox) throws Exception {
        return programInfoMapper.programInfoList(requestBox);
    }

    //list count
    @Override
    public int programInfoListCount(RequestBox requestBox) throws Exception {
        return programInfoMapper.programInfoListCount(requestBox);
    }

    public int programInsCheck(RequestBox requestBox) {
        return programInfoMapper.programInsCheck(requestBox);
    }

    //List ExcelDownLoad
    @Override
    public List<Map<String, String>> programInfoExcelDownload(RequestBox requestBox) throws Exception {
        return programInfoMapper.programInfoExcelDownload(requestBox);
    }

    //type - E01,E02
    @Override
    public List<DataBox> programInfoType(RequestBox requestBox) throws Exception {
        return programInfoMapper.programInfoType(requestBox);
    }

    //type - E03,E04
    @Override
    public List<DataBox> programInfoCheck(RequestBox requestBox) throws Exception {
        return programInfoMapper.programInfoCheck(requestBox);
    }

    @Override
    public List<DataBox> programInfoBrand(RequestBox requestBox) throws Exception {
        return programInfoMapper.programInfoBrand(requestBox);
    }

    @Override
    public List<DataBox> programInfoBrandDepth(RequestBox requestBox) throws Exception {
        return programInfoMapper.programInfoBrandDepth(requestBox);
    }

    //typaA insert
    @Override
    public int programInfoOneInsert(RequestBox requestBox) throws Exception {
        Map<String, Object> fileMap = new HashMap<String, Object>();
        int result = 0;

        String textValue = "";
        String intro = "";
        String comboValue = "";

        String contentText = "";
        String content = "";
        String contentCombo = "";

        for(int i=0;i< requestBox.getVector("ppseq").size();i++){

            textValue = java.util.regex.Matcher.quoteReplacement(StringUtil.htmlSpecialChar((String)requestBox.getVector("intro").get(0)));
            intro = "".equals(textValue) ? comboValue : textValue;
            requestBox.put("intro", intro);

            contentText = java.util.regex.Matcher.quoteReplacement(StringUtil.htmlSpecialChar((String)requestBox.getVector("content").get(0)));
            content = "".equals(contentText) ? contentCombo : contentText;
            requestBox.put("content", content);

            result = programInfoMapper.programInfoOneInsert(requestBox);
        }

        for(int j=0; j < 10; j++){
            if(!requestBox.get("filekey"+(j+1)).toString().equals("0")) {
                fileMap.put("fileKey", requestBox.get("filekey" + (j + 1)));
                fileMap.put("altText", requestBox.get("alt" + (j + 1)));

                programInfoMapper.fileUpdate(fileMap);
            }
        }

        return result;
    }

    @Override
    public int programInfoSearchRsvInsert(RequestBox requestBox) throws Exception {
        return programInfoMapper.programInfoSearchRsvInsert(requestBox);
    }

    @Override
    public int programInfoSeq(RequestBox requestBox) throws Exception {
        int result = programInfoMapper.programInfoSeq(requestBox);
        requestBox.put("expseq",result);
    	//공휴일추가
    	programInfoMapper.programInfoInsertHoliday(requestBox);
    	
        return result;
    }

    @Override
    public void programInfoDelete(RequestBox requestBox) throws Exception {
        programInfoMapper.programInfoDelete(requestBox);
    }

    @Override
    public void programInfoDeleteAll(RequestBox requestBox) throws Exception {
        programInfoMapper.programInfoDeleteAll(requestBox);
    }

    @Override
    public void programInfoInsert(RequestBox requestBox) throws Exception {
        programInfoMapper.programInfoInsert(requestBox);
        /**
	      * 최근 수정자를 보여 주기위해 마스터에 수정자 정보를 업데이트 한다.
	      */
        programInfoMapper.rsvexpinfoUpdate(requestBox);
    }

    @Override
    public void programInfoTwoUpdate(RequestBox requestBox) throws Exception {
    	programInfoMapper.programInfoTwoUpdate(requestBox);
	      /**
	      * 최근 수정자를 보여 주기위해 마스터에 수정자 정보를 업데이트 한다.
	      */
    	programInfoMapper.rsvexpinfoUpdate(requestBox);
    }

    @Override
    public int allSessionTypeSearch(RequestBox requestBox) throws Exception {
        return programInfoMapper.allSessionTypeSearch(requestBox);
    }

    @Override
    public void programinfoInsertRoomrole(RequestBox requestBox) throws Exception {
        programInfoMapper.programinfoInsertRoomrole(requestBox);
        /**
	      * 최근 수정자를 보여 주기위해 마스터에 수정자 정보를 업데이트 한다.
	      */
        programInfoMapper.rsvexpinfoUpdate(requestBox);
    }

    @Override
    public DataBox programInfoTwoSeq(RequestBox requestBox) throws Exception {
        return programInfoMapper.programInfoTwoSeq(requestBox);
    }

    @Override
    public List<DataBox> programInfoSelectWeek(RequestBox requestBox) throws Exception {
        return programInfoMapper.programInfoSelectWeek(requestBox);
    }

    @Override
    public void programInfoInsertEarly(RequestBox requestBox) throws Exception {
        programInfoMapper.programInfoInsertEarly(requestBox);
        /**
	      * 최근 수정자를 보여 주기위해 마스터에 수정자 정보를 업데이트 한다.
	      */
       programInfoMapper.rsvexpinfoUpdate(requestBox);
    }

    @Override
    public List<DataBox> programInfoDetailTwoList(RequestBox requestBox) throws Exception {
        return programInfoMapper.programInfoDetailTwoList(requestBox);
    }

    @Override
    public List<DataBox> checkList(RequestBox requestBox) throws Exception {
        return programInfoMapper.checkList(requestBox);
    }

    @Override
    public List<DataBox> rsvCheckList(RequestBox requestBox) throws Exception {
        return programInfoMapper.rsvCheckList(requestBox);
    }

    @Override
    public void programInfoEarlyDel(RequestBox requestBox) throws Exception {
    	programInfoMapper.programInfoEarlyDel(requestBox);
    	/**
	      * 최근 수정자를 보여 주기위해 마스터에 수정자 정보를 업데이트 한다.
	      */
        programInfoMapper.rsvexpinfoUpdate(requestBox);
    }

    @Override
    public DataBox programInfoDetailSessionPop(RequestBox requestBox) throws Exception {
        return programInfoMapper.programInfoDetailSessionPop(requestBox);
    }

    @Override
    public List<DataBox> programInfoDetailTwoPreview(RequestBox requestBox) throws Exception {
        return programInfoMapper.programInfoDetailTwoPreview(requestBox);
    }

    //res list - age
    @Override
    public List<DataBox> programInfoDetailPinInfo(RequestBox requestBox) throws Exception {
        return programInfoMapper.programInfoDetailPinInfo(requestBox);
    }

    //res list - age
    @Override
    public List<DataBox> programInfoDetailAgeInfo(RequestBox requestBox) throws Exception {
        return programInfoMapper.programInfoDetailAgeInfo(requestBox);
    }

    //res list - area
    @Override
    public List<DataBox> programInfoDetailAreaInfo(RequestBox requestBox) throws Exception {
        return programInfoMapper.programInfoDetailAreaInfo(requestBox);
    }

    //res list - special
    @Override
    public List<DataBox> programInfoDetailSpecialInfo(RequestBox requestBox) throws Exception {
        return programInfoMapper.programInfoDetailSpecialInfo(requestBox);
    }

    //res list - combo
    @Override
    public List<DataBox> codeCombo(RequestBox requestBox) throws Exception {
        return programInfoMapper.codeCombo(requestBox);
    }

    //res pop session list
    @Override
    public List<DataBox> programInfoDetailSession(RequestBox requestBox) throws Exception {
        return programInfoMapper.programInfoDetailSession(requestBox);
    }

    //limit - insert
    @Override
    public void programInfoDetailTermInsert(RequestBox requestBox) throws Exception {
        programInfoMapper.programInfoDetailTermInsert(requestBox);
        /**
	      * 최근 수정자를 보여 주기위해 마스터에 수정자 정보를 업데이트 한다.
	      */
       programInfoMapper.rsvexpinfoUpdate(requestBox);
    }

    // all session - save
    @Override
    public void programInfoAllSessionInsert(RequestBox requestBox) throws Exception {
        programInfoMapper.programInfoAllSessionInsert(requestBox);
        /**
	      * 최근 수정자를 보여 주기위해 마스터에 수정자 정보를 업데이트 한다.
	      */
       programInfoMapper.rsvexpinfoUpdate(requestBox);
    }

    //term list
    @Override
    public List<DataBox> programInfoDetailTermList(RequestBox requestBox) throws Exception {
        return programInfoMapper.programInfoDetailTermList(requestBox);
    }

    @Override
    public void termListDelete(RequestBox requestBox) throws Exception {
        programInfoMapper.termListDelete(requestBox);
        /**
	      * 최근 수정자를 보여 주기위해 마스터에 수정자 정보를 업데이트 한다.
	      */
        programInfoMapper.rsvexpinfoUpdate(requestBox);
    }

    @Override
    public List<DataBox> programInfoDetailDisPopList(RequestBox requestBox) throws Exception{
        return programInfoMapper.programInfoDetailDisPopList(requestBox);
    }

    @Override
    public void programInfoDetailDisInsert(RequestBox requestBox) throws Exception {
        programInfoMapper.programInfoDetailDisInsert(requestBox);
        /**
	      * 최근 수정자를 보여 주기위해 마스터에 수정자 정보를 업데이트 한다.
	      */
        programInfoMapper.rsvexpinfoUpdate(requestBox);
    }

    @Override
    public List<DataBox> programInfoDetailDisList(RequestBox requestBox) throws Exception {
        return programInfoMapper.programInfoDetailDisList(requestBox);
    }

    @Override
    public void disListDelete(RequestBox requestBox) throws Exception {
        programInfoMapper.disListDelete(requestBox);
        /**
	      * 최근 수정자를 보여 주기위해 마스터에 수정자 정보를 업데이트 한다.
	      */
        programInfoMapper.rsvexpinfoUpdate(requestBox);
    }

    @Override
    public List<DataBox> programInfoDetailThreeCancelPopList(RequestBox requestBox) throws Exception {
        return programInfoMapper.programInfoDetailThreeCancelPopList(requestBox);
    }

    @Override
    public void programInfoDetailCancelInsert(RequestBox requestBox) throws Exception {
        programInfoMapper.programInfoDetailCancelInsert(requestBox);
        /**
	      * 최근 수정자를 보여 주기위해 마스터에 수정자 정보를 업데이트 한다.
	      */
       programInfoMapper.rsvexpinfoUpdate(requestBox);
    }

    @Override
    public List<DataBox> programInfoDetailCancelList(RequestBox requestBox) throws Exception {
        return programInfoMapper.programInfoDetailCancelList(requestBox);
    }

    @Override
    public void cancelListDelete(RequestBox requestBox) throws Exception {
        programInfoMapper.cancelListDelete(requestBox);
        /**
	      * 최근 수정자를 보여 주기위해 마스터에 수정자 정보를 업데이트 한다.
	      */
        programInfoMapper.rsvexpinfoUpdate(requestBox);
    }

    @Override
    public DataBox exptypecheck(RequestBox requestBox) throws Exception {
        return programInfoMapper.exptypecheck(requestBox);
    }

    @Override
    public DataBox programInfoDetailOne(RequestBox requestBox) throws Exception {
        return programInfoMapper.programInfoDetailOne(requestBox);
    }

    @Override
    public List<DataBox> programInfoDetailDate(RequestBox requestBox) throws Exception {
        return programInfoMapper.programInfoDetailDate(requestBox);
    }


    @Override
    public List<DataBox> checkdetail(RequestBox requestBox) throws Exception {
        return programInfoMapper.checkdetail(requestBox);
    }

    @Override
    public int programInfoUpdate(RequestBox requestBox) throws Exception {
        Map<String, Object> fileMap = new HashMap<String, Object>();
        int result = 0;
        
        programInfoMapper.programInfoUpdate(requestBox);

        for(int j=0; j < 10; j++){
            if(!requestBox.get("filekey"+(j+1)).toString().equals("0")) {
                fileMap.put("fileKey", requestBox.get("filekey" + (j + 1)));
                fileMap.put("altText", requestBox.get("alt" + (j + 1)));

                programInfoMapper.fileUpdate(fileMap);
            }
        }
        
        return result;
    }

	@Override
	public List<DataBox> selectcategorytypelist(RequestBox requestBox) {
		// TODO Auto-generated method stub
		return programInfoMapper.selectcategorytypelist(requestBox);
	}

    @Override
    public List<DataBox> programInfoDetailOneFile(RequestBox requestBox) throws Exception {
        return programInfoMapper.programInfoDetailOneFile(requestBox);
    }

    @Override
    public List<DataBox> programInfoDetailOtherFile(RequestBox requestBox) throws Exception {
        return programInfoMapper.programInfoDetailOtherFile(requestBox);
    }

}
