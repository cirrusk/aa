<%@ page pageEncoding="UTF-8" contentType="text/javascript; charset=UTF-8"%><%@ include file="/WEB-INF/view/include/taglibs.jspf"%>
{
    "description" : "게시판 댓글 삭제",
    "url" : "<c:url value="/api/bbs/comment/delete"/>",
    "method" : "POST",
    "rest" : "<c:url value="/api/bbs/comment/delete"/>",
    "request" : [
        {"name" : "accessToken", "type" : "String", "length" : "100", "required" : true, "defaults" : "", "description" : "인증키", "value" : ""},
        {"name" : "bbsSeq", "type" : "Long", "length" : "100", "required" : true, "defaults" : "", "description" : "게시물일련번호", "value" : ""},
        {"name" : "commentSeq", "type" : "Long", "length" : "100", "required" : true, "defaults" : "", "description" : "코멘트일련번호", "value" : ""} 
    ],
    "response" : [
        {"name" : "resultCode", "type" : "number", "description" : "결과코드 0: 성공 5000: 실패"},
        {"name" : "resultMessage",  "type" : "String", "description" : "성공"}
    ]
}