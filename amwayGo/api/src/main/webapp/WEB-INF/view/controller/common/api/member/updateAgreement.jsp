<%@ page pageEncoding="UTF-8" contentType="text/javascript; charset=UTF-8"%><%@ include file="/WEB-INF/view/include/taglibs.jspf"%>
{
    "description" : "개인정보동의",
    "url" : "<c:url value="/api/member/agreement"/>",
    "method" : "POST",
    "rest" : "<c:url value="/api/member/agreement"/>",
    "request" : [
        {"name" : "accessToken", "type" : "String", "length" : "100", "required" : true, "defaults" : "", "description" : "인증키", "value" : ""},
         {"name" : "courseActiveSeq", "type" : "String", "length" : "100", "required" : true, "defaults" : "", "description" : "과정키", "value" : ""},
          {"name" : "srchAgreeSeq1", "type" : "String", "length" : "100", "required" : false, "defaults" : "", "description" : "약관동의1키값", "value" : ""},
           {"name" : "srchAgreeSeq2", "type" : "String", "length" : "100", "required" : false, "defaults" : "", "description" : "약관동의2키값", "value" : ""},
           {"name" : "srchAgreeSeq3", "type" : "String", "length" : "100", "required" : false, "defaults" : "", "description" : "약관동의3키값", "value" : ""},
            {"name" : "applyCheck1", "type" : "String", "length" : "100", "required" : false, "defaults" : "", "description" : "동의여부1", "value" : ""},
            {"name" : "applyCheck2", "type" : "String", "length" : "100", "required" : false, "defaults" : "", "description" : "동의여부2", "value" : ""},
            {"name" : "applyCheck3", "type" : "String", "length" : "100", "required" : false, "defaults" : "", "description" : "동의여부3", "value" : ""}
    ],
    "response" : [
        {"name" : "resultCode",    "type" : "number", "description" : "결과코드 0: 성공"}
    ]
}