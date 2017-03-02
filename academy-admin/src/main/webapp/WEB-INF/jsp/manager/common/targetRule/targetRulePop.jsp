<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/manager/frame/include/topPop.jsp" %>

<script type="text/javascript">
	var selectMode = {};
	var ruleStVal = "";
	var ruleEdVal = "";

	$(document).ready(function(){
		//저장
		$("#saveBtn").on("click", function (mode, item, idx){
			if($("#targetcodegubun").val() == ""){
				alert("대상자코드구분을 선택하세요");
				return;
			}
			if($("#rulegubun").val() == ""){
				alert("업무구분을 선택하세요");
				return;
			}
			if($("#targetrulename").val() == ""){
				alert("조건명을 입력하세요");
				return;
			}
			if($("#rulescope").val() == ""){
				alert("조건설정을 선택하세요");
				return;
			}
			if($("#targetcodegubun").val() == "agecode"){
				if($("#rulescope").val() == "scope"){
					if($("#agestart").val() == ""){
						alert("이상을 입력하세요.");
						return;
					}
					if($("#ageend").val() == ""){
						alert("이하를 입력하세요.");
						return;
					}
				}
				if($("#rulescope").val() == "over"){
					if($("#agestart").val() == ""){
						alert("이상을 입력하세요.");
						return;
					}
				}
				if($("#rulescope").val() == "under"){
					if($("#ageend").val() == ""){
						alert("이하를 입력하세요.");
						return;
					}
				}
			} else {
				if ($("#rulescope").val() == "scope") {
					if ($("#rulestart").val() == "") {
						alert("이상을 선택하세요.");
						return;
					}
					if ($("#ruleend").val() == "") {
						alert("이하를 선택하세요.");
						return;
					}
				}
				if ($("#rulescope").val() == "over") {
					if ($("#rulestart").val() == "") {
						alert("이상을 선택하세요.");
						return;
					}
				}
				if ($("#rulescope").val() == "under") {
					if ($("#ruleend").val() == "") {
						alert("이하를 선택하세요.");
						return;
					}
				}
			}

			// 저장전 Validation
			if(!confirm("저장하시겠습니까?")){
				return;
			}
			selectMode.mode = "I";
			rulePop.doSave(selectMode.mode);
		});

		$("#rulescope").on("change", function() {
			if($("#rulescope").val() == "scope"){
				$("#rulestart").show();
				$("#ruleend").show();
				$("#agestart").show();
				$("#ageend").show();
			}
			if($("#rulescope").val() == "over"){
				$("#rulestart").show();
				$("#ruleend").hide();
				$("#agestart").show();
				$("#ageend").hide();
			}
			if($("#rulescope").val() == "under"){
				$("#rulestart").hide();
				$("#ruleend").show();
				$("#agestart").hide();
				$("#ageend").show();
			}
		});

		$("#targetcodegubun").on("change", function() {
			$("#nonage").show();
			$("#age").hide();
			if($("#targetcodegubun").val() == "") {
				$("#rulestart").empty();
				$("#ruleend").empty();
				return;
			}
			if($("#targetcodegubun").val() == "agecode"){
				$("#nonage").hide();
				$("#age").show();
				ruleStVal = 0;
				ruleEdVal = 200;
				return;
			}

			var param = {
				targetcodegubun : $("#targetcodegubun").val()
			};

			$.ajaxCall({
				url: "<c:url value="/manager/common/targetRule/targetRuleCode.do"/>"
				, data: param
				, success: function( data, textStatus, jqXHR){
					if(data.result < 1){
						var msg = '<spring:message code="errors.load"/>';
						alert(msg);
						//return;
					} else {
						callCode(data);
					}
				},
				error: function( jqXHR, textStatus, errorThrown) {
					var msg = '<spring:message code="errors.load"/>';
					alert(msg);
				}
			});
			function callCode(data) {
				$("#rulestart").html("");
				$("#rulestart").append( $( '<option>' ).attr( 'value', '' ).html( '이상' ) );

				for(var i=0;i<data.listCode.length; i++) {
					$("#rulestart").append("<option value='"+ data.listCode[i].code +"'>"+ data.listCode[i].name +"</option>");
				}
				ruleStVal = data.listCode[0].code;

				$("#ruleend").html("");
				$("#ruleend").append( $( '<option>' ).attr( 'value', '' ).html( '이하' ) );

				for(var i=0;i<data.listCode.length; i++) {
					$("#ruleend").append("<option value='"+ data.listCode[i].code +"'>"+ data.listCode[i].name +"</option>");
				}
				var endLeng = data.listCode.length;
				ruleEdVal = data.listCode[endLeng-1].code;
			}
		});
	});

  	var rulePop = {
		doSave : function(mode, item, idx){
			var targetrulename = $("#targetrulename").val();

			if(mode == "I") {
				var sUrl = "<c:url value="/manager/common/targetRule/targetRuleInsert.do"/>";
				var sMsg = "등록하였습니다.";
			}
			if($("#targetcodegubun").val() == "agecode"){
				if ($("#rulescope").val() == "scope") {
				//	targetrulename = $("#agestart").val() + " ~ " + $("#ageend").val();
					ruleStVal = $("#agestart").val();
					ruleEdVal = $("#ageend").val();
				}
				if ($("#rulescope").val() == "over") {
				//	targetrulename = "A"+$("#agestart").val();
					ruleStVal = $("#agestart").val();
				}
				if ($("#rulescope").val() == "under") {
				//	targetrulename = "U"+$("#ageend").val();
					ruleEdVal = $("#ageend").val();
				}
			} else {
				if ($("#rulescope").val() == "scope") {
				//	targetrulename = $("#rulestart option:selected").text() + " ~ " + $("#ruleend option:selected").text();
					ruleStVal = $("#rulestart").val();
					ruleEdVal = $("#ruleend").val();
					if(ruleStVal == ""){
						alert("이상 조건설정을 선택하세요");
						return;
					}
					if(ruleEdVal == ""){
						alert("이하 조건설정을 선택하세요");
						return;
					}
				}
				if ($("#rulescope").val() == "over") {
				//	targetrulename = $("#rulestart option:selected").text() + " 이상";
					ruleStVal = $("#rulestart").val();
					if(ruleStVal == ""){
						alert("이상 조건설정을 선택하세요");
						return;
					}
				}
				if ($("#rulescope").val() == "under") {
				//	targetrulename = $("#ruleend option:selected").text() + " 이하";
					ruleEdVal = $("#ruleend").val();

					if(ruleStVal == ""){
						alert("이하 조건설정을 선택하세요");
						return;
					}
				}
			}

			var param = {
				targetcodegubun : $("#targetcodegubun").val(),
				rulegubun : $("#rulegubun").val(),
				targetrulename : targetrulename,
				rulescope : $("#rulescope").val(),
				rulestart : ruleStVal,
				ruleend : ruleEdVal
			};

			$.ajaxCall({
				url: sUrl
				, data: param
				, success: function( data, textStatus, jqXHR){
					if(data.result < 1){
						var msg = '<spring:message code="errors.load"/>';
						alert(msg);
						//return;
					} else if(data.result.errCode == 2) {
						alert("이미 등록된 조건이 있습니다.");
					} else {
						var frmId = $("input[name='frmId']").val();
						alert(sMsg);
						eval($('#ifrm_main_'+frmId).get(0).contentWindow.doReturn());
						closeManageLayerPopup("searchPopup");
					}
				},
				error: function( jqXHR, textStatus, errorThrown) {
					var msg = '<spring:message code="errors.load"/>';
					alert(msg);
				}
			});
		}
	}

