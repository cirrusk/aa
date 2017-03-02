<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ include file="/WEB-INF/jsp/manager/frame/include/top.jsp" %>
<!-- js/이미지/공통  include -->
<%@ include file="/WEB-INF/jsp/manager/frame/include/include.jsp" %>
<script type="text/javascript">
var oriObjectVal = "";
function scc(obj){
	if($("#courseid").val() != ""){
		if($("#studentcount").val() != "0"){
			alert("이미 등록된 수강자가 있어서 정규과정의 단계과 구성과정을 변경할 수 없습니다.");
			return false;
		}	
	}
}
function scc1(obj){
	oriObjectVal = obj.value;
}
function scc2(obj){
	if($("#courseid").val() != ""){
		if($("#studentcount").val() != "0"){
			alert("이미 등록된 수강자가 있어서 정규과정의 단계과 구성과정을 변경할 수 없습니다.");
			obj.value = oriObjectVal;
			return false;
		}	
	}
} 
var managerMenuAuth ="${managerMenuAuth}";
var frmid = "${param.frmId}";
var prefrmid = "${param.prefrmId}";
var defaultParam = {
 	sortColKey: "lms.online.list"
};
var nowDate = "${nowDate.yyyy}-${nowDate.mm}-${nowDate.dd} ${nowDate.hh}:${nowDate.mi}:${nowDate.ss}";
var listGrid = new AXGrid(); // instance 상단그리드
$(document.body).ready(function(){
	$("#insertBtn").on("click", function(){
		if(checkManagerAuth(managerMenuAuth)){return;}
		imageSubmit();
	});
	$("#cancelBtn").on("click", function(){
		closeTapAndGoTap(frmid, prefrmid);
	});

	$("#themeButton").on("click", function(){
		if(checkManagerAuth(managerMenuAuth)){return;}
		themeButtonClick();
	});
	$("#themeseq").on("change", function(){
		var selectedVal = $("#themeseq option:selected").text();
		$("#themename").val(selectedVal);
		stampDupCheck();
	});
	
	if($("#courseid").val()!=""){
		themeButtonClick();
	}
	$("#preopenflag").val($("input:radio[name='openflag']:checked").val());
	$("#prethemeseq").val($("#themeseq option:selected").val());
	
	$(".stampflag").on("click", function(){
		stampflagClick(this.value);
	});
	$("#stampid").on("change", function(){
		stampDupCheck();
	});
	stampflagClick($("input:radio[name='stampflag']:checked").val());
	
	$("#deleteConditionButton").on("click", function(){
		if(checkManagerAuth(managerMenuAuth)){return;}
		gridEvent.chkDelete();
	});
	$("#addconditionButton").on("click", function(){
		if(checkManagerAuth(managerMenuAuth)){return;}
		goConditionWrite("I", $("#searchconditiontype").val(), "");
	});
	list.init();
	list.doSearch();
	
	myIframeResizeHeight(frmid);
	if($("#courseid").val() == ""){
		addStepClick();	
	}
	fnCheckLength('coursecontent',500);
});

