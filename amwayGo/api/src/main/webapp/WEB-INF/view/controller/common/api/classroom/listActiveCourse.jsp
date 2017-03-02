<%@ page pageEncoding="UTF-8" contentType="text/javascript; charset=UTF-8"%><%@ include file="/WEB-INF/view/include/taglibs.jspf"%>
{
    "description" : "운영과정목록",
    "url" : "<c:url value="/api/courseactive/list"/>",
    "method" : "POST",
    "rest" : "<c:url value="/api/courseactive/list"/>",
    "request" : [
        {"name" : "accessToken", "type" : "String", "length" : "100", "required" : true, "defaults" : "", "description" : "인증키", "value" : ""},
        {"name" : "srchWord", "type" : "String", "length" : "100", "required" : false, "defaults" : "", "description" : "과정명검색", "value" : ""},
        {"name" : "courseMasterSeq", "type" : "Long", "length" : "100", "required" : false, "defaults" : "", "description" : "마스터과정일련번호", "value" : ""},
        {"name" : "currentPage", "type" : "Long", "length" : "100", "required" : true, "defaults" : "1", "description" : "페이지 번호", "value" : "1"},
        {"name" : "perPage", "type" : "Long", "length" : "100", "required" : true, "defaults" : "10", "description" : "페이지당갯수", "value" : "10"},
        {"name" : "srchType", "type" : "String", "length" : "100", "required" : true, "defaults" : "10", "description" : "검색속성(01:마스터, 02:교강사 과정)", "value" : "01"},
         {"name" : "applyType", "type" : "String", "length" : "100", "required" : true, "defaults" : "", "description" : "강의진행상태(ING/WAIT/END)", "value" : ""},
        {"name" : "srchCompetitionYn", "type" : "String", "length" : "2", "required" : false, "defaults" : "", "description" : "인재개발대회여부(Y)", "value" : ""}
        
    ],
    "response" : [
        {"name" : "resultCode", "type" : "number", "description" : "결과코드 0: 성공 5000: 실패"},
        {"name" : "resultMessage",  "type" : "String", "description" : "성공"},
        {"name" : "totalRowCount", "type" : "number", "description" : "총갯수"},
        {"name" : "currentPage", "type" : "number", "description" : "현재 페이지 정보"},
        {"name" : "items", "type" : "String", "description" : "목록데이터"}
    ]
}