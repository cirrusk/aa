<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/manager/frame/include/top.jsp" %>

<!-- js/이미지/공통  include -->
<%@ include file="/WEB-INF/jsp/manager/frame/include/include.jsp" %>

<script type="text/javascript">
$(document).ready(function(){
	alert("세션이 종료되었습니다.");
	top.location.href = "/";	
});
</script>
</head>

<body class="bgw">
	<!--title //-->
	<div class="contents_title clear">
		<h2 class="fl">세션 에러</h2>
	</div>

	<!--search table // -->
	<div class="tbl_write">
		<table id="tblSearch" width="100%" border="0" cellspacing="0" cellpadding="0">
			<tr>
				<td>
					<div>
						<div>세션이 종료되었습니다.</div>
					</div>
				</td>
			</tr>
		</table>

	</div>
</body>