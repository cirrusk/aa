<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/jsp/framework/include/header.jsp" %>
<%@ include file="/WEB-INF/jsp/framework/include/layerPop.jsp" %>

<script type="text/javascript">

$(document.body).ready(function(){
	
// 	$(".btnBasicBL").on("click", function(){

		
// 	});
	
	$(".btnBasicGL").on("click", function(){
		
		try{
// 			window.opener.location.reload();
			self.close();
		}catch(e){
			//console.log(e);
		}
	});
	
});



/*
 * 필수 입력값 체크 및 확인
 */
var mendatoryCheck = {
		
	partnerSelectbox : function(){
		
		var mendatoryCheckForSelectBox = false;
		
		$("select[name=partnerTypeCode]").each(function(){
			if(0 == $(this).val().length){
				mendatoryCheckForSelectBox = true;
			}
		});
		
		if(mendatoryCheckForSelectBox){
			alert("동반여부는필수 선택 입니다.");
			return false;
		}else{
			return true;
		}
	}
};

function expSkinInsert(){
	
	if(!mendatoryCheck.partnerSelectbox()){
		return;
	}
	
	$(".btnBasicBL").removeAttr("onclick");
	
	var param = $("#expForm").serialize();
	 
	$.ajax({
		url: "<c:url value='/reservation/expSkinInsertAjax.do' />"
		, type : "POST"
		, data: param
		, success: function(data, textStatus, jqXHR){
			
// 			console.log(data);
			
			if("false" == data.possibility){
				alert(data.reason);
				return false;
			}else{
				var expSkinRsvList = data.expSkinRsvInfoList;
				var totalCnt = data.totalCnt;
				if(expSkinRsvList[0].msg == "false"){
					alert(expSkinRsvList[0].reason);
					return false;
				}else{
					/* 부모창으로  예약한 데이터 전달 */
					try{
						window.opener.$("#transactionTime").val(data.transactionTime);
						window.opener.expSkinRsvDetail(expSkinRsvList, totalCnt);
						self.close();
					}catch(e){
						//console.log(e);
					}
				}
				
			}
		},
		error: function( jqXHR, textStatus, errorThrown) {
			var mag = '<spring:message code="errors.load"/>';
			alert(mag);
			
			$(".btnBasicBL").attr("onclick", "javascript:expSkinInsert()");
		}
	});
}
</script>
</head>
<body>
<form id="expForm" name="expForm" method="post">

	<div id="pbPopWrap">
		<header id="pbPopHeader">
			<h1><img src="/_ui/desktop/images/academy/h1_w020500080.gif" alt="예약정보 확인" /></h1>
		</header>
		<a href="javascript:self.close();" class="btnPopClose"><img src="/_ui/desktop/images/common/btn_close.gif" alt="팝업창 닫힘" /></a>
		<section id="pbPopContent">
				
			<span class="resvItem"><c:out value="${expSkinRsvInfoList[0].ppName}"/><em>|</em>피부 측정</span>
			
			<table class="confirmTbl">
				<caption>예약정보 확인</caption>
				<colgroup>
					<col style="width:35%" />
					<col style="width:35%" />
					<col style="width:30%" />
				</colgroup>
				
				<thead>
				<tr>
					<th scope="col">날짜</th>
					<th scope="col">체험시간</th>
					<th scope="col">동반여부</th>
				</tr>
				</thead>
				<tfoot>
				<tr>
					<td colspan="3" class="total textR"><strong>총 ${totalCnt} 건</strong></td>
				</tr>
				</tfoot>
				<tbody>
					<c:forEach items="${expSkinRsvInfoList}" var="item">
						<tr>
							<td>
								${item.dateFormat}
								<input type="hidden" name="ppSeq" value="${item.ppSeq}">
								<input type="hidden" name="sessionTime" value="${item.sessionTime}">
								<input type="hidden" name="typeSeq" value="${item.typeSeq}">
								<input type="hidden" name="expsessionseq" value="${item.expsessionseq}">
								<input type="hidden" name="reservationDate" value="${item.reservationDate}">
								<input type="hidden" name="dateFormat" value="${item.dateFormat}">
								<input type="hidden" name="rsvflag" value="${item.rsvflag}">
								<input type="hidden" name="expseq" value="${item.expseq}">
								<input type="hidden" name="startdatetime" value="${item.startdatetime}">
								<input type="hidden" name="enddatetime" value="${item.enddatetime}">
								<input type="hidden" name="ppName" value="${item.ppName}">
								<input type="hidden" name="accounttype" value="A01">
							</td>
							<td>
								${item.sessionTime}
							</td>
							<td>
								<select title="동반인 선택" class="tdSel" name="partnerTypeCode">
									<option value="">선택</option>
									<c:forEach items="${partnerTypeCodeList}" var="codeList">
										<option value="${codeList.commonCodeSeq}">${codeList.codeName}</option>
									</c:forEach>
								</select>
							</td>
						</tr>
					</c:forEach>
				</tbody>
			</table>
			
			<p class="textC popupBText">위의 정보가 맞으면 [예약확정] 버튼을 눌러 주세요.<br/>[예약확정] 하셔야 정상적으로 예약이 완료됩니다.</p>
			
			<div class="btnWrapC">
				<input type="button" class="btnBasicGL" value="예약취소" />
				<input type="button" class="btnBasicBL" onclick="javascript:expSkinInsert();" value="예약확정" />
			</div>
		
		</section>
	</div>
</form>

		
<!-- 	<div class="skipNaviReturn"> -->
<%@ include file="/WEB-INF/jsp/framework/include/footer.jsp" %>