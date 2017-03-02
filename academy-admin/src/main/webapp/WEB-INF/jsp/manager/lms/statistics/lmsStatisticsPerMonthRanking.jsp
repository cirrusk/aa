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
				<col width="8%" />
				<col width="32%" />
				<col width="50%" />
				<col width="10%" />
			</colgroup>
			<tr>
				<th>순위</th>
				<th>교육분류</th>
				<th>과정/자료명</th>
				<c:choose>
					<c:when test="${param.type eq 2 or param.type eq 3 }">
						<th>조회수</th>
					</c:when>
					<c:when test="${param.type eq 4 or param.type eq 5 }">
						<th>좋아요수</th>
					</c:when>
					<c:otherwise>
						<th>참석수</th>
					</c:otherwise>
				</c:choose>
			</tr>
			<c:forEach items="${dataList }" var="dataList">
				<tr>
					<td>${dataList.rank }위</td>
					<td>${dataList.categorytreename }</td>
					<td>${dataList.coursename }</td>
					<td>${dataList.viewcount }</td>
				</tr>
			</c:forEach>
		</table>
	</div>
</body>
</html>