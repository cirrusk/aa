<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!doctype html>
<html lang="ko">
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no">
<title>온라인강의 - ABN Korea</title>
<link rel="stylesheet" href="/_ui/mobile/common/css/academy_default.css" />
<script src="/_ui/mobile/common/js/jquery-1.8.3.min.js"></script>
<script src="/_ui/mobile/common/js/pbCommonAcademy.js"></script>
<script src="/_ui/mobile/common/js/owl.carousel.js"></script>
<script src="/_ui/mobile/common/js/pbLayerPopup.js"></script>

	<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
	<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
	<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
	<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
	<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
	<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
	<%@ taglib prefix="ct" uri="/WEB-INF/tlds/ct.tld" %>
	
<script src="/js/front.js"></script>
<script src="/js/lms/lmsCommMobile.js"></script>

<script type="text/javascript">
	$(document.body).ready(function() {
		init();
	});
	function init() {
		if("${scrData.redirectGlmsURL}" == "" ) {
			this.close();
			return;
		}
		if("${scrData.activityid}" == "") {
			if("${scrData.activitycode}" == "A") {
				alert("이용권한이 없습니다.");
			} else if("${scrData.activitycode}" == "T") {
				alert("수강 기간이 종료되었습니다.");
			} else {
				alert("이용권한이 없습니다.");	
			}
			this.close();
			return;
		} else {
			location.href = "${scrData.redirectGlmsURL}";	
		}
	}
</script>
</head>

<body>
		<!-- content area | ### academy IFRAME Start ### -->
		<section id="pbContent" class="academyWrap">
			<div class="hWrap">
			</div>
		</section>
		<!-- //content area | ### academy IFRAME Start ### -->
</body>
</html>