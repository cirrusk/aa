<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/framework/include/mobile/header.jsp" %>

<!-- //Adobe Analytics Header 호출 include -->
<%@ include file="/WEB-INF/jsp/framework/include/inc_analyticsHeader.jsp"%>

<script type="text/javascript">
$(document.body).ready(function() {
	//스크롤 사이즈
	abnkorea_resize();
	
	// 계획서 활성화
	$(".onlyNum").on("keyup", function(){
		$(this).val($(this).val().replace(/[^0-9]/gi,""));
		if(this.value > 999) { this.value = this.value.substring(0,3); } 
	});
	
	
	
	//지출항목 셋팅
	$('.spendItemWrap').spenditemMoblie($("#spendItem0").html());
	
	$(".fileUploadWrap").fileup();
	
	$(".btnFileItemAdd").on("click", function () {
		var num = $(".fileUploadWrap > div").length;
		var addDom = "";
		
		if( !isNull(document.getElementById("file"+num)) ) {
			num = num + "" + 1
		}
		
		addDom += "<div class='textBox'>";
		addDom += "<form id='fileForm"+num+"' method='POST' enctype='multipart/form-data'>";
		addDom += "	<input type='file' class='requd' id='file"+num+"' name='file"+num+"' title='사진 찾기' />";
		addDom += "	<input type='hidden' id='filekey"+num+"' name='filekey' title='파일번호' />";
		addDom += "	<input type='hidden' id='oldfilekey"+num+"' name='oldfilekey' title='파일번호' />";
		addDom += "	<a href='javascript:;' class='btnFileItemDelete'><span>파일삭제</span></a>";
		addDom += "</form>";
		addDom += "</div>";
		
		$(".fileUploadWrap").append(addDom);
		//스크롤 사이즈
		abnkorea_resize();
	});
	
	// 교육비 표기
	$("#trfee").text(setComma($("#trainingFeeForm > input[name='trfee']").val()));
	
	reload.init($("#trainingFeeForm > input[name='okdata']").val());
});

var reload = {
	init : function(okdata) {
		var searchData = okdata.split(',');
		var htmlYear = "";
		var htmlMonth = "";
		var pitem = "";
		var citem = "";
		var sGiveyear  = $("#trainingFeeForm > input[name='giveyear']").val();
		var sGivemonth = $("#trainingFeeForm > input[name='givemonth']").val();
		
		$(searchData).each(function(num, val){
			pitem = val.substring(1,5);
			if(citem!=pitem) {
				if(sGiveyear==pitem) {
					htmlYear += "<option value='"+pitem+"' selected>"+pitem+"년</option>";
				} else {
					htmlYear += "<option value='"+pitem+"'>"+pitem+"년</option>";
				}
				citem = pitem;
			}
			if(sGivemonth==val.slice(5)) {
				htmlMonth += "<option value='"+val.slice(5)+"' selected>"+val.slice(5)+"월</option>";
			} else {
				htmlMonth += "<option value='"+val.slice(5)+"'>"+val.slice(5)+"월</option>";
			}
		});
		
// 		$("#searchYear").html(htmlYear);
		$("#searchMonth").html(htmlMonth);
	},
	searchYear : function() {
		$("#trainingFeeForm > input[name='giveyear']").val($("#searchYear").val());
		$("#trainingFeeForm").attr("action", "/mobile/trainingFee/trainingFeePlan.do")
		$("#trainingFeeForm").submit();
	},
	searchMonth : function() {
		$("#trainingFeeForm > input[name='givemonth']").val($("#searchMonth").val());
		$("#trainingFeeForm").attr("action", "/mobile/trainingFee/trainingFeePlan.do")
		$("#trainingFeeForm").submit();
	},
	pagego : function(){
		$("#trainingFeeForm").attr("action", "/mobile/trainingFee/trainingFeeIndex.do")
		$("#trainingFeeForm").submit();
	},
	planPop : function() {
		$("#trainingFeeForm > input[name='mode']").val("I");
		$("#trainingFeeForm").attr("action", "/mobile/trainingFee/trainingFeePlanInsert.do")
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
		// ok
		if($("#trainingFeeForm > input[name='planstatus']").val()=="Y") {
			$("#trainingFeeForm > input[name='mode']").val("S");
		} else {
			$("#trainingFeeForm > input[name='mode']").val("U");
		}
		$("#trainingFeeForm > input[name='sortnum']").val(sortnum);
		$("#trainingFeeForm > input[name='planid']").val(planid);
		$("#trainingFeeForm").attr("action", "/mobile/trainingFee/trainingFeePlanUpdate.do")
		$("#trainingFeeForm").submit();
	}
}

