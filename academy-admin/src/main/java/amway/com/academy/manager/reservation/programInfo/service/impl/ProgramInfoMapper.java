package amway.com.academy.manager.reservation.programInfo.service.impl;

import egovframework.rte.psl.dataaccess.mapper.Mapper;
import framework.com.cmm.lib.DataBox;
import framework.com.cmm.lib.RequestBox;

import java.util.List;
import java.util.Map;

/**
 * Created by KR620248 on 2016-08-08.
 */
@Mapper
public interface ProgramInfoMapper {
    /**
     * 프로그램정보 리스트
     * @param requestBox
     * @throws Exception
     */
    List<DataBox> programInfoList(RequestBox requestBox) throws Exception;

    /**
     * 프로그램정보 리스트 카운트
     * @param requestBox
     * @throws Exception
     */
    int programInfoListCount(RequestBox requestBox) throws Exception;

    /**
     * 프로그램정보 엑셀다운
     * @param requestBox
     * @throws Exception
     */
    List<Map<String,String>> programInfoExcelDownload(RequestBox requestBox) throws Exception;

    /**
     * 프로그램정보 측정프로그램 리스트 - E01,E02
     * @param requestBox
     * @throws Exception
     */
    List<DataBox> programInfoType(RequestBox requestBox) throws Exception;

    /**
     * 프로그램정보 체험프로그램 리스트 - E03,E04
     * @param requestBox
     * @throws Exception
     */
    List<DataBox> programInfoCheck(RequestBox requestBox) throws Exception;

    /**
     * 프로그램정보 체험프로그램 브랜드셀렉트
     * @param requestBox
     * @throws Exception
     */
    List<DataBox> programInfoBrand(RequestBox requestBox) throws Exception;

    /**
     * 프로그램정보 체험프로그램 브랜드셀렉트 - 3뎁스
     * @param requestBox
     * @throws Exception
     */
    List<DataBox> programInfoBrandDepth(RequestBox requestBox) throws Exception;

    /**
     * 프로그램정보 측정프로그램 등록
     * @param requestBox
     * @throws Exception
     */
    int programInfoOneInsert(RequestBox requestBox) throws Exception;

    int programInsCheck(RequestBox requestBox);

    int fileUpdate(Map<String, Object> map);
    /**
     * 프로그램정보 One 검색키워드 등록
     * @param requestBox
     * @throws Exception
     */
    int programInfoSearchRsvInsert(RequestBox requestBox) throws Exception;

    /**
     * 프로그램정보 측정프로그램 시퀀스 셋팅
     * @param requestBox
     * @throws Exception
     */
    int programInfoSeq(RequestBox requestBox) throws Exception;

    /**
     * 시설정보 디테일 Two 요일삭제:일별
     * @param requestBox
     * @throws Exception
     */
    void programInfoDelete(RequestBox requestBox) throws Exception;

    /**
     * 시설정보 디테일 Two 요일삭제:전체
     * @param requestBox
     * @throws Exception
     */
    void programInfoDeleteAll(RequestBox requestBox) throws Exception;

    /**
     * 시설정보 디테일 B 요일등록
     * @param requestBox
     * @throws Exception
     */
    void programInfoInsert(RequestBox requestBox) throws Exception;

    void programInfoTwoUpdate(RequestBox requestBox) throws Exception;

    int allSessionTypeSearch(RequestBox requestBox) throws Exception;

    void programinfoInsertRoomrole(RequestBox requestBox) throws Exception;

    /**
     *   프로그램정보 디테일 B 요일 불러오기
     * //@param RequestBox requestBox
     *   @throws Exception
     */
    List<DataBox> programInfoSelectWeek(RequestBox requestBox) throws Exception;

    /**
     *   프로그램정보 디테일 B 운영일/휴무일 저장
     * //@param RequestBox requestBox
     *   @throws Exception
     */
    void programInfoInsertEarly(RequestBox requestBox) throws Exception;
    
    /**
     * 공휴일 입력
     * @param requestBox
     * @throws Exception
     */
    void programInfoInsertHoliday(RequestBox requestBox) throws Exception;

    /**
     *   프로그램정보 디테일 Two seq
     * //@param RequestBox requestBox
     *   @throws Exception
     */
    DataBox programInfoTwoSeq(RequestBox requestBox) throws Exception;

    /**
     *   프로그램정보 디테일 B 운영일/휴무일 삭제
     * //@param RequestBox requestBox
     *   @throws Exception
     */
    void programInfoEarlyDel(RequestBox requestBox) throws Exception;
    /**
     *   프로그램정보 디테일 B 운영일/휴무일
     * //@param RequestBox requestBox
     *   @throws Exception
     */
    List<DataBox> programInfoDetailTwoList(RequestBox requestBox) throws Exception;

    List<DataBox> checkList(RequestBox requestBox) throws Exception;

    List<DataBox> rsvCheckList(RequestBox requestBox) throws Exception;

    /**
     *   프로그램정보 디테일 B 상세보기 팝업
     * //@param RequestBox requestBox
     *   @throws Exception
     */
    DataBox programInfoDetailSessionPop(RequestBox requestBox) throws Exception;

    /**
     *   프로그램정보 디테일 B 상세보기 리스트
     * //@param RequestBox requestBox
     *   @throws Exception
     */
    List<DataBox> programInfoDetailTwoPreview(RequestBox requestBox) throws Exception;
    /**
     *   프로그램정보 디테일 C 예약 팝업 - pin
     * //@param RequestBox requestBox
     *   @throws Exception
     */
    List<DataBox> programInfoDetailPinInfo(RequestBox requestBox) throws Exception;

