<%@ page pageEncoding="UTF-8" contentType="text/javascript; charset=UTF-8"%><%@ include file="/WEB-INF/view/include/taglibs.jspf"%>
{
    "description" : "쪽지 목록 조회",
    "url" : "<c:url value="/api/mypage/message/list"/>",
    "method" : "POST",
    "rest" : "<c:url value="/api/mypage/message/list"/>",
    "request" : [
        {"name" : "accessToken", "type" : "Long", "length" : "100", "required" : false, "defaults" : "", "description" : "인증키", "value" : ""},
        {"name" : "srchMemberSeq", "type" : "Long", "length" : "100", "required" : true, "defaults" : "", "description" : "보낸 사용자 일련번호", "value" : ""}
    ],
    "response" : [
        {"name" : "resultCode",    "type" : "number", "description" : "결과코드 0: 성공 5000: 실패"},
        {"name" : "resultMessage",    "type" : "String", "description" : "결과메세지"},
        {"name" : "totalRowCount", "type" : "number", "description" : "총갯수"},
        {"name" : "messageList",   "type" : "List", "description" : "목록데이터"}
    ]
}