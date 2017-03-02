<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/manager/frame/include/top.jsp" %>

<!-- js/이미지/공통  include -->
<%@ include file="/WEB-INF/jsp/manager/frame/include/include.jsp" %>
<style type="text/css">
	#crumbs {text-align: center;}
	#crumbs ul {list-style: none;display: inline-table;}
	#crumbs ul li {display: inline;}
	#crumbs ul li a {display: block;float: left;height: 20px;background: #3498db;text-align: center;padding: 10px 20px 10px 50px;position: relative;margin: 0 1px 0 0; font-size: 20px;text-decoration: none;color: #fff;}
	#crumbs ul li a:after {content: "";  border-top: 20px solid transparent;border-bottom: 20px solid transparent;border-left: 20px solid #3498db;position: absolute; right: -20px; top: 0;z-index: 1;}
	#crumbs ul li a:before {content: "";  border-top: 20px solid transparent;border-bottom: 20px solid transparent;border-left: 20px solid #d4f2ff;position: absolute; left: 0; top: 0;}
	#crumbs ul li:first-child a {border-top-left-radius: 0px; border-bottom-left-radius: 0px;}
	#crumbs ul li:first-child a:before {display: none; }
	#crumbs ul li:last-child a {padding-right: 80px;border-top-right-radius: 0px; border-bottom-right-radius: 0px;}
	#crumbs ul li:last-child a:after {display: none; }
	#crumbs ul li a:hover, #crumbs ul li a.on {background: #fa5ba5;}
	#crumbs ul li a:hover:after, #crumbs ul li a.on:after {border-left-color: #fa5ba5;}
</style>

