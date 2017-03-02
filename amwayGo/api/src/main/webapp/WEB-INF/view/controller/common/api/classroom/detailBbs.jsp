<%@ page pageEncoding="UTF-8" contentType="text/javascript; charset=UTF-8"%><%@ include file="/WEB-INF/view/include/taglibs.jspf"%>
{
    "description" : "과정게시판 상세 정보",
    "url" : "<c:url value="/api/course/active/board/page/detail"/>/{courseActiveSeq}/{bbsSeq}",
    "method" : "POST",
    "rest" : "<c:url value="/api/course/active/board/page/detail/1107/461"/>",
    "request" : [
        {"name" : "accessToken", "type" : "Long", "length" : "100", "required" : true, "defaults" : "", "description" : "인증키", "value" : ""} 
    ],
    "response" : [
        {"name" : "resultCode", "type" : "number", "description" : "결과코드 0: 성공 5000: 실패"},
        {"name" : "resultMessage",  "type" : "String", "description" : "성공"},
        {"name" : "item", "type" : "String", "description" : "게시판 상세 정보"},
        {"name" : "items",   "type" : "List", "description" : "코멘트목록데이터"}
    ]
}