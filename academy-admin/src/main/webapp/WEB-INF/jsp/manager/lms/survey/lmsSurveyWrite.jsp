<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/manager/frame/include/top.jsp" %>

<!-- js/이미지/공통  include -->
<%@ include file="/WEB-INF/jsp/manager/frame/include/include.jsp" %>

<script type="text/javascript">
var managerMenuAuth ="${managerMenuAuth}";
var frmid = "${param.frmId}";
var prefrmid = "${param.prefrmId}"

AXConfig.AXGrid.fitToWidthRightMargin = -1;

var pageID = "AXGrid";
var AXGrid_instances = [];
var list = [];
var fnObj = {
    pageStart: function () {
        fnObj.grid.bind();
    },
    grid: {
        target: new AXGrid(),
        bind: function () {
            window.myGrid = fnObj.grid.target;

            var getColGroup = function () {
                return [
                    {key: "surveyseq", label: "", width: "40", align: "center", formatter:"checkbox", sort: false},
                    {key: "no", label: "No" , width: "50" , align: "center", sort: false },
                    {key: "surveyname", label: "설문문항", width: "400", align : "center", sort: false},
                    {key: "surveytypename", label: "설문유형", width: "100", align : "center", sort: false},
    				{
    					key: "manage", label : "수정", width: "80", align: "center", sort: false, formatter: function () {
   							return "<a href=\"javascript:;\" class=\"btn_green\" onclick=\"fn_update('U','" + this.item.surveyseq + "')\">수정</a>";
    					}
    				},
    				{key: "surveytype", label: "", width: "0", align : "center", sort: false, display:false},
    				{key: "samplecount", label: "", width: "0", align: "center", sort: false, display:false},
    				<c:forEach var="list" varStatus="idx" begin="1" end="10">
    				{key: "samplename_${list}", label: "", width: "0", align: "center", sort: false, display:false},
    				{key: "samplevalue_${list}", label: "", width: "0", align: "center", sort: false, display:false},
    				{key: "directyn_${list}", label: "", width: "0", align: "center", sort: false, display:false},
    				</c:forEach>
                ];
            };
            
            var getColHead = function () {
            	return { 
					heights: [25,25]
            	};
            };

            myGrid.setConfig({
                targetID: "AXGridTarget",
                sort: true, //정렬을 원하지 않을 경우 (tip
                colHeadTool: true, // column tool use
                fitToWidth: true, // 너비에 자동 맞춤
                colGroup: getColGroup(),
                colHead : getColHead(),
                colHeadAlign: "center", // 헤드의 기본 정렬 값. colHeadAlign 을 지정하면 colGroup 에서 정의한 정렬이 무시되고 colHeadAlign : false 이거나 없으면 colGroup 에서 정의한 속성이 적용됩니다.
                body: {
                    addClass: function () {
                        return (this.index % 2 == 0 ? "gray" : "white"); // red, green, blue, yellow, white, gray
                    }
                },
                page: {
                    display: false,
                    paging: false
                }
            });

        }
    }
};
$(document.body).ready(function() {
	
	fnObj.pageStart();
	
	//grid 다시 읽기
	if($("#inputtype").val()=="U") {
		//ajax 읽이서 그리드 호출하기
		var param = {
			inputtype : $("#inputtype").val()
			, courseid : $("#courseid").val()	
		};
		$.ajaxCall({
			url: "<c:url value="/manager/lms/survey/lmsSurveyWriteAjax.do"/>"
			, data: param
			, success: function(gridlist, textStatus, jqXHR){
				list = gridlist;
				
				myGrid.setList(list);
				
				//배열변수 list에 값 세팅하기
				$("#totalcount").text( list.length );
				
			},
			error: function( jqXHR, textStatus, errorThrown) {
	           	alert("<spring:message code="errors.load"/>");
			}
		});
	}
	
	$("#saveBtn").on("click", function(){
		if(checkManagerAuth(managerMenuAuth)){return;}
		if( $("#inputtype").val() == "U" && $("#responsecount").val() > 0  ) {
			alert("설문 응답자가 있어서 설문정보를 저장할 수 없습니다.");
			return;
		}
		fnSubmit();
	});
	
	$("#cancelBtn").on("click", function(){
		closeTapAndGoTap(frmid, prefrmid);
	});
	
	$("#insertButton").on("click", function(){
		if(checkManagerAuth(managerMenuAuth)){return;}
		if( $("#inputtype").val() == "U" && $("#responsecount").val() > 0  ) {
			alert("설문 응답자가 있어서 설문문항을 등록할 수 없습니다.");
			return;
		}

		fn_insert('I','');
		return;
	});
	
	$("#deleteButton").on("click", function(){
		if(checkManagerAuth(managerMenuAuth)){return;}
		if( $("#inputtype").val() == "U" && $("#responsecount").val() > 0  ) {
			alert("설문 응답자가 있어서 설문문항을 삭제할 수 없습니다.");
			return;
		}
		
		var deleteChk = "";
		var checkedList = myGrid.getCheckedListWithIndex(0);// colSeq
		for(var i = 0; i < checkedList.length; i++){
			deleteChk += checkedList[i].item.surveyseq + ",";
		}
		
		if( deleteChk != "" ) {
			deleteChk = deleteChk.substring(0, deleteChk.length-1);
		}
		
		if( deleteChk == "") {
			alert("삭제할 설문문항을 선택하세요.");
			return;
		}
		
		var atferList = [];
		var result = confirm("선택한 설문문항을 삭제 하겠습니까?"); 
		if( result ) {
			var delArr = deleteChk.split(",");
			
			var newIdx = 0;
			for( var i=0; i<list.length; i++ ) {
				var isChecked = false;
				for( var k=0; k<delArr.length; k++ ) {
					if( list[i].surveyseq == delArr[k] ) {
						isChecked = true;
					}
				}
				
				if( !isChecked ) {
					atferList[newIdx] = list[i];
					atferList[newIdx].surveyseq = newIdx+1;
					atferList[newIdx].no = newIdx+1;
					
					newIdx ++;
				}
			}
			
			list = atferList;
			
			myGrid.setList(list);
			$("#totalcount").text( list.length );
			
		}
	});
	
	$("#aExcdlDown").on("click", function(){
		var result = confirm("엑셀 내려받기를 시작 하겠습니까?\n 네트워크 상황에 따라서 1~3분 정도 시간이 걸릴 수 있습니다."); 
		if(result) {
			showLoading();
			
			var param = fn_getValue();
			
			postGoto("/manager/lms/survey/lmsSurveyWriteExcelDown.do", param);
			hideLoading();
		}
    	
    });
});

