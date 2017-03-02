package amway.com.academy.manager.reservation.facilityInfo.service;

import framework.com.cmm.lib.DataBox;
import framework.com.cmm.lib.RequestBox;

import javax.xml.crypto.Data;

import java.util.List;
import java.util.Map;

/**
 * Created by KR620248 on 2016-08-08.
 */
public interface FacilityInfoService {

    /**
     * 시설정보 리스트
     * @param requestBox
     * @throws Exception
     */
    public List<DataBox> facilityInfoList(RequestBox requestBox) throws Exception;

    /**
     * 시설정보 리스트 카운트
     * @param requestBox
     * @throws Exception
     */
    public int facilityInfoListCount(RequestBox requestBox) throws Exception;

    //시설정보 Excel  다운로드
    public List<Map<String, String>> facilityinfoExcelDownload(RequestBox requestBox) throws Exception;

    /**
     * 코드관리 분류리스트
     * @param requestBox
     * @return
     * @throws Exception
     */
    public List<DataBox> codeCombo(RequestBox requestBox) throws Exception;

    /**
     * 시설정보 시설타입
     * @param requestBox
     * @return
     * @throws Exception
     */
    public List<DataBox> rsvType(RequestBox requestBox) throws Exception;

    /**
     * 시설정보 시설타입 - 수정
     * @param requestBox
     * @return
     * @throws Exception
     */
    public List<DataBox> updateType(RequestBox requestBox) throws Exception;

    /**
     * 시설정보 디테일 리스트 One 저장
     * @param requestBox
     * @throws Exception
     */
    public int facilityInfoDetailOneInsert(RequestBox requestBox) throws Exception;

    /**
     * 시설정보 디테일 리스트 One - 타입찾기
     * @param requestBox
     * @throws Exception
     */
    public DataBox typesearch(RequestBox requestBox) throws Exception;

    /**
     * 시설정보 디테일 리스트 One Seq 셀렉트
     * @param requestBox
     * @throws Exception
     */
    public int facilityInfoDetailOneSeq(RequestBox requestBox) throws Exception;

    /**
     * 시설정보 디테일 One 파티션룸 찾기
     * @param requestBox
     * @throws Exception
     */
    public DataBox ptype(RequestBox requestBox) throws Exception;

    /**
     * 시설정보 디테일 리스트 One 수정
     * @param requestBox
     * @throws Exception
     */
    public int facilityInfoDetailOneUpdate(RequestBox requestBox) throws Exception;

    /**
     * 시설정보 디테일 Two 요일삭제:일별
     * @param requestBox
     * @throws Exception
     */
    public void facilityInfoDelete(RequestBox requestBox) throws Exception;

    /**
     * 시설정보 디테일 Two 요일삭제:전체
     * @param requestBox
     * @throws Exception
     */
    public void facilityInfoDeleteAll(RequestBox requestBox) throws Exception;

    /**
     * 시설정보 디테일 Two 요일저장:일별
     * @param requestBox
     * @throws Exception
     */
    public void facilityInfoInsert(RequestBox requestBox) throws Exception;
    /**
     * 시설정보 디테일 Two 요일저장:일별
     * @param requestBox
     * @throws Exception
     */
    public void facilityInfoUpdate(RequestBox requestBox) throws Exception;

    /**
     * 시설정보 디테일 Two 리스트 셀렉트: 월
     * @param requestBox
     * @throws Exception
     */
    public List<DataBox> facilityInfoSelectWeek(RequestBox requestBox) throws Exception;

    /**
     * 시설정보 디테일 Two  - 운영일/휴무일 rsvroomrole 테이블에 모든세션이 있는지 찾기.
     * @param requestBox
     * @throws Exception
     */
    public int allSessionTypeSearch(RequestBox requestBox) throws Exception;

    /**
     * 시설정보 디테일 Two 팝업:운영일저장
     * @param requestBox
     * @throws Exception
     */
    public void facilityInfoInsertEarly(RequestBox requestBox) throws Exception;

