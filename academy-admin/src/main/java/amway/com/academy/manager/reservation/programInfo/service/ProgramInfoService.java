package amway.com.academy.manager.reservation.programInfo.service;

import framework.com.cmm.lib.DataBox;
import framework.com.cmm.lib.RequestBox;

import javax.xml.crypto.Data;

import java.util.List;
import java.util.Map;

/**
 * Created by KR620248 on 2016-08-08.
 */
public interface ProgramInfoService {

    /**
     * 프로그램정보 리스트
     * @param requestBox
     * @throws Exception
     */
    public List<DataBox> programInfoList(RequestBox requestBox) throws Exception;

    /**
     * 프로그램정보 리스트 카운트
     * @param requestBox
     * @throws Exception
     */
    public int programInfoListCount(RequestBox requestBox) throws Exception;

    public int programInsCheck(RequestBox requestBox);
    /**
     * 프로그램정보 Excel  다운로드
     * @param requestBox
     * @throws Exception
     */
    public List<Map<String, String>> programInfoExcelDownload(RequestBox requestBox) throws Exception;

    /**
     * 측정프로그램 리스트 - 피부측정,체성분측정
     * @param requestBox
     * @throws Exception
     */
    public List<DataBox> programInfoType(RequestBox requestBox) throws Exception;

    /**
     * 측정프로그램 리스트 - 문화체험,브랜드체험
     * @param requestBox
     * @throws Exception
     */
    public List<DataBox> programInfoCheck(RequestBox requestBox) throws Exception;

    /**
     * 측정프로그램 리스트 - 브랜드체험
     * @param requestBox
     * @throws Exception
     */
    public List<DataBox> programInfoBrand(RequestBox requestBox) throws Exception;

    /**
     * 측정프로그램 리스트 - 브랜드체험 선택시 - 3depth
     * @param requestBox
     * @throws Exception
     */
    public List<DataBox> programInfoBrandDepth(RequestBox requestBox) throws Exception;

    /**
     * 측정프로그램 등록
     * @param requestBox
     * @throws Exception
     */
    public int programInfoOneInsert(RequestBox requestBox) throws Exception;

    /**
     * 검색키워드 등록
     * @param requestBox
     * @throws Exception
     */
    public int programInfoSearchRsvInsert(RequestBox requestBox) throws Exception;

    /**
     * 시퀀스 셋팅
     * @param requestBox
     * @throws Exception
     */
    int programInfoSeq(RequestBox requestBox) throws Exception;

    /**
     * 프로그램정보 디테일 Two 요일삭제:일별
     * @param requestBox
     * @throws Exception
     */
    void programInfoDelete(RequestBox requestBox) throws Exception;

    /**
     * 프로그램정보 디테일 Two 요일삭제:전체
     * @param requestBox
     * @throws Exception
     */
    void programInfoDeleteAll(RequestBox requestBox) throws Exception;

    /**
     * 프로그램정보 디테일 Two 요일등록
     * @param requestBox
     * @throws Exception
     */
    public void programInfoInsert(RequestBox requestBox) throws Exception;

    /**
     * 프로그램정보 디테일 Two 요일등록
     * @param requestBox
     * @throws Exception
     */
    public void programInfoTwoUpdate(RequestBox requestBox) throws Exception;

    /**
     * 프로그램정보 디테일 Two 모든세션여부
     * @param requestBox
     * @throws Exception
     */
    public int allSessionTypeSearch(RequestBox requestBox) throws Exception;

    /**
     * 프로그램정보 디테일 Two 자격테이블 insert
     * @param requestBox
     * @throws Exception
     */
    void programinfoInsertRoomrole(RequestBox requestBox) throws Exception;

    /**
     * 프로그램정보 디테일 Two seq
     * @param requestBox
     * @throws Exception
     */
    public DataBox programInfoTwoSeq(RequestBox requestBox) throws Exception;

    /**
     * 프로그램정보 디테일 Two 리스트 셀렉트: 월
     * @param requestBox
     * @throws Exception
     */
    List<DataBox> programInfoSelectWeek(RequestBox requestBox) throws Exception;

    /**
     * 프로그램정보 디테일 Two 리스트:운영일 휴무일 저장
     * @param requestBox
     * @throws Exception
     */
    public void programInfoInsertEarly(RequestBox requestBox) throws Exception;
    /**
     * 프로그램정보 디테일 Two 리스트:운영일 휴무일
     * @param requestBox
     * @throws Exception
     */
    public List<DataBox> programInfoDetailTwoList(RequestBox requestBox) throws Exception;

    public List<DataBox> checkList(RequestBox requestBox) throws Exception;

    public List<DataBox> rsvCheckList(RequestBox requestBox) throws Exception;

    /**
     * 프로그램정보 디테일 Two 리스트:운영일 휴무일
     * @param requestBox
     * @throws Exception
     */
    public void programInfoEarlyDel(RequestBox requestBox) throws Exception;

    /**
     * 프로그램정보 디테일 Two 세션팝업
     * @param requestBox
     * @throws Exception
     */
    public DataBox programInfoDetailSessionPop(RequestBox requestBox) throws Exception;

    /**
     * 프로그램정보 디테일 Two 미리보기 리스트
     * @param requestBox
     * @throws Exception
     */
    public List<DataBox> programInfoDetailTwoPreview(RequestBox requestBox) throws Exception;

