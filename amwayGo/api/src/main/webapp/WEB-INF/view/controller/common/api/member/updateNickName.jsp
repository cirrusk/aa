<%@ page pageEncoding="UTF-8" contentType="text/javascript; charset=UTF-8"%><%@ include file="/WEB-INF/view/include/taglibs.jspf"%>
{
    "description" : "닉네임 수정",
    "url" : "<c:url value="/api/member/nickname/update"/>",
    "method" : "POST",
    "rest" : "<c:url value="/api/member/nickname/update"/>",
    "request" : [
        {"name" : "accessToken", "type" : "String", "length" : "100", "required" : false, "defaults" : "", "description" : "인증키", "value" : ""},
        {"name" : "j_nickname", "type" : "String", "length" : "20", "required" : true, "defaults" : "", "description" : "닉네임", "value" : ""}
    ],
    "response" : [
        {"name" : "resultCode",    "type" : "number", "description" : "결과코드 0: 성공"},
        {"name" : "clauseList",    "type" : "List", "description" : "결과코드 0: 성공"}
    ]
}