var listArr = [];
var list = {
	/** init : 초기 화면 구성 (Grid)
	*/		
	init : function() {
		var idx = 0; // 정렬 Index 
		var _colGroup = [
			{key:"conditionseq", width:"40", align:"center", formatter:"checkbox", formatterlabel:"", sort:false, checked:function(){
                return this.item.___checked && this.item.___checked["1"];
     		}}
			, {key:"no", label:"No.", width:"60", align:"center", formatter:"money", sort:false}
			, {key:"conditiontypename", label:"구분", width:"80", align:"center", sort:false}
			, {key:"conditionname", label:"조건", width:"350", align:"center", sort:false}
			, {key:"edudate", label:"기간", width:"250", align:"center", sort:false}
			
			, {key:"conditiontype", label:"", width:"0", align:"center", sort:false, display:false}
			, {key:"abotypecode", label:"", width:"0", align:"center", sort:false, display:false}
			, {key:"abotypeabove", label:"", width:"0", align:"center", sort:false, display:false}
			, {key:"pincode", label:"", width:"0", align:"center", sort:false, display:false}
			, {key:"pinabove", label:"", width:"0", align:"center", sort:false, display:false}
			, {key:"pinunder", label:"", width:"0", align:"center", sort:false, display:false}
			, {key:"bonuscode", label:"", width:"0", align:"center", sort:false, display:false}
			, {key:"bonusunder", label:"", width:"0", align:"center", sort:false, display:false}
			, {key:"bonusabove", label:"", width:"0", align:"center", sort:false, display:false}
			, {key:"agecode", label:"", width:"0", align:"center", sort:false, display:false}
			, {key:"ageunder", label:"", width:"0", align:"center", sort:false, display:false}
			, {key:"ageabove", label:"", width:"0", align:"center", sort:false, display:false}
			, {key:"loacode", label:"", width:"0", align:"center", sort:false, display:false}
			, {key:"diacode", label:"", width:"0", align:"center", sort:false, display:false}
			, {key:"customercode", label:"", width:"0", align:"center", sort:false, display:false}
			, {key:"consecutivecode", label:"", width:"0", align:"center", sort:false, display:false}
			, {key:"businessstatuscode", label:"", width:"0", align:"center", sort:false, display:false}
			, {key:"targetcode", label:"", width:"0", align:"center", sort:false, display:false}
			, {key:"targetmember", label:"", width:"0", align:"center", sort:false, display:false}
			, {key:"startdate", label:"", width:"0", align:"center", sort:false, display:false}
			, {key:"enddate", label:"", width:"0", align:"center", sort:false, display:false}
			
			, {
				key:"edit", label:"수정", width:"100", align:"center", sort:false, formatter: function () {
					return "<a href=\"javascript:;\" class=\"btn_green\" onclick=\"javascript:goConditionWrite('U', '"+ this.item.conditiontype + "', '"+ this.item.conditionseq + "');\">수정</a> ";
			}}
		]
		var gridParam = {
			colGroup : _colGroup
			, fitToWidth: true
			, colHead : { heights: [25,25]}
			, targetID : "AXGridTarget"
			, height : "320px"
		}
		
		fnGrid.nonPageGrid(listGrid, gridParam);
	}, doSearch : function() {

		// Param 셋팅(검색조건)
		var initParam = {
			categoryid : $("#categoryid").val()	
			, courseid : $("#courseid").val()
		};
		
		$.extend(defaultParam, initParam);
		
		$.ajaxCall({
	   		url: "<c:url value="/manager/lms/course/lmsConditionListAjax.do"/>"
	   		, data: defaultParam
	   		, success: function( data, textStatus, jqXHR){
	   			if(data.result < 1){
	        		alert("<spring:message code="errors.load"/>");
	        		return;
				} else {
					callbackList(data);
				}
	   		},
	   		error: function( jqXHR, textStatus, errorThrown) {
	           	alert("<spring:message code="errors.load"/>");
	   		}
	   	});

	   	function callbackList(data) {
	   		 
	   		var obj = data; //JSON.parse(data);
	   		// Grid Bind
	   		var gridData = {
				list: obj.dataList
			};			   		
	   		$("#totalcount").text(obj.totalcount);
	   		
	   		// Grid Bind Real
	   		listGrid.setData(gridData);
	   		
	   		listArr = data.dataList;
	   	}
	}
}
var gridEvent = {
	chkDelete : function() {
		// 선택 정보 삭제전 메세지 출력
		var checkedList = listGrid.getCheckedListWithIndex(0);
		var len = checkedList.length;
		if(len == 0){
			alert("선택된 조건이 없습니다.");
			return;
		}
		var result = confirm("선택한 조건을 삭제 하겠습니까?"); 
		
		var tempList = []; 
		var tempIdx = 0;
		for(var i=0; i<listArr.length; i++) {
			var isChecked = false;
			for(var k=0; k<checkedList.length; k++) {
				if( listArr[i].conditionseq == checkedList[k].item.conditionseq ) {
					isChecked = true;
					break;
				}
			}

			if(!isChecked) {
				tempList[tempIdx] = listArr[i];
				tempList[tempIdx].conditionseq = tempIdx + 1;
				tempList[tempIdx].no = tempIdx + 1;
				
				tempIdx ++;
			}
		}
		
		//그래드 재 읽기 및 카운트 재 조정
		$("#totalcount").text(tempList.length);
   		
   		// Grid Bind Real
   		var gridData = {
			list: tempList
		};
   		
   		listGrid.setData(gridData);
   		
   		listArr = tempList;
	}
}
var goConditionWrite = function( inuptVal, searchconditiontypeVal, conditionseqVal ) {
	//수정일 경우에는 검색구분 선택하여 넘길것
	var param = {
		categoryid : $("#categoryid").val()	
		, courseid : $("#courseid").val()
		, conditionseq : conditionseqVal
		, searchconditiontype : searchconditiontypeVal
		, inputtype : inuptVal
 	};
	
	//기존 입력했던 값을 붙여서 팝업에 보낸다.
	if( inuptVal == "U" ) {
		//날짜 값 있으면 날짜, 분, 초 읽어오기
		var startdateyymmdd = "";
		var startdatehh = "";
		var startdatemm = "";
		var enddateyymmdd = "";
		var enddatehh = "";
		var enddatemm = "";
		
		if( listArr[conditionseqVal-1].startdate != "" ) {
			startdateyymmdd = listArr[conditionseqVal-1].startdate.substring(0,10);
			startdatehh = listArr[conditionseqVal-1].startdate.substring(11,13);
			startdatemm = listArr[conditionseqVal-1].startdate.substring(14,16);
		}
		if( listArr[conditionseqVal-1].enddate != "" ) {
			enddateyymmdd = listArr[conditionseqVal-1].enddate.substring(0,10);
			enddatehh = listArr[conditionseqVal-1].enddate.substring(11,13);
			enddatemm = listArr[conditionseqVal-1].enddate.substring(14,16);
		}
		
		var paramafter = {
			conditiontype : listArr[conditionseqVal-1].conditiontype
			, abotypecode : listArr[conditionseqVal-1].abotypecode
			, abotypeabove : listArr[conditionseqVal-1].abotypeabove
			, pincode : listArr[conditionseqVal-1].pincode
			, pinabove : listArr[conditionseqVal-1].pinabove
			, pinunder : listArr[conditionseqVal-1].pinunder
			, bonuscode : listArr[conditionseqVal-1].bonuscode
			, bonusunder : listArr[conditionseqVal-1].bonusunder
			, bonusabove : listArr[conditionseqVal-1].bonusabove
			, agecode : listArr[conditionseqVal-1].agecode
			, ageunder : listArr[conditionseqVal-1].ageunder
			, ageabove : listArr[conditionseqVal-1].ageabove
			, loacode : listArr[conditionseqVal-1].loacode
			, diacode : listArr[conditionseqVal-1].diacode
			, customercode : listArr[conditionseqVal-1].customercode
			, consecutivecode : listArr[conditionseqVal-1].consecutivecode
			, businessstatuscode : listArr[conditionseqVal-1].businessstatuscode
			, targetcode : listArr[conditionseqVal-1].targetcode
			, targetmember : listArr[conditionseqVal-1].targetmember
			, startdate : listArr[conditionseqVal-1].startdate
			, enddate : listArr[conditionseqVal-1].enddate
			, startdateyymmdd : startdateyymmdd
			, startdatehh : startdatehh
			, startdatemm : startdatemm
			, enddateyymmdd : enddateyymmdd
			, enddatehh : enddatehh
			, enddatemm : enddatemm
		}
		$.extend(param, paramafter);
	}
 	
 	var popParam = {
 		url : "/manager/lms/course/lmsCourseConditionPop.do"
 		, width : "1000"
 		, height : "840"
 		, maxHeight : 840
 		, params : param
 		, targetId : "searchPopup"
 	}
 	window.parent.openManageLayerPopup(popParam);
}
var fn_addGrid = function(inputVal){
	//신규 항목 입력 : 정렬 신경쓸것
	var tempParam = {
		conditionseq : listArr.length + 1	
		, no : listArr.length + 1	
	};
	$.extend(inputVal, tempParam);
	
	listArr.push(inputVal);
	
	//신규 값 입력에 따른 order 재 조정
	//conditiontype : 1, 2, 3으로 conditionseq, no 조정할 것
	var tempListArr = [];
	var idx = 0;
	for(var k=1; k<=3; k++) {
		for( var i=0; i<listArr.length; i++ ) {
			if( eval(listArr[i].conditiontype) == k ) {
				tempListArr[idx] = listArr[i];
				
				tempListArr[idx].conditionseq = idx + 1;
				tempListArr[idx].no = idx + 1;
				
				idx ++;
			}
		}
	}
	listArr = tempListArr;
	
	listGrid.setList(listArr);
	$("#totalcount").text(listArr.length);
}
var fn_updateGrid = function(inputVal){
	//기존 항목 수정
	listArr[inputVal.conditionseq - 1] = inputVal;
	listGrid.setList(listArr);
}

var stampflagClick = function(stampflag){
	if(stampflag == "N"){
		$("#stampid").hide();
		$("#stampid").val("0");
	}else{
		$("#stampid").show();
	}
}
var themeButtonClick = function(){
	if($("#themeseqtype").val()=="1"){
		$("#themeseqtype").val("2");
		$("#themeseq").show();
		$("#themename").hide();
	}else{
		$("#themeseqtype").val("1");
		$("#themeseq").hide();
		$("#themeseq").val("");
		$("#themename").show();
		$("#themename").val("");
	}
	var preopenflag = $("#preopenflag").val();
	var prethemeseq = $("#prethemeseq").val();

	var themeButtonTitle = "기존테마에 추가하기";
	if($("#themeseqtype").val() == "2"){
		themeButtonTitle = "신규테마에 추가하기";
	}
	$("#themeButton").text(themeButtonTitle);
};

