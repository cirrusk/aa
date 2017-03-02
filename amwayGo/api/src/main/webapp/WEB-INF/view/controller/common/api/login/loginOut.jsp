<%@ page pageEncoding="UTF-8" contentType="text/javascript; charset=UTF-8"%><%@ include file="/WEB-INF/view/include/taglibs.jspf"%>
{
    "description" : "로그인아웃",
    "url" : "<c:url value="/security/logout"/>",
    "method" : "POST",
    "rest" : "<c:url value="/security/logout"/>",
    "request" : [
        {"name" : "type", "type" : "String", "length" : "100", "required" : true, "defaults" : "json", "description" : "타입", "value" : "json"}
    ],
    "response" : [
        {"name" : "resultCode",    "type" : "number", "description" : "결과코드 0: 성공 1101: 실패 중복로그인: 1102 중복로그인확인: 1103"}
    ]
}