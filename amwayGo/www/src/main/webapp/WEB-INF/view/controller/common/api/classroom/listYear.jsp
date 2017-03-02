<%@ page pageEncoding="UTF-8" contentType="text/javascript; charset=UTF-8"%><%@ include file="/WEB-INF/view/include/taglibs.jspf"%>
{
    "description" : "년도학기 코드목록",
    "url" : "/api/course/yearTerm/list.do",
    "method" : "POST",
    "rest" : "/api/course/yearTerm/list.do",
    "response" : [
        {"name" : "resultCode",    "type" : "number", "description" : "결과코드 0: 성공"}
    ]
}