<%@ page pageEncoding="UTF-8" contentType="text/javascript; charset=UTF-8"%><%@ include file="/WEB-INF/view/include/taglibs.jspf"%>
{
    "description" : "마스터 과정 조회",
    "url" : "<c:url value="/api/member/all/detail"/>",
    "method" : "POST",
    "rest" : "<c:url value="/api/member/all/detail"/>",
    "request" : [
        {"name" : "accessToken", "type" : "String", "length" : "100", "required" : true, "defaults" : "", "description" : "인증키", "value" : ""},
        {"name" : "memberSeq", "type" : "Long", "length" : "100", "required" : false, "defaults" : "", "description" : "인증키", "value" : ""}
    ],
    "response" : [
        {"name" : "resultCode",    "type" : "number", "description" : "결과코드 0: 성공"}
    ]
}