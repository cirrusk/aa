<%@ page pageEncoding="UTF-8"%><%@ include file="/WEB-INF/view/include/taglibs.jspf" %>
<html>
<head>
<title></title>
</head>

<body>
	<c:choose>
		<c:when test="${condition.srchCategoryType eq 'course'}">
			<c:set var="registCategoryLevel" value="${aoffn:config('category.course.limitLevel')}"/>
		</c:when>
		<c:when test="${condition.srchCategoryType eq 'contents'}">
			<c:set var="registCategoryLevel" value="${aoffn:config('category.contents.limitLevel')}"/>
		</c:when>
	</c:choose>
	<c:if test="${!empty registCategoryLevel}">
		<c:set var="registCategoryLevel" value="${aoffn:toInt(registCategoryLevel)}"/>
	</c:if>
	
	<c:forEach var="row" items="${listCategory}" varStatus="i">
		<div>
			<ul>
				<li>
					<c:choose>
						<c:when test="${row.category.level eq registCategoryLevel}">
							<aof:img src="icon/tree_branch_opened.gif"/>
						</c:when>
						<c:otherwise>
							<a href="javascript:void(0)" onclick="doHide(this)" style="display:none;"><aof:img src="icon/tree_branch_closed.gif"/></a>
							<a href="javascript:void(0)" onclick="doList('<c:out value="${row.category.categorySeq}"/>','<c:out value="${row.category.level}"/>')"><aof:img src="icon/tree_branch_opened.gif"/></a>
						</c:otherwise>
					</c:choose>

					<c:choose>
						<c:when test="${param['limitCategoryLevel'] eq 'maxSelect'}">
							<c:choose>
								<c:when test="${row.category.level eq registCategoryLevel}">
									<a href="javascript:void(0)" onclick="doDetail(this, {
										categorySeq : '<c:out value="${row.category.categorySeq}"/>',
										level : '<c:out value="${row.category.level}"/>',
										title : '<c:out value="${row.category.title}"/>',
										path : '<c:out value="${row.category.path}"/>'
										})"><c:out value="${row.category.title}"/></a>
								</c:when>
								<c:otherwise>
									<c:out value="${row.category.title}"/>
								</c:otherwise>							
							</c:choose>
						</c:when>
						<c:when test="${param['limitCategoryLevel'] eq 'regist'}">
							<c:choose>
								<c:when test="${row.category.level lt registCategoryLevel}">
									<a href="javascript:void(0)" onclick="doDetail(this, {
										categorySeq : '<c:out value="${row.category.categorySeq}"/>',
										level : '<c:out value="${row.category.level}"/>',
										title : '<c:out value="${row.category.title}"/>',
										path : '<c:out value="${row.category.path}"/>'
										})"><c:out value="${row.category.title}"/></a>
								</c:when>
								<c:otherwise>
									<c:out value="${row.category.title}"/>
								</c:otherwise>							
							</c:choose>
						</c:when>
						<c:otherwise>
							<a href="javascript:void(0)" onclick="doDetail(this, {
								categorySeq : '<c:out value="${row.category.categorySeq}"/>',
								level : '<c:out value="${row.category.level}"/>',
								title : '<c:out value="${row.category.title}"/>',
								path : '<c:out value="${row.category.path}"/>'
								})"><c:out value="${row.category.title}"/></a>
						</c:otherwise>
					</c:choose>
				</li>
			</ul>
				
			<ul id="category-<c:out value="${row.category.categorySeq}"/>" style="display:none;padding-left:20px;"></ul>
		</div>
	</c:forEach>
	<c:if test="${empty listCategory}">
		<script>
			doNoListdata();
		</script>
	</c:if>
</body>
</html>