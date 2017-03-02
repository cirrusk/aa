<%@ page pageEncoding="UTF-8" contentType="text/javascript; charset=UTF-8"%><%@ include file="/WEB-INF/view/include/taglibs.jspf"%>
{
    "description" : "운영 과정 상세",
    "url" : "<c:url value="/api/courseactive"/>/{courseActiveSeq}/detail",
    "method" : "POST",
    "rest" : "<c:url value="/api/courseactive"/>/1/detail",
    "request" : [
        {"name" : "accessToken", "type" : "Long", "length" : "100", "required" : false, "defaults" : "", "description" : "인증키", "value" : ""}
    ],
    "response" : [
        {"name" : "resultCode",    "type" : "number", "description" : "결과코드 0: 성공"},
        {"name" : "item",    "type" : "Object", "description" : "상세내용"}
    ]
}