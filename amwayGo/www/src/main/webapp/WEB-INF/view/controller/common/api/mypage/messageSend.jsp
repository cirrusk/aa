<%@ page pageEncoding="UTF-8" contentType="text/javascript; charset=UTF-8"%><%@ include file="/WEB-INF/view/include/taglibs.jspf"%>
{
    "description" : "쪽지를 보냄",
    "url" : "/api/mypage/message/send/insert.do",
    "method" : "POST",
    "rest" : "/api/mypage/message/send/insert.do",
    "request" : [
        {"name" : "message", "type" : "String", "length" : "500", "required" : true, "defaults" : "", "description" : "쪽지메세지", "value" : ""},
        {"name" : "memberSeq", "type" : "String", "length" : "500", "required" : true, "defaults" : "", "description" : "받는멤버일련번호", "value" : ""}
    ],
    "response" : [
        {"name" : "resultCode",    "type" : "number", "description" : "결과코드 0: 성공 5000: 실패"},
        {"name" : "resultMessage",    "type" : "String", "description" : "성공 실패"}
    ]
}