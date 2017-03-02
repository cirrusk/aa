<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ include file="/WEB-INF/jsp/manager/frame/include/top.jsp" %>
<!-- js/이미지/공통  include -->
<%@ include file="/WEB-INF/jsp/manager/frame/include/include.jsp" %>
<script type="text/javascript">	
var managerMenuAuth ="${managerMenuAuth}";
var frmid = "${param.frmId}";
var prefrmid = "${param.prefrmId}";
var defaultParam = {
 	sortColKey: "lms.banner.list"
};
var listGrid = new AXGrid(); // instance 상단그리드

var positionVal = "";

$(document.body).ready(function(){
	$("#insertBtn").on("click", function(){
		if(checkManagerAuth(managerMenuAuth)){return;}
		imageSubmit();
	});
	$("#cancelBtn").on("click", function(){
		closeTapAndGoTap(frmid, prefrmid);
	});
	
	$(".position").on("click", function(){
		positionChanged($(this).val());
	});
	positionVal = $("input:radio[name='position']:checked").val();
	positionChanged(positionVal);
	
	$("#deleteConditionButton").on("click", function(){
		if(checkManagerAuth(managerMenuAuth)){return;}
		gridEvent.chkDelete();
	});
	$("#addconditionButton").on("click", function(){
		if(checkManagerAuth(managerMenuAuth)){return;}
		goConditionWrite("I", $("#searchconditiontype").val(), "");
	});
	
	$(".openflag").on("click", function(){
		if($(this).val() == "N" && $("#old_openflag").val() == "Y"){
			$("#bannerorder").val("100");		
		}
	});
	
	list.init();
	list.doSearch();

	myIframeResizeHeight(frmid);

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
			bannerid : $("#bannerid").val()
		};
		
		$.extend(defaultParam, initParam);
		
		$.ajaxCall({
	   		url: "<c:url value="/manager/lms/banner/lmsConditionListAjax.do"/>"
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
		bannerid : $("#bannerid").val()
		, conditionseq : conditionseqVal
		, searchconditiontype : searchconditiontypeVal
		, inputtype : inuptVal
		, coursetype : "D"
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
 		url : "/manager/lms/banner/lmsBannerConditionPop.do"
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
var positionChanged = function(str){
	positionVal = str;
	if(str == "P"){
		$(".pcTr").show();
		$(".mobileTr").hide();
	}else if(str == "M"){
		$(".pcTr").hide();
		$(".mobileTr").show();
	}else{
		$(".pcTr").show();
		$(".mobileTr").show();
	}
	myIframeResizeHeight(frmid);
}
var imageSubmit = function(){
	// 저장전 Validation
	if(!confirm("배너 정보를 저장하시겠습니까?")){
		return;
	}
	
	if(!chkValidation({chkId:"#frm", chkObj:"hidden|input|select|textarea"}) ){
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
	if( conditionCount1 == 0) {
		alert("기간 및 대상자 정보 중 노출권한을 반드시 입력하여야 합니다.");
		return;
	}
	if( conditionDateCount1 > 0 ) {
		alert("노출권한의 기간을 입력하세요.");
		return;
	}
	//대상자 정보 체크하기 끝
	if(positionVal == "P" || positionVal == "A"){
		if($("#pcimagefile").val().length<1 && $("#pcimage").val().length<1){
			alert("PC배너이미지를 등록해 주세요.");
			return;
		}
		if($("#pcimagenote").val().length<1 ){
			alert("PC이미지 설명을 입력해 주세요.");
			$("#pcimagenote").focus();
			return;
		}
	}
	
	
	if(positionVal == "M" || positionVal == "A"){
		if($("#mobileimagefile").val().length<1 && $("#mobileimage").val().length<1){
			alert("MOBILE배너이미지를 등록해 주세요.");
			return;
		}
		if($("#mobileimagenote").val().length<1 ){
			alert("MOBILE이미지 설명을 입력해 주세요.");
			$("#mobileimagenote").focus();
			return;
		}
	}
	
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
	var param = $("#frm").serialize();
	//대상자 정보 직렬화 하기
	var conditionParam = fn_getConditionParam();
	$.ajaxCall({
   		url : "<c:url value="/manager/lms/banner/lmsBannerSaveAjax.do"/>"
   		, data : param + "&" + jQuery.param(conditionParam)
   		, type: 'POST'
        , contentType: 'application/x-www-form-urlencoded; charset=UTF-8'
   		, success: function( data, textStatus, jqXHR){
   			if(data.cnt < 1){
           		alert("처리중 오류가 발생하였습니다..");
           		return;
   			} else {
				alert("저장이 완료되었습니다.");
				closeTapAndGoTap(frmid, prefrmid);
				return;
   			}
   		},
   		error: function( jqXHR, textStatus, errorThrown) {
           	alert("<spring:message code="errors.load"/>.");
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
var fnCheckLength = function( objName, chkLength ) {
	var objValue = $("#"+objName).val();
	if( objValue.length > chkLength ) {
		$("#"+objName).val(objValue.substring(0,chkLength)); 
	}
	$("#"+objName+"Span").html( $("#"+objName).val().length + "/" + chkLength + "자" );
};
</script>
</head>

<body class="bgw">

	<!--title //-->
	<div class="contents_title clear">
		<h2 class="fl">배너등록</h2>
	</div>
	
	<!--search table // -->
	<div class="tbl_write">
<form id="frm" name="frm" method="post">
<input type="hidden" id="bannerid" name="bannerid" value="${detail.bannerid}" />
<input type="hidden" id="old_openflag" name="old_openflag" value="${detail.openflag}" />
		<strong> 기본정보</strong>
		<table id="tblSearch" width="100%" border="0" cellspacing="0" cellpadding="0">
			<colgroup>
				<col width="10%" />
				<col width="*" />
			</colgroup>		
			<tr>
				<th>출력위치</th>
				<td><span class="required"></span>
					<c:forEach items="${ bannerPositionList}" var="data" varStatus="status">
						<label><input type="radio" id="position${status.count }" name="position" value="${data.value}"  class="AXInput required position" title="${data.name }" <c:if test="${ detail.position eq data.value or (empty detail.position and data.value eq 'A')}">checked</c:if>> ${data.name }</label>
					</c:forEach>
				</td>
			</tr>
			<tr>
				<th>상태</th>
				<td>
					<label class="required"><input type="radio" id="openflag1" name="openflag" value="N"  class="AXInput required openflag" title="상태" <c:if test="${ detail.openflag eq 'N' or empty detail.openflag}">checked</c:if>> 비공개</label>
					<label><input type="radio" id="openflag2" name="openflag" value="Y"  class="AXInput required openflag" title="상태" <c:if test="${ detail.openflag eq 'Y'}">checked</c:if>> 공개</label>
					 * 사용자 화면에 20개 이상 노출 시 디자인이 깨질 수 있습니다.
				</td>
			</tr>
			<tr>
				<th>순서</th>
				<td>
					<select class="required" id="bannerorder" name="bannerorder" style="width:auto; min-width:80px"  title="순서" >
						<option value="">선택</option>
						<c:forEach begin="1" end="100" var="data" varStatus="status">
							<option value="${data }" <c:if test="${detail.bannerorder eq data}" >selected</c:if>>${data }</option>
						</c:forEach>
					</select>
				</td>
			</tr>
			<tr>
				<th>배너명</th>
				<td><input type="text" id="bannername" name="bannername" style="width:90%;" value="${detail.bannername}" class="AXInput required" maxlength="50" title="배너명"></td>
			</tr>
		</table>
	
		<br/>
		
		<strong> 기간 및 대상자정보</strong>
		<div class="contents_title clear">
			<div class="fl">
				<input type="hidden" name="rowPerPage" value="1000" />
				<a href="javascript:;" id="deleteConditionButton" class="btn_green" style="margin-left:0px;">삭제</a>
				<span> Total : <span id="totalcount"></span>건</span>
			</div>
			
			<div class="fr">
				<div style="float:right;">
					<select id="searchconditiontype" name="searchconditiontype" style="width:auto; min-width:100px; display:none"> 
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
			<tr class="pcTr">
				<th>PC링크</th>
				<td colspan="2">
					<input type="text" id="pclink" name="pclink" style="width:90%;" value="${detail.pclink}" class="AXInput" maxlength="500" title="PC링크">
					<br />* http:// 형식의 완전한 링크로 입력해 주세요.
				</td>
			</tr>
			<tr class="pcTr">
				<th>PC링크 타겟</th>
				<td colspan="2">
					<c:forEach items="${ linkTargetList}" var="data" varStatus="status">
						<label><input type="radio" id="pctarget${status.count }" name="pctarget" value="${data.value}"  class="AXInput pctarget" title="${data.value }" <c:if test="${ detail.pctarget eq data.value or (empty detail.pctarget and data.value eq 'IN')}">checked</c:if>> ${data.name }</label>
					</c:forEach>
				</td>
			</tr>					
			<tr class="pcTr">
				<th rowspan="3">PC배너이미지</th>
				<td rowspan="2">
					<div id="pcimageView" style="width:140px;height:80px;float:left;">
					<c:if test="${not empty detail.pcimage}"><img src="/manager/lms/common/imageView.do?file=${detail.pcimage}&mode=course" width="120" style="max-height:80px;"></c:if>
					</div>
				</td>
				<td>
					<input type="hidden" id="pcimagefile" name="pcimagefile" value="${detail.pcimage}" title="PC배너이미지" />
					<input type="file" id="pcimage" name="pcimage" accept="image/*" onchange="getThumbnailPrivew(this,$('#pcimageView'), 120 , 80);" title="PC배너이미지"><br />
				</td>
			</tr>
			<tr class="pcTr">
				<td>
					이미지설명 <input type="text" id="pcimagenote" name="pcimagenote" style="width:60%;" value="${detail.pcimagenote}" class="AXInput" maxlength="50" title="이미지설명">				
				</td>
			</tr>
			<tr class="pcTr">
				<td colspan="2"> * 이미지파일은 960 * 318 pixel 사이즈(Fix)로 용량 300KB이하로 업로드해주세요.</td>
			</tr>
			
			<tr class="mobileTr">
				<th>MOBILE링크</th>
				<td colspan="2">
					<input type="text" id="mobilelink" name="mobilelink" style="width:90%;" value="${detail.mobilelink}" class="AXInput" maxlength="500" title="MOBILE링크">
					<br />* http:// 형식의 완전한 링크로 입력해 주세요.
				</td>
			</tr>
			<tr class="mobileTr">
				<th>MOBILE링크 타겟</th>
				<td colspan="2">
					<c:forEach items="${ linkTargetList}" var="data" varStatus="status">
						<label><input type="radio" id="mobiletarget${status.count }" name="mobiletarget" value="${data.value}"  class="AXInput mobiletarget" title="${data.value }" <c:if test="${ detail.mobiletarget eq data.value or (empty detail.mobiletarget and data.value eq 'IN')}">checked</c:if>> ${data.name }</label>
					</c:forEach>
				</td>
			</tr>					
			<tr class="mobileTr">
				<th rowspan="3">MOBILE배너이미지</th>
				<td rowspan="2">
					<div id="mobileimageView" style="width:140px;height:80px;float:left;">
					<c:if test="${not empty detail.mobileimage}"><img src="/manager/lms/common/imageView.do?file=${detail.mobileimage}&mode=course" width="120" style="max-height:80px;"></c:if>
					</div>
				</td>
				<td>
					<input type="hidden" id="mobileimagefile" name="mobileimagefile" value="${detail.mobileimage}" title="MOBILE배너이미지" />
					<input type="file" id="mobileimage" name="mobileimage" accept="image/*" onchange="getThumbnailPrivew(this,$('#mobileimageView'), 120 , 80);" title="MOBILE배너이미지"><br />
				</td>
			</tr>
			<tr class="mobileTr">
				<td>
					이미지설명 <input type="text" id="mobileimagenote" name="mobileimagenote" style="width:60%;" value="${detail.mobileimagenote}" class="AXInput" maxlength="50" title="이미지설명">				
				</td>
			</tr>
			<tr class="mobileTr">
				<td colspan="2"> * 이미지파일은 640 * 380 pixel 사이즈로 용량 300KB이하로 업로드해주세요.</td>
			</tr>
		</table>
</form>
	</div>
		
	<div align="center">
		<a href="javascript:;" id="insertBtn" class="btn_green">저장</a>&nbsp;&nbsp;
		<a href="javascript:;" id="cancelBtn" class="btn_green">취소</a>
	</div>
<script>
/** 이미지 미리보기
 * 
 */
function checkUploadFileType(html) {
	return;
	// 우선은 제약을 풀어놓는다.
	if(html.value == ""){
		return;
	}
	var _lastDot = html.value.lastIndexOf('.');
	var fileExt = html.value.substring(_lastDot+1, html.value.length).toLowerCase();
	var datatype = $("input:radio[name='datatype']:checked").val();
	if(datatype == "F"){
		if( fileExt != "hwp" && fileExt != "doc" && fileExt != "docx" && fileExt != "xls" && fileExt != "xlsx" && fileExt != "pdf" ) {
			alert("문서 파일(hwp,doc,docx,xls,xlsx,pdf)만 입력하세요.");
			html.value = "";
			return;
		}
	}
}
</script>
</body>
</html>