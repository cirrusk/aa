<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ include file="/WEB-INF/jsp/manager/frame/include/topPop.jsp" %>
<%@ page import = "amway.com.academy.manager.lms.common.LmsCode" %>

<%-- <!-- js/이미지/공통  include -->
<%@ include file="/WEB-INF/jsp/manager/frame/include/include.jsp" %> --%>
	
<script type="text/javascript">	
var managerMenuAuth =$("#"+g_managerLayerMenuId.callId).get(0).contentWindow.managerMenuAuth;
var g_tab = "1";
var g_params = {showTab:g_tab};
var nowDate = "${nowDate.yyyy}-${nowDate.mm}-${nowDate.dd}";
var minDate = "${param.startdateyymmdd}";
if(minDate=="" || minDate=="--"){
	minDate = nowDate;
}else if(minDate > nowDate){
	minDate = nowDate;
}

var fnDateAutoInput = function( idxVal) {
	//$("#startdateyymmdd"+idxVal).val("2000-01-01");
	$("#startdateyymmdd"+idxVal).val("${nowDate.yyyy}-${nowDate.mm}-${nowDate.dd}");
	$("#startdatehh"+idxVal).val("00");
	$("#startdatemm"+idxVal).val("00");
	
	$("#enddateyymmdd"+idxVal).val("2050-12-31");
	$("#enddatehh"+idxVal).val("23");
	$("#enddatemm"+idxVal).val("50");
};
function saveSubmit(){
	var param = $("#frm").serialize();
	$.ajaxCall({
   		url : "<c:url value="/manager/lms/banner/lmsBannerConditionExcelSaveAjax.do"/>"
   		, timeout : 60 * 1000
   		, data : param
   		, type: 'POST'
        , contentType: 'application/x-www-form-urlencoded; charset=UTF-8'
   		, success: function( data, textStatus, jqXHR){
			if( data.result == "E" ) {
				alert("<spring:message code="errors.load"/>");
				return;
			} else if( data.result == "F" ) {
				if( data.logresult == "fail" ) {
					alert("로그를 저장하는 중 오류가 발생하였습니다.");
				} else {
					alert("데이터를 처리하는 중 오류가 발견되었습니다.\n로그를 확인하세요.");
					
					//로그결과 화면에 뿌려주기
					$("#resultArea").show();
					
					$("#successcount").html( data.successcount );
					$("#failcount").html( data.failcount );
					$("#logid").val( data.logid );
					$("#logcontent").val( data.logcontent );
				}
			} else {
				$("#targetcode").val(data.logid);
				$("#targetmember").val(data.uids);
				alert("대상자를 저장하였습니다.");
				
				//로그결과 화면에 뿌려주기
				$("#resultArea").show();
				
				$("#successcount").html( data.successcount );
				$("#failcount").html( data.failcount );
				$("#logid").val( data.logid );
				$("#logcontent").val( data.logcontent );
				$("#selectLogMemberButton").show();
			}
   		},
   		error: function( jqXHR, textStatus, errorThrown) {
           	alert("<spring:message code="errors.load"/>");
           	return;
   		}
   	});
}
var layer = {
	init : function(){
		// 상단 탭
		$("#divLmsCourseConditionTab").bindTab({
			  theme : "AXTabs"
			, overflow :"visible"
			, value: g_tab
			, options:[
				{optionValue:"1", optionText:"일반조건", tabId:"1"} 
				, {optionValue:"2", optionText:"대상자조건", tabId:"2"}
			]
			, onchange : function(selectedObject, value){
				layer.setViewTab(value, selectedObject);
			}
		});
	}, setViewTab : function(value, selectedObject){
		g_params.showTab = value;
		if(g_params.showTab=="1") {
			g_tab = "1";
			$("#divTabPage1").show();
			$("#divTabPage2").hide();
			fnDateIconReset();
		} else if(g_params.showTab=="2") {
			g_tab = "2";
			$("#divTabPage1").hide();
			$("#divTabPage2").show();
			fnDateIconReset();
		}
	} // end func setViewTab
}
var fnMultiSelectAdd = function(oriObj,targetObj) {
	$("#"+oriObj+" option:selected").each( function () {
		var tempVal = $(this).val();
		var tempText = $(this).text();
		
		//오른쪽에 있는 값과 비교하여 넣을지 판단할 것
		var tempChk = false;
		for( var i=0; i<$("#"+targetObj+" option").size(); i++ ) {
			var tempVal2 = $("#"+targetObj+" option:eq("+i+")").val();
			if( tempVal == tempVal2 ) {
				tempChk = true;
			}
		}
		if( tempVal !="" && !tempChk ) { //같은것이 없으면 추가함
			$("#"+targetObj).append("<option value='"+ tempVal +"'>"+ tempText +"</option>");
		}
		$(this).remove();
	});
	if($("#loacode option").length==0){
		$("#checkbox_loacode").prop("checked", false);
	}else{
		$("#checkbox_loacode").prop("checked", true);
	}
	if($("#diacode option").length==0){
		$("#checkbox_diacode").prop("checked", false);
	}else{
		$("#checkbox_diacode").prop("checked", true);
	}
};
var fnInitDiaSelect = function(initObj) {
	var initObjArr = initObj.split("|");
	var initObjValArr = initObjArr[0].split(",");
	var initObjTextArr = initObjArr[1].split(",");
	for( var i=0; i<initObjValArr.length; i++) {
		$("#diacode").append("<option value='"+ initObjValArr[i] +"'>"+ initObjTextArr[i] +"</option>");
	}
}
var fnInitLoaSelect = function(initObj) {
	var initObjArr = initObj.split("|");
	try{
		var initObjValArr = initObjArr[0].split(",");
		var initObjTextArr = initObjArr[1].split(",");
		for( var i=0; i<initObjValArr.length; i++) {
			$("#loacode").append("<option value='"+ initObjValArr[i] +"'>"+ initObjTextArr[i] +"</option>");
		}
	}catch(e){
		var initObjValArr = initObjArr[0].split(",");
		for( var i=0; i<initObjValArr.length; i++) {
			$("#loacodebefore option").each(function(index){
				if($(this).val() == initObjValArr[i]){
					$("#loacode").append("<option value='"+ initObjValArr[i] +"'>"+ $(this).text() +"</option>");
				}
			});
		}		
	}
}


