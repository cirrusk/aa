<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/jsp/framework/include/header.jsp" %>
<%@ include file="/WEB-INF/jsp/framework/include/layerPop.jsp" %>
<!-- //page unique -->
<title>교육비 관리 - ABN Korea</title>
		
<script type="text/javascript">
	var targettype = "";
	
	$(document.body).ready(function(){
		if( $("input[name='targetType']").val() == "NOT" ) {
			alert("교육비 지급 대상자가 아닙니다.");
			
			var postUrl = parent.document.URL.split("kr");
			var fullUrl = postUrl[0]+"kr/business";
			
			parent.location.href = fullUrl;
			
		} else if( $("input[name='targetType']").val() == "DIA" ) {
			var postUrl = parent.document.URL.split("kr");
			var fullUrl = postUrl[0]+"kr/business";
			
			parent.location.href = fullUrl;
			alert("교육비 위임자의 권한부여에 대한 동의가 필요합니다.");
		}
	});
	
</script>
</head>

<body>
	<!-- content area | ### academy IFRAME Start ### -->
	<section id="pbContent" class="bizroom">
		<input type="hidden" name="targetType"   value="${scrData.targetType }" />
	</section>
	<!-- //content area | ### academy IFRAME End ### -->
		
<!-- 	<div class="skipNaviReturn"> -->
<%@ include file="/WEB-INF/jsp/framework/include/footer.jsp" %>
