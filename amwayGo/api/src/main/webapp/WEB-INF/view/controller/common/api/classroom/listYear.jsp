<%@ page pageEncoding="UTF-8" contentType="text/javascript; charset=UTF-8"%><%@ include file="/WEB-INF/view/include/taglibs.jspf"%>
{
    "description" : "년도학기 코드목록",
    "url" : "<c:url value="/api/course/yearTerm/list"/>",
    "method" : "POST",
    "rest" : "<c:url value="/api/course/yearTerm/list"/>", 
    "request" : [
        {"name" : "accessToken", "type" : "Long", "length" : "100", "required" : false, "defaults" : "", "description" : "인증키", "value" : ""}
    ],
    "response" : [      
        {"name" : "resultCode",    "type" : "number", "description" : "결과코드 0: 성공"}
    ]
}