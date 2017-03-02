<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/manager/frame/include/top.jsp" %>

<!-- js/이미지/공통  include -->
<%@ include file="/WEB-INF/jsp/manager/frame/include/include.jsp" %>

</head>
<body>
	<div class="contents_title clear">
		<div class="fl">
			<a href="javascript:;" onclick="excelDownload('${param.type}','${param.date }')" class="btn_excel" style="vertical-align:middle">엑셀 다운</a>
		</div>
	</div>
		<!--search table // -->
	<div class="tbl_write">
		<table id="tblSearch" width="100%" border="0" cellspacing="0" cellpadding="0">
			<colgroup>
				<col width="10%" />
				<col width="6%" />
				<col width="6%" />
				<col width="6%" />
				<col width="6%" />
				<col width="6%" />
				<col width="6%" />
				<col width="6%" />
				<col width="6%" />
				<col width="6%" />
				<col width="6%" />
				<col width="6%" />
				<col width="6%" />
				<col width="9%" />
				<col width="9%" />
			</colgroup>
			<tr>
				<th>구분</th>
				<th>9월</th>
				<th>10월</th>
				<th>11월</th>
				<th>12월</th>
				<th>1월</th>
				<th>2월</th>
				<th>3월</th>
				<th>4월</th>
				<th>5월</th>
				<th>6월</th>
				<th>7월</th>
				<th>8월</th>
				<th>계</th>
				<th>지난달 대비 증감(%)</th>
			</tr>
			<c:forEach items="${dataList }" var="dataList">
				<tr>
					<td>${dataList.flag }</td>
					<td>${dataList.september }</td>
					<td>${dataList.october }</td>
					<td>${dataList.november }</td>
					<td>${dataList.december }</td>
					<td>${dataList.january }</td>
					<td>${dataList.february }</td>
					<td>${dataList.march }</td>
					<td>${dataList.april }</td>
					<td>${dataList.may }</td>
					<td>${dataList.june }</td>
					<td>${dataList.july }</td>
					<td>${dataList.august }</td>
					<td>${dataList.totalcnt }</td>
					<c:choose>
						<c:when test="${dataList.pct2 eq '999999999999%' }">
							<td>0%</td>
						</c:when>
						<c:otherwise>
							<td>${dataList.pct2 }</td>
						</c:otherwise>
					</c:choose>
				</tr>
			</c:forEach>
		</table>
	</div>
</body>
</html>