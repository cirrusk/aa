<%@ page pageEncoding="UTF-8"%><%@ include file="/WEB-INF/view/include/taglibs.jspf" %>
<html>
<head>
<title></title>
<script type="text/javascript">
</script>
</head>

<body>

	<table class="tbl-detail">
	<colgroup>
		<col style="width: 110px" />
		<col/>
		<col style="width: 140px" />
	</colgroup>
	<tbody>
		<tr>
			<th><spring:message code="필드:멤버:아이디"/></th>
			<td><c:out value="${detail.member.memberId}"/></td>
			<td class="align-c" rowspan="4">
				<c:choose>
					<c:when test="${!empty detail.member.photo}">
						<c:set var="memberPhoto" value ="${aoffn:config('upload.context.image')}${detail.member.photo}.thumb.jpg"/>
					</c:when>
					<c:otherwise>
						<c:set var="memberPhoto"><aof:img type="print" src="common/blank.gif"/></c:set>
					</c:otherwise>
				</c:choose>
				<div class="photo photo-120">
					<img src="${memberPhoto}" title="<spring:message code="필드:멤버:사진"/>">
				</div>
			</td>
		</tr>
		<tr>
			<th><spring:message code="필드:멤버:이름"/></th>
			<td><c:out value="${detail.member.memberName}"/></td>
		</tr>
		<tr>
			<th><spring:message code="필드:멤버:닉네임"/></th>
			<td><c:out value="${detail.member.nickname}"/></td>
		</tr>
		<tr>
			<th><spring:message code="필드:멤버:소속"/></th>
			<td><c:out value="${detail.company.companyName}"/></td>
		</tr>
		<tr>
			<th><spring:message code="필드:멤버:이메일"/></th>
			<td colspan="2"><c:out value="${detail.member.email}"/></td>
		</tr>
		<tr>
			<th><spring:message code="필드:멤버:모바일전화번호"/></th>
			<td colspan="2"><c:out value="${detail.member.phoneMobile}"/></td>
		</tr>
		<tr>
			<th><spring:message code="필드:멤버:집전화번호"/></th>
			<td colspan="2"><c:out value="${detail.member.phoneHome}"/></td>
		</tr>
		<tr>
			<th><spring:message code="필드:멤버:주소"/></th>
			<td colspan="2">
				<c:if test="${!empty detail.member.zipcode and !empty detail.member.address}">
					<c:out value="${fn:substring(detail.member.zipcode, 0, 3)}"/>-<c:out value="${fn:substring(detail.member.zipcode, 3, 6)}"/> 
					&nbsp;<c:out value="${detail.member.address}"/>&nbsp;<c:out value="${detail.member.addressDetail}"/>
				</c:if>
			</td>
		</tr>
		<tr>
			<th><spring:message code="필드:멤버:상태"/></th>
			<td colspan="2"><aof:code type="print" codeGroup="MEMBER_STATUS" selected="${detail.member.memberStatusCd}"/></td>
		</tr>
		<tr>
			<c:choose>
				<c:when test="${detail.member.memberStatusCd eq 'leave'}">
					<th><spring:message code="필드:멤버:회원탈퇴일"/></th>
					<td colspan="2"><aof:date datetime="${detail.member.leaveDtime}" pattern="${aoffn:config('format.datetime')}"/></td>
				</c:when>
				<c:otherwise>
					<th><spring:message code="필드:멤버:회원가입일"/></th>
					<td colspan="2"><aof:date datetime="${detail.member.regDtime}" pattern="${aoffn:config('format.datetime')}"/></td>
				</c:otherwise>
			</c:choose>
		</tr>
	</tbody>
	</table>

</body>
</html>