$(document).ready(function(){

	if( $("#searchconditiontype").val() == "1" ) {
		$("#smalltitle").text("노출권한");	
	} else if( $("#searchconditiontype").val() == "2" ) {
		$("#smalltitle").text("이용권한");
	} else if( $("#searchconditiontype").val() == "3" ) {
		$("#smalltitle").text("추천권한");
	}
	
	//대상자 조건이 있으면 탭2로 처리할 것
	if( $("#targetcode").val() != "" ){
		var logmember = $("#targetmember").val();
		var targetexcelname = logmember.substring(0, logmember.indexOf("|"));
		$("#targetexcelname").val(targetexcelname);
		
		logmember = logmember.substring( logmember.indexOf("|")+1, logmember.length);
		var targetmembers = logmember.split(",");
		
		g_tab = "2";
		
		$("#resultArea").show();
		
		$("#successcount").html( targetmembers.length );
		$("#failcount").html( "" );
		$("#logid").val( $("#targetcode").val() );
		$("#logcontent").val( targetmembers.length + "건의 데이터를 저장하였습니다." );
		$("#selectLogMemberButton").show();
	}
	
	//tab start
	layer.init();
	
	if(g_tab=="1") {
		$("#divTabPage1").show();
		$("#divTabPage2").hide();
		
		//입력의 경우 검색 구분에 따라서 추천이 아닌 경우에는 다운라인, 연속주문횟수, 비즈니스상태 감추기
		if( $("#searchconditiontype").val() != "3" ) {
			$("#tr_customercode").hide();
			$("#tr_consecutivecode").hide();
			$("#tr_businessstatuscode").hide();
		}
	} else if(g_tab=="2") {
		$("#divTabPage1").hide();
		$("#divTabPage2").show();
	}
	
	//loa 있을 경우 select 제어하기
	if( $("#load_loacode").val() != "" ) {
		fnInitLoaSelect($("#load_loacode").val());
	}
	
	//dia 있을 경우 select 제어하기
	if( $("#load_diacode").val() != "" ) {
		fnInitDiaSelect($("#load_diacode").val());
	}
	
	$("#checkbox_forever1").on("click", function() {
		if( $(this).is(":checked") ) {
			fnDateAutoInput("1");	
		}
	});
	$("#checkbox_forever2").on("click", function() {
		if( $(this).is(":checked") ) {
			fnDateAutoInput("2");
		}
	});
	
	$("#loacode2").on("change", function() {
		if( $("#loacode2").val() == "" ) {
			//alert("LOA를 선택하세요.");
			return;
		}
		
		var param = {
			loacode : $("#loacode2").val()
		};
		$.ajaxCall({
	   		url: "<c:url value="/manager/lms/banner/lmsBannerConditionDiaAjax.do"/>"
	   		, data: param
	   		, success: function( data, textStatus, jqXHR){
	   			if(data.result < 1){
   	           		alert("<spring:message code="errors.load"/>");
   	           		return;
   	   			} else {
					//dia 리스트 새로 만들어서 뿌릴 것
					//DAICODE, DIACODENAME
					$("#diacodebefore").html("");
					
					for(var i=0;i<data.dataList.length; i++) {
						$("#diacodebefore").append("<option value='"+ data.dataList[i].diacode +"'>"+ data.dataList[i].diacodename +"</option>");	
					}
   	   			}
	   		},
	   		error: function( jqXHR, textStatus, errorThrown) {
	           	alert("<spring:message code="errors.load"/>");
	   		}
	   	});
	});
	
	$("#plusSelectLoa").on("click", function() {
		//선택된 값을 모두 넣어주고 삭제하지 않음
		fnMultiSelectAdd("loacodebefore","loacode");
	});	
	
	$("#minusSelectLoa").on("click", function() {
		//삭제만 함
		fnMultiSelectAdd("loacode","loacodebefore");
	});	
	
	$("#plusSelect").on("click", function() {
		//선택된 값을 모두 넣어주고 삭제할 것
		fnMultiSelectAdd("diacodebefore","diacode");
	});	
	
	$("#minusSelect").on("click", function() {
		//선택된 값을 모두 넣어주고 삭제할 것
		fnMultiSelectAdd("diacode","diacodebefore");
	});	
	
	$("#insertBtn").on("click", function(){
		if(checkManagerAuth(managerMenuAuth)){return;}
		//입력한 조건 체크하기
		var conditionname = "";
		var abotypecode = "";
		var abotypeabove = "";
		var pincode = "";
		var pinabove = "";
		var pinunder = "";
		var bonuscode = "";
		var bonusabove = "";
		var bonusunder = "";
		var agecode = "";
		var ageabove = "";
		var ageunder = "";
		var loacode = "";
		var diacode = "";
		var customercode = "";
		var consecutivecode = "";
		var businessstatuscode = "";
		var targetcode = "";
		var targetmember = "";
		
		if( g_tab == "1" ) {
			if( $("#checkbox_abotypecode").is(":checked") ) {
				if( $("#abotypecode").val() == "" ) {
					alert("회원타입을 선택하세요.");
					return
				} else {
					//conditionname += "회원타입,";
					conditionname += $("#abotypecode option:selected").text()+",";
					var temp_abotypecode = $("#abotypecode").val().split(",");
					abotypecode = temp_abotypecode[0];
					abotypeabove = temp_abotypecode[1];
					if( abotypeabove == "" ) {
						abotypeabove = "2";
					}
				}
			}
			
			if( $("#checkbox_pincode").is(":checked") ) {
				if( $("#pincode").val() == "" ) {
					alert("핀레벨을 선택하세요.");
					return
				} else {
					//conditionname += "핀레벨,";
					conditionname += $("#pincode option:selected").text()+",";
					var temp_pincode = $("#pincode").val().split(",");
					pincode = temp_pincode[0];
					pinabove = temp_pincode[1];
					pinunder = temp_pincode[2];
					if( pincode == "" ) {
						pinabove = "1";
						pinunder = "2";
					}
				}
			}
			if( $("#checkbox_bonuscode").is(":checked") ) {
				if( $("#bonuscode").val() == "" ) {
					alert("보너스레벨을 선택하세요.");
					return
				} else {
					//conditionname += "보너스레벨,";
					conditionname += $("#bonuscode option:selected").text()+",";
					var temp_bonuscode = $("#bonuscode").val().split(",");
					bonuscode = temp_bonuscode[0];
					bonusabove = temp_bonuscode[1];
					bonusunder = temp_bonuscode[2];
					if( bonuscode == "" ) {
						bonusabove = "1";
						bonusunder = "2";
					}
					
				}
			}
			if( $("#checkbox_agecode").is(":checked") ) {
				if( $("#agecode").val() == "" ) {
					alert("나이를 선택하세요.");
					return
				} else {
					//conditionname += "나이,";
					conditionname += $("#agecode option:selected").text()+",";
					var temp_agecode = $("#agecode").val().split(",");
					agecode = temp_agecode[0];
					ageabove = temp_agecode[1];
					ageunder = temp_agecode[2];
					if( agecode == "" ) {
						ageabove = "1";
						ageunder = "2";
					}
					
				}
			}
			if( $("#checkbox_loacode").is(":checked") ) {
				if( $("#loacode").val() == "" ) {
					alert("LOA를 선택하세요.");
					return
				} else {
					conditionname += "LOA,";
					//loacode = $("#loacode").val();
					
					//LOA 코드 읽기
					var temp_loacode = "";
					var temp_loacode_text = "";
					$("#loacode").find("option").each(function(){
						temp_loacode += this.value + ",";
						temp_loacode_text += this.text + ",";
					});
					if( temp_loacode != "" ) {
						temp_loacode = temp_loacode.substring(0,temp_loacode.length-1);
						temp_loacode_text = temp_loacode_text.substring(0,temp_loacode_text.length-1);
						//loacode = temp_loacode + "|" + temp_loacode_text;
						loacode = temp_loacode;
					}
				}
			}
			
			if( $("#checkbox_diacode").is(":checked") ) {
				if( $("#diacode option").length == 0 ) {
					alert("Diamond Group을 선택하세요.");
					return
				} else {
					conditionname += "Diamond Group,";
				
					//Diamond Group 코드 읽기
					var temp_diacode = "";
					var temp_diacode_text = "";
					$("#diacode").find("option").each(function(){
						temp_diacode += this.value + ",";
						temp_diacode_text += this.text + ",";
					});
					if( temp_diacode != "" ) {
						temp_diacode = temp_diacode.substring(0,temp_diacode.length-1);
						temp_diacode_text = temp_diacode_text.substring(0,temp_diacode_text.length-1);
						diacode = temp_diacode + "|" + temp_diacode_text;
					}
				}
			}
			
			//추천인 경우 추가 조건 확인
			if( $("#searchconditiontype").val() == "3" ) {
				if( $("#checkbox_customercode").is(":checked") ) {
					if( $("#customercode").val() == "" ) {
						alert("다운라인구매를 선택하세요.");
						return
					} else {
						conditionname += "다운라인구매,";
						customercode = $("#customercode").val();
					}
				}	
				if( $("#checkbox_consecutivecode").is(":checked") ) {
					if( $("#consecutivecode").val() == "" ) {
						alert("연속주문횟수를 선택하세요.");
						return
					} else {
						conditionname += "연속주문횟수,";
						consecutivecode = $("#consecutivecode").val();
					}
				}	
				if( $("#checkbox_businessstatuscode").is(":checked") ) {
					if( $("#businessstatuscode").val() == "" ) {
						alert("비즈니스상태를 선택하세요.");
						return
					} else {
						conditionname += "비즈니스상태,";
						businessstatuscode = $("#businessstatuscode").val();
					}
				}	
			}
		
			var startdateyymmdd = $("#startdateyymmdd1").val(); 
			var startdatehh = $("#startdatehh1").val();
			var startdatemm = $("#startdatemm1").val();
			var enddateyymmdd = $("#enddateyymmdd1").val(); 
			var enddatehh = $("#enddatehh1").val();
			var enddatemm = $("#enddatemm1").val();
			
			var startdate = startdateyymmdd + " " + startdatehh + ":" + startdatemm; 
			var enddate = enddateyymmdd + " " + enddatehh + ":" + enddatemm;

			if(startdateyymmdd == ""){
				alert("사용시작일을 선택해 주세요.");
				return;
			}
			if(minDate > startdateyymmdd){
				alert("사용시작일은 "+minDate+" 보다 이전으로 셋팅할 수 없습니다.");
				return;
			}
			if(enddateyymmdd == ""){
				alert("사용종료일을 선택해 주세요.");
				return;
			}
			if(startdate > enddate){
				alert("사용시작일시가 사용종료일시보다 이후입니다. \n사용기간을 확인해 주세요.");
				return;
			}
			
			$("#startdate").val(startdate);
			$("#enddate").val(enddate);
		} else {
			if( $("#checkbox_targetcode").is(":checked") ) {
				if( $("#targetcode").val() == "" ) {
					alert("대상자를 엑셀로 등록하세요.");
					return
				}else if($("#targetexcelname").val() == ""){
					alert("리스트 정보를 입력해 주세요.");
					return					
				} else {
					conditionname = "대상자 입력,";
					targetcode = $("#targetcode").val();
					
					var logmember = $("#targetmember").val();
					logmember = logmember.substring( logmember.indexOf("|")+1, logmember.length);
					//엑셀대상자와 엑셀 제목을 |로 구부해서 값을 더해준다.
					targetmember = $("#targetexcelname").val() + "|" +logmember; 
				}
			}
			var startdateyymmdd = $("#startdateyymmdd2").val(); 
			var startdatehh = $("#startdatehh2").val();
			var startdatemm = $("#startdatemm2").val();
			var enddateyymmdd = $("#enddateyymmdd2").val(); 
			var enddatehh = $("#enddatehh2").val();
			var enddatemm = $("#enddatemm2").val();
			
			var startdate = startdateyymmdd + " " + startdatehh + ":" + startdatemm; 
			var enddate = enddateyymmdd + " " + enddatehh + ":" + enddatemm;

			if(startdateyymmdd == ""){
				alert("사용시작일을 선택해 주세요.");
				return;
			}
			if(enddateyymmdd == ""){
				alert("사용종료일을 선택해 주세요.");
				return;
			}
			if(startdate > enddate){
				alert("사용시작일시가 사용종료일시보다 이후입니다. \n사용기간을 확인해 주세요.");
				return;
			}
			
			$("#startdate").val(startdate);
			$("#enddate").val(enddate);
		}
		
		if( conditionname != "" ) {
			conditionname = conditionname.substring(0, conditionname.length-1);
		} else {
			alert("사용하실 조건을 선택하세요.");
			return;
		}
		
		var conditiontypename = "";
		if( $("#searchconditiontype").val() == "1" ) {
			conditiontypename = "노출권한";
		} else if( $("#searchconditiontype").val() == "2" ) {
			conditiontypename = "이용권한";
		} else {
			conditiontypename = "추천권한";
		}	
		
		if( !confirm("검색 조건을 적용하시겠습니까?")) {
			return;
		}
		
		//결과값을 배열로 저장하여 opener에 담기
		var inputVal = {
			conditionseq : $("#conditionseq").val()
			, no : $("#conditionseq").val()
			, conditiontypename : conditiontypename
			, conditionname : conditionname
			, edudate : $("#startdate").val() + ' ~ ' + $("#enddate").val()
			, conditiontype : $("#searchconditiontype").val()
			, abotypecode : abotypecode 
			, abotypeabove : abotypeabove
			, pincode : pincode
			, pinabove : pinabove
			, pinunder : pinunder
			, bonuscode : bonuscode
			, bonusabove : bonusabove
			, bonusunder : bonusunder
			, agecode : agecode
			, ageabove : ageabove
			, ageunder : ageunder
			, loacode : loacode
			, diacode : diacode
			, customercode : customercode
			, consecutivecode : consecutivecode
			, businessstatuscode : businessstatuscode
			, targetcode : targetcode
			, targetmember : targetmember
			, startdate : $("#startdate").val()
			, enddate : $("#enddate").val()
		};
		if( $("#inputtype").val() == "I" ) {
			$("#"+g_managerLayerMenuId.callId).get(0).contentWindow.fn_addGrid( inputVal );	
		} else {
			$("#"+g_managerLayerMenuId.callId).get(0).contentWindow.fn_updateGrid( inputVal );
		}
		
		closeManageLayerPopup("searchPopup");

	});
	
	$("#aExcdlDown").on("click", function(){
		var result = confirm("엑셀 내려받기를 시작 하겠습니까?\n 네트워크 상황에 따라서 1~3분 정도 시간이 걸릴 수 있습니다."); 
		if(result) {
			showLoading();
			var defaultParam = {
				exceltype : "condition"
			};
			postGoto("<c:url value="/manager/lms/banner/lmsBannerConditionSampleExcelDownload.do"/>", defaultParam);
			hideLoading();
		}
	});	
	
	$("#aExcdlSave").on("click", function(){
		try{if(checkManagerAuth(managerMenuAuth)){return;}}catch(e){}
		var fileYn = false;
		var fileExt = "";
		$( "input:file" ).each(function( index ){
			if($( this ).val().length>0 ){
				fileYn = true;
				var _lastDot = $( this ).val().lastIndexOf('.');
				fileExt = $( this ).val().substring(_lastDot+1, $( this ).val().length).toLowerCase();
			}
		});
		
		if(!fileYn){
			alert("등록할 엑셀파일을 선택하세요.");
			return;
		}
		if( fileExt != "xlsx" && fileExt != "xls" ) {
			alert("엑셀파일만 입력하세요.");
			return;
		}
		
		if( !confirm("대상자를 엑셀파일로 등록하겠습니까?") ) {
			return;
		}
		
		$("#frm").ajaxForm({
			dataType:"json",
			data:{mode:"excel"},
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
	});
	
	$("#selectLogButton").on("click", function(){
		$("#logcontent_area").show();
		fnDateIconReset();
	});
	$("#selectLogMemberButton").on("click", function(){
		var logmember = $("#targetmember").val();
		logmember = logmember.substring( logmember.indexOf("|")+1, logmember.length);
		$("#logmember").val( logmember.replace(/,/g,"\n") );
		$("#logmember_area").show();
		fnDateIconReset();
	});
	
	
	
	/* 값이 모두 없는 경우 회원타입 > 비회원 기본 설정 해준다. */
	if(!$(".codecheckbox").is(":checked")){
		$("#checkbox_abotypecode").prop("checked", true);
		//var maxoptionindex = $("#abotypecode option").length - 1;
		var maxoptionindex = 1;
		$("#abotypecode option:eq("+maxoptionindex+")").prop("selected", true);
	}
	
	$(".codeselect").on("change",function(){
		var val = "";
		var checkBox = $(this).parent().parent().children("td").find("input:checkbox");

		if($(this).attr("id") != "loacode"){
			val = $(this).val();
		}else{
			val = $(this).val();
			if($("#diacode option").length != 0 || val != ""){
				val = "a"; // 더미값 셋팅
			}
		}
		$(checkBox).prop("checked",val);

	});
});

var fnDateIconReset = function() {
	$(".datepDay").bindDate({separator:"-", selectType:"d"});
};

var delVar = function(obj, val){
	$(obj).val($(obj).val().replace(/\|/g,''));
};
</script>
</head>
<body>
	<div id="popwrap">
		<!--pop_title //-->
		<div class="title clear">
			<h2 class="fl">검색 조건 등록</h2>
			<span class="fr"><a href="javascript:;" class="btn_close close-layer">X</a></span>
		</div>
		<!--// pop_title -->
		
		<!-- Contents -->
		<div id="popcontainer"  style="height:800px">
			<div id="popcontent">
				<!-- Sub Title -->
				<div class="poptitle clear">
					<h3 id="smalltitle"></h3>
				</div>
				
				<div id="divLmsCourseConditionTab"></div>
				
				<!--// Sub Title -->
				<div id="tabLayer">
					<div id="divTabPage1" class="tabView tbl_write2">
						<table width="100%" border="0" cellspacing="0" cellpadding="0">
							<colgroup>
								<col width="5%" />
								<col width="15%"  />
								<col width="80%"  />
							</colgroup>
							<tr>								
								<th>사용</th>
								<th>검색조건 </th>
								<th>검색 값 선택 </th>
							</tr>
							<tr id="tr_abotypecode">
								<td style="text-align:center;">
									<input type="hidden" id="inputtype" name="inputtype" value="${param.inputtype}"/>
									<input type="hidden" id="searchconditiontype" name="searchconditiontype" value="${param.searchconditiontype}"/>
									<input type="hidden" id="conditionseq" name="conditionseq" value="${param.conditionseq}"/>
									<input type="hidden" id="load_loacode" name="load_loacode" value="${param.loacode}"/>
									<input type="hidden" id="load_diacode" name="load_diacode" value="${param.diacode}"/>
								
									<input type="checkbox" id="checkbox_abotypecode" name="checkboxTarget" value="ABOTYPECODE" <c:if test="${ not empty param.abotypecode }">checked</c:if> class="codecheckbox"/>
								</td>
								<td style="text-align:center;">
									<span>회원타입</span>
								</td>
								<td style="text-align:left;">
									<select id="abotypecode" name="abotypecode" style="width:auto; min-width:100px" class="codeselect"> 
										<option value="">선택</option>
										<c:forEach items="${ abotypeList}" var="data" varStatus="status">
											<option value="${data.targetcodeseq},${data.targetcodeorder}" <c:if test="${ param.abotypecode eq data.targetcodeseq}">selected</c:if>>${data.targetcodename }</option>
										</c:forEach>
									</select>
									* 선택하신 해당 타입 이상으로 적용됩니다.
								</td>
							</tr>
							<tr id="tr_pincode">
								<td style="text-align:center;">
									<input type="checkbox" id="checkbox_pincode" name="checkboxTarget" value="PINCODE" <c:if test="${ not empty param.pincode }">checked</c:if> class="codecheckbox"/>
								</td>
								<td style="text-align:center;">
									<span>핀레벨</span>
								</td>
								<td style="text-align:left;">
									<select id="pincode" name="pincode" style="width:auto; min-width:100px" class="codeselect">
										<option value="">선택</option> 
										<c:forEach items="${ pincodeList}" var="data" varStatus="status">
											<option value="${data.targetcodeseq},${data.targetcodeorderabove},${data.targetcodeorderunder}" <c:if test="${param.pincode eq data.targetcodeseq}">selected</c:if>>${data.targetcodename }</option>
										</c:forEach>
									</select>
								</td>
							</tr>
							<tr id="tr_bonuscode">
								<td style="text-align:center;">
									<input type="checkbox" id="checkbox_bonuscode" name="checkboxTarget" value="BONUSCODE" <c:if test="${ not empty param.bonuscode }">checked</c:if> class="codecheckbox"/>
								</td>
								<td style="text-align:center;">
									<span>보너스레벨</span>
								</td>
								<td style="text-align:left;">
									<select id="bonuscode" name="bonuscode" style="width:auto; min-width:100px" class="codeselect"> 
										<option value="">선택</option>
										<c:forEach items="${ bonuscodeList}" var="data" varStatus="status">
											<option value="${data.targetcodeseq},${data.targetcodeorderabove},${data.targetcodeorderunder}" <c:if test="${param.bonuscode eq data.targetcodeseq}">selected</c:if>>${data.targetcodename }</option>
										</c:forEach>
									</select>
									* 보너스 레벨 조건 적용 시 핀 레벨 항목을 핀 없음으로 체크하세요.
								</td>
							</tr>
							<tr id="tr_agecode">
								<td style="text-align:center;">
									<input type="checkbox" id="checkbox_agecode" name="checkboxTarget" value="AGECODE" <c:if test="${ not empty param.agecode }">checked</c:if> class="codecheckbox"/>
								</td>
								<td style="text-align:center;">
									<span>나이</span>
								</td>
								<td style="text-align:left;">
									<select id="agecode" name="agecode" style="width:auto; min-width:100px" class="codeselect"> 
										<option value="">선택</option>
										<c:forEach items="${agecodeList}" var="data" varStatus="status">
											<option value="${data.targetcodeseq},${data.targetcodeorderabove},${data.targetcodeorderunder}" <c:if test="${param.agecode eq data.targetcodeseq}">selected</c:if>>${data.targetcodename }</option>
										</c:forEach>
									</select>
								</td>
							</tr>
							
							<tr id="tr_loacode">
								<td style="text-align:center;">
									<input type="checkbox" id="checkbox_loacode" name="checkboxTarget" value="LOACODE" <c:if test="${ not empty param.loacode}">checked</c:if> class="codecheckbox"/>
								</td>
								<td style="text-align:center;">
									<span>LOA</span>
								</td>
								<td style="text-align:left;">
									<span style="margin-left:10px;font-weight:bold;">선택</span>
									<span style="margin-left:220px;font-weight:bold;">선택된 LOA</span>
									<br/>
									<div style="float:left;">
										<select id="loacodebefore" name="loacodebefore" multiple='multiple' style="width:200px; min-width:100px; min-height:60px;float:left;" class="codeselect">
											<c:forEach items="${ loacodeList}" var="data" varStatus="status">
												<option value="${data.targetcodeseq}">${data.targetcodename }</option>
											</c:forEach>
			                			</select>
										<div style="float:left;">
											<a href="javascript:;" id="plusSelectLoa" class="btn_green">>></a><br/>
	                						<a href="javascript:;" id="minusSelectLoa" class="btn_green"><<</a>
										</div>
										<select id="loacode" name="loacode" multiple='multiple' style="width:200px; min-width:100px; min-height:60px;float:left;margin-left:5px;">
			                			</select>
									</div>										
								</td>
							</tr>
							
							<tr id="tr_diacode">
								<td style="text-align:center;">
									<input type="checkbox" id="checkbox_diacode" name="checkboxTarget" value="DIACODE" <c:if test="${ not empty param.diacode }">checked</c:if> class="codecheckbox"/>
								</td>
								<td style="text-align:center;">
									<span>Diamond Group</span>
								</td>
								<td style="text-align:left;">
									<select id="loacode2" name="loacode2" style="width:auto; min-width:100px;width:200px;">
										<option value="">선택</option> 
										<c:forEach items="${ loacodeList}" var="data" varStatus="status">
											<option value="${data.targetcodeseq}">${data.targetcodename }</option>
										</c:forEach>
									</select>
									<span style="margin-left:55px;font-weight:bold;">선택된 Diamond Group</span>
									<br/>
									<div style="float:left;">
										<select id="diacodebefore" name="diacodebefore" multiple='multiple' style="width:200px; min-width:100px; min-height:60px;float:left;" class="codeselect">
			                   				 <option value="">선택</option>
			                			</select>
										<div style="float:left;">
											<a href="javascript:;" id="plusSelect" class="btn_green">>></a><br/>
	                						<a href="javascript:;" id="minusSelect" class="btn_green"><<</a>
										</div>
										<select id="diacode" name="diacode" multiple='multiple' style="width:200px; min-width:100px; min-height:60px;float:left;margin-left:5px;" class="codeselect">
			                			</select>
									</div>										
								</td>
							</tr>
							<tr id="tr_customercode">
								<td style="text-align:center;">
									<input type="checkbox" id="checkbox_customercode" name="checkboxTarget" value="CUSTOMERCODE" <c:if test="${ not empty param.customercode }">checked</c:if> class="codecheckbox"/>
								</td>
								<td style="text-align:center;">
									<span>다운라인구매</span>
								</td>
								<td style="text-align:left;">
									<select id="customercode" name="customercode" style="width:auto; min-width:100px" class="codeselect"> 
										<option value="">선택</option>
										<c:forEach items="${ customercodeList}" var="data" varStatus="status">
											<option value="${data.targetcodeseq}" <c:if test="${param.customercode eq data.targetcodeseq}">selected</c:if>>${data.targetcodename }</option>
										</c:forEach>
									</select>
								</td>
							</tr>
							<tr id="tr_consecutivecode">
								<td style="text-align:center;">
									<input type="checkbox" id="checkbox_consecutivecode" name="checkboxTarget" value="CONSECUTIVECODE" <c:if test="${ not empty param.consecutivecode }">checked</c:if> class="codecheckbox"/>
								</td>
								<td style="text-align:center;">
									<span>연속주문횟수</span>
								</td>
								<td style="text-align:left;">
									<select id="consecutivecode" name="consecutivecode" style="width:auto; min-width:100px" class="codeselect"> 
										<option value="">선택</option>
										<c:forEach items="${ consecutivecodeList}" var="data" varStatus="status">
											<option value="${data.targetcodeseq}" <c:if test="${param.consecutivecode eq data.targetcodeseq}">selected</c:if>>${data.targetcodename }</option>
										</c:forEach>
									</select>
								</td>
							</tr>
							<tr id="tr_businessstatuscode">
								<td style="text-align:center;">
									<input type="checkbox" id="checkbox_businessstatuscode" name="checkboxTarget" value="BUSINESSSTATUSCODE" <c:if test="${ not empty param.businessstatuscode }">checked</c:if> class="codecheckbox"/>
								</td>
								<td style="text-align:center;">
									<span>비즈니스상태</span>
								</td>
								<td style="text-align:left;">
									<select id="businessstatuscode" name="businessstatuscode" style="width:auto; min-width:100px" class="codeselect"> 
										<option value="">선택</option>
										<c:forEach items="${ businessstatuscodeList}" var="data" varStatus="status">
											<option value="${data.targetcodeseq}" <c:if test="${param.businessstatuscode eq data.targetcodeseq}">selected</c:if>>${data.targetcodename }</option>
										</c:forEach>
									</select>
								</td>
							</tr>
							<tr>
								<td></td>
								<td style="text-align:center;">
									<span>사용기간</span>
								</td>
								<td style="text-align:left;">
								<div style="position:relative">
									<input type="hidden" id="startdate" name="startdate"> 
									<input type="hidden" id="enddate" name="enddate">
									
									<input type="text" id="startdateyymmdd1" name="startdateyymmdd1"  value="${param.startdateyymmdd}" title="사용시작일" class="AXInput datepDay" style="width:100px; min-width:100px">
									<select id="startdatehh1" name="startdatehh1" style="width:auto; min-width:70px"  title="사용시작시" >
										<c:forEach items="${ hourList}" var="data" varStatus="status">
											<option value="${data.value }" <c:if test="${param.startdatehh eq data.value}" >selected</c:if>>${data.name }</option>
										</c:forEach>
									</select>	
									<select id="startdatemm1" name="startdatemm1" style="width:auto; min-width:70px"  title="사용시작분" >
										<c:forEach items="${ minute2List}" var="data" varStatus="status">
											<option value="${data.value }" <c:if test="${param.startdatemm eq data.value}" >selected</c:if>>${data.name }</option>
										</c:forEach>
									</select>	
									 ~  
									<input type="text" id="enddateyymmdd1" name="enddateyymmdd1"  value="${param.enddateyymmdd}" title="사용종료일" class="AXInput datepDay"  style="width:100px; min-width:100px">
									<select id="enddatehh1" name="enddatehh1" style="width:auto; min-width:70px"  title="사용종료시" >
										<c:forEach items="${ hourList}" var="data" varStatus="status">
											<option value="${data.value }" <c:if test="${param.enddatehh eq data.value}" >selected</c:if>>${data.name }</option>
										</c:forEach>
									</select>
									<select id="enddatemm1" name="enddatemm1" style="width:auto; min-width:70px"  title="사용종료분" >
										<c:forEach items="${ minute2List}" var="data" varStatus="status">
											<option value="${data.value }" <c:if test="${param.enddatemm eq data.value}" >selected</c:if>>${data.name }</option>
										</c:forEach>
									</select>
									
									<label><input type="checkbox" id="checkbox_forever1" name="checkboxForever1" value="FOREVER"/> 상시오픈</label>
								</div>
								</td>
							</tr>
						</table>
					</div>
					
					<div id="divTabPage2" class="tabView tbl_write2">
						<form id="frm" name="fileform" method="post" enctype="multipart/form-data">
						<input type="hidden" id="targetexcelfile" name="targetexcelfile" value="" title="" />
						<input type="hidden" id="targetcode" name="targetcode" value="${param.targetcode}" />
						<input type="hidden" id="targetmember" name="targetmember" value="${param.targetmember}" />
					
						<table width="100%" border="0" cellspacing="0" cellpadding="0">
							<colgroup>
								<col width="5%" />
								<col width="15%"  />
								<col width="80%"  />
							</colgroup>
							<tr>								
								<th>사용</th>
								<th>검색조건 </th>
								<th>검색 값 선택 </th>
							</tr>
							<tr>
								<td style="text-align:center;" rowspan="2">
									<input type="checkbox" id="checkbox_targetcode" name="checkboxTarget" value="TARGETCODE" checked />
								</td>
								<td style="text-align:center;" rowspan="2">
									<span>대상자 입력</span>
								</td>
								<td style="text-align:left;">
									리스트 정보 : <input type="text" id="targetexcelname" name="targetexcelname" title="대상자 리스트 정보"  title="대상자 리스트 정보" maxlength="20" style="width:300px" onblur="delVar(this,'|');"/>
								</td>
							</tr>
							<tr>
								<td style="text-align:left;">
									<input type="file" id="targetexcel" name="targetexcel" title="첨부파일" accept=".xlsx,.xls" title="첨부파일"/>
									<a href="javascript:;" id="aExcdlSave" class="btn_excel" style="vertical-align:middle">엑셀 업로드</a>
									<a href="javascript:;" id="aExcdlDown" class="btn_excel" style="vertical-align:middle; margin-left:10px;">샘플 다운</a>
								</td>
							</tr>
							<tr>
								<td></td>
								<td style="text-align:center;">업로드결과</td>
								<td style="text-align:left; height:25px;" >
									<span id="resultArea" style="display:none;">
										성공: <span id="successcount"></span>, 실패: <span id="failcount"></span>
										<a href="javascript:;" id="selectLogButton" class="btn_green" >로그보기</a>
										<a href="javascript:;" id="selectLogMemberButton" class="btn_green" style="display:none">대상자보기</a>
									</span>
								</td>
							</tr>
							<tr id="logcontent_area" style="display:none;">
								<td></td>								
								<td style="text-align:center;">로그</td>
								<td style="text-align:left;height:150px;">
									<textarea id="logcontent" name="logcontent" class="AXInput" style="width:90%;height:150px;" ></textarea>
								</td>
							</tr>
							<tr id="logmember_area" style="display:none;">
								<td></td>								
								<td style="text-align:center;">대상자</td>
								<td style="text-align:left;height:150px;">
									<textarea id="logmember" name="logmember" class="AXInput" style="width:90%;height:150px;" ></textarea>
								</td>
							</tr>
							<tr>
								<td></td>
								<td style="text-align:center;">
									<span>사용기간</span>
								</td>
								<td style="text-align:left;">
									<input type="text" id="startdateyymmdd2" name="startdateyymmdd2"  value="${param.startdateyymmdd}" title="사용시작일" class="AXInput datepDay" style="width:100px; min-width:100px">
									<select id="startdatehh2" name="startdatehh2" style="width:auto; min-width:70px"  title="사용시작시" >
										<c:forEach items="${ hourList}" var="data" varStatus="status">
											<option value="${data.value }" <c:if test="${param.startdatehh eq data.value}" >selected</c:if>>${data.name }</option>
										</c:forEach>
									</select>	
									<select id="startdatemm2" name="startdatemm2" style="width:auto; min-width:70px"  title="사용시작분" >
										<c:forEach items="${ minute2List}" var="data" varStatus="status">
											<option value="${data.value }" <c:if test="${param.startdatemm eq data.value}" >selected</c:if>>${data.name }</option>
										</c:forEach>
									</select>	
									 ~  
									<input type="text" id="enddateyymmdd2" name="enddateyymmdd2"  value="${param.enddateyymmdd}" title="사용종료일" class="AXInput datepDay" style="width:100px; min-width:100px">
									<select id="enddatehh2" name="enddatehh2" style="width:auto; min-width:70px"  title="사용종료시" >
										<c:forEach items="${ hourList}" var="data" varStatus="status">
											<option value="${data.value }" <c:if test="${param.enddatehh eq data.value}" >selected</c:if>>${data.name }</option>
										</c:forEach>
									</select>
									<select id="enddatemm2" name="enddatemm2" style="width:auto; min-width:70px"  title="사용종료분" >
										<c:forEach items="${ minute2List}" var="data" varStatus="status">
											<option value="${data.value }" <c:if test="${param.enddatemm eq data.value}" >selected</c:if>>${data.name }</option>
										</c:forEach>
									</select>
									<label><input type="checkbox" id="checkbox_forever2" name="checkboxForever2" value="FOREVER"/> 상시오픈</label>
								</td>
							</tr>
						</table>
						
						</form>
					</div>	
				</div>
 		
				<div align="center">
					<a href="javascript:;" id="insertBtn" class="btn_green">저장</a>
					<a href="javascript:;" id="closeBtn" class="btn_green close-layer">취소</a>
				</div>						
			</div>
		</div>
	</div>
	<!--// Edu Part Cd Info -->