function fn_getValue() {
	//그리드의 데이터를 hidden에 담아서 보낼것
	var surveyseqArr = [];
	var surveynameArr = [];
	var surveytypeArr = [];
	var surveytypenameArr = [];
	var samplecountArr = [];
	var directyn_1Arr = [];
	var samplename_1Arr = [];
	var samplevalue_1Arr = [];
	var directyn_2Arr = [];
	var samplename_2Arr = [];
	var samplevalue_2Arr = [];
	var directyn_3Arr = [];
	var samplename_3Arr = [];
	var samplevalue_3Arr = [];
	var directyn_4Arr = [];
	var samplename_4Arr = [];
	var samplevalue_4Arr = [];
	var directyn_5Arr = [];
	var samplename_5Arr = [];
	var samplevalue_5Arr = [];
	var directyn_6Arr = [];
	var samplename_6Arr = [];
	var samplevalue_6Arr = [];
	var directyn_7Arr = [];
	var samplename_7Arr = [];
	var samplevalue_7Arr = [];
	var directyn_8Arr = [];
	var samplename_8Arr = [];
	var samplevalue_8Arr = [];
	var directyn_9Arr = [];
	var samplename_9Arr = [];
	var samplevalue_9Arr = [];
	var directyn_10Arr = [];
	var samplename_10Arr = [];
	var samplevalue_10Arr = []; 

	for(var i=0; i<list.length; i++){
		surveyseqArr[i] = list[i].surveyseq;
		surveynameArr[i] = list[i].surveyname.replace(/,/g, "WNBC");
		if( surveynameArr[i] == "" ) surveynameArr[i] = "WNB";
		surveytypeArr[i] = list[i].surveytype;
		if( surveytypeArr[i] == "" ) surveytypeArr[i] = "WNB";
		surveytypenameArr[i] = list[i].surveytypename;
		if( surveytypenameArr[i] == "" ) surveytypenameArr[i] = "WNB";
		
		samplecountArr[i] = list[i].samplecount;
		if( samplecountArr[i] == "" ) samplecountArr[i] = "WNB";
		directyn_1Arr[i] = list[i].directyn_1;
		if( directyn_1Arr[i] == "" ) directyn_1Arr[i] = "WNB";
		samplename_1Arr[i] = list[i].samplename_1.replace(/,/g, "WNBC");
		if( samplename_1Arr[i] == "" ) samplename_1Arr[i] = "WNB";
		samplevalue_1Arr[i] = list[i].samplevalue_1;
		if( samplevalue_1Arr[i] == "" ) samplevalue_1Arr[i] = "WNB";
		directyn_2Arr[i] = list[i].directyn_2;
		if( directyn_2Arr[i] == "" ) directyn_2Arr[i] = "WNB";
		samplename_2Arr[i] = list[i].samplename_2.replace(/,/g, "WNBC");
		if( samplename_2Arr[i] == "" ) samplename_2Arr[i] = "WNB";
		samplevalue_2Arr[i] = list[i].samplevalue_2;
		if( samplevalue_2Arr[i] == "" ) samplevalue_2Arr[i] = "WNB";
		directyn_3Arr[i] = list[i].directyn_3;
		if( directyn_3Arr[i] == "" ) directyn_3Arr[i] = "WNB";
		samplename_3Arr[i] = list[i].samplename_3.replace(/,/g, "WNBC");
		if( samplename_3Arr[i] == "" ) samplename_3Arr[i] = "WNB";
		samplevalue_3Arr[i] = list[i].samplevalue_3;
		if( samplevalue_3Arr[i] == "" ) samplevalue_3Arr[i] = "WNB";
		directyn_4Arr[i] = list[i].directyn_4;
		if( directyn_4Arr[i] == "" ) directyn_4Arr[i] = "WNB";
		samplename_4Arr[i] = list[i].samplename_4.replace(/,/g, "WNBC");
		if( samplename_4Arr[i] == "" ) samplename_4Arr[i] = "WNB";
		samplevalue_4Arr[i] = list[i].samplevalue_4;
		if( samplevalue_4Arr[i] == "" ) samplevalue_4Arr[i] = "WNB";
		directyn_5Arr[i] = list[i].directyn_5;
		if( directyn_5Arr[i] == "" ) directyn_5Arr[i] = "WNB";
		samplename_5Arr[i] = list[i].samplename_5.replace(/,/g, "WNBC");
		if( samplename_5Arr[i] == "" ) samplename_5Arr[i] = "WNB";
		samplevalue_5Arr[i] = list[i].samplevalue_5;
		if( samplevalue_5Arr[i] == "" ) samplevalue_5Arr[i] = "WNB";
		directyn_6Arr[i] = list[i].directyn_6;
		if( directyn_6Arr[i] == "" ) directyn_6Arr[i] = "WNB";
		samplename_6Arr[i] = list[i].samplename_6.replace(/,/g, "WNBC");
		if( samplename_6Arr[i] == "" ) samplename_6Arr[i] = "WNB";
		samplevalue_6Arr[i] = list[i].samplevalue_6;
		if( samplevalue_6Arr[i] == "" ) samplevalue_6Arr[i] = "WNB";
		directyn_7Arr[i] = list[i].directyn_7;
		if( directyn_7Arr[i] == "" ) directyn_7Arr[i] = "WNB";
		samplename_7Arr[i] = list[i].samplename_7.replace(/,/g, "WNBC");
		if( samplename_7Arr[i] == "" ) samplename_7Arr[i] = "WNB";
		samplevalue_7Arr[i] = list[i].samplevalue_7;
		if( samplevalue_7Arr[i] == "" ) samplevalue_7Arr[i] = "WNB";
		directyn_8Arr[i] = list[i].directyn_8;
		if( directyn_8Arr[i] == "" ) directyn_8Arr[i] = "WNB";
		samplename_8Arr[i] = list[i].samplename_8.replace(/,/g, "WNBC");
		if( samplename_8Arr[i] == "" ) samplename_8Arr[i] = "WNB";
		samplevalue_8Arr[i] = list[i].samplevalue_8;
		if( samplevalue_8Arr[i] == "" ) samplevalue_8Arr[i] = "WNB";
		directyn_9Arr[i] = list[i].directyn_9;
		if( directyn_9Arr[i] == "" ) directyn_9Arr[i] = "WNB";
		samplename_9Arr[i] = list[i].samplename_9.replace(/,/g, "WNBC");
		if( samplename_9Arr[i] == "" ) samplename_9Arr[i] = "WNB";
		samplevalue_9Arr[i] = list[i].samplevalue_9;
		if( samplevalue_9Arr[i] == "" ) samplevalue_9Arr[i] = "WNB";
		directyn_10Arr[i] = list[i].directyn_10;
		if( directyn_10Arr[i] == "" ) directyn_10Arr[i] = "WNB";
		samplename_10Arr[i] = list[i].samplename_10.replace(/,/g, "WNBC");
		if( samplename_10Arr[i] == "" ) samplename_10Arr[i] = "WNB";
		samplevalue_10Arr[i] = list[i].samplevalue_10;
		if( samplevalue_10Arr[i] == "" ) samplevalue_10Arr[i] = "WNB";
	}

	var initParam = {
		inputtype : $("#inputtype").val()	
		, courseid : $("#courseid").val()
		, openflag : $("#openflag").val()
		, categoryid : $("#categoryid").val()
		, coursename : $("#coursename").val()
		, coursecontent : $("#coursecontent").val()
		, startdate : $("#startdate").val()
		, enddate : $("#enddate").val()
		, surveyseqArr : surveyseqArr	
		, surveynameArr : surveynameArr
		, surveytypeArr : surveytypeArr
		, surveytypenameArr : surveytypenameArr
		, samplecountArr : samplecountArr
		, directyn_1Arr : directyn_1Arr
		, samplename_1Arr : samplename_1Arr
		, samplevalue_1Arr : samplevalue_1Arr
		, directyn_2Arr : directyn_2Arr
		, samplename_2Arr : samplename_2Arr
		, samplevalue_2Arr : samplevalue_2Arr
		, directyn_3Arr : directyn_3Arr
		, samplename_3Arr : samplename_3Arr
		, samplevalue_3Arr : samplevalue_3Arr
		, directyn_4Arr : directyn_4Arr
		, samplename_4Arr : samplename_4Arr
		, samplevalue_4Arr : samplevalue_4Arr
		, directyn_5Arr : directyn_5Arr
		, samplename_5Arr : samplename_5Arr
		, samplevalue_5Arr : samplevalue_5Arr
		, directyn_6Arr : directyn_6Arr
		, samplename_6Arr : samplename_6Arr
		, samplevalue_6Arr : samplevalue_6Arr
		, directyn_7Arr : directyn_7Arr
		, samplename_7Arr : samplename_7Arr
		, samplevalue_7Arr : samplevalue_7Arr
		, directyn_8Arr : directyn_8Arr
		, samplename_8Arr : samplename_8Arr
		, samplevalue_8Arr : samplevalue_8Arr
		, directyn_9Arr : directyn_9Arr
		, samplename_9Arr : samplename_9Arr
		, samplevalue_9Arr : samplevalue_9Arr
		, directyn_10Arr : directyn_10Arr
		, samplename_10Arr : samplename_10Arr
		, samplevalue_10Arr : samplevalue_10Arr
	};	
	
	return initParam;
}

