package amway.com.academy.manager.reservation.facilityInfo.service.impl;

import egovframework.rte.psl.dataaccess.mapper.Mapper;
import framework.com.cmm.lib.DataBox;
import framework.com.cmm.lib.RequestBox;

import java.util.List;
import java.util.Map;

/**
 * Created by KR620248 on 2016-08-08.
 */
@Mapper
public interface FacilityInfoMapper {
    /**
     * 시설정보 디테일 리스트
     * @param requestBox
     * @throws Exception
     */
    List<DataBox> facilityInfoList(RequestBox requestBox) throws Exception;

    int facilityInfoDetailOneSeq(RequestBox requestBox) throws Exception;

    List<Map<String,String>> facilityinfoExcelDownload(RequestBox requestBox) throws Exception;

    int facilityInfoListCount(RequestBox requestBox) throws Exception;

    List<DataBox> codeCombo(RequestBox requestBox) throws Exception;

    List<DataBox> rsvType(RequestBox requestBox) throws Exception;

    List<DataBox> updateType(RequestBox requestBox) throws Exception;

    DataBox ptype(RequestBox requestBox) throws Exception;

    int facilityInfoDetailOneUpdate(RequestBox requestBox) throws Exception;

    int fileUpdate(Map<String, Object> map);

    /**
     * 시설정보 디테일 리스트 Two
     * @param requestBox
     * @throws Exception
     */
    int facilityInfoDetailOneInsert(RequestBox requestBox) throws Exception;

    DataBox typesearch(RequestBox requestBox) throws Exception;

    void facilityInfoDelete(RequestBox requestBox) throws Exception;

    void facilityInfoDeleteAll(RequestBox requestBox) throws Exception;

    void facilityInfoInsert(RequestBox requestBox) throws Exception;

    void facilityInfoUpdate(RequestBox requestBox) throws Exception;

    List<DataBox> facilityInfoSelectWeek(RequestBox requestBox) throws Exception;

    /**
     * 시설정보 디테일 리스트 Two 운영일 휴무일 지정
     * @param requestBox
     * @throws Exception
     */
    void facilityInfoInsertEarly(RequestBox requestBox) throws Exception;
    
    //공휴일 입력
    void facilityInfoInsertHoliday(RequestBox requestBox) throws Exception;

    //모든세션 찾기.
    int allSessionTypeSearch(RequestBox requestBox) throws Exception;

    //모든세션 있으면 roomrole table에 insert
    void facilityinfoInsertRoomrole(RequestBox requestBox) throws Exception;

    void facilityInfoEarlyDel(RequestBox requestBox) throws Exception;

    List<DataBox> facilityInfoDetailTwoList(RequestBox requestBox) throws Exception;

    void facilityInfoSessionDel(RequestBox requestBox) throws Exception;

    DataBox facilityInfoDetailSessionPop(RequestBox requestBox) throws Exception; //팝업

    List<DataBox> facilityInfoDetailTwoPreview(RequestBox requestBox) throws Exception; //미리보기

    DataBox facilityInfoDetailTwoDateCheck(RequestBox requestBox) throws Exception;

    DataBox cookType(RequestBox requestBox) throws Exception; //요리명장 여부

    List<DataBox> checkList(RequestBox requestBox) throws Exception; //요리명장 여부

    List<DataBox> rsvCheckList(RequestBox requestBox) throws Exception; //요리명장 여부

    DataBox facilityType(RequestBox requestBox) throws Exception; //시설타입 체크

    List<DataBox> facilityInfoDetailThreeAreaInfo(RequestBox requestBox) throws Exception;

    List<DataBox> facilityInfoDetailThreePinInfo(RequestBox requestBox) throws Exception;

    List<DataBox> facilityInfoDetailThreeAgeInfo(RequestBox requestBox) throws Exception;

    List<DataBox> facilityInfoDetailThreeSpecialInfo(RequestBox requestBox) throws Exception;

    List<DataBox> facilityInfoDetailThreeSpecialCookInfo(RequestBox requestBox) throws Exception;

    List<DataBox> facilityInfoDetailThreeSession(RequestBox requestBox) throws Exception;

    void facilityInfoDetailThreeTermInsert(RequestBox requestBox) throws Exception;

    List<DataBox> facilityInfoAllSession(RequestBox requestBox) throws Exception;

    List<DataBox> facilityInfoDetailThreeTermList(RequestBox requestBox) throws Exception;

    void termListDelete(RequestBox requestBox) throws Exception;

    List<DataBox> facilityInfoDetailThreeDisPopList(RequestBox requestBox) throws Exception;

    int facilityInfoDetailThreeDisInsert(RequestBox requestBox) throws Exception;

    List<DataBox> facilityInfoDetailThreeDisList(RequestBox requestBox) throws Exception;

    void disListDelete(RequestBox requestBox) throws Exception;