<script type="text/javascript">
    $("#ifrm_main_${listseq.frmId}", parent.document).height(960);
    var selectMode = {};
    $(document.body).ready(function() {
        param={frmId:"${listseq.frmId}",menuAuth:"${param.menuAuth}"};
        pop.init();

     <c:if test="${listseq.roomMode eq 'I'}">
        //교육장으로 default 체크 - 등록시에만
        var typecheck = $("[name='typeseq']");
        var fcchecked = "";

        for(var i=0; i<typecheck.length;i++){
            fcchecked = $("#typefc"+i).attr("title");
            if(fcchecked == "교육장"){
                $("#typefc"+i).attr("checked", true);
            }
        }

     </c:if>

        $(".fileWrap").fileUpload(); // 파일업로드 셋팅

        if($("#partyType").val() >0){
           $("#btnNext").hide();
        }

        //목록이동
        $("#btnReturn").on("click",function(){
            var f = document.listForm;
            f.action = "/manager/reservation/facilityInfo/facilityInfoList.do";
            f.submit();
        });

    <c:if test="${listseq.roomMode eq 'U'}">
        //다음으로이동
        $("#btnNext").on("click",function(){
            //퀸룸파티룸 타입체크
            var typecheck = $(".typecheck");
            var fcchecked = "";
            var typeCheck = $(".typecheck:checked");
            $("#checkCount").val(typeCheck.length); //시설타입 갯수 셋팅

            for(var i=0; i<typecheck.length;i++){
                var checked = $(".typecheck:checked");

                if(checked.length>1){
                    fcchecked = $("#utypefc"+i).attr("title");
                    if(fcchecked == "퀸룸/파티룸"){
                        $("#sTypeseq").val($("#utypefc"+i).val());
                        $("#checkType").val("Y");
                    }
                }else{
                    $("#sTypeseq").val($("input[name='typeseq']:checked").val());
                }
            }
            pop.goTwoPage();
        });
     </c:if>
        //파일 초기화
        $("#reset").on("click",function(){
            $("[type='file']").val("");
        });

        //파일 추가
        $(".fileAdd").on("click",function(){
            var html = "";
            var num = $(".fileWrap ul li").length;

            if(num>9) {
                alert("파일을 10개 이상 업로드를 할 수 없습니다.");
                return;
            };

            if( !isNull($(".fileWrap > input[name='file"+num+"']")) ) {
                num = num;
            }

            html = '<li>';
            html += '<form id="fileForm'+num+'" method="POST" enctype="multipart/form-data">';
            html += '<span>이미지 설명 : </span>';
            html += '<input type="text" name="altText'+num+'" id="altText'+num+'">';
            html += '<input type="file" name="file" id="file'+num+'" style="width:30%;" title="파일첨부" onChange="javascript:html.filesize(this,'+num+');" />';
            html += '<input type="hidden" name="filekey" id="filekey'+num+'" title="파일번호" />';
            html += '<input type="hidden" name="oldfilekey" id="oldfilekey'+num+'" title="파일번호" />';
            html += '<a href="javascript:;" class="btn_gray btnFileDelete">삭제</a>';
            html += '</form>';
            html += '</li>';

            $(".fileWrap > ul").append(html);
        });

        $(".btnFileDelete1").on("click",function(){
            if(confirm("삭제하시겠습니까?")){
                $(this).closest("li").remove();
                return false;
            } else {
                return;
            }
        });
        myIframeResizeHeight("${listseq.frmId}");
    });

    var html = {
        filesize : function(file, num){
            var filebox = $("input:file")
            if( isNull(filebox) ) {
                if( isNull($("#oldfilekey"+num).val()) ) {
                    $("#filekey"+num).val("");
                } else {
                    $("#filekey"+num).val($("#oldfilekey"+num).val());
                }
                return;
            }

            var chkData = {
                "chkFile" : "jpg, jpeg, png,gif"
            };

            var ext = file.value.split('.').pop().toLowerCase();
            var opts = $.extend({},chkData);

            if(opts.chkFile.indexOf(ext) == -1) {
                alert(opts.chkFile + ' 파일만 업로드 할수 있습니다.');
                return;
            }

            $("#fileForm"+num).ajaxForm({
                url : "<c:url value="/manager/reservation/programInfo/fileUpload.do"/>"
                , method : "post"
                , async : false
                , type : "json"
                , beforeSend: function(xhr, settings) { showLoading(); }
                , success : function(data){
                    var obj = JSON.parse(data);
                    var items = obj.fileKey;

                    $("#filekey"+num).val(items);
                    $("#oldfilekey"+num).val(items);
                    hideLoading();
                }
                , error : function(data){
                    hideLoading();
                    //alert("[파일업로드] 처리도중 오류가 발생하였습니다.");
        			var mag = '[파일업로드] <spring:message code="errors.load"/>';
        			alert(mag);
                    
                }
            }).submit();
        }
    }

    var pop = {
        init : function(){
            //저장
            $("#btnSave").on("click",function(val){

                var typecheck = $("[name='typeseq']");
                var fcchecked = "";

                for(var i=0; i<typecheck.length;i++){
                    var fccheck = $("#typefc"+i).attr("title");

                    if($("#typefc"+i).is(":checked")){
                       if(isNull(fcchecked)) fcchecked = $("#typefc"+i).attr("title");

                       if((fccheck == "비즈룸"&&fcchecked == "퀸룸/파티룸") || (fccheck == "비즈룸"&&fcchecked == "교육장")){
                           alert("비즈룸은 단독으로만 선택가능 합니다.");
                           return;
                       }
                    }
                }

                if(!chkValidation({chkId:"#tblSearch", chkObj:"hidden|input|select"}) ){
                    return;
                }

                var startday = $("#startdate").val().replace("-","").replace("-","");
                var endday = $("#enddate").val().replace("-","").replace("-","");

                if(startday>endday || startday==endday){
                    alert("시작일과 종료일이 같을수없습니다.\n또는 시작일은 종료일을 넘길수 없습니다.");
                    return;
                }

				var typeseq = "";
				var $item = $("input[name='typeseq']");
    			
    			$item.each(function(i){
    				if( $(this).is(":checked") ) {
    					if(isNull(typeseq)) {
    						typeseq = typeseq + "" + $(this).val();
    					} else {
    						typeseq = typeseq + ","+$(this).val();
    					}
    				}
    			});

                if(isNull(typeseq)) {
    				alert("시설 타입 값이 없습니다. \n시설탑입은(는) 필수 입력값입니다.");
    				$("input[name='typeseq']").focus();
    				return;
    			}
    			if(isNull($("#intro").val())) {
    				alert("시설 소개 값이 없습니다. \n시설소개은(는) 필수 입력값입니다.");
    				$("#intro").focus();
    				return;
    			}
    			if(isNull($("#facility").val())) {
    				alert("부대시설 값이 없습니다. \n부대시설은(는) 필수 입력값입니다.");
    				$("#facility").focus();
    				return;
    			}

                $("input[name='typeseq']").on("click",function(){
                    if( $(this).is(":checked").length > 2 ) {
                        alert("3개 이상 선택 할 수 없습니다.");
                        $(this).prop("checked",false);
                        $("#facility").focus();
                    }
                });

                showLoading();
                if(confirm("시설타입정보는 등록 후 수정이 불가능합니다.\n진행하시겠습니까?")){
                    selectMode.mode = "I";
                    pop.doSave(selectMode.mode);
                } else {
                    hideLoading();	//로딩 끝
                }
            });
            //수정
            $("#btnUpdate").on("click",function(val){
                if(!chkValidation({chkId:"#tblSearch", chkObj:"hidden|input|select"}) ){
                    return;
                }

                var startday = $("#startdate").val().replace("-","").replace("-","");
                var endday = $("#enddate").val().replace("-","").replace("-","");

                if(startday>endday || startday==endday){
                    alert("시작일과 종료일이 같을수없습니다.\n또는 시작일은 종료일을 넘길수 없습니다.");
                    return;
                }

				var typeseq = "";
				var $item = $("input[name='typeseq']");
    			
    			$item.each(function(i){
    				if( $(this).is(":checked") ) {
    					if(isNull(typeseq)) {
    						typeseq = typeseq + "" + $(this).val();
    					} else {
    						typeseq = typeseq + ","+$(this).val();
    					}
    				}
    			});
    			if(isNull($("#intro").val())) {
    				alert("시설 소개 값이 없습니다. \n시설소개은(는) 필수 입력값입니다.");
    				$("input[name='typeseq']").focus();
    				return;
    			}
    			if(isNull($("#facility").val())) {
    				alert("부대시설 값이 없습니다. \n부대시설은(는) 필수 입력값입니다.");
    				$("input[name='typeseq']").focus();
    				return;
    			}

                showLoading();
                if(confirm("수정하시겠습니까?")){
                    selectMode.mode = "U";
                    pop.doSave(selectMode.mode);
                } else {
                    hideLoading();	//로딩 끝
                }
            });
        } // end Init
        , doSave : function(mode, fileKey,item, idx,alt,num){
            if(mode == "I") {
                var sUrl = "<c:url value="/manager/reservation/facilityInfo/facilityInfoDetailOneSave.do"/>";
                var sMsg = "등록하였습니다.";
                
                var $item = $("input[name='typeseq']");
				var typeseq = "";

    			$item.each(function(i){
    				if( $(this).is(":checked") ) {
    					if(isNull(typeseq)) {
    						typeseq = typeseq + "" + $(this).val();
    					} else {
    						typeseq = typeseq + ","+$(this).val();
    					}
    				}
    			});

                var usekeyword = $("#keyword").val().replace(/\s/gi, '');

    			var param = {
                    ppseq : $("#ppseq").val(),
                    roomname : $("#roomname").val(),
                    typeseq : typeseq,
                    startdate : $("#startdate").val(),
                    enddate : $("#enddate").val(),
                    statuscode : $("#statuscode").val(),
                    seatcount : $("#seatcount").val(),
                    usetime : $("#usetime").val(),
                    role : $("#role").val(),
                    rolenote : $("#rolenote").val(),
                    facility : $("#facility").val(),
                    keyword : usekeyword,
                    intro : $("#intro").val(),
                    filekey1:isNvl($("#filekey0").val(),"0"),
                    filekey2:isNvl($("#filekey1").val(),"0"),
                    filekey3:isNvl($("#filekey2").val(),"0"),
                    filekey4:isNvl($("#filekey3").val(),"0"),
                    filekey5:isNvl($("#filekey4").val(),"0"),
                    filekey6:isNvl($("#filekey5").val(),"0"),
                    filekey7:isNvl($("#filekey6").val(),"0"),
                    filekey8:isNvl($("#filekey7").val(),"0"),
                    filekey9:isNvl($("#filekey8").val(),"0"),
                    filekey10:isNvl($("#filekey9").val(),"0"),
                    alt1:isNvl($("#altText0").val(),""),
                    alt2:isNvl($("#altText1").val(),""),
                    alt3:isNvl($("#altText2").val(),""),
                    alt4:isNvl($("#altText3").val(),""),
                    alt5:isNvl($("#altText4").val(),""),
                    alt6:isNvl($("#altText5").val(),""),
                    alt7:isNvl($("#altText6").val(),""),
                    alt8:isNvl($("#altText7").val(),""),
                    alt9:isNvl($("#altText8").val(),""),
                    alt10:isNvl($("#altText9").val(),"")
                };
                
                $.ajaxCall({
                    url: sUrl
                    , data: param
                    , success: function( data, textStatus, jqXHR){
                        if(data.errCode < 0){
                            alert("처리도중 오류가 발생하였습니다.");
                        } else {
                            $("#roomseq").val(data.listseq);
                            var typeCheck = $("[name='typeseq']:checked");
                            $("#checkCount").val(typeCheck.length); //시설타입 갯수 셋팅

                            //퀸룸파티룸 타입체크
                            var typecheck = $("[name='typeseq']");
                            var fcchecked = "";

                            for(var i=0; i<typecheck.length;i++){
                                var checked = $("[name='typeseq']:checked");

                                if(checked.length>1){
                                    fcchecked = $("#typefc"+i).attr("title");
                                    if(fcchecked == "퀸룸/파티룸"){
                                        $("#sTypeseq").val($("#typefc"+i).val());
                                    }

                                }else{
                                    $("#sTypeseq").val($("input[name='typeseq']:checked").val());
                                }
                            }
                            alert(sMsg);
                            var sRoomSeq = data.listseq;
                            pop.goTwoPage(sRoomSeq);
                        }
                    },
                    error: function( jqXHR, textStatus, errorThrown) {
    					var mag = '<spring:message code="errors.load"/>';
    					alert(mag);
                    }
                });
            }

            if(mode == "U") {
                var sUrl = "<c:url value="/manager/reservation/facilityInfo/facilityInfoDetailOneUpdate.do"/>";
                var sMsg = "수정하였습니다.";

                //키워드 공백제거
                var usekeyword = $("#keyword").val().replace(/\s/gi, '');

                var param = {
                    roomseq : $("#roomseq").val(),
                    ppseq : $("#ppseq").val(),
                    roomname : $("#roomname").val(),
                    typeseq : $("input[name='sTypeseq']:checked").val(),
                    startdate : $("#startdate").val(),
                    enddate : $("#enddate").val(),
                    statuscode : $("#statuscode").val(),
                    seatcount : $("#seatcount").val(),
                    usetime : $("#usetime").val(),
                    role : $("#role").val(),
                    rolenote : $("#rolenote").val(),
                    facility : $("#facility").val(),
                    keyword : usekeyword,
                    intro : $("#intro").val(),
                    filekey1:isNvl($("#filekey0").val(),"0"),
                    filekey2:isNvl($("#filekey1").val(),"0"),
                    filekey3:isNvl($("#filekey2").val(),"0"),
                    filekey4:isNvl($("#filekey3").val(),"0"),
                    filekey5:isNvl($("#filekey4").val(),"0"),
                    filekey6:isNvl($("#filekey5").val(),"0"),
                    filekey7:isNvl($("#filekey6").val(),"0"),
                    filekey8:isNvl($("#filekey7").val(),"0"),
                    filekey9:isNvl($("#filekey8").val(),"0"),
                    filekey10:isNvl($("#filekey9").val(),"0"),
                    alt1:isNvl($("#altText0").val(),""),
                    alt2:isNvl($("#altText1").val(),""),
                    alt3:isNvl($("#altText2").val(),""),
                    alt4:isNvl($("#altText3").val(),""),
                    alt5:isNvl($("#altText4").val(),""),
                    alt6:isNvl($("#altText5").val(),""),
                    alt7:isNvl($("#altText6").val(),""),
                    alt8:isNvl($("#altText7").val(),""),
                    alt9:isNvl($("#altText8").val(),""),
                    alt10:isNvl($("#altText9").val(),"")
                };

                $.ajaxCall({
                    url: sUrl
                    , data: param
                    , success: function( data, textStatus, jqXHR){
                    	if(data.result.errCode < 0){
                            alert("처리도중 오류가 발생하였습니다.");
                        } else {
                            var typeCheck = $(".typecheck:checked");
                            $("#checkCount").val(typeCheck.length); //시설타입 갯수 셋팅
                            //퀸룸파티룸 타입체크
                            var typecheck = $(".typecheck");
                            var fcchecked = "";

                            for(var i=0; i<typecheck.length;i++){
                                var checked = $(".typecheck:checked");

                                if(checked.length>1){
                                    fcchecked = $("#utypefc"+i).attr("title");
                                    if(fcchecked == "퀸룸/파티룸"){
                                        $("#sTypeseq").val($("#utypefc"+i).val());
                                    }
                                }else{
                                    $("#sTypeseq").val($("input[name='typeseq']:checked").val());
                                }
                            }

                            alert(sMsg);
                            var sRoomSeq = $("#roomseq").val();
                            var partyType = "${ptype.roomseq}";

//                            if(partyType == 0){
                                pop.goTwoPage(sRoomSeq);
/*
                            }else{
                                var f = document.listForm;
                                f.action = "/manager/reservation/facilityInfo/facilityInfoList.do";
                                f.submit();
                            };
*/

                        }
                    },
                    error: function( jqXHR, textStatus, errorThrown) {
    					var mag = '<spring:message code="errors.load"/>';
    					alert(mag);
                    }
                });
            }

        }, goTwoPage : function(){
            var f = document.listForm;
            if($("#partCheck").val() == "1") {
                f.action = "/manager/reservation/facilityInfo/facilityInfoPartitionDetailTwo.do";
            } else {
                f.action = "/manager/reservation/facilityInfo/facilityInfoDetailTwo.do";
            }
            f.submit();
        }
    }