var fnSubmit = function(){
	$("#categoryid").val($("#searchcategoryid").val());
	if(!chkValidation({chkId:"#frm", chkObj:"hidden|input|select|textarea"}) ){
		return;
	}
	var startdateyymmdd = $("#startdateyymmdd").val(); 
	var startdatehh = $("#startdatehh").val();
	var startdatemm = $("#startdatemm").val();
	var enddateyymmdd = $("#enddateyymmdd").val(); 
	var enddatehh = $("#enddatehh").val();
	var enddatemm = $("#enddatemm").val();
	
	var startdate = startdateyymmdd + " " + startdatehh + ":" + startdatemm + ":00"; 
	var enddate = enddateyymmdd + " " + enddatehh + ":" + enddatemm + ":00";
		
	if(startdateyymmdd == ""){
		alert("설문시작일을 선택해 주세요.");
		return;
	}
	if(enddateyymmdd == ""){
		alert("설문종료일을 선택해 주세요.");
		return;
	}
	if(startdate > enddate){
		alert("실문시작일시가 실문종료일시보다 이후입니다. \n설문기간을 확인해 주세요.");
		return;
	}
	$("#startdate").val(startdate);
	$("#enddate").val(enddate);
	
	//설문소개 500자 자르기
	if( $("#coursecontent").val().length > 500 ) {
		alert("설문소개를 500자 이내로 입력해 주세요.");
		return;
	}
	
	//설문답변 확인
	if( list.length <= 0 ) {
		alert("설문문항을 등록해 주세요.");
		return;
	}
	
	//설문응답자가 있으면 설문 수정하지 못함 : 기간만 수정이 가능함
	if(!confirm("설문을 저장하겠습니까?")){
		return;
	}
	
	var param = fn_getValue();
	
	$.ajaxCall({
   		url: "<c:url value="/manager/lms/survey/lmsSurveySaveAjax.do"/>"
   		, data: param
   		, success: function( data, textStatus, jqXHR){
   			if(data.result < 1){
           		alert("<spring:message code="errors.load"/>");
           		return;
   			} else {
   				alert("저장이 완료되었습니다.");
   				closeTapAndGoTap(frmid, prefrmid);
   			}
   		},
   		error: function( jqXHR, textStatus, errorThrown) {
           	alert("<spring:message code="errors.load"/>");
   		}
   	});
}

