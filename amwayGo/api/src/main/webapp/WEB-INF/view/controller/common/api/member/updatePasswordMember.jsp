<%@ page pageEncoding="UTF-8" contentType="text/javascript; charset=UTF-8"%><%@ include file="/WEB-INF/view/include/taglibs.jspf"%>
{
    "description" : "비밀번호 수정",
    "url" : "<c:url value="/api/member/password/update"/>",
    "method" : "POST",
    "rest" : "<c:url value="/api/member/password/update"/>",
    "request" : [
        {"name" : "accessToken", "type" : "String", "length" : "100", "required" : true, "defaults" : "", "description" : "인증키", "value" : ""},
        {"name" : "j_password", "type" : "String", "length" : "100", "required" : true, "defaults" : "", "description" : "비밀번호", "value" : ""}
    ],
    "response" : [
        {"name" : "resultCode",    "type" : "number", "description" : "결과코드 0: 성공"}
    ]
}