var imageSubmit = function(){
	
	// 저장전 Validation
	if(!confirm("정규과정 정보를 저장하시겠습니까?")){
		return;
	}
	$("#categoryid").val($("#searchcategoryid").val());
	if(!chkValidation({chkId:"#frm", chkObj:"hidden|input|select|textarea"}) ){
		return;
	}
	var stampflag = $("input:radio[name='stampflag']:checked").val();
	if(stampflag == "Y"){
		if($("#stampid").val() == "0"){
			alert("정규과정 스탬프를 선택해 주세요.");
			return;
		}
	}
	if(!stampDupCheck()){
		return;
	}
	//대상자 정보 체크하기
	if( listArr.length == 0 ) {
		alert("대상자 정보를 입력하세요.");
		return;
	}
	var conditionCount1 = 0;
	var conditionCount2 = 0;
	var conditionDateCount = 0;
	var conditionDateCount1 = 0;
	var conditionDateCount2 = 0;
	var conditionDateCount3 = 0;
	var minSearchDate = "";
	var maxSearchDate = "";
	var minRecoDate = "";
	var maxRecoDate = "";
	for( var i=0; i<listArr.length; i++ ) {
		if( listArr[i].conditiontype == "1" || listArr[i].conditiontype == "2" ) {
			if( listArr[i].startdate == "" ) {
				conditionDateCount ++;
			}
			if( listArr[i].conditiontype == "1" ) conditionCount1 ++;
			if( listArr[i].conditiontype == "2" ) conditionCount2 ++;
		} else if( listArr[i].conditiontype == "3" ) {
			if( listArr[i].startdate == "" ) {
				conditionDateCount ++;
			}
		}
		if( listArr[i].startdate == "" ) {
			if( listArr[i].conditiontype == "1" ) conditionDateCount1 ++;
			if( listArr[i].conditiontype == "2" ) conditionDateCount2 ++;
			if( listArr[i].conditiontype == "3" ) conditionDateCount3 ++;
		}
		if( listArr[i].startdate != "" ) { // 제일 작은 시간
			if( listArr[i].conditiontype == "1" ){ // 조회권한
				if(minSearchDate == "" || minSearchDate > listArr[i].startdate){
					minSearchDate = listArr[i].startdate
				}
			}
			if( listArr[i].conditiontype == "3" ){ // 추천권한
				if(minRecoDate == "" || minRecoDate > listArr[i].startdate){
					minRecoDate = listArr[i].startdate
				}
			}
		}
		if( listArr[i].enddate != "" ) { // 제일 큰 시간
			if( listArr[i].conditiontype == "1" ){ // 조회권한
				if(maxSearchDate == "" || maxSearchDate < listArr[i].enddate){
					maxSearchDate = listArr[i].enddate
				}
			}
			if( listArr[i].conditiontype == "3" ){ // 추천권한
				if(maxRecoDate == "" || maxRecoDate < listArr[i].enddate){
					maxRecoDate = listArr[i].enddate
				}
			}
		}	
	}
	if( conditionCount1 == 0 || conditionCount2 == 0 ) {
		alert("대상자 정보 중 노출권한, 이용권한을 반드시 입력하여야 합니다.");
		return;
	}
	if( conditionDateCount1 > 0 ) {
		alert("노출권한의 기간을 입력하세요.");
		return;
	}
	if( conditionDateCount2 > 0 ) {
		alert("이용권한의 기간을 입력하세요.");
		return;
	}
	if( conditionDateCount3 > 0 ) {
		alert("추천권한의 기간을 입력하세요.");
		return;
	}
	/* 
	if(minRecoDate!="" && maxRecoDate!=""){
		if(minSearchDate > minRecoDate){
			alert("추천권한 시작일이 노출권한 시작일 보다 이전입니다.");
			return;
		}
		if(maxSearchDate < maxRecoDate){
			alert("추천권한 종료일이 노출권한 종료일 보다 이후입니다.");
			return;
		}
	}
	*/
	//대상자 정보 체크하기 끝
	
	if($("#courseimagefile").val().length<1 && $("#courseimage").val().length<1){
		alert("대표이미지를 등록해 주세요.");
		return;
	}
	
	if($("#coursecontent").val().length > 500){
		alert("교육소개를 500자 이내로 입력해 주세요.");
		$("#coursecontent").focus();
		return;
	}
	
	// 단계 유무 체크
	if($("select[name=steporder]").length == 0 ){
		alert("정규과정 단계가 없습니다.");
		return;
	}
	// 단계 중복 여부 체크
	var steporderdupnum = "";
	$("select[name=steporder]").each(function(i){
		var steporder1 = $(this).val();
		$("select[name=steporder]").each(function(j){
			var steporder2 = $(this).val();
			if(i != j){
				if(steporder1 == $(this).val()){
					steporderdupnum = steporder1;
					return false;
				}
			}
		});
	});
	if(steporderdupnum != ""){
		alert(steporderdupnum + "단계가 중복되었습니다.");
		return;
	}
	// 단계에 과정 있는지 체크
	var stepordernullnum = "";
	$("input[name=stepseq]").each(function(i){
		var copyId = $(this).val();
		if($("input[name=stepcourseid"+copyId+"]").length == 0){
			stepordernullnum = $("#steporder"+copyId).val();
			return false;
		}
	});
	if(stepordernullnum != ""){
		alert(stepordernullnum + "단계에 등록된 과정이 없습니다.");
		return;
	}
	// 단계별 필수과정이 수료과정수보다 작은지 체크
	var stepordermustovernum = "";
	var steporderrealovernum = "";
	$("input[name=stepseq]").each(function(i){
		var copyId = $(this).val();
		var stepcount = $("#stepcount"+copyId).val();
		var steprealcount =  0;
		var stepmustcount =  0;
		$("select[name=coursemustflag"+copyId+"]").each(function(index){
			steprealcount = steprealcount + 1;
			if($(this).val() == "Y"){
				stepmustcount = stepmustcount + 1;
			}
		});
		if(stepcount < stepmustcount){
			stepordermustovernum = $("#steporder"+copyId).val();
			return false;
		}
		if(stepcount > steprealcount){
			steporderrealovernum = $("#steporder"+copyId).val();
			return false;
		}
	});
	if(stepordermustovernum != ""){
		alert(stepordermustovernum + "단계에 등록된 필수 과정수 보다 수료과정수가 적게 등록되었습니다.");
		return;
	}
	if(steporderrealovernum != ""){
		alert(steporderrealovernum + "단계에 등록된 과정수 보다 수료과정수가 많게 등록되었습니다.");
		return;
	}

	//스텝별 시작날짜 검증
	var stepDateCheck = true;
	var stepMinDate = "";
	var totalMinDate = "2100-12-31 23:59:59";
	var stepPreDate = "1900-01-01 00:00:00";
	var sortedStepArray = $("select[name=steporder]").sort(function(a, b){
		  var aNum = Number($(a).val());
		  var bNum = Number($(b).val());
		  return ((aNum < bNum) ? -1 : ((aNum > bNum) ? 1 : 0));
	});
	$(sortedStepArray).each(function(i){
		var stepVal = $(this).val();
		var copyId = $(this).attr("id").replace("steporder","");
		var minDate = "";
		var nextDate = "2100-12-31 23:59:59";
		$("input[name=unitStartDate"+copyId+"]").each(function(i){
			var startdate = $(this).val();
			if(startdate < nextDate){
				minDate = startdate;
				nextDate = startdate;
				if(minDate < totalMinDate){
					totalMinDate = minDate;
				}
			}
		});
		var stepstartdate = minDate;
	
		if(stepPreDate > stepstartdate){
			alert(stepVal + "단계 시작일이 전 단계보다 이전 일자 입니다.");
			stepDateCheck = false;
			return false;
		}
		stepPreDate = stepstartdate;
	});
	if(!stepDateCheck){
		return;
	}
	if($("#courseid").val() == ""){ // 등록인 경우만 체크한다.
		if(totalMinDate < nowDate){
			if(!confirm("교육시작일이 현재일자보다 이전일자입니다. 교육신청화면에 노출이 안됩니다.계속 진행하시겠습니까?")){
				return;
			}
		}
	}

	$("#stepcounttotal").val($("input[name=stepseq]").length);

	var fileYn = false;
	$( "input:file" ).each(function( index ){
		if($( this ).val().length>0 ){
			fileYn = true;
		}
	});
	if(!fileYn){
		saveSubmit();
		return;
	}
	$("#frm").ajaxForm({
		dataType:"json",
		data:{mode:"course"},
		url:'/manager/lms/common/lmsFileUploadAjax.do',
		beforeSubmit:function(data, form, option){
			return true;
		},
        success: function(result, textStatus){
        	for(i=0; i<result.length;i++){
        		$("#"+result[i].fieldName+"file").val(result[i].FileSavedName);
        	}
        	saveSubmit();
        },
        error: function(){
           	alert("파일업로드 중 오류가 발생하였습니다.");
           	return;
        }
	}).submit();
}
var saveSubmit = function(){
	// 수강생 있는지 체크한다. 
	var courseid = $("#courseid").val();
	$.ajaxCall({
   		url : "/manager/lms/course/lmsRegularWriteStudentAjax.do"
   		, data : {courseid: courseid }
   		, type: 'POST'
   		, async: false
        , contentType: 'application/x-www-form-urlencoded; charset=UTF-8'
   		, success: function( data, textStatus, jqXHR){
   			$("#studentcount").val(data.studentcount) ;
   		},
   		error: function( jqXHR, textStatus, errorThrown) {
           	alert("<spring:message code="errors.load"/>");
           	return;
   		}
   	}); 
	
	if($("#studentcount").val() != "0"){
		alert("기본/대상자/콘텐츠 정보 수정은 적용 가능하지만 등록된 수강생이 있을 경우 단계별 과정정보는 수정되지 않습니다.");
	}
	var param = $("#frm").serialize();
	//대상자 정보 직렬화 하기
	var conditionParam = fn_getConditionParam();
	$.ajaxCall({
   		url : "/manager/lms/course/lmsRegularSaveAjax.do"
   		, data : param + "&" + jQuery.param(conditionParam)
   		, type: 'POST'
        , contentType: 'application/x-www-form-urlencoded; charset=UTF-8'
   		, success: function( data, textStatus, jqXHR){
   			if(data.cnt < 1){
           		alert("처리중 오류가 발생하였습니다.");
           		return;
   			} else {
				alert("저장이 완료되었습니다.");
				closeTapAndGoTap(frmid, prefrmid);
				return;
   			}
   		},
   		error: function( jqXHR, textStatus, errorThrown) {
           	alert("<spring:message code="errors.load"/>");
           	return;
   		}
   	}); 
}
function closeTapAndGoTap(closeid, goid){
	try {
		window.parent.setValueTabMenu(goid);
		window.parent.listRefresh(goid);
		window.parent.closeTabMenu(closeid);
	} catch( e ) {
	}
}
var fn_getConditionParam = function() {
	
	var conditiontypeArr = [];
	var abotypecodeArr = [];
	var abotypeaboveArr = [];
	var pincodeArr = [];
	var pinaboveArr = [];
	var pinunderArr = [];
	var bonuscodeArr = [];
	var bonusunderArr = [];
	var bonusaboveArr = [];
	var agecodeArr = [];
	var ageunderArr = [];
	var ageaboveArr = [];
	var loacodeArr = [];
	var diacodeArr = [];
	var customercodeArr = [];
	var consecutivecodeArr = [];
	var businessstatuscodeArr = [];
	var targetcodeArr = [];
	var targetmemberArr = [];
	var startdateArr = [];
	var enddateArr = [];
	for(var i=0; i<listArr.length; i++){
		conditiontypeArr[i] = listArr[i].conditiontype.replace(/,/g, "WNBC");
		if( conditiontypeArr[i] == "" ) conditiontypeArr[i] = "WNB";
		abotypecodeArr[i] = listArr[i].abotypecode.replace(/,/g, "WNBC");
		if( abotypecodeArr[i] == "" ) abotypecodeArr[i] = "WNB";
		abotypeaboveArr[i] = listArr[i].abotypeabove.replace(/,/g, "WNBC");
		if( abotypeaboveArr[i] == "" ) abotypeaboveArr[i] = "WNB";
		pincodeArr[i] = listArr[i].pincode.replace(/,/g, "WNBC");
		if( pincodeArr[i] == "" ) pincodeArr[i] = "WNB";
		pinaboveArr[i] = listArr[i].pinabove.replace(/,/g, "WNBC");
		if( pinaboveArr[i] == "" ) pinaboveArr[i] = "WNB";
		pinunderArr[i] = listArr[i].pinunder.replace(/,/g, "WNBC");
		if( pinunderArr[i] == "" ) pinunderArr[i] = "WNB";
		bonuscodeArr[i] = listArr[i].bonuscode.replace(/,/g, "WNBC");
		if( bonuscodeArr[i] == "" ) bonuscodeArr[i] = "WNB";
		bonusunderArr[i] = listArr[i].bonusunder.replace(/,/g, "WNBC");
		if( bonusunderArr[i] == "" ) bonusunderArr[i] = "WNB";
		bonusaboveArr[i] = listArr[i].bonusabove.replace(/,/g, "WNBC");
		if( bonusaboveArr[i] == "" ) bonusaboveArr[i] = "WNB";
		agecodeArr[i] = listArr[i].agecode.replace(/,/g, "WNBC");
		if( agecodeArr[i] == "" ) agecodeArr[i] = "WNB";
		ageunderArr[i] = listArr[i].ageunder.replace(/,/g, "WNBC");
		if( ageunderArr[i] == "" ) ageunderArr[i] = "WNB";
		ageaboveArr[i] = listArr[i].ageabove.replace(/,/g, "WNBC");
		if( ageaboveArr[i] == "" ) ageaboveArr[i] = "WNB";
		loacodeArr[i] = listArr[i].loacode.replace(/,/g, "WNBC");
		if( loacodeArr[i] == "" ) loacodeArr[i] = "WNB";
		diacodeArr[i] = listArr[i].diacode.replace(/,/g, "WNBC");
		if( diacodeArr[i] == "" ) diacodeArr[i] = "WNB";
		customercodeArr[i] = listArr[i].customercode.replace(/,/g, "WNBC");
		if( customercodeArr[i] == "" ) customercodeArr[i] = "WNB";
		consecutivecodeArr[i] = listArr[i].consecutivecode.replace(/,/g, "WNBC");
		if( consecutivecodeArr[i] == "" ) consecutivecodeArr[i] = "WNB";
		businessstatuscodeArr[i] = listArr[i].businessstatuscode.replace(/,/g, "WNBC");
		if( businessstatuscodeArr[i] == "" ) businessstatuscodeArr[i] = "WNB";
		targetcodeArr[i] = listArr[i].targetcode.replace(/,/g, "WNBC");
		if( targetcodeArr[i] == "" ) targetcodeArr[i] = "WNB";
		targetmemberArr[i] = listArr[i].targetmember.replace(/,/g, "WNBC");
		if( targetmemberArr[i] == "" ) targetmemberArr[i] = "WNB";

		startdateArr[i] = listArr[i].startdate.replace(/,/g, "WNBC") + ":00";
		if( startdateArr[i] == "" ) startdateArr[i] = "WNB";
		enddateArr[i] = listArr[i].enddate.replace(/,/g, "WNBC") + ":00";
		if( enddateArr[i] == "" ) enddateArr[i] = "WNB";
	}
	
	var initParam = {
		conditiontypeArr : conditiontypeArr	
		, abotypecodeArr : abotypecodeArr
		, abotypeaboveArr : abotypeaboveArr
		, pincodeArr : pincodeArr
		, pinaboveArr : pinaboveArr
		, pinunderArr : pinunderArr
		, bonuscodeArr : bonuscodeArr
		, bonusunderArr : bonusunderArr
		, bonusaboveArr : bonusaboveArr
		, agecodeArr : agecodeArr
		, ageunderArr : ageunderArr
		, ageaboveArr : ageaboveArr
		, loacodeArr : loacodeArr
		, diacodeArr : diacodeArr
		, customercodeArr : customercodeArr
		, consecutivecodeArr : consecutivecodeArr
		, businessstatuscodeArr : businessstatuscodeArr
		, targetcodeArr : targetcodeArr
		, targetmemberArr : targetmemberArr
		, startdateArr : startdateArr
		, enddateArr : enddateArr
	};
	
	return initParam;
};
var checkStudent = function(){
	// 수강생 있는지 체크한다. 
	var courseid = $("#courseid").val();
	$.ajaxCall({
   		url : "/manager/lms/course/lmsRegularWriteStudentAjax.do"
   		, data : {courseid: courseid }
   		, type: 'POST'
   		, async: false
        , contentType: 'application/x-www-form-urlencoded; charset=UTF-8'
   		, success: function( data, textStatus, jqXHR){
   			$("#studentcount").val(data.studentcount) ;
   		},
   		error: function( jqXHR, textStatus, errorThrown) {
           	alert("<spring:message code="errors.load"/>");
           	return;
   		}
   	}); 
	
	if($("#studentcount").val() != "0"){
		alert("이미 등록된 수강자가 있어서 정규과정의 단계과 구성과정을 변경할 수 없습니다.");
		return false;
	}
	return true;
}
var fnCheckLength = function( objName, chkLength ) {
	var objValue = $("#"+objName).val();
	if( objValue.length > chkLength ) {
		$("#"+objName).val(objValue.substring(0,chkLength)); 
	}
	$("#"+objName+"Span").html( $("#"+objName).val().length + "/" + chkLength + "자" );
};
var stampDupCheck = function(){
	var returnVar = true;
	var stampid = $("#stampid").val();
	var stampname = $("#stampid option:selected").text();
	var stampthemeseq = $("#stampid option:selected").attr("data-themeseq");
	var stampthemename = $("#stampid option:selected").attr("data-themename");
	var themeseq = $("#themeseq").val();
	var themename = $("#themeseq option:selected").text();
	if(stampid == "0"){ // 스탬프가 선택안된 경우 넘어간다.
		return returnVar;
	}
	if(stampthemeseq != themeseq){
		if(stampthemeseq != ""){ // 다른 테마에 이미 등록되어 있는 스탬프임
			alert(stampname + " 스탬프는 " + stampthemename + " 테마에 이미 등록되어 있습니다.");
			$("#stampid").val("0");
			returnVar = false;
		}
		if(stampthemeseq == "" && themeseq != ""){ // 스탬프는 테마에 등록 안되어 있지만 해당하는 테마에 이미 등록되어 있는 경우 스탬프가 있는지 확인 한다.
			$("#stampid option").each(function(index){
				var otherthemeseq = $(this).attr("data-themeseq");
				var otherthemename = $(this).attr("data-themename");
				var otherstampname = $(this).text();
				if(themeseq == otherthemeseq){
					alert(themename + " 테마에는 이미 " + otherstampname + " 스탬프가 등록되어 있습니다.");
					$("#stampid").val("0");
					returnVar = false;
					return false;
				}
			});
		}
	}
	return returnVar;
};
</script>
</head>

