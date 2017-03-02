<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/manager/frame/include/top.jsp" %>

<!-- js/이미지/공통  include -->
<%@ include file="/WEB-INF/jsp/manager/frame/include/include.jsp" %>
		
<script type="text/javascript">	
var params = {page:"target", downloadfile:"교육비 지급 대상자"};

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
		showLoading();
		if(result) {
			postGoto("<c:url value="/manager/common/excel/excelDownload.do"/>", params);
			
			hideLoading();
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
			$("#frmFile").ajaxForm({
				  url     : "<c:url value="/manager/common/excel/excelFileUpload.do"/>"
				, method  : "post"
				, data    : params
				, async   : false
				, success : function(data){
					var item = JSON.parse(data);
					
					if( item.errCode == 0 ) {
						hideLoading();
						$(".close-layer").click();
						alert(item.importCount+"건 엑셀 업로드가 완료 되었습니다.");
					} else {
						hideLoading();
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
	},
	reset : function() {
		$("#startdate").val("");
		$("#enddate").val("");
		$("#starttime").val("10");
		$("#endtime").val("18");
	}
}

$(document.body).ready(function(){
});

</script>
</head>

 
	<div id="popwrap">
		<!--pop_title //-->
		<div class="title clear">
			<h2 class="fl">Excel Upload ${popupPage.title }</h2>
			<span class="fr"><a href="javascript:;" class="btn_close close-layer">X</a></span>
		</div>
		<!--// pop_title -->
		
		<div id="popcontainer">
			<div id="popcontent">
				<div class="tbl_write">
					<form id="frmFile" name="fileform" method="post" enctype="multipart/form-data">
						<table id="tblSearch" width="100%" border="0" cellspacing="0" cellpadding="0">
							<colgroup>
								<col width="20%" />
								<col width="*"  />
							</colgroup>
							<tr>
								<th>지급연도/월</th>
								<td>
									<input type="hidden" name="page" value="${layPopData.page }" />
									<input type="text" id="searchGiveYear" name="giveyear" class="AXInput datepMon setDateMon required" style="width:120px; min-width:100px;" title="지급연도/월" readonly="readonly">
								</td>
							</tr>
							<tr>
								<th>일정</th>
								<td colspan="3">
									<input type="text" id="startdate" name="startdate" class="datepDay required" style="width:120px; min-width:100px;" title="지급 시작 일자">
									<select id="starttime" name="starttime" style="width:60px; min-width:60px;" title="지급 시작 시간" >
										<option value="10">10</option>
										<option value="11">11</option>
										<option value="12">12</option>
										<option value="13">13</option>
										<option value="14">14</option>
										<option value="15">15</option>
										<option value="16">16</option>
										<option value="17">17</option>
										<option value="18">18</option>
										<option value="19">19</option>
										<option value="20">20</option>
										<option value="21">21</option>
										<option value="22">22</option>
										<option value="23">23</option>
										<option value="24">24</option>
									</select>
									~
									<input type="text" id="enddate" name="enddate" class="datepDay required" style="width:120px; min-width:100px;" title="지급 종료 일정">
									<select id="endtime" name="endtime" style="width:60px; min-width:60px;" title="지급 종료 시간">
										<option value="10">10</option>
										<option value="11">11</option>
										<option value="12">12</option>
										<option value="13">13</option>
										<option value="14">14</option>
										<option value="15">15</option>
										<option value="16">16</option>
										<option value="17">17</option>
										<option value="18" selected>18</option>
										<option value="19">19</option>
										<option value="20">20</option>
										<option value="21">21</option>
										<option value="22">22</option>
										<option value="23">23</option>
										<option value="24">24</option>
									</select>
									<a href="javascript:excelPopup.reset();" class="btn_green" >Reset</a>
								</td>
							</tr>
							<tr>
								<th>첨부파일</th>
								<td colspan="3">
									<input type="file" id="file" name="file" title="첨부파일" class="required" title="첨부파일" />
									<span id="spanFile" >
									</span>
								</td>
							</tr>
							<tr>
								<th>업로드양식</th>
								<td>
									<input type="hidden" id="downloadfile" value="${layPopData.downloadfile }" />
									<a href="javascript:excelPopup.excelDown();" >${layPopData.downloadfile }</a>
								</td>
							</tr>
						</table>
					</form>
				</div>
			</div>		
		</div>
		<div class="btnwrap clear">
			<a href="javascript:excelPopup.excelUpload();" class="btn_green" >업로드</a>
			<a href="javascript:;" class="btn_gray close-layer" >닫기</a>
		</div>
			
		<!--// Contents -->
	</div>