<%@ page pageEncoding="UTF-8"%><%@ include file="/WEB-INF/view/include/taglibs.jspf" %>
<%-- 공통코드 --%>
<c:set var="CD_CATEGORY_TYPE_NONDEGREE" value="${aoffn:code('CD.CATEGORY_TYPE.NONDEGREE')}"/>
<c:set var="CD_CATEGORY_TYPE_OCW"       value="${aoffn:code('CD.CATEGORY_TYPE.OCW')}"/>
<c:set var="CD_CATEGORY_TYPE_CONTENTS"  value="${aoffn:code('CD.CATEGORY_TYPE.CONTENTS')}"/>
<c:set var="CD_CATEGORY_TYPE_MOOC"      value="${aoffn:code('CD.CATEGORY_TYPE.MOOC')}"/>
<c:set var="CD_CATEGORY_TYPE_DEGREE"    value="${aoffn:code('CD.CATEGORY_TYPE.DEGREE')}"/>

<html>
<head>
<title></title>
</head>
<body>
	<c:choose>
		<c:when test="${condition.srchCategoryTypeCd eq CD_CATEGORY_TYPE_DEGREE}">
			<c:set var="registCategoryLevel" value="${aoffn:config('category.degree.limitLevel')}"/>
		</c:when>
		<c:when test="${condition.srchCategoryTypeCd eq CD_CATEGORY_TYPE_NONDEGREE}">
			<c:set var="registCategoryLevel" value="${aoffn:config('category.nondegree.limitLevel')}"/>
		</c:when>
		<c:when test="${condition.srchCategoryTypeCd eq CD_CATEGORY_TYPE_OCW}">
			<c:set var="registCategoryLevel" value="${aoffn:config('category.ocw.limitLevel')}"/>
		</c:when>
		<c:when test="${condition.srchCategoryTypeCd eq CD_CATEGORY_TYPE_CONTENTS}">
			<c:set var="registCategoryLevel" value="${aoffn:config('category.contents.limitLevel')}"/>
		</c:when>
        <c:when test="${condition.srchCategoryTypeCd eq CD_CATEGORY_TYPE_MOOC}">
            <c:set var="registCategoryLevel" value="${aoffn:config('category.contents.limitLevel')}"/>
        </c:when>
	</c:choose>
	<c:if test="${!empty registCategoryLevel}">
		<c:set var="registCategoryLevel" value="${aoffn:toInt(registCategoryLevel)}"/>
	</c:if>

	<c:forEach var="row" items="${listCategory}" varStatus="i">
		<div>
			<ul>
				<li style="padding:3px 0;">
					<c:choose>
						<c:when test="${row.category.groupLevel eq registCategoryLevel}">
							<aof:img src="icon/tree_branch_ended.gif" style="width:11px;height:13px;"/>
						</c:when>
						<c:otherwise>
							<a href="javascript:void(0)" onclick="doHide(this)" style="display:none;"><aof:img src="icon/tree_branch_closed.gif" style="width:11px;height:13px;"/></a>
							<a href="javascript:void(0)" onclick="doList('<c:out value="${row.category.categorySeq}"/>','<c:out value="${row.category.groupLevel}"/>')"
							   ><aof:img src="icon/tree_branch_opened.gif" style="width:11px;height:13px;"/></a>
						</c:otherwise>
					</c:choose>

					<c:choose>
						<c:when test="${param['limitCategoryLevel'] eq 'maxSelect'}">
							<c:choose>
								<c:when test="${row.category.groupLevel eq registCategoryLevel}">
									<a href="javascript:void(0)" onclick="doDetail(this, {
										categorySeq : '<c:out value="${row.category.categorySeq}"/>',
										groupLevel : '<c:out value="${row.category.groupLevel}"/>',
										categoryName : '<c:out value="${row.category.categoryName}"/>',
										groupOrder : '<c:out value="${row.category.groupOrder}"/>',
										categoryString : '<c:out value="${row.category.categoryString}"/>'
										})"><c:out value="${row.category.categoryName}"/></a>
								</c:when>
								<c:otherwise>
									<c:out value="${row.category.categoryName}"/>
								</c:otherwise>							
							</c:choose>
						</c:when>
						<c:when test="${param['limitCategoryLevel'] eq 'regist'}">
							<c:choose>
								<c:when test="${row.category.groupLevel lt registCategoryLevel}">
									<a href="javascript:void(0)" onclick="doDetail(this, {
										categorySeq : '<c:out value="${row.category.categorySeq}"/>',
										groupLevel : '<c:out value="${row.category.groupLevel}"/>',
										categoryName : '<c:out value="${row.category.categoryName}"/>',
										groupOrder : '<c:out value="${row.category.groupOrder}"/>',
										categoryString : '<c:out value="${row.category.categoryString}"/>'
										})"><c:out value="${row.category.categoryName}"/></a>
								</c:when>
								<c:otherwise>
									<c:out value="${row.category.categoryName}"/>
								</c:otherwise>							
							</c:choose>
						</c:when>
						<c:otherwise>
							<a href="javascript:void(0)" onclick="doDetail(this, {
								categorySeq : '<c:out value="${row.category.categorySeq}"/>',
								groupLevel : '<c:out value="${row.category.groupLevel}"/>',
								categoryName : '<c:out value="${row.category.categoryName}"/>',
								groupOrder : '<c:out value="${row.category.groupOrder}"/>',
								categoryString : '<c:out value="${row.category.categoryString}"/>'
								})"><c:out value="${row.category.categoryName}"/></a>
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