function fn_insert( modeVal, surveyseqVal) {
	var param = {
		inputtype : modeVal
		, surveyseq : surveyseqVal
	};
	var popParam = {
		url : "<c:url value="/manager/lms/survey/lmsSurveyPop.do" />"
		, width : 800
		, height : 600
		, maxHeight : 600
		, params : param
		, targetId : "searchPopup"
	}
	window.parent.openManageLayerPopup(popParam);
}
function fn_update( modeVal, surveyseqVal) {
	if( $("#inputtype").val() == "U" && $("#responsecount").val() > 0  ) {
		alert("설문 응답자가 있어서 설문문항을 수정할 수 없습니다.");
		return;
	}
	
	//list에서 정보 읽기
	var item = myGrid.list[surveyseqVal-1];
	var param = {
		inputtype : modeVal
		, surveyseq: item.surveyseq
		, surveyname: item.surveyname 
		, surveytype: item.surveytype
		, surveytypename: item.surveytypename
		, samplecount : item.samplecount
		, directyn_1 : item.directyn_1
		, samplename_1 : item.samplename_1
		, samplevalue_1 : item.samplevalue_1
		, directyn_2 : item.directyn_2
		, samplename_2 : item.samplename_2
		, samplevalue_2 : item.samplevalue_2
		, directyn_3 : item.directyn_3
		, samplename_3 : item.samplename_3
		, samplevalue_3 : item.samplevalue_3
		, directyn_4 : item.directyn_4
		, samplename_4 : item.samplename_4
		, samplevalue_4 : item.samplevalue_4
		, directyn_5 : item.directyn_5
		, samplename_5 : item.samplename_5
		, samplevalue_5 : item.samplevalue_5
		, directyn_6 : item.directyn_6
		, samplename_6 : item.samplename_6
		, samplevalue_6 : item.samplevalue_6
		, directyn_7 : item.directyn_7
		, samplename_7 : item.samplename_7
		, samplevalue_7 : item.samplevalue_7
		, directyn_8 : item.directyn_8
		, samplename_8 : item.samplename_8
		, samplevalue_8 : item.samplevalue_8
		, directyn_9 : item.directyn_9
		, samplename_9 : item.samplename_9
		, samplevalue_9 : item.samplevalue_9
		, directyn_10 : item.directyn_10
		, samplename_10 : item.samplename_10
		, samplevalue_10 : item.samplevalue_10
	};
	var popParam = {
		url : "<c:url value="/manager/lms/survey/lmsSurveyPop.do" />"
		, width : 800
		, height : 600
		, maxHeight : 600
		, params : param
		, targetId : "searchPopup"
	}
	window.parent.openManageLayerPopup(popParam);
}

