<%@ page pageEncoding="UTF-8" contentType="text/javascript; charset=UTF-8"%><%@ include file="/WEB-INF/view/include/taglibs.jspf"%>
{
    "description" : "팀프로젝트 목록",
    "url" : "<c:url value="/api/classroom/teamproject/list"/>",
    "method" : "POST",
    "rest" : "<c:url value="/api/classroom/teamproject/list"/>",
    "request" : [
        {"name" : "accessToken", "type" : "Long", "length" : "100", "required" : false, "defaults" : "", "description" : "인증키", "value" : ""},
        {"name" : "courseActiveSeq", "type" : "Long", "length" : "100", "required" : true, "defaults" : "", "description" : "과정일련번호", "value" : ""},
        {"name" : "courseTeamProjectSeq", "type" : "Long", "length" : "100", "required" : false, "defaults" : "", "description" : "팀프로젝트일련번호(미입력시 최초 등록한 팀프로젝트만 노출)", "value" : ""}
    ],
    "response" : [
        {"name" : "resultCode", "type" : "number", "description" : "결과코드 0: 성공 5000: 실패"},
        {"name" : "resultMessage",  "type" : "String", "description" : "성공"},
        {"name" : "items",   "type" : "List", "description" : "목록데이터"}
    ]
}