var btnEvent = {
		nomalPlanCancel : function() {
			var result = confirm("사전계획서 입력을 취소 하시겠습니까?");
			
			if(result){
				$("#trainingFeeForm").attr("action", "/mobile/trainingFee/trainingFeePlan.do")
				$("#trainingFeeForm").submit();
			}
		},
		rentCancel : function() {
			var result = confirm("임대차지출 입력을 취소 하시겠습니까?");
			
			if(result){
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
			
			var sRentDeposit = $("#rentDeposit").val().replace(/,/g, "");
			var sRentamount = $("#rentAmount").val().replace(/,/g, "");
			
			var result = confirm("임대차지출 작성 내용을 저장 하시겠습니까?");
			
			if(result){
				// 첨부파일 전송 후 첨부파일 키값 받아 온다.
				$("#fileUpload").ajaxForm({
						url : "<c:url value="/trfee/common/file/fileUpLoad.do"/>"
					  , method : "post"
						, async : false
						, beforeSend: function(xhr, settings) { showLoading(); }
						, complete: function (xhr, textStatus) {  }
						, success : function(data){							
							var item = data.result;
							var param = {  tabType     : "rent"
									      ,rentDeposit : sRentDeposit 
									      ,rentamount  : sRentamount 
									      ,renttitle   : $("#renttitle").val()
									      ,rentfrommonth : $("#rentFromDt").val()
									      ,renttomonth   : $("#rentToDt").val()  
									      ,attachfile  : item.fileKey
									      ,giveyear   : $("#trainingFeeForm > input[name='giveyear']").val()
										  ,givemonth  : $("#trainingFeeForm > input[name='givemonth']").val()
									 };
							
							// 첨부파일 전송 완료 후 저장
							btnEvent.savePlan(param);
							
						}, error : function(data){
							hideLoading();	//로딩 끝
							alert("처리도중 오류가 발생하였습니다.");
						}
					}).submit();
			}
			
		},
		savePlan : function(param) {
			$("#trainingFeeForm > input[name='mode']").val("I");
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
						$("#trainingFeeForm > input[name='mode']").val("R");
						alert(data.result.errMsg);
						$("#trainingFeeForm").attr("action", "/mobile/trainingFee/trainingFeePlan.do")
						$("#trainingFeeForm").submit();
					}					
				},
				error : function(jqXHR, textStatus, errorThrown) {
					alert("처리도중 오류가 발생하였습니다.");
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
			var result = confirm("사전 계획서 수정 내역을 취소 하시겠습니다.");
			
			if(result){
				$("#trainingFeeForm").attr("action", "/mobile/trainingFee/trainingFeeIndex.do")
				$("#trainingFeeForm").submit();
			}
		},
		resultSave : function(defaultParam, msgText) {
			$.ajaxCall({
				url : "<c:url value="/mobile/trainingFee/saveTrainingFeePlanConfirm.do"/>",
				data : defaultParam,
				success : function(data, textStatus, jqXHR) {
					if( data.result.errCode < 1 ) {
						alert("처리도중 오류가 발생하였습니다.");
					} else {
						$("#trainingFeeForm > input[name='mode']").val("S");
						$("#trainingFeeForm").attr("action", "/mobile/trainingFee/trainingFeePlan.do")
						$("#trainingFeeForm").submit();
						alert(msgText);
					}					
				},
				error : function(jqXHR, textStatus, errorThrown) {
					alert("처리도중 오류가 발생하였습니다.");
				}
			});
		}
}

</script>

