<%@ page pageEncoding="UTF-8" contentType="text/javascript; charset=UTF-8"%><%@ include file="/WEB-INF/view/include/taglibs.jspf"%>
{
    "description" : "선택한 쪽지를 삭제함",
    "url" : "/api/mypage/message/delete.do",
    "method" : "POST",
    "rest" : "/api/mypage/message/delete.do",
    "request" : [
        {"name" : "messageSeq", "type" : "Long", "length" : "100", "required" : true, "defaults" : "", "description" : "쪽지 일련번호", "value" : ""},
        {"name" : "messageType", "type" : "String", "length" : "100", "required" : true, "defaults" : "", "description" : "쪽지구분(recv, send)", "value" : ""}
    ],
    "response" : [
        {"name" : "resultCode",    "type" : "number", "description" : "결과코드 0: 성공 5000: 실패"},
        {"name" : "resultMessage",    "type" : "String", "description" : "성공 실패"}
    ]
}