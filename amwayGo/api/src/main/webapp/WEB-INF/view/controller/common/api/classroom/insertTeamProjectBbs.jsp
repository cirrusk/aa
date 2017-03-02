<%@ page pageEncoding="UTF-8" contentType="text/javascript; charset=UTF-8"%><%@ include file="/WEB-INF/view/include/taglibs.jspf"%>
{
    "description" : "강의실 팀프로젝트 게시물 등록",
    "url" : "<c:url value="/api/bbs/teamproject/insert"/>",
    "method" : "POST",
    "rest" : "<c:url value="/api/bbs/teamproject/insert"/>",
    "request" : [
          {"name" : "accessToken", "type" : "Long", "length" : "100", "required" : true, "defaults" : "", "description" : "인증키", "value" : ""},
        {"name" : "parentSeq", "type" : "Long", "length" : "100", "required" : false, "defaults" : "", "description" : "부모 게시물 일련번호", "value" : ""},
        {"name" : "boardSeq", "type" : "Long", "length" : "100", "required" : true, "defaults" : "", "description" : "게시물 일련번호", "value" : ""},
        {"name" : "courseTeamProjectSeq", "type" : "Long", "length" : "100", "required" : true, "defaults" : "", "description" : "팀프로젝트 일련번호", "value" : ""},
        {"name" : "courseTeamSeq", "type" : "Long", "length" : "100", "required" : true, "defaults" : "", "description" : "팀 일련번호", "value" : ""},
        {"name" : "courseActiveSeq", "type" : "Long", "length" : "100", "required" : true, "defaults" : "", "description" : "과정일련번호", "value" : ""},
        {"name" : "bbsTitle", "type" : "String", "length" : "100", "required" : true, "defaults" : "", "description" : "제목", "value" : ""},        
        {"name" : "description", "type" : "String", "length" : "500", "required" : true, "defaults" : "", "description" : "내용", "value" : ""},        
        {"name" : "secretYn", "type" : "String", "length" : "1", "required" : true, "defaults" : "", "description" : "비밀글여부(Y/N)", "value" : "N"},
        {"name" : "downloadYn", "type" : "String", "length" : "1", "required" : true, "defaults" : "", "description" : "다운로드Y/N", "value" : "N"}
    ],
    "response" : [
        {"name" : "resultCode", "type" : "number", "description" : "결과코드 0: 성공 5000: 실패"},
        {"name" : "resultMessage",  "type" : "String", "description" : "성공"},
        {"name" : "totalRowCount", "type" : "number", "description" : "총갯수"},
        {"name" : "currentPage", "type" : "number", "description" : "현재 페이지 정보"},
        {"name" : "boardType", "type" : "String", "description" : "게시판 형식"},
        {"name" : "bbsList",   "type" : "List", "description" : "목록데이터"}
    ]
}