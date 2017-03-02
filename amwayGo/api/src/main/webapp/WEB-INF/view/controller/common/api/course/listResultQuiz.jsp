<%@ page pageEncoding="UTF-8" contentType="text/javascript; charset=UTF-8"%><%@ include file="/WEB-INF/view/include/taglibs.jspf"%>
{
    "description" : "과정시험/퀴즈결과목록",
    "url" : "<c:url value="/api/course/active/quiz/answer/list.do"/>",
    "method" : "POST",
    "rest" : "<c:url value="/api/course/active/quiz/answer/list.do"/>",
    "request" : [
        {"name" : "accessToken", "type" : "String", "length" : "100", "required" : true, "defaults" : "", "description" : "인증키", "value" : ""},
        {"name" : "courseActiveSeq", "type" : "Long", "length" : "100", "required" : true, "defaults" : "", "description" : "운영과정 일련번호", "value" : ""},
        {"name" : "memberSeq", "type" : "Long", "length" : "100", "required" : false, "defaults" : "", "description" : "등록자 seq", "value" : ""},
        {"name" : "currentPage", "type" : "Long", "length" : "100", "required" : false, "defaults" : "1", "description" : "페이지 번호", "value" : "1"},
        {"name" : "perPage", "type" : "Long", "length" : "100", "required" : false, "defaults" : "10", "description" : "페이지당갯수", "value" : "10"},
        {"name" : "srchClassificationCode", "type" : "String", "length" : "2", "required" : false, "defaults" : "", "description" : "세션코드값 (ex : H1)", "value" : ""}
    ],
    "response" : [
        {"name" : "resultCode", "type" : "number", "description" : "결과코드 0: 성공 5000: 실패"},
        {"name" : "resultMessage",  "type" : "String", "description" : "성공"},
        {"name" : "totalRowCount", "type" : "number", "description" : "총갯수"},
        {"name" : "currentPage", "type" : "number", "description" : "현재 페이지 정보"},
        {"name" : "items",   "type" : "List", "description" : "목록데이터"}
    ]
}