<%@ page pageEncoding="UTF-8" contentType="text/javascript; charset=UTF-8"%><%@ include file="/WEB-INF/view/include/taglibs.jspf"%>
{
    "description" : "강의실 설문 등록",
    "url" : "<c:url value="/api/classroom/surveypaper/insert"/>",
    "method" : "POST",
    "rest" : "<c:url value="/api/classroom/surveypaper/insert"/>",
    "request" : [
        {"name" : "accessToken", "type" : "String", "length" : "100", "required" : true, "defaults" : "", "description" : "인증키", "value" : ""},
        {"name" : "courseActiveSeq", "type" : "Long", "length" : "100", "required" : true, "defaults" : "", "description" : "과정일련번호", "value" : ""},
        {"name" : "courseApplySeq", "type" : "Long", "length" : "100", "required" : true, "defaults" : "", "description" : "수강생일련번호", "value" : ""},
        {"name" : "courseActiveSurveySeq", "type" : "Long", "length" : "100", "required" : true, "defaults" : "", "description" : "강의실설문일련번호", "value" : ""},
        {"name" : "surveyPaperSeq", "type" : "Long", "length" : "100", "required" : true, "defaults" : "", "description" : "설문일련번호", "value" : ""},
        {"name" : "surveyResult", "type" : "String", "length" : "500", "required" : true, "defaults" : "", "description" : "설문결과{{}}", "value" : ""}
    ],
    "response" : [
        {"name" : "resultCode",    "type" : "number", "description" : "결과코드 0 : 성공"},
        {"name" : "resultMessage",    "type" : "String", "description" : "성공"}
    ]
}