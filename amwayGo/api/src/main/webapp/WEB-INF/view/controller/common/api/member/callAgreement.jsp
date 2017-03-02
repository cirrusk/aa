<%@ page pageEncoding="UTF-8" contentType="text/javascript; charset=UTF-8"%><%@ include file="/WEB-INF/view/include/taglibs.jspf"%>
{
    "description" : "개인정보동의",
    "url" : "<c:url value="/api/course/clause"/>",
    "method" : "POST",
    "rest" : "<c:url value="/api/course/clause"/>",
    "request" : [
        {"name" : "accessToken", "type" : "String", "length" : "100", "required" : false, "defaults" : "", "description" : "인증키", "value" : ""},
         {"name" : "srchCourseActiveSeq", "type" : "String", "length" : "100", "required" : true, "defaults" : "", "description" : "과정키", "value" : ""}
    ],
    "response" : [
        {"name" : "resultCode",    "type" : "number", "description" : "결과코드 0: 성공"}
    ]
}