</script>

	<div id="popwrap">
		<input type="hidden" name="frmId" value="${layerMode.frmId}"/>
		<!--pop_title //-->
		<div class="title clear">
			<h2 class="fl">
				Window
			</h2>
			<span class="fr"><a href="javascript:;" class="btn_close close-layer">X</a></span>
		</div>
		<!--// pop_title -->
		
		<!-- Contents -->
		<div id="popcontainer"  style="height:270px">
			<div id="popcontent">
				<!-- Sub Title -->
				<div class="poptitle clear">
					<h3>
						대상자 조건 설정
					</h3>
				</div>
				<!--// Sub Title -->
				<form id="saveItem">
				<div class="tbl_write">
					<table id="tblSearch" width="100%" border="0" cellspacing="0" cellpadding="0">
						<colgroup>
							<col width="20%" />
							<col width="80%"  />
						</colgroup>
						<tr>
							<th scope="row" style="text-align: center;">대상자코드구분</th>
							<td>
								<c:if test="${layerMode.mode eq 'I' }">
									<label class="required">
										<select id="targetcodegubun">
											<option value="">선택</option>
											<option value="pincode"  >핀레벨</option>
											<option value="bonuscode">보너스레벨</option>
											<option value="agecode"  >나이</option>
										</select>
									</label>
								</c:if>
								<c:if test="${layerMode.mode eq 'U' }">
									${targetDetail.targetcodegubun}
								</c:if>
							</td>
						</tr>
						<tr>
							<th scope="row" style="text-align: center;">업무구분</th>
							<td>
								<c:if test="${layerMode.mode eq 'I' }">
									<label class="required">
										<select id="rulegubun">
											<option value="">전체</option>
											<option value="1">예약서비스</option>
											<option value="2">교육</option>
										</select>
									</label>
								</c:if>
								<c:if test="${layerMode.mode eq 'U' }">
									${targetDetail.rulegubun}
								</c:if>
							</td>
						</tr>
						<tr>
							<th scope="row" style="text-align: center;">조건명</th>
							<td>
								<c:if test="${layerMode.mode eq 'I' }">
									<input type="text" class="required" id="targetrulename" name="targetrulename"/>
								</c:if>
								<c:if test="${layerMode.mode eq 'U' }">
									${targetDetail.targetrulename}
								</c:if>
							</td>
						</tr>
						<tr>
							<th scope="row" style="text-align: center;">조건 설정</th>
							<td>
								<c:if test="${layerMode.mode eq 'I' }">
									<label class="required">
										<select style="min-width: 150px;" id="rulescope">
											<option value="">선택</option>
											<option value="scope">범위</option>
											<option value="over" >이상</option>
											<option value="under">이하</option>
										</select>
									</label>
									<span id="nonage">
										<label>
											<select style="min-width: 150px;" id="rulestart">
												<option value="">선택</option>
											</select>
										</label>
										~
										<label>
											<select style="min-width: 150px;" id="ruleend">
												<option value="">선택</option>
											</select>
										</label>
									</span>
									<span id="age" style="display: none;">
										<label>
											<input type="text" id="agestart"/>
										</label>
										~
										<label>
											<input type="text" id="ageend"/>
										</label>
									</span>
								</c:if>
								<c:if test="${layerMode.mode eq 'U' }">
									<label>
										${targetDetail.rulescope}
									</label>
								</c:if>
							</td>
						</tr>
					</table>
				</div>				
				</form>
				<br>
				<div class="btnwrap mb10">
					<c:if test="${layerMode.mode eq 'I' }">
						<a href="javascript:;" id="saveBtn" class="btn_green authWrite">저장</a>
					</c:if>
					&nbsp;
					<button id="closebTn"  class="btn_close close-layer" >닫기</button>
				</div>
			</div>
		</div>
	</div>
