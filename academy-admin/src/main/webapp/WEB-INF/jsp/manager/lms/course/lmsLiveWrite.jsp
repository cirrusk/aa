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
 	sortColKey: "lms.online.list"
};
var listGrid = new AXGrid(); // instance 상단그리드
$(document.body).ready(function(){
	$("#insertBtn").on("click", function(){
		if(checkManagerAuth(managerMenuAuth)){return;}
		imageSubmit();
	});
	$("#cancelBtn").on("click", function(){
		closeTapAndGoTap(frmid, prefrmid);
	});
	
	$(".openflag").on("click", function(){
		openFlageChanged($(this).val());
	});
	$("#themeButton").on("click", function(){
		if(checkManagerAuth(managerMenuAuth)){return;}
		themeButtonClick();
	});
	$("#themeseq").on("change", function(){
		var selectedVal = $("#themeseq option:selected").text();
		if(selectedVal.indexOf("[") > 0){
			selectedVal = selectedVal.split(" [")[0];
		}else{
			selectedVal = "";
		}
		$("#themename").val(selectedVal);
	});

	openFlageChanged($("input:radio[name='openflag']:checked").val());
	
	if($("#courseid").val()!=""){
		themeButtonClick();
	}
	$("#preopenflag").val($("input:radio[name='openflag']:checked").val());
	$("#prethemeseq").val($("#themeseq option:selected").val());
	
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
	openFlageChanged($("input:radio[name='openflag']:checked").val());
};

var openFlageChanged = function(str){
	var preopenflag = $("#preopenflag").val();
	var prethemeseq = $("#prethemeseq").val();

	var themeButtonTitle = "기존테마에 추가하기";
	if($("#themeseqtype").val() == "2"){
		themeButtonTitle = "신규테마에 추가하기";
	}
	$("#themeButton").text(themeButtonTitle);
	if(str == "C"){
		$("#regualrNote").show();
		fnDateIconReset();
	}else{
		$("#regualrNote").hide();
		fnDateIconReset();
	}
};
var imageSubmit = function(){
	// 저장전 Validation
	if(!confirm("라이브과정 정보를 저장하시겠습니까?")){
		return;
	}
	$("#categoryid").val($("#searchcategoryid").val());
	if(!chkValidation({chkId:"#frm", chkObj:"hidden|input|select|textarea"}) ){
		return;
	}
	var openflag = $("input:radio[name='openflag']:checked").val();

	var startdateyymmdd = $("#startdateyymmdd").val(); 
	var startdatehh = $("#startdatehh").val();
	var startdatemm = $("#startdatemm").val();
	var enddateyymmdd = $("#enddateyymmdd").val(); 
	var enddatehh = $("#enddatehh").val();
	var enddatemm = $("#enddatemm").val();
	
	var startdate = startdateyymmdd + " " + startdatehh + ":" + startdatemm + ":00"; 
	var enddate = enddateyymmdd + " " + enddatehh + ":" + enddatemm + ":00";
	
	if(startdateyymmdd == ""){
		alert("교육시작일을 선택해 주세요.");
		return;
	}
	if(enddateyymmdd == ""){
		alert("교육종료일을 선택해 주세요.");
		return;
	}
	if(startdate > enddate){
		alert("교육시작일시가 교육종료일시보다 이후입니다. \n교육기간을 확인해 주세요.");
		return;
	}
	$("#startdate").val(startdate);
	$("#enddate").val(enddate);
	
	if($("#livereplaylink").val() != ""){
		startdateyymmdd = $("#replaystartyymmdd").val(); 
		startdatehh = $("#replaystarthh").val();
		startdatemm = $("#replaystartmm").val();
		enddateyymmdd = $("#replayendyymmdd").val(); 
		enddatehh = $("#replayendhh").val();
		enddatemm = $("#replayendmm").val();
		
		startdate = startdateyymmdd + " " + startdatehh + ":" + startdatemm + ":00"; 
		enddate = enddateyymmdd + " " + enddatehh + ":" + enddatemm + ":00";
		
		if(startdateyymmdd == ""){
			alert("재방송 교육시작일을 선택해 주세요.");
			return;
		}
		if(enddateyymmdd == ""){
			alert("재방송 교육종료일을 선택해 주세요.");
			return;
		}
		if(startdate > enddate){
			alert("재방송 교육시작일시가 재방송 교육종료일시보다 이후입니다. \n재방송 교육기간을 확인해 주세요.");
			return;
		}
		$("#replaystart").val(startdate);
		$("#replayend").val(enddate);
	}else{
		$("#replaystart").val("");
		$("#replayend").val("");
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
   		url : "<c:url value="/manager/lms/course/lmsLiveSaveAjax.do"/>"
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
var fnCheckLength = function( objName, chkLength ) {
	var objValue = $("#"+objName).val();
	if( objValue.length > chkLength ) {
		$("#"+objName).val(objValue.substring(0,chkLength)); 
	}
	$("#"+objName+"Span").html( $("#"+objName).val().length + "/" + chkLength + "자" );
};
var fnDateIconReset = function() {
	$(".datepDay").bindDate({separator:"-", selectType:"d"});
};
</script>
</head>

<body class="bgw">

	<!--title //-->
	<div class="contents_title clear">
		<h2 class="fl">라이브과정</h2>
	</div>
	
	<!--search table // -->
	<div class="tbl_write">
<form id="frm" name="frm" method="post">
<input type="hidden" id="courseid" name="courseid" value="${detail.courseid}" />
		<strong> 기본정보</strong>
		<table id="tblSearch" width="100%" border="0" cellspacing="0" cellpadding="0">
			<colgroup>
				<col width="10%" />
				<col width="*" />
			</colgroup>		
			<tr>
				<th>과정 유형</th>
				<td>라이브과정</td>
			</tr>
			
			<tr>
				<th>교육 분류</th>
				<td> 
					<input type="hidden" id="categoryid" name="categoryid" value="${detail.categoryid}"  class="required" title="교육 분류"/>
					<c:set var="courseTypeCode" value="L"/>
					<%@ include file="/WEB-INF/jsp/manager/lms/include/lmsSearchCategory.jsp" %>								
				</td>
			</tr>
			
			<tr>
				<th>과정명</th>
				<td><input type="text" id="coursename" name="coursename" style="width:90%;" value="${detail.coursename}" class="AXInput required" maxlength="50" title="과정명"></td>
			</tr>
			
			<tr>
				<th>라이브테마명</th>
				<td><span class="required"></span>
					<input type="hidden" id="themeseqtype" name="themeseqtype" value="1">
					<input type="hidden" id="prethemeseq" name="prethemeseq">
					<select id="themeseq" name="themeseq" style="width:auto; min-width:120px;display:none"  title="라이브테마명" >
						<option value="">라이브테마 선택</option>
						<c:forEach items="${themeList }" var="data" varStatus="status">
							<option value="${data.themeseq }" <c:if test="${detail.themeseq eq data.themeseq}" >selected</c:if>>${data.themename }</option>
						</c:forEach>
					</select>	
					<input type="text" id="themename" name="themename" style="width:200px;" value="${detail.themename}" class="AXInput required" maxlength="50" title="라이브테마명">
					<a href="javascript:;" id="themeButton" class="btn_green">기존테마에 추가하기</a>
				</td>
			</tr>
			<tr>
				<th>정원</th>
				<td>
					<input type="text" id="limitcount" name="limitcount" value="${detail2.limitcount }" style="width:80px;"  class="AXInput required isNum" maxlength="7" title="정원">
					( 정원이 없으면 9999999를 입력하세요. )
				</td>
			</tr>
			<tr>
				<th>상태</th>
				<td>
					<label class="required"><input type="radio" id="openflag1" name="openflag" value="N"  class="AXInput required openflag" title="상태" <c:if test="${ detail.openflag eq 'N' or empty detail.openflag}">checked</c:if>> 비공개</label>
					<label><input type="radio" id="openflag2" name="openflag" value="Y"  class="AXInput required openflag" title="상태" <c:if test="${ detail.openflag eq 'Y'}">checked</c:if>> 공개</label>
					<label><input type="radio" id="openflag3" name="openflag" value="C"  class="AXInput required openflag" title="상태" <c:if test="${ detail.openflag eq 'C'}">checked</c:if>> 정규과정 공개</label>
				</td>
			</tr>
			
			<tr>
				<th>교육기간</th>
				<td>본 방송 : &nbsp;&nbsp;
					<input type="hidden" id="startdate" name="startdate"> 
					<input type="hidden" id="enddate" name="enddate">
					<input type="text" id="startdateyymmdd" name="startdateyymmdd"  value="${detail.startdateyymmdd}" title="교육시작일" class="AXInput datepDay">
					<select id="startdatehh" name="startdatehh" style="width:auto; min-width:80px"  title="교육시작시" >
						<c:forEach items="${ hourList}" var="data" varStatus="status">
							<option value="${data.value }" <c:if test="${detail.startdatehh eq data.value}" >selected</c:if>>${data.name }</option>
						</c:forEach>
					</select>	
					<select id="startdatemm" name="startdatemm" style="width:auto; min-width:80px"  title="교육시작분" >
						<c:forEach items="${ minute2List}" var="data" varStatus="status">
							<option value="${data.value }" <c:if test="${detail.startdatemm eq data.value}" >selected</c:if>>${data.name }</option>
						</c:forEach>
					</select>	
					 ~  
					<input type="text" id="enddateyymmdd" name="enddateyymmdd"  value="${detail.enddateyymmdd}" title="교육종료일" class="AXInput datepDay">
					<select id="enddatehh" name="enddatehh" style="width:auto; min-width:80px"  title="교육종료시" >
						<c:forEach items="${ hourList}" var="data" varStatus="status">
							<option value="${data.value }" <c:if test="${detail.enddatehh eq data.value}" >selected</c:if>>${data.name }</option>
						</c:forEach>
					</select>
					<select id="enddatemm" name="enddatemm" style="width:auto; min-width:80px"  title="교육종료분" >
						<c:forEach items="${ minute2List}" var="data" varStatus="status">
							<option value="${data.value }" <c:if test="${detail.enddatemm eq data.value}" >selected</c:if>>${data.name }</option>
						</c:forEach>
					</select>	<br>
						재 방송 : &nbsp;&nbsp;
					<input type="hidden" id="replaystart" name="replaystart"> 
					<input type="hidden" id="replayend" name="replayend">
					<input type="text" id="replaystartyymmdd" name="replaystartyymmdd"  value="${detail2.replaystartyymmdd}" title="재방송시작일" class="AXInput datepDay">
					<select id="replaystarthh" name="replaystarthh" style="width:auto; min-width:80px"  title="재방송시작시" >
						<c:forEach items="${ hourList}" var="data" varStatus="status">
							<option value="${data.value }" <c:if test="${detail2.replaystarthh eq data.value}" >selected</c:if>>${data.name }</option>
						</c:forEach>
					</select>	
					<select id="replaystartmm" name="replaystartmm" style="width:auto; min-width:80px"  title="재방송시작분" >
						<c:forEach items="${ minute2List}" var="data" varStatus="status">
							<option value="${data.value }" <c:if test="${detail2.replaystartmm eq data.value}" >selected</c:if>>${data.name }</option>
						</c:forEach>
					</select>	
					 ~  
					<input type="text" id="replayendyymmdd" name="replayendyymmdd"  value="${detail2.replayendyymmdd}" title="재방송종료일" class="AXInput datepDay">
					<select id="replayendhh" name="replayendhh" style="width:auto; min-width:80px"  title="재방송종료시" >
						<c:forEach items="${ hourList}" var="data" varStatus="status">
							<option value="${data.value }" <c:if test="${detail2.replayendhh eq data.value}" >selected</c:if>>${data.name }</option>
						</c:forEach>
					</select>
					<select id="replayendmm" name="replayendmm" style="width:auto; min-width:80px"  title="재방송종료분" >
						<c:forEach items="${ minute2List}" var="data" varStatus="status">
							<option value="${data.value }" <c:if test="${detail2.replayendmm eq data.value}" >selected</c:if>>${data.name }</option>
						</c:forEach>
					</select>	
					<br />*[유의사항] 동일 시간대에 복수의 라이브 개설 시 송출 오류가 발생할 수 있습니다
				</td>
			</tr>	
			<tr>
				<th>라이브 링크</th>
				<td>본 방송 : &nbsp;&nbsp;
					<input type="text" id="livelink" name="livelink" style="width:50%;" value="${detail2.livelink}" title="본방송" class="AXInput required" maxlength="500">
					<br>
					재 방송 : &nbsp;&nbsp;
					<input type="text" id="livereplaylink" name="livereplaylink" style="width:50%;" value="${detail2.livereplaylink}" title="재방송" class="AXInput" maxlength="500">
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
		<div id="regualrNote">[유의사항] 정규과정의 대상자정보는 과정운영 > 정규과정 메뉴에서 적용이 가능합니다. 현재 메뉴에서 설정한 내용은 미적용 됩니다</div>
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
</form>
	</div>
		
	<div align="center">
		<a href="javascript:;" id="insertBtn" class="btn_green">저장</a>&nbsp;&nbsp;
		<a href="javascript:;" id="cancelBtn" class="btn_green">취소</a>
	</div>

</body>
</html>