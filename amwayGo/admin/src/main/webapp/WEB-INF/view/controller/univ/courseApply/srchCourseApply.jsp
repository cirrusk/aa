<%@ page pageEncoding="UTF-8"%><%@ include file="/WEB-INF/view/include/taglibs.jspf" %>
<%-- 공통코드 --%>
<c:set var="CD_APPLY_STATUS_002"      value="${aoffn:code('CD.APPLY_STATUS.002')}"/>
<c:set var="CD_CATEGORY_TYPE_DEGREE"  value="${aoffn:code('CD.CATEGORY_TYPE.DEGREE')}"/>

<c:set var="srchKey">memberName=<spring:message code="필드:수강신청:이름"/>,memberId=<spring:message code="필드:수강신청:아이디"/></c:set>
<form name="FormSrch" id="FormSrch" method="post" onsubmit="return false;">
    <div class="lybox search">
        <fieldset>
	        <input type="hidden" name="currentPage" value="1" /> <%-- 1 or 0(전체) --%>
	        <input type="hidden" name="perPage"     value="<c:out value="${condition.perPage}"/>" />
	        <input type="hidden" name="orderby"     value="<c:out value="${condition.orderby}"/>" />
            
            <input type="hidden" name="shortcutYearTerm"         value="<c:out value="${param['shortcutYearTerm']}"/>" />
            <input type="hidden" name="shortcutCourseActiveSeq"  value="<c:out value="${param['shortcutCourseActiveSeq']}"/>" />
            <input type="hidden" name="shortcutCategoryTypeCd" value="<c:out value="${param['shortcutCategoryTypeCd']}"/>"/>
            <input type="hidden" name="shortcutCourseTypeCd" value="<c:out value="${param['shortcutCourseTypeCd']}"/>"/>
            
            <div class="vspace"></div>
            <select name="srchApplyStatusCd">
            	<option value=""><spring:message code="필드:전체"/></option>
                <aof:code type="option" codeGroup="APPLY_STATUS" selected="${condition.srchApplyStatusCd}"/>    
            </select>
            
           <select name="srchKey" class="select">
                <aof:code type="option" codeGroup="${srchKey}" selected="${condition.srchKey}"/>
            </select>
           
	        <input type="text" name="srchWord" value="<c:out value="${condition.srchWord}"/>" style="width:200px;" onkeyup="UT.callFunctionByEnter(event, doSearch);"/>
	        <a href="#" onclick="doSearch()" class="btn black"><span class="mid"><spring:message code="버튼:검색" /><span></a>
        </fieldset>
    </div>
</form>

<form name="FormList" id="FormList" method="post" onsubmit="return false;">
    <input type="hidden" name="currentMenuId" value="<c:out value="${aoffn:encrypt(menuActiveList.menu.menuId)}"/>">
    <input type="hidden" name="currentPage"  value="<c:out value="${condition.currentPage}"/>" />
    <input type="hidden" name="perPage"      value="<c:out value="${condition.perPage}"/>" />
    <input type="hidden" name="orderby"      value="<c:out value="${condition.orderby}"/>" />
    <input type="hidden" name="srchKey"      value="<c:out value="${condition.srchKey}"/>" />
    <input type="hidden" name="srchWord"     value="<c:out value="${condition.srchWord}"/>" />

    <input type="hidden" name="srchYearTerm" value="<c:out value="${condition.srchYearTerm}"/>" />
    <input type="hidden" name="srchYear"     value="<c:out value="${condition.srchYear}"/>" />
    <input type="hidden" name="srchApplyStatusCd"  value="<c:out value="${condition.srchApplyStatusCd}"/>" />

    <input type="hidden" name="shortcutYearTerm"         value="<c:out value="${param['shortcutYearTerm']}"/>" />
    <input type="hidden" name="shortcutCourseActiveSeq"  value="<c:out value="${param['shortcutCourseActiveSeq']}"/>" />
    <input type="hidden" name="shortcutCategoryTypeCd" value="<c:out value="${param['shortcutCategoryTypeCd']}"/>"/>
    <input type="hidden" name="shortcutCourseTypeCd" value="<c:out value="${param['shortcutCourseTypeCd']}"/>"/>
</form>

<form name="FormDetailMember" id="FormDetailMember" method="post" onsubmit="return false;">
   
</form>

<form name="FormMemberPopup" id="FormMemberPopup" method="post" onsubmit="return false;">
   <input type="hidden" name="srchCourseActiveSeq"  value="<c:out value="${param['shortcutCourseActiveSeq']}"/>" />
   <c:if test="${CD_CATEGORY_TYPE_DEGREE eq param['shortcutCategoryTypeCd']}">
       <input type="hidden" name="srchYearTerm"         value="<c:out value="${param['shortcutYearTerm']}"/>" />
   </c:if>
   <input type="hidden" name="srchApplyKindCd">
   <input type="hidden" name="callback" value="doList">
</form>

<form name="FormUpdate" id="FormUpdate" method="post" onsubmit="return false;">
    <input type="hidden" name="srchCourseActiveSeq"/>
    <input type="hidden" name="shortcutCourseActiveSeq"  value="<c:out value="${param['shortcutCourseActiveSeq']}"/>" />
    <input type="hidden" name="courseApplySeq"/>
    <input type="hidden" name="applyStatusCd">
    <input type="hidden" name="courseTypeCd" value="<c:out value="${param['shortcutCourseTypeCd']}"/>"/>
</form>

<form name="FormRandomDivision" id="FormRandomDivision" method="post" onsubmit="return false;">
    <input type="hidden" name="courseActiveSeq" value="<c:out value="${param['shortcutCourseActiveSeq']}"/>"/>
    <input type="hidden" name="callback" value="doList">
</form>

<form name="FormUpdateDivision" id="FormUpdateDivision" method="post" onsubmit="return false;">
    <input type="hidden" name="courseActiveSeq"  value="<c:out value="${param['shortcutCourseActiveSeq']}"/>" />
    <input type="hidden" name="courseApplySeq"/>
    <input type="hidden" name="division"/>
</form>

<form name="FormUpdateInitDivision" id="FormUpdateInitDivision" method="post" onsubmit="return false;">
    <input type="hidden" name="courseActiveSeq"  value="<c:out value="${param['shortcutCourseActiveSeq']}"/>" />
</form>

<form name="FormDownloadExcel" id="FormDownloadExcel" method="post" onsubmit="return false;">
    <input type="hidden" name="courseActiveSeq"  value="<c:out value="${param['shortcutCourseActiveSeq']}"/>" />
</form>

<form name="FormUploaddExcel" id="FormUploadExcel" method="post" onsubmit="return false;">
    <input type="hidden" name="courseActiveSeq"  value="<c:out value="${param['shortcutCourseActiveSeq']}"/>" />
    <input type="hidden" name="callback" value="doList">
</form>

