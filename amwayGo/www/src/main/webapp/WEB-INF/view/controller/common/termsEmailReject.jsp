<%@ page pageEncoding="UTF-8"%><%@ include file="/WEB-INF/view/include/taglibs.jspf" %>

<c:set var="domainWww" value="${aoffn:config('domain.www')}"/>

<html>
<head>
<title></title>
<script type="text/javascript">
initPage = function() {
};
</script>
</head>

<body>
	 <div id="content">
        	<!-- title -->
      		<div class="tit">
                <h3><spring:message code="메뉴:이메일무단수집거부"/></h3>
                <div class="location"><spring:message code="메뉴:멤버십"/> &gt; <em><spring:message code="메뉴:이메일무단수집거부"/></em></div>
            </div>
            <!-- //title -->
            <!-- cont -->
			<div class="email_not">
				<aof:img src="content/email_img.gif"/>
                <p>본 웹사이트에 게시된 이메일 주소가 전자우편 수집 프로그램이나 그 밖의 기술적 장치를<br /> 이용하여 무단으로 수집되는 것을 거부하며<br />
                <em>이를 위반시 정보통신망법에 의해 형사처벌됨을 유념하시기 바랍니다.</em></p>
			</div>
            <!-- //cont -->
        </div>
</body>
</html>