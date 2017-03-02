<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/manager/frame/include/topPop.jsp" %>
		
<script type="text/javascript">	
var imgList = {};
$(document).ready(function(){
	fn_init();
});

function fn_init() {
	
	// 업로드 파일 불러 오기
	$.ajaxCall({
   		url: "<c:url value="/manager/trainingFee/proof/trainingFeeSpendReceiptList.do"/>"
   		, data: $("#lyData").serialize()
   		, success: function( data, textStatus, jqXHR){
   			var totCnt = 0;
   			
   			$.each(data.dataList, function (i,val) {
   				totCnt += 1;
   				imgList[i] = val;
            	if(i==0) {
            		$("#imgTag").val(val.realfilename);
            		if( val.spendtype == "person" ) {
            			$("#spentypeperson").show();	
            			$("#spentypegroup").hide();	
            			$("#pspendamount").text(setComma(val.spendamount));
            		} else {
            			$("#spentypeperson").hide();	
            			$("#spentypegroup").show();	
            			$("#grpamount").text(setComma(val.grpamount));
            			$("#gspendamount").text(setComma(val.spendamount));
            		}
            		$("#edukindname").text(val.edukindname);
            		$("#edutitle").text(val.edutitle);
            		$("#spenddt").text(val.spenddt);
            		saveChecking(1);
            	}
            });
   			$("#totpage").text(totCnt);
   		},
   		error: function( jqXHR, textStatus, errorThrown) {
           	alert("처리도중 오류가 발생하였습니다.");
   		}
   	});
}

var btnEvent = {
		btnNext : function() {
			var num = parseInt($("#pagenum").text());
			var sTag = "";
			
			if( parseInt($("#totpage").text()) < (num + 1) ) {
				alert("영수증이 존재 하지 않습니다.");
			} else {
				$("#pagenum").text((num + 1))
				var items = imgList[num];
				$("#img"+(num)).hide();
				$("#img"+(num+1)).show();
				
        		if( items.spendtype == "person" ) {
        			$("#spentypeperson").show();	
        			$("#spentypegroup").hide();	
        			$("#pspendamount").text(setComma(items.spendamount));
        		} else {
        			$("#spentypeperson").hide();	
        			$("#spentypegroup").show();	
        			$("#grpamount").text(setComma(items.grpamount));
        			$("#gspendamount").text(setComma(items.spendamount));
        		}
        		$("#edukindname").text(items.edukindname);
        		$("#edutitle").text(items.edutitle);
        		$("#spenddt").text(items.spenddt);

        		saveChecking(num+1);
			}
		},
		btnBack : function() {
			var num = parseInt($("#pagenum").text());

			if( (num - 1) == 0 ) {
				alert("영수증이 존재 하지 않습니다.");
			} else {
				$("#pagenum").text((num - 1))
				var items = imgList[(num- 1)-1];
				
				$("#img"+(num)).hide();
				$("#img"+(num-1)).show();

        		if( items.spendtype == "person" ) {
        			$("#spentypeperson").show();
        			$("#spentypegroup").hide();
        			$("#pspendamount").text(setComma(items.spendamount));
        		} else {
        			$("#spentypeperson").hide();	
        			$("#spentypegroup").show();	
        			$("#grpamount").text(setComma(items.grpamount));
        			$("#gspendamount").text(setComma(items.spendamount));
        		}
        		$("#edukindname").text(items.edukindname);
        		$("#edutitle").text(items.edutitle);
        		$("#spenddt").text(items.spenddt);
        		
        		saveChecking(num-1);
			}
		}
}

function saveChecking(num) {
	var param = { giveyear    : $("#lyData input[name='giveyear']").val()
			    , givemonth   : $("#lyData input[name='givemonth']").val()
			    , spendid     : $("#spendid"+num).val()
			    , spenditemid : $("#spenditemid"+num).val() };

	$.ajaxCall({
   		url: "<c:url value="/manager/trainingFee/proof/trainingFeeSpendChecking.do"/>"
   		, data: param
   		, success: function( data, textStatus, jqXHR){
   		},
   		error: function( jqXHR, textStatus, errorThrown) {
           	alert("처리도중 오류가 발생하였습니다.");
   		}
   	});
}

