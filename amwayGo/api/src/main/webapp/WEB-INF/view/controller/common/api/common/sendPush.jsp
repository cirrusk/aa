<%@ page pageEncoding="UTF-8" contentType="text/javascript; charset=UTF-8"%><%@ include file="/WEB-INF/view/include/taglibs.jspf"%>
{
    "description" : "일반 푸시 전송",
    "url" : "<c:url value="/api/device/push/send"/>",
    "method" : "POST",
    "rest" : "<c:url value="/api/device/push/send"/>",
    "request" : [
    	{"name" : "accessToken", "type" : "Long", "length" : "100", "required" : true, "defaults" : "", "description" : "인증키", "value" : ""},
    	{"name" : "memberSeqList", "type" : "Long", "length" : "100", "required" : true, "defaults" : "", "description" : "발신대상자 (,로 구분)", "value" : ""},
        {"name" : "pushType", "type" : "String", "length" : "500", "required" : true, "defaults" : "", "description" : "전송타입(문자열 String.valueOf((char)0x01) 로 분기)", "value" : ""},
        {"name" : "pushTitle", "type" : "String", "length" : "500", "required" : true, "defaults" : "", "description" : "푸시 제목", "value" : ""},
        {"name" : "pushMessage", "type" : "String", "length" : "500", "required" : true, "defaults" : "", "description" : "푸시 내용", "value" : ""}
    ],
    "response" : [
        {"name" : "resultCode",    "type" : "number", "description" : "결과코드 0: 성공 5000: 실패"},
        {"name" : "resultCnt",    "type" : "number", "description" : "전송처리 완료된 사용자 수"}
    ]
}