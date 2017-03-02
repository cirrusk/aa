<%@ page pageEncoding="UTF-8" contentType="text/javascript; charset=UTF-8"%><%@ include file="/WEB-INF/view/include/taglibs.jspf"%>
{
    "description" : "선택한 쪽지를 삭제함",
    "url" : "<c:url value="/api/mypage/message/delete"/>",
    "method" : "POST",
    "rest" : "<c:url value="/api/mypage/message/delete"/>",
    "request" : [
        {"name" : "accessToken", "type" : "Long", "length" : "100", "required" : false, "defaults" : "", "description" : "인증키", "value" : ""},
        {"name" : "messageSeq", "type" : "Long", "length" : "100", "required" : true, "defaults" : "", "description" : "쪽지 일련번호", "value" : ""},
        {"name" : "messageType", "type" : "String", "length" : "100", "required" : true, "defaults" : "", "description" : "쪽지구분(recv, send)", "value" : ""}
    ],
    "response" : [
        {"name" : "resultCode",    "type" : "number", "description" : "결과코드 0: 성공 5000: 실패"},
        {"name" : "resultMessage",    "type" : "String", "description" : "성공 실패"}
    ]
}