function fn_addGrid( inputVal ) {
	list.push({
		surveyseq: list.length + 1 ,
		no: list.length + 1 ,
		surveyname: inputVal.surveyname , 
		surveytype: inputVal.surveytype ,
		surveytypename: inputVal.surveytypename ,
		samplecount: inputVal.samplecount ,
		
		directyn_1: inputVal.sampleList[0][0],
		samplename_1: inputVal.sampleList[0][1],
		samplevalue_1: inputVal.sampleList[0][2],
		directyn_2: inputVal.sampleList[1][0],
		samplename_2: inputVal.sampleList[1][1],
		samplevalue_2: inputVal.sampleList[1][2],
		directyn_3: inputVal.sampleList[2][0],
		samplename_3: inputVal.sampleList[2][1],
		samplevalue_3: inputVal.sampleList[2][2],
		directyn_4: inputVal.sampleList[3][0],
		samplename_4: inputVal.sampleList[3][1],
		samplevalue_4: inputVal.sampleList[3][2],
		directyn_5: inputVal.sampleList[4][0],
		samplename_5: inputVal.sampleList[4][1],
		samplevalue_5: inputVal.sampleList[4][2],
		directyn_6: inputVal.sampleList[5][0],
		samplename_6: inputVal.sampleList[5][1],
		samplevalue_6: inputVal.sampleList[5][2],
		directyn_7: inputVal.sampleList[6][0],
		samplename_7: inputVal.sampleList[6][1],
		samplevalue_7: inputVal.sampleList[6][2],
		directyn_8: inputVal.sampleList[7][0],
		samplename_8: inputVal.sampleList[7][1],
		samplevalue_8: inputVal.sampleList[7][2],
		directyn_9: inputVal.sampleList[8][0],
		samplename_9: inputVal.sampleList[8][1],
		samplevalue_9: inputVal.sampleList[8][2],
		directyn_10: inputVal.sampleList[9][0],
		samplename_10: inputVal.sampleList[9][1],
		samplevalue_10: inputVal.sampleList[9][2],
	});
	
	myGrid.setList(list);
	
	$("#totalcount").text( list.length );
}

