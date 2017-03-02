<%@ page pageEncoding="utf-8" %><%@ include file="/WEB-INF/view/include/taglibs.jspf" %>

<c:set var="selected" value=""/>
<c:if test="${!empty param['selected']}">
	<c:set var="selected" value="${param['selected']}"/>
</c:if>
<c:set var="onchange" value="doSearch"/>
<c:if test="${!empty param['onchange']}">
	<c:set var="onchange" value="${param['onchange']}"/>
</c:if>

<div class="lybox-btn-r">
	<c:if test="${boardType eq 'ask'}">
		<a href="#" onclick="doSearch()" class="btn blue"><span class="mid">갱신<span></a>
	</c:if>
	<select name="perpage" onchange="<c:out value="${onchange}"/>(this.value)" class="select">
		<aof:code type="option" codeGroup="PERPAGE" selected="${selected}" removeCodePrefix="true"/>
	</select>
</div>
