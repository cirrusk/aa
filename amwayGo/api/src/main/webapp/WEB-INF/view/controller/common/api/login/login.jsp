<%@ page pageEncoding="UTF-8" contentType="text/javascript; charset=UTF-8"%><%@ include file="/WEB-INF/view/include/taglibs.jspf"%>
{
    "description" : "로그인",
    "url" : "<c:url value="/security/login"/>",
    "method" : "POST",
    "rest" : "<c:url value="/security/login"/>",
    "request" : [
        {"name" : "j_username", "type" : "String", "length" : "100", "required" : true, "defaults" : "", "description" : "아이디", "value" : ""},
        {"name" : "j_password", "type" : "String", "length" : "100", "required" : true, "defaults" : "", "description" : "비밀번호", "value" : ""},
        {"name" : "j_nickname", "type" : "String", "length" : "100", "required" : false, "defaults" : "", "description" : "닉네임", "value" : ""},
        {"name" : "type", "type" : "String", "length" : "100", "required" : true, "defaults" : "json", "description" : "타입", "value" : "json"}
    ],
    "response" : [
        {"name" : "resultCode",    "type" : "number", "description" : "결과코드 0: 성공 1101: 실패 중복로그인: 1102 중복로그인확인: 1103"}
    ]
}