function fn_updateGrid( inputVal ) {
	list[inputVal.surveyseq - 1] = {
		surveyseq: inputVal.surveyseq ,
		no: inputVal.surveyseq ,
		surveyname: inputVal.surveyname , 
		surveytype: inputVal.surveytype ,
		surveytypename: inputVal.surveytypename ,
		samplecount: inputVal.samplecount ,
		
		directyn_1: inputVal.sampleList[0][0],
		samplename_1: inputVal.sampleList[0][1],
		samplevalue_1: inputVal.sampleList[0][2],
		directyn_2: inputVal.sampleList[1][0],
		samplename_2: inputVal.sampleList[1][1],
		samplevalue_2: inputVal.sampleList[1][2],
		directyn_3: inputVal.sampleList[2][0],
		samplename_3: inputVal.sampleList[2][1],
		samplevalue_3: inputVal.sampleList[2][2],
		directyn_4: inputVal.sampleList[3][0],
		samplename_4: inputVal.sampleList[3][1],
		samplevalue_4: inputVal.sampleList[3][2],
		directyn_5: inputVal.sampleList[4][0],
		samplename_5: inputVal.sampleList[4][1],
		samplevalue_5: inputVal.sampleList[4][2],
		directyn_6: inputVal.sampleList[5][0],
		samplename_6: inputVal.sampleList[5][1],
		samplevalue_6: inputVal.sampleList[5][2],
		directyn_7: inputVal.sampleList[6][0],
		samplename_7: inputVal.sampleList[6][1],
		samplevalue_7: inputVal.sampleList[6][2],
		directyn_8: inputVal.sampleList[7][0],
		samplename_8: inputVal.sampleList[7][1],
		samplevalue_8: inputVal.sampleList[7][2],
		directyn_9: inputVal.sampleList[8][0],
		samplename_9: inputVal.sampleList[8][1],
		samplevalue_9: inputVal.sampleList[8][2],
		directyn_10: inputVal.sampleList[9][0],
		samplename_10: inputVal.sampleList[9][1],
		samplevalue_10: inputVal.sampleList[9][2],
	};
	
	myGrid.setList(list);
}

function closeTapAndGoTap(closeid, goid){
	try {
		window.parent.setValueTabMenu(goid);
		window.parent.listRefresh(goid);
		window.parent.closeTabMenu(closeid);
	} catch( e ) {
	}
}
</script>
</head>
<body class="bgw">
	<div class="contents_title clear">
		<h2 class="fl">설문등록</h2>
	</div>
	
	<div class="tbl_write">
