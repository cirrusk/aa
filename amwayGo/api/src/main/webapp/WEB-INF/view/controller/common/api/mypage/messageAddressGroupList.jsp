<%@ page pageEncoding="UTF-8" contentType="text/javascript; charset=UTF-8"%><%@ include file="/WEB-INF/view/include/taglibs.jspf"%>
{
    "description" : "주소록 목록 조회",
    "url" : "<c:url value="/api/mypage/contact/list"/>",
    "method" : "POST",
    "rest" : "<c:url value="/api/mypage/contact/list"/>",
    "request" : [
        {"name" : "accessToken", "type" : "Long", "length" : "100", "required" : false, "defaults" : "", "description" : "인증키", "value" : ""},
        {"name" : "pageNum", "type" : "Long", "length" : "100", "required" : false, "defaults" : "", "description" : "페이지번호", "value" : ""},
        {"name" : "perPage", "type" : "Long", "length" : "100", "required" : false, "defaults" : "10", "description" : "페이지당갯수", "value" : ""}
    ],
    "response" : [
        {"name" : "resultCode",    "type" : "number", "description" : "결과코드 0: 성공 5000: 실패"},
        {"name" : "resultMessage",    "type" : "String", "description" : "성공 실패"},
        {"name" : "totalRowCount", "type" : "number", "description" : "총갯수"},
        {"name" : "conctacList",   "type" : "List", "description" : "목록데이터"}
    ]
}