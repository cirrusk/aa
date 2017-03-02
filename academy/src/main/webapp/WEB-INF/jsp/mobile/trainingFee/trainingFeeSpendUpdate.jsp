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
		if(this.value > 999) { this.value = this.value.substring(0,3); } 
	});
	
	//지출항목 셋팅
	$('.spendItemWrap').spendItemsMoblie($("#spendItem0").html());

	$("#setData1").bind("keyup",function(){
		var re = /[ \{\}\[\]\/?.,;:|\)*~`!^\-_+┼<>@\#$%&\'\"\\(\=]/gi; 
        var temp=$("#setData1").val();

        if(re.test(temp)){ //특수문자가 포함되면 삭제하여 값으로 다시셋팅

         $("#setData1").val(temp.replace(re,"")); } 
	});
	$("#setData6").bind("keyup",function(){
		var re = /[ \{\}\[\]\/?.,;:|\)*~`!^\-_+┼<>@\#$%&\'\"\\(\=]/gi;
        var temp=$("#setData6").val();

        if(re.test(temp)){ //특수문자가 포함되면 삭제하여 값으로 다시셋팅

         $("#setData6").val(temp.replace(re,"")); } 
	});
	$("#setData7").bind("keyup",function(){
		var re = /[ \{\}\[\]\/?.,;:|\)*~`!^\-_+┼<>@\#$%&\'\"\\(\=]/gi; 
        var temp=$("#setData7").val();

        if(re.test(temp)){ //특수문자가 포함되면 삭제하여 값으로 다시셋팅

         $("#setData7").val(temp.replace(re,"")); } 
	});
});

var reload = {
	searchMonth : function() {
		$("#trainingFeeForm > input[name='givemonth']").val($("select[name='searchmonth']").val());
		$("#trainingFeeForm").attr("action", "/mobile/trainingFee/trainingFeeSpend.do")
		$("#trainingFeeForm").submit();
	},
	pagego : function(){
		$("#trainingFeeForm").attr("action", "/mobile/trainingFee/trainingFeeMain.do")
		$("#trainingFeeForm").submit();
	},
	planSelect : function() {
		var datasplit = $("select[name='planItemList']").val().split(",");
		
		$(datasplit).each(function(num, val){
			$("#setData"+num).val(val);
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
// 		$("#trainingFeeForm > input[name='listDay']").val(day.substring(8,10));
		$("#trainingFeeForm > input[name='mode']").val("U");
		$("#trainingFeeForm > input[name='sortnum']").val(sortnum);
		$("#trainingFeeForm > input[name='spendid']").val(planid);
		html.clickSpendListEvent();
	},
	clickSpendListEvent : function() {
		$("#trainingFeeForm").attr("action", "/mobile/trainingFee/trainingFeeSpendUpdate.do")
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
	filecall : function(num) {
		rownum = num;
		window.appFile.selectFileInfo(num, "img", "10485760", "$('#IframeComponent').get(0).contentWindow.fncallback");
	},
	filesize : function(file,num){
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
			file.value = "";
			return;
		}
		
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
		searchSpend : function(editYn, giveMonth) {
			$("#trainingFeeForm > input[name='givemonth']").val(giveMonth);
			$("#trainingFeeForm > input[name='editYn']").val(editYn);
			$("#trainingFeeForm > input[name='sortnum']").val("");
			$("#trainingFeeForm > input[name='planid']").val("");
			$("#trainingFeeForm > input[name='listDay']").val("");
			$("#trainingFeeForm > input[name='mode']").val("S");
			$("#trainingFeeForm").attr("action", "/mobile/trainingFee/trainingFeeSpend.do")
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
			$("#trainingFeeForm").attr("action", "/mobile/trainingFee/trainingFeeSpend.do")
			$("#trainingFeeForm").submit();
		},
		nomalSpendDelete : function() {
			var result = confirm("저장 하신 지출 내용을 삭제 하시겠습니까?");
			
			if(result){
				$("#trainingFeeForm > input[name='rmode']").val("D");
				var param = {};
				
				btnEvent.saveSpend(param);				
			}
		},
		nomalSpendCancel : function() {
			var result = confirm("입력 하신 지출(수정) 내용을 취소 하시겠습니까?");
			
			if(result){
				$("#trainingFeeForm").attr("action", "/mobile/trainingFee/trainingFeeSpend.do")
				$("#trainingFeeForm").submit();
			}
		},
		nomalSpendOk : function() {
			$("#trainingFeeForm").attr("action", "/mobile/trainingFee/trainingFeeSpend.do")
			$("#trainingFeeForm").submit();
		},
		nomalSpendInsert : function() {
			if(!chkValidation({chkId:"#setData", chkObj:"hidden|input|select"}) ){
				return;
			}
			
			var sSpendItem   = "";
			var sSpendAmount = "";
			var filekey      = "";
			var cnt = $(".spendItemWrap > .inputWrap").length;
			
			for( var i=0; i < cnt; i++ ) {
				var objItem    = $(".spendItemWrap > .inputWrap > form > .selectBox1 > select[name='nomalSpendItem']")[i].value;
				var objAmount  = $(".spendItemWrap > .inputWrap > form > .unit > input[name='spendAmount']")[i].value;
				var objFile    = $(".spendItemWrap > .inputWrap > form > p > input[name='filekey']")[i].value;
				
				var unCommaTxt = objAmount.replace(/,/g, "");
				
				if(isNull(objFile)){
					alert("["+(i+1)+"] 지출영수증 파일을 선택 해 주세요.");
					return;
				}
				
				if(isNull(objItem)){
					alert("["+(i+1)+"] 지출항목을 선택 해 주세요.");
					return;
				}
				
				if(isNull(objAmount)){
					alert("["+(i+1)+"] 지출금액을 입력 해 주세요.");
					return;
				}
				
				if(i==0) {
					sSpendItem   = objItem;
					sSpendAmount = unCommaTxt;
					filekey      = objFile;
				} else {
					sSpendItem   = sSpendItem + "," + objItem;
					sSpendAmount = sSpendAmount + "," + unCommaTxt;
					filekey      = filekey + "," + objFile;
				}
			}
			
			var result = confirm("지출증빙 작성 내용을 저장 하시겠습니까?");
			
			if(result){
				var param = {  eduTitle    : $("#setData input[name='edutitle']").val()   
						      ,eduKind     : $("#setData select[name='edukind']").val()  
						      ,place       : $("#setData input[name='place']").val()  
						      ,spendDt     : $("#setData input[name='spendDt']").val()
						      ,personcount : $("#setData input[name='personcount']").val() 
						      ,plancount   : $("#setData input[name='plancount']").val() 
						      ,eduDesc     : $("#setData input[name='edudesc']").val() 
						      ,planid      : $("#setData input[name='planid']").val() 
						      ,spendItem   : sSpendItem
						      ,spendAmount : sSpendAmount
						      ,attachfile  : filekey
						 };
				
				// 첨부파일 전송 완료 후 저장
				btnEvent.saveSpend(param);
			}
		},
		saveSpend : function(param) {
			var defaultParam = {
					giveyear   : $("#trainingFeeForm > input[name='giveyear']").val(),
					givemonth  : $("#trainingFeeForm > input[name='givemonth']").val(),
					depaboNo   : $("#trainingFeeForm > input[name='depaboNo']").val(),
					mode       : $("#trainingFeeForm > input[name='rmode']").val(),
					groupCode  : $("#trainingFeeForm > input[name='groupCode']").val(),
					procType   : $("#trainingFeeForm > input[name='procType']").val(),
					sortnum    : $("#trainingFeeForm > input[name='sortnum']").val(),
					spendid    : $("#trainingFeeForm > input[name='spendid']").val()
			};
			
			$.extend(defaultParam, param);
			
			$.ajaxCall({
				url : "<c:url value="/mobile/trainingFee/saveTrainingFeeSpend.do"/>",
				data : defaultParam,
				success : function(data, textStatus, jqXHR) {
					var item = data.result;
					
					if( data.result.errCode < 1 ) {
						alert("처리도중 오류가 발생하였습니다.");
					} else {
						alert("지출증빙 처리가 완료 되었습니다.");
						$("#trainingFeeForm").attr("action", "/mobile/trainingFee/trainingFeeSpend.do")
						$("#trainingFeeForm").submit();
					}
				},
				error : function(jqXHR, textStatus, errorThrown) {
					var mag = '<spring:message code="trfee.errors.spendsave.false"/>';
					alert(mag);
				}
			});
		}
}

</script>

<!-- content area | ### academy IFRAME Start ### -->
<section id="pbContent">
	<form id="trainingFeeForm" name="trainingFeeForm" method="post">
		<input type="hidden" name="giveyear"    value="${scrData.giveyear }"   />
		<input type="hidden" name="givemonth"   value="${scrData.givemonth }"  />
		<input type="hidden" name="okdata"      value="${scrData.okdata }"     />
		<input type="hidden" name="depaboNo"    value="${scrData.depaboNo }"   />
		<input type="hidden" name="editYn"      value="${scrData.editYn }"     />
		<input type="hidden" name="mode"        value="${scrData.mode }"       />
		<input type="hidden" name="rmode"       value="${scrData.rmode }"      />
		<input type="hidden" name="targettype"  value="${scrData.targettype }" />
		<input type="hidden" name="trfee"       value="${scrData.trfee }"      />
		<input type="hidden" name="groupCode"   value="${scrData.groupCode }"  />
		<input type="hidden" name="procType"    value="${scrData.procType }"   />
		<input type="hidden" name="sortnum"     value="${scrData.sortnum }"    />
		<input type="hidden" name="spendid"     value="${scrData.spendid }"    />
		<input type="hidden" name="listDay"     value="${scrData.listDay }"    />
		<input type="hidden" name="spendstatus" value="${scrData.spendstatus }"/>
		<input type="hidden" name="app"         value="${scrData.app }"        />
	</form>
	<c:set var="updateYN" value="Y"></c:set>
	<div class="mTrainingFee">
		<c:if test="${scrData.rmode eq 'I' }"><h2 class="titTop">교육비 지출증빙등록/조회</h2></c:if>
		<c:if test="${scrData.rmode eq 'U' }"><h2 class="titTop">교육비 지출증빙수정/조회</h2></c:if>
		<c:if test="${scrData.rmode eq 'S' }"><h2 class="titTop">교육비 지출증빙 조회</h2></c:if>

			<!-- @edit 20160705 디자인 수정사항 적용 brdTop 클래스 위치 변경 -->
			<section class="mInputWrapper" id="setData">
				<div class="spendItemWrap">
					<c:if test="${scrData.rmode eq 'I' }">
						<div class="inputWrap  brdTop">
							<strong class="labelSizeM">영수증 등록</strong>
							<form id="fileForm0" method="POST" enctype="multipart/form-data" class="textBox unit">
								<p>
								   <c:if test="${scrData.app eq 'amway_Android' }">
										<a href="javascript:html.filecall(0);" class="btnTbl mgbS">파일선택</a>
										<input type="text" id="file0" class="file" name="file0" title="사진 찾기" placeholder="선택된 파일 없음" readonly />
									</c:if>
									<c:if test="${scrData.app eq 'Android' }">
										<input type="file" name="file0" id="file0" title="사진 찾기" onChange="javascript:html.filesize(this,0);" accept="image/*;capture=camera" />
									</c:if>
								   <input type="hidden" name="filekey" id="filekey0" title="파일번호" value="" />
								   <input type="hidden" name="oldfilekey" id="oldfilekey0" title="파일번호" value="" />
								</p>
								
								<p class="selectBox1">
									<select title="지출항목 선택" id="spendItem0" name="nomalSpendItem" >
										<option value="" selected="selected">지출항목 선택</option>
										<ct:code type="option" majorCd="spenditem" selectAll="false" />
									</select>
								</p>
								<p class="unit"><input type="tel" title="지출금액" placeholder="금액입력" id="spendAmount0" name="spendAmount" onkeyup="changeSpendAmount(this)" /><em>원</em></p>
								<p class="btns" id="spendBtn0"><a href="#" class="btnTblLGray">추가</a></p>
							</form>
						</div>
					</c:if>
					<c:if test="${scrData.rmode ne 'I' }">
						<c:forEach var="items" items="${dataSpendItem }" varStatus="status">
							<c:if test="${status.index eq 0 }">
							<div class="inputWrap brdTop">
								<strong class="labelSizeM">영수증 등록</strong>
								<form id="fileForm${status.index}" method="POST" enctype="multipart/form-data" class="textBox unit">
									<c:if test="${scrData.procType ne items.spendtype}">
										<c:set var="updateYN" value="N"></c:set>
									</c:if>
										<p> <c:if test="${scrData.rmode eq 'S' }"><input type="text" value="${items.realfilename }" readonly /></c:if>
										    <c:if test="${scrData.rmode ne 'S' }">
										    	<c:if test="${scrData.app eq 'amway_Android' }">
													<a href="javascript:html.filecall(${status.index});" class="btnTbl mgbS">파일선택</a>
													<input type="text" id="file${status.index}" class="file" name="file${status.index}" title="사진 찾기" placeholder="선택된 파일 없음" readonly />
												</c:if>
												<c:if test="${scrData.app eq 'Android' }">
										    		<input type="file" name="file${status.index}" id="file${status.index}" title="사진 찾기" onChange="javascript:html.filesize(this,${status.index});" accept="image/*;capture=camera" />
										    	</c:if>
										    </c:if>
										</p>
										<p> 등록 파일 : <a href="/trfee/common/file/mobile/fileDownload.do?fileKey=${items.attachfile }&uploadSeq=${items.uploadseq }" >${items.realfilename }</a>
											<input type="hidden" name="filekey" id="filekey${status.index }" title="파일번호" value="${items.attachfile }" />
											<input type="hidden" name="oldfilekey" id="oldfilekey${status.index }" title="파일번호" value="${items.attachfile }" /> </p>
										<p class="selectBox1">
											<select title="지출항목 선택" id="spendItem${status.index}" name="nomalSpendItem" <c:if test="${scrData.rmode eq 'S' }">disabled</c:if> >
												<option selected="selected">지출항목 선택</option>
												<ct:code type="option" majorCd="spenditem" selectAll="false" selected="${items.spenditem }" />
											</select>
										</p>
										<p class="unit"><input type="tel" title="지출금액" placeholder="금액입력" id="spendAmount${status.index}" name="spendAmount" onkeyup="changeSpendAmount(this)" value="${items.spendamountcomma }" <c:if test="${scrData.rmode eq 'S' }">readonly</c:if> /><em>원</em></p>
										<p class="btns" id="spendBtn0">
											<c:if test="${status.last }">
												<c:if test="${scrData.procType eq 'person' and items.spendtype eq 'person'}">
												<a href="#" class="btnTblLGray">추가</a>
												</c:if>
											</c:if>
										</p>
								</form>
							</div>
							</c:if>
							<c:if test="${status.index ne 0  and !status.last }">
							<div class="inputWrap  addInput">
								<form id="fileForm${status.index}" method="POST" enctype="multipart/form-data" class="textBox unit">
									<p><c:if test="${scrData.rmode eq 'S' }"><input type="text" value="${items.realfilename }" readonly /></c:if>
									   <c:if test="${scrData.rmode ne 'S' }">
									   		<c:if test="${scrData.app eq 'amway_Android' }">
												<a href="javascript:html.filecall(${status.index});" class="btnTbl mgbS">파일선택</a>
												<input type="text" id="file${status.index}" class="file" name="file${status.index}" title="사진 찾기" placeholder="선택된 파일 없음" readonly />
											</c:if>
											<c:if test="${scrData.app eq 'Android' }">
									    		<input type="file" name="file${status.index}" id="file${status.index}" title="사진 찾기" onChange="javascript:html.filesize(this,${status.index});" accept="image/*;capture=camera" />
									    	</c:if>
									   </c:if>
									</p>
									<p> 등록 파일 : <a href="/trfee/common/file/mobile/fileDownload.do?fileKey=${items.attachfile }&uploadSeq=${items.uploadseq }" >${items.realfilename }</a>
										<input type="hidden" name="filekey" id="filekey${status.index }" title="파일번호" value="${items.attachfile }" />
										<input type="hidden" name="oldfilekey" id="oldfilekey${status.index }" title="파일번호" value="${items.attachfile }" /> </p>
									<p class="selectBox1">
										<select title="지출항목 선택" id="spendItem${status.index}" name="nomalSpendItem" <c:if test="${scrData.rmode eq 'S' }">disabled</c:if>>
											<option selected="selected">지출항목 선택</option>
											<ct:code type="option" majorCd="spenditem" selectAll="false" selected="${items.spenditem }"  />
										</select>
									</p>
									<p class="unit"><input type="tel" title="지출금액" placeholder="금액입력" id="spendAmount${status.index}" name="spendAmount" onkeyup="changeSpendAmount(this)" value="${items.spendamountcomma }" <c:if test="${scrData.rmode eq 'S' }">readonly</c:if> /><em>원</em></p>
									<p class="btns">
										<c:if test="${scrData.rmode ne 'S' }">
											<c:if test="${scrData.procType eq 'person' and items.spendtype eq 'person'}">
											<a href='javascript:;' class='btnTblL'>삭제</a>
											</c:if>
										</c:if>
									</p>
								</form>
							</div>
							</c:if>
							<c:if test="${status.index ne 0 and status.last }">
							<div class="inputWrap  addInput">
								<form id="fileForm${status.index}" method="POST" enctype="multipart/form-data" class="textBox unit">
										<p><c:if test="${scrData.rmode eq 'S' }"><input type="text" value="${items.realfilename }" readonly /></c:if>
										   <c:if test="${scrData.rmode ne 'S' }">
											   	<c:if test="${scrData.app eq 'amway_Android' }">
													<a href="javascript:html.filecall(${status.index});" class="btnTbl mgbS">파일선택</a>
													<input type="text" id="file${status.index}" class="file" name="file${status.index}" title="사진 찾기" placeholder="선택된 파일 없음" readonly />
												</c:if>
												<c:if test="${scrData.app eq 'Android' }">
										    		<input type="file" name="file${status.index}" id="file${status.index}" title="사진 찾기" onChange="javascript:html.filesize(this,${status.index});" accept="image/*;capture=camera" />
										    	</c:if> 
										   </c:if>
										</p>
										<p> 등록 파일 : <a href="/trfee/common/file/mobile/fileDownload.do?fileKey=${items.attachfile }&uploadSeq=${items.uploadseq }" >${items.realfilename }</a>
											<input type="hidden" name="filekey" id="filekey${status.index }" title="파일번호" value="${items.attachfile }" />
											<input type="hidden" name="oldfilekey" id="oldfilekey${status.index }" title="파일번호" value="${items.attachfile }" /> </p>
										<p class="selectBox1">
											<select title="지출항목 선택" id="spendItem${status.index}" name="nomalSpendItem" <c:if test="${scrData.rmode eq 'S' }">disabled</c:if> >
												<option selected="selected">지출항목 선택</option>
												<ct:code type="option" majorCd="spenditem" selectAll="false" selected="${items.spenditem }"  />
											</select>
										</p>
										<p class="unit"><input type="tel" title="지출금액" placeholder="금액입력" id="spendAmount${status.index}" name="spendAmount" onkeyup="changeSpendAmount(this)" value="${items.spendamountcomma }" <c:if test="${scrData.rmode eq 'S' }">readonly</c:if> /><em>원</em></p>
										<p class="btns">
											<c:if test="${scrData.rmode ne 'S' }">
												<c:if test="${scrData.procType eq 'person' and items.spendtype eq 'person'}">
												<a href='javascript:;' class='btnTblL'>삭제</a><a href="#" class="btnTblLGray">추가</a>
												</c:if>
											</c:if>
										</p>
								</form>
							</div>
							</c:if>
						</c:forEach>
					</c:if>
				</div>
				<!-- @edit 20160705 디자인 수정사항 적용 brdTop2 클래스 추가 -->
				<c:if test="${scrData.rmode ne 'S' }">
				<div class="inputWrap brdTop">
					<strong class="labelSizeM">사전계획선택</strong>
					<div class="textBox">
						<p class="selectBox1">
							<select name="planItemList" title="사전계획선택" onchange="javascript:reload.planSelect();">
								<option value=",,,,,,,">신규 등록</option>
								<c:forEach var="items" items="${planList}" varStatus="status">
									<c:if test="${items.planid eq dataSpend.planid }">
									<option value="${items.planid },${items.edutitle },${items.edukind },${items.spenddate },${items.personcount },${items.plancount },${items.place },${items.edudesc }" selected>${items.optionname }</option>
									</c:if>
									<c:if test="${items.planid ne dataSpend.planid }">
									<option value="${items.planid },${items.edutitle },${items.edukind },${items.spenddate },${items.personcount },${items.plancount },${items.place },${items.edudesc }" >${items.optionname }</option>
									</c:if>
								</c:forEach>
							</select>
						</p>
					</div>
				</div>
				</c:if>
				<div class="inputWrap">
					<strong class="labelSizeM">교육명</strong>
					<div class="textBox"><input type="hidden" title="계획서 아이디" id="setData0" name="planid" value="${dataSpend.planid }" />
					                     <input type="text" title="교육명" class="inputWFull requd" id="setData1" name="edutitle" value="${dataSpend.edutitle }" <c:if test="${scrData.rmode eq 'S' }">readonly</c:if> maxlength="50" oninput="maxLengthCheck(this)" /></div>
				</div>
				<div class="inputWrap">
					<strong class="labelSizeM">교육종류</strong>
					<div class="textBox">
						<p class="selectBox1">
							<select title="교육종류" id="setData2" name="edukind" class="requd" <c:if test="${scrData.rmode eq 'S' }">disabled</c:if>>
								<option value="">교육종류 선택</option>
								<ct:code type="option" majorCd="edukind" selectAll="false"  selected="${dataSpend.edukind }" />
							</select>
						</p>
					</div>
				</div>
				<div class="inputWrap">
					<strong class="labelSizeM">교육일자</strong>
					<div class="textBox"><input type="date" title="교육일자" id="setData3" name="spendDt" class="inputDate requd" value="${dataSpend.spenddate }" <c:if test="${scrData.rmode eq 'S' }">readonly</c:if> /> </div>
				</div>
				<div class="inputWrap">
					<strong class="labelSizeM">예상인원</strong>
					<div class="textBox">
						<p class="unit"><input type="number" id="setData4" name="personcount" class="requd" title="예상인원" value="${dataSpend.personcount }" <c:if test="${scrData.rmode eq 'S' }">readonly</c:if> maxlength="5" oninput="maxLengthCheck(this)" /><em>명</em></p>
					</div>
				</div>
				<div class="inputWrap">
					<strong class="labelSizeM">횟수</strong>
					<div class="textBox">
						<p class="unit"><input type="number" id="setData5" name="plancount" class="requd" title="횟수" value="${dataSpend.plancount }" <c:if test="${scrData.rmode eq 'S' }">readonly</c:if> maxlength="3" oninput="maxLengthCheck(this)" /><em>회</em></p>
					</div>
				</div>
				<div class="inputWrap">
					<strong class="labelSizeM">교육장소(선택)</strong>
					<div class="textBox"><input type="text" id="setData6" name="place" class="" title="교육장소(선택)" value="${dataSpend.place }" <c:if test="${scrData.rmode eq 'S' }">readonly</c:if> maxlength="50" oninput="maxLengthCheck(this)" /></div>
				</div>
				<!-- @edit 20160705 디자인 수정사항 적용 brdB 클래스 추가 -->
				<div class="inputWrap brdB">
					<strong class="labelSizeM">교육설명(선택)</strong>
					<div class="textBox"><input type="text" title="교육설명(선택)" id="setData7" name="edudesc" class="" value="${dataSpend.edudesc }" <c:if test="${scrData.rmode eq 'S' }">readonly</c:if> maxlength="50" oninput="maxLengthCheck(this)" /></div>
				</div>
				<div class="btnWrap bNumb3">
					<c:if test="${scrData.rmode ne 'S' }">
						<c:if test="${scrData.rmode ne 'I' }">
							<span><c:if test="${updateYN eq 'Y'}"><a href="javascript:;" class="btnBasicGL" id="btnSpendCancel" onclick="javascript:btnEvent.nomalSpendDelete();" >삭제</a></c:if></span>
						</c:if>
					<span><a href="javascript:;" class="btnBasicGL" id="btnSpendCancel" onclick="javascript:btnEvent.nomalSpendCancel();" >취소</a></span>
					<span><c:if test="${updateYN eq 'Y'}"><a href="javascript:;" class="btnBasicBL" id="btnSpendInsert" onclick="javascript:btnEvent.nomalSpendInsert();" >저장</a></c:if></span>
					</c:if>
					<c:if test="${scrData.rmode eq 'S' }">
					<span><a href="javascript:;" class="btnBasicGL" onclick="javascript:btnEvent.nomalSpendOk();" >확인</a></span>
					</c:if>
				</div>
			</section>
		</div>		
	<!-- //교육비 사전계획등록/조회 -->
</section>
<!-- //content area | ### academy IFRAME End ### -->

<%@ include file="/WEB-INF/jsp/framework/include/footer.jsp"%>
