<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/framework/include/header.jsp"%>
<!-- //Adobe Analytics Header 호출 include -->
<%@ include file="/WEB-INF/jsp/framework/include/inc_analyticsHeader.jsp"%>

<script type="text/javascript">
$(document.body).ready(function() {
	// 계획서 활성화
	$(".onlyNum").on("keyup", function(){
		$(this).val($(this).val().replace(/[^0-9]/gi,""));
	});
	
	$("#nomalEduTitle").keyup(function(event){
		var replaceChar = /[\{\}\[\]\/?.,;:|\)*~`!^\-_+┼<>@\#$%&\'\"\\(\=]/gi;
		var temp=$(this).val();
		
        if(replaceChar.test(temp)){ //특수문자가 포함되면 삭제하여 값으로 다시셋팅
         $(this).val(temp.replace(replaceChar,"")); 
        }        
	});
	$("#nomalPlace").keyup(function(event){
		var replaceChar = /[\{\}\[\]\/?.,;:|\)*~`!^\-_+┼<>@\#$%&\'\"\\(\=]/gi;
		var temp=$(this).val();
		
        if(replaceChar.test(temp)){ //특수문자가 포함되면 삭제하여 값으로 다시셋팅
         $(this).val(temp.replace(replaceChar,"")); 
        }        
	});
	$("#nomalEduDesc").keyup(function(event){
		var replaceChar = /[\{\}\[\]\/?.,;:|\)*~`!^\-_+┼<>@\#$%&\'\"\\(\=]/gi;
		var temp=$(this).val();
		
        if(replaceChar.test(temp)){ //특수문자가 포함되면 삭제하여 값으로 다시셋팅
         $(this).val(temp.replace(replaceChar,"")); 
        }        
	});
	
	//지출항목 셋팅
	$('.spendItemWrap').spenditem($("#spendItem0").html());
	
	//지출항목 셋팅
	$(".spenditemAdd").on("click", function () {
		var num = $(".spendItemList > li").length;
		var addDom = "";
		
		if( !isNull(document.getElementById("amount"+num)) ) {
			num = num + "" + 1
		}
		
		addDom += "<li>";
		addDom += "	<select title='지출항목 선택' name='nomalSpendItem'>";
		addDom += $("#spendItem0").html();
		addDom += "	</select>";
		addDom += "	<label for='num3' class='mgLabel'>예상금액</label>";
		addDom += "	<input type='tel' id='amount"+num+"' name='spendamount' title='예상금액' class='requd isNum' maxlength='15' oninput='maxNumberLength(this)' onkeyup='changeSpendAmount("+num+")' />";
// 		addDom += "	<input type='hidden' id='spendamount"+num+"' name='spendamount' title='예상금액' class='requd' /> 
		addDom += "	<a href='javascript:javascript.spendItemDelete(this);' class='mgLabel btnTbl btnItemDelete'><span>삭제</span></a>";
		addDom += "</li>";
		
		$(".spendItemList").append(addDom);
		
		setTimeout(function(){ abnkorea_resize(); }, 500);
	});
	
	$(".fileUploadWrap").fileup();
	
	$(".btnFileItemAdd").on("click", function () {
		var num = $(".fileup > li").length;
		var addDom = "";
		
		if( !isNull(document.getElementById("file"+num)) ) {
			num = num + "" + 1
		}
	
		addDom += "<li>";
		addDom += "<form id='fileForm"+num+"' method='POST' enctype='multipart/form-data'>";
		addDom += "	<input type='file' id='file"+num+"' name='file' title='첨부파일' onChange='javascript:html.filesize(this,"+num+");' />";
		addDom += "	<input type='hidden' id='filekey"+num+"' name='filekey' title='파일번호' />";
		addDom += "	<input type='hidden' id='oldfilekey"+num+"' name='oldfilekey' title='파일번호' />";
		addDom += "	<a href='javascript:;' class='mgLabel btnTbl btnFileItemDelete'><span>파일삭제</span></a>";
		addDom += "</form></li>";
		
		$(".fileup").append(addDom);
		
		//스크롤 사이즈
		setTimeout(function(){ abnkorea_resize(); }, 500);
	});
	
	init();
});

function init() {
	// 교육비 표기
	$("#trfee").text(setComma($("#trainingFeeForm > input[name='trfee']").val()));
	// 월 표기
	reload.searchMonth($("#trainingFeeForm > input[name='giveyear']").val(), $("#trainingFeeForm > input[name='givemonth']").val());
		
	if( !isNull($("#trainingFeeForm > input[name='sortnum']").val()) ) {
		if($("#trainingFeeForm > input[name='sortnum']").val()=='0') {
			$("#groupRentClass").click();
			$('#groupPlanClass').removeClass('logTabSection on').addClass('logTabSection');
			$('#groupRentClass').removeClass('logTabSection').addClass('logTabSection on');
		}
	}
	
	tabEvent.dayList();
	
	if(!isNull($("#trainingFeeForm > input[name='sortnum']").val())) {
		var sortnum = $("#trainingFeeForm > input[name='sortnum']").val();
		
		if(sortnum=="0") {
			$("#groupPlanClass").remove();
			$("#groupRentClass").show();
			if("${scrData.spendconfirmflag}"=="Y") {
				alert("지출 승인 된 임대차는 수정 할 수 없습니다.");
			}
		} else {
			$("#groupPlanClass").show();
			$("#groupRentClass").remove();
		}
	} else {
		$("#groupPlanClass").show();
		$("#groupRentClass").show();
	}
	
	setTimeout(function(){ abnkorea_resize(); }, 500);
}

var reload = {
	searchMonth : function(schYear, schMonth) {
		
		var i     = 0;
		var sHtml = "";
		
		var okdata   = $("#trainingFeeForm > input[name='okdata']").val().split(',');
		var baseYear = $("#trainingFeeForm > input[name='giveyear']").val();
		var schYear  = $("#searchYear").val();
		
		for(var i=0; i<12; i++) { 
			var sBlob    = "N";
			var schmm    = "";
			var schyymm  ="";
			
			if(i < 9) {
				schmm = "0"+(i+1);
			} else {
				schmm = i+1;
			} 
			
			schyymm = schYear + "" + schmm;
			
			$(okdata).each(function(num, val){
				if( schyymm == val.slice(1) ) {
					sBlob = "Y";
				}
			});
			
			if(sBlob=="Y") {
				if( schyymm==(schYear+""+schMonth) ){
					sHtml = sHtml+"<a href=\"javascript:btnEvent.searchPlan('Y','"+(i+1)+"');\" class=\"on\"><span class=\"b\">"+(i+1)+"월</span></a>";	
				} else {
					sHtml = sHtml+"<a href=\"javascript:btnEvent.searchPlan('Y','"+(i+1)+"');\"><span class=\"b\">"+(i+1)+"월</span></a>";	
				}			
			} else {
				if( schyymm==(schYear+""+schMonth) ){
					sHtml = sHtml+"<a href=\"javascript:btnEvent.searchPlan('N','"+(i+1)+"');\" class=\"on\"><span>"+(i+1)+"월</span></a>";	
				} else {
					sHtml = sHtml+"<a href=\"javascript:btnEvent.searchPlan('N','"+(i+1)+"');\"><span>"+(i+1)+"월</span></a>";	
				}
			}
		}	
		$("#searchMonthList").html(sHtml);
		
	},
	pagego : function(){
		$("#trainingFeeForm").attr("action", "${pageContext.request.contextPath}/trainingFee/trainingFeeIndex.do")
		$("#trainingFeeForm").submit();
	}
}


// 계획금액 입력시 저장용 변수
function changeSpendAmount(num) {
	var text = $("#amount"+num).val().replace(/[^0-9]/gi, "");
	var commaTxt = setComma(text);
	var unCommaTxt = commaTxt.replace(/,/g, "");
	
	$("#amount"+num).val(commaTxt);
// 	$("#spendamount"+num).val(unCommaTxt);
}

function changeRentAmount(id) {
	
	var text = $("#"+id).val().replace(/[^0-9]/gi, "");
	var commaTxt = setComma(text);
	var unCommaTxt = commaTxt.replace(/,/g, "");

	$("#"+id).val(commaTxt);

	var rentDeposit = $("#rentDeposit").val(); // 보증금
	var rentAmount  = $("#rentAmount").val(); // 월 임대료
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
	
	if( !isNull($("#rentDeposit").val()) && !isNull($("#rentAmount").val()) ) {
		$("#rentDepAmount").text(payComma);
		$("#rentDepAmountTxt").val(payText);
	}
	
	if(id=="rentDeposit") {
		$("#rentDepositTxt").val(chnageNumberTxt(unCommaTxt));		
	} else {
		$("#rentAmountTxt").val(chnageNumberTxt(unCommaTxt));
	}
// 	$("#spendamount"+num).val(unCommaTxt);
}

var html = {
	clickPlanList : function(sortnum,planid,day){
		$("#trainingFeeForm > input[name='listDay']").val(day.substring(8,10));
		$("#trainingFeeForm > input[name='mode']").val("U");
		$("#trainingFeeForm > input[name='act']").val("ADD");
		$("#trainingFeeForm > input[name='sortnum']").val(sortnum);
		$("#trainingFeeForm > input[name='planid']").val(planid);
		
		html.clickPlanListEvent();
	},
	clickPlanListEvent : function() {
		$("#trainingFeeForm").attr("action", "${pageContext.request.contextPath}/trainingFee/trainingFeePlan.do")
		$("#trainingFeeForm").submit();
	},
	changeRentFM : function(obj){
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
	filesize : function(file, num){
// 		var browser = checkBrowser();
				
		if(isNull(file.value)) {
			if( isNull($("#oldfilekey"+num).val()) ) {
				$("#filekey"+num).val("");
			} else {
				$("#filekey"+num).val($("#oldfilekey"+num).val());
			}
			return;
		}
		
		var chkData = {
				"chkFile" : "jpg, jpeg, png, xls, xlsx, doc, docx, ppt, pptx, hwp, zip, gif"
		};
		
		var ext = file.value.split('.').pop().toLowerCase();
		var opts = $.extend({},chkData);
		
		if(opts.chkFile.indexOf(ext) == -1) {
			alert(opts.chkFile + ' 파일만 업로드 할수 있습니다.');
			return;
		}
		
		showLoading();
		
		$.ajaxCall({
			url : "<c:url value="/trainingFee/fileUpLoadFileKey.do"/>",
			bLoading : "N",
			success : function(data, textStatus, jqXHR) {
				$("#filekey"+num).val(data.result.fileKey);
				
				$("#fileForm"+num).ajaxForm({
				  	  url : "<c:url value="/trainingFee/fileUpLoadSpend.do"/>"
				    , method : "post"
					, async : false
					, success : function(data){
						hideLoading();
					}
					, error : function(jqXHR, textStatus, errorThrown) {
						hideLoading();
						$("#file"+num).val("");
						$("#filekey"+num).val("");
						alert("[파일업로드] 처리도중 오류가 발생하였습니다." + errorThrown );
					}
				}).submit();				
			},
			error : function(jqXHR, textStatus, errorThrown) {
				hideLoading();
				var mag = '<spring:message code="trfee.errors.filekey.false"/>';
				alert(mag);
			}
		});
		
		
	}
}

var btnEvent = {
		searchPlan : function(editYn, giveMonth) {
			$("#trainingFeeForm > input[name='givemonth']").val(giveMonth);
			$("#trainingFeeForm > input[name='editYn']").val(editYn);
			$("#trainingFeeForm > input[name='giveopen']").val(editYn);
			$("#trainingFeeForm > input[name='sortnum']").val("");
			$("#trainingFeeForm > input[name='planid']").val("");
			$("#trainingFeeForm > input[name='listDay']").val("");
			$("#trainingFeeForm > input[name='mode']").val("S");
			$("#trainingFeeForm > input[name='act']").val("");
			$("#trainingFeeForm").attr("action", "${pageContext.request.contextPath}/trainingFee/trainingFeePlan.do")
			$("#trainingFeeForm").submit();
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
			$("#trainingFeeForm > input[name='act']").val("ADD");
			$("#trainingFeeForm").attr("action", "${pageContext.request.contextPath}/trainingFee/trainingFeePlan.do")
			$("#trainingFeeForm").submit();
		},
		nomalPlanDelete : function() {
			var result = confirm("[사전계획서] 작성 내용을 삭제 하시겠습니까?");
			
			if(result){
				$("#trainingFeeForm > input[name='mode']").val("D");
				var param = {  tabType     : "nomal"  
						 };
				
				btnEvent.savePlan(param);				
			}
		},
		nomalPlanCancel : function() {
			var result = confirm("[사전계획서] 작성 내용을 취소 하시겠습니까?");
			
			if(result){
				btnEvent.searchPlan($("#trainingFeeForm > input[name='editYn']").val(), $("#trainingFeeForm > input[name='givemonth']").val());
			}
// 			$("#openTab").hide();
// 			$("#resultDiv").hide();
		},
		nomalPlanInsert : function() {
			if(!chkValidation({chkId:"#nomalSpend", chkObj:"hidden|input|select"}) ){
				return;
			}
			
			var sSpendItem = "";
			var sSpendAmount = "";
			var cnt = $("#spendItemList > li > select[name='nomalSpendItem']").length;
			
			for( var i=0; i < cnt; i++ ) {
				var objItem   = $(".spendItemList > li > select[name='nomalSpendItem']")[i];
				var objAmount = $(".spendItemList > li > input[name='spendamount']")[i];
				var spendAmount = objAmount.value;
				var unCommaTxt = spendAmount.replace(/,/g, "");
				
				if(isNull(objItem.value)) {
					alert("["+(i+1)+"] 지출항목 값이 없습니다. \n지출항목은(는) 필수 입력값입니다.");
					return;
				}
				
				if(isNull(objAmount.value)) {
					alert("["+(i+1)+"] 예상금액 값이 없습니다. \n예상금액은(는) 필수 입력값입니다.");
					return;
				}
					
				if(i==0) {
					sSpendItem   = objItem.value;
					sSpendAmount = unCommaTxt;
				} else {
					sSpendItem   = sSpendItem + "," + objItem.value;
					sSpendAmount = sSpendAmount + "," + unCommaTxt;
				}
			}
			
			var perCnt = $("#nomalPersoncount").val();
			var plancount = $("#nomalPlancount").val();
			
			var param = {  tabType     : "nomal"  
					      ,eduTitle    : $("#nomalEduTitle").val()   
					      ,eduKind     : $("#nomalEduKind option:selected").val()  
					      ,place       : $("#nomalPlace").val()  
					      ,spendDt     : $("#nomalUseYer option:selected").val() +""+ $("#nomalUseMon option:selected").val() +""+ $("#nomalUseDay option:selected").val()
					      ,personcount : perCnt.replace(/,/g, "")
					      ,plancount   : plancount.replace(/,/g, "")
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
			
			if(fromDt>toDt) {
				alert("[임대기간] 종료 년/월은 시작 년/월 보다 커야 합니다.");
				return;
			}
			
			/** 파일 체크 */
			var cnt = $("#fileup > li > form > input[type='file']").length;
			var filekey = "";
			
			for( var i=0; i < cnt; i++ ) {
				var objFile   = $("#fileup > li > form > input[name='filekey']")[i];
				
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
			
			var sRentDeposit = $("#rentDeposit").val().replace(/,/g, "");
			var sRentamount = $("#rentAmount").val().replace(/,/g, "");
			
			var result = confirm("임대차  작성 내용을 저장 하시겠습니까?");
			
			if(result){
				var param = {  tabType     : "rent"
						      ,rentDeposit : sRentDeposit 
						      ,rentamount  : sRentamount 
						      ,renttitle   : "임대차지출"
						      ,rentfrommonth : $("#rentfromyear option:selected").val() +""+ $("#rentfrommonth option:selected").val()
						      ,renttomonth   : $("#renttoyear option:selected").val() +""+ $("#renttomonth option:selected").val()  
						      ,attachfile  : filekey
						 };
				
				// 첨부파일 전송 완료 후 저장
				btnEvent.savePlan(param);
			}
			
		},
		rentCancel : function() {
			var result = confirm("[입대차] 작성 내용을 취소 하시겠습니까?");
			
			if(result){
				btnEvent.searchPlan($("#trainingFeeForm > input[name='editYn']").val(), $("#trainingFeeForm > input[name='givemonth']").val());
			}
		},
		rentDelete : function() {
			var result = confirm("[임대차] 작성 내용을 삭제 하시겠습니까?");
			
			if(result){
				
				var param = {  tabType     : "rent"  
						 , rentyear   : $("#trainingFeeForm > input[name='rentyear']").val()
						 , planid     : $("#trainingFeeForm > input[name='planid']").val()
						 , depaboNo   : $("#trainingFeeForm > input[name='depaboNo']").val()
				 };
				
				$.ajaxCall({
					url : "<c:url value="/trainingFee/rentDeleteVaildate.do"/>",
					data : param,
					success : function(data, textStatus, jqXHR) {
						if( data.result.errCode < 0 ) {
							alert(data.result.errMsg);
						} else {
							$("#trainingFeeForm > input[name='mode']").val("D");
							btnEvent.savePlan(param);			
						}					
					},
					error : function(jqXHR, textStatus, errorThrown) {
						var mag = '<spring:message code="trfee.errors.plansave.false"/>';
						alert(mag);
					}
				});				
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
			$("#trainingFeeForm > input[name='act']").val("");
			
			$.extend(defaultParam, param);
			
			$.ajaxCall({
				url : "<c:url value="${pageContext.request.contextPath}/trainingFee/saveTrainingFeePlan.do"/>",
				data : defaultParam,
				success : function(data, textStatus, jqXHR) {
					if( data.result.errCode < 1 ) {
						var mag = '<spring:message code="trfee.errors.save.false"/>';
						alert(mag);
						hideLoading();
						$("#trainingFeeForm").attr("action", "${pageContext.request.contextPath}/trainingFee/trainingFeePlan.do")
						$("#trainingFeeForm").submit();
					} else {
						if($("#trainingFeeForm > input[name='mode']").val()=="D") {
							$("#trainingFeeForm > input[name='sortnum']").val("");	
						}
						$("#trainingFeeForm > input[name='mode']").val("S");						
						alert(data.result.errMsg);
						$("#trainingFeeForm").attr("action", "${pageContext.request.contextPath}/trainingFee/trainingFeePlan.do")
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
			var result = confirm("사전 계획서를 수정 하시겠습니다.\n\n수정 완료 후 계획서 완료를 하셔야 적용이 됩니다.");
			
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
			$("#trainingFeeForm").attr("action", "${pageContext.request.contextPath}/trainingFee/trainingFeeIndex.do")
			$("#trainingFeeForm").submit();
		},
		resultSave : function(defaultParam, msgText) {
			$.ajaxCall({
				url : "<c:url value="${pageContext.request.contextPath}/trainingFee/saveTrainingFeePlanConfirm.do"/>",
				data : defaultParam,
				success : function(data, textStatus, jqXHR) {
					if( data.result.errCode < 1 ) {
						alert("처리도중 오류가 발생하였습니다.");
					} else {
						$("#trainingFeeForm > input[name='mode']").val("S");
						alert(msgText);
						$("#trainingFeeForm").attr("action", "${pageContext.request.contextPath}/trainingFee/trainingFeePlan.do")
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

var tabEvent = {
	groupPlan : function() {
		$('#groupPlanClass').removeClass('logTabSection').addClass('logTabSection on');
		$('#groupRentClass').removeClass('logTabSection on').addClass('logTabSection');
		//스크롤 사이즈
		setTimeout(function(){ abnkorea_resize(); }, 500);
	},
	groupRent : function() {
		$('#groupPlanClass').removeClass('logTabSection on').addClass('logTabSection');
		$('#groupRentClass').removeClass('logTabSection').addClass('logTabSection on');
		//스크롤 사이즈
		setTimeout(function(){ abnkorea_resize(); }, 500);
	},
	listClick : function() {
		$("#openTab").show();
		$('#groupPlanClass').hide();
		$('#groupRentClass').hide();
		
		if( $("#trainingFeeForm > input[name='editYn']").val() == "N" ) {
			
			if( $("#trainingFeeForm > input[name='sortnum']").val()=="0" ){
				// rent 모드
				$('#groupPlanClass').show();
				$('#groupRentClass').show();
				$("#groupPlan").hide();
				$("#groupRent").show();
				$('#groupPlanClass').removeClass('logTabSection on').addClass('logTabSection');
				$('#groupRentClass').removeClass('logTabSection').addClass('logTabSection on');
				
				if( $("#trainingFeeForm > input[name='editYn']").val() == "Y" ) {
					// 수정모드로
					$("#groupRent").show();
					$("#groupRentS").hide();
					
					$("#btnRentCancel").hide();
					$("#btnRentInsert").show();
				} else {
					// 조회 모드
					$("#groupRent").hide();
					$("#groupRentS").show();
					
					$("#btnRentCancel").hide();
					$("#btnRentInsert").hide();
				}
			} else {
				// plan 모드
				$('#groupPlanClass').show();
				$('#groupRentClass').show();
				
				$("#groupPlan").show();
				$("#groupRent").hide();
				$('#groupPlanClass').removeClass('logTabSection').addClass('logTabSection on');
				$('#groupRentClass').removeClass('logTabSection on').addClass('logTabSection');
				
				// 리스트 클릭 오픈시 발생
				if( $("#trainingFeeForm > input[name='editYn']").val() == "Y" ) {
					// 수정모드로
					$("#groupPlan").show();
					$("#groupPlanS").hide();	
					
					$("#btnPlanDelete").show();
					$("#btnPlanCancel").hide();
					$("#btnPlanInsert").show();
					
					tabEvent.dayList();
				} else {
					// 조회 모드
					$("#groupPlan").hide();
					$("#groupPlanS").show();
					
					$("#btnPlanDelete").hide();
					$("#btnPlanCancel").hide();
					$("#btnPlanInsert").hide();
				}
			}
		} else {
		
			if( $("#trainingFeeForm > input[name='planstatus']").val() == "Y" ) {
				if( $("#trainingFeeForm > input[name='sortnum']").val()=="0" ){
					// rent 모드
					$("#groupPlan").hide();
					$("#groupRent").show();
					$('#groupPlanClass').removeClass('logTabSection on').addClass('logTabSection');
					$('#groupRentClass').removeClass('logTabSection').addClass('logTabSection on');
					// 조회 모드
					$("#groupRent").hide();
					$("#groupRentS").show();
					
					$("#btnRentCancel").hide();
					$("#btnRentInsert").hide();
				} else {
					// plan 모드
					$("#groupPlan").show();
					$("#groupRent").hide();
					$('#groupPlanClass').removeClass('logTabSection').addClass('logTabSection on');
					$('#groupRentClass').removeClass('logTabSection on').addClass('logTabSection');
					// 조회 모드
					$("#groupPlan").hide();
					$("#groupPlanS").show();
					
					$("#btnPlanDelete").hide();
					$("#btnPlanCancel").hide();
					$("#btnPlanInsert").hide();
				}
			} else {
				
				if( $("#trainingFeeForm > input[name='sortnum']").val()=="0" ){
					// rent 모드
					$('#groupPlanClass').show();
					$('#groupRentClass').show();
					$("#groupPlan").hide();
					$("#groupRent").show();
					$('#groupPlanClass').removeClass('logTabSection on').addClass('logTabSection');
					$('#groupRentClass').removeClass('logTabSection').addClass('logTabSection on');
					
					if( $("#trainingFeeForm > input[name='editYn']").val() == "Y" ) {
						// 수정모드로
						$("#groupRent").show();
						$("#groupRentS").hide();
						
						$("#btnRentCancel").hide();
						$("#btnRentInsert").show();
					} else {
						// 조회 모드
						$("#groupRent").hide();
						$("#groupRentS").show();
						
						$("#btnRentCancel").hide();
						$("#btnRentInsert").hide();
					}
				} else {
					// plan 모드
	// 				$("#planTab1").attr("disabled", false);
					$('#groupPlanClass').show();
					$('#groupRentClass').show();
					
					$("#groupPlan").show();
					$("#groupRent").hide();
					$('#groupPlanClass').removeClass('logTabSection').addClass('logTabSection on');
					$('#groupRentClass').removeClass('logTabSection on').addClass('logTabSection');
					
					// 리스트 클릭 오픈시 발생
					if( $("#trainingFeeForm > input[name='editYn']").val() == "Y" ) {
						// 수정모드로
						$("#groupPlan").show();
						$("#groupPlanS").hide();	
						
						$("#btnPlanDelete").show();
						$("#btnPlanCancel").hide();
						$("#btnPlanInsert").show();
						
						tabEvent.dayList();
					} else {
						// 조회 모드
						$("#groupPlan").hide();
						$("#groupPlanS").show();
						
						$("#btnPlanDelete").hide();
						$("#btnPlanCancel").hide();
						$("#btnPlanInsert").hide();
					}
				}
			}
		}
		//스크롤 사이즈
		setTimeout(function(){ abnkorea_resize(); }, 500);
	},
	dayList : function() {
		var lastDay = "";
		var spendate = $("#trainingFeeForm > input[name='spenddate']").val();
		
		if( isNull(spendate) ) {
			var month = isNvl($("#nomalUseMon option:selected").val(), "${scrData.givemonth}");
			var year = isNvl($("#nomalUseYer option:selected").val(), "${scrData.giveyear }");
			lastDay = LastDayOfMonth(year, month);
		} else {
			lastDay = LastDayOfMonth(spendate.substring(0,4), spendate.substring(5,7));
		}
		
		setSelectMonthDay(lastDay, "nomalUseDay", "01" );
		
		if( !isNull(spendate) ) {
			$("#nomalUseYer").val(spendate.substring(0,4));
			$("#nomalUseMon").val(spendate.substring(5,7));
			$("#nomalUseDay").val(spendate.substring(8));
		}
		
	}
}

var page = {
		init : function() {
			$("#openTab").hide();
			
			if( $("#trainingFeeForm > input[name='editYn']").val() == "Y" ) {
			} else {
			}

			setTimeout(function(){ abnkorea_resize(); }, 500);
		},
		init2 : function() {
			$("#openTab").hide();
			
			if( $("#trainingFeeForm > input[name='editYn']").val() == "Y" ) {
			} else {
			}

			setTimeout(function(){ abnkorea_resize(); }, 500);
		},
		saveInit : function() {
			$("#openTab").hide();
			
			if( $("#trainingFeeForm > input[name='planstatus']").val() == "Y" ) {
			} else {
			}
			
			setTimeout(function(){ abnkorea_resize(); }, 500);
		},
		addPlanInit : function() {
			$("#groupPlanClass").show();
			$("#groupRentClass").show();
			$("#openTab").show();
			
			$("#groupPlan").show();
			$("#groupPlanS").hide();
			$("#groupRent").hide();
			$("#groupRentS").hide();
			
			$("#btnPlanDelete").hide();
			$("#btnPlanCancel").show();
			$("#btnPlanInsert").show();
			
			$("#btnRentCancel").hide();
			$("#btnRentInsert").hide();
			
			LastDayOfMonth($("#nomalUseYer option:selected").val(), $("#nomalUseMon option:selected").val());
			setSelectMonthDay(LastDayOfMonth($("#nomalUseYer option:selected").val(), $("#nomalUseMon option:selected").val()), "nomalUseDay", "01");
			
			setTimeout(function(){ abnkorea_resize(); }, 500);
		}
}
</script>
</head>
<body>

<!-- content area | ### academy IFRAME Start ### -->
<section id="pbContent" class="bizroom">
	<div class="hWrap">
		<h1>
			<img src="/_ui/desktop/images/academy/h1_w020400410.gif" alt="교육비 사전계획등록/조회">
		</h1>
		<p>
			<img src="/_ui/desktop/images/academy/txt_w020400410.gif" alt="교육비 사용에 대한 사전계획을 등록하고 조회하실 수 있습니다.">
		</p>
	</div>
	<form id="trainingFeeForm" name="trainingFeeForm" method="post">
		<input type="hidden" name="fiscalyear"  value="${scrData.fiscalyear }" />
		<input type="hidden" name="rentyear"    value="${scrData.rentyear }"   />
		<input type="hidden" name="giveyear"    value="${scrData.giveyear }"   />
		<input type="hidden" name="givemonth"   value="${scrData.givemonth }"  />
		<input type="hidden" name="okdata"      value="${scrData.okdata }"     />
		<input type="hidden" name="depaboNo"    value="${scrData.depaboNo }"   />
		<input type="hidden" name="editYn"      value="${scrData.editYn }"     />
		<input type="hidden" name="mode"        value="${scrData.mode }"       />
		<input type="hidden" name="giveopen"    value="${scrData.giveopen }"   />
		<input type="hidden" name="targettype"  value="${scrData.targettype }" />
		<input type="hidden" name="trfee"       value="${scrData.trfee }"      />
		<input type="hidden" name="groupCode"   value="${scrData.groupCode }"  />
		<input type="hidden" name="procType"    value="${scrData.procType }"   />
		<input type="hidden" name="sortnum"     value="${scrData.sortnum }"    />
		<input type="hidden" name="planid"      value="${scrData.planid }"     />
		<input type="hidden" name="listDay"     value="${scrData.listDay }"    />
		<input type="hidden" name="spendstatus"  value="${scrData.spendstatus }" />
		<input type="hidden" name="planstatus"  value="${scrData.planstatus }" />
		<input type="hidden" name="rentstatus"  value="${scrData.rentstatus }" />
		<input type="hidden" name="act"  value="${scrData.act }" />
		<input type="hidden" name="spenddate"  value="${dataPlan.spenddate }" />
	</form>
	<c:set var="grouplistcount" value="0"></c:set>
	<c:set var="personlistcount" value="0"></c:set>
	<c:set var="updateYN" value="Y"></c:set>
	<!-- 교육비 사전계획등록/조회 -->
	<div id="trainingFee">

		<div class="monthSelectWrap">
			<select title="년도" id="searchYear" onchange="btnEvent.searchYear(this);">
				<ct:code type="option" majorCd="schYear" selectAll="false" selected="${scrData.giveyear }"  />
			</select>
			<div id="searchMonthList">
			</div>
		</div>

		<div class="tblTopTitleBox">
			<span class="tit">
				<c:if test="${scrData.procType eq 'person' }">
				개인
				</c:if>
				<c:if test="${scrData.procType eq 'group' }">
				그룹
				</c:if>
				교육비 <strong id="trfee" class="won"></strong> 원
				<c:if test="${scrData.trfeetype eq 'NOTFOUND' }">
					예상
				</c:if>
			</span> <a href="javascript:reload.pagego();" class="btnCont"><span>교육비관리 목록</span></a>
		</div>

		<table class="tblList lineLeft">
			<caption>교육비 등록 일자, 교육종류, 교육, 횟수, 예상금액, 비율 테이블</caption>
			<colgroup>
				<col style="width: 7%">
				<col style="width: 16%">
				<col style="width: 10%">
				<col style="width: auto">
				<col style="width: 9%">
				<col style="width: 13%">
				<col style="width: 9%">
			</colgroup>
			<thead>
				<tr>
					<th scope="col">번호</th>
					<th scope="col">일자</th>
					<th scope="col">교육종류</th>
					<th scope="col">교육명</th>
					<th scope="col">횟수<span class="normal">(회)</span></th>
					<th scope="col">예상금액<span class="normal">(원)</span></th>
					<th scope="col">비율<span class="normal">(%)</span></th>
				</tr>
			</thead>
			<c:if test="${!empty planList}">
				<tbody>
				<c:forEach var="items" items="${planList}" varStatus="status">
					<c:if test="${items.sortnum eq 9999 }">
						<c:set var="listcount" value="${status.count}"></c:set>
						<c:set var="totalplancount" value="${items.plancount}"></c:set>
						<c:set var="totalspendamount" value="${items.spendamount}"></c:set>
						<c:set var="totalrate" value="${items.rate}"></c:set>
					</c:if>
					<c:if test="${items.sortnum ne 9999 }">
						<td>${status.index + 1}</td>
						<td>${items.spenddt }</td>
						<td>${items.edukindname}</td>
						<td class="textL">
								<c:if test="${items.plantype eq 'group' }">(그룹)<c:set var="grouplistcount" value="1"></c:set></c:if>
								<c:if test="${items.plantype eq 'person' }">(개인)<c:set var="personlistcount" value="1"></c:set></c:if>
						<a href="javascript:html.clickPlanList('${items.sortnum}','${items.planid}','${items.spenddt }');">${items.edutitle}<c:if test="${items.sortnum eq 0 }">-${items.planid}</c:if></a></td>
						<td>${items.plancount}</td>
						<td>${items.spendamount}</td>
						<td>${items.rate}</td>
					</c:if>
					</tr>
				</c:forEach>
				</tbody>
<%-- 				<c:if test="${scrData.planstatus eq 'Y'}"> --%>
				<tfoot>
					<tr>
						<td>계</td>
						<td></td>
						<td></td>
						<td></td>
						<td>${totalplancount}</td>
						<td>${totalspendamount}</td>
						<td>${totalrate}</td>
					</tr>
				</tfoot>
<%-- 				</c:if> --%>
			</c:if>
			<c:if test="${empty planList}">
				<tbody>
					<tr><td colspan="7">사전 계획을 등록해 주세요.</td></tr>
				</tbody>
			</c:if>
		</table>
		<div class="btnWrap">
			<ul class="listWarning">
				<li>※ 사전계획 등록은 '교육비 제출' 전까지 수정이 가능합니다.<br />교육내용 수정을 원하시면,
					교육명을 선택하여 수정해 주세요.
				</li>
			</ul>
			<c:if test="${scrData.editYn eq 'Y' and scrData.planstatus eq 'N' and scrData.processstatus ne 'Y' and scrData.editYn eq 'Y' }">
			<span class="btnR"><a href="javascript:btnEvent.addPlan();" class="btnPlanBS">+계획추가</a></span>
			</c:if>
		</div>
		
		<c:if test="${scrData.act eq 'ADD'}">
		<div class="tabWrapLogical" id="openTab" >
			<section class="logTabSection on" id="groupPlanClass" style="display:none">
				<h2 class="tab01">
					<a href="javascript:;" onclick="javascript:tabEvent.groupPlan();">일반지출</a>
				</h2>
				
				<c:if test="${scrData.planstatus eq 'N' and scrData.editYn eq 'Y'}">
				<!-- 입력 모드 -->
				<div class="logTabContent" id="groupPlan">
					<c:if test="${!empty dataPlan}">
						<c:if test="${scrData.procType ne dataPlan.plantype}">
							<c:set var="updateYN" value="N"></c:set>
						</c:if>
					</c:if>
					<table class="tblInput" id="nomalSpend">
						<caption>부가정보 입력</caption>
						<colgroup>
							<col style="width: 18%">
							<col style="width: auto">
							<col style="width: 18%">
							<col style="width: auto">
						</colgroup>
						<tbody>
							<tr>
								<th scope="row">교육명</th>
								<td colspan="3"><input type="text" title="교육명" class="inputWFull requd" id="nomalEduTitle" name="nomalEduTitle" value="<c:if test="${!empty dataPlan}">${dataPlan.edutitle }</c:if>" maxlength="50" oninput="maxLengthCheck(this)"/></td>
							</tr>
							<tr>
								<th scope="row">교육종류</th>
								<td>
									<select id="nomalEduKind" name="nomalEduKind" title="교육종류" class="requd">
										<option value="">교육종류 선택</option>
										<c:if test="${!empty dataPlan}">
											<ct:code type="option" majorCd="edukind" selectAll="false" selected="${dataPlan.edukind }" />
										</c:if>
										<c:if test="${empty dataPlan}">
											<ct:code type="option" majorCd="edukind" selectAll="false" />
										</c:if>
									</select>
								</td>
								<th scope="row">교육일자</th>
								<td>
									<select title="교육일자 년 선택" id="nomalUseYer" name="useYer" class="requd">
										<option value="${scrData.giveyear }">${scrData.giveyear }년</option>
									</select> 
									<select title="교육일자 월 선택" class="mglSs" id="nomalUseMon" name="useMon" class="requd" onchange="javascript:tabEvent.dayList();">
										<c:forEach var="planUseMon" items="${planUseMon}" varStatus="status">
											<c:if test="${!empty dataPlan}">
												<option value="${planUseMon.usemon }" <c:if test="${planUseMon.usemon eq dataPlan.usemon}"> selected="selected"</c:if>>${planUseMon.usemon }월</option>
											</c:if>
											<c:if test="${empty dataPlan}">
												<option value="${planUseMon.usemon }" <c:if test="${planUseMon.usemon eq scrData.givemonth}"> selected="selected"</c:if>>${planUseMon.usemon }월</option>
											</c:if>
										</c:forEach>
									</select>
									<select title="교육일자 일 선택" class="mglSs" id="nomalUseDay" name="useDay" class="requd">
									</select>
								</td>
							</tr>
							<tr>
								<th scope="row">예상인원</th>
								<td><input type="text" title="예상인원" id="nomalPersoncount" name="nomalPersoncount" class="onlyNum requd isNum" maxlength="5" oninput="maxNumberLength(this)" value="<c:if test="${!empty dataPlan}">${dataPlan.personcount }</c:if>" /> 명</td>
								<th scope="row">횟수(회)</th>
								<td><input type="tel" title="횟수(회)" id="nomalPlancount" name="nomalPlancount" class="onlyNum requd isNum" maxlength="3" oninput="maxNumberLength(this)" value="<c:if test="${!empty dataPlan}">${dataPlan.plancount }</c:if>" /> 회</td>
							</tr>
							<tr>
								<th scope="row">지출항목</th>
								<td colspan="3">
									<div class="spendItemWrap">
										<ul class="spendItemList" id="spendItemList">
											<c:if test="${!empty dataPlan}">
												<c:forEach var="items" items="${dataPlanItem}" varStatus="status">
													<li>
														<select id="spendItem${status.index }" title="지출항목 선택" name="nomalSpendItem">
															<option value="">지출항목 선택</option>
															<ct:code type="option" majorCd="spenditem" selectAll="false" selected="${items.spenditem }" />
														</select>
														<label for="num3" class="mgLabel">예상금액</label>
														<input type="tel" id="amount${status.index }" name="spendamount" class="requd isNum" title="예상금액" maxlength="15" oninput="maxNumberLength(this)" onkeyup="changeSpendAmount('${status.index }')" value="${items.spendamountcomma }" />
														<c:if test="${status.index eq 0 }">
															<a href="javascript:;" class="mgLabel btnTbl btnGs spenditemAdd">추가</a>
														</c:if>
														<c:if test="${status.index ne 0 }">
															<a href="javascript:javascript.spendItemDelete(this);" class="mgLabel btnTbl btnItemDelete"><span>삭제</span></a>
														</c:if>
													</li>
												</c:forEach>
											</c:if>
											<c:if test="${empty dataPlan}">
											<li>
												<select id="spendItem0" title="지출항목 선택" name="nomalSpendItem">
													<option value="">지출항목 선택</option>
													<ct:code type="option" majorCd="spenditem" selectAll="false" />
												</select>
												<label for="num3" class="mgLabel">예상금액</label>
												<input type="tel" id="amount0" name="spendamount" title="예상금액" class="requd isNum" maxlength="15" oninput="maxNumberLength(this)" onkeyup="changeSpendAmount('0')" />
												<a href="javascript:;" class="mgLabel btnTbl btnGs spenditemAdd">추가</a>
											</li>
											</c:if>
										</ul>
									</div>
								</td>
							</tr>
							<tr>
								<th scope="row">교육장소(선택)</th>
								<td colspan="3">
									<input type="text" title="교육장소" class="inputWFull" id="nomalPlace" name="nomalPlace" value="<c:if test="${!empty dataPlan}">${dataPlan.place }</c:if>" maxlength="50" oninput="maxLengthCheck(this)" />
								</td>
							</tr>
							<tr>
								<th scope="row">교육설명(선택)</th>
								<td colspan="3"><input type="text" title="교육장소" class="inputWFull" id="nomalEduDesc" name="nomalEduDesc" value="<c:if test="${!empty dataPlan}">${dataPlan.edudesc }</c:if>" maxlength="50" oninput="maxLengthCheck(this)"/></td>
							</tr>
						</tbody>
					</table>
					<div class="btnWrapC">
						<a href="javascript:;" class="btnBasicGS" id="btnPlanCancel" onclick="javascript:btnEvent.nomalPlanCancel();" >취소</a> 
						<c:if test="${scrData.act eq 'ADD' and scrData.mode eq 'U'}">
							<c:if test="${updateYN eq 'Y'}">
							<a href="javascript:;" class="btnBasicGS" id="btnPlanDelete" onclick="javascript:btnEvent.nomalPlanDelete();" >삭제</a>
							</c:if>
						</c:if> 
						<c:if test="${updateYN eq 'Y'}">
						<a href="javascript:;" class="btnBasicBS" id="btnPlanInsert" onclick="javascript:btnEvent.nomalPlanInsert();" >저장</a>
						</c:if>
					</div>
				</div>
				<!-- 입력 모드 end -->
				</c:if>
				<c:if test="${scrData.planstatus eq 'Y'}">
				<!-- 조회 모드 -->
				<div class="logTabContent" id="groupPlanS">

					<table class="tblInput">
						<caption>부가정보 입력</caption>
						<colgroup>
							<col style="width: 18%">
							<col style="width: auto">
							<col style="width: 18%">
							<col style="width: auto">
						</colgroup>
						<tbody>
							<tr>
								<th scope="row">교육명</th>
								<td colspan="3"><span><c:if test="${!empty dataPlan}">${dataPlan.edutitle }</c:if></span></td>
							</tr>
							<tr>
								<th scope="row">교육종류</th>
								<td><span><c:if test="${!empty dataPlan}">${dataPlan.edukind }</c:if></span></td>
								<th scope="row">교육일자</th>
								<td><span><c:if test="${!empty dataPlan}">${dataPlan.spenddate }</c:if></span></td>
							</tr>
							<tr>
								<th scope="row">예상인원</th>
								<td><span><c:if test="${!empty dataPlan}">${dataPlan.personcount }</c:if></span>명</td>
								<th scope="row">횟수(회)</th>
								<td><span><c:if test="${!empty dataPlan}">${dataPlan.plancount }</c:if></span> 회</td>
							</tr>
							<tr>
								<th scope="row">지출항목</th>
								<td colspan="3">
									<div class="spendItemWrap">
										<ul class="spendItemList">
											<c:if test="${!empty dataPlan}">
												<c:forEach var="items" items="${dataPlanItem}" varStatus="status">
													<li>
														<label class="mgLabel">지출항목</label><span>${items.spenditemname }</span>
														<label for="num3" class="mgLabel">예상금액</label>
														<span>${items.spendamountcomma }</span>
													</li>
												</c:forEach>
											</c:if>
										</ul>
									</div>
								</td>
							</tr>
							<tr>
								<th scope="row">교육장소(선택)</th>
								<td colspan="3"><span><c:if test="${!empty dataPlan}">${dataPlan.place }</c:if></span></td>
							</tr>
							<tr>
								<th scope="row">교육설명(선택)</th>
								<td colspan="3"><span><c:if test="${!empty dataPlan}">${dataPlan.edudesc }</c:if></span></td>
							</tr>
						</tbody>
					</table>
				</div>
				<!-- 조회 모드 end -->
				</c:if>
				
			</section>
			
			<section class="logTabSection" id="groupRentClass" style="display:none;">
				<h2 class="tab02">
					<a href="javascript:;" onclick="javascript:tabEvent.groupRent();">임대차지출</a>
				</h2>
				<c:if test="${scrData.planstatus eq 'N' and scrData.editYn eq 'Y'}">
				<!-- 입력모드 -->
				<div class="logTabContent" id="groupRent">
					<c:if test="${!empty dataUpdate}">
						<c:if test="${scrData.procType ne dataUpdate.renttype}">
							<c:set var="updateYN" value="N"></c:set>
						</c:if>
					</c:if>
					<p class="listWarning pdNone">
						※ 임대차 증빙은 회계연도 단위로 증빙이 필요합니다.<br /> 현재 등록하는 임대차 증빙은 <span id="fiscalyear">${scrData.fiscalyear}</span>년 <span id="fiscalmonth">8</span>월 까지
						일괄 적용됩니다.<br /> 등록된 임대차 계약 사항은 수정이 불가하므로 정확히 입력해 주세요.
					</p>

					<!-- @edit 20160629 레이블문구 수정 -->
					<p class="mgbM lb_txtin">
						<c:if test="${!empty dataUpdate}">
							<input type="checkbox" id="chkRent" title="임대차 동의여부" checked />
						</c:if>
						<c:if test="${empty dataUpdate}">
							<input type="checkbox" id="chkRent" title="임대차 동의여부" />
						</c:if> 
						<label for="chkRent" class="ftw"> 
							임대차 계약서 등록에 대해 임대인과 사전 협의 하였으며, 임대인의 개인정보
							(이름, 주민번호, 전화(휴대)번호,<br /> 주소 등) 를 가린 사진을 등록하겠습니다.
						</label>
					</p>
					<!-- // @edit 20160629 레이블문구 수정 -->
					<table class="tblInput" id="trainingfeerent">
						<caption>부가정보 입력</caption>
						<colgroup>
							<col style="width: 18%">
							<col style="width: auto">
						</colgroup>
						<tbody>
<!-- 							<tr> -->
<!-- 								<th scope="row">계약명</th> -->
<!-- 								<td> -->
<%-- 									<input type="text" size="50" title="계약명" name="renttitle" id="renttitle" value="<c:if test="${!empty dataUpdate}">${dataUpdate.renttitle }</c:if>" class="requd" /> --%>
<!-- 								</td> -->
<!-- 							</tr> -->
							<tr>
								<th scope="row">임대기간</th>
								<td>
									<select title="임대기간 년 선택" name="rentfromyear" id="rentfromyear" onchange="javascript:html.changeRentFM(this);" class="requd" disabled="disabled" >
										<c:forEach var="rentYear" items="${rentYear}" varStatus="status">
											<c:if test="${!empty dataUpdate}">
												<option value="${rentYear.fiscalyear }" <c:if test="${dataUpdate.rentfromyy eq rentYear.fiscalyear}">selected="selected"</c:if>>${rentYear.fiscalyear }년</option>
											</c:if>
											<c:if test="${empty dataUpdate}">
												<option value="${rentYear.fiscalyear }" <c:if test="${scrData.fiscalyear ne rentYear.fiscalyear}">selected="selected"</c:if>>${rentYear.fiscalyear }년</option>
											</c:if>
										</c:forEach>
									</select>
									
									<select title="임대기간 월 선택" class="mglSs" name="rentfrommonth" id="rentfrommonth" class="requd" disabled="disabled" >
										<c:forEach var="rentMonth" items="${rentMonth}" varStatus="status">
											<c:if test="${!empty dataUpdate}">
												<option value="${rentMonth.mm }" <c:if test="${dataUpdate.rentfrommm eq rentMonth.mm}">selected="selected"</c:if>>${rentMonth.mm }월</option>
											</c:if>
											<c:if test="${empty dataUpdate}">
												<option value="${rentMonth.mm }" <c:if test="${scrData.givemonth eq rentMonth.mm}">selected="selected"</c:if>>${rentMonth.mm }월</option>												
											</c:if>
										</c:forEach>
									</select> ~ 
									<select title="임대기간 년 선택" name="renttoyear" id="renttoyear" onchange="javascript:html.changeRentFMTO(this);" class="requd" >
										<c:forEach var="rentYear" items="${rentYear}" varStatus="status">
											<c:if test="${!empty dataUpdate}">
												<option value="${rentYear.fiscalyear }" <c:if test="${dataUpdate.renttoyy eq rentYear.fiscalyear}">selected="selected"</c:if>>${rentYear.fiscalyear }년</option>
											</c:if>
											<c:if test="${empty dataUpdate}">
												<option value="${rentYear.fiscalyear }" <c:if test="${scrData.fiscalyear eq rentYear.fiscalyear}">selected="selected"</c:if>>${rentYear.fiscalyear }년</option>
											</c:if>
										</c:forEach>
									</select> 
									<select title="임대기간 월 선택" class="mglSs" name="renttomonth" id="renttomonth" class="requd" >
										<c:forEach var="rentMaxMonth" items="${rentMaxMonth}" varStatus="status">
											<c:if test="${!empty dataUpdate}">
												<option value="${rentMaxMonth.mm }" <c:if test="${dataUpdate.renttomm eq rentMaxMonth.mm}">selected="selected"</c:if>>${rentMaxMonth.mm }월</option>
											</c:if>
											<c:if test="${empty dataUpdate}">
												<option value="${rentMaxMonth.mm }">${rentMaxMonth.mm }월</option>
											</c:if>
										</c:forEach>
									</select>
								</td>
							</tr>
							<tr>
								<th scope="row">보증금</th>
								<td>
									<input type="text" size="15" title="보증금" name="rentDeposit" id="rentDeposit" onkeyup="changeRentAmount('rentDeposit')" value="<c:if test="${!empty dataUpdate}">${dataUpdate.rentdepositcomma }</c:if>" class="requd isNum" maxlength="15" oninput="maxLengthCheck(this)" /> 원 
									<input type="text" size="15" disabled="disabled" class="mglS" id="rentDepositTxt" value="<c:if test="${!empty dataUpdate}">${dataUpdate.rentdeposittxt }</c:if>" /> 
									<span class="mglS">※ 보증금은 년 5% 대출 이율로 월할 계산됩니다.</span>
								</td>
							</tr>
							<tr>
								<th scope="row">월임대료</th>
								<td>
									<input type="text" size="15" title="월임대료" name="rentAmount" id="rentAmount" onkeyup="changeRentAmount('rentAmount')" value="<c:if test="${!empty dataUpdate}">${dataUpdate.rentamountcomma }</c:if>" class="requd isNum" maxlength="15" oninput="maxLengthCheck(this)" /> 원 
									<input type="text" size="15" disabled="disabled" class="mglS" id="rentAmountTxt" value="<c:if test="${!empty dataUpdate}">${dataUpdate.rentamounttxt }</c:if>" />
								</td>
							</tr>
							<tr>
								<th scope="row">월지원금</th>
								<td>
									보증금이자(5%/12)+월임대료 = <span id="rentDepAmount" > <c:if test="${!empty dataUpdate}">${dataUpdate.rentdepositcomma12 }</c:if></span>
									<input type="text" size="30" disabled="disabled" class="mglS" id="rentDepAmountTxt" value="<c:if test="${!empty dataUpdate}">${dataUpdate.rentdeposit12txt }</c:if>" />
								</td>
							</tr>
							<tr>
								<th scope="row">임대차계약서</th>
								<td>
									<div class="fileUploadWrap">
										<ul class="fileup" id="fileup">
											<c:if test="${empty dataRentFile}">
											<li>
												<form id="fileForm0" method="POST" enctype="multipart/form-data">
													<input type="file" id="file0" class="file" name="file" title="첨부파일" onChange="javascript:html.filesize(this,0);" />
													<input type="hidden" name="filekey" id="filekey0" title="파일번호" />
													<input type="hidden" name="oldfilekey" id="oldfilekey0" title="파일번호" />
													<a href="javascript:;" class="mgLabel btnTbl btnGs btnFileItemAdd" title="파일추가">파일추가</a>
												</form>
											</li>
											</c:if>
											<c:if test="${!empty dataRentFile}">
												<c:forEach var="items" items="${dataRentFile }" varStatus="status">
													<li>
														<form id="fileForm${status.index }" method="POST" enctype="multipart/form-data">
															<input type="file" id="file${status.index }" class="file" name="file" title="첨부파일" onChange="javascript:html.filesize(this,${status.index });" />
															<input type="hidden" name="filekey" id="filekey${status.index }" title="파일번호" value="${items.filekey }" />
															<input type="hidden" name="oldfilekey" id="oldfilekey${status.index }" title="파일번호" value="${items.filekey }" />
															<c:if test="${updateYN eq 'Y'}"><a href="javascript:;" class="mgLabel btnTbl btnGs btnFileItemAdd" title="파일추가">파일추가</a></c:if>
															<div style="border-top:1px dotted #D5D5D5;width:98%;">등록 파일 : <a href="/trfee/common/file/fileDownload.do?fileKey=${items.filekey }&uploadSeq=${items.uploadseq }" >${items.realfilename }</a></div>
														</form>
													</li>
												</c:forEach>
											</c:if>
										</ul>
									</div>
								</td>
							</tr>
						</tbody>
					</table>
					<div class="btnWrapC">
						<a href="javascript:;" class="btnBasicGS" id="btnRentCancel" onclick="javascript:btnEvent.rentCancel()" >취소</a> 
						<c:if test="${scrData.spendconfirmflag ne 'Y'}">
							<c:if test="${updateYN eq 'Y'}">
							<a href="javascript:;" class="btnBasicGS" id="btnRentDelete" onclick="javascript:btnEvent.rentDelete()" >삭제</a>
							<a href="javascript:;" class="btnBasicBS" id="btnRentInsert" onclick="javascript:btnEvent.rentInsert()" >저장</a>
							</c:if>
						</c:if>
					</div>

				</div>
				<!-- 입력모드 end -->
				</c:if>
				<c:if test="${scrData.planstatus eq 'Y'}">
				<!-- 조회모드 -->
				<div class="logTabContent" id="groupRentS">

					<p class="listWarning pdNone">
						※ 임대차 증빙은 회계연도 단위로 증빙이 필요합니다.<br /> 현재 등록하는 임대차 증빙은 <span id="fiscalyear">${scrData.fiscalyear}</span>년 <span id="fiscalmonth">8</span>월 까지
						일괄 적용됩니다.<br /> 등록된 임대차 계약 사항은 수정이 불가하므로 정확히 입력해 주세요.
					</p>

					<!-- @edit 20160629 레이블문구 수정 -->
					<p class="mgbM lb_txtin">
						<c:if test="${!empty dataUpdate}">
							<input type="checkbox" title="임대차 동의여부" checked disabled="disabled"  />
						</c:if>
						<label for="chkRent" class="ftw"> 
							임대차 계약서 등록에 대해 임대인과 사전 협의 하였으며, 임대인의 개인정보
							(이름, 주민번호, 전화(휴대)번호,<br /> 주소 등) 를 가린 사진을 등록하겠습니다.
						</label>
					</p>
					<!-- // @edit 20160629 레이블문구 수정 -->
					<table class="tblInput">
						<caption>부가정보 입력</caption>
						<colgroup>
							<col style="width: 18%">
							<col style="width: auto">
						</colgroup>
						<tbody>
							<tr>
								<th scope="row">임대기간</th>
								<td><span><c:if test="${!empty dataUpdate}">${dataUpdate.rentfromyy}년 ${dataUpdate.rentfrommm}월 ~ ${dataUpdate.renttoyy}년 ${dataUpdate.renttomm}월</c:if></span></td>
							</tr>
							<tr>
								<th scope="row">보증금</th>
								<td><span><c:if test="${!empty dataUpdate}">${dataUpdate.rentdepositcomma }</c:if></span> 원<span class="mglS">※ 보증금은 년 5% 대출 이율로 월할 계산됩니다.</span>
								</td>
							</tr>
							<tr>
								<th scope="row">월임대료</th>
								<td><span><c:if test="${!empty dataUpdate}">${dataUpdate.rentamountcomma }</c:if></span> 원 
								<input type="text" size="15" value="<c:if test="${!empty dataUpdate}">${dataUpdate.rentamounttxt }</c:if>" disabled="disabled" class="mglS" id="rentAmountTxt" />
								</td>
							</tr>
							<tr>
								<th scope="row">월지원금</th>
								<td>보증금이자(5%/12)+월임대료 = <span><c:if test="${!empty dataUpdate}">${dataUpdate.rentdepositcomma12 }</c:if></span> 원
								<input type="text" size="30" value="<c:if test="${!empty dataUpdate}">${dataUpdate.rentdeposit12txt }</c:if>" disabled="disabled" class="mglS" />
								</td>
							</tr>
							<tr>
								<th scope="row">임대차계약서</th>
								<td>
									<c:forEach var="items" items="${dataRentFile}" varStatus="status">
									<div style="width:98%;">등록 파일 : <a href="/trfee/common/file/fileDownload.do?fileKey=${items.filekey }&uploadSeq=${items.uploadseq }" >${items.realfilename }</a></div>
									</c:forEach>
								</td>
							</tr>
						</tbody>
					</table>
				</div>
				<!-- 조회모드 end -->
				</c:if>
			</section>
		</div>
		</c:if>
		
		<c:if test="${listcount > 0 and scrData.giveopen eq 'Y' and scrData.processstatus eq 'N' and scrData.spendstatus ne 'Y'}"> 
 		<div id="resultDiv" >
 			<!-- @edit 20160629 출력메시지 추가 -->
<%--  			<c:if test="${scrData.diffSpendAmount > 1000000  and scrData.act ne 'ADD'}"> --%>
 			<c:if test="${scrData.diffSpendAmount > 100000  and scrData.act ne 'ADD'}">
	 			<div class="footMsg">
	 				<p>교육비와 등록 금액의 차이가 <strong class="won money">${scrData.diffSpendAmountTxt }</strong>원 입니다. 계획을 추가하여 주시기 바랍니다.</p>
	 			</div>
 			</c:if>
 			<!-- //@edit 20160629 출력메시지 추가 --> 
			<c:if test="${scrData.diffSpendAmount <= 100000 }">
				<c:if test="${scrData.planstatus eq 'N' and scrData.sortnum ne '0' and scrData.act ne 'ADD' }">
		 			<div class="btnWrapC pdtM">
		 				<c:if test="${scrData.procType eq 'person' }">
		 					<c:if test="${personlistcount eq 1}">
			 					<a href="javascript:btnEvent.resultconfirm()" class="btnBasicBL">계획완료</a>
			 				</c:if>
		 				</c:if>
		 				<c:if test="${scrData.procType eq 'group' }">
		 					<a href="javascript:btnEvent.resultconfirm()" class="btnBasicBL">계획완료</a>
		 				</c:if>
		 				
		 			</div>
				</c:if>
				<c:if test="${scrData.planstatus eq 'Y' and scrData.act ne 'ADD'}">
		 			<div class="btnWrapC">
		 				<a href="javascript:btnEvent.resultCancel()" class="btnBasicGL">취소</a>
		 				<c:if test="${scrData.procType eq 'person' }">
			 				<c:if test="${personlistcount eq 1}">
			 					<a href="javascript:btnEvent.resultUpdate()" class="btnBasicBL">계획수정</a>
			 				</c:if>
<%-- 			 				<c:if test="${personlistcount eq 0 and grouplistcount eq 1}"> --%>
<!-- 			 					<a href="javascript:btnEvent.resultUpdate()" class="btnBasicBL">계획수정</a> -->
<%-- 			 				</c:if> --%>
			 			</c:if>
		 				<c:if test="${scrData.procType eq 'group' }">
		 					<a href="javascript:btnEvent.resultUpdate()" class="btnBasicBL">계획수정</a>
			 			</c:if>
	 				</div>
				</c:if>
	 			<!-- 계획조회 선택 시 --> 
 			</c:if>
 		</div>
 		</c:if>
	</div>
	<!-- //교육비 사전계획등록/조회 -->
</section>
<!-- //content area | ### academy IFRAME End ### -->
<!-- //Adobe Analytics Footer 호출 include -->
<%@ include file="/WEB-INF/jsp/framework/include/inc_analyticsFooter.jsp"%>
<%@ include file="/WEB-INF/jsp/framework/include/footer.jsp"%>
