<%@ page pageEncoding="UTF-8" contentType="text/javascript; charset=UTF-8"%><%@ include file="/WEB-INF/view/include/taglibs.jspf"%>
{
    "description" : "마스터 과정 상세",
    "url" : "<c:url value="/api/course/active/quiz/answer/detail.do"/>",
    "method" : "POST",
    "rest" : "<c:url value="/api/course/active/quiz/answer/detail.do"/>",
    "request" : [
        {"name" : "accessToken", "type" : "String", "length" : "100", "required" : true, "defaults" : "", "description" : "인증키", "value" : ""},
        {"name" : "courseActiveSeq", "type" : "Long", "length" : "100", "required" : true, "defaults" : "", "description" : "운영과정 일련번호", "value" : ""},
        {"name" : "examItemSeq", "type" : "Long", "length" : "100", "required" : true, "defaults" : "", "description" : "시험지 item 번호", "value" : ""},
        {"name" : "courseActiveProfSeq", "type" : "Long", "length" : "100", "required" : true, "defaults" : "", "description" : "교수자 일련번호", "value" : ""},
        {"name" : "quizDtime", "type" : "String", "length" : "100", "required" : true, "defaults" : "", "description" : "퀴즈 순서값", "value" : ""},
        {"name" : "classificationCode", "type" : "String", "length" : "2", "required" : false, "defaults" : "", "description" : "세션코드값 (ex : H1)", "value" : ""}
    ],
    "response" : [
        {"name" : "resultCode", "type" : "number", "description" : "결과코드 0: 성공 5000: 실패"},
        {"name" : "resultMessage",  "type" : "String", "description" : "성공"},
        {"name" : "items",   "type" : "List", "description" : "목록데이터"}
    ]
}