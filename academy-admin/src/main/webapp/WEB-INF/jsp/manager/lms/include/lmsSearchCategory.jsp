<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="ct" uri="/WEB-INF/tlds/ct.tld" %>
<script type="text/javascript">
var courseTypeCode = "${courseTypeCode}";
var categoryid1 = "${categoryIdMap.categoryid1}";
var categoryid2 = "${categoryIdMap.categoryid2}";
var categoryid3 = "${categoryIdMap.categoryid3}";
$(document).ready(function(){
	setLmsCategoryOptions(courseTypeCode,"0", "searchcategoryid", 1);

	
	$("#searchcategoryid1").on("change", function(){
		setLmsCategoryOptions(courseTypeCode, $("#searchcategoryid1").val(), "searchcategoryid", 2);
		if(courseTypeCode == "D"){
			showHideSnsTr($("#searchcategoryid1 option:selected").attr("data-compliance"))
		}
	});
	
	$("#searchcategoryid2").on("change", function(){
		setLmsCategoryOptions(courseTypeCode, $("#searchcategoryid2").val(), "searchcategoryid", 3);
		if(courseTypeCode == "D"){
			showHideSnsTr($("#searchcategoryid2 option:selected").attr("data-compliance"))
		}
	});
	
	$("#searchcategoryid3").on("change", function(){
		setLmsCategoryOptions(courseTypeCode, $("#searchcategoryid3").val(), "searchcategoryid", 4);
		if(courseTypeCode == "D"){
			showHideSnsTr($("#searchcategoryid3 option:selected").attr("data-compliance"))
		}
	});
	
	if(categoryid1 != ""){
		$("#searchcategoryid1").val(categoryid1).prop("selected", true);
		setLmsCategoryOptions(courseTypeCode, $("#searchcategoryid1").val(), "searchcategoryid", 2);
		if(categoryid2 != ""){
			$("#searchcategoryid2").val(categoryid2).prop("selected", true);
			setLmsCategoryOptions(courseTypeCode, $("#searchcategoryid2").val(), "searchcategoryid", 3);
			if(categoryid3 != ""){
				$("#searchcategoryid3").val(categoryid3).prop("selected", true);
				setLmsCategoryOptions(courseTypeCode, $("#searchcategoryid3").val(), "searchcategoryid", 4);
			}
		}
	}

	showHideSnsTr($("#searchcategoryid1 option:selected").attr("data-compliance"))
	
	
});

function showHideSnsTr(str){
	if(str == "Y"){
		$("#snsTr").hide();
	}else{
		$("#snsTr").show();
	}
}
function setLmsCategoryOptions(categorytype, categoryid, objName, objNum){
	if(categoryid == "" || categoryid == null){
		$("#"+objName).val($("#"+objName+(objNum-2)).val());
	}else{
		if(categoryid != "0"){
			$("#"+objName).val(categoryid);
		}
	}
	if(objNum > 3){
		return;
	}
	if(categoryid == "" || categoryid == null){
		for(var i = objNum ; i <= 3; i++){
			$("#" + objName + i + " option").remove();
			$("#" + objName + i ).hide();
		}
		return;
	}
	var targetObj = objName + objNum;
	$.ajaxCall({
   		url: "<c:url value="/manager/lms/common/lmsCommonCategoryListAjax.do"/>"
   		, data: {categorytype:categorytype, categoryid: categoryid}
   		, async : false
   		, success: function( data, textStatus, jqXHR){
   			setLmsCategorySelectBox(data, targetObj, objNum);
   		},
   		error: function( jqXHR, textStatus, errorThrown) {
           	alert("<spring:message code="errors.load"/>");
   		}
   	});
}

function setLmsCategorySelectBox(data, targetObj, objNum){
	var codefield = data.codefield;
	var codenamefield = data.codenamefield;
	var compliancefield = data.compliancefield;
	var len = data.dataList.length;
	if(len > 0){
		var HTML = "<option value='__CODE_VALUE__' data-compliance='_CODE_COMPLIANCE_'>__CODE_TEXT__</option>";
		var tmpHTML = "";
		var realHTML = "<option value='' data-compliance=''>선택</option>";
		for(var i = 0; i < data.dataList.length; i++){
			tmpHtml = HTML;
			tmpHtml = tmpHtml.replace(/__CODE_VALUE__/g, eval("data.dataList[i]."+codefield));
			tmpHtml = tmpHtml.replace(/__CODE_TEXT__/g, eval("data.dataList[i]."+codenamefield));
			tmpHtml = tmpHtml.replace(/_CODE_COMPLIANCE_/g, eval("data.dataList[i]."+compliancefield));
			realHTML += tmpHtml;
		}
		$("#" + targetObj + " option").remove();
		$("#" + targetObj).append(realHTML);
		$("#" + targetObj).show();
	} else {
		$("#" + targetObj + " option").remove();
		if(objNum != 1){
			$("#" + targetObj).hide();
		}
	}
}
</script>
					<inupt type="hidden" id="searchcategoryid" name="searchcategoryid" >
					<select id="searchcategoryid1" name="searchcategoryid1" style="width:auto; min-width:100px" >
						<option value="" data-compliance="">선택</option>
					</select>
					<select id="searchcategoryid2" name="searchcategoryid2" style="width:auto; min-width:100px;display:none" >
						<option value="" data-compliance="">선택</option>
					</select>
					<select id="searchcategoryid3" name="searchcategoryid3" style="width:auto; min-width:100px;display:none"  >
						<option value="" data-compliance="">선택</option>
					</select>