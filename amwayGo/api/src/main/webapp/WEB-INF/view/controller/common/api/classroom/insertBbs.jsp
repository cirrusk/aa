<%@ page pageEncoding="UTF-8" contentType="text/javascript; charset=UTF-8"%><%@ include file="/WEB-INF/view/include/taglibs.jspf"%>
{
    "description" : "강의실 게시물 등록",
    "url" : "<c:url value="/api/course/active/board/page/insert"/>",
    "method" : "POST",
    "rest" : "<c:url value="/api/course/active/board/page/insert"/>",
    "request" : [
          {"name" : "accessToken", "type" : "String", "length" : "100", "required" : true, "defaults" : "", "description" : "인증키", "value" : ""},
        {"name" : "boardSeq", "type" : "Long", "length" : "100", "required" : true, "defaults" : "", "description" : "게시물 일련번호", "value" : ""},
        {"name" : "parentSeq", "type" : "Long", "length" : "100", "required" : false, "defaults" : "", "description" : "부모 게시물 일련번호", "value" : ""},      
        {"name" : "courseActiveSeq", "type" : "Long", "length" : "100", "required" : true, "defaults" : "", "description" : "과정일련번호", "value" : ""},
        {"name" : "bbsTitle", "type" : "String", "length" : "100", "required" : true, "defaults" : "", "description" : "제목", "value" : ""},        
        {"name" : "description", "type" : "String", "length" : "500", "required" : true, "defaults" : "", "description" : "내용", "value" : ""},        
        {"name" : "boardTypeCd", "type" : "String", "length" : "50", "required" : true, "defaults" : "", "description" : "게시판타입", "value" : ""},
        {"name" : "downloadYn", "type" : "String", "length" : "1", "required" : true, "defaults" : "", "description" : "다운로드Y/N", "value" : "N"},
        {"name" : "pushYn", "type" : "String", "length" : "1", "required" : true, "defaults" : "", "description" : "푸시Y/N", "value" : "N"},
        {"name" : "classificationCode", "type" : "String", "length" : "2", "required" : false, "defaults" : "", "description" : "세션코드값 (ex : H1)", "value" : ""}
    ],
    "response" : [
        {"name" : "resultCode", "type" : "number", "description" : "결과코드 0: 성공 5000: 실패"},
        {"name" : "resultMessage",  "type" : "String", "description" : "성공"}
    ]
}