<section id="pbContent" class="bizroom">
<!-- content area | ### academy IFRAME Start ### -->
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
		<h2 class="titTop">교육비 사전계획등록/조회 <a href="javascript:reload.pagego();" class="btnTbl">교육비관리 목록</a></h2>
		<c:set var="grouplistcount" value="0"></c:set>
		<c:set var="personlistcount" value="0"></c:set>
		<div class="inquiryWrap nobrd">
			<div class="inquiryBox">
				<div class="inputBox">
					<p class="selectBox">
						<c:if test="${scrData.mode ne 'S' }">
							<select class="year" id="searchYear" title="년도" onchange="reload.searchYear();">
								<ct:code type="option" majorCd="schYear" selectAll="false" selected="${scrData.giveyear }"  />
							</select>
							<select class="month" title="월" id="searchMonth" onchange="reload.searchMonth();">
							</select>
						</c:if>
						<c:if test="${scrData.mode eq 'S' }">
							<span>${scrData.giveyear }년도 ${scrData.givemonth }월</span>
						</c:if>
					</p>
				</div>
			</div>
		</div>
		
		<div class="planningWrap">
			<div class="planningBox">
				<p><c:if test="${scrData.procType eq 'person' }">개인</c:if>
				   <c:if test="${scrData.procType eq 'group' }">그룹</c:if> 교육비 <strong id="trfee">10,000,000</strong>원 <c:if test="${scrData.trfeetype eq 'NOTFOUND' }">예상</c:if></p>
				<c:if test="${scrData.mode ne 'S' and scrData.planstatus eq 'N' and scrData.processstatus ne 'Y' }">
					<div class="btnWrap bNumb1">
						<a href="#uiLayerPop_mTFadd01" class="btnBasicGL" onclick="reload.planPop();">+ 계획추가</a>
					</div>
				</c:if>
			</div>
			
			<div class="planningBox2">
				<c:if test="${!empty planList}">
					<c:forEach var="items" items="${planList}" varStatus="status">
						<c:if test="${items.sortnum eq 9999 }">
							<div class="planningConBox">
								<p><span>총예상금액 :</span> <span>${items.spendamount}원</span></p>
								<p><span>총비율 :</span> <span>${items.rate}%</span></p>
							</div>
						</c:if>
					</c:forEach>
					<c:forEach var="items" items="${planList}" varStatus="status">
						<c:if test="${items.sortnum ne 9999 }">
							<dl>
								<dt><a href="javascript:html.clickPlanList('${items.sortnum}','${items.planid}','${items.spenddt }');">
									<c:if test="${items.plantype eq 'group' }">(그룹)<c:set var="grouplistcount" value="1"></c:set></c:if>
									<c:if test="${items.plantype eq 'person' }">(개인)<c:set var="personlistcount" value="1"></c:set></c:if>
								<span>${items.edutitle}<c:if test="${items.sortnum eq 0 }">-${items.planid}</c:if></span> <span class="btnDetail">상세보기</span></a></dt>
								<dd><span>일자</span><span>${items.spenddt }</span></dd>
								<dd><span>교육종류</span><span>${items.edukindname}</span></dd>
								<dd><span>횟수</span><span>${items.plancount}회</span></dd>
								<dd><span>예상금액</span><span>${items.spendamount}</span></dd>
								<dd><span>비율</span><span>${items.rate}</span></dd>
							</dl>
						</c:if>
					</c:forEach>
					<c:if test="${scrData.processstatus ne 'Y' and scrData.spendstatus ne 'Y' }">
						<c:if test="${scrData.planstatus ne 'Y'}">
							<p class="listWarning mgtSs">※ 사전계획 등록은 '교육비 제출' 전까지 수정이 가능합니다. 교육내용 수정을 원하시면, 교육명을 선택하여 수정해 주세요.</p>
						</c:if>
						<c:if test="${scrData.diffSpendAmount > 100000 }">
							<div class="footMsg">
								<p>교육비와 등록 금액의 차이가 ${scrData.diffSpendAmountTxt }원 입니다. 계획을 추가하여 주시기 바랍니다.</p>
								<c:set var="diffSpendAmount" value="${scrData.diffSpendAmount}"></c:set>
							</div>
						</c:if>
						<c:if test="${scrData.diffSpendAmount <= 100000 and scrData.planstatus ne 'Y' }"> 
							<div class="btnWrap bNumb1">
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
						<c:if test="${scrData.planstatus eq 'Y'}">
							<c:if test="${scrData.procType eq 'person' }">
				 				<c:if test="${personlistcount eq 1}">
								<div class="btnWrap bNumb2">
									<a href="javascript:btnEvent.resultCancel()" class="btnBasicGL">취소</a>
									<a href="javascript:btnEvent.resultUpdate()" class="btnBasicBL">계획수정</a>
								</div>
								</c:if>
				 			</c:if>
							<c:if test="${scrData.procType eq 'group' }">
								<div class="btnWrap bNumb2">
									<a href="javascript:btnEvent.resultCancel()" class="btnBasicGL">취소</a>
									<a href="javascript:btnEvent.resultUpdate()" class="btnBasicBL">계획수정</a>
								</div>
				 			</c:if>
						</c:if>
					</c:if>
				</c:if>
				
				<c:if test="${empty planList}">
				<!-- 사전 계획 등록 전 메세지 -->
				<p class="beforMsg">사전 계획을 등록해 주세요.</p>
				</c:if>
			</div>
		</div>
		
	</div>
</section>
<!-- //content area | ### academy IFRAME End ### -->
<!-- //Adobe Analytics Footer 호출 include -->
<%@ include file="/WEB-INF/jsp/framework/include/inc_analyticsFooter.jsp"%>
<%@ include file="/WEB-INF/jsp/framework/include/footer.jsp"%>