    /**
     * 시설정보 디테일 Two 팝업:운영일저장 rsvsessionseq rsvroomrole table에 넣기.
     * @param requestBox
     * @throws Exception
     */
    public void facilityinfoInsertRoomrole(RequestBox requestBox) throws Exception;

    /**
     * 시설정보 디테일 Two :삭제
     * @param requestBox
     * @throws Exception
     */
    public void facilityInfoEarlyDel(RequestBox requestBox) throws Exception;

    /**
     * 시설정보 디테일 Two 팝업:날짜 중복체크
     * @param requestBox
     * @throws Exception
     */
    public DataBox facilityInfoDetailTwoDateCheck(RequestBox requestBox) throws Exception;

    /**
     * 시설정보 디테일 Two 리스트
     * @param requestBox
     * @throws Exception
     */
    public List<DataBox> facilityInfoDetailTwoList(RequestBox requestBox) throws Exception;

    /**
     * 시설정보 디테일 Two 팝업
     * @param requestBox
     * @throws Exception
     */
    public DataBox facilityInfoDetailSessionPop(RequestBox requestBox) throws Exception;

    /**
     * 시설정보 디테일 Two 미리보기
     * @param requestBox
     * @throws Exception
     */
    public List<DataBox> facilityInfoDetailTwoPreview(RequestBox requestBox) throws Exception;

    /**
     * 시설정보 디테일 Two 요리명장여부 판별
     * @param requestBox
     * @throws Exception
     */
    public DataBox cookType(RequestBox requestBox) throws Exception;

    /**
     * 우선운영일/휴일 체크
     * @param requestBox
     * @throws Exception
     */
    public List<DataBox> checkList(RequestBox requestBox) throws Exception;

    /**
     * 우선운영일/휴일 체크
     * @param requestBox
     * @throws Exception
     */
    public List<DataBox> rsvCheckList(RequestBox requestBox) throws Exception;

    /**
     * 시설정보 디테일 Two 시설타입 체크
     * @param requestBox
     * @throws Exception
     */
    public DataBox facilityType(RequestBox requestBox) throws Exception;

    /**
     * 시설정보 디테일 Three 팝업 지역군정보
     * @param requestBox
     * @throws Exception
     */
    public List<DataBox> facilityInfoDetailThreeAreaInfo(RequestBox requestBox) throws Exception;

    /**
     * 시설정보 디테일 Three 팝업 핀정보
     * @param requestBox
     * @throws Exception
     */
    public List<DataBox> facilityInfoDetailThreePinInfo(RequestBox requestBox) throws Exception;

    /**
     * 시설정보 디테일 Three 팝업 나이정보
     * @param requestBox
     * @throws Exception
     */
    public List<DataBox> facilityInfoDetailThreeAgeInfo(RequestBox requestBox) throws Exception;

    /**
     * 시설정보 디테일 Three 팝업 특정대상자정보
     * @param requestBox
     * @throws Exception
     */
    public List<DataBox> facilityInfoDetailThreeSpecialInfo(RequestBox requestBox) throws Exception;

    /**
     * 시설정보 디테일 Three 팝업 특정대상자정보 - 요리명장
     * @param requestBox
     * @throws Exception
     */
    List<DataBox> facilityInfoDetailThreeSpecialCookInfo(RequestBox requestBox) throws Exception;
    /**
     * 시설정보 디테일 Two 리스트
     * @param requestBox
     * @throws Exception
     */
    public List<DataBox> facilityInfoDetailThreeSession(RequestBox requestBox) throws Exception;

    /**
     * 시설정보 디테일 Three 팝업 등록
     * @param requestBox
     * @throws Exception
     */
    public void facilityInfoDetailThreeTermInsert(RequestBox requestBox) throws Exception;

    /**
     * 시설정보 디테일 Three 팝업 모든세션등록
     * @param requestBox
     * @throws Exception
     */
    public List<DataBox> facilityInfoAllSession(RequestBox requestBox) throws Exception;