    /**
     * 프로그램정보 디테일 Three 팝업 - pin
     * @param requestBox
     * @throws Exception
     */
    List<DataBox> programInfoDetailPinInfo(RequestBox requestBox) throws Exception;

    /**
     * 프로그램정보 디테일 Three 팝업 - age
     * @param requestBox
     * @throws Exception
     */
    List<DataBox> programInfoDetailAgeInfo(RequestBox requestBox) throws Exception;

    /**
     * 프로그램정보 디테일 Three 팝업 - area
     * @param requestBox
     * @throws Exception
     */
    List<DataBox> programInfoDetailAreaInfo(RequestBox requestBox) throws Exception;

    /**
     * 프로그램정보 디테일 Three 팝업 - special
     * @param requestBox
     * @throws Exception
     */
    List<DataBox> programInfoDetailSpecialInfo(RequestBox requestBox) throws Exception;

    /**
     * 프로그램정보 디테일 Three 팝업 - codeCombo
     * @param requestBox
     * @throws Exception
     */
    public List<DataBox> codeCombo(RequestBox requestBox) throws Exception;

    /**
     * 프로그램정보 디테일 Three 팝업 - 세션
     * @param requestBox
     * @throws Exception
     */
    public List<DataBox> programInfoDetailSession(RequestBox requestBox) throws Exception;

    /**
     * 프로그램정보 디테일 Three 팝업 - 예약자격 등록
     * @param requestBox
     * @throws Exception
     */
    void programInfoDetailTermInsert(RequestBox requestBox) throws Exception;

    /**
     * 프로그램정보 디테일 Three 팝업 - 예약자격 모든세션저장
     * @param requestBox
     * @throws Exception
     */
    public void programInfoAllSessionInsert(RequestBox requestBox) throws Exception;

    /**
     * 프로그램정보 디테일 Three 예약자격 리스트
     * @param requestBox
     * @throws Exception
     */
    public List<DataBox> programInfoDetailTermList(RequestBox requestBox) throws Exception;

    /**
     * 프로그램정보 디테일 Three 예약자격 리스트 삭제
     * @param requestBox
     * @throws Exception
     */
    void termListDelete(RequestBox requestBox) throws Exception;

    /**
     * 프로그램정보 디테일 Three 팝업 - 누적예약 리스트
     * @param requestBox
     * @throws Exception
     */
    public List<DataBox> programInfoDetailDisPopList(RequestBox requestBox) throws Exception;

    /**
     * 프로그램정보 디테일 Three 팝업 - 누적예약 등록
     * @param requestBox
     * @throws Exception
     */
    void programInfoDetailDisInsert(RequestBox requestBox) throws Exception;

    /**
     * 프로그램정보 디테일 Three  누적예약 리스트
     * @param requestBox
     * @throws Exception
     */
    public List<DataBox> programInfoDetailDisList(RequestBox requestBox) throws Exception;

    /**
     * 프로그램정보 디테일 Three  누적예약 리스트 삭제
     * @param requestBox
     * @throws Exception
     */
    public void disListDelete(RequestBox requestBox) throws Exception;

    /**
     * 프로그램정보 디테일 Three 팝업 - 취소패널티 리스트
     * @param requestBox
     * @throws Exception
     */
    public List<DataBox> programInfoDetailThreeCancelPopList(RequestBox requestBox) throws Exception;

    /**
     * 프로그램정보 디테일 Three 팝업 - 취소패널티 등록
     * @param requestBox
     * @throws Exception
     */
    void programInfoDetailCancelInsert(RequestBox requestBox) throws Exception;

    /**
     * 프로그램정보 디테일 Three 취소패널티 리스트
     * @param requestBox
     * @throws Exception
     */
    public List<DataBox> programInfoDetailCancelList(RequestBox requestBox) throws Exception;

    /**
     * 프로그램정보 디테일 Three 취소패널티 리스트 삭제
     * @param requestBox
     * @throws Exception
     */
    void cancelListDelete(RequestBox requestBox) throws Exception;

    /**
     * 프로그램정보 디테일 페이지
     * @param requestBox
     * @throws Exception
     */
    public DataBox programInfoDetailOne(RequestBox requestBox) throws Exception;

    /**
     * 프로그램정보 디테일 페이지 - 예약 자격/기간 리스트
     * @param requestBox
     * @throws Exception
     */
    public List<DataBox> programInfoDetailDate(RequestBox requestBox) throws Exception;

    /**
     * 프로그램정보 디테일 페이지 - 타입체크
     * @param requestBox
     * @throws Exception
     */
    public DataBox exptypecheck(RequestBox requestBox) throws Exception;

    /**
     * 프로그램정보 디테일 페이지 - 측정인경우
     * @param requestBox
     * @throws Exception
     */
    public List<DataBox> checkdetail(RequestBox requestBox) throws Exception;

    public int programInfoUpdate(RequestBox requestBox) throws Exception;

	public List<DataBox> selectcategorytypelist(RequestBox requestBox) throws Exception;

    /**
     * 프로그램정보 디테일 페이지 - 파일
     * @param requestBox
     * @throws Exception
     */
    List<DataBox> programInfoDetailOneFile(RequestBox requestBox) throws Exception;

    /**
     * 프로그램정보 디테일 페이지 - 프로그램정보 파일
     * @param requestBox
     * @throws Exception
     */
    List<DataBox> programInfoDetailOtherFile(RequestBox requestBox) throws Exception;
}