<body class="bgw">

	<!--title //-->
	<div class="contents_title clear">
		<h2 class="fl">정규과정</h2>
	</div>
	
	<!--search table // -->
	<div class="tbl_write">
<form id="frm" name="frm" method="post">
<input type="hidden" id="courseid" name="courseid" value="${detail.courseid}" />
<input type="hidden" id="stepcounttotal"  name="stepcounttotal" value="${detail2.stepcount}">
<input type="hidden" id="studentcount"  name="studentcount" value="${detail2.studentcount}">
		<strong> 기본정보</strong>
		<table id="tblSearch" width="100%" border="0" cellspacing="0" cellpadding="0">
			<colgroup>
				<col width="10%" />
				<col width="*" />
			</colgroup>		
			<tr>
				<th>과정 유형</th>
				<td>정규과정</td>
			</tr>
			
			<tr>
				<th>교육 분류</th>
				<td> 
					<input type="hidden" id="categoryid" name="categoryid" value="${detail.categoryid}"  class="required" title="교육 분류"/>
					<c:set var="courseTypeCode" value="R"/>
					<%@ include file="/WEB-INF/jsp/manager/lms/include/lmsSearchCategory.jsp" %>								
				</td>
			</tr>
			<tr>
				<th>상태</th>
				<td>
					<label class="required"><input type="radio" id="openflag1" name="openflag" value="N"  class="AXInput required openflag" title="상태" <c:if test="${ detail.openflag eq 'N' or empty detail.openflag}">checked</c:if>> 비공개</label>
					<label><input type="radio" id="openflag2" name="openflag" value="Y"  class="AXInput required openflag" title="상태" <c:if test="${ detail.openflag eq 'Y'}">checked</c:if>> 공개</label>
				</td>
			</tr>
			<tr>
				<th>정규과정테마</th>
				<td><span class="required"></span>
					<input type="hidden" id="themeseqtype" name="themeseqtype" value="1">
					<input type="hidden" id="prethemeseq" name="prethemeseq">
					<select id="themeseq" name="themeseq" style="width:auto; min-width:120px;display:none"  title="정규과정테마" >
						<option value="">정규과정테마 선택</option>
						<c:forEach items="${themeList }" var="data" varStatus="status">
							<option value="${data.themeseq }" <c:if test="${detail.themeseq eq data.themeseq}" >selected</c:if>>${data.themename }</option>
						</c:forEach>
					</select>	
					<input type="text" id="themename" name="themename" style="width:200px;" value="${detail.themename}" class="AXInput required" maxlength="50" title="정규과정테마">
					<a href="javascript:;" id="themeButton" class="btn_green">기존테마에 추가하기</a>
				</td>
			</tr>
			<tr>
				<th>정규과정명</th>
				<td><input type="text" id="coursename" name="coursename" style="width:90%;" value="${detail.coursename}" class="AXInput required" maxlength="50" title="정규과정명"></td>
			</tr>
			<tr>
				<th>정원</th>
				<td>
					<input type="text" id="limitcount" name="limitcount" value="${detail2.limitcount }" style="width:80px;"  class="AXInput required isNum" maxlength="7" title="정원">
				</td>
			</tr>
			<tr>
				<th>부사업자 허용</th>
				<td>
					<label class="required"><input type="radio" id="togetherflag1" name="togetherflag" value="N"  class="AXInput required togetherflag" title="부사업자 허용" <c:if test="${ detail2.togetherflag eq 'N' or empty detail2.togetherflag}">checked</c:if>> 불허</label>
					<label><input type="radio" id="togetherflag2" name="togetherflag" value="Y"  class="AXInput required togetherflag" title="부사업자 허용" <c:if test="${ detail2.togetherflag eq 'Y'}">checked</c:if>> 허용</label>
				</td>
			</tr>
			<tr>
				<th>스탬프 적용</th>
				<td>
					<label class="required"><input type="radio" id="stampflag1" name="stampflag" value="N"  class="AXInput required stampflag" title="스탬프 적용" <c:if test="${ detail2.stampflag eq 'N' or empty detail2.stampflag}">checked</c:if>> 비적용</label>
					<label><input type="radio" id="stampflag2" name="stampflag" value="Y"  class="AXInput required stampflag" title="스탬프 적용" <c:if test="${ detail2.stampflag eq 'Y'}">checked</c:if>> 적용</label>
					<select id="stampid" name="stampid" style="width:auto; min-width:120px;display:none"  title="정규과정스탬프" >
						<option value="0" data-themeseq="" data-themename="">정규과정스탬프 선택</option>
						<c:forEach items="${stampList }" var="data" varStatus="status">
							<option value="${data.stampid }" data-themeseq="${data.themeseq }" data-themename="${data.themename }" <c:if test="${detail2.stampid eq data.stampid}" >selected</c:if>>${data.stampname }</option>
						</c:forEach>
					</select>	
				</td>
			</tr>
			<tr>
				<th>AmwayGO 적용</th>
				<td>
					<label class="required"><input type="radio" id="groupflag1" name="groupflag" value="N"  class="AXInput required groupflag" title="AmwayGO 적용" <c:if test="${ detail.groupflag eq 'N' or empty detail.groupflag}">checked</c:if>> 비적용</label>
					<label><input type="radio" id="groupflag2" name="groupflag" value="Y"  class="AXInput required groupflag" title="AmwayGO 적용" <c:if test="${ detail.groupflag eq 'Y'}">checked</c:if>> 적용</label>
				</td>
			</tr>
			<tr>
				<th>취소허용기간</th>
				<td>
					<c:set var="cancelterm" value="${detail.cancelterm }" />
					<c:if test="${empty cancelterm  }">
						<c:set var="cancelterm" value="2" />
					</c:if>
					<input type="text" id="cancelterm" name="cancelterm" style="width:80px;" value="${cancelterm}" class="AXInput required isNum" maxlength="2" title="취소허용기간">
					일 전까지
				</td>
			</tr>
		</table>
	
		<br/>
		
		<strong> 대상자정보</strong>
		<div class="contents_title clear">
			<div class="fl">
				<input type="hidden" name="rowPerPage" value="1000" />
				<a href="javascript:;" id="deleteConditionButton" class="btn_green" style="margin-left:0px;">삭제</a>
				<span> Total : <span id="totalcount"></span>건</span>
			</div>
			
			<div class="fr">
				<div style="float:right;">
					<select id="searchconditiontype" name="searchconditiontype" style="width:auto; min-width:100px"> 
						<option value="1">노출권한</option>
						<option value="2">이용권한</option>
						<option value="3">추천권한</option>
					</select>
					<a href="javascript:;" id="addconditionButton" class="btn_green">추가</a>
				</div>
			</div>
		</div> 
		<div id="AXGrid">
			<div id="AXGridTarget"></div>
		</div>
		
		<br/>
		
		<strong> 컨텐츠 정보</strong>
		<table id="tblSearch2" width="100%" border="0" cellspacing="0" cellpadding="0">
			<colgroup>
				<col width="10%" />
				<col width="130" />
				<col width="*" />
			</colgroup>		
			<tr>
				<th rowspan="3">대표이미지</th>
				<td rowspan="2">
					<div id="courseimageView" style="width:140px;height:80px;float:left;" class="required">
					<c:if test="${not empty detail.courseimage}"><img src="/manager/lms/common/imageView.do?file=${detail.courseimage}&mode=course" width="120" style="max-height:80px;"></c:if>
					</div>
				</td>
				<td>
					<input type="hidden" id="courseimagefile" name="courseimagefile" value="${detail.courseimage}" title="대표이미지" />
					<input type="file" id="courseimage" name="courseimage" accept="image/*" onchange="getThumbnailPrivew(this,$('#courseimageView'), 120 , 80);" title="대표이미지"><br />
				</td>
			</tr>
			<tr>
				<td>
					이미지설명 <input type="text" id="courseimagenote" name="courseimagenote" style="width:60%;" value="${detail.courseimagenote}" class="AXInput required" maxlength="50" title="이미지설명">				
				</td>
			</tr>
			<tr>
				<td colspan="2"> * 이미지파일은 712 * 447 pixel 사이즈로 용량 300KB이하로 업로드해주세요.</td>
			</tr>
			<tr>
				<th>교육소개</th>
				<td colspan="2">
					<textarea id="coursecontent" name="coursecontent" class="AXInput required" style="width:90%;height:100px;" title="교육소개" onkeyup="javascript:fnCheckLength('coursecontent',500);" onkeydown="javascript:fnCheckLength('coursecontent',500);">${detail.coursecontent}</textarea>
					<br><span class="byte" id="coursecontentSpan">0/500자</span>
				</td>
			</tr>
			<tr>
				<th>신청대상(목록)</th>
				<td colspan="2"><input type="text" id="target" name="target" style="width:90%;" value="${detail.target}" class="AXInput required" maxlength="50" title="신청대상(목록)"></td>
			</tr>
			<tr>
				<th>신청대상(상세)</th>
				<td colspan="2"><textarea id="targetdetail" name="targetdetail" class="AXInput required" style="width:90%;height:100px;" title="신청대상(상세)">${detail2.targetdetail}</textarea></td>
			</tr>
			<tr>
				<th>유의사항 및 기타안내</th>
				<td colspan="2"><textarea id="note" name="note" class="AXInput" style="width:90%;height:100px;" title="유의사항 및 기타안내">${detail2.note}</textarea></td>
			</tr>
			<tr>
				<th rowspan="2">유의사항링크</th>
				<td>제목</td>
				<td><input type="text" id="linktitle" name="linktitle" style="width:90%;" value="${detail2.linktitle}" class="AXInput" maxlength="50" title="유의사항링크 제목"></td>
			</tr>
			<tr>
				<td>주소</td>
				<td><input type="text" id="linkurl" name="linkurl" style="width:90%;" value="${detail2.linkurl}" class="AXInput" maxlength="100" title="유의사항링크 주소"></td>
			</tr>		
			<tr>
				<th>페널티</th>
				<td colspan="2"><textarea id="penaltynote" name="penaltynote" class="AXInput" style="width:90%;height:100px;" title="페널티">${detail2.penaltynote}</textarea></td>
			</tr>
			<tr>
				<th>수료기준</th>
				<td colspan="2"><textarea id="passnote" name="passnote" class="AXInput required" style="width:90%;height:100px;" title="수료기준">${detail2.passnote}</textarea></td>
			</tr>
			<tr>
				<th>SNS 공유설정</th>
				<td colspan="2">
					<label class="required"><input type="radio" id="snsflag1" name="snsflag" value="N"  class="AXInput required snsflag" title="SNS 공유설정" <c:if test="${ detail.snsflag eq 'N' or empty detail.snsflag}">checked</c:if>> 비공유</label>
					<label><input type="radio" id="snsflag2" name="snsflag" value="Y"  class="AXInput required snsflag" title="SNS 공유설정" <c:if test="${ detail.snsflag eq 'Y'}">checked</c:if>> 공유</label>
				</td>
			</tr>
			<tr>
				<th>검색용 키워드</th>
				<td colspan="2">
					<input type="text" id="searchword" name="searchword" style="width:90%;" value="${detail.searchword}" class="AXInput" maxlength="500" title="검색용 키워드">
					<br>* 검색용 키워드를 여러개 등록하는 경우는 쉼표(,)로 구분하여 등록하여 주세요.
				</td>
			</tr>
		</table>

		<br/><br/>
		<div style="width:100%" class="contents_title clear">
			<strong> 단계별 과정정보</strong>
			<a href="javascript:;" class="btn_green btn_right" onclick="addStepClick()">단계 추가</a>
		</div>
		<div id="stepDivTarget">

		</div>
