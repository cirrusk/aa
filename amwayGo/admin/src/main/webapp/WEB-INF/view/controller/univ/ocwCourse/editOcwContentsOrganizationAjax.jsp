<%@ page pageEncoding="UTF-8" %><%@ include file="/WEB-INF/view/include/taglibs.jspf" %>

<html>
<head>
<title></title>
</head>
<c:set var="key_id"><c:out value="${param['courseActiveSeq']}"/>_<c:out value="${param['activeElementSeq']}" />_<c:out value="${param['organizationSeq']}"/>_<c:out value="${param['itemSeq']}"/></c:set>
<body>
<form id="FormUpdate_<c:out value="${key_id}"/>" name="FormUpdate_<c:out value="${key_id}"/>" method="post" onsubmit="return false;">
	<input type="hidden" name="ocwOrganizaionSeq" value="<c:out value="${detail.ocwContents.ocwOrganizaionSeq}"/>"/>
	<input type="hidden" name="courseActiveSeq" value="<c:out value="${param['courseActiveSeq']}"/>"/>
	<input type="hidden" name="activeElementSeq" value="<c:out value="${param['activeElementSeq']}"/>"/>
	<input type="hidden" name="organizationSeq" value="<c:out value="${param['organizationSeq']}"/>"/>
	<input type="hidden" name="itemSeq" value="<c:out value="${param['itemSeq']}"/>"/>
	<input type="hidden" name="photo" value="<c:out value="${detail.ocwContents.photo}"/>"/>
	<table id="itemTable" class="tbl-detail-row add">
		<colgroup>
			<col style="width:12%;" />
			<col style="width:auto;" />
			<col style="width:12%;" />
			<col style="width:auto;" />
		</colgroup>
		<thead>
			<tr>
				<th><spring:message code="필드:주차:차시설명" /><span class="star">*</span></th>
				<td colspan="3">
					<textarea name="introduction" style="width:99%; height:100px"><c:out value="${detail.ocwContents.introduction}"/></textarea>
				</td>
			</tr>
			<tr>
				<th><spring:message code="필드:주차:한글스크립트" /></th>
				<td colspan="3">
					<textarea name="krScript" style="width:99%; height:100px"><c:out value="${detail.ocwContents.krScript}"/></textarea>
				</td>
			</tr>
			<tr>
				<th><spring:message code="필드:주차:원문스크립트" /></th>
				<td colspan="3">
					<textarea name="originScript" style="width:99%; height:100px"><c:out value="${detail.ocwContents.originScript}"/></textarea>
				</td>
			</tr>
			<tr>
				<th><spring:message code="필드:주차:강사" /><span class="star">*</span></th>
				<td class="align-l">
					<input type="text" name="lectureName" style="width:100px;" value="<c:out value="${detail.ocwContents.lectureName}"/>">
				</td>
				<th><spring:message code="필드:주차:제공자" /><span class="star">*</span></th>
				<td class="align-l">
					<input type="text" name="offerName" style="width:100px;" value="<c:out value="${detail.ocwContents.offerName}"/>">
				</td>
			</tr>
			<tr>
				<th><spring:message code="필드:주차:출저" /></th>
				<td class="align-l">
					<input type="text" name="source" style="width:250px;" value="<c:out value="${detail.ocwContents.source}"/>">
				</td>
				<th><spring:message code="필드:주차:참고서적" /></th>
				<td class="align-l">
					<input type="text" name="referenceBook" style="width:250px;" value="<c:out value="${detail.ocwContents.referenceBook}"/>">
				</td>
			</tr>
			<tr>
				<th><spring:message code="필드:개설과목:이미지" /></th>
				<td colspan="3" class="align-l">
					<div class="photo photo-120">
						<c:choose>
							<c:when test="${!empty detail.ocwContents.photo}">
								<c:set var="ocwPhoto" value ="${aoffn:config('upload.context.image')}${detail.ocwContents.photo}.thumb.jpg"/>
							</c:when>
							<c:otherwise>
								<c:set var="ocwPhoto"><aof:img type="print" src="common/blank.gif"/></c:set>
							</c:otherwise>
						</c:choose>
						<img src="${ocwPhoto}" id="ocw-photo-<c:out value="${key_id}"/>" title="<spring:message code="필드:멤버:사진"/>">
						<div id="uploader_img_<c:out value="${key_id}"/>" class="uploader"></div>
						<div class="delete" 
						     style="display:<c:out value="${empty detail.ocwContents.photo ? 'none' : ''}"/>;" 
						     onclick="doDeletePhoto('<c:out value="${key_id}"/>')" title="<spring:message code="버튼:삭제"/>"></div>
					</div>
					<spring:message code="필드:개설과목:이미지"/>1 : 832px x 459px
				</td>
			</tr>
			<tr>
				<th><spring:message code="필드:주차:키워드" /></th>
				<td colspan="3" class="align-l">
					<input type="text" name="keyword" style="width:70%;" value="<c:out value="${detail.ocwContents.keyword}"/>"> <spring:message code="글:주차:구분자콤마"/>
				</td>
			</tr>
		</thead>
	</table>

	<div class="lybox-btn-r">
		<a href="javascript:void(0)" onclick="doOcwContentsUpdate('<c:out value="${key_id}"/>');" class="btn blue"><span class="mid"><spring:message code="버튼:저장"/></span></a>
		<a href="javascript:void(0)" onclick="doOcwContentsClose('<c:out value="${key_id}"/>');" class="btn blue" ><span class="mid"><spring:message code="버튼:닫기"/></span></a>
	</div>
</form>

<script type="text/javascript">
	doSetSwfu('<c:out value="${key_id}"/>');
</script>

</body>
</html>