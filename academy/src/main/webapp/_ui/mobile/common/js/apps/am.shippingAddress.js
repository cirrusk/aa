(function($) {
	//이벤트 처리
	$.addrList={
			data : {},
			callAjax : function(type, url, dataType, data, successCallBack, errorCallBack){
				$.ajax({
					type     : type,
					url      : url,
					dataType : dataType,
					data     : data,
					success: function (data){
						if(data.result === "false"){
							alert(data.errorMessage);
							return;
						}else{
							successCallBack(data);
						}
					},
					error: function(xhr, st, err){
						xhr = null;
						if( typeof errorCallBack === 'function' ) { 
							errorCallBack();
						} else {
							alert($.msg.err.system);
						}
						return false;
					}
				});				
			},			
			
			getSearchData : function(page, groupSel, searchStr, option){
				
				var actionUrl  = "/mypage/address/shipping/addr/search";
				var params	   = {};
				
				params.page	       = page;
				params.groupSel    = groupSel;
				params.searchStr = searchStr;
				
				$.addrList.callAjax('GET', actionUrl, 'html', params, function successCallBack(data){
					$("#addrList_list").html(data);
					$("#searchStr").val(searchStr);
					$.addrList.openAddrDetail();
					if($("#totCnt").val()<=20){
						$("a.listMore").remove();  
					}
					
					if(option=="S"){
						var tmpTot= $(".listInfo strong").html();
						if(tmpTot<=0)
						{
							$("#searchStr").focus();
							return;
						}
					}
				}, null);
			},
			getData : function(type, page){
				
				var groupSel    = $("#groupSel").val().trim();
				var searchStr = $("#searchStr").val().trim();

				if(type=="O"){
					$.addrList.getSearchData(page, groupSel, searchStr, "O");
				}else{
					if(searchStr==""){
						alert("검색어를 입력 후 다시 검색해 주세요.");
						$("#searchStr").focus();
						return;
					}
					$.addrList.getSearchData(page, groupSel, searchStr, "S");
				}
				return false;
			},
			
			deleteList : function(){
				var actionUrl  = "/mypage/address/shipping/addr/del";
				$.addrList.callAjax('POST', actionUrl, 'json',  $("#AddrListMgmtForm").serialize(), function successCallBack(data){
					$.addrList.getData("O", 1);
				}, null);
			},
			
			openPopup : function(e){
				// checked 데이터를 layer popup으로 뿌려주기 위한 데이터 세팅

				var html ="";
				$("#uiDevlist input[name=chkM]:checked").each(function(idx){
					var name = $(this).parents("li").find("input[name=name]").val(); 
					var addrId = $(this).parents("li").find("input[name=addrId]").val(); 
					var flags = addrId.split('_')[1];
					if (flags=='G'){
						group = "선물";
					}else{
						group = "일반";
					}
					html += '<tr> <th scope="row">'+name+'</th><td>'+group+'</td></tr>'
				});
				
				$("#layerList").html(html);
			},
			
			groupCng : function(){
				var url = "/mypage/address/m/saveAddrNewGroup";
				
				$.addrList.callAjax('POST', url, 'json',  $("#AddrListMgmtForm").serialize(), function successCallBack(data){
					alert("그룹이 이동되었습니다. 배송지 목록에서 확인하세요.");
					closeLayerPopup($(this).parents("#uiLayerPop_userSet1"));
					$.addrList.getData("O", 1);
					return false;
				}, null);
				
				return false;
			},
			
			openNewAddressPopupPage : function(obj) {
				//새 배송지
				var actionUrl = "/shop/order/checkout/orderCreatingNewAddressPopup";
				
				$.addrList.callAjax('GET', actionUrl, 'html', null, function successCallBack(data){
					$("#uiLayerPop_delivery").html(data);
					layerPopupOpen(obj);
				}, null);
			},
			
			openAddrDetail : function(){
				//배송지 열기 닫기
				$('a.btnTgg').unbind("click");
				$('a.btnTgg').click(function() {
					if($(this).parent().parent().hasClass('on') == true){
						$(this).parent().parent().removeClass('on');
						$(this).find('img').attr('src',$(this).find('img').attr("src").split("_close.gif").join("_open.gif")).attr('alt','상세열기');
					}else{
						$(this).parent().parent().addClass('on');
						$(this).find('img').attr('src',$(this).find('img').attr("src").split("_open.gif").join("_close.gif")).attr('alt','상세닫기');
					}
				});
			}
			
	},
	
	// 20개 더보기
	$.showMoreList= {

			getMoreAddrList : function(page) {
				
				var actionUrl = "/mypage/address/shipping/addr/search";
				var groupSel    = $("#groupSel").val().trim();
				var searchStr = $("#searchStr").val().trim();
				var ajaxType = "mobile";
				var params = {};

				params.page = page;
				params.groupSel = groupSel;
				params.searchStr = searchStr;
				params.ajaxType = ajaxType;
				
				$.addrList.callAjax('GET', actionUrl, 'html', params, function successCallBack(data){
					$("#groupSel").val(groupSel);
					$("#searchStr").val(searchStr);
					$("#page").val(page);
					$("div#addrListMob").append(data);
					$.addrList.openAddrDetail();
				}, null);
			}
		
	}

})(jQuery)

