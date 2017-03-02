<%@ page pageEncoding="UTF-8" contentType="text/javascript; charset=UTF-8"%><%@ include file="/WEB-INF/view/include/taglibs.jspf"%>
{
    "description" : "학습지원센터에서 사용되는 게시판 목록",
    "url" : "<c:url value="/api/helpdesk/board/page/category/list"/>",
    "method" : "POST",
    "rest" : "<c:url value="/api/helpdesk/board/page/category/list"/>",
    "request" : [
        {"name" : "accessToken", "type" : "Long", "length" : "100", "required" : false, "defaults" : "", "description" : "인증키", "value" : ""},
        {"name" : "srchBoardSeq", "type" : "Long", "length" : "100", "required" : true, "defaults" : "", "description" : "게시판 일련번호", "value" : ""}
    ],
    "response" : [
        {"name" : "resultCode",    "type" : "number", "description" : "결과코드 0: 성공 5000: 실패"},
        {"name" : "resultMessage",    "type" : "number", "description" : "결과 메시지"},
        {"name" : "totalRowCount", "type" : "number", "description" : "총갯수"},
        {"name" : "cateList",   "type" : "List", "description" : "목록데이터"}
    ]
}