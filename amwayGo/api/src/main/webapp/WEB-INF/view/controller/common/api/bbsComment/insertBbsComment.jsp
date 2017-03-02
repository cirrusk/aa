<%@ page pageEncoding="UTF-8" contentType="text/javascript; charset=UTF-8"%><%@ include file="/WEB-INF/view/include/taglibs.jspf"%>
{
    "description" : "게시판 댓글 등록",
    "url" : "<c:url value="/api/bbs/comment/insert"/>",
    "method" : "POST",
    "rest" : "<c:url value="/api/bbs/comment/insert"/>",
    "request" : [
        {"name" : "accessToken", "type" : "String", "length" : "100", "required" : true, "defaults" : "", "description" : "인증키", "value" : ""},
        {"name" : "bbsSeq", "type" : "Long", "length" : "100", "required" : true, "defaults" : "", "description" : "게시물일련번호", "value" : ""},
        {"name" : "description", "type" : "String", "length" : "500", "required" : true, "defaults" : "", "description" : "내용", "value" : ""} 
    ],
    "response" : [
        {"name" : "resultCode", "type" : "number", "description" : "결과코드 0: 성공 5000: 실패"},
        {"name" : "resultMessage",  "type" : "String", "description" : "성공"}
    ]
}