    List<DataBox> facilityInfoDetailThreeCancelPopList(RequestBox requestBox) throws Exception;

    List<DataBox> facilityInfoDetailThreeCookCancelPopList(RequestBox requestBox) throws Exception;

    void facilityInfoDetailThreeCancelInsert(RequestBox requestBox) throws Exception;

    List<DataBox> facilityInfoDetailThreeCancelList(RequestBox requestBox) throws Exception;

    void cancelListDelete(RequestBox requestBox) throws Exception;

    void facilityInfoDetailThreeCancelDelete(RequestBox requestBox) throws Exception;

    List<DataBox> comparedataa(RequestBox requestBox) throws Exception;

    List<DataBox> comparedatab(RequestBox requestBox) throws Exception;

    DataBox facilityInfoDetailOne(RequestBox requestBox) throws Exception;

    DataBox facilityInfoCheckType(RequestBox requestBox) throws Exception;

    List<DataBox> facilityInfoDetailDate(RequestBox requestBox)throws Exception;

    //detail page
    int facilityInfoDetailPageListCount(RequestBox requestBox) throws Exception;

    List<DataBox> facilityInfoDetailPageList(RequestBox requestBox) throws Exception;

    int facilityInfoDetailPageResListCount(RequestBox requestBox)throws Exception;

    List<DataBox> facilityInfoDetailPageResList(RequestBox requestBox)throws Exception;

    int facilityInfoDetailPageLimitListCount(RequestBox requestBox)throws Exception;

    List<DataBox> facilityInfoDetailPageLimitList(RequestBox requestBox)throws Exception;

    int facilityInfoDetailPageCancelListCount(RequestBox requestBox)throws Exception;

    List<DataBox> facilityInfoDetailPageCancelList(RequestBox requestBox)throws Exception;

    int facilityInfoDetailPageCookResListCount(RequestBox requestBox)throws Exception;

    List<DataBox> facilityInfoDetailPageCookResList(RequestBox requestBox)throws Exception;

    int facilityInfoDetailPageCookLimitListCount(RequestBox requestBox)throws Exception;

    List<DataBox> facilityInfoDetailPageCookLimitList(RequestBox requestBox)throws Exception;

    int facilityInfoDetailPageCookCancelListCount(RequestBox requestBox)throws Exception;

    List<DataBox> facilityInfoDetailPageCookCancelList(RequestBox requestBox)throws Exception;

    List<DataBox> facilityInfoDetailThreeCookTermList(RequestBox requestBox) throws Exception;

	int facilityInfoAllSessionInsert(RequestBox requestBox);

	int facilityInfoDetailOneInsertTypeSeq(RequestBox requestBox);

	int facilityInfoPartitionDetailDelete(RequestBox requestBox);

	int facilityInfoDetailThreeDisDelete(RequestBox requestBox);

	List<DataBox> facilityInfoDetailOneFile(RequestBox requestBox);

    int facilityInfoSearchRsvInsert(RequestBox requestBox);

    String facilityInfoPartitionCheck(RequestBox requestBox) throws Exception;

    String facilitySessionTypeCheck(RequestBox requestBox) throws Exception;

    DataBox facilityInfoPartitionOne(RequestBox requestBox) throws Exception;

    String facilityInfoRtnType(RequestBox requestBox) throws Exception;

    String facilityInfoSameCheck(RequestBox requestBox) throws Exception;

    String facilitySessionPartitionCheck(RequestBox requestBox) throws Exception;

    String facilityPartyCheck(RequestBox requestBox) throws Exception;

    String facilityPartyTypeCheck(RequestBox requestBox) throws Exception;

    String facilityInfoRoleComparison(RequestBox requestBox) throws Exception;

    String facilityInfoDisComparison(RequestBox requestBox) throws Exception;

    String facilityInfoCancelComparison(RequestBox requestBox) throws Exception;

    void facilityInfoPartitionInsert(RequestBox requestBox)throws Exception;

    int facilityinfoSearchSeq(RequestBox requestBox) throws Exception;

    int facilityinfoSearchSeqTwo(RequestBox requestBox) throws Exception;

    //조건 및 다른 테이블 insert
    void facilityInfoSessionInsert(RequestBox requestBox) throws Exception;

    void facilityInfoRoomroleInsert(RequestBox requestBox) throws Exception;

    void facilityInfotypemapInsert(RequestBox requestBox) throws Exception;

    void facilityInfopenaltymapInsert(RequestBox requestBox) throws Exception;

    //파티션룸 인서트트
    void facilityInfoSeqaInsert(RequestBox requestBox) throws Exception;

    void facilityInfoSeqbInsert(RequestBox requestBox) throws Exception;

    void facilityInfoSeqInsert(RequestBox requestBox) throws Exception;

	void rsvroominfoUpdate(RequestBox requestBox);
}