</form>
	</div>
		
	<div align="center">
		<a href="javascript:;" id="insertBtn" class="btn_green">저장</a>&nbsp;&nbsp;
		<a href="javascript:;" id="cancelBtn" class="btn_green">취소</a>
	</div>
	
	<div id="stepDiv" style="display:none">

		<table id="stepTableCopyId" style="margin-bottom: 40px;" width="100%" border="0" cellspacing="0" cellpadding="0">
			<colgroup>
				<col width="10%" />
				<col width="*" />
			</colgroup>		
			<tr>
				<th>순서</th>
				<td>
					<input type="hidden" id="stepseqCopyId"  name="stepseqCopyName" value="CopyId">
					<select id="steporderCopyId" name="steporderCopyName" style="width:auto; min-width:80px" onclick="scc(this);"></select>
					<a href="javascript:;" class="btn_green btn_right" onclick="delStep('CopyId')">단계삭제</a></td>
			</tr>
			<tr>
				<th>단계명</th>
				<td><input type="text" id="stepnameCopyId" name="stepnameCopyName" style="width:50%;" value="" class="AXInput required" maxlength="50" title="단계명" onfocus="scc1(this);" onchange="scc2(this);"></td>
			</tr>
			<tr>
				<th>구성과정</th>
				<td class="tbl_write2">
					<div style="width:100%" class="contents_title clear">
						<a href="javascript:;" class="btn_green" onclick="delStepUnit('CopyId')">삭제</a>
						<span style="float:right;vertical-align: middle;">
							*오프라인 과정만으로 구성된 단계는 필수 여부를 "선택"으로 처리 필요
							<a href="javascript:;" class="btn_green " onclick="addStepUnit('CopyId')">추가</a>
						</span>
					</div>
					
					<table id="stepUnitTableCopyId" width="100%" border="0" cellspacing="0" cellpadding="0">
						<colgroup>
							<col width="50px" />
							<col width="50px" />
							<col width="150px" />
							<col width="*" />
							<col width="160px" />
							<col width="80px" />
							<col width="80px" />
							<col width="80px" />
						</colgroup>
						<tr>
							<th><input type="checkbox"  onclick="checkStepUnit(this, 'CopyId')"></th>
							<th>No</th>
							<th>과정구분</th>
							<th>과정/자료명</th>
							<th>교육기간</th>
							<th>필수여부</th>
							<th>순서</th>
							<th>관리</th>
						</tr>

					</table>
				</td>
			</tr>
			<tr>
				<th>수료과정수</th>
				<td>
					<span id="spanStepUnitCountCopyId">0</span> 과목 중 <input type="text" id="stepcountCopyId" name="stepcountCopyName" value="0" style="width:50px;" class="AXInput required isNum" maxlength="5" title="수료과정수" onfocus="scc1(this);" onchange="scc2(this);"> 이상
					<input type="hidden" id="mustflagCopyId" name="mustflagCopyName" value="N">
				</td>
			</tr>
		</table>
	</div>
	<table id="stepUnitCopyTable" style="display:none;">
		<tr>
			<td style="text-align:center;"><input type="checkbox" name="checkStepUnitCopyId" value="">
					<input type="hidden" class="stepcourseidCopyName"  name="stepcourseidCopyIdCopyName" value="CourseId">
					<input type="hidden" id="themeseqdupCopyId_CourseId"  name="themeseqdupCopyName" value="">
					<input type="hidden" id="unitStartDateCopyId_CourseId" name="unitStartDateCopyIdCopyName" value="">
					<input type="hidden" id="unitEndDateCopyId_CourseId" name="unitEndDateCopyIdCopyName" value="">
			</td>
			<td class="trOrderNumCopyId" style="text-align:center;">1</td>
			<td id="categorytreenameCopyId_CourseId" style="text-align:center;">courseTypeName</td>
			<td id="coursenameCopyId_CourseId">courseName</td>
			<td id="edudateCopyId_CourseId">eduDate</td>
			<td><select id="coursemustflagCopyId_CourseId" name="coursemustflagCopyIdCopyName" onchange="changecoursemustflag('CopyId','CourseId'); "  onclick="scc(this);" class="AXInput"  style="width:auto; min-width:60px">
						<option value="N">선택</option>								
						<option value="Y">필수</option>
					</select>
			</td>
			<td><input type="text" id="unitorderCopyId_CourseId" name="unitorderCopyIdCopyName" value="1" style="width:50px;" class="AXInput required isNum" maxlength="5" title="순서" onfocus="scc1(this);" onchange="scc2(this);"></td>
			<td><a href="javascript:;" class="btn_green" onclick="editStepUnit('CopyId','CourseId','CourseType')">수정</a></td>
		</tr>
	</table>