</script>
</head>

<body class="bgw">
<form:form id="listForm" name="listForm" method="post">
    <input type="hidden" id="roomseq" name="roomseq" value="${listseq.roomseq}"/>
    <input type="hidden" id="sTypeseq" name="sTypeseq" value="${listseq.sTypeseq}"/>
    <input type="hidden" id="roomMode" name="roomMode" value="${listseq.roomMode}"/>
    <input type="hidden" id="partyType" name="partyType" value="${detailpage.parentroomseq}"/>
    <input type="hidden" id ="checkType" name="checkType" />
    <input type="hidden" id="checkCount" name="checkCount" value=""/>
    <input type="hidden" name="frmId" value="${listseq.frmId}"/>
    <input type="hidden" name="menuAuth" id="menuAuth" value="${param.menuAuth}"/>
    <input type="hidden" name="partCheck" id="partCheck" value="${ptype.roomseq}"/>
</form:form>
<!--title //-->
    <div class="contents_title clear">
    	<c:if test="${listseq.roomMode eq 'I'}">
        	<h2 class="fl">시설 정보 등록</h2>
        </c:if>
        <c:if test="${listseq.roomMode eq 'U'}">
        	<h2 class="fl">시설 정보 상세</h2>
        </c:if>
    </div>

	<div id="crumbs">
		<ul>
			<li><a href="#1" class="on">1. 기본정보</a></li>
			<li><a href="#2">2.날짜/세션정보</a></li>
			<li><a href="#3">3.예약조건</a></li>
		</ul>
	</div>

    <!--search table // -->
    <div class="tbl_write" style="line-height: 13px;">
        <table id="tblSearch" width="100%" border="0" cellspacing="0" cellpadding="0">
        	<colgroup>
				<col width="12%" />
				<col width="38%"  />
				<col width="12%" />
				<col width="38%" />
			</colgroup>
            <tr>
                <th scope="row" >PP</th>
                <td>
                    <c:if test="${listseq.roomMode eq 'I'}">
                        <select id="ppseq" name="ppseq" class="required" title="PP명">
                            <option value="">선택</option>
                            <c:forEach var="item" items="${ppCodeList}">
                                <option value="${item.commonCodeSeq}" ${detailpage.ppseq eq item.commonCodeSeq ? "selected=\"selected\"" : "" }>${item.codeName}</option>
                            </c:forEach>
                        </select>
                    </c:if>
                    <c:if test="${listseq.roomMode eq 'U'}">
                        ${detailpage.ppname}
                        <input type="hidden" id="ppseq" class="required" value="${detailpage.ppseq}"/>
                    </c:if>
                </td>
                <th scope="row" >시설명</th>
                <td style="line-height: 2;">
                    <input type="text" class="AXInput required" style="min-width:303px;" id="roomname" maxlength="10" value="${detailpage.roomname}" title="시설명"/>
                    <br>(실제 시설명을 등록합니다. 예:101호 등)
                </td>
            </tr>
            <tr>
                <th scope="row" >시설 타입</th>
                <td id="facilitystatuscode">&nbsp;
                    <label class="required" title="시설 타입">
                        <c:forEach var="rsvType" items="${rsvType}" varStatus="status">
                            <label>
                                <c:if test="${listseq.roomMode eq 'I'}">
                                    <input type="checkbox" id="typefc${status.index }" name="typeseq" title="${rsvType.typename}"  value="${rsvType.typeseq}" ${detailpage.typeseq eq rsvType.typeseq ? "checked=\"checked\"" : ""}/> ${rsvType.typename}
                                </c:if>
                            </label>
                        </c:forEach>
                        <c:forEach var="updateType" items="${updateType}" varStatus="status">
                            <label style="text-align: left;">
                                <c:if test="${listseq.roomMode eq 'U'}">
                                    <input disabled="disabled" type="checkbox" id="utypefc${status.index }" class="typecheck" name="typeseq" title="${updateType.typename}" value="${updateType.typeseq}" ${! empty updateType.typeseq ? "checked=\"checked\"" : ""}/> ${updateType.typename}
                                </c:if>
                            </label>
                        </c:forEach>
                    </label>
                </td>
                <th scope="row" >운영기간</th>
                <td>
                    <input type="text" id="startdate" class="AXInput datepDay required" title="운영기간(시작)" readonly="readonly" value="${detailpage.startdate}">
                    ~
                    <input type="text" id="enddate" class="AXInput datepDay required" title="운영기간(종료)" readonly="readonly" value="${detailpage.enddate}">
                </td>
            </tr>
            <tr>
                <th scope="row" >상태</th>
                <td colspan="3">
                    <select id="statuscode" class="required" title="상태">
                        <option value="">선택</option>
                        <c:forEach var="item" items="${codeCombo}">
                            <option value="${item.commoncodeseq}" ${item.commoncodeseq eq detailpage.statuscodenm ? "selected=\"selected\"" : ""} >${item.codename}</option>
                        </c:forEach>
                    </select>
                </td>
            </tr>
            <tr>
                <th scope="row" >시설소개</th>
                <td colspan="3">
                    <textarea style="width:100%;min-width:700px;min-height: 80px;resize: none;" id="intro" maxlength="500" name="intro" class="required" title="시설소개">${detailpage.intro}</textarea>
                </td>
            </tr>
            <tr>
                <th scope="row" >정원</th>
                <td>
                    <input type="text" class="AXInput required" title="정원" style="min-width:100px;" id="seatcount" value="${detailpage.seatcount}" maxlength="100" oninput="maxLengthCheck(this)"/>
                </td>
                <th scope="row" >이용시간</th>
                <td>
                    <input type="text" class="AXInput required" title="이용시간" style="min-width:100px;" id="usetime" value="${detailpage.usetime}" maxlength="30" oninput="maxLengthCheck(this)"/>
                </td>
            </tr>
            <tr>
                <th >예약자격</th>
                <td>
                    <input type="text" class="AXInput required" title="예약자격" maxlength="60" style="min-width:303px;" id="role" value="${detailpage.role}"/>
                </td>
                <th >예약자격 부가설명</th>
                <td>
                    <input type="text" class="AXInput" title="예약자격 부가설명" maxlength="500" style="min-width:303px;" id="rolenote" value="${detailpage.rolenote}"/>
                </td>
            </tr>
            <tr>
                <th scope="row" >부대시설</th>
                <td colspan="3">
                    <textarea style="width:100%;min-width:700px;min-height: 80px;resize: none;" id="facility" maxlength="500" class="required" title="부대시설">${detailpage.facility}</textarea>
                </td>
            </tr>
            <tr>
                <th scope="row" >섬네일</th>
                <td colspan="3">
                    <div class="fileWrap">
	            		<ul>
                            <input type="button" value="파일초기화" id="reset" style="height: 28px;">
                            <c:if test="${listseq.roomMode eq 'I'}">
                              <c:if test="${empty detailfile}">
                                 <li>
                                    <form id="fileForm0" method="POST" enctype="multipart/form-data">
                                        <span>이미지 설명 : </span>
                                        <input type="text" name="altText0" id="altText0">
                                        <input type="file" name="file0" id="file0" style="width:30%;" title="파일첨부" onChange="javascript:html.filesize(this,0);" />
                                        <input type="hidden" name="filekey" id="filekey0" title="파일번호" />
                                        <input type="hidden" name="oldfilekey" id="oldfilekey0" title="파일번호" />
                                        <a href="#none" class="btn_green fileAdd">추가</a>
                                    </form>
                                  </li>
                              </c:if>
                            </c:if>
                            <c:if test="${listseq.roomMode eq 'U'}">
                                <c:if test="${empty detailfile}">
                                    <li>
                                        <form id="fileForm0" method="POST" enctype="multipart/form-data">
                                            <span>이미지 설명 : </span>
                                            <input type="text" name="altText0" id="altText0">
                                            <input type="file" name="file0" id="file0" style="width:30%;" title="파일첨부" onChange="javascript:html.filesize(this,0);" />
                                            <input type="hidden" name="filekey" id="filekey0" title="파일번호" />
                                            <input type="hidden" name="oldfilekey" id="oldfilekey0" title="파일번호" />
                                            <a href="#none" class="btn_green fileAdd">추가</a>
                                        </form>
                                    </li>
                                </c:if>
                              <c:if test="${!empty detailfile}">
                                <c:forEach var="items" items="${detailfile }" varStatus="status">
                                    <li>
                                        <form id="fileForm${status.index }" method="POST" enctype="multipart/form-data">
                                            <span>이미지 설명 : </span>
                                            <input type="text" name="altText${status.index }" id="altText${status.index }" value="${items.altdesc }" />
                                            <input type="file" name="file${status.index }" id="file${status.index }" style="width:30%;" title="파일첨부" value="${items.realfilename }" onChange="javascript:html.filesize(this,${status.index });"/>
                                            <input type="hidden" name="filekey" id="filekey${status.index }" title="파일번호" value="${items.filekey }" />
                                            <input type="hidden" name="oldfilekey" id="oldfilekey${status.index }" title="파일번호" value="${items.filekey }" />
                                            <c:if test="${status.index == 0}">
                                                <a href="#none" class="btn_green fileAdd">추가</a>
                                            </c:if>
                                            <c:if test="${status.index > 0}">
                                                <a href="javascript:;" class="btn_gray btnFileDelete1">삭제</a>
                                            </c:if>
                                            <div style="border-top:1px dotted #D5D5D5;width:98%;">등록 파일 : <a href="/manager/common/trfeefile/trfeeFileDownload.do?fileKey=${items.filekey }&uploadSeq=${items.uploadseq }&work=${items.work }" >${items.realfilename }</a></div>
                                        </form>
                                    </li>
                                </c:forEach>
                              </c:if>
                            </c:if>
	            		</ul>
                        <span>※이미지 설명은 이미지 등록시에만 적용 됩니다.</span>
	                </div>
                </td>
            </tr>
            <tr>
                <th scope="row" >검색용 키워드</th>
                <td colspan="3">
                    <input type="text" class="AXInput" title="키워드" style="width:95%;min-width:600px;" id="keyword" value="${detailpage.keyword}" maxlength="30" oninput="maxLengthCheck(this)" />
                    <br>콤마(,) 단위로 넣어 주세요.
                </td>
            </tr>
        </table>

        <div class="contents_title clear" style="padding-top: 15px;height: 15px;">
            <div class="fr">
                <c:if test="${listseq.roomMode eq 'I'}">
                <a href="javascript:;" id="btnSave" class="btn_green" style="vertical-align:middle; margin-left:0px;">저장</a>
                </c:if>
                <c:if test="${listseq.roomMode eq 'U'}">
                    <a href="javascript:;" id="btnUpdate" class="btn_green" style="vertical-align:middle; margin-left:0px;">수정</a>
                </c:if>
            </div>
            <div align="center">
                <a href="javascript:;" id="btnReturn" class="btn_gray">목록</a>
                <c:if test="${listseq.roomMode eq 'U'}">
                    <a href="javascript:;" id="btnNext" class="btn_gray">다음 단계로</a>
                </c:if>
            </div>
        </div>
    </div>

<!-- Board List -->

</body>