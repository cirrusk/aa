<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<script type="text/javascript">

function changePartnertLayerPop(){
	var param = {
		  rsvseq : $("input[name = rsvseq]").val()
		, purchasedate : $("input[name = purchasedate]").val()
		, ppseq : $("input[name = ppseq]").val()
		, partnerTypeCode : $("input:radio[name = partnerTypeCode]:checked").val()
	};
	
	if(confirm("동반인 구분을 수정 하시겠습니까?") == true){
		$.ajax({
			url: "<c:url value="/mobile/reservation/changePartnertAjax.do"/>"
			, type : "POST"
			, data: param
			, success: function(data, textStatus, jqXHR){
				
				if(data.msg == "success"){
					$("#uiLayerPop_alter").hide();
					
					alert("정상적으로 처리 완료 되었습니다.");
					$("#expInfoForm").attr("action", "/mobile/reservation/expInfoDetailList.do");
					$("#expInfoForm").submit();
				}else{
					alert("처리 도중 에레가 발생 되었습니다.");
				}
				
			},
			error: function( jqXHR, textStatus, errorThrown) {
				alert("처리도중 오류가 발생하였습니다.");
			}
		});
	}else{
		return false;
	}
}

function cancelExpRsvLayerPop(){
	
	var param = {
			  rsvseq : $("input[name = rsvseq]").val()
			, expsessionseq : $("input[name = expsessionseq]").val()
			, reservationdate : $("input[name = reservationdate]").val()
			, ppseq : $("input[name = ppseq]").val()
			, expseq : $("input[name = expseq]").val()
			, typecode : $("input[name = typecode]").val()
		};
		
		if(confirm("예약 취소를 하시겠습니까?") == true){
			$.ajax({
				url: "<c:url value="/mobile/reservation/updateCancelCodeAjax.do"/>"
				, type : "POST"
				, data: param
				, success: function(data, textStatus, jqXHR){
					
					try{
						alert("예약이 취소되었습니다.");
						
						/*--------------------부모창 새로고침---------------------------------------*/
							
						if($("input[name=parentInfo]").val() == "D"){
							
							if(data.msg == "success"){
								$("#uiLayerPop_cancel").hide();
								
								alert("정상적으로 처리 완료 되었습니다.");
								
								$("#expInfoForm").attr("action", "/mobile/reservation/expInfoDetailList.do");
								$("#expInfoForm").submit();
							}
						}else if($("input[name=parentInfo]").val() == "CAL"){
							/* 캘린더 부모 함수 호출 */
							var popYear = $("#popYear").val();
							var popMonth = $("#popMonth").val();
							var popDay = $("#popDay").val();
							var dayFlag = "C";
							
							viewTypeCalendar();
						}
						
						/*-----------------------------------------------------------------*/
						
					}catch(e){
						//console.log(e);
					}
					
				},
				error: function( jqXHR, textStatus, errorThrown) {
					alert("처리도중 오류가 발생하였습니다.");
				}
			});
		}else{
			return false;
		}
	
}

function cancelPop(obj){
	$(obj).parent().parent().parent().parent().hide();
	$("#layerMask").remove();
}

</script>

<div class="pbLayerPopup" id="uiLayerPop_cancel" tabindex="0" style="display: block; top: 271px;">
	<div class="pbLayerHeader">
		<strong>예약취소</strong>
	</div>
	<div class="pbLayerContent">
		
		<div class="cancelWrap">
			<p>예약을 취소하시겠습니까?</p>
			<!-- 무료예약의 경우 -->
			
			<!-- 20160714 페널티 수정 -->
			<p class="bdBox" id="cancelMsg">취소 시 페널티가 적용됩니다.</p>
		</div>
		
		<div class="btnWrap aNumb2">
			<span><a href="#none" class="btnBasicGL" onclick="javascript:cancelPop(this);">취소</a></span>
			<span><a href="#none" class="btnBasicBL" onclick="javascirpt:cancelExpRsvLayerPop();">확인</a></span>
		</div>
	</div>
	
	<a href="#none" class="btnPopClose"><img src="/_ui/mobile/images/common/btn_close.gif" alt="창 닫기"></a>
</div>


<div class="pbLayerPopup" id="uiLayerPop_alter" style="display: block; top: 334px;" tabindex="0">
	<div class="pbLayerHeader">
		<strong>동반여부 변경</strong>
	</div>
	<div class="pbLayerContent">
		<div class="radioList mgAuto">
			<c:forEach var="item" items="${partnerTypeCodeList}">
				<span><input type="radio" id="cpRadio1" name="partnerTypeCode" value="${item.commonCodeSeq}"/><label for="cpRadio1">${item.codeName}</label></span>
			</c:forEach>
		</div>
		
		<div class="btnWrap aNumb2">
			<span><a href="#" class="btnBasicGL" onclick="javascript:cancelPop(this);">변경취소</a></span>
			<span><a href="#" class="btnBasicBL" onclick="javascript:changePartnertLayerPop();">변경완료</a></span>
		</div>
	</div>
	<a href="#none" class="btnPopClose"><img src="/_ui/mobile/images/common/btn_close.gif" alt="창 닫기"></a>
</div>