<script type="text/javascript">
var copyId = 1;
$(document.body).ready(function(){
	 if($("#courseid").val() != ""){ // 수정페이지인경우 기존 스텝 데이터 가져와서 값 셋팅해주기
			$.ajaxCall({
		   		url: "/manager/lms/course/lmsRegularStepUnitSumListAjax.do"
		   		, data: {courseid : $("#courseid").val() }
		   		, async : false
		   		, success: function( data, textStatus, jqXHR){
		   			if(data.result < 1){
		        		alert("<spring:message code="errors.load"/>");
		        		return;
					} else {
						for(var i = 0; i<data.stepList.length; i++){
							addStep(data.stepList[i]);	
						}
					}
		   		},
		   		error: function( jqXHR, textStatus, errorThrown) {
		           	alert("<spring:message code="errors.load"/>");
		   		}
		   	});
	 }
});
//단계 추가 버튼 클릭한 경우
function addStepClick(param){
	if(checkManagerAuth(managerMenuAuth)){return;}
	if($("#courseid").val() != ""){
		if(!checkStudent()){return false;}	
	}
	addStep();
}
//단계 추가
function addStep(param){
	var html = $("#stepDiv").html();
	html = html.replace(/CopyId/g,copyId);
	html = html.replace(/CopyName/g,"");
	$("#stepDivTarget").append(html);
	resetStepOrderSelect();
	
	if(param != null){
		$("#stepname"+copyId).val(param.stepname);
		$("#stepcount"+copyId).val(param.stepcount);
		if(param.unitlist != null){
			for(var i=0; i < param.unitlist.length; i++){
				param.unitlist[i].copyId = copyId; 
				addStepUnitReal(param.unitlist[i])
			}
		}
	}
	copyId = copyId + 1; 
	myIframeResizeHeight(frmid);
}
//과정 추가 버튼 클릭
function addStepUnit(copyId){
	if(checkManagerAuth(managerMenuAuth)){return;}
	if(!checkStudent()){return false;}
	var popParam = {
			url : "/manager/lms/course/lmsRegularCourseSearch.do"
			, width : 1024
			, height : 900
			, maxHeight : 900
			, params : {copyId : copyId}
			, targetId : "searchPopup"
	}
	window.parent.openManageLayerPopup(popParam);
}
//과정 추가 선택 리턴 및 유효성 체크
function addStepUnitReturn(param){
	var copyId = param.copyId;
	var courseId = param.courseid;
	var themeseqdup = param.themeseq;
	var coursetype = param.coursetype;
	var dupCheck = false;
	if(coursetype == "F"){
		$("input[name=themeseqdup]").each(function(index){
			if( $(this).val() == themeseqdup ){
				alert("해당테마는 이미 적용되어 있습니다.");
				dupCheck = true;
				return false;
			} 
		});
		if(dupCheck){return;};
		// 오프라인인 경우 해당 테마 읽어서 과정별로 입력해준다.
		$.ajaxCall({
	   		url: "/manager/lms/course/lmsRegularOffCourseListAjax.do"
	   		, data: {themeseq : themeseqdup}
	   		, async : false
	   		, success: function( data, textStatus, jqXHR){
	   			if(data.result < 1){
	        		alert("<spring:message code="errors.load"/>");
	        		return;
				} else {
					for(var i = 0; i<data.dataList.length; i++){
						data.dataList[i].copyId = copyId;
						data.dataList[i].coursemustflag = "N";
						addStepUnitReal(data.dataList[i]);	
					}
				}
	   		},
	   		error: function( jqXHR, textStatus, errorThrown) {
	           	alert("<spring:message code="errors.load"/>");
	   		}
	   	});
	}else{
		$(".stepcourseid").each(function(index){
			if( $(this).val() == courseId ){
				alert("해당과정은 이미 적용되어 있습니다.");
				dupCheck = true;
				return false;
			} 
		});
		if(dupCheck){return;};
		addStepUnitReal(param);
	}
	myIframeResizeHeight(frmid);
}
// 과정  로우 추가
function addStepUnitReal(param){
	var copyId = param.copyId;
	var courseId = param.courseid;
	var themeseqdup = param.themeseq;
	var coursetype = param.coursetype;
	
	var html = $("#stepUnitCopyTable").html();
	html = html.replace(/CopyId/g,copyId);
	html = html.replace(/CourseId/g,courseId);
	html = html.replace(/CopyName/g,"");
	html = html.replace(/courseTypeName/g,param.coursetypename);
	html = html.replace(/CourseType/g,param.coursetype);
	html = html.replace(/courseName/g,param.coursename);
	html = html.replace(/eduDate/g,param.edudate);
	$("#stepUnitTable"+copyId).append(html);
	trOrderNumSet(copyId);
	$("#coursemustflag"+copyId+"_"+courseId).val(param.coursemustflag);
	$("#themeseqdup"+copyId+"_"+courseId).val(param.themeseq);
	var courseNum = $("input[name=unitorder"+copyId+"]").length;
	$("#unitorder"+copyId+"_"+courseId).val(courseNum);
	$("#spanStepUnitCount"+copyId).text(courseNum);
	$("#unitStartDate"+copyId+"_"+courseId).val(param.startdate);
	$("#unitEndDate"+copyId+"_"+courseId).val(param.enddate);
}

