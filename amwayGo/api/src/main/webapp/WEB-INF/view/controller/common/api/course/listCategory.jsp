<%@ page pageEncoding="UTF-8" contentType="text/javascript; charset=UTF-8"%><%@ include file="/WEB-INF/view/include/taglibs.jspf"%>
{
    "description" : "마스터 과정 조회",
    "url" : "<c:url value="/api/category"/>/{categoryType}/list",
    "method" : "POST",
    "rest" : "<c:url value="/api/category"/>/degree/list",
    "request" : [
        {"name" : "accessToken", "type" : "String", "length" : "100", "required" : true, "defaults" : "", "description" : "인증키", "value" : ""},
        {"name" : "srchParentSeq", "type" : "Long", "length" : "100", "required" : true, "defaults" : "0", "description" : "상위키", "value" : "0"},
        {"name" : "srchYearTerm", "type" : "Long", "length" : "100", "required" : false, "defaults" : "2015", "description" : "학기( categoryType  degree 인 경우 필수)", "value" : "2015"}
    ],
    "response" : [
        {"name" : "resultCode",    "type" : "number", "description" : "결과코드 0: 성공"}
    ]
}