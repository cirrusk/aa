(function($) {
	var losmap;
	$.returnGroup = {
			data : {
				  url : "/_ui/mobile"
				, currentMonth	: 0
				, currentYear	: 0
				, selectedYear	: 0
				, selectedMonth	: 0
				, selectedItemId : ""
				, groupPage			: 1
				, detailPage		: 1
				, useShowMoreGroup	: false
				, useShowMoreDetail	: false
				, html				: ""
				, closeYear			: ""
				, closeMonth		: ""
			},
			init : function(){
				$.returnGroup.loadLosmapTree();
				$.returnGroup.setThisMonthAndYear();
				$.returnGroup.data.selectedYear = $.returnGroup.data.currentYear;
				$.returnGroup.data.selectedMonth = $.returnGroup.data.currentMonth;
			},
			callAjax : function(type, url, dataType, data, successCallBack, errorCallBack){
				$.ajax({
					type     : type,
					url      : url,
					dataType : dataType,
					data     : data,
					cache	 : false,
					success: function (data){
						if( typeof successCallBack === 'function' ) { successCallBack(data); }
						return false;
					},
					error: function(xhr, st, err){
						xhr = null;
						if( typeof errorCallBack === 'function' ){ 
							errorCallBack(); 
						} else {
							loadingLayerSClose();
							alert($.msg.err.system);
						}
						return false;
					},
					complete : function(){
						loadingLayerSClose();
					}
				});				
			},
			getSearchData : function(year, month, url, type, obj){
				var actionUrl  = "/business/record/return" + url;
				var params	   = {};

				obj.attr("disabled", true);
				
				params.sYear  = year;
				if(month.length != 0){
					params.sMonth = month;
				}
				// 로딩레이어 시작
				loadingLayerS();

				$.returnGroup.callAjax('GET', actionUrl, 'html', params, function successCallBack(data){
					if(type == 'B'){
						$("#relatedBonusList").html(data);
					}else if(type == 'M'){
						$("#topupList").html(data);
					}else{
						$("#downlineTopupList").html(data);
					}
					flickingAreaS();
					$(window).trigger('resize');	
					// 로딩레이어 종료
					loadingLayerSClose();
				}, function errorCallBack(){obj.attr("disabled", true);alert($.msg.err.system);loadingLayerSClose();});
			},
			nanToNumber : function(number){
				if(isNaN(number)) { return  0; }
				return number;
			},
			setThisMonthAndYear : function(){
				$("#searchYear").val($.returnGroup.data.currentYear).attr("selected", "selected");
				$("#searchMonth").val($.returnGroup.data.currentMonth).attr("selected", "selected");
			},
			loadLosmapTree : function(){
				dhx4.attachEvent("onAjaxError", $.returnGroup.alertLoadLosMapError);
				losmap = new dhtmlXTreeObject("losmapTree", "100%", "100%", 0);
				
				losmap.setImagePath(IMAGE_RESOUCE_PATH + "/dhtmlx/dhxtree_skyblue/");
				
				losmap.enableTreeImages(false);
				losmap.enableItemEditor(false);
				
				losmap.setOnClickHandler($.returnGroup.setIdOfSelectedItem);
				losmap.setOnDblClickHandler($.returnGroup.setIdOfSelectedItem);
				
				losmap.loadJSON("/business/record/return/ajax/losmap", function(){
					$.returnGroup.loadDownLine($("#aboPk").val(), "-1");
					losmap.setOnOpenHandler($.returnGroup.loadDownLine);
				});
			},
			loadDownLine : function(id, mode){
				if(mode > 0){
					return true;
				}else{
					if(!losmap.hasChildren(id)){
						return false;
					}
					$.returnGroup.callAjax("GET", "/business/record/return/ajax/losmap", "json", {"id" : id }, function(data){
						var downLineData = data.item;
						losmap.deleteChildItems(id);
						$.returnGroup.loadDownLineTree(downLineData, id);
					});
					return false;
				}
			},
			loadDownLineTree : function(resultData, id){
				var isEnd = false;
				
				if(resultData == null || !resultData.length){
					return isEnd
				}
				
				for (var iLoop = 0; iLoop < resultData.length; iLoop++) {
					var downLineData = resultData[iLoop];
					losmap.insertNewChild(id, downLineData.id, downLineData.text);
					
					if(downLineData.item == null){
						isEnd = true;
						continue;
					}
					
					if(!$.returnGroup.loadDownLineTree(downLineData.item, downLineData.id)){
						isEnd = true;
						continue;
					}
					
					if(downLineData.item[0].id == "-"){
						losmap.closeItem(downLineData.id);
					}
				}
				return isEnd;
			},
			setLosmapTreeBySearch : function(id){
				if($.returnGroup.validateSearchDownLine()){
					loadingLayerS();
					$.returnGroup.callAjax("GET", "/business/record/return/ajax/losmap-by-searchword", "json", { "searchword" : id }, function(data){
						if(data.status){
							var resultData = data.success;
							losmap.deleteChildItems(0);
							$.returnGroup.loadDownLineTree(resultData, 0);
						}else{
							loadingLayerSClose();
							if(data.error){
								$("#uiLayerPop_losResult").hide();
								alert(data.error);
								//$.returnGroup.resetLosMapTree();
								return false;
							}else{
								$.returnGroup.renderLayerTbody(data.multi);
								layerPopupOpen($("#searchUserResult"));
								// 선택한 유저로 검색
								$(document).off("click", "#selectedUser").on("click", "#selectedUser", function(){
									if($(this).attr("href") != null || $(this).attr("href") != ""){
										$.returnGroup.setLosmapTreeBySearch($(this).attr("href"));
									}
									$("#uiLayerPop_losResult .btnPopClose").trigger("click");
									return false;
								});
							}
						}
					});
				}
			},
			renderLayerTbody : function(resultData){
				$("#searchUserListTable tbody tr").remove();
				var trHtml = "";
				$(resultData).each(function(idx) {
					var result = resultData[idx].result
					trHtml += '<tr>';
					trHtml += ' <td>' + result.uid + '</td>';
					trHtml += ' <td>' + result.name + '</td>';
					trHtml += ' <td>' + result.location + '</td>';
					if(result.uid != null || result.uid != ""){
						trHtml += ' <td class="btn"><a href="' + result.uid  + '" class="btnTbl" id="selectedUser"><span>선택</span></a></td>';
					}else{
						trHtml += ' <td class="btn"></td>';
					}
					trHtml += '</tr>';
				});
				
				$("#searchUserListTable tbody").append(trHtml);
			},
			resetLosMapTree : function(name, xhr){
				$("#txtSrc").val("");
				$.returnGroup.callAjax("GET", "/business/record/return/ajax/losmap", "json", null, function(data){
					var itemData = data.item;
					losmap.deleteChildItems(0);
					$.returnGroup.loadDownLineTree(itemData, 0);
					$.returnGroup.loadDownLine($("#aboPk").val(), "-1");
				});
				return false;
			},
			alertLoadLosMapError : function(name, xhr){
				loadingLayerSClose();
				alert("LOS MAP Tree 로드 중 오류가 발생하였습니다.");
				//$.returnGroup.resetLosMapTree();
				return false;
			},
			setIdOfSelectedItem : function(id){
				$.returnGroup.data.selectedItemId = id;
				
				$("#searchYear").attr("disabled", true);
				$("#searchMonth").attr("disabled", true);
				
				$.returnGroup.data.selectedYear = $("#searchYear").val();
				$.returnGroup.data.selectedMonth = $("#searchMonth").val();
				
				var params = {};
				params.page	= 1;
				params.year = $.returnGroup.data.selectedYear;
				params.month = $.returnGroup.data.selectedMonth;
				params.id = $.returnGroup.data.selectedItemId;
				params.isPaging = false;
				
				$.returnGroup.searchReturnInGroupByDate(params);
			},
			validateSearchDownLine : function(){
				// 임시처리
				//$("#txtSrc").val($.trim($("#txtSrc").val()));
				if($("#txtSrc").val() == null || $("#txtSrc").val() ==""){
					alert("회원명 혹은 회원번호를 입력해주세요.");
					$("#txtSrc").focus();
					return false;
				}else{
					return true;
				}
			},
			searchReturnInGroupByDate : function(params){
				loadingLayerS();
				$.returnGroup.callAjax(
						"GET", "/business/record/return/abototal/ajax/returnInGroup", "html", params
					  , function(data){
							if(params.isPaging){
								$("#flickingTbody").append(data);
								$.returnGroup.appendFlickingToFixed();
								if(!$.returnGroup.data.useShowMoreGroup){
									$("#showMoreListReturnGroup").hide();
								}
							}else{
								$("#returnInGroupArea").html(data);
								$("#searchYear").attr("disabled", false);
								$("#searchMonth").attr("disabled", false);
							}
							flickingAreaS();
							$(window).trigger('resize');							
						}
				);
			},
			setMemberInfoToFormForDetail : function($obj){
				$("#returnOfUserSearchForm #distNoKey").val($obj.parents("th").find("#hiddenDistNoKey").val());
				$("#returnOfUserSearchForm #ordPeriod").val($obj.parents("th").find("#hiddenOrdPeriod").val());
				$("#returnOfUserSearchForm #bonPeriod").val($obj.parents("th").find("#hiddenBonPeriod").val());
				$("#returnOfUserSearchForm #pordPeriod").val($obj.parents("th").find("#hiddenPordPeriod").val());
			},
			searchReturnDetailOfUser : function(page, isPaging){
				loadingLayerS();
				$.returnGroup.callAjax(
						  "POST", "/business/record/return/abototal/ajax/detail", "html"
						, $("#returnOfUserSearchForm").serialize() + "&page=" + page + "&isPaging=" + isPaging
						, function(data){
							  if(isPaging){
								  $("#flickingTbody").append("<tr>" + data + "</tr>");
								  
								  $.returnGroup.appendFlickingToFixed();
								  if(!$.returnGroup.data.useShowMoreDetail){
									  $("#showMoreListInReturnDetail").hide();
								  }
							  }else{
								  $("#returnInGroupArea").html(data);
							  }
							  flickingAreaS();
							  $(window).trigger('resize');	
						  }
				);
			},
			// 반품제품 목록 페이징처리 (사용안함)
			getDetailPaginationData : function(page){
				$.returnGroup.callAjax(
									"POST"
								  , "/business/record/return/abototal/ajax/detailPaging"
								  , "html"
								  , $("#searchDataForPaging").val() + "&page=" + page
								  , function successCallBack(data){
									    flickingAreaS();
									    $(window).trigger('resize');	
								  	}
								  , null);
				return false;
			},
			appendFlickingToFixed : function(){
				var fixedTbodyStr = "";
				$("#flickingTbody").find("tr").each(function(){
					if($(this).find("th").html()){
						console.log("html : " + $(this).find("th").html());
						fixedTbodyStr += "<tr><th>" + $(this).find("th").html() + "</th></tr>";
					}else{
						$(this).remove();
					}
				});
				$("#fixedTbody").html(fixedTbodyStr);
			},
			getReturnDetailInfoList : function($obj){
				loadingLayerS();
				var actionUrl = $obj.attr("href");
				$.returnGroup.callAjax("GET", actionUrl, "html", null
						  , function(data){
								if($("#returnDetailInfoList").length){
									$("#returnDetailInfoList").html(data);
									$("#returnInGroupList").addClass("hide");
									$("#returnDetailInfoList").removeClass("hide");
									$("body, html").animate({ scrollTop: $("#returnDetailInfoList").offset().top }, 0);
								}else{
									var listHtml = $("section#pbContent").html();
									$.returnGroup.data.html = listHtml;
									$("section#pbContent").html(data);
									$("body, html").animate({ scrollTop: $("#pbContent").offset().top }, 0);
								}
							}
						  , function(){
							  	loadingLayerSClose();
								alert("반품 상세정보가 없습니다.");
						  	});
			}
	};

	// ############################################################################
	// 공통
	// ############################################################################

	// 탑업타입 레이어 팝업 호출
	$(document).on("click", "#btnTopUpType", function(){
		layerPopupOpen($(this))
		return false;
	});

	// ############################################################################
	// 보너스 연관 반품
	// ############################################################################

	// 검색
	$(document).on("change", "#myMonth", function(){
		var obj = $(this);
		var date = new Date();
		var dateYear = date.getFullYear();
		var dateMonth = Number($.returnGroup.data.closeMonth) || Number(date.getMonth());
		var year = $("#myYear").val();
		var month = $(this).val();
		var url = "/relatedbonus/ajax/list";
		
		if(dateMonth == 0){
			dateYear = Number(dateYear) - 1;
			dateMonth = 12;
		}

        var closeDate = new Date(date.getFullYear(), date.getMonth()-1, 1);
        var selectDate = new Date(year, month-1, 1);
        
		//if(year == dateYear && month > dateMonth){
        if( closeDate < selectDate ) {
			alert("보너스 연관 반품은 전월까지만 서비스 됩니다.");

			$("#myMonth").find("option:eq("+ (Number($("input[name=oldMonth]").val())-1).toString() + ")").attr("selected", true);
/*			
			obj.find("option").each(function(){
				if($(this).val() == dateMonth){
					obj.find("option").attr("selected", false);					
					$(this).attr("selected", true);	
				}
			});
			$.returnGroup.getSearchData(year, dateMonth, url, "B", $("#myYear"));
*/
		}else{
			$.returnGroup.getSearchData(year, month, url, "B", $("#myYear"));
		}
	});

	// 검색
	$(document).on("change", "#myYear", function(){
		var obj = $("#myMonth");
		var date = new Date();
		var dateYear = date.getFullYear();
		var dateMonth = Number($.returnGroup.data.closeMonth);		
		var year = $(this).val();
		var month = obj.val();
		var url = "/relatedbonus/ajax/list";
		
		if(dateMonth == 0){
			dateYear = Number(dateYear) - 1;
			dateMonth = 12;
		}		

        var closeDate = new Date(date.getFullYear(), date.getMonth()-1, 1);
        var selectDate = new Date(year, month-1, 1);
        
		//if(year == dateYear && month > dateMonth){
        if( closeDate < selectDate ) {
			alert("보너스 연관 반품은 전월까지만 서비스 됩니다.");

			$("#myYear").find("option").each(function(){
				if( $(this).val() == $("input[name=oldYear]").val() ) {
					$(this).attr("selected", true);	
				}
			});
/*			
			obj.find("option").each(function(){
				if($(this).val() == dateMonth){
					obj.find("option").attr("selected", false);
					$(this).attr("selected", true);
				}
			});

			$.returnGroup.getSearchData(year, dateMonth, url, "B", $("#myMonth"));
*/
		}else{
			$.returnGroup.getSearchData(year, month, url, "B", $("#myMonth"));
		}
	});

	// 탑업안내 레이어 팝업 호출
	$(document).on("click", "#openGuide", function(){
		layerPopupOpen($(this));
		return false;
	});		

	// ############################################################################
	// 나의탑업
	// ############################################################################

	$(document).on("change", "#selectYear", function(){
		var year = $(this).val();
		var url = "/topup/ajax/list";
		
		$.returnGroup.getSearchData(year, "", url, "M", $(this));
	});

	// ############################################################################
	// 다운라인 반품탑업
	// ############################################################################

	// 검색
	$(document).on("change", "#year", function(e){
		var obj = $("#month");
		var date = new Date();
		var closeYear = Number($.returnGroup.data.closeYear);
		var closeMonth = Number($.returnGroup.data.closeMonth) || Number(date.getMonth());	
		var year = $(this).val();
		var month = obj.val();
		var url = "/downline-topup/ajax/list";

		if(year == closeYear && month > closeMonth){
			alert(closeYear + "년 마감월인 " + closeMonth + "월까지 검색 가능합니다.");
			
			obj.find("option").each(function(){
				if($(this).val() == closeMonth){
					obj.find("option").attr("selected", false);
					$(this).attr("selected", true);	
				}
			});

			$.returnGroup.getSearchData(year, closeMonth, url, "D", $("#month"));
		}else{
			$.returnGroup.getSearchData(year, month, url, "D", $("#month"));
		}

		return false;
	});

	// 검색
	$(document).on("change", "#month", function(e){
		var obj = $(this);
		var date = new Date();
		var closeYear = Number($.returnGroup.data.closeYear)
		var closeMonth = Number($.returnGroup.data.closeMonth);
		var month = $(this).val();
		var year = $("#year").val();
		var url = "/downline-topup/ajax/list";

		if(year == closeYear && month > closeMonth){
			alert(closeYear + "년 마감월인 " + closeMonth + "월까지 검색 가능합니다.");

			obj.find("option").each(function(){
				if($(this).val() == closeMonth){
					obj.find("option").attr("selected", false);
					$(this).attr("selected", true);	
				}
			});

			$.returnGroup.getSearchData(year, closeMonth, url, "D", $("#year"));
		}else{
			$.returnGroup.getSearchData(year, month, url, "D", $("#year"));
		}

		return false;
	});

	// 탑업안내(다운라인) 레이어 팝업 호출
	$(document).on("click", "#openDownlineGuide", function(){
		layerPopupOpen($(this));
		return false;
	});
	
	// ############################################################################
	// 그룹내 총 반품
	// ############################################################################
	
	// 년/월 변경 이벤트 > 검색
	$(document).on("change", "#searchYear, #searchMonth", function(){
		
		$("#searchYear").attr("disabled", true);
		$("#searchMonth").attr("disabled", true);
		
		$.returnGroup.data.selectedYear = $("#searchYear").val();
		$.returnGroup.data.selectedMonth = $("#searchMonth").val();
		
		var params = {};
		params.page	= 1;
		params.year = $.returnGroup.data.selectedYear;
		params.month = $.returnGroup.data.selectedMonth;
		params.id = $.returnGroup.data.selectedItemId;
		params.isPaging = false;
		
		$.returnGroup.searchReturnInGroupByDate(params);
		return false;
	});
	
	// 더보기 그룹 목록
	$(document).on("click", "#showMoreListReturnGroup", function(e){

		$.returnGroup.data.groupPage++;
		
		var params = {};
		params.page	= $.returnGroup.data.groupPage;
		params.year = $.returnGroup.data.selectedYear;
		params.month = $.returnGroup.data.selectedMonth;
		params.id = $.returnGroup.data.selectedItemId;
		params.isPaging = true;
		
		$.returnGroup.searchReturnInGroupByDate(params);
		return false;
	});
	
	// 회원 검색
	$(document).on("click", "#searchDownlineMember", function(){
		$.returnGroup.setLosmapTreeBySearch($.trim($("#txtSrc").val()));
		return false;
	});
	
	// 회원 검색 엔터
	$(document).on("keydown", "#txtSrc", function() {
		if (event.keyCode == 13) {
			$.returnGroup.setLosmapTreeBySearch($.trim($("#txtSrc").val()));
		}
	});
	
	// 검색초기화
	$(document).on("click", "#uiSearchInit", function(){

		var params = {};
		params.page	= 1;
		params.year = $.returnGroup.data.currentYear;
		params.month = $.returnGroup.data.currentMonth;
		params.id = "";
		params.isPaging = false;
		
		$.returnGroup.data.selectedYear = $.returnGroup.data.currentYear;
		$.returnGroup.data.selectedMonth = $.returnGroup.data.currentMonth;

		$("#txtSrc").val("");
		$.returnGroup.setThisMonthAndYear();
		$.returnGroup.resetLosMapTree();
		$.returnGroup.searchReturnInGroupByDate(params);
		
		return false;
	});
	
	// 상세보기
	$(document).on("click", "#returnOfUserInfoDetail", function(){
		$.returnGroup.setMemberInfoToFormForDetail($(this));
		$.returnGroup.data.detailPage = 1;
		$.returnGroup.searchReturnDetailOfUser($.returnGroup.data.detailPage, false);
		return false;
	});
	
	// 더보기 상세
	$(document).on("click", "#showMoreListInReturnDetail", function(e){
		$.returnGroup.data.detailPage++;
		$.returnGroup.searchReturnDetailOfUser($.returnGroup.data.detailPage, true);
		return false;
	});
	
	// 목록으로 이동
	$(document).on("click", "#returnInGroup", function(){
		
		var params = {};
		params.page	= $.returnGroup.data.groupPage;
		params.year = $.returnGroup.data.selectedYear;
		params.month = $.returnGroup.data.selectedMonth;
		params.id = $.returnGroup.data.selectedItemId;
		params.isPaging = false;
		
		$.returnGroup.searchReturnInGroupByDate(params);
		return false;
	});
	
	// 반품내역 상세정보 이전 버튼
	$(document).off("click", "#historyBack").on("click", "#historyBack", function(e){
		if($("#returnDetailInfoList").length){
			$("#returnDetailInfoList").html("");
			$("#returnInGroupList").removeClass("hide");
			$("#returnDetailInfoList").addClass("hide");
			$("body, html").animate({ scrollTop: $("#returnDetailInfoList").offset().top }, 0); 
		}else{
			$("section#pbContent").html($.returnGroup.data.html);
		}
		return false;
	});

	// 반품내역 상세보기 클릭 이벤트
	$(document).on("click", "#returnProductView", function(e){
		$.returnGroup.getReturnDetailInfoList($(this));
		return false;
	});

})(jQuery);