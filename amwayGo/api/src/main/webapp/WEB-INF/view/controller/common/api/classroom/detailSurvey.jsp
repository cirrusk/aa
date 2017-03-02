<%@ page pageEncoding="UTF-8" contentType="text/javascript; charset=UTF-8"%><%@ include file="/WEB-INF/view/include/taglibs.jspf"%>
{
    "description" : "강의실 설문",
    "url" : "<c:url value="/api/classroom/surveypaper/detail"/>",
    "method" : "POST",
    "rest" : "<c:url value="/api/classroom/surveypaper/detail"/>",
    "request" : [
        {"name" : "accessToken", "type" : "String", "length" : "100", "required" : true, "defaults" : "", "description" : "인증키", "value" : ""},
        {"name" : "courseActiveSeq", "type" : "Long", "length" : "100", "required" : true, "defaults" : "", "description" : "과정일련번호", "value" : ""},
        {"name" : "courseApplySeq", "type" : "Long", "length" : "100", "required" : true, "defaults" : "", "description" : "수강생일련번호", "value" : ""},
        {"name" : "courseActiveSurveySeq", "type" : "Long", "length" : "100", "required" : true, "defaults" : "", "description" : "강의실설문일련번호", "value" : ""},
        {"name" : "courseTypeCd", "type" : "String", "length" : "100", "required" : true, "defaults" : "", "description" : "과정구분(COURSE_TYPE::ALWAYS,COURSE_TYPE::PERIOD)", "value" : ""}
    ],
    "response" : [
        {"name" : "resultCode",    "type" : "number", "description" : "결과코드 0 : 성공"},
        {"name" : "resultMessage",    "type" : "String", "description" : "성공"},
        {"name" : "items",   "type" : "List", "description" : "목록데이터"}
    ]
}