    /**
     * 시설정보 디테일 Three 예약자격/기간 리스트
     * @param requestBox
     * @throws Exception
     */
    public List<DataBox> facilityInfoDetailThreeTermList(RequestBox requestBox) throws Exception;

    /**
     * 시설정보 디테일 Three 누적 예약 제한 리스트 - 삭제
     * @param requestBox
     * @throws Exception
     */
    public void termListDelete(RequestBox requestBox) throws Exception;

    /**
     * 시설정보 디테일 Three 누적예약제한 팝업 리스트
     * @param requestBox
     * @throws Exception
     */
    public List<DataBox> facilityInfoDetailThreeDisPopList(RequestBox requestBox) throws Exception;

    /**
     * 시설정보 디테일 Three 누적예약제한 팝업 등록
     * @param requestBox
     * @throws Exception
     */
    public int facilityInfoDetailThreeDisInsert(RequestBox requestBox) throws Exception;

    /**
     * 시설정보 디테일 Three 누적예약제한 리스트
     * @param requestBox
     * @throws Exception
     */
    public List<DataBox> facilityInfoDetailThreeDisList(RequestBox requestBox) throws Exception;

    /**
     * 시설정보 디테일 Three 누적 예약 제한 리스트 - 삭제
     * @param requestBox
     * @throws Exception
     */
    public void disListDelete(RequestBox requestBox) throws Exception;

    /**
     * 시설정보 디테일 Three 취소패널티 팝업 리스트
     * @param requestBox
     * @throws Exception
     */
    public List<DataBox> facilityInfoDetailThreeCancelPopList(RequestBox requestBox) throws Exception;

    /**
     * 시설정보 디테일 Three 취소패널티 팝업 리스트 - 요리명장
     * @param requestBox
     * @throws Exception
     */
    public List<DataBox> facilityInfoDetailThreeCookCancelPopList(RequestBox requestBox) throws Exception;

    /**
     *   시설정보 디테일 Three 취소패널티 팝업 저장
     * //@param RequestBox requestBox
     * //@param ModelAndView mav
     *   @return ModelAndView
     *   @throws Exception
     */
    public void facilityInfoDetailThreeCancelInsert(RequestBox requestBox) throws Exception;

    /**
     * 시설정보 디테일 Three 취소패널티 리스트
     * @param requestBox
     * @throws Exception
     */
    public List<DataBox> facilityInfoDetailThreeCancelList(RequestBox requestBox) throws Exception;

    /**
     * 시설정보 디테일 Three 취소예약 제한 리스트 - 삭제
     * @param requestBox
     * @throws Exception
     */
    public void facilityInfoDetailThreeCancelDelete(RequestBox requestBox) throws Exception;

    /**
     * 시설정보 파티룸 데이터 비교
     * @param requestBox
     * @throws Exception
     */
    public List<DataBox> comparedataa (RequestBox requestBox) throws Exception;

    /**
     * 시설정보 파티룸 데이터 비교
     * @param requestBox
     * @throws Exception
     */
    public List<DataBox> comparedatab (RequestBox requestBox) throws Exception;

    /**
     * 시설정보 디테일 원
     * @param requestBox
     * @throws Exception
     */
	public DataBox facilityInfoDetailOne(RequestBox requestBox) throws Exception;

    /**
     * 시설정보 디테일 원 - 시설타입 갯수 체크.
     * @param requestBox
     * @throws Exception
     */
    public DataBox facilityInfoCheckType(RequestBox requestBox) throws Exception;

	/**
     * 시설정보 디테일 원  - 월요일
     * @param requestBox
     * @throws Exception
     */
	public List<DataBox> facilityInfoDetailDate(RequestBox requestBox)throws Exception;


	/**
     * 시설정보 디테일 페이지
     * @param requestBox
     * @throws Exception
     */
    public int facilityInfoDetailPageListCount(RequestBox requestBox) throws Exception;