<form id="frm" name="frm" method="post">
<input type="hidden" id="inputtype" name="inputtype" value="${inputtype}" />
<input type="hidden" id="responsecount" name="responsecount" value="${responsecount}" />
<input type="hidden" id="courseid" name="courseid" value="${detail.courseid}" />

<input type="hidden" id="openflag" name="openflag" value="C" />

		<strong> 기본정보</strong>
		<table id="tblSearch" width="100%" border="0" cellspacing="0" cellpadding="0">
			<colgroup>
				<col width="10%" />
				<col width="*" />
			</colgroup>		
			<tr>
				<th>설문 분류</th>
				<td> 
					<input type="hidden" id="categoryid" name="categoryid" value="${detail.categoryid}"  class="required" title="설문 분류"/>
					<c:set var="courseTypeCode" value="V"/>
					<%@ include file="/WEB-INF/jsp/manager/lms/include/lmsSearchCategory.jsp" %>
				</td>
			</tr>
			<tr>
				<th>설문명</th>
				<td><input type="text" id="coursename" name="coursename" style="width:90%;" value="${detail.coursename}" class="AXInput required" maxlength="50" title="설문명"></td>
			</tr>
			<tr>
				<th>설문기간</th>
				<td>
					<span class="required"></span>
					<input type="hidden" id="startdate" name="startdate"> 
					<input type="hidden" id="enddate" name="enddate">
					<input type="text" id="startdateyymmdd" name="startdateyymmdd"  value="${detail.startdateyymmdd}" title="설문시작일" class="AXInput datepDay" >
					<select id="startdatehh" name="startdatehh" style="width:auto; min-width:80px"  title="설문시작시" >
						<c:forEach items="${ hourList}" var="data" varStatus="status">
							<option value="${data.value }" <c:if test="${detail.startdatehh eq data.value}" >selected</c:if>>${data.name }</option>
						</c:forEach>
					</select>	
					<select id="startdatemm" name="startdatemm" style="width:auto; min-width:100px" title="설문시작분" >
						<c:forEach items="${ minute2List}" var="data" varStatus="status">
							<option value="${data.value }" <c:if test="${detail.startdatemm eq data.value}" >selected</c:if>>${data.name }</option>
						</c:forEach>
					</select>	
					 ~  
					<input type="text" id="enddateyymmdd" name="enddateyymmdd"  value="${detail.enddateyymmdd}" title="설문종료일" class="AXInput datepDay" >
					<select id="enddatehh" name="enddatehh" style="width:auto; min-width:80px"  title="설문종료시" >
						<c:forEach items="${ hourList}" var="data" varStatus="status">
							<option value="${data.value }" <c:if test="${detail.enddatehh eq data.value}" >selected</c:if>>${data.name }</option>
						</c:forEach>
					</select>
					<select id="enddatemm" name="enddatemm" style="width:auto; min-width:80px" title="설문종료분" >
						<c:forEach items="${ minute2List}" var="data" varStatus="status">
							<option value="${data.value }" <c:if test="${detail.enddatemm eq data.value}" >selected</c:if>>${data.name }</option>
						</c:forEach>
					</select>	
				</td>
			</tr>	
			<tr>
				<th>설문소개</th>
				<td>
					<textarea id="coursecontent" name="coursecontent" class="AXInput required" style="width:90%;height:100px;" title="설문소개">${detail.coursecontent}</textarea>
				</td>
			</tr>									
		</table>
		
</form>
	</div>

	<strong> 설문문항 정보</strong>
		
	<div class="contents_title clear" style="padding-top:5px;">
		<div class="fl">
			<a href="javascript:;" id="deleteButton" class="btn_green">삭제</a>
			<a href="javascript:;" id="aExcdlDown" class="btn_excel" style="vertical-align:middle; margin-left:0px;">엑셀 다운</a>
			
			
			<span> Total : <span id="totalcount">0</span>건</span>
		</div>
		
		<div class="fr">
			<div style="float:right;">
				<a href="javascript:;" id="insertButton" class="btn_green">등록</a>
			</div>
		</div>
	</div>

	<!-- grid -->
	<div id="AXGrid">
		<div id="AXGridTarget"></div>
	</div>
		
	<div align="center">
		<a href="javascript:;" id="saveBtn" class="btn_green">저장</a>&nbsp;&nbsp;
		<a href="javascript:;" id="cancelBtn" class="btn_green">취소</a>
	</div>
</body>
</html>