// 그룹 선택
$(document).on("change", "#groupSel", function(){
		$.addrList.getData("O", 1);
});

// 검색
$(document).on("click", "#addrListSubmit", function(){
	$.addrList.getData("S", 1);
});

// 검색 입력 엔터 처리 
$(document).on("keydown", "#searchStr", function(e){
	if (e.keyCode == 13) {
		$.addrList.getData("S", 1);
		return false;
	}
});

//체크박스 일괄 선택/해제
$(document).on("click", "#selectAll", function(e){
	
	var chkvalue = $("#selectYN").val().trim();
	if( chkvalue == "nonChecked" )
	{
		$("#uiDevlist input[name=chkM]").each(function()
		{
			$(this).parents("div").find(".chk").attr('checked', true);
			$(this).parents("div").find("input[name=chk]").val("1");
		});
		$("#selectYN").val("checked");
	}
	else
	{
		$("#uiDevlist input[name=chkM]").prop('checked', false );
		$(this).parents("tr").find("input[name=chk]").val("0");
		$("#selectYN").val("nonChecked");
	}
});


//체크박스 체크 이벤트
$(document).off("change", "#uiDevlist input[name=chkM]").on("change", "#uiDevlist input[name=chkM]", function(e)
{
	$("#uiDevlist input[name=chkM]").each(function()
			{
				if($(this).is(':checked')){
					$(this).parents("li").find("input[name=chk]").val("1");
				}else{
					$(this).parents("li").find("input[name=chk]").val("0");
				}
			});
});


//선택 배송지 삭제
$(document).on("click", "#btnAddrDelete", function(e){
	var idxChk=0;
	$("#uiDevlist input[name=chkM]:checked").each(function()
	{
		idxChk++;
	});

	if( idxChk <= 0 )
	{
		alert("선택된 배송지가 없습니다.");
		return false;
	}

	if (!confirm("선택한 배송지를 삭제하시겠습니까?")) 
	{
		return false;
	}

	$.addrList.deleteList(); //삭제함수호출
	return false;
});

// 20개 더보기
$(document).on("click", "a.listMore", function(){
	var page =  $("#page").val();
	var totPage = $("#totPage").val();
	
	page++;
	
	if(totPage == page){		
		$("a.listMore").remove();  
	}
	$.showMoreList.getMoreAddrList(page);
	return false;
});

//[그룹이동 팝업] 팝업 호출
$(document).off("click", "#addrGroupCng").on("click", "#addrGroupCng", function(e){
	var idxChk=0;
	$("#uiDevlist input[name=chkM]:checked").each(function()
	{
		idxChk++;
	});

	if( idxChk <= 0 )
	{
		alert("선택된 배송지가 없습니다.");
		return false;
	}
	
	$.addrList.openPopup();
	$(this).attr("href","#uiLayerPop_UserSet1");
	layerPopupOpen($(this));
	return false;

});

// [그룹이동 팝업] 그룹 이동 저장
$(document).on("click", "#groupCng", function(e) {
	
	if($("#movGrp").val()== "empty"){
		alert("이동 그룹을 선택해 주세요");
		return false;
		
	}else{
		$.addrList.groupCng();
	}
	return false;
});

//새 배송지 클릭
$(document).on("click", "#newAddrBtn", function() {
	$.addrList.openNewAddressPopupPage($(this));
});
	
// 수정 아이콘 클릭이벤트 
$(document).on("click", "#modifyAddrBtn", function() {
	var rowData = $(this).parents("li");
	var addrCode  = rowData.find("input[name='addrCode']").val();
	var addrFlags = rowData.find("input[name='oldFlags']").val();
	
	$.address.openAddressModifyPopupPage(addrCode, addrFlags, $(this));
	return false;
});
