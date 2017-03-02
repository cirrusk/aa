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
                <h3><spring:message code="메뉴:개인정보취급방침"/></h3>
                <div class="location"><spring:message code="메뉴:멤버쉽"/> &gt; <em><spring:message code="메뉴:개인정보취급방침"/></em></div>
            </div>
            <!-- //title -->
            <!-- agree -->
          	<div class="scollbox">
                <!-- stitle -->
                <h4 class="mt20"><spring:message code="메뉴:개인정보취급방침"/>  <span><spring:message code="글:반드시아래내용을확인하시기바랍니다"/></span></h4>
                <!-- //stitle -->
                <div class="scrollCont">
					<p style="font-size: 16px; font-weight: bold;" >개인정보 수집 및 이용 목적</p><br>
                	
					<p style="font-weight: bold;" >ㅇ 개인정보의 수집 및 이용 목적</p>
					- 회사는 수집한 개인정보를 다음의 목적을 위해 활용합니다. 서비스 제공에 관한 회원 관리, 학습 진행 및 이력 관리, 고용보험 과정의 노동부 신고 등에 사용합니다.<br>
					- 회원 관리 <br>
					회원제 서비스 이용에 따른 본인확인, 개인 식별, 불량회원의 부정 이용 방지와 비인가사용 방지, 가입 의사 확인, 연령확인, 불만처리 등 민원처리, 고지사항 전달<br> 
					- 고용보험 과정의 노동부 신고 <br>
					회원이 신청한 과정이 고용보험 대상 과정인 경우 고용보험 환급을 이유로 노동부에 신고하기 위해 개인정보를 수집합니다.<br><br>
					
					<p style="font-weight: bold;" >ㅇ 수집하는 개인정보 항목</p>
					수집하는 목적/방법에 따라 수집하는 개인정보 항목은 다음과 같습니다.<br>
					- 회원 가입 시 수집하는 개인정보 항목 <br>
					개인정보 : 이름, 주민등록번호, 로그인 ID, 비밀번호, 휴대전화번호, 이메일, 부서명, 직위/직책<br>
					- 서비스 이용 중 발생되는 정보 <br>
					교육이력, 접속로그(IP)<br><br>
					
					<p style="font-weight: bold;" >ㅇ 보유이용기간</p>
					① 성명,주민등록번호,소속사,접속로그 (IP) : 영구 <br><br>
					
					
					<p style="font-weight: bold;" >ㅇ 보유이용근거</p>
					근로자 직무능력개발법, 정보통신 이용촉진 및 정보보호 등에 관한 법률, 통신비밀 보호법<br><br>
					
					<p style="font-weight: bold;" >ㅇ 개인정보 수집 동의 거부의 권리</p>
					본사는 보다 원활한 교육 서비스 제공을 위하여 기본 정보 이외의 추가 정보를 수집할 수도 있으며, 추가정보는 교육 서비스 개선 및 외부 위탁사 교육 제공시 활용되는 정보로 제공을 원하지 않을 경우 수집하지 않으며, 미동의로 인해 이용 상의 불이익도 발생하지 않습니다.<br>					
                </div>
            </div>
            <!-- //agree -->
        </div>
</body>
</html>