    public List<DataBox> facilityInfoDetailPageList(RequestBox requestBox) throws Exception;

	public int facilityInfoDetailPageResListCount(RequestBox requestBox)throws Exception;

	public List<DataBox> facilityInfoDetailPageResList(RequestBox requestBox) throws Exception;

	public int facilityInfoDetailPageLimitListCount(RequestBox requestBox) throws Exception;

	public List<DataBox> facilityInfoDetailPageLimitList(RequestBox requestBox) throws Exception;

	public int facilityInfoDetailPageCancelListCount(RequestBox requestBox) throws Exception;

	public List<DataBox> facilityInfoDetailPageCancelList(RequestBox requestBox) throws Exception;

	public int facilityInfoDetailPageCookResListCount(RequestBox requestBox) throws Exception;

	public List<DataBox> facilityInfoDetailPageCookResList(RequestBox requestBox) throws Exception;

	public int facilityInfoDetailPageCookLimitListCount(RequestBox requestBox) throws Exception;

	public List<DataBox> facilityInfoDetailPageCookLimitList(RequestBox requestBox) throws Exception;

	public int facilityInfoDetailPageCookCancelListCount(RequestBox requestBox) throws Exception;

    public List<DataBox> facilityInfoDetailPageCookCancelList(RequestBox requestBox) throws Exception;

    public List<DataBox> facilityInfoDetailThreeCookTermList(RequestBox requestBox) throws Exception;

    public void cancelListDelete(RequestBox requestBox) throws Exception;

	public int facilityInfoAllSessionInsert(RequestBox requestBox);

	public int facilityInfoDetailOneInsertTypeSeq(RequestBox requestBox);

	public int facilityInfoPartitionDetailDelete(RequestBox requestBox);

	public int facilityInfoDetailThreeDisDelete(RequestBox requestBox);

	public List<DataBox> facilityInfoDetailOneFile(RequestBox requestBox);

    public int facilityInfoSearchRsvInsert(RequestBox requestBox);

    public String facilityInfoPartitionCheck(RequestBox requestBox) throws Exception;

    public String facilitySessionTypeCheck(RequestBox requestBox) throws Exception;

    public DataBox facilityInfoPartitionOne(RequestBox requestBox) throws Exception;

    public String facilityInfoRtnType(RequestBox requestBox) throws Exception;

    public String facilityInfoSameCheck(RequestBox requestBox) throws Exception;

    public String facilitySessionPartitionCheck(RequestBox requestBox) throws Exception;

    public String facilityPartyCheck(RequestBox requestBox) throws Exception;

    public String facilityPartyTypeCheck(RequestBox requestBox) throws Exception;

    public String facilityInfoRoleComparison(RequestBox requestBox) throws Exception;

    public String facilityInfoDisComparison(RequestBox requestBox) throws Exception;

    public String facilityInfoCancelComparison(RequestBox requestBox) throws Exception;

    //파티션룸
    public void facilityInfoPartitionInsert(RequestBox requestBox) throws Exception;

    public int facilityinfoSearchSeq(RequestBox requestBox) throws Exception;

    public int facilityinfoSearchSeqTwo(RequestBox requestBox) throws Exception;

    //조건 , 및 다른 테이블 insert
    public void facilityInfoSessionInsert(RequestBox requestBox) throws Exception;

    public void facilityInfoRoomroleInsert(RequestBox requestBox) throws Exception;

    public void facilityInfotypemapInsert(RequestBox requestBox) throws Exception;

    public void facilityInfopenaltymapInsert(RequestBox requestBox) throws Exception;

    //파티션룸 인서트
    public void facilityInfoSeqaInsert(RequestBox requestBox) throws Exception;

    public void facilityInfoSeqbInsert(RequestBox requestBox) throws Exception;

    public void facilityInfoSeqInsert(RequestBox requestBox) throws Exception;

}

