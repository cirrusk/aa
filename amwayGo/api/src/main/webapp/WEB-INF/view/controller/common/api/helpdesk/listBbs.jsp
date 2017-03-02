<%@ page pageEncoding="UTF-8" contentType="text/javascript; charset=UTF-8"%><%@ include file="/WEB-INF/view/include/taglibs.jspf"%>
{
    "description" : "학습지원센터에서 사용되는 게시판 목록",
    "url" : "<c:url value="/api/helpdesk/board/page/list"/>",
    "method" : "POST",
    "rest" : "<c:url value="/api/helpdesk/board/page/list"/>",
    "request" : [
        {"name" : "accessToken", "type" : "Long", "length" : "100", "required" : false, "defaults" : "", "description" : "인증키", "value" : ""},
        {"name" : "srchBoardSeq", "type" : "Long", "length" : "100", "required" : true, "defaults" : "", "description" : "게시판 일련번호", "value" : ""},
        {"name" : "currentPage", "type" : "Long", "length" : "100", "required" : true, "defaults" : "1", "description" : "페이지 번호", "value" : "1"},
        {"name" : "perPage", "type" : "Long", "length" : "100", "required" : true, "defaults" : "10", "description" : "페이지당갯수", "value" : "10"},
        {"name" : "srchWord", "type" : "String", "length" : "500", "required" : false, "defaults" : "", "description" : "검색어", "value" : ""},
        {"name" : "srchKey", "type" : "String", "length" : "500", "required" : false, "defaults" : "", "description" : "검색구분", "value" : ""}
    ],
    "response" : [
        {"name" : "resultCode", "type" : "number", "description" : "결과코드 0: 성공 5000: 실패"},
        {"name" : "resultMessage",  "type" : "String", "description" : "성공"},
        {"name" : "totalRowCount", "type" : "number", "description" : "총갯수"},
        {"name" : "currentPage", "type" : "number", "description" : "현재 페이지 정보"},
        {"name" : "boardType", "type" : "String", "description" : "게시판 형식"},
        {"name" : "bbsList",   "type" : "List", "description" : "목록데이터"}
    ]
}