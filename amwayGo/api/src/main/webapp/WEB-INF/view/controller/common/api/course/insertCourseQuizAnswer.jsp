<%@ page pageEncoding="UTF-8" contentType="text/javascript; charset=UTF-8"%><%@ include file="/WEB-INF/view/include/taglibs.jspf"%>
{
    "description" : "수강생퀴즈 저장",
    "url" : "<c:url value="/api/course/exam/answer/insert"/>",
    "method" : "POST",
    "rest" : "<c:url value="/api/course/exam/answer/insert"/>",
    "request" : [
        {"name" : "accessToken", "type" : "String", "length" : "100", "required" : true, "defaults" : "", "description" : "인증키", "value" : ""},
        {"name" : "courseActiveSeq", "type" : "Long", "length" : "100", "required" : true, "defaults" : "", "description" : "강의실일련번호", "value" : ""},
        {"name" : "courseApplySeq", "type" : "Long", "length" : "100", "required" : true, "defaults" : "", "description" : "수강생일련번호", "value" : ""},
        {"name" : "courseActiveProfSeq", "type" : "Long", "length" : "100", "required" : true, "defaults" : "", "description" : "교강사일련번호", "value" : ""},
        {"name" : "examItemSeq", "type" : "Long", "length" : "100", "required" : true, "defaults" : "", "description" : "문제일련번호", "value" : ""},
        {"name" : "examExampleSeq", "type" : "Long", "length" : "100", "required" : false, "defaults" : "", "description" : "객관식 식별번호", "value" : ""},
        {"name" : "shortAnswer", "type" : "String", "length" : "100", "required" : false, "defaults" : "", "description" : "주관식 답", "value" : ""},
        {"name" : "quizDtime", "type" : "String", "length" : "500", "required" : true, "defaults" : "", "description" : "실별날짜", "value" : ""},
        {"name" : "classificationCode", "type" : "String", "length" : "500", "required" : false, "defaults" : "", "description" : "세션코드값 (ex : H1)", "value" : ""}  
    ],
    "response" : [
        {"name" : "resultCode", "type" : "number", "description" : "결과코드 0: 성공 5000: 실패"},
        {"name" : "resultMessage",  "type" : "String", "description" : "성공"}
    ]
}