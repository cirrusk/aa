<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<!doctype html>
<html lang="ko">

	<head>
	
		<meta property="og:title" content="예약 정보 안내" />
		<meta property="og:type" content="website" />
		<meta property="og:url" content="${currentDomain}/reservation/simpleReservation.do?reservation=${rsvSeq}" />
		<meta property="og:description" content="${rsvDescription}" />
		<meta property="og:image" content="http://www.amway.co.kr/lcl/ko/AmwayLocalizedImages/PresetImages/logo_amway_ko.png" />
		<meta property="og:site_name" content="ABN Korea Reservation" />

		<%@ include file="/WEB-INF/jsp/framework/include/include_reservation.jsp" %>
		
		<title>reservation information</title>
		
	</head>
	
	<body>
		<script>
			setTimeout(function(){
				
				top.window.location.href='${hybrisUrl}/business';
				
			},5000);
		</script>
		<br />
	</body>
</html>