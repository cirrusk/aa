<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" session="true" %>

	<!-- js/이미지/공통  include -->
	<%@ include file="/WEB-INF/jsp/framework/include/mobile/top.jsp" %>
	<%@ include file="/WEB-INF/jsp/framework/include/mobile/include.jsp" %>

<script type="text/javascript">
	// 모바일 가로/세로 resize
	$(window).on("orientationchange", function(event){
		setTimeout(function(){ abnkorea_resize(); }, 500);
	});
</script>