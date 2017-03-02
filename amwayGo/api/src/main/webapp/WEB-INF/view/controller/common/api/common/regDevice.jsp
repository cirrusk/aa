<%@ page pageEncoding="UTF-8" contentType="text/javascript; charset=UTF-8"%><%@ include file="/WEB-INF/view/include/taglibs.jspf"%>
{
    "description" : "디바이스등록",
    "url" : "<c:url value="/api/device/check"/>",
    "method" : "POST",
    "rest" : "<c:url value="/api/device/check"/>",
    "request" : [
         {"name" : "accessToken", "type" : "String", "length" : "100", "required" : false, "defaults" : "", "description" : "인증키", "value" : ""}
    ],
    "response" : [
        {"name" : "resultCode",    "type" : "number", "description" : "결과코드 0: 성공 7000:에러"}
    ]
}