// 단계 콤보 생성
function createStepOrderSelect(copyId, selectedVal){
	var targetObj = "steporder"+copyId;
	var endCnt = $("input[name=stepseq]").length;
	var realHTML = "";
	for(var i = 1; i <= endCnt; i++){
		realHTML += "<option value='"+i+"'>"+i+" 단계</option>";
	}
	$("#" + targetObj + " option").remove();
	$("#" + targetObj).append(realHTML);
	if(selectedVal == null || selectedVal == ""){
		$("input[name=stepseq]").each(function(index){
			if($(this).val() == copyId){
				selectedVal = index+1;
			}
		});
	}
	$("#" + targetObj).val(selectedVal);
}
//No. 재설정
function trOrderNumSet(copyId){
	$(".trOrderNum"+copyId).each(function(index){
		$(this).text(index+1);
	});	
}
//유닛 삭제
function delStepUnit(copyId){
	if(checkManagerAuth(managerMenuAuth)){return;}
	if(!checkStudent()){return false;}
	if(!confirm("선택된 과정을 삭제하겠습니까?")){return;}
	$("input[name=checkStepUnit"+copyId+"]").each(function(index){
		if($(this).is(":checked") == true){
			$(this).parent().parent().remove();
		}
	});	
	trOrderNumSet(copyId);
	var courseNum = $("input[name=unitorder"+copyId+"]").length;
	$("#spanStepUnitCount"+copyId).text(courseNum);
}
//전체 선택
function checkStepUnit(obj, copyId){
	var checked = obj.checked;
	$("input[name=checkStepUnit"+copyId+"]").prop("checked", checked);
}
//단계 삭제
function delStep(copyId){
	if(checkManagerAuth(managerMenuAuth)){return;}
	if(!checkStudent()){return false;}
	if(!confirm("단계를 삭제하겠습니까?")){
		return;
	}
	$("#stepTable"+copyId).remove();
	resetStepOrderSelect();
}
// 순서 재설정
function resetStepOrderSelect(){
	var len = $("input[name=stepseq]").length;
	$("input[name=stepseq]").each(function(index){
		createStepOrderSelect($(this).val());
	});	
}
//과정수정
function editStepUnit(copyId, courseId, coursetype){
	var width = 900, height = 350;
	var url = "/manager/lms/course/lmsRegularCourseEdit.do"; // 온라인,  라이브, 교육자료, 설문지
	if(coursetype == "F"){
		url = "/manager/lms/course/lmsRegularCourseEditOff.do";	//오프라인
		width = 1024;
		height = 400;
	}else if(coursetype == "T"){
		url = "/manager/lms/course/lmsRegularCourseEditTest.do";	//시험
	}
	var popParam = {
			url : url
			, width : width
			, height : height
			, maxHeight : 800
			, params : {copyId : copyId, courseid: courseId, coursetype: coursetype}
			, targetId : "searchPopup"
	}
	window.parent.openManageLayerPopup(popParam);
}
// 과정수정 후 리턴받는 함수
function editStepUnitReturn(param){
	var courseid = param.courseid;
	var copyId = param.copyId;
	var startdateyymmdd = param.startdateyymmdd;
	var enddateyymmdd = param.enddateyymmdd;
	var edudate = startdateyymmdd + " ~ " + enddateyymmdd;
	$("#edudate"+copyId+"_"+courseid).text(edudate);
	$("#unitStartDate"+copyId+"_"+courseid).val(param.startdate);
	$("#unitEndDate"+copyId+"_"+courseid).val(param.enddate);
} 
// 필수 여부 선택 시 단계별 수료과정수 자동으로 변경하게  
function changecoursemustflag(copyId, courseid){
	var stepMustCount = 0;
	$("select[name=coursemustflag"+copyId+"]").each(function(i){
		if($(this).val() == "Y"){
			stepMustCount++;
		}
	});
	$("#stepcount"+copyId).val(stepMustCount);
}
</script>
</body>
</html>