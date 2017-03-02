(function($) {
	$.orderright = {
			data : {
				  url : "/_ui/mobile"
				, isSeeMore 	: ""
				, page 			: ""
				, totalCount 	: ""
				, searchType	: ""
				, searchText	: ""
			},
			callAjax : function(type, url, dataType, data, successCallBack, errorCallBack){
				$.ajax({
					type     : type,
					url      : url,
					dataType : dataType,
					data     : data,
					cache	 : false,
					success	 : function (data){
						if( typeof successCallBack === 'function' ) { successCallBack(data); }
						
						return false;
					},
					error	 : function(xhr, st, err){
						xhr = null;
						if( typeof errorCallBack === 'function' ){ 
							errorCallBack(); 
						} else {
							alert($.msg.err.system);
						}
						return false;
					}
				});				
			},
			// 양도 & 양도 취소
			setTransferData : function(actionUrl, type, obj){
				$.orderright.callAjax('POST', actionUrl, 'json', $("#orderListSaveForm").serialize(), function successCallBack(data){
					if(data.status == $.msg.common.success){
						var gubun 		= "";
						var seeMore 	= "";
						var sortType 	= "";

						if(type == 'SC' || type == 'MC'){
							var seeMore = $("#trListSeeMore");
							gubun 		= obj.parents("section#pbContent").find("#transfer_list").attr("data-code");
							
							$.orderright.getData(1, gubun, sortType, seeMore);
						} else {
							alert($.msg.orderright.completeTransfer);
							$(location).attr("href", "/shop/order-right");
						}
					} else {
						var msg = data.status;
						msg 	= msg.replace(/\\n/g, "\\\n");
						msg 	= msg.replace(/\\/g, "");
						
						alert(msg);
					}
				}, null);

				if(type == 'SC'){
					$("#transfer_list").find("input[name=prdChk]").each(function(){
						if($(this).attr("checked")){
							$(this).parents("li").find("input[name=isCheckedList]").val("1");
						}
					});					
				}
			},
			// 최대 리스트 선택 가능 유무 리턴
			limitList : function(num){
				var chkLength = 0;

				$("input[name=prdChk]").each(function(){
					var rowData 	= $(this).parents("li");
					var checkVal 	=  Number(rowData.find("input[name=isCheckedList]").val());
					
					if($(this).is(":checked")){
						chkLength += checkVal;
					}
				})

				if(chkLength > num){
					alert($.getMsg($.msg.common.selectMax, num+'개'));
					
					return false;
				}

				return true;
			},			
			getSearchData : function(page, gubun, sortType, obj){
				var actionURL;
				var params 	= {};
				
				params.page = page;

				if(sortType.length != 0){
					if(sortType != 'ALL'){
						params.sortType = sortType;
					}
				}

				if(gubun 			== 'taL'){
					actionUrl 			= "/shop/order-right/ajax/paging";
				} else if(gubun 	== 'tL'){
					actionUrl 			= "/shop/order-right/transfer/ajax/paging";
				}

				$.orderright.callAjax('GET', actionUrl, 'html', params, function successCallBack(data){
					if(gubun 			== 'taL'){	// 양도/사용
						if(page == 1){
							$("#transferAcquisition_list").html(data);
						} else {
							var render = $("#transferAcquisition_list").find("#acquisitionList").html() + data;
							$("#transferAcquisition_list").find("#acquisitionList").append(render);
						}

						$.orderright.list.sameRightsCheck();
					} else if(gubun 	== 'tL'){ // 구매권한 양도내역
						if(page == 1){
							$("#transferList #transfer_list").html(data);
							$("div.listHead span.listInfo strong").text($.orderright.data.totalCount);
							alert($.msg.orderright.completeTransferCancel);
						} else {
							$("#transferList #transfer_list").append(data);
							$("#transferList #transfer_list li").each(function(index){
								$(this).find("input[name='prdChk']").attr("id", "coupon" + (index + 1));
								$(this).find("label").attr("for", "coupon" + (index + 1));
							});
						}
					}			

					$.orderright.setSeeMore(obj);
				}, null);
			},
			getData : function(page, gubun, sortType, obj){
				$.orderright.getSearchData(page, gubun, sortType, obj);
				
				return false;
			},
			// 선택된 제품이 없는 경우
			isChecked : function(checkbox, e, msg){
				if(!checkbox.is(":checked")){
					e.preventDefault();
					alert($.getMsg($.msg.common.selectDetail, msg));
					
					return false;
				}
				return true;
			},
			// 숫자 유효성 체크
			numberValidationCheck : function(obj){
				var num_check=/^[0-9]*$/;

				if(!num_check.test(obj.val())){
					alert($.msg.common.inputOnlyNumber);
					obj.val("");
					obj.focus();
					
					return false;
				}
				return true;
			},
			setSeeMore : function(obj){

				if($.orderright.data.isSeeMore == "false"){
					obj.hide();
				}else{
					obj.show();
				}
			}
	};
	
	// 구매권한 사용내역 검색만을 위한 기능(15.11.11)
	$.list = {
			getSearchData : function(){
				var seeMore 		=	$("#useListSeeMore");
				var actionUrl 		= "/shop/order-right/use/ajax/paging";
				
				$.list.searchData($.orderright.data);
				
				$.orderright.callAjax('POST', actionUrl, 'html', $("#acquisitionSearchForm").serialize(), function successCallBack(data){
					$.orderright.data.totalCount = parseInt($(data).find("span#totalCount").text());
					
					$(".listHead.spTransfer span.listInfo strong").text($.orderright.data.totalCount);
				
					if($.orderright.data.page == 1){
						$("#use_list").html(data);
					} else {
						$("#use_list").html($("#use_list").html() + data);
					}
					$.orderright.setSeeMore(seeMore);
					
					if ($.orderright.data.totalCount <= 0)
					{
						alert($.msg.orderright.searchResultZero);
					}
				}, null);
			},
			search : function(){
				var searchType 			= $(".listHead.authSchList .listInfo #searchType").val();
				var searchText 			= $.trim($(".listHead.authSchList .listSearch #quickSrch").val());

				if (searchType == "number" && searchText.length > 0){
					if (!$.isNumeric(searchText)) {
						alert($.getMsg($.msg.common.inputOnlyNumber));
						$(".listHead.authSchList .listSearch #quickSrch").val("");
						$(".listHead.authSchList .listSearch #quickSrch").focus();
						return;
					}
				}
				
				$.orderright.data.page			= 1;
				$.orderright.data.searchType 	= searchType;
				$.orderright.data.searchText 	= searchText;
				$.list.getSearchData();			
			},
			searchData : function(){
				$("#acquisitionSearchForm #page").val($.orderright.data.page || 1);
				$("#acquisitionSearchForm #searchType").val($.orderright.data.searchType || "");
				$("#acquisitionSearchForm #searchValue").val($.orderright.data.searchText || "");
				$(".listHead.authSchList .listSearch #quickSrch").val($.orderright.data.searchText || "");
			}
	};
	
	// ############################################################################
	// 공통
	// ############################################################################

	// 체크박스 체크 이벤트(폼에 담아가기 위해서 hidden 값에 셋팅)
	$(document).off("change", "input[name=prdChk]").on("change", "input[name=prdChk]", function(e)
	{
		if($(this).is(':checked')){
			$(this).parents("li").find("input[name=isCheckedList]").val("1");
		}else{
			$(this).parents("li").find("input[name=isCheckedList]").val("0");
		}
	});

	// 체크박스 전체 선택, 전체 해제
	$(document).on("click", "#selectAll", function(e){
		var rowData;
		var checkBox = $("#acquisitionList, #transfer_list").find("input[name=prdChk]");

		checkBox.prop("checked", !checkBox.is(":checked"));		

		checkBox.each(function(){
			var obj 		= $(this);
			var disabled 	= obj.attr("disabled");
			rowData 		= obj.parents("li");
			
			if(disabled != undefined){
				obj.attr("checked", false);
			} else {
				rowData.find("input[name=isCheckedList]").val("1");
			}
		});

		checkBox.each(function(){
			if($(this).is(":checked")){
				$(this).parents("li").find("input[name=isCheckedList]").val("1");
			} else {
				$(this).parents("li").find("input[name=isCheckedList]").val("0");
			}
		});
	});

	// ############################################################################
	// 구매권한 양도/양수
	// ############################################################################

	$.orderright.list = {
			openTransfer : function(obj){
				$("#orderListSaveForm").attr("action", "/shop/order-right/transferPopup");
				$("#orderListSaveForm").attr("target", "_self");
				$("#orderListSaveForm").attr("method", "post");
				$("#orderListSaveForm").submit();
				
				if(obj){
					$("#acquisitionList").find("input[name=prdChk]").each(function(){
						if($(this).attr("checked")){
							$(this).parents("li").find("input[name=isCheckedList]").val("1");
						}
					});
				}
			},
			// 동일 권한일 경우 동일 클래스 설정
			sameRightsCheck : function(){
				$("#acquisitionList li").each(function(){
					var obj 	= $(this);
					var param 	= [];
					var rNum 	= obj.find("input[name=ortgroup]").val();

					$("#acquisitionList li").each(function(){
						param 		= rNum;
						var dupObj 	= $(this);
						var duprNum = dupObj.find("input[name=ortgroup]").val();

						if(param.indexOf(duprNum) == 0){
							var sameClass = $(this).find(".couponList").attr("class");
							obj.find(".couponList").attr("class", sameClass);
							
							return false;
						}
					})
				})				
			}
	};

	// 더보기
	$(document).on("click", "#orderRightSeeMore", function(e){
		$.orderright.data.page++;
		var obj 		= $(this);
		var sortType 	= $.trim($("#acquisitionSortType").val());
		var gubun 		= $(this).parents("section#pbContent").find("#acquisitionList").attr("data-code");
		
		$.orderright.getData($.orderright.data.page, gubun, sortType, obj);
		
		return false;
	});

	// 정렬 조건 검색
	$(document).on("change", "#acquisitionSortType", function(){
		var obj 		= $("#orderRightSeeMore");
		var sortType 	= $.trim($("#acquisitionSortType").val());
		var gubun 		= $(this).parents("section#pbContent").find("#acquisitionList").attr("data-code");

		$.orderright.getData(1, gubun, sortType, obj);
		
		return false;
	});	

	// 구매 버튼
	$(document).on("click", "#btnMoveDetail", function(e){
		if(confirm($.msg.orderright.moveProductDetail)){
			location.href = $(this).attr("href");
		}
		return false;
	});

	// 선택한 구매권한 - 양도 버튼
	$(document).on("click", "#btnChkTransfer", function(e){
		event.preventDefault();
		var isNoDup = false;
		
		if($.orderright.isChecked($("input[name=prdChk]"), e, "양도할 구매권한을")){
			$("#acquisitionList li").each(function(){
				if($(this).find("input[name=isCheckedList]").val() == 1){
					var param 	= [];
					var rNum 	= $(this).find("input[name=ortgroup]").val();
					
					param.push(rNum);
					
					$("#acquisitionList li").each(function(){
						if($(this).find("input[name=isCheckedList]").val() == 1){
							var duprNum = $(this).find("input[name=ortgroup]").val();	
							if(param.indexOf(duprNum) == -1){
								isNoDup = true;
							}
						}
					});
				}
			});

			if(isNoDup){
				alert($.msg.orderright.sameRightsTransfer);
				
				return false;
			}

			if($.orderright.limitList(10)){
				$.orderright.list.openTransfer();
			}
			return false;		
		}
	});

	// 개별 양도 버튼
	$(document).on("click", "#btnTransfer", function(e){
		event.preventDefault();
		$("input[name=isCheckedList]").val("0");
		$(this).parents("li").find("input[name=isCheckedList]").val(1);
		$(this).parents("li").find("input[name=prdChk]").attr("checked", true);
		
		$.orderright.list.openTransfer($(this));
		
		return false;
	});	

	// 동일 구매권한 번호, 동일 class 로 변경
	$(document).ready(function(){
		$.orderright.list.sameRightsCheck();
	});

	// ############################################################################
	// 구매권한 양도 팝업
	// ############################################################################

	$.orderright.popup = {
			searchData : function(){
				var obj = $("input[name=inputNumber]");

				if(obj.val().length == 0){
					alert($.msg.orderright.inputMemberNumber);
					obj.focus();
					
					return false;
				}

				if($.orderright.numberValidationCheck(obj)){
					var params 		= {};
					params.memberNo	= obj.val();

					var actionUrl = "/shop/order-right/ajax/search/memberInfo";
					$.orderright.callAjax('GET', actionUrl, 'json', params, function successCallBack(data){
						if(data.name == null){
							alert($.msg.orderright.invaildMemberNumber);
						} else {
							$("input[name=ownerDistNo]").val($("input[name=inputNumber]").val());
							$("#memberName").text(data.name);		
						}
					}, null);
				}
			}
	};

	// 회원검색
	$(document).on("click", "#btnSearch", function(e){
		$.orderright.popup.searchData();
		
		return false;
	});

	// 회원검색 엔터 처리
	$(document).on("keydown", "input[name=inputNumber]", function(e){
		$.inputOnlyNumber(e);
		if (e.keyCode == 13) {
			$.orderright.popup.searchData();
			
			return false;
		}
	});

	// 양도
	$(document).on("click", "#btnPopTransfer", function(e){
		var obj 	= $("input[name=inputNumber]");
		var name 	= $("#memberName").text();

		if(obj.val() == 0){
			alert($.msg.orderright.inputMemberNumber);
			obj.focus();
			
			return false;
		}

		if(name.length == 0){
			alert($.msg.orderright.inputMemberNumber);
			obj.focus();
			
			return false;
		}

		if($.orderright.numberValidationCheck(obj)){
			if(confirm($.msg.orderright.confirmTransfer)){
				var url = "/shop/order-right/ajax/transfer";
				$.orderright.setTransferData(url, 'T', $("#transferAcquisition_list"));
			}			
		}
		return false;
	});

	// ############################################################################
	// 구매권한 양도내역
	// ############################################################################

	// 더보기
	$(document).on("click", "#trListSeeMore", function(e){
		$.orderright.data.page++;
		var obj 	= $(this);
		var gubun 	= $(this).parents("section#pbContent").find("#transfer_list").attr("data-code");

		$.orderright.getData($.orderright.data.page, gubun, "", obj);
		
		return false;
	});

	// 개별 양도취소 버튼
	$(document).on("click", "#btnTransferCancel", function(e){
		$(this).parents("li").find("input[name=prdChk]").attr("checked", true);

		if(confirm($.getMsg($.msg.common.wantToCancel, "구매권한 양도를"))){
			var url = "/shop/order-right/transfer/ajax/cancel";
			$("input[name=isCheckedList]").val("0");
			$(this).parents("li").find("input[name=isCheckedList]").val(1);

			$.orderright.setTransferData(url, 'SC', $(this));
		}else{
			$(this).parents("li").find("input[name=prdChk]").attr("checked", false);
		}

		return false;
	});

	// 선택한 구매권한 - 양도취소 버튼
	$(document).on("click", "#btnChkTransferCancel", function(e){
		if($.orderright.isChecked($("input[name=prdChk]"), e, "양도 취소할 구매권한을")){
			if($.orderright.limitList(10)){
				if(confirm($.getMsg($.msg.common.wantToCancel, "구매권한 양도를"))){
					var url = "/shop/order-right/transfer/ajax/cancel";

					$.orderright.setTransferData(url, 'MC', $(this));
				}				
			}
		}

		return false;
	});

	// ############################################################################
	// 구매권한 사용내역
	// ############################################################################

	// 더보기
	$(document).on("click", "#useListSeeMore", function(e){
		$.orderright.data.page++;
		$.list.getSearchData();
		return false;
	});
	
	// 검색버튼 클릭시
	$(document).on("click", ".listHead.authSchList .listSearch .btnSearch", function(){
		$.list.search();
		return false;
	});
	
	// 검색 엔터 처리
	$(document).on("keydown", "input[id=quickSrch]", function(e){
		if (e.keyCode == 13) {
			$.list.search();
			return false;
		}
	});
	
	// 전체보기 버튼 클릭시
//	$(document).on("click", ".noTblBox.mgtL .other a.btnReset", function(){
//		$.orderright.data.searchText = "";
//		$.list.getSearchData();
//		return false;
//	});
	
})(jQuery);