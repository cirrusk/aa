<%@ page pageEncoding="UTF-8" contentType="text/javascript; charset=UTF-8"%><%@ include file="/WEB-INF/view/include/taglibs.jspf"%>
{
    "description" : "수강과정 조회",
    "url" : "<c:url value="/api/course/apply/list"/>",
    "method" : "POST",
    "rest" : "<c:url value="/api/course/apply/list"/>",
    "request" : [
        {"name" : "accessToken", "type" : "Long", "length" : "100", "required" : false, "defaults" : "", "description" : "인증키", "value" : ""},
        {"name" : "applyType", "type" : "String", "length" : "100", "required" : true, "defaults" : "", "description" : "강의진행상태(ING/WAIT/END)", "value" : ""},
        {"name" : "categoryTypeCd", "type" : "String", "length" : "100", "required" : true, "defaults" : "", "description" : "학위코드(degree/nondegree)", "value" : ""},
        {"name" : "yearTerm", "type" : "String", "length" : "100", "required" : true, "defaults" : "", "description" : "년도/학기", "value" : ""},
        {"name" : "srchCompetitionYn", "type" : "String", "length" : "2", "required" : false, "defaults" : "", "description" : "인재개발대회여부(Y)", "value" : ""}
    ],
    "response" : [
        {"name" : "resultCode",    "type" : "number", "description" : "결과코드 0: 성공"}
    ]
}