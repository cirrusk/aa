<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/manager/frame/include/topPop.jsp" %>
		
<script type="text/javascript">	
var params = {page:"agree", downloadfile:"에메랄드 위임자"};

$(document.body).ready(function() {
	$("input[id='file']").change(function(){
		if($(this).val() != "") {
			var chkData = {
					"chkFile" : "xls, xlsx"
			};
			
			var ext = $(this).val().split('.').pop().toLowerCase();
			var txt = $(this).val();
			var opts = $.extend({},chkData);
			
			if(opts.chkFile.indexOf(ext) == -1) {
				alert("업로드가 허용된 파일확장자는 "+opts.chkFile+" 입니다. 확인 후 다시 올려주세요");
				$(this).val("");
				return;
			}
			
			if( byteCheck(txt) > 128 ) {
				alert("업로드가 허용된 파일명길이는 영문 128자, 한글 64자 입니다. 확인 후 다시 올려주세요");
				$(this).val("");
				return;
			}
		}
	});
});

function byteCheck(str){
    var size = 0;
    for(var i=0,len=str.length;i<len;i++) {
        size++;
        if(44032 <str.charCodeAt(i) && str.charCodeAt(i) <=  55203) {
            size++;
        }
        if(12593 <= str.charCodeAt(i) && str.charCodeAt(i) <= 12686 ) {
            size++;
        }
    }
    return size;
}

var excelPopup = {
	excelDown:function(){
		var result = confirm("양식 내려받기를 시작 하시겠습니까?\n 네트워크 상황에 따라서 1~3분 정도 시간이 걸릴 수 있습니다."); 
		var params = {
				page : "agree",
				downloadfile:$("#downloadfile").val()
		};
		
		if(result) {
			postGoto("<c:url value="/manager/common/excel/excelDownload.do"/>", params);
		}
	} 
	, excelUpload:function(){
		// 저장전 Validation
    	if(!chkValidation({chkId:"#tblSearch", chkObj:"hidden|input|select"}) ){
    		return;
    	}
		
    	showLoading();
		var result = confirm("엑셀 일괄 업로드를 진행 하시겠습니까?"); 
		
		if(result) {
			
			$("#excelUpload").ajaxForm({
				  url     : "<c:url value="/manager/common/excel/excelFileUpload.do"/>"
// 			    , type    : "json"
				, method  : "post"
				, async   : false
				, success : function(data){
					hideLoading();
					var item = JSON.parse(data);
					
					if( item.errCode == 0 ) {
						alert(item.importCount+"건 엑셀 업로드가 완료 되었습니다.");
						$(".btn_close").click();
					} else {
						alert(item.errMsg.replace("java.lang.Exception:",""));
					}
				}, error : function(data){
					hideLoading();
					alert("엑셀 업로드 처리 중 오류가 발생 하였습니다.");
				}
			}).submit();
		} else {
			hideLoading();
		}
	}
}

$(document.body).ready(function(){
	
});

</script>

	<div id="popwrap">
		<!--pop_title //-->
		<div class="title clear">
			<h2 class="fl">교육비 Emerald 위임 등록</h2>
			<span class="fr"><a href="javascript:;" class="btn_close close-layer">X</a></span>
		</div>
		<!--// pop_title -->
		
		<div id="popcontainer">
			<div id="popcontent">
				<form id="excelUpload" name="excelUpload" method="post">
				<div class="tbl_write">
					<table width="100%" border="0" cellspacing="0" cellpadding="0">
						<colgroup>
							<col width="13%" />
							<col width="37%" />
							<col width="13%" />
							<col width="37%" />
						</colgroup>
						<tr>
							<th scope="row">회계연도</th>
							<td>
<%-- 								<span>${layPopData.fiscalyear }</span> --%>
								<input type="text" name="fiscalyear" class="AXInput datepYear setFiscalYear" readonly="readonly" />
							</td>
							<th scope="row">위임구분</th>
							<td scope="row">
								<span>Emerald 위임</span>
								<input type="hidden" name="agreetype" value="1" />
							</td>
						</tr>
						<tr>
							<th>첨부파일</th>
							<td colspan="3">
								<input type="file" id="file" name="file" title="첨부파일" class="required" title="첨부파일"/>
								<span id="spanFile" >
								</span>
							</td>
						</tr>
						<tr>
							<th>업로드양식</th>
							<td colspan="3">
								<input type="hidden" id="downloadfile" value="${layPopData.downloadfile }" />
								<a href="javascript:excelPopup.excelDown();" >${layPopData.downloadfile }</a>
							</td>
						</tr>
					</table>
				</div>
				<div>
					<input type="hidden" name="fiscalyear" value="${layPopData.fiscalyear }" />
					<input type="hidden" name="agreetypecode" value="${layPopData.agreetypecode }" />
					<input type="hidden" name="page" value="${layPopData.page }" />
				</div>
			</form>
			</div>
			
			<div class="btnwrap clear">
				<a href="javascript:excelPopup.excelUpload();" class="btn_green" >업로드</a>
				<a href="javascript:;" class="btn_gray close-layer" >닫기</a>
			</div>
		</div>
	</div>