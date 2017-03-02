<%@ page pageEncoding="UTF-8" contentType="text/javascript; charset=UTF-8"%><%@ include file="/WEB-INF/view/include/taglibs.jspf"%>
{
    "description" : " 좋아여 등록",
    "url" : "<c:url value="/api/like/history/insert"/>",
    "method" : "POST",
    "rest" : "<c:url value="/api/like/history/insert"/>",
    "request" : [
        {"name" : "accessToken", "type" : "String", "length" : "100", "required" : true, "defaults" : "", "description" : "인증키", "value" : ""},
        {"name" : "referenceSeq", "type" : "Long", "length" : "100", "required" : true, "defaults" : "", "description" : "참조키일련번호(예:게시물일련번호)", "value" : ""},
        {"name" : "reference", "type" : "String", "length" : "500", "required" : true, "defaults" : "", "description" : "참조정보(bbs,course_teamproject_bbs)", "value" : "bbs"}
    ],
    "response" : [
        {"name" : "resultCode", "type" : "number", "description" : "결과코드 0: 성공 5000: 실패"},
        {"name" : "resultMessage",  "type" : "String", "description" : "성공"}
    ]
}