<%@ page pageEncoding="UTF-8" contentType="text/javascript; charset=UTF-8"%><%@ include file="/WEB-INF/view/include/taglibs.jspf"%>
{
    "description" : "학습지원센터에서 사용되는 게시판 목록",
    "url" : "/api/helpdesk/board/list.do",
    "method" : "POST",
    "rest" : "/api/helpdesk/board/list.do",
    "response" : [
        {"name" : "resultCode",    "type" : "number", "description" : "결과코드 0 : 성공"},
        {"name" : "resultMessage",    "type" : "String", "description" : "성공"},
        {"name" : "totalRowCount", "type" : "number", "description" : "총갯수"},
        {"name" : "boardList",   "type" : "List", "description" : "목록데이터"}
    ]
}