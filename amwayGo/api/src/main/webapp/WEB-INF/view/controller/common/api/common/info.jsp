<%@ page pageEncoding="UTF-8" contentType="text/javascript; charset=UTF-8"%><%@ include file="/WEB-INF/view/include/taglibs.jspf"%>
{
    "description" : "로그인",
    "url" : "<c:url value="/api/common/info"/>",
    "method" : "POST",
    "rest" : "<c:url value="/api/common/info"/>",
    "request" : [
        {"name" : "linkCd", "type" : "String", "length" : "100", "required" : true, "defaults" : "", "description" : "연동코드", "value" : "_4CSOFT_API_"}
    ],
    "response" : [
        {"name" : "resultCode",    "type" : "number", "description" : "결과코드 0: 성공 7000:에러"}
    ]
}
