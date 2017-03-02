<%@ page pageEncoding="UTF-8" contentType="text/javascript; charset=UTF-8"%><%@ include file="/WEB-INF/view/include/taglibs.jspf"%>
{
    "description" : "온라인 학습리스트",
    "url" : "<c:url value="/api/course/element/list"/>",
    "method" : "POST",
    "rest" : "<c:url value="/api/course/element/list"/>",
    "request" : [
        {"name" : "accessToken", "type" : "Long", "length" : "100", "required" : false, "defaults" : "", "description" : "인증키", "value" : ""},
        {"name" : "courseActiveSeq", "type" : "Long", "length" : "100", "required" : true, "defaults" : "", "description" : "과정일련번호", "value" : ""},
        {"name" : "courseApplySeq", "type" : "Long", "length" : "100", "required" : true, "defaults" : "", "description" : "수강생일련번호", "value" : ""}
    ],
    "response" : [
        {"name" : "resultCode",    "type" : "number", "description" : "결과코드 0: 성공"}
    ]
} 