(function($) {
	$.returnList = {
			data : {
				page			: 1
			  , currentYear		: 0
			  , currentMonth	: 0
			  , currentDate		: 0
			  , useShowMore		: false
			  , searchData		: ""
			  , fromDetail		: false
			  , selectedStartDay: 0
			  , selectedEndDay	: 0
			},
			init : function(){
				loadingLayerSClose();
				
				$.returnList.setCalendarView();
				$.returnList.replaceTypeLabel();
				
				if(!$.returnList.data.fromDetail){
					$.returnList.setThisMonth($.returnList.data.currentMonth, false);
				}else{
					$.returnList.setDateOption($("#searchStartMonth"));
					$.returnList.setDateOption($("#searchEndMonth"));
				}

				$.returnList.changeAttributeBySelectVal($("#searchType"));
				$.returnList.setHiddenSearchData(false);
				
				$.returnList.setActBtnByCurrentDate();
				//$.returnList.sortOptionByVal();
			},
			changeAttributeBySelectVal : function($obj){
				var inputType = "";
				if($obj.val()== "RETURNCODE" || $obj.val()== "VPS"){
					inputType = "tel";
				}else{
					inputType = "text";
				}
				var inputBox = $("<div/>").append($("<input />", {id : "searchValue", name : "searchValue", type : inputType, title : "검색값", style : "width:100%;"})).html();
				$(".tggCnt .inputSel p:eq(1)").html(inputBox);
				if($obj.val()== "ALL"){
					$("#searchValue").val("");
					$("#searchValue").attr("disabled", true);
				}else{
					$("#searchValue").attr("disabled", false);
				}
			},
			replaceTypeLabel : function(){
				$(".inputBox input[name='returnType']").each(function(){
					var $optionLabel = $(this).parent().find("label");
					$optionLabel.addClass("mgNone");
					if($(this).val() == "ALL"){
						$optionLabel.text("전체");
						$(this).attr("checked", true)
					}
				});
				
				$("#searchType").children().each(function(){
					if($(this).val() == "ALL"){
						$(this).text("검색조건 전체");
					}
				});
			},
			setCalendarView : function(){
				$("#myReturnSearchForm select[id$='Year']").each(function(){
					$(this).children().each(function(){
						$(this).text($(this).val() + "년");
					});
				});
				$("#myReturnSearchForm select[id$='Month']").each(function(){	
					$(this).children().each(function(){
						$(this).text($(this).val() + "월");
					});
				});
				$("#myReturnSearchForm select[id$='Day']").each(function(){	
					$(this).children().each(function(){
						$(this).text($(this).val() + "일");
					});
				});
			},
			setDateOption : function(selMonthObj){
				
				var year = selMonthObj.parents(".innerBx").find("select[id$='Year']").val();
				var month = selMonthObj.parents(".innerBx").find("select[id$='Month']").val();
				
				var orgCalendar = new Date(year, month, 1); //select box의 값으로 Date 생성
				var calendar = new Date(orgCalendar.setDate(orgCalendar.getDate() - 1)); // 이번달 Date 생성
				var endDayOfCalendar = calendar.getDate(); // 이번달 말일

				selMonthObj.parents(".innerBx").find("select[id$='Day'] option").remove();// day option 삭제
				for (var iLoop = 1; iLoop <= endDayOfCalendar; iLoop++) {
					selMonthObj.parents(".innerBx").find("select[id$='Day']").append("<option value='" + iLoop + "'>" + iLoop + "일</option>");
				}

				if($.returnList.data.fromDetail){
					$("#searchStartDay").val($.returnList.data.selectedStartDay);
					$("#searchEndDay").val($.returnList.data.selectedEndDay);
				}else if(selMonthObj.attr("id").indexOf("End") != -1){
					$("#searchEndDay option:last").attr("selected", "selected");
				}
			},
			setThisMonth : function(month, isToday){
				var orgCalendar = new Date($.returnList.data.currentYear, month, 1); // 서버에서 내려받은 날짜로 Date 생성
				var calendar = new Date(orgCalendar.setDate(orgCalendar.getDate() - 1)); // 이번달 달력 생성
				var endDayOfCalendar = calendar.getDate(); // 말일
				
				var yearVal = calendar.getFullYear(); // 년
				var monthVal = calendar.getMonth() + 1; // 월
				var firstDayVal, endDayVal; // 일
				if(isToday){ // 오늘
					firstDayVal = $.returnList.data.currentDate;
					endDayVal = $.returnList.data.currentDate;
				}else{ // 1일, 말일
					firstDayVal = 1;
					endDayVal = endDayOfCalendar;
				}
				
				$("#searchStartYear, #searchEndYear").val(yearVal).attr("selected", "selected");
				$("#searchStartMonth, #searchEndMonth").val(monthVal).attr("selected", "selected");
				
				$.returnList.setDateOption($("#searchStartMonth"));
				$.returnList.setDateOption($("#searchEndMonth"));
				
				$("#searchStartDay").val(firstDayVal).attr("selected", "selected");
				$("#searchEndDay").val(endDayVal).attr("selected", "selected");
			},
			setActiveBtn : function($obj){
				$obj.parent(".btnGrp").find("a").each(function(){
					if($obj.attr("id") == $(this).attr("id")){
						$(this).attr('class', 'btnTbl on');
					}else{
						$(this).attr('class', 'btnTbl');
					}
				});
			},
			setActBtnByCurrentDate : function(){
				var orgCalendar = new Date($.returnList.data.currentYear, $.returnList.data.currentMonth, 1);
				var calendar = new Date(orgCalendar.setDate(orgCalendar.getDate() - 1)); // 이번달
				
				var searchStartCalendar = new Date($("#searchStartYear").val(), $("#searchStartMonth").val() - 1, $("#searchStartDay").val());
				var searchEndCalendar = new Date($("#searchEndYear").val(), $("#searchEndMonth").val() - 1, $("#searchEndDay").val());
				
				if(calendar.getTime() == searchEndCalendar.getTime()){
					calendar.setDate(1);
					if(calendar.getTime() == searchStartCalendar.getTime()){
						$("#btnCurrentMonth").attr('class', 'btnTbl on');
					}else{
						$(".btnGrp").find("a").each(function(){
							$(this).attr('class', 'btnTbl');
						});
					}
				}else{
					$(".btnGrp").find("a").each(function(){
						$(this).attr('class', 'btnTbl');
					});
				}
			},
			sortOptionByVal : function(){ // select box option 정렬
				var sort = $("#searchType>option").sort(function(before, after){ 
						return before.value < after.value ? -1 : before.value > after.value ? 1 : 0;
				});
				$("#searchType").empty();
				$("#searchType").append(sort);
				$("#searchType>option:first").attr("selected","selected");
			},
			searchReturnInfo : function(){

				if(!$.returnList.validateSearchForm()){
					loadingLayerSClose();
					return false;
				}
				
				$("#myReturnSearchForm #page").val(1);

				$.returnList.callAjax(
									  "POST"
									, "/shop/myorder/return/ajax/search"
									, "html"
									, $("#myReturnSearchForm").serialize()
									, function successCallBack(data){
										  $("#returnInfoListTable").html(data);
										  $(".btnWrapC input[type=submit]").blur();
									  }
									, null);
				
				return false;
			},
			validateSearchForm : function(){
				// 날짜 체크
				var startDate = new Date($("#searchStartYear").val(), $("#searchStartMonth").val(), $("#searchStartDay").val()); 
				var endDate = new Date($("#searchEndYear").val(), $("#searchEndMonth").val(), $("#searchEndDay").val()); 
				
				if(startDate > endDate){
					alert("검색 기간의 시작일이 종료일보다 클 수 없습니다.");
					return false;
				}
				
				// 검색 조건 입력 체크
				if($("#searchType").val() != "ALL" && ($("#searchValue").val() == null || $("#searchValue").val() == "")){
					alert("검색어를 입력해 주세요.");
					$("#searchValue").focus();
					return false;
				}
				
				// 검색 조건이 VPS 나 반품 번호인 상태에서 검색어에 문자를 입력했을 경우
				var isNumberInput = false;
				if($("#searchType").val() == "RETURNCODE" || $("#searchType").val() == "VPS"){
					isNumberInput = true;
				}
				
				if(isNumberInput && !$.isNumeric($("#searchValue").val())){
					alert($.msg.common.inputOnlyNumber);
					$("#searchValue").focus();
					return false;
				}
				return true;
			},
			setHiddenSearchData : function(fromDetail){
				$.returnList.data.page = 1;
				$("#myReturnSearchForm #fromDetail").val(fromDetail);
				$("#searchDataForPaging").val($("#myReturnSearchForm").serialize());
			},
			getPaginationData : function(page){
				$.returnList.callAjax(
									"POST"
								  , "/shop/myorder/return/ajax/search"
								  , "html"
								  , $("#searchDataForPaging").val() + "&page=" + page
								  , function successCallBack(data){
										$("#returnInfoList").append(data);
										if(!$.returnList.data.useShowMore){
											$("#showMoreListInMyReturn").hide();
										}
								  	}
								  , null);
				return false;
			},
			callAjax : function(type, url, dataType, data, successCallBack, errorCallBack){
				$.ajax({
					type     : type,
					url      : url,
					dataType : dataType,
					data     : data,
					success: function (data){
						if( typeof successCallBack === 'function' ) { successCallBack(data); }
						return false;
					},
					error: function(xhr, st, err){
						xhr = null;
						// alert(err);
						if( typeof errorCallBack === 'function' ) { 
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
			}
	};
	
	$.returnDetail = {
			//
	};
	
	// 더보기
	$(document).on("click", "#showMoreListInMyReturn", function(e){
		loadingLayerS();
		$.returnList.data.page++;
		$.returnList.getPaginationData($.returnList.data.page);
		return false;
	});
	
	// 조회버튼 클릭 이벤트
	$(document).on("click", "#SubmitMyReturnSearchForm", function(){
		loadingLayerS();
		$.returnList.setActBtnByCurrentDate();
		$.returnList.setHiddenSearchData(false);
		$.returnList.searchReturnInfo();
		return false;
	});
	
	// 검색 엔터 이벤트
	$(document).on("keydown", "#searchValue", function(e){
		if (e.keyCode == 13) {
			loadingLayerS();
			$.returnList.setActBtnByCurrentDate();
			$.returnList.setHiddenSearchData(false);
			$.returnList.searchReturnInfo();
			return false;
		}
	});
	
	// 당일 클릭 이벤트
	$(document).on("click", "#btnCurrentDay", function(){
		$.returnList.setActiveBtn($(this));
		$.returnList.setThisMonth($.returnList.data.currentMonth, true);
		return false;
	});
	
	// 당월 클릭 이벤트
	$(document).on("click", "#btnCurrentMonth", function(){
		$.returnList.setActiveBtn($(this));
		$.returnList.setThisMonth($.returnList.data.currentMonth, false);
		return false;
	});
	
	// 전월 클릭 이벤트
	$(document).on("click", "#btnLastMonth", function(){
		$.returnList.setActiveBtn($(this));
		$.returnList.setThisMonth($.returnList.data.currentMonth - 1, false);
		return false;
	});
	
	// 년 셀렉트박스 변경 이벤트
	$(document).on("change", "#searchStartYear, #searchEndYear", function(){
		$.returnList.setActBtnByCurrentDate();
	});
	
	// 월 셀렉트박스 변경 이벤트
	$(document).on("change", "#searchStartMonth, #searchEndMonth", function(){
		$.returnList.setActBtnByCurrentDate();
		$.returnList.setDateOption($(this));
	});
	
	// 검색조건 셀렉스박스 변경 이벤트
	$(document).on("change", "#searchType", function(){
		$.returnList.changeAttributeBySelectVal($(this));
		return false;
	});
	
	// AP안내 팝업
	$(document).on("click", "#apInfo", function(){
		var apCode = $(this).attr("href").replace("#", "");
		var popupUrl = "/customer/apinfo?apCode=" + apCode;
		window.open(popupUrl);
		return false;
	});
	
	// 상세보기로 이동
	$(document).on("click", "#goReturnDetail", function(){
		var pageStr = $(".paging span.list strong").text();
		$("#myReturnSearchForm #fromDetail").val(false);
		$("#myReturnSearchForm").append("<input id='page' name='page' type='hidden' value='" + $.returnList.data.page + "'>");
		$("#myReturnSearchForm").attr("action", $(this).attr("href"));
		$("#myReturnSearchForm").attr("method", "POST");
		$("#myReturnSearchForm").submit();
		return false;
	});
	
	// 목록으로 이동
	$(document).on("click", "#goMyReturnList", function(){
		$("#myReturnSearchForm #fromDetail").val(true);
		$("#myReturnSearchForm").attr("action", "/shop/myorder/return");
		$("#myReturnSearchForm").attr("method", "POST");
		$("#myReturnSearchForm").submit();
		return false;
	});

})(jQuery);

