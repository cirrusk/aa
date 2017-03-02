<%@ page pageEncoding="UTF-8" contentType="text/javascript; charset=UTF-8"%><%@ include file="/WEB-INF/view/include/taglibs.jspf"%>
{
    "description" : "마스터 과정 조회",
    "url" : "<c:url value="/api/coursemaster"/>/{categoryType}/list",
    "method" : "POST",
    "rest" : "<c:url value="/api/coursemaster"/>/degree/list",
    "request" : [
        {"name" : "accessToken", "type" : "Long", "length" : "100", "required" : false, "defaults" : "", "description" : "인증키", "value" : ""},
        {"name" : "currentPage", "type" : "Long", "length" : "100", "required" : true, "defaults" : "1", "description" : "페이지 번호", "value" : "1"},
        {"name" : "perPage", "type" : "Long", "length" : "100", "required" : true, "defaults" : "10", "description" : "페이지당갯수", "value" : "10"}
    ],
    "response" : [
        {"name" : "resultCode",    "type" : "number", "description" : "결과코드 0: 성공"}
    ]
}