    /**
     *   프로그램정보 디테일 C 예약 팝업 - age
     * //@param RequestBox requestBox
     *   @throws Exception
     */
    List<DataBox> programInfoDetailAgeInfo(RequestBox requestBox) throws Exception;

    /**
     *   프로그램정보 디테일 C 예약 팝업 - area
     * //@param RequestBox requestBox
     *   @throws Exception
     */
    List<DataBox> programInfoDetailAreaInfo(RequestBox requestBox) throws Exception;

    /**
     *   프로그램정보 디테일 C 예약 팝업 - special
     * //@param RequestBox requestBox
     *   @throws Exception
     */
    List<DataBox> programInfoDetailSpecialInfo(RequestBox requestBox) throws Exception;

    /**
     *   프로그램정보 디테일 C 예약 팝업 - combo
     * //@param RequestBox requestBox
     *   @throws Exception
     */
    List<DataBox> codeCombo(RequestBox requestBox) throws Exception;

    /**
     *   프로그램정보 디테일 C 예약 팝업 - 세션리스트
     * //@param RequestBox requestBox
     *   @throws Exception
     */
    List<DataBox> programInfoDetailSession(RequestBox requestBox) throws Exception;
    /**
     *   프로그램정보 디테일 C 예약 팝업 등록
     * //@param RequestBox requestBox
     *   @throws Exception
     */
    void programInfoDetailTermInsert(RequestBox requestBox) throws Exception;

    /**
     *   프로그램정보 디테일 C 예약 팝업 등록 - 모든세션저장
     * //@param RequestBox requestBox
     *   @throws Exception
     */
    void programInfoAllSessionInsert(RequestBox requestBox) throws Exception;

    /**
     *   프로그램정보 디테일 C 예약 리스트
     * //@param RequestBox requestBox
     *   @throws Exception
     */
    List<DataBox> programInfoDetailTermList(RequestBox requestBox) throws Exception;

    /**
     *   프로그램정보 디테일 C 예약 리스트 삭제
     * //@param RequestBox requestBox
     *   @throws Exception
     */
    void termListDelete(RequestBox requestBox) throws Exception;

    /**
     *   프로그램정보 디테일 C 누적예약팝업 리스트
     * //@param RequestBox requestBox
     *   @throws Exception
     */
    List<DataBox> programInfoDetailDisPopList(RequestBox requestBox) throws Exception;

    /**
     *   프로그램정보 디테일 C 누적예약팝업 등록
     * //@param RequestBox requestBox
     *   @throws Exception
     */
    void programInfoDetailDisInsert(RequestBox requestBox) throws Exception;

    /**
     *   프로그램정보 디테일 C 누적예약 리스트
     * //@param RequestBox requestBox
     *   @throws Exception
     */
    List<DataBox> programInfoDetailDisList(RequestBox requestBox) throws Exception;

    /**
     *   프로그램정보 디테일 C 누적예약 리스트 삭제
     * //@param RequestBox requestBox
     *   @throws Exception
     */
    void disListDelete(RequestBox requestBox) throws Exception;

    /**
     *   프로그램정보 디테일 C  취소패널티팝업 리스트
     * //@param RequestBox requestBox
     *   @throws Exception
     */
    List<DataBox> programInfoDetailThreeCancelPopList(RequestBox requestBox) throws Exception;

    /**
     *   프로그램정보 디테일 C  취소패널티팝업 등록
     * //@param RequestBox requestBox
     *   @throws Exception
     */
    void programInfoDetailCancelInsert(RequestBox requestBox) throws Exception;

    /**
     *   프로그램정보 디테일 C  취소패널티 리스트
     * //@param RequestBox requestBox
     *   @throws Exception
     */
    List<DataBox> programInfoDetailCancelList(RequestBox requestBox) throws Exception;

    /**
     *   프로그램정보 디테일 C  취소패널티 리스트 삭제
     * //@param RequestBox requestBox
     *   @throws Exception
     */
    void cancelListDelete(RequestBox requestBox) throws Exception;

    /**
     *   프로그램정보 디테일 - 타입체크
     * //@param RequestBox requestBox
     *   @throws Exception
     */
    DataBox exptypecheck(RequestBox requestBox) throws Exception;
    /**
     *   프로그램정보 디테일 상세 페이지
     *   @return ModelAndView
     *   @throws Exception
     */
    DataBox programInfoDetailOne(RequestBox requestBox) throws Exception;

    /**
     *   프로그램정보 디테일 상세 페이지 -  예약 자격/기간 리스트
     *   @return ModelAndView
     *   @throws Exception
     */
    List<DataBox> programInfoDetailDate(RequestBox requestBox) throws Exception;

    /**
     *   프로그램정보 디테일 상세 페이지 -  측정인경우
     *   @return ModelAndView
     *   @throws Exception
     */
    List<DataBox> checkdetail(RequestBox requestBox) throws Exception;

    int programInfoUpdate(RequestBox requestBox) throws Exception;

	List<DataBox> selectcategorytypelist(RequestBox requestBox);

    List<DataBox> programInfoDetailOneFile(RequestBox requestBox) throws Exception;

    List<DataBox> programInfoDetailOtherFile(RequestBox requestBox) throws Exception;

	void rsvexpinfoUpdate(RequestBox requestBox);
}