function fn_filedownload(fileKey, uploadSeq) {
	var parm = {
		  work : "TRFEE"
		, fileKey : fileKey
		, uploadSeq : uploadSeq
	};
	
	postGoto("<c:url value="/manager/common/trfeefile/trfeeFileDownload.do"/>", parm);
}
</script>

	<div id="popwrap">
		<!--pop_title //-->
		<div class="title clear">
			<h2 class="fl">교육비 지출증빙 영수증 확인</h2>
			<span class="fr"><a href="javascript:;" class="btn_close close-layer">X</a></span>
		</div>
		<!--// pop_title -->
		
		<!-- Contents -->
		<div id="popcontainer">
			<div id="popcontent">
				<form id="lyData">
					<input type="hidden" name="giveyear"  value="${lyData.giveyear }" />
					<input type="hidden" name="givemonth" value="${lyData.givemonth }" />
					<input type="hidden" name="abono"     value="${lyData.abono }" />
					<input type="hidden" name="frmId"     value="${lyData.frmId }" />
				</form>
				<div style="float:right;padding:5px 5px 5px 5px;">
					<span>총금액 : </span><span>${lyData.totamount}원</span>
				</div>
				<div class="img" style="padding:5px 5px 5px 5px;">
					<c:forEach var="items" items="${dataList}" varStatus="status">
					<div id="img${status.index + 1 }" <c:if test="${status.index ne 0 }">style="display:none;"</c:if>>
						<input type="hidden" name="spendid"     id="spendid${status.index + 1 }"     value="${items.spendid }" />
						<input type="hidden" name="spenditemid" id="spenditemid${status.index + 1 }" value="${items.spenditemid }" />
						<c:choose>
        					<c:when test="${items.fileext eq 'jpg' or items.fileext eq 'jpeg' or items.fileext eq 'png' or items.fileext eq 'gif' or items.fileext eq 'JPG' or items.fileext eq 'JPEG' or items.fileext eq 'PNG' or items.fileext eq 'GIF'}">
								<a href="javascript:fn_filedownload('${items.attachfile}','${items.uploadseq}');">
								<img src="/manager/trainingFee/proof/imageView.do?filefullurl=${items.filefullurl }&storefilename=${items.storefilename }" width="400px;" style="max-height:300px;">
								</a>
        					</c:when>
        					<c:otherwise>
        						<a href="javascript:fn_filedownload('${items.attachfile}','${items.uploadseq}');">${items.realfilename}</a>
					        </c:otherwise>
					    </c:choose>
					</div>
					</c:forEach>
				</div>
				<div class="imgpage">
					<a href="javascript:btnEvent.btnBack();" class="btn_green">◀</a>
					<span id="pagenum">1</span> / <span id="totpage" class="totimg">3</span>
					<a href="javascript:btnEvent.btnNext();" class="btn_green">▶</a>
				</div>
				<div class="tbl_write1">
					<table id="tblSearch" width="100%" border="0" cellspacing="0" cellpadding="0">
						<colgroup>
							<col width="20%" />
							<col width="*"  />
						</colgroup>
						<tr>
 							<th>지출금액</th>
 							<td>
 								<div id="spentypeperson" style="display:none;" >
 									개인 : <span id="pspendamount"></span>원
 								</div>
 								<div id="spentypegroup" style="display:none;" >
 									그룹 : <span id="gspendamount"></span>원 ( <span id="grpamount"></span>원 )
 								</div> 								 								
 							</td>
 						</tr> 
						<tr>
 							<th>교육종류</th>
 							<td><span id="edukindname"></span></td>
 						</tr> 
						<tr>
 							<th>교육명</th>
 							<td><span id="edutitle"></span></td>
 						</tr> 
						<tr>
 							<th>교육일자</th>
 							<td><span id="spenddt"></span></td>
 						</tr> 
					</table>
				</div>
		</div>
		<div class="btnwrap clear">
			<a href="javascript:;" class="btn_gray close-layer">닫기</a>
		</div>
	</div>
	<!--// Edu Part Cd Info -->
