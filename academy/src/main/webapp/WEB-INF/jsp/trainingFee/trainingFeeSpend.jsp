<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/framework/include/header.jsp"%>
<!-- //Adobe Analytics Header 호출 include -->
<%@ include file="/WEB-INF/jsp/framework/include/inc_analyticsHeader.jsp"%>

<script type="text/javascript">
$(document.body).ready(function() {
	abnkorea_resize();
	
	// 계획서 활성화
	$(".onlyNum").on("keyup", function(){
		$(this).val($(this).val().replace(/[^0-9]/gi,""));
// 		if(this.value > 99999) { this.value = this.value.substring(0,5); } 
	});
	
	//지출항목 셋팅
	$('.spendItemList').spenditem($("#spendItem0").html());
	
	//지출항목 셋팅
	$(".spenditemAdd").on("click", function () {
		var addDom = "";
		var num = $(".spendItemList > li").length;
		
		if( !isNull(document.getElementById("spendAmount"+num)) ) {
			num = num + "" + 1
		}
		
		addDom += "<li>";
		addDom += "<form id='fileForm"+num+"' method='POST' enctype='multipart/form-data'>";
		addDom += "<input type='file' name='file' id='file"+num+"' style='width:30%;' title='파일첨부' onChange='javascript:html.filesize(this,"+num+");' />";
		addDom += "<input type='hidden' name='filekey' id='filekey"+num+"' title='파일번호' />";
		addDom += "<input type='hidden' name='oldfilekey' id='oldfilekey"+num+"' title='파일번호' />";
		addDom += "	<select name='spenditem' title='지출항목 선택' class='mglS'>";
		addDom += $("select[name='spenditem']").html();
		addDom += "	</select>";
		addDom += "	<input type='tel' title='지출금액' size='15' class='mglS requd isNum' id='spendAmount"+num+"' name='spendAmount' maxlength='15' oninput='maxNumberLength(this)' onkeyup='changeSpendAmount(this)' /> 원";
		addDom += "	<a href='javascript:javascript.spendItemDelete(this);' class='mgLabel btnTbl btnItemDelete'><span>삭제</span></a>";
		addDom += "</form>";
		addDom += "</li>";
		
		$(".spendItemList").append(addDom);
		
		abnkorea_resize();
	});
	
	$("#setData1").alphanumericWithSpace();
	$("#setData6").alphanumericWithSpace();
	$("#setData7").alphanumericWithSpace();
	 
	init();
});

function init() {
	// 교육비 표기
	$("#trfee").text(setComma($("#trainingFeeForm > input[name='trfee']").val()));
	// 월 표기
	reload.searchMonth($("#trainingFeeForm > input[name='giveyear']").val(), $("#trainingFeeForm > input[name='givemonth']").val());
	
	// mode에 따라서 페이지 UI 네이게이션
	var sMode = $("#trainingFeeForm > input[name='mode']").val();
	
	if( $("#trainingFeeForm > input[name='act']").val() == "ADD" ) tabEvent.dayList();
}

var reload = {
	searchMonth : function(schYear, schMonth) {
		var i     = 0;
		var sHtml = "";
		
		var okdata = $("#trainingFeeForm > input[name='okdata']").val().split(',');
		var baseYear = $("#trainingFeeForm > input[name='giveyear']").val();
		
		for(var i=0; i<12; i++) { 
			var sBlob = "N";
			
			$(okdata).each(function(num, val){
				if( (i+1)==parseInt(val.slice(5)) ) {
					sBlob = "Y";
				}			
			});
			
			if(sBlob=="Y" && baseYear==schYear) {
				if((i+1)==schMonth  ){
					sHtml = sHtml+"<a href=\"javascript:btnEvent.searchSpend('Y','"+(i+1)+"');\" class=\"on\"><span class=\"b\">"+(i+1)+"월</span></a>";	
				} else {
					sHtml = sHtml+"<a href=\"javascript:btnEvent.searchSpend('Y','"+(i+1)+"');\"><span class=\"b\">"+(i+1)+"월</span></a>";	
				}			
			} else {
				if((i+1)==schMonth ){
					sHtml = sHtml+"<a href=\"javascript:btnEvent.searchSpend('N','"+(i+1)+"');\" class=\"on\"><span>"+(i+1)+"월</span></a>";	
				} else {
					sHtml = sHtml+"<a href=\"javascript:btnEvent.searchSpend('N','"+(i+1)+"');\"><span>"+(i+1)+"월</span></a>";	
				}
			}
		}	
		$("#searchMonthList").html(sHtml);
	},
	pagego : function(){
		$("#trainingFeeForm").attr("action", "${pageContext.request.contextPath}/trainingFee/trainingFeeIndex.do")
		$("#trainingFeeForm").submit();
	},
	planSelect : function() {
		var datasplit = $("select[name='planItemList']").val().split(",");
		
		$(datasplit).each(function(num, val){
			if(num==3) {
				$("#nomalUseMon").val(val.substring(4,6));	
		        $("#nomalUseDay").val(val.substring(6,8));
			} else {
				$("#setData"+num).val(val);
			}
			
		});
	}
}

