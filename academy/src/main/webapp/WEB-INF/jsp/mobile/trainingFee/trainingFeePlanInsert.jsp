<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/framework/include/mobile/header.jsp" %>

<script type="text/javascript">
var rownum = "";

$(document.body).ready(function() {
	//스크롤 사이즈
	setTimeout(function(){ abnkorea_resize(); }, 500);
	
	// 계획서 활성화
	$(".onlyNum").on("keyup", function(){
		$(this).val($(this).val().replace(/[^0-9]/gi,""));
// 		if(this.value > 999) { this.value = this.value.substring(0,3); } 
	});
	
	//지출항목 셋팅
	$('.spendItemWrap').spenditemMoblie($("#spendItem0").html());
	
	$(".fileUploadWrap").fileupMobile();

	$("#nomalEduTitle").bind("keyup",function(){
		var re = /[\{\}\[\]\/?.,;:|\)*~`!^\-_+┼<>@\#$%&\'\"\\(\=]/gi;
        var temp=$(this).val();
        if(re.test(temp)){ $(this).val(temp.replace(re,"")); } 
	});
	$("#nomalPlace").bind("keyup",function(){
		var re = /[\{\}\[\]\/?.,;:|\)*~`!^\-_+┼<>@\#$%&\'\"\\(\=]/gi;
		var temp=$(this).val();
        if(re.test(temp)){ $(this).val(temp.replace(re,"")); } 
	});
	$("#nomalEduDesc").bind("keyup",function(){
		var re = /[\{\}\[\]\/?.,;:|\)*~`!^\-_+┼<>@\#$%&\'\"\\(\=]/gi;
		var temp=$(this).val();
        if(re.test(temp)){ $(this).val(temp.replace(re,"")); } 
	});
});

var reload = {
	searchMonth : function(schYear, schMonth) {
		
		var i     = 0;
		var sHtml = "";
		
		var okdata = $("#trainingFeeForm > input[name='okdata']").val().split(',');
		var baseYear = $("#trainingFeeForm > input[name='giveyyear']").val();
		
		for(var i=0; i<12; i++) { 
			var sBlob = "N";
			
			$(okdata).each(function(num, val){
				if( (i+1)==parseInt(val.slice(5)) ) {
					sBlob = "Y";
				}			
			});
			
			if(sBlob=="Y" && baseYear==schYear) {
				if((i+1)==schMonth  ){
					sHtml = sHtml+"<a href=\"javascript:btnEvent.searchPlan('Y','"+(i+1)+"');\" class=\"on\"><span class=\"b\">"+(i+1)+"월</span></a>";	
				} else {
					sHtml = sHtml+"<a href=\"javascript:btnEvent.searchPlan('Y','"+(i+1)+"');\"><span class=\"b\">"+(i+1)+"월</span></a>";	
				}			
			} else {
				if((i+1)==schMonth ){
					sHtml = sHtml+"<a href=\"javascript:btnEvent.searchPlan('N','"+(i+1)+"');\" class=\"on\"><span>"+(i+1)+"월</span></a>";	
				} else {
					sHtml = sHtml+"<a href=\"javascript:btnEvent.searchPlan('N','"+(i+1)+"');\"><span>"+(i+1)+"월</span></a>";	
				}
			}
		}	
		$("#searchMonthList").html(sHtml);
	},
	pagego : function(){
		$("#trainingFeeForm").attr("action", "/mobile/trainingFee/trainingFeeIndex.do")
		$("#trainingFeeForm").submit();
	}
}


// 계획금액 입력시 저장용 변수
function changeSpendAmount(num) {
	var text = $("#amount"+num).val().replace(/[^0-9]/gi, "");
	if(text > 999999999999) { 
		$("#amount"+num).val(setComma(text.substring(0,12)));
	} else {
		$("#amount"+num).val(setComma(text));
	}
}

function changeRentAmount(id) {
	var text = $("#"+id).val().replace(/[^0-9]/gi, "");
	var commaTxt = setComma(text);
	var unCommaTxt = commaTxt.replace(/,/g, "");
	
	$("#"+id).val(commaTxt);

	var rentDeposit = isNvl($("#rentDeposit").val(),'0'); // 보증금
	var rentAmount  = isNvl($("#rentAmount").val(),'0'); // 월 임대료
	var pay         = "";
	var payText     = "";
	var payComma    = "";
	
	rentDeposit = rentDeposit.replace(/,/g, "");
	rentAmount  = rentAmount.replace(/,/g, "");
	
	rentDeposit = ( parseInt(rentDeposit) * 0.05 ) / 12; // 보증금은 년 5% 대출 이율로 월할 계산
	rentDeposit = Math.ceil(rentDeposit);
	pay         = parseInt(rentDeposit) + parseInt(rentAmount);
	
	payComma    = setComma(pay);
	payText     = chnageNumberTxt(pay);
	
	$("#rentDepAmount").text(payComma);
	$("#rentDepAmountTxt").text(payText);
	
	if(id=="rentDeposit") {
		$("#rentDepositTxt").text(chnageNumberTxt(unCommaTxt));		
	} else {
		$("#rentAmountTxt").text(chnageNumberTxt(unCommaTxt));
	}
// 	$("#spendamount"+num).val(unCommaTxt);
}

var html = {
	clickPlanList : function(sortnum,planid,day){
		$("#trainingFeeForm > input[name='listDay']").val(day.substring(8,10));
		$("#trainingFeeForm > input[name='mode']").val("U");
		if( $("#trainingFeeForm > input[name='editYn']").val() == "Y" ) {
			$("#trainingFeeForm > input[name='sortnum']").val(sortnum);
			$("#trainingFeeForm > input[name='planid']").val(planid);
		} else {
			$("#trainingFeeForm > input[name='sortnum']").val(sortnum);
			$("#trainingFeeForm > input[name='planid']").val(planid);
		}
// 		html.clickPlanListEvent();
	},
	clickPlanListEvent : function() {
		$("#trainingFeeForm").attr("action", "/mobile/trainingFee/trainingFeePlan.do")
		$("#trainingFeeForm").submit();
	},
	changeRentFM : function(obj){
		var params = {'fiscalyear':obj.value, 'schfiscalyear':$("#trainingFeeForm > input[name='fiscalyear']").val()};
		
		$.ajaxCall({
			method : "POST",
			url : "<c:url value="/mobile/trainingFee/selectTrFeeRentMonth.do"/>",
			dataType : "json",
			data : params,
			bLoading : "N",
			success : function(data, textStatus, jqXHR) {
				var option = '';
	        	for(var i = 0; i < data.dataList.length; i++){
	            	var code = data.dataList[i].mm || '';
	            	
	            	option += '<option value="'+code+'">'+code+'월</option>';
	            }

            	$('select[name="rentfrommonth"]').html(option);
			},
			error : function(jqXHR, textStatus, errorThrown) {
				alert("처리도중 오류가 발생하였습니다.");
			}
		});
	},
	changeRentFMTO : function(obj){
		var params = {'fiscalyear':obj.value, 'schfiscalyear':$("#trainingFeeForm > input[name='fiscalyear']").val()};
		
		$.ajaxCall({
			method : "POST",
			url : "<c:url value="${pageContext.request.contextPath}/trainingFee/selectTrFeeRentMonth.do"/>",
			dataType : "json",
			data : params,
			bLoading : "N",
			success : function(data, textStatus, jqXHR) {
				var option = '';
	        	for(var i = 0; i < data.dataList.length; i++){
	            	var code = data.dataList[i].mm || '';
	            	
	            	option += '<option value="'+code+'">'+code+'월</option>';
	            }

            	$('select[name="renttomonth"]').html(option);
			},
			error : function(jqXHR, textStatus, errorThrown) {
				alert("처리도중 오류가 발생하였습니다.");
			}
		});
	},
	filecall : function(num) {
		rownum = num;
		window.appFile.selectFileInfo(num, "img", "10485760", "$('#IframeComponent').get(0).contentWindow.fncallback");
	},
	filesize : function(file, num){
		if( isNull(file.files[0]) ) {
			if( isNull($("#oldfilekey"+num).val()) ) {
				$("#filekey"+num).val("");
			} else {
				$("#filekey"+num).val($("#oldfilekey"+num).val());
			}
			return;
		}
		
		var fSize = file.files[0].size;
		var maxSize = 1024*10240;
		if(fSize>maxSize) {
			alert("용량제한 10MB를 초과 하였습니다.");
			file.value="";
			return;
		}
		
		var chkData = {
				"chkFile" : "gif,png,jpg,jpeg"
		};
		
		
		
		var ext = file.value.split('.').pop().toLowerCase();
		var opts = $.extend({},chkData);
		
		if(opts.chkFile.indexOf(ext) == -1) {
			alert(opts.chkFile + ' 파일만 업로드 할수 있습니다.');
			return;
		}
		
		/**  */
		$("#fileForm"+num).ajaxForm({
		  	  url : "<c:url value="/mobile/trainingFee/fileUpLoadSpend.do"/>"
		    , method : "post"
			, async : false
			, beforeSend: function(xhr, settings) { showLoading(); }
			, success : function(data){
				var item = data.result;
				$("#filekey"+num).val(item.fileKey);
				hideLoading();
			}
			, error : function(data){
				hideLoading();
				var mag = '<spring:message code="trfee.errors.filekey.false"/>';
				alert(mag);
			}
		}).submit();
	}
}

function fncallback(filekey){
	var item = JSON.parse(filekey);
	
	$("#filekey"+rownum).val(item.fileKey);
	$("#file"+rownum).val(item.realFileNm);
}

var btnEvent = {
		btnInit : function(editYn) {
			if(editYn=="Y") {
				// 입력모드
				$("#btnPlanCancel").show();
				$("#btnPlanInsert").show();
			} else {
				// 조회모드
			}
		},
		searchYear : function(obj) {
			var okdata = $("#trainingFeeForm > input[name='okdata']").val().split(',');
			var sEditYn = "N";
			
			$(okdata).each(function(num, val){
				if(parseInt(val)==parseInt(obj.value + "" + $("#trainingFeeForm > input[name='givemonth']").val())) {
					sEditYn = "Y";
				}					
			});
			
			$("#trainingFeeForm > input[name='giveyear']").val(obj.value);
			$("#trainingFeeForm > input[name='editYn']").val(sEditYn);
			$("#trainingFeeForm > input[name='sortnum']").val("");
			$("#trainingFeeForm > input[name='planid']").val("");
			$("#trainingFeeForm > input[name='listDay']").val("");
			$("#trainingFeeForm > input[name='mode']").val("S");
			btnEvent.searchPlan(sEditYn, $("#trainingFeeForm > input[name='givemonth']").val());
		},
		addPlan : function() {
			$("#trainingFeeForm > input[name='sortnum']").val("");
			$("#trainingFeeForm > input[name='planid']").val("");
			$("#trainingFeeForm > input[name='mode']").val("I");
			$("#trainingFeeForm").attr("action", "/mobile/trainingFee/trainingFeePlan.do")
			$("#trainingFeeForm").submit();
		},
		nomalPlanDelete : function() {
			var result = confirm("저장 하신 사전계획서를 삭제 하시겠습니까?");
			
			if(result){
				$("#trainingFeeForm > input[name='mode']").val("D");
				var param = {  tabType     : "nomal"  
						 };
				
				btnEvent.savePlan(param);				
			}
		},
		nomalPlanCancel : function() {
			var result = confirm("입력된 사전계획서 수정 취소 하시겠습니까?");
			
			if(result) {
				$("#trainingFeeForm > input[name='sortnum']").val("");
				$("#trainingFeeForm > input[name='planid']").val("");
				$("#trainingFeeForm").attr("action", "/mobile/trainingFee/trainingFeePlan.do")
				$("#trainingFeeForm").submit();
			}
		},
		nomalPlanSch : function() {
				$("#trainingFeeForm > input[name='sortnum']").val("");
				$("#trainingFeeForm > input[name='planid']").val("");
				$("#trainingFeeForm").attr("action", "/mobile/trainingFee/trainingFeePlan.do")
				$("#trainingFeeForm").submit();
		},
		rentCancel : function() {
			var result = confirm("입력된 임대차지출 수정 취소 하시겠습니까?");
			
			if(result) {
				$("#trainingFeeForm > input[name='sortnum']").val("");
				$("#trainingFeeForm > input[name='planid']").val("");
				$("#trainingFeeForm").attr("action", "/mobile/trainingFee/trainingFeePlan.do")
				$("#trainingFeeForm").submit();
			}
		},
		nomalPlanInsert : function() {
			if(!chkValidation({chkId:"#nomalSpend", chkObj:"hidden|input|select"}) ){
				return;
			}
			
			var sSpendItem = "";
			var sSpendAmount = "";
			var cnt = $(".spendItemWrap > .inputWrap").length;
			
			for( var i=0; i < cnt; i++ ) {
				var objItem   = $(".spendItemWrap > .inputWrap > div > .selectBox1 > select[name='nomalSpendItem']")[i].value;
				var objAmount = $(".spendItemWrap > .inputWrap > div > .unit > input[name='spendamount']")[i].value;
				var unCommaTxt = objAmount.replace(/,/g, "");
				
				if(i==0) {
					sSpendItem   = objItem;
					sSpendAmount = unCommaTxt;
				} else {
					sSpendItem   = sSpendItem + "," + objItem;
					sSpendAmount = sSpendAmount + "," + unCommaTxt;
				}
			}
			
			var param = {  tabType     : "nomal"  
					      ,eduTitle    : $("#nomalEduTitle").val()   
					      ,eduKind     : $("#nomalEduKind option:selected").val()  
					      ,place       : $("#nomalPlace").val()  
					      ,spendDt     : $("#spendDt").val()
					      ,personcount : $("#nomalPersoncount").val()
					      ,plancount   : $("#nomalPlancount").val()
					      ,eduDesc     : $("#nomalEduDesc").val()   
					      ,spendItem   : sSpendItem
					      ,spendAmount : sSpendAmount
					 };
			
			var result = confirm("사전계획서 작성 내용을 저장 하시겠습니까?");
			
			if(result){
				btnEvent.savePlan(param);
			}
		},
		rentInsert : function() {
			var options = {
					beforeSubmit : btnEvent.submitBefore,
					success : btnEvent.submitAfter,
					dataType : "joson",
					method : "post",
			};
			
			if(!chkValidation({chkId:"#trainingfeerent", chkObj:"hidden|input|select"}) ){
				return;
			}
			// 동의여부 체크
			if( !$("#chkRent").is(":checked") ) {
				alert("임대차 증빙 관련 동의여부를 체크 해 주세요!!");
				return;
			}
			
			var rentfrommonth = "";
			var renttomonth = "";
			
			if($("#rentfrommonth option:selected").val().length==1) rentfrommonth = "0"+$("#rentfrommonth option:selected").val(); else rentfrommonth = $("#rentfrommonth option:selected").val();
			if($("#renttomonth option:selected").val().length==1) renttomonth = "0"+$("#renttomonth option:selected").val(); else renttomonth = $("#renttomonth option:selected").val();
			
			var fromDt = $("#rentfromyear option:selected").val() +""+ rentfrommonth;			
			var toDt = $("#renttoyear option:selected").val() +""+ renttomonth;			

			if(fromDt > toDt) {
				alert("[임대기간] 종료 년/월은 시작 년/월 보다 커야 합니다.");
				return;
			}
			
			var sRentDeposit = $("#rentDeposit").val().replace(/,/g, "");
			var sRentamount = $("#rentAmount").val().replace(/,/g, "");
			/** 파일 체크 */
			var cnt = $(".fileUploadWrap").find("form").length;
			var filekey = "";
			
			for( var i=0; i < cnt; i++ ) {
				var objFile   = $(".fileUploadWrap").find("input[name='filekey']")[i];

				if(isNull(objFile.value)){
					alert("["+(i+1)+"] 임대차 계약서 파일을 선택 해 주세요.");
					return;
				}
				
				if(i==0) {
					filekey = objFile.value;
				} else {
					filekey = filekey + "," + objFile.value;
				}
			}
			
			var result = confirm("임대차지출 작성 내용을 저장 하시겠습니까?");
			
			if(result){
				
				var param = {  tabType     : "rent"
						      ,rentDeposit : sRentDeposit 
						      ,rentamount  : sRentamount 
						      ,renttitle   : "임대차지출"
					    	  ,rentfrommonth : $("#rentfromyear option:selected").val() +""+ rentfrommonth
						      ,renttomonth   : $("#renttoyear option:selected").val() +""+ renttomonth
						      ,attachfile  : filekey
						      ,giveyear   : $("#trainingFeeForm > input[name='giveyear']").val()
							  ,givemonth  : $("#trainingFeeForm > input[name='givemonth']").val()
						 };
				
				// 첨부파일 전송 완료 후 저장
				btnEvent.savePlan(param);
			}
			
		},
		savePlan : function(param) {
			var defaultParam = {
					giveyymm   : $("#trainingFeeForm > input[name='giveyymm']").val(),
					fiscalyear : $("#trainingFeeForm > input[name='fiscalyear']").val(),
					giveyear   : $("#trainingFeeForm > input[name='giveyear']").val(),
					givemonth  : $("#trainingFeeForm > input[name='givemonth']").val(),
					okdata     : $("#trainingFeeForm > input[name='okdata']").val(),
					depaboNo   : $("#trainingFeeForm > input[name='depaboNo']").val(),
					editYn     : $("#trainingFeeForm > input[name='editYn']").val(),
					mode       : $("#trainingFeeForm > input[name='mode']").val(),
					targettype : $("#trainingFeeForm > input[name='targettype']").val(),
					trfee      : $("#trainingFeeForm > input[name='trfee']").val(),
					groupCode  : $("#trainingFeeForm > input[name='groupCode']").val(),
					procType   : $("#trainingFeeForm > input[name='procType']").val(),
					sortnum    : $("#trainingFeeForm > input[name='sortnum']").val(),
					planid     : $("#trainingFeeForm > input[name='planid']").val(),
					listDay    : $("#trainingFeeForm > input[name='listDay']").val()
			};
			
			$.extend(defaultParam, param);
			
			$.ajaxCall({
				url : "<c:url value="/mobile/trainingFee/saveTrainingFeePlan.do"/>",
				data : defaultParam,
				success : function(data, textStatus, jqXHR) {
					if( data.result.errCode < 1 ) {
						alert("처리도중 오류가 발생하였습니다.");
					} else {
						alert(data.result.errMsg);
						$("#trainingFeeForm").attr("action", "/mobile/trainingFee/trainingFeePlan.do")
						$("#trainingFeeForm").submit();
					}					
				},
				error : function(jqXHR, textStatus, errorThrown) {
					var mag = '<spring:message code="trfee.errors.save.false"/>';
					alert(mag);
				}
			});
		},
		resultconfirm : function() {
			var result = confirm("계획 완료 시 더이상 추가/수정을 할 수 없습니다.\n\n사전계획서 작성 내용을 완료 하시겠습니까?");
			
			if(result){
				var defaultParam = {
						fiscalyear : $("#trainingFeeForm > input[name='fiscalyear']").val(),
						giveyear   : $("#trainingFeeForm > input[name='giveyear']").val(),
						givemonth  : $("#trainingFeeForm > input[name='givemonth']").val(),
						depaboNo   : $("#trainingFeeForm > input[name='depaboNo']").val(),
						groupCode  : $("#trainingFeeForm > input[name='groupCode']").val(),
						procType   : $("#trainingFeeForm > input[name='procType']").val(),
						planstatus : "Y"
				};
				
				btnEvent.resultSave(defaultParam,"사전 계획서 작성 완료 하였습니다.");
			}
		},
		resultUpdate : function() {
			var result = confirm("사전 계혹서를 수정 하시겠습니다.\n\n수정 완료 후 계획서 완료를 하셔야 적용이 됩니다.");
			
			if(result){
				var defaultParam = {
						fiscalyear : $("#trainingFeeForm > input[name='fiscalyear']").val(),
						giveyear   : $("#trainingFeeForm > input[name='giveyear']").val(),
						givemonth  : $("#trainingFeeForm > input[name='givemonth']").val(),
						depaboNo   : $("#trainingFeeForm > input[name='depaboNo']").val(),
						groupCode  : $("#trainingFeeForm > input[name='groupCode']").val(),
						procType   : $("#trainingFeeForm > input[name='procType']").val(),
						planstatus : "N"
				};
				
				btnEvent.resultSave(defaultParam, "사전 계획서를 수정 할 수 있습니다.");
			}
		},
		resultCancel : function(){
			alert("취소를 누르면 화면을 그대로??");
		},
		resultSave : function(defaultParam, msgText) {
			$.ajaxCall({
				url : "<c:url value="/mobile/trainingFee/saveTrainingFeePlanConfirm.do"/>",
				data : defaultParam,
				success : function(data, textStatus, jqXHR) {
					if( data.result.errCode < 1 ) {
						alert("처리도중 오류가 발생하였습니다.");
					} else {
						alert(msgText);
						$("#trainingFeeForm").attr("action", "/mobile/trainingFee/trainingFeePlan.do")
						$("#trainingFeeForm").submit();
					}					
				},
				error : function(jqXHR, textStatus, errorThrown) {
					var mag = '<spring:message code="trfee.errors.resultsave.false"/>';
					alert(mag);
				}
			});
		}
}

</script>

<!-- content area | ### academy IFRAME Start ### -->

<section id="pbContent" class="bizroom">
<form id="trainingFeeForm" name="trainingFeeForm" method="post">
	<input type="hidden" name="fiscalyear"  value="${scrData.fiscalyear }" />
	<input type="hidden" name="giveyear"    value="${scrData.giveyear }"   />
	<input type="hidden" name="givemonth"   value="${scrData.givemonth }"  />
	<input type="hidden" name="okdata"      value="${scrData.okdata }"     />
	<input type="hidden" name="depaboNo"    value="${scrData.depaboNo }"   />
	<input type="hidden" name="editYn"      value="${scrData.editYn }"     />
	<input type="hidden" name="mode"        value="${scrData.mode }"       />
	<input type="hidden" name="targettype"  value="${scrData.targettype }" />
	<input type="hidden" name="trfee"       value="${scrData.trfee }"      />
	<input type="hidden" name="groupCode"   value="${scrData.groupCode }"  />
	<input type="hidden" name="procType"    value="${scrData.procType }"   />
	<input type="hidden" name="sortnum"     value="${scrData.sortnum }"    />
	<input type="hidden" name="planid"      value="${scrData.planid }"     />
	<input type="hidden" name="listDay"     value="${scrData.listDay }"    />
	<input type="hidden" name="planstatus"  value="${scrData.planstatus }" />
	<input type="hidden" name="rentstatus"  value="${scrData.rentstatus }" />
	<input type="hidden" name="app"         value="${scrData.app }"        />
</form>
	<div class="mTrainingFee">
		<h2 class="titTop">교육비 사전계획등록/조회</h2>
		<div class="tabWrapLogical tNum2Line">
			<section class="on">
				<h2 class="tab01"><a href="#none" onclick="setTimeout(function(){ abnkorea_resize(); }, 500);">일반지출</a></h2>
					<!-- 일반지출 -->
					<div class="mInputWrapper" id="nomalSpend">
						<!-- @edit 20160705 디자인 수정사항 적용 brdTop1 클래스 추가 -->
						<div class="inputWrap brdTop1">
							<strong class="labelSizeM">교육명</strong>
							<div class="textBox"><input type="text" id="nomalEduTitle" name="nomalEduTitle" title="교육명" class="requd" maxlength="50" oninput="maxLengthCheck(this)" /></div>
						</div>
						<div class="inputWrap">
							<strong class="labelSizeM">교육종류</strong>
							<div class="textBox">
								<p class="selectBox1">
									<select title="교육종류선택" id="nomalEduKind" name="nomalEduKind" class="requd">
										<option value="" selected="selected">교육종류 선택</option>
										<ct:code type="option" majorCd="edukind" selectAll="false" />
									</select>
								</p>
							</div>
						</div>
						<div class="inputWrap">
							<strong class="labelSizeM">교육일자</strong>
							<div class="textBox"><input type="date" title="교육일자" id="spendDt" name="spendDt" class="inputDate requd" /> </div>
						</div>
						<div class="inputWrap">
							<strong class="labelSizeM">예상인원</strong>
							<div class="textBox">
								<p class="unit"><input type="tel" id="nomalPersoncount" name="nomalPersoncount" title="예상인원" class="onlyNum requd" maxlength="5" oninput="maxLengthCheck(this)" /><em>명</em></p>
							</div>
						</div>
						<div class="inputWrap">
							<strong class="labelSizeM">횟수</strong>
							<div class="textBox">
								<p class="unit"><input type="tel" id="nomalPlancount" title="횟수" class="onlyNum requd" maxlength="3" oninput="maxLengthCheck(this)" /><em>회</em></p>
							</div>
						</div>
						<div class="spendItemWrap">
							<div class="inputWrap">
								<strong class="labelSizeM">지출항목/<br />예상금액</strong>
								<div class="textBox unit">
									<p class="selectBox1">
										<select id="spendItem0" title="지출항목 선택" name="nomalSpendItem" class="requd">
											<option value="">선택</option>
											<ct:code type="option" majorCd="spenditem" selectAll="false" />
										</select>
									</p>
									<p class="unit"><input type="text" title="예상금액" id="amount0" name="spendamount" placeholder="금액입력" onkeyup="changeSpendAmount('0')" class="requd" /><em>원</em></p>
									<p class="btns" id="spendBtn0"><a href="#" class="btnTblLGray">추가</a></p>
								</div>
							</div>
						</div>
						<div class="inputWrap">
							<strong class="labelSizeM">교육장소(선택)</strong>
							<div class="textBox"><input type="text" id="nomalPlace" name="nomalPlace" title="교육장소(선택)" class="" maxlength="50" oninput="maxLengthCheck(this)"/></div>
						</div>
						<!-- @edit 20160705 디자인 수정사항 적용 brdB 클래스 추가 -->
						<div class="inputWrap brdB">
							<strong class="labelSizeM">교육설명(선택)</strong>
							<div class="textBox"><input type="text" id="nomalEduDesc" name="nomalEduDesc" title="교육설명(선택)" class="" maxlength="50" oninput="maxLengthCheck(this)"/></div>
						</div>
						<div class="btnWrap aNumb2">
							<span><a href="javascript:;" class="btnBasicGL" id="btnPlanCancel" onclick="javascript:btnEvent.nomalPlanCancel();">취소</a></span>
							<span><a href="javascript:;" class="btnBasicBL" id="btnPlanInsert" onclick="javascript:btnEvent.nomalPlanInsert();">저장</a></span>
						</div>
					</div>
			</section>
			<!-- 임대차 지출 -->
			<section id="trainingfeerent">
				<h2 class="tab02"><a href="#none" onclick="setTimeout(function(){ abnkorea_resize(); }, 500);">임대차지출</a></h2>
				<div class="mInputWrapper">
					<ul class="listDot mgtSM">
						<li>임대차 증빙은 회계연도 단위로 증빙이 필요합니다.</li>
						<li>현재 등록하는 임대차 증빙은 ${scrData.fiscalyear}년 8월까지 일괄 적용됩니다.</li>
						<li>등록된 임대차 계약 사항은 수정이 불가하므로 정확히 입력해 주세요.</li>
					</ul>
					<!-- @edit 20160629 레이블 문구수정 -->
					<div class="secWrap">
						<input type="checkbox" id="chkRent" title="임대차 동의여부" /><label for="chkRent">임대차 계약서 등록에 대해 임대인과 사전 협의 하였으며, 임대인의 개인정보 (이름, 주민번호, 전화(휴대)번호, 주소 등) 를 가린 사진을 등록하겠습니다.</label>
					</div>
					
					<!-- @edit 20160705 디자인 수정사항 적용 brdTop1 클래스 추가 -->
					<div class="inputWrap brdTop1">
						<strong class="labelBlock">임대기간</strong>
						<div class="textBox pdlS">
							<div class="inputNum4">
								<span class="bgNone">
									<select title="임대기간 시작년" name="rentfromyear" id="rentfromyear" onchange="javascript:html.changeRentFM(this);" class="requd" disabled="disabled">
										<c:forEach var="rentYear" items="${rentYear}" varStatus="status">
											<option value="${rentYear.fiscalyear }" <c:if test="${scrData.giveyear eq rentYear.fiscalyear}">selected="selected"</c:if>>${rentYear.fiscalyear }년</option>
										</c:forEach>
									</select>
								</span>
								<span class="bgNone">
									<select title="임대기간 시작월" name="rentfrommonth" id="rentfrommonth" class="requd" disabled="disabled" >
										<c:forEach var="rentMonth" items="${rentMonth}" varStatus="status">
											<option value="${rentMonth.mm }" <c:if test="${scrData.givemonth eq rentMonth.mm}">selected="selected"</c:if>>${rentMonth.mm }월</option>
										</c:forEach>
									</select>
								</span>
								<span>
									<select title="임대기간 종료년" name="renttoyear" id="renttoyear" onchange="javascript:html.changeRentFMTO(this);" class="requd" >
										<c:forEach var="rentYear" items="${rentYear}" varStatus="status">
											<option value="${rentYear.fiscalyear }" <c:if test="${scrData.fiscalyear eq rentYear.fiscalyear}">selected="selected"</c:if>>${rentYear.fiscalyear }년</option>
										</c:forEach>
									</select>
								</span>
								<span class="bgNone">
									<select title="임대기간 종료월" name="renttomonth" id="renttomonth" class="requd" >
										<c:forEach var="rentMaxMonth" items="${rentMaxMonth}" varStatus="status">
											<option value="${rentMaxMonth.mm }">${rentMaxMonth.mm }월</option>
										</c:forEach>
									</select>
								</span>
							</div>
						</div>
					</div>
							
					<div class="inputWrap">
						<strong class="labelSizeM">보증금</strong>
						<div class="textBox">
							<p class="unit"><input type="tel" title="보증금" class="unitInput requd" name="rentDeposit" id="rentDeposit" onkeyup="changeRentAmount('rentDeposit')" maxlength="15" oninput="maxLengthCheck(this)" /> <em>원</em></p>
							<p class="unit"><span class="readonlyStyle" id="rentDepositTxt"></span></p>
							<p class="listWarning pdbS">※ 보증금은 년 5%로 월할 계산됩니다.</p>
						</div>
					</div>
					<div class="inputWrap">
						<strong class="labelSizeM">월임대료</strong>
						<div class="textBox">
							<p class="unit"><input type="tel" title="월 임대료" name="rentAmount" id="rentAmount" class="requd" onkeyup="changeRentAmount('rentAmount')" maxlength="15" oninput="maxLengthCheck(this)" /> <em>원</em></p>
							<p class="unit pdbS"><span class="readonlyStyle" id="rentAmountTxt"></span></p>
						</div>
					</div>
					<div class="inputWrap">
						<!-- @edit 20160705 디자인 수정사항 적용 pdNone 클래스 추가 -->
						<strong class="labelSizeM pdNone">월지원금</strong>
						<div class="textBox">
							<p class="pdbS">보증금이자(5%/12) + 월임대료 = <span id="rentDepAmount" ></span></p> 
							<p class="unit pdbS"><span class="readonlyStyle" id="rentDepAmountTxt" ></span></p>
						</div>
					</div>
					<!-- @edit 20160705 디자인 수정사항 적용 -->
					<div class="fileUploadWrap">
						<div class="inputWrap brdB">
							<strong class="labelSizeM pdNone">임대차계약서</strong>
							<form id="fileForm0" method="POST" enctype="multipart/form-data" class="textBox">
								<p> <c:if test="${scrData.app eq 'amway_Android' }">
										<a href="javascript:html.filecall(0);" class="btnTbl mgbS">파일선택</a>
										<input type="text" id="file0" class="file requd" name="file0" title="사진 찾기" placeholder="선택된 파일 없음" readonly />
									</c:if>									
									<c:if test="${scrData.app ne 'amway_Android' }">
										<input type="file" id="file0" class="file requd" name="file0" title="사진 찾기" onChange="javascript:html.filesize(this,0);" accept="image/*;capture=camera" />
									</c:if>
								</p>
								<p class="btns" id="retnBtn0"><a href="#" class="btnTblLGray">파일추가</a></p>
								<input type="hidden" name="filekey" id="filekey0" title="파일번호" />
								<input type="hidden" name="oldfilekey" id="oldfilekey0" title="파일번호" />
							</form>
						</div>
					</div>
					
					<!-- // @edit 20160705 디자인 수정사항 적용 -->
					<div class="btnWrap aNumb2">
						<span><a href="javascript:;" class="btnBasicGL" id="btnRentCancel" onclick="javascript:btnEvent.rentCancel()">취소</a></span>
						<span><a href="javascript:;" class="btnBasicBL" id="btnRentInsert" onclick="javascript:btnEvent.rentInsert()">저장</a></span>
					</div>
				</div>
			</section>
		</div>
		
	</div>
	<!-- //계획추가 -->
</section>
<!-- //content area | ### academy IFRAME End ### -->

<%@ include file="/WEB-INF/jsp/framework/include/footer.jsp"%>
