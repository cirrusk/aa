<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/framework/include/mobile/header.jsp" %>

<script type="text/javascript">
$(document.body).ready(function() {
	// 계획서 활성화
	$(".onlyNum").on("keyup", function(){
		$(this).val($(this).val().replace(/[^0-9]/gi,""));
		if(this.value > 999) { this.value = this.value.substring(0,3); } 
	});
	
	//지출항목 셋팅
	$('.spendItemWrap').spendItemsMoblie($("#spendItem0").html());
	
	$(".fileupWrap").fileup();

	$("#trfee").text(setComma($("#trainingFeeForm > input[name='trfee']").val()));
	reload.init($("#trainingFeeForm > input[name='okdata']").val());
	
	//스크롤 사이즈
	abnkorea_resize();
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
		$("#trainingFeeForm").attr("action", "/mobile/trainingFee/trainingFeeSpend.do")
		$("#trainingFeeForm").submit();
	},
	searchMonth : function() {
		$("#trainingFeeForm > input[name='givemonth']").val($("#searchMonth").val());
		$("#trainingFeeForm").attr("action", "/mobile/trainingFee/trainingFeeSpend.do")
		$("#trainingFeeForm").submit();
	},
	pagego : function(){
		$("#trainingFeeForm").attr("action", "/mobile/trainingFee/trainingFeeIndex.do")
		$("#trainingFeeForm").submit();
	},
	planSelect : function() {
		var datasplit = $("select[name='planItemList']").val().split(",");
		
		$(datasplit).each(function(num, val){
			$("#setData"+num).val(val);
		});
	},
	spendInsert : function() {
		$("#trainingFeeForm > input[name='mode']").val("I");
		$("#trainingFeeForm > input[name='rmode']").val("I");
		$("#trainingFeeForm").attr("action", "/mobile/trainingFee/trainingFeeSpendUpdate.do")
		$("#trainingFeeForm").submit();
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
		$("#trainingFeeForm > input[name='sortnum']").val(sortnum);
		$("#trainingFeeForm > input[name='spendid']").val(planid);
		
		var spendstatus   = $("#trainingFeeForm > input[name='spendstatus']").val();
		var planstatus    = $("#trainingFeeForm > input[name='planstatus']").val();
		var processstatus = $("#trainingFeeForm > input[name='processstatus']").val();
		var editYn        = $("#trainingFeeForm > input[name='editYn']").val();
		
		if(planstatus=="Y"&&spendstatus=="N"&&processstatus=="N"&&editYn=="Y") {
			$("#trainingFeeForm > input[name='rmode']").val("U");
		} else if(planstatus=="Y"&&spendstatus=="Y"&&processstatus=="N"&&editYn=="Y") {
			$("#trainingFeeForm > input[name='rmode']").val("S");
		} else if(planstatus=="Y"&&spendstatus=="Y"&&processstatus=="R") {
			$("#trainingFeeForm > input[name='rmode']").val("U");
		} else if(planstatus=="Y"&&spendstatus=="N"&&processstatus=="N"&&editYn=="Y") {
			$("#trainingFeeForm > input[name='rmode']").val("U");
		} else if(planstatus=="Y"&&spendstatus=="N"&&processstatus=="R"&&editYn=="Y") {
			$("#trainingFeeForm > input[name='rmode']").val("U");
		} else {
			$("#trainingFeeForm > input[name='rmode']").val("S");
		}
				
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
				$("#trainingFeeForm > input[name='mode']").val("D");
				var param = {};
				
				btnEvent.saveSpend(param);				
			}
		},
		nomalSpendCancel : function() {
			var result = confirm("입력 하신 지출 내용을 취소 하시겠습니까?");
			
			if(result){
				btnEvent.searchSpend($("#trainingFeeForm > input[name='editYn']").val(), $("#trainingFeeForm > input[name='givemonth']").val());
			}
// 			$("#openTab").hide();
// 			$("#resultDiv").hide();
		},
		nomalSpendInsert : function() {
			if(!chkValidation({chkId:"#setData", chkObj:"hidden|input|select"}) ){
				return;
			}
			
			var sSpendItem = "";
			var sSpendAmount = "";
			var cnt = $(".spendItemWrap > .inputWrap").length;
			
			for( var i=0; i < cnt; i++ ) {
				var objItem   = $(".spendItemWrap > .inputWrap > div > .selectBox1 > select[name='spenditem']")[i].value;
				var objAmount = $(".spendItemWrap > .inputWrap > div > .unit > input[name='spendAmount']")[i].value;
				var objFile   = $(".spendItemWrap > .inputWrap > div > p > input[type='file']")[i].value;
				var unCommaTxt = objAmount.replace(/,/g, "");
				
				if(isNull(objFile)){
					alert("지출영수증 파일을 선택 해 주세요.");
					return;
				} else {
						var chkData = {
								"chkFile" : "gif,png,jpg,jpeg"
						};
						
						var ext = objFile.split('.').pop().toLowerCase();
						var opts = $.extend({},chkData);
						
						if(opts.chkFile.indexOf(ext) == -1) {
							alert(opts.chkFile + ' 파일만 업로드 할수 있습니다.');
							return;
						}
						
				}
				
				if(isNull(objItem)){
					alert("지출항목을 선택 해 주세요.");
					return;
				}
				
				if(isNull(objAmount)){
					alert("지출금액을 입력 해 주세요.");
					return;
				}
				
				if(i==0) {
					sSpendItem   = objItem;
					sSpendAmount = unCommaTxt;
				} else {
					sSpendItem   = sSpendItem + "," + objItem;
					sSpendAmount = sSpendAmount + "," + unCommaTxt;
				}
			}
			
			var result = confirm("지출증빙 작성 내용을 저장 하시겠습니까?");
			
			if(result){
				$("#fileUpload").ajaxForm({
				  	  url : "<c:url value="/mobile/trainingFee/fileUpLoadSpend.do"/>"
				    , method : "post"
					, async : false
					, beforeSend: function(xhr, settings) { showLoading(); }
					, success : function(data){
						var item = data.result;
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
								      ,attachfile  : item.fileKey
								 };
						
						// 첨부파일 전송 완료 후 저장
						btnEvent.saveSpend(param);
					}
					, error : function(data){
							alert("[파일업로드] 처리도중 오류가 발생하였습니다.");
					}
				}).submit();
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
			
			$.extend(defaultParam, param);
			
			$.ajaxCall({
				url : "<c:url value="/mobile/trainingFee/saveTrainingFeeSpend.do"/>",
				data : defaultParam,
				success : function(data, textStatus, jqXHR) {
					var item = data.result;
					
					if( data.result.errCode < 1 ) {
						alert("처리도중 오류가 발생하였습니다.");
					} else {
						$("#trainingFeeForm > input[name='mode']").val("R");
						alert("지출증빙 저장 완료 하였습니다.");
						$("#trainingFeeForm").attr("action", "/mobile/trainingFee/trainingFeeSpend.do")
						$("#trainingFeeForm").submit();
					}
				},
				error : function(jqXHR, textStatus, errorThrown) {
					alert("[error] 처리도중 오류가 발생하였습니다.");
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
				url : "<c:url value="/mobile/trainingFee/saveTrainingFeeSpendConfirm.do"/>",
				data : defaultParam,
				success : function(data, textStatus, jqXHR) {
					if( data.result.errCode < 1 ) {
						alert("처리도중 오류가 발생하였습니다.");
					} else {
						$("#trainingFeeForm > input[name='mode']").val("S");
						alert(msgText);
						$("#trainingFeeForm").attr("action", "/mobile/trainingFee/trainingFeeSpend.do")
						$("#trainingFeeForm").submit();
					}					
				},
				error : function(jqXHR, textStatus, errorThrown) {
					alert("처리도중 오류가 발생하였습니다.");
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
	},
	dayList : function() {
		LastDayOfMonth($("#nomalUseYer option:selected").val(), $("#nomalUseMon option:selected").val())
		setSelectMonthDay(LastDayOfMonth($("#nomalUseYer option:selected").val(), $("#nomalUseMon option:selected").val()), "nomalUseDay", $("#trainingFeeForm > input[name='listDay']").val());
	}
}

var page = {
		init : function() {
			$("#btnSpendAdd").show();
			$("#openTab").hide();
		},
		saveInit : function() {
			$("#openTab").hide();
			
			
			if( $("#trainingFeeForm > input[name='spendstatus']").val() == "Y" ) {
				$("#btnSpendAdd").show();
			} else {
				$("#btnSpendAdd").show();
			}
			$("#resultDiv").show();
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
		}
}
</script>

<!-- content area | ### academy IFRAME Start ### -->
<section id="pbContent">
	<form id="trainingFeeForm" name="trainingFeeForm" method="post">
		<input type="hidden" name="fiscalyear"    value="${scrData.fiscalyear }"   />
		<input type="hidden" name="giveyear"      value="${scrData.giveyear }"     />
		<input type="hidden" name="givemonth"     value="${scrData.givemonth }"    />
		<input type="hidden" name="okdata"        value="${scrData.okdata }"       />
		<input type="hidden" name="depaboNo"      value="${scrData.depaboNo }"     />
		<input type="hidden" name="editYn"        value="${scrData.editYn }"       />
		<input type="hidden" name="mode"          value="${scrData.mode }"         />
		<input type="hidden" name="rmode"         value=""                         />
		<input type="hidden" name="targettype"    value="${scrData.targettype }"   />
		<input type="hidden" name="trfee"         value="${scrData.trfee }"        />
		<input type="hidden" name="groupCode"     value="${scrData.groupCode }"    />
		<input type="hidden" name="procType"      value="${scrData.procType }"     />
		<input type="hidden" name="sortnum"       value="${scrData.sortnum }"      />
		<input type="hidden" name="spendid"       value="${scrData.spendid }"      />
		<input type="hidden" name="listDay"       value="${scrData.listDay }"      />
		<input type="hidden" name="spendstatus"   value="${scrData.spendstatus }"  />
		<input type="hidden" name="planstatus"    value="${scrData.planstatus }"   />
		<input type="hidden" name="processstatus" value="${scrData.processstatus }"/>
		<input type="hidden" name="app"           value="${scrData.app }"          />
	</form>
	<c:set var="grouplistcount" value="0"></c:set>
	<div class="mTrainingFee">
		<h2 class="titTop">교육비 지출증빙등록/조회  <a href="javascript:reload.pagego();" class="btnTbl">교육비관리 목록</a></h2>
		
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
				   <c:if test="${scrData.procType eq 'group' }">그룹</c:if> 교육비 <strong id="trfee"></strong>원</p>
				<c:if test="${scrData.mode ne 'S' and scrData.processstatus ne 'Y' and scrData.editYn eq 'Y' and scrData.planstatus eq 'Y' and scrData.targetcnt > 0 }">
					<div class="btnWrap bNumb1">
						<a href="#uiLayerPop_mTFadd02" class="btnBasicGL" onclick="reload.spendInsert();">+ 지출추가</a>
					</div>
				</c:if>
			</div>
			
			<div class="planningBox2">
				<c:if test="${!empty spendList}">
					<c:forEach var="items" items="${spendList}" varStatus="status">
						<c:if test="${items.sortnum eq 9999 }">
						<div class="planningConBox">
							<p><span>총금액 :</span> <span>${items.spendamount}원</span></p>
							<p><span>총비율 :</span> <span>${items.rate}%</span></p>
							<p class="listWarning point2">※ ${scrData.givemonth }월 교육에 해당하는 지출증빙 서류를 등록해 주시기 바랍니다.</p>
						</div>
						</c:if>
					</c:forEach>
					<!-- 리스트 -->
					<c:forEach var="items" items="${spendList}" varStatus="status">
						<c:if test="${items.sortnum ne 9999 }">
						<dl>
								<dt>
								<a href="javascript:html.clickSpendList('${items.sortnum}','${items.planid}','${items.spenddt }');">
								<span>
									<c:if test="${items.plantype eq 'group' }">(그룹)
									<c:set var="grouplistcount" value="1"></c:set>
									</c:if>
									<c:if test="${items.plantype eq 'person' }">(개인)
									<c:set var="personlistcount" value="1"></c:set>
									</c:if>${items.edutitle}<c:if test="${items.sortnum eq 0 }">-${items.planid}</c:if>
								</span>
								<span class="btnDetail">상세보기</span>
								</a></dt>
							<dd><span>일자</span><span>${items.spenddt }</span></dd>
							<dd><span>교육종류</span><span>${items.edukindname}</span></dd>
							<dd><span>금액</span><span>${items.spendamount}원</span></dd>
							<dd><span>비율</span><span>${items.rate}%</span></dd>
							<dd><span>영수증</span><span class="ico_recipt">영수증</span></dd>
						</dl>
						</c:if>
					</c:forEach>
					
					<c:if test="${scrData.mode ne 'S' and scrData.processstatus ne 'Y' and scrData.editYn eq 'Y' and scrData.planstatus eq 'Y' and scrData.targetcnt > 0 }">
						<p class="listWarning mgtSs">※ ${scrData.givemonth }월 교육에 해당하는 지출증빙 서류를 등록해 주세요. 지출증빙은 제출 후 수정이 불가합니다. 정확하게 확인 후 제출해 주세요.</p>
						<c:if test="${scrData.diffSpendAmount > 100000 }">
							<div class="footMsg">
								<!-- @edit 20160711 문구변경 -->
								<p>교육비와 등록 금액의 차이가 ${scrData.diffSpendAmountTxt }원 입니다. 지출증빙을 추가하여 주시기 바랍니다.</p><!-- @edit 20160803 -->
							</div>
						</c:if>
						<c:if test="${scrData.diffSpendAmount <= 100000 }">
							<div class="btnWrap bNumb1">
								<c:if test="${scrData.procType eq 'person' }">
					 				<c:if test="${personlistcount eq 1}">
					 				<a href="javascript:btnEvent.resultconfirm();" class="btnBasicBL">제출</a>
					 				</c:if>
					 			</c:if>
					 			<c:if test="${scrData.procType eq 'group' }">
					 				<a href="javascript:btnEvent.resultconfirm();" class="btnBasicBL">제출</a>
					 			</c:if>
							</div>
						</c:if>
					</c:if>
				</c:if>
				<c:if test="${empty spendList}">
					<!-- 지출증빙 등록 전 메세지 -->
					<p class="beforMsg">지출 증빙을 등록해 주세요.</p>
				</c:if>
			</div>
		</div>
	</div>
	<!-- //교육비 사전계획등록/조회 -->
</section>
<!-- //content area | ### academy IFRAME End ### -->

<%@ include file="/WEB-INF/jsp/framework/include/footer.jsp"%>