// 계획금액 입력시 저장용 변수
function changeSpendAmount(object) {
	var text     = object.value.replace(/[^0-9]/gi, "");
	var commaTxt = setComma(text);
	
	$("#"+object.id).val(commaTxt);
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
	
	$("#rentDepAmount").text(payComma);
	$("#rentDepAmountTxt").val(payText);
	
	if(id=="rentDeposit") {
		$("#rentDepositTxt").val(chnageNumberTxt(unCommaTxt));		
	} else {
		$("#rentAmountTxt").val(chnageNumberTxt(unCommaTxt));
	}
// 	$("#spendamount"+num).val(unCommaTxt);
}

var html = {
	clickSpendList : function(sortnum,planid,day){
		$("#trainingFeeForm > input[name='listDay']").val(day.substring(8,10));
		$("#trainingFeeForm > input[name='mode']").val("U");
		$("#trainingFeeForm > input[name='act']").val("ADD");
		if( $("#trainingFeeForm > input[name='editYn']").val() == "Y" ) {
			$("#trainingFeeForm > input[name='sortnum']").val(sortnum);
			$("#trainingFeeForm > input[name='spendid']").val(planid);
			$("#trainingFeeForm > input[name='planid']").val(planid);
		} else {
			$("#trainingFeeForm > input[name='sortnum']").val(sortnum);
			$("#trainingFeeForm > input[name='spendid']").val(planid);
			$("#trainingFeeForm > input[name='planid']").val(planid);
		}
		html.clickSpendListEvent();
	},
	clickSpendListEvent : function() {
		$("#trainingFeeForm").attr("action", "${pageContext.request.contextPath}/trainingFee/trainingFeeSpend.do")
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
	filesize : function(file, num){
		
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
		
		$.ajaxCall({
			url : "<c:url value="/trainingFee/fileUpLoadFileKey.do"/>",
			success : function(data, textStatus, jqXHR) {
				$("#filekey"+num).val(data.result.fileKey);
				
				$("#fileForm"+num).ajaxForm({
				  	  url : "<c:url value="/trainingFee/fileUpLoadSpend.do"/>"
		 		  	, dataType: "text"
				    , method : "post"
					, async : false
					, beforeSend: function(xhr, settings) { showLoading(); }
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
				var mag = '<spring:message code="trfee.errors.filekey.false"/>';
				alert(mag);
			}
		});
		
	}
}

var btnEvent = {
		searchSpend : function(editYn, giveMonth) {
			$("#trainingFeeForm > input[name='givemonth']").val(giveMonth);
			$("#trainingFeeForm > input[name='editYn']").val(editYn);
			$("#trainingFeeForm > input[name='sortnum']").val("");
			$("#trainingFeeForm > input[name='planid']").val("");
			$("#trainingFeeForm > input[name='listDay']").val("");
			$("#trainingFeeForm > input[name='mode']").val("S");
			$("#trainingFeeForm > input[name='act']").val("");
			$("#trainingFeeForm").attr("action", "${pageContext.request.contextPath}/trainingFee/trainingFeeSpend.do")
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
			btnEvent.searchSpend(sEditYn, $("#trainingFeeForm > input[name='givemonth']").val());
		},
		addSpend : function() {
			$("#trainingFeeForm > input[name='mode']").val("I");
			$("#trainingFeeForm > input[name='act']").val("ADD");
			$("#trainingFeeForm").attr("action", "${pageContext.request.contextPath}/trainingFee/trainingFeeSpend.do")
			$("#trainingFeeForm").submit();
		},
		nomalSpendDelete : function() {
			var result = confirm("저장 하신 지출 내용을 삭제 하시겠습니까?");
			
			if(result){
				$("#trainingFeeForm > input[name='mode']").val("D");
				$("#trainingFeeForm > input[name='act']").val("");
				var param = {};
				
				btnEvent.saveSpend(param);				
			}
		},
		nomalSpendCancel : function() {
			var result = confirm("입력 하신 지출 내용을 취소 하시겠습니까?");
			
			if(result){
				$("#trainingFeeForm > input[name='act']").val("");
				$("#trainingFeeForm").attr("action", "${pageContext.request.contextPath}/trainingFee/trainingFeeSpend.do")
				$("#trainingFeeForm").submit();
			}
		},
		nomalSpendInsert : function() {
			if(!chkValidation({chkId:"#spendItemListChecked", chkObj:"hidden|input|select"}) ){
				return;
			}
			if(!chkValidation({chkId:"#setData", chkObj:"hidden|input|select"}) ){
				return;
			}
			
			var sSpendItem = "";
			var sSpendAmount = "";
			var filekey = "";
			var cnt = $(".spendItemList > li").length;
			
			for( var i=0; i < cnt; i++ ) {
				var objItem   = $(".spendItemList > li > form > select[name='spenditem']")[i];
				var objAmount = $(".spendItemList > li > form > input[name='spendAmount']")[i];
				var objFile   = $(".spendItemList > li > form > input[name='filekey']")[i];
				var objFileNm = $(".spendItemList > li > form > input[name='file']")[i];
				
				var spendAmount = objAmount.value;
				var unCommaTxt = spendAmount.replace(/,/g, "");
				
				if(isNull(objFile.value)){
					alert("["+(i+1)+"] 지출영수증 파일을 선택 해 주세요.");
					return;
				}
				if($("#trainingFeeForm > input[name='mode']").val()=="I") {	
					if(isNull(objFileNm.value)){
						alert("["+(i+1)+"] 지출영수증 파일을 선택 해 주세요.");
						return;
					}
				}
				
				if(isNull(objItem.value)){
					alert("["+(i+1)+"] 지출항목을 선택 해 주세요.");
					return;
				}
				
				if(isNull(spendAmount)){
					alert("["+(i+1)+"] 지출금액을 입력 해 주세요.");
					return;
				}
				
				if(i==0) {
					sSpendItem   = objItem.value;
					sSpendAmount = unCommaTxt;
					filekey = objFile.value;
				} else {
					sSpendItem   = sSpendItem + "," + objItem.value;
					sSpendAmount = sSpendAmount + "," + unCommaTxt;
					filekey = filekey + "," + objFile.value;
				}
			}
		
			var result = confirm("지출증빙 작성 내용을 저장 하시겠습니까?");
			
			if(result){
				var param = {  eduTitle    : $("#setData input[name='edutitle']").val()   
						      ,eduKind     : $("#setData select[name='edukind']").val()  
						      ,place       : $("#setData input[name='place']").val()  
						      ,spendDt     : $("#nomalUseYer option:selected").val() +""+ $("#nomalUseMon option:selected").val() +""+ $("#nomalUseDay option:selected").val()
						      ,personcount : $("#setData input[name='personcount']").val() 
						      ,plancount   : $("#setData input[name='plancount']").val() 
						      ,eduDesc     : $("#setData input[name='edudesc']").val() 
						      ,planid      : $("#setData input[name='planid']").val() 
						      ,spendItem   : sSpendItem
						      ,spendAmount : sSpendAmount
						      ,attachfile  : filekey
						 };
				btnEvent.saveSpend(param);
			}
		},
		saveSpend : function(param) {
			var defaultParam = {
					giveyear   : $("#trainingFeeForm > input[name='giveyear']").val(),
					givemonth  : $("#trainingFeeForm > input[name='givemonth']").val(),
					depaboNo   : $("#trainingFeeForm > input[name='depaboNo']").val(),
					mode       : $("#trainingFeeForm > input[name='mode']").val(),
					groupCode  : $("#trainingFeeForm > input[name='groupCode']").val(),
					procType   : $("#trainingFeeForm > input[name='procType']").val(),
					sortnum    : $("#trainingFeeForm > input[name='sortnum']").val(),
					spendid    : $("#trainingFeeForm > input[name='spendid']").val()
			};
// 			$("#trainingFeeForm > input[name='act']").val("");
			$.extend(defaultParam, param);
			
			$.ajaxCall({
				url : "<c:url value="${pageContext.request.contextPath}/trainingFee/saveTrainingFeeSpend.do"/>",
				data : defaultParam,
				success : function(data, textStatus, jqXHR) {
					var item = data.result;
					
					if( data.result.errCode < 0 ) {
						hideLoading();
						var mag = '<spring:message code="trfee.errors.save.false"/>';
						alert(mag);
					} else {
						$("#trainingFeeForm > input[name='act']").val("");
						alert("지출증빙 처리가 완료 되었습니다.");
						$("#trainingFeeForm").attr("action", "${pageContext.request.contextPath}/trainingFee/trainingFeeSpend.do")
						$("#trainingFeeForm").submit();
					}
				},
				error : function(jqXHR, textStatus, errorThrown) {
					var mag = '<spring:message code="trfee.errors.spendsave.false"/>';
					alert(mag);
				}
			});
		},
		resultconfirm : function() {
			var result = confirm("제출 완료 시 더이상 추가/수정을 할 수 없습니다.\n\n지출증빙 작성 내용을 완료 하시겠습니까?");
			
			if(result){
				var defaultParam = {
						giveyear   : $("#trainingFeeForm > input[name='giveyear']").val(),
						givemonth  : $("#trainingFeeForm > input[name='givemonth']").val(),
						depaboNo   : $("#trainingFeeForm > input[name='depaboNo']").val(),
						groupCode  : $("#trainingFeeForm > input[name='groupCode']").val(),
						procType   : $("#trainingFeeForm > input[name='procType']").val(),
						spendstatus : "Y"
				};
				
				btnEvent.resultSave(defaultParam,"지출증빙 작성 완료 하였습니다.");
			}
		},
		resultSave : function(defaultParam, msgText) {
			$.ajaxCall({
				url : "<c:url value="${pageContext.request.contextPath}/trainingFee/saveTrainingFeeSpendConfirm.do"/>",
				data : defaultParam,
				success : function(data, textStatus, jqXHR) {
					if( data.result.errCode < 1 ) {
						alert("처리도중 오류가 발생하였습니다.");
					} else {
						$("#trainingFeeForm > input[name='mode']").val("S");
						alert(msgText);
						$("#trainingFeeForm").attr("action", "${pageContext.request.contextPath}/trainingFee/trainingFeeSpend.do")
						$("#trainingFeeForm").submit();
					}					
				},
				error : function(jqXHR, textStatus, errorThrown) {
					var mag = '<spring:message code="trfee.errors.resultsave.false1"/>';
					alert(mag);
				}
			});
		}
}

var tabEvent = {
	listClick : function() {
		$("#openTab").show();
		$("#btnSpendAdd").show();
		
		$("#btnSpendDelete").show();
		$("#btnSpendCancel").hide();
		$("#btnSpendInsert").show();
		
		abnkorea_resize();
	},
	dayList : function() {
		var lastDay = "";
		
		lastDay = LastDayOfMonth($("#nomalUseYer option:selected").val(), $("#nomalUseMon option:selected").val());
		setSelectMonthDay(lastDay, "nomalUseDay", $("#trainingFeeForm > input[name='listDay']").val() );
	}
}

var page = {
		init : function() {
			$("#btnSpendAdd").show();
// 			$("#openTab").hide();
			
			abnkorea_resize();
		},
		saveInit : function() {
// 			$("#openTab").hide();
			
			
			if( $("#trainingFeeForm > input[name='spendstatus']").val() == "Y" ) {
				$("#btnSpendAdd").show();
			} else {
				$("#btnSpendAdd").show();
			}
// 			$("#resultDiv").show();
			
			abnkorea_resize();
		},
		addPlanInit : function() {
			$("#openTab").show();
			$("#resultDiv").hide();
			
			$("#btnSpendAdd").show();
			$("#btnSpendDelete").hide();
			$("#btnSpendCancel").show();
			$("#btnSpendInsert").show();
			
			LastDayOfMonth($("#nomalUseYer option:selected").val(), $("#nomalUseMon option:selected").val())
			setSelectMonthDay(LastDayOfMonth($("#nomalUseYer option:selected").val(), $("#nomalUseMon option:selected").val()), "nomalUseDay", "01");
			
			abnkorea_resize();
		}
}
</script>
</head>

<body>
<!-- content area | ### academy IFRAME Start ### -->
<section id="pbContent" class="bizroom">
	<div class="hWrap">
		<h1><img src="/_ui/desktop/images/academy/h1_w020400420.gif" alt="교육비 지출증빙 등록/조회"></h1>
		<p><img src="/_ui/desktop/images/academy/txt_w020400420.gif" alt="교육비 지출증빙을 등록하고 조회하실 수 있습니다."></p>
	</div>
	<form id="trainingFeeForm" name="trainingFeeForm" method="post">
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
		<input type="hidden" name="spendid"     value="${scrData.spendid }"    />
		<input type="hidden" name="planid"     value="${scrData.spendid }"    />
		<input type="hidden" name="listDay"     value="${scrData.listDay }"    />
		<input type="hidden" name="spendstatus" value="${scrData.spendstatus }"/>
		<input type="hidden" name="planstatus" value="${scrData.planstatus }"/>
		<input type="hidden" name="processstatus" value="${scrData.processstatus }"/>
		<input type="hidden" name="act" value="${scrData.act }"/>
	</form>
	<c:set var="grouplistcount" value="0"></c:set>
	<c:set var="personlistcount" value="0"></c:set>
	<c:set var="updateYN" value="Y"></c:set>
	<!-- 교육비 사전계획등록/조회 -->
	<div id="trainingFee">

		<div class="monthSelectWrap">
			<select title="년도" onchange="btnEvent.searchYear(this);">
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
			</span> <a href="javascript:reload.pagego();" class="btnCont"><span>교육비관리 목록</span></a>
		</div>
		
		<table class="tblList lineLeft">
			<caption>교육비 등록 일자, 교육종류, 교육, 횟수, 예상금액, 비율 테이블</caption>
			<colgroup>
				<col style="width:7%">
				<col style="width:16%">
				<col style="width:10%">
				<col style="width:auto">
				<col style="width:12%">
				<col style="width:9%">
				<col style="width:9%">
			</colgroup>
			<thead>
				<tr>
					<th scope="col">번호</th>
					<th scope="col">일자</th>
					<th scope="col">교육종류</th>
					<th scope="col">교육명</th>
					<th scope="col">예상금액<span class="normal">(원)</span></th>
					<th scope="col">비율<span class="normal">(%)</span></th>
					<th scope="col">영수증</th>
				</tr>
			</thead>
			<c:if test="${!empty spendList}">
				<tbody>
				<c:forEach var="items" items="${spendList}" varStatus="status">
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
								<c:if test="${items.plantype eq 'group' }">(그룹)
									<c:if test="${items.sortnum ne 0 }"><c:set var="grouplistcount" value="1"></c:set></c:if>
								</c:if>
								<c:if test="${items.plantype eq 'person' }">(개인)
									<c:if test="${items.sortnum ne 0 }"><c:set var="personlistcount" value="1"></c:set></c:if>
								</c:if>
							<a href="javascript:html.clickSpendList('${items.sortnum}','${items.planid}','${items.spenddt }');">${items.edutitle}<c:if test="${items.sortnum eq 0 }">-${items.planid}</c:if></a>
						</td>
						<td>${items.spendamount}</td>
						<td>${items.rate}</td>
						<td>
							<a href="javascript:html.clickSpendList('${items.sortnum}','${items.planid}','${items.spenddt }');"><img src="/_ui/desktop/images/academy/ico_bills.gif" alt="영수증"></a>
						</td>
					</c:if>
					</tr>
				</c:forEach>
				</tbody>
<%-- 				<c:if test="${scrData.mode eq 'R' || scrData.spendstatus eq 'Y'}"> --%>
				<tfoot>
					<tr>
						<td>계</td>
						<td></td>
						<td></td>
						<td></td>
						<td>${totalspendamount}</td>
						<td>${totalrate}</td>
						<td></td>
					</tr>
				</tfoot>
<%-- 				</c:if> --%>
			</c:if>
			<c:if test="${empty spendList}">
				<tbody>
					<tr><td colspan="7">지출증빙을 등록해 주세요.</td></tr>
				</tbody>
			</c:if>
		</table>
		
		<c:if test="${scrData.sortnum ne 0 || scrData.sortnum eq ''}">
			<div class="btnWrap">
				<ul class="listWarning">
					<li>※ ${scrData.givemonth }월 교육에 해당하는 지출증빙 서류를 등록해 주세요.</li>
				</ul>
				<c:if test="${scrData.spendstatus eq 'N' and scrData.processstatus ne 'Y' and scrData.planstatus eq 'Y' }">
					<span class="btnR"><a href="javascript:btnEvent.addSpend();" id="btnSpendAdd" class="btnPlanBS">+지출추가</a></span>
				</c:if>
			</div>
			
			<!-- 지출추가 테이블 -->
			<c:if test="${scrData.mode ne 'S' and scrData.act eq 'ADD'}">
			<div class="logTabContent" id="openTab" >
			
				
				<table class="tblInput" id="spendItemListChecked">
					<caption>부가정보 입력</caption>
					<colgroup>
						<col style="width:18%">
						<col style="width:auto">
					</colgroup>
					<tbody>
						<tr>
							<th scope="row">영수증등록</th>
							<td>
								
								<ul class="spendItemList" id="spendItemList">
									<c:if test="${empty dataSpendItem}">
										<li>
											<form id="fileForm0" method="POST" enctype="multipart/form-data">
												<input type="file" name="file" id="file0" style="width:30%;" title="파일첨부" onChange="javascript:html.filesize(this,0);" />
												<input type="hidden" name="filekey" id="filekey0" title="파일번호" />
												<input type="hidden" name="oldfilekey" id="oldfilekey0" title="파일번호" />
												<select name="spenditem" title="지출항목 선택" class="mglS">
													<option value="">지출항목 선택</option>
													<ct:code type="option" majorCd="spenditem" selectAll="false" />
												</select>
												<input type="tel" size="15" title="지출금액" class="mglS requd isNum" id="spendAmount0" name="spendAmount" maxlength="15" oninput="maxNumberLength(this)" onkeyup="changeSpendAmount(this)" /> 원
												<a href="#none" class="mgLabel btnTbl btnGs spenditemAdd">추가</a>
											</form>
										</li>
									</c:if>
									<c:if test="${!empty dataSpendItem}">
										<c:forEach var="items" items="${dataSpendItem }" varStatus="status">
											<li>
												<form id="fileForm${status.index }" method="POST" enctype="multipart/form-data">
													<input type="file" name="file" id="file${status.index }" style="width:30%;" title="파일첨부" value="${items.realfilename }" onChange="javascript:html.filesize(this,${status.index });" />
													<input type="hidden" name="filekey" id="filekey${status.index }" title="파일번호" value="${items.attachfile }" />
													<input type="hidden" name="oldfilekey" id="oldfilekey${status.index }" title="파일번호" value="${items.attachfile }" />
													<select name="spenditem" title="지출항목 선택" class="mglS">
														<option value="">지출항목 선택</option>
														<ct:code type="option" majorCd="spenditem" selectAll="false" selected="${items.spenditem }" />
													</select>
													<input type="tel" size="15" title="지출금액" class="mglS requd isNum" id="spendAmount${status.index }" name="spendAmount" maxlength="15" oninput="maxNumberLength(this)" onkeyup="changeSpendAmount(this)" value="${items.spendamountcomma }" /> 원
													<c:if test="${status.index == 0 and scrData.spendstatus eq 'N'}">
														<c:if test="${scrData.procType eq 'person' and items.spendtype eq 'person'}">
															<a href="#none" class="mgLabel btnTbl btnGs spenditemAdd">추가</a>
														</c:if>
														
													</c:if>
													<c:if test="${scrData.procType ne items.spendtype}">
														<c:set var="updateYN" value="N"></c:set>
													</c:if>
													<c:if test="${status.index > 0 and scrData.spendstatus eq 'N'}">
														<c:if test="${scrData.procType eq 'person' and items.spendtype eq 'person'}">
															<a href="javascript:javascript.spendItemDelete(this);" class="mgLabel btnTbl btnItemDelete"><span>삭제</span></a>
														</c:if>
													</c:if>
													<div style="border-top:1px dotted #D5D5D5;width:98%;">등록 파일 : <a href="/trfee/common/file/fileDownload.do?fileKey=${items.attachfile }&uploadSeq=${items.uploadseq }" >${items.realfilename }</a></div>
												</form>
											</li>
										</c:forEach>
									</c:if>
								</ul>
							</td>
						</tr>
					</tbody>
				</table>
							
				<table class="tblInput mgtL" id="setData">
					<caption>부가정보 입력</caption>
					<colgroup>
						<col style="width:18%">
						<col style="width:auto">
						<col style="width:18%">
						<col style="width:auto">
					</colgroup>
					<tbody>
						<tr>
							<th scope="row">사전계획선택</th>
							<td colspan="3">
								
								<select name="planItemList" title="사전계획선택" onchange="javascript:reload.planSelect();">
									<option value=",,,,,,,">신규 등록</option>
									<c:forEach var="items" items="${planList}" varStatus="status">
										<option value="${items.planid },${items.edutitle },${items.edukind },${items.spenddt },${items.personcount },${items.plancount },${items.place },${items.edudesc }">${items.optionname }</option>
									</c:forEach>
								</select>
							</td>
						</tr>
						<tr>
							<th scope="row">교육명</th>
							<td colspan="3"><input type="hidden" title="계획서 아이디" id="setData0" name="planid" value="<c:if test="${!empty dataSpend}">${dataSpend.planid }</c:if>" />
							                <input type="text" title="교육명" class="inputWFull requd" id="setData1" name="edutitle" value="<c:if test="${!empty dataSpend}">${dataSpend.edutitle }</c:if>" maxlength="50" oninput="maxLengthCheck(this)" /></td>
						</tr>
						<tr>
							<th scope="row">교육종류</th>
							<td>
								<select title="교육종류" id="setData2" name="edukind" class="requd">
									<option value="">교육종류 선택</option>
									<c:if test="${!empty dataSpend}">
										<ct:code type="option" majorCd="edukind" selectAll="false" selected="${dataSpend.edukind }" />
									</c:if>
									<c:if test="${empty dataSpend}">
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
										<c:if test="${!empty dataSpend}">
											<option value="${planUseMon.usemon }" <c:if test="${planUseMon.usemon eq dataSpend.usemon}"> selected="selected"</c:if>>${planUseMon.usemon }월</option>
										</c:if>
										<c:if test="${empty dataSpend}">
											<option value="${planUseMon.usemon }" <c:if test="${planUseMon.usemon eq scrData.givemonth}"> selected="selected"</c:if>>${planUseMon.usemon }월</option>
										</c:if>
									</c:forEach>										
								</select>
								<select title="교육일자 일 선택" class="mglSs" id="nomalUseDay" name="useDay" class="requd"></select>
							</td>
						</tr>
						<tr>
							<th scope="row">예상인원</th>
							<td><input type="text" size="10" title="예상인원" id="setData4" name="personcount" class="requd isNum onlyNum" value="<c:if test="${!empty dataSpend}">${dataSpend.personcount }</c:if>" maxlength="5" oninput="maxLengthCheck(this)" /> 명</td>
							<th scope="row">횟수(회)</th>
							<td><input type="text" size="10" title="횟수(회)" id="setData5" name="plancount" class="requd isNum onlyNum" value="<c:if test="${!empty dataSpend}">${dataSpend.plancount }</c:if>" maxlength="3" oninput="maxLengthCheck(this)" /> 회</td>
						</tr>
						<tr>
							<th scope="row">교육장소(선택)</th>
							<td colspan="3"><input type="text" title="교육장소" class="inputWFull" id="setData6" name="place" value="<c:if test="${!empty dataSpend}">${dataSpend.place }</c:if>" maxlength="50" oninput="maxLengthCheck(this)" /></td>
						</tr>
						<tr>
							<th scope="row">교육설명(선택)</th>
							<td colspan="3"><input type="text" title="교육장소" class="inputWFull" id="setData7" name="edudesc" value="<c:if test="${!empty dataSpend}">${dataSpend.edudesc }</c:if>" maxlength="50" oninput="maxLengthCheck(this)" /></td>
						</tr>
					</tbody>
				</table>

				<div class="btnWrapC">
					<c:if test="${scrData.spendstatus eq 'N' and scrData.processstatus ne 'Y' and scrData.planstatus eq 'Y' }">
						<a href="javascript:;" class="btnBasicGS" id="btnSpendCancel" onclick="javascript:btnEvent.nomalSpendCancel();" >취소</a>
						<c:if test="${scrData.mode eq 'U'}">
							<c:if test="${updateYN eq 'Y'}">
							<a href="javascript:;" class="btnBasicGS" id="btnSpendDelete" onclick="javascript:btnEvent.nomalSpendDelete();" >삭제</a>
							</c:if>
						</c:if> 
						<c:if test="${updateYN eq 'Y'}"> 
						<a href="javascript:;" class="btnBasicBS" id="btnSpendInsert" onclick="javascript:btnEvent.nomalSpendInsert();" >저장</a>
						</c:if>
					</c:if>
				</div>
			</div>
			</c:if>
			<!-- //지출추가 테이블 -->
			
			<!-- 지출입력완료 테이블 -->
			<c:if test="${listcount > 0 and scrData.processstatus ne 'Y' }">
			<div id="resultDiv" >
	 			<!-- @edit 20160629 출력메시지 추가 -->
	 			<c:if test="${scrData.diffSpendAmount > 100000 and scrData.act ne 'ADD'}">
		 			<div class="footMsg">
		 				<p>교육비와 등록 금액의 차이가 <strong class="won money">${scrData.diffSpendAmountTxt }</strong>원 입니다. 차액이 10만원 이하가 되어야 제출 가능합니다.</p>
		 			</div>
	 			</c:if>
	 			<!-- //@edit 20160629 출력메시지 추가 -->
				<c:if test="${scrData.diffSpendAmount <= 100000 and scrData.spendstatus eq 'N' and scrData.act ne 'ADD'}">
		 			<div class="btnWrapC pdtM"> 
			 			<c:if test="${scrData.procType eq 'person' }">
			 				<c:if test="${personlistcount eq 1}">
			 				<a href="javascript:btnEvent.resultconfirm()" class="btnBasicBL">제출</a>
			 				</c:if>
			 			</c:if>
			 			<c:if test="${scrData.procType eq 'group' }">
			 				<a href="javascript:btnEvent.resultconfirm()" class="btnBasicBL">제출</a>
			 			</c:if>
		 			</div>
		 			<!-- 계획조회 선택 시 --> 
	 			</c:if>
	 		</div>
	 		</c:if>
	 		<!-- //지출추가 테이블 -->
 		</c:if> <!-- 지출 내역 -->
 		
 		<c:if test="${scrData.sortnum eq 0 && scrData.sortnum ne '' }">
 			<br/>
 			<div class="logTabContent">
	 			<table class="tblInput">
					<caption>부가정보 입력</caption>
					<colgroup>
						<col style="width: 18%">
						<col style="width: auto">
					</colgroup>
					<tbody>
						<tr>
							<th scope="row">임대기간</th>
							<td><span><c:if test="${!empty dataRent}">${dataRent.rentfromyy}년 ${dataRent.rentfrommm}월 ~ ${dataRent.renttoyy}년 ${dataRent.renttomm}월</c:if></span></td>
						</tr>
						<tr>
							<th scope="row">보증금</th>
							<td><span><c:if test="${!empty dataRent}">${dataRent.rentdepositcomma }</c:if></span> 원<span class="mglS">※ 보증금은 년 5% 대출 이율로 월할 계산됩니다.</span>
							</td>
						</tr>
						<tr>
							<th scope="row">월임대료</th>
							<td><span><c:if test="${!empty dataRent}">${dataRent.rentamountcomma }</c:if></span> 원 
							<input type="text" size="15" value="<c:if test="${!empty dataRent}">${dataRent.rentamounttxt }</c:if>" disabled="disabled" class="mglS" id="rentAmountTxt" />
							</td>
						</tr>
						<tr>
							<th scope="row">월지원금</th>
							<td>보증금이자(5%/12)+월임대료 = <span><c:if test="${!empty dataRent}">${dataRent.rentdepositcomma12 }</c:if></span> 원
							<input type="text" size="30" value="<c:if test="${!empty dataRent}">${dataRent.rentdeposit12txt }</c:if>" disabled="disabled" class="mglS" />
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
 		</c:if>
 		
	</div>
	<!-- //교육비 사전계획등록/조회 -->
</section>
<!-- //content area | ### academy IFRAME End ### -->
<!-- //Adobe Analytics Footer 호출 include -->
<%@ include file="/WEB-INF/jsp/framework/include/inc_analyticsFooter.jsp"%>
<%@ include file="/WEB-INF/jsp/framework/include/footer.jsp"%>
