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
    var selectMode = {};

    $(document.body).ready(function() {
        param={frmId:"${param.frmId}",menuAuth:"${param.menuAuth}"};

        $(".fileWrap").fileUpload();

        //목록이동
        $("#btnReturn").on("click",function(){
            var f = document.listForm;
            f.action = "/manager/reservation/programInfo/programInfoList.do";
            f.submit();
        });

        //다음으로이동
        $("#btnNext").on("click",function(){
            btnEvent.goTwoPage();
        });

        //DEPTH에 따라서 화면 변화
        var categorytype1= $("#category").val();
        var categorytype2= $("#category2").val();
        var categorytype3= $("#category3").val();
        var nump = $("#nump").val();
        var numg = $("#numg").val();
        var unmInt = $("#unmInt").val();

        if(categorytype1=="E03") {
            if (categorytype2 == "E0301") {
                $(".brandmix").hide();
                $(".brandrightexp").hide();
                $(".brand").show();
                $(".pcontent").show();
                $("#category3").show();
                if(isNull(nump)){
                    $("#personhide").hide();
                    $("#seatcounthide").show();
                    $("#seatInt").hide();
                }else{
                    $("#personhide").show();
                    $("#seatcounthide").hide();
                    $("#seatInt").show();
                }
            } else if (categorytype2 == "E0302" || categorytype2 == "E0303") {
                $(".brand").hide();
                $(".brandrightexp").hide();
                $(".brandmix").show();
                if(isNull(nump)){
                    $("#personhide").hide();
                    $("#seatcounthide").show();
                    $("#seatInt").hide();
                }else{
                    $("#personhide").show();
                    $("#seatcounthide").hide();
                    $("#seatInt").show();
                }
            } else if (categorytype2 == "E0304") {
                $(".brand").hide();
                $(".brandmix").hide();
                $(".pcontent").hide();
                $(".pusetimenote").hide();
                $(".brandrightexp").show();
                if(isNull(nump)){
                    $("#personhide").hide();
                    $("#seatcounthide").show();
                    $("#seatInt").hide();
                }else{
                    $("#personhide").show();
                    $("#seatcounthide").hide();
                    $("#seatInt").show();
                }
            }
            myIframeResizeHeight("${layerMode.frmId}");
        }else if(categorytype1=="E04"){
            $(".brand").hide();
            $(".culture").show();

            $("#personhide").show();
            $("#seatcounthide").hide();
            $("#seatInt").show();
            $("#categorytype2 option").remove();
            $("#categorytype3 option").remove();
            $("#categorytype2").hide();
            $("#categorytype3").hide();
        }else{
            $(".brand").hide();
            $(".culture").show();
            $(".sumcheck").show();

            $("#personhide").show();
            $("#seatcounthide").hide();
            $("#seatInt").hide();
            $(".themaname").hide();
            $("#categorytype2 option").remove();
            $("#categorytype3 option").remove();
            $("#categorytype2").hide();
            $("#categorytype3").hide();
        };

        fnInit();

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
            html += '<a href="javascript:;" class="btn_gray btnFileDelete">삭제</a>'
            html += '</form>';
            html += '</li>';

            $(".fileWrap > ul").append(html);
        });

    });

    //파일 저장
    var html = {
        filesize : function(file, num){
            var filebox = $("input:file")
            if( isNull(filebox)) {
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
    				var mag = '[파일업로드] <spring:message code="errors.load"/>';
    				alert(mag);
                }
            }).submit();
        },
        othersize : function(file, num){

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

    var categorytype1 = {};
    var categorytype2 = {};
    var categorytype3 = {};

    // 화면 초기화
    function fnInit() {
        var cagori1 = 0;
        var cagori2 = 0;
        var cagori3 = 0;

        $.ajaxCall({
            url : "<c:url value="/manager/reservation/programInfo/programInfoDetailOneInit.do"/>"
            , method : "post"
            , success: function( data, textStatus, jqXHR){
                $.each(data.dataList, function (i,val) {
                    if(val.div=="CATE1") {
                        categorytype1[cagori1] = { minorCd : val.type
                            , cdName  : val.name
                            , upCode  : val.uptype}
                        cagori1 = cagori1+1;
                    }
                    if(val.div=="CATE2") {
                        categorytype2[cagori2] = { minorCd : val.type
                            , cdName  : val.name
                            , upCode  : val.uptype}
                        cagori2 = cagori2+1;
                    }
                    if(val.div=="CATE3") {
                        categorytype3[cagori3] = { minorCd : val.type
                            , cdName  : val.name
                            , upCode  : val.uptype}
                        cagori3 = cagori3+1;
                    }
                });

                // 카테고리 1
                var tmpHTML = "";

                $.each(categorytype1, function (i,val) {
                    tmpHTML = tmpHTML + "<option value='"+val.minorCd+"'>"+val.cdName+"</option>";
                });

                $("#categorytype1").append(tmpHTML);
            },
            error: function( jqXHR, textStatus, errorThrown) {
				var mag = '<spring:message code="errors.load"/>';
				alert(mag);
            }
        });
    }

    var btnEvent = {
        btnSave : function() {
            //공통
            var startdate = $("[name='startdate']").val();
            var enddate = $("[name='enddate']").val();
            var pp = $("[name='ppseq']").val();
            var statuscode = $("[name='statuscode']").val();
            var productname = $("[name='productname']").val();

            // 프로그램소개
            var pcontent = $("[name='content']").val();
            //프로그램개요
            var intro = $("[name='intro']").val();
            //테마명
            var themename = $("[name='themename']").val();
            //정원(개인)
            var seatcount1 = $("[name='seatcount1']").val();
            //정원(그룹)
            var seatcount2 = $("[name='seatcount2']").val();
            //개인정원인원
            var seatcount = $("[name='seatcount']").val();
            //체험시간
            var usetime = $("[name='usetime']").val();
            //체험시간부가설명
            var usetimenote = $("[name='usetimenote']").val();
            //예약자격
            var role = $("[name='role']").val();
            //예약자격부가설명
            var rolenote = $("[name='rolenote']").val();
            //준비물
            var preparation = $("[name='preparation']").val();
            //키워드
            var keyword = $("[name='keyword']").val();

            var nump = $("#nump").val();
            var numg = $("#numg").val();
            var numInt = $("#numInt").val();

            var depth1 = $("[name='category']").val();
            var depth2 = $("[name='category2']").val();

            var startday = $("[name='startdate']").val().replace("-","").replace("-","");
            var endday = $("[name='enddate']").val().replace("-","").replace("-","");

            if(startday>endday || startday==endday){
                alert("시작일과 종료일이 같을수없습니다.\n또는 시작일은 종료일을 넘길수 없습니다.");
                return;
            };

            //공통
            if(isNull(startdate)){
                alert("시작시간 값이 없습니다. \n시작시간 입력값입니다.");
                $("[name='startdate']").focus();
                return;
            }

            if(isNull(enddate)){
                alert("종료시간 값이 없습니다. \n종료시간 은(는) 필수 입력값입니다.");
                $("[name='enddate']").focus();
                return;
            }

            if(isNull(enddate)){
                alert("프로그램명 값이 없습니다. \n프로그램명 은(는) 필수 입력값입니다.");
                $("[name='productname']").focus();
                return;
            }

            if(isNull(pp)){
                alert("PP 값이 없습니다. \nPP은(는) 필수 입력값입니다.");
                $("[name='ppseq']").focus();
                return;
            }

            if(isNull(statuscode)){
                alert("프로그램 상태 값이 없습니다. \n프로그램 상태은(는) 필수 입력값입니다.");
                $("[name='statuscode']").focus();
                return;
            }

            if(depth1 == "E03") {
                //브랜드체험
                if(depth2 == "E0301"){
                    //브랜드체험 - 브랜드셀렉트
                    if(isNull(pcontent)){
                        alert("프로그램 소개 값이 없습니다. \n프로그램 소개 은(는) 필수 입력값입니다.");
                        $("[name='content']").focus();
                        return;
                    }

                    if(isNull(intro)){
                        alert("프로그램 개요 값이 없습니다. \n프로그램 개요 은(는) 필수 입력값입니다.");
                        $("[name='intro']").focus();
                        return;
                    }

                    if(isNull(nump) && isNull(numg)){
                        alert("정원 개인/그룹 하나만 입력해 주십시오.");
                        $("[name='seatcount1']").focus();
                        return;
                    }

                    if(nump.length > 0 && numg.length > 0){
                        alert("정원은 개인/그룹중 하나만 입력 가능 합니다.");
                        $("[name='seatcount1']").focus();
                        return;
                    }

                    if(!isNull(nump) && isNull(numInt)){
                        alert("개인정원인원은 개인일 경우 필수 입력값입니다.");
                        $("[name='seatcount']").focus();
                        return;
                    }

                    if(isNull(usetime)){
                        alert("체험시간 값이 없습니다. \n체험시간 은(는) 필수 입력값입니다.");
                        $("[name='usetime']").focus();
                        return;
                    }

                    if(isNull(role)){
                        alert("예약자격 값이 없습니다. \n 예약자격 은(는) 필수 입력값입니다.");
                        $("[name='role']").focus();
                        return;
                    }

                    if(isNull(preparation)){
                        alert("준비물값이 없습니다. \n 준비물(는) 필수 입력값입니다.");
                        $("[name='preparation']").focus();
                        return;
                    }
                } else if (depth2 == "E0302" || depth2 == "E0303") {
                    //브랜드 믹스 , 투어
                    if(isNull(pcontent)){
                        alert("프로그램 소개 값이 없습니다. \n프로그램 소개 은(는) 필수 입력값입니다.");
                        $("[name='content']").focus();
                        return;
                    }

                    if(isNull(nump) && isNull(numg)){
                        alert("정원 개인/그룹 하나만 입력해 주십시오.");
                        $("[name='seatcount1']").focus();
                        return;
                    }

                    if(nump.length > 0 && numg.length > 0){
                        alert("정원은 개인/그룹중 하나만 입력 가능 합니다.");
                        $("[name='seatcount1']").focus();
                        return;
                    }

                    if(!isNull(nump) && isNull(numInt)){
                        alert("개인정원인원은 개인일 경우 필수 입력값입니다.");
                        $("[name='seatcount']").focus();
                        return;
                    }

                    if(isNull(usetime)){
                        alert("체험시간 값이 없습니다. \n체험시간 은(는) 필수 입력값입니다.");
                        $("[name='usetime']").focus();
                        return;
                    }

                    if(isNull(role)){
                        alert("예약자격 값이 없습니다. \n 예약자격 은(는) 필수 입력값입니다.");
                        $("[name='role']").focus();
                        return;
                    }

                    if(isNull(preparation)){
                        alert("준비물값이 없습니다. \n 준비물(는) 필수 입력값입니다.");
                        $("[name='preparation']").focus();
                        return;
                    }
                } else if (depth2 == "E0304") {
                    // 맞춤식체험
                    if (isNull(intro)) {
                        alert("프로그램 개요 값이 없습니다. \n프로그램 개요 은(는) 필수 입력값입니다.");
                        $("[name='intro']").focus();
                        return;
                    }

                    if (isNull(nump) && isNull(numg)) {
                        alert("정원 개인/그룹 하나만 입력해 주십시오.");
                        $("[name='seatcount1']").focus();
                        return;
                    }

                    if (nump.length > 0 && numg.length > 0) {
                        alert("정원은 개인/그룹중 하나만 입력 가능 합니다.");
                        $("[name='seatcount1']").focus();
                        return;
                    }

                    if (!isNull(nump) && isNull(numInt)) {
                        alert("개인정원인원은 개인일 경우 필수 입력값입니다.");
                        $("[name='seatcount']").focus();
                        return;
                    }

                    if (isNull(usetime)) {
                        alert("체험시간 값이 없습니다. \n체험시간 은(는) 필수 입력값입니다.");
                        $("[name='usetime']").focus();
                        return;
                    }

                    if (isNull(role)) {
                        alert("예약자격 값이 없습니다. \n 예약자격 은(는) 필수 입력값입니다.");
                        $("[name='role']").focus();
                        return;
                    }

                    if (isNull(preparation)) {
                        alert("준비물값이 없습니다. \n 준비물(는) 필수 입력값입니다.");
                        $("[name='preparation']").focus();
                        return;
                    }
                }
            }else if(depth1 == "E04"){
                // 문화체험
                if(isNull(pcontent)){
                    alert("프로그램 소개 값이 없습니다. \n프로그램 소개 은(는) 필수 입력값입니다.");
                    $("[name='content']").focus();
                    return;
                }

                if(isNull(themename)){
                    alert("테마명 값이 없습니다. \n 테마명 은(는) 필수 입력값입니다.");
                    $("[name='themename']").focus();
                    return;
                }

                if(isNull(seatcount1)){
                    alert("인원(개인) 값이 없습니다. \n인원(개인) 은(는) 필수 입력값입니다.");
                    $("[name='seatcount1']").focus();
                    return;
                }

                if(isNull(seatcount)){
                    alert("개인정원인원은 필수 입력값입니다.");
                    $("[name='seatcount']").focus();
                    return;
                }

                if(isNull(usetime)){
                    alert("체험시간 값이 없습니다. \n체험시간 은(는) 필수 입력값입니다.");
                    $("[name='usetime']").focus();
                    return;
                }

                if(isNull(role)){
                    alert("예약자격 값이 없습니다. \n 예약자격 은(는) 필수 입력값입니다.");
                    $("[name='role']").focus();
                    return;
                }
            }else if(depth1 == "E02" || depth1 == "E01"){
                // 측정
                if(isNull(pcontent)){
                    alert("프로그램 소개 값이 없습니다. \n프로그램 소개 은(는) 필수 입력값입니다.");
                    $("[name='content']").focus();
                    return;
                }

                if(isNull(seatcount1)){
                    alert("인원(개인) 값이 없습니다. \n인원(개인) 은(는) 필수 입력값입니다.");
                    $("[name='seatcount1']").focus();
                    return;
                }

                if(isNull(usetime)){
                    alert("체험시간 값이 없습니다. \n체험시간 은(는) 필수 입력값입니다.");
                    $("[name='usetime']").focus();
                    return;
                }

                if(isNull(role)){
                    alert("예약자격 값이 없습니다. \n 예약자격 은(는) 필수 입력값입니다.");
                    $("[name='role']").focus();
                    return;
                }

                if(isNull(preparation)){
                    alert("준비물값이 없습니다. \n 준비물(는) 필수 입력값입니다.");
                    $("[name='preparation']").focus();
                    return;
                }
            }

            if($("[name='categorytype1'] option:selected").val()=="E04"){
                if(confirm("수정하시겠습니까?")){
                    btnEvent.doSave("");
                    return;
                }
            }else{
                btnEvent.doSaveFile();
            }

        },
        doSaveFile : function() {
            // 파일 저장 후 doSave 호춯(파일 키 리턴)
            // 파일 저장 후 doSave 호춯(파일 키 리턴)
            showLoading();
          //  if(confirm("프로그램타입정보는 등록 후 수정이 불가능합니다.\n진행하시겠습니까?")){
                btnEvent.doSave();
          //  }
        }
        , doSave : function(){
            var param = {
                productname:$("[name='productname']").val(),
                themename:$("[name='themename']").val(),
                ppseq : $("[name='ppseq'] option:selected").val(),
                intro : $("[name='intro']").val(),
                content : $("[name='content']").val(),
                time1 :$("[name='time1']").val(),
                note1 :$("[name='note1']").val(),
                time2 :$("[name='time2']").val(),
                note2 :$("[name='note2']").val(),
                time3 :$("[name='time3']").val(),
                note3 :$("[name='note3']").val(),
                startdate : $("[name='startdate']").val(),
                enddate : $("[name='enddate']").val(),
                statuscode : $("[name='statuscode'] option:selected").val(),
                seatcount1 : $("[name='seatcount1']").val(),
                seatcount2 : $("[name='seatcount2']").val(),
                seatcount : $("[name='seatcount']").val(),
                usetime : $("[name='usetime']").val(),
                usetimenote:$("[name='usetimenote']").val(),
                role : $("[name='role']").val(),
                rolenote : $("[name='rolenote']").val(),
                preparation : $("[name='preparation']").val(),
                keyword : $("[name='keyword']").val(),
                expseq : $("#expseq").val(),
                filekey1:isNvl($("#filekey0").val(),"0"),
                filekey2:isNvl($("#filekey1").val(),"0"),
                filekey3:isNvl($("#filekey2").val(),"0"),
                filekey4:isNvl($("#filekey3").val(),"0"),
                filekey5:isNvl($("#filekey4").val(),"0"),
                filekey6:isNvl($("#filekey6").val(),"0"),
                filekey7:isNvl($("#filekey7").val(),"0"),
                filekey8:isNvl($("#filekey8").val(),"0"),
                filekey9:isNvl($("#filekey9").val(),"0"),
                filekey10:isNvl($("#filekey10").val(),"0"),
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
                url: "<c:url value="/manager/reservation/programInfo/programInfoUpdate.do"/>"
                , data: param
                , success: function( data, textStatus, jqXHR){
                    if(data.result.errCode < 0){
                        var msg = '<spring:message code="errors.load"/>';
                        alert(msg);
                    } else if(data.result.errCode == 2) {
                        alert("이미 등록되어 사용중인 프로그램이 있습니다.");
                    } else {
                        btnEvent.goTwoPage($("#category").val($("[name='categorytype1']").val()));
                        alert("수정했습니다.");
                    }
                },
                error: function( jqXHR, textStatus, errorThrown) {
    				var mag = '<spring:message code="errors.load"/>';
    				alert(mag);
                }
            });

        },  goTwoPage : function(){
            var f = document.listForm;
            f.listMode.value = "U";
            f.action = "/manager/reservation/programInfo/programInfoDetailTwo.do";
            f.submit();
        }
    }

    function onlyNumber(obj) {
        $(obj).keyup(function(){
            $(this).val($(this).val().replace(/[^0-9]/g,""));
        });
        $(obj).focusout(function(){
            $(this).val($(this).val().replace(/[^0-9]/g,""));
        });
    }

</script>
</head>

<body class="bgw">
<!--title //-->
<div class="contents_title clear">
    <h2 class="fl">프로그램 정보 상세</h2>
</div>
<div id="crumbs">
    <ul>
        <li><a href="#1" class="on">1. 기본정보</a></li>
        <li><a href="#2">2.날짜/세션정보</a></li>
        <li><a href="#3">3.예약조건</a></li>
    </ul>
</div>
<!--search table // -->
<div class="tbl_write" style="line-height: 10px;">
        <form:form id="listForm" name="listForm" method="post">
            <input type="hidden" id="expseq" name="expseq" value="${listtype.expseq}"/>
            <input type="hidden" id="type" name="type" value="${listtype.type}"/>
            <input type="hidden" id="category" name="category" value="${check.categorytype1}"/>
            <input type="hidden" id="category2" name="category2" value="${check.categorytype2}"/>
            <input type="hidden" id="category3" name="category3" value="${check.categorytype3}"/>
            <input type="hidden" id="listMode" name="listMode" value="${listtype.listMode}"/>
            <input type="hidden" name="frmId" value="${param.frmId}"/>
            <input type="hidden" name="menuAuth" id="menuAuth" value="${param.menuAuth}"/>
        </form:form>
        <table id="tblcommon" width="100%" border="0" cellspacing="0" cellpadding="0">
            <colgroup>
                <col width="15%" />
                <col width="35%"  />
                <col width="15%" />
                <col width="35%" />
            </colgroup>
            <tbody>
            <tr>
                <th scope="row">프로그램 타입</th>
                <td colspan="3">
                    ${detailpage.categorytype1name} ${detailpage.categorytype2name} ${detailpage.categorytype3name}
                </td>
            </tr>
            <tr>
                <th scope="row">운영기간</th>
                <td>
                    <input type="text" name="startdate" class="AXInput datepDay required" title="운영기간" readonly="readonly" value="${detailpage.startdate}">
                    ~
                    <input type="text" name="enddate" class="AXInput datepDay required" title="운영기간" readonly="readonly" value="${detailpage.enddate}">
                </td>
                <th scope="row">프로그램 명</th>
                <td>
                    <input type="text" class="AXInput required" title="프로그램 명" style="min-width:303px;" maxlength="50" name="productname" value="${detailpage.productname}"/>
                </td>
            </tr>
            <tr>
                <th scope="row">PP</th>
                <td>
                    <select name="ppseq" class="required" title="PP">
                        <option value="">선택</option>
                        <c:forEach var="item" items="${ppCodeList}">
                            <option value="${item.commonCodeSeq}" ${detailpage.ppseq eq item.commonCodeSeq ? "selected=\"selected\"" : "" }>${item.codeName}</option>
                        </c:forEach>
                    </select>
                </td>
                <th scope="row">상태</th>
                <td>
                    <select name="statuscode" class="required" title="상태">
                        <c:forEach var="item" items="${codeCombo}">
                            <option value="${item.commoncodeseq}" ${item.commoncodeseq eq detailpage.statuscode ? "selected=\"selected\"" : ""} >${item.codename}</option>
                        </c:forEach>
                    </select>
                </td>
            </tr>
            <tr class="pcontent">
                <th scope="row">프로그램소개</th>
                <td colspan="3">
                    <textarea style="width:100%;min-width:700px;min-height: 50px;resize: none;" name="content" maxlength="500" class="required" title="프로그램소개">${detailpage.content}</textarea>
                </td>
            </tr>
            </tbody>
        </table>
        <div style="height: 10px;"></div>
        <table id="tblSearch" width="100%" border="0" cellspacing="0" cellpadding="0">
            <colgroup>
                <col width="15%" />
                <col width="35%"  />
                <col width="15%" />
                <col width="35%" />
            </colgroup>
            <tbody>
            <!-- 브랜드체험  -->
            <tr class="brand brandrightexp" style="display: none;">
                <th scope="row" >프로그램개요</th>
                <td colspan="3">
                    <textarea style="width:100%;min-width:700px;min-height: 50px;resize: none;" name="intro" maxlength="500" class="required" title="프로그램개요">${detailpage.intro}</textarea>
                </td>
            </tr>
            <!-- 브랜드셀렉트 -->
            <tr class="brandmix" style="display: none;">
                <th scope="row" >프로그램정보1</th>
                <td colspan="3">
                    <c:if test="${empty otherfile}">
                        <li>
                            <form id="fileForm6" method="POST" enctype="multipart/form-data">
                                <input type="file" name="file6" id="file6" style="width:30%;" title="파일첨부" onChange="javascript:html.othersize(this,6);" />
                                <input type="hidden" name="filekey" id="filekey6" title="파일번호" />
                                <input type="hidden" name="oldfilekey" id="oldfilekey6" title="파일번호" />
                            </form>
                        </li>
                    </c:if>
                    <c:if test="${!empty otherfile}">
                        <c:forEach var="items" items="${otherfile }" varStatus="status" begin="0" end="0">
                            <li>
                                <form id="fileForm6" method="POST" enctype="multipart/form-data">
                                    <input type="file" name="file6" id="file${status.index }" style="width:30%;" title="파일첨부" value="${items.realfilename }" onChange="javascript:html.filesize(this,${status.index });"/>
                                    <input type="hidden" name="filekey" id="filekey${status.index }" title="파일번호" value="${items.filekey }" />
                                    <input type="hidden" name="oldfilekey" id="oldfilekey${status.index }" title="파일번호" value="${items.filekey }" />
                                    <input type="text" name="altText" value="${items.altdesc }" />
                                    <div style="border-top:1px dotted #D5D5D5;width:98%;">등록 파일 : <a href="/manager/common/trfeefile/trfeeFileDownload.do?fileKey=${items.filekey }&uploadSeq=${items.uploadseq }&work=${items.work }" >${items.realfilename }</a></div>
                                </form>
                            </li>
                        </c:forEach>
                    </c:if>
                    시간 <input type="text" name="time1" title="프로그램정보1" class="AXInput" style="min-width:303px;" value="${detailpage.time1}"/>
                         <textarea style="width:100%;min-width:700px;min-height: 50px;resize: none;" name="note1" maxlength="500" title="프로그램정보1">${detailpage.note1}</textarea>
                </td>
            </tr>
            <tr class="brandmix" style="display: none;">
                <th scope="row" >프로그램정보2</th>
                <td colspan="3">
                    <c:if test="${empty otherfile}">
                        <li>
                            <form id="fileForm7" method="POST" enctype="multipart/form-data">
                                <input type="file" name="file6" id="file7" style="width:30%;" title="파일첨부" onChange="javascript:html.othersize(this,6);" />
                                <input type="hidden" name="filekey" id="filekey7" title="파일번호" />
                                <input type="hidden" name="oldfilekey" id="oldfilekey7" title="파일번호" />
                            </form>
                        </li>
                    </c:if>
                    <c:if test="${!empty otherfile}">
                        <c:forEach var="items" items="${otherfile }" varStatus="status" begin="1" end="1">
                            <li>
                                <form id="fileForm7" method="POST" enctype="multipart/form-data">
                                    <input type="file" name="file6" id="file${status.index }" style="width:30%;" title="파일첨부" value="${items.realfilename }" onChange="javascript:html.filesize(this,${status.index });"/>
                                    <input type="hidden" name="filekey" id="filekey${status.index }" title="파일번호" value="${items.filekey }" />
                                    <input type="hidden" name="oldfilekey" id="oldfilekey${status.index }" title="파일번호" value="${items.filekey }" />
                                    <input type="text" name="altText" value="${items.altdesc }" />
                                    <div style="border-top:1px dotted #D5D5D5;width:98%;">등록 파일 : <a href="/manager/common/trfeefile/trfeeFileDownload.do?fileKey=${items.filekey }&uploadSeq=${items.uploadseq }&work=${items.work }" >${items.realfilename }</a></div>
                                </form>
                            </li>
                        </c:forEach>
                    </c:if>
                    시간 <input type="text" class="AXInput" name="time2" title="프로그램정보2" style="min-width:303px;" value="${detailpage.time2}"/>
                         <textarea style="width:100%;min-width:700px;min-height: 50px;resize: none;" name="note2" maxlength="500" title="프로그램정보2">${detailpage.note2}</textarea>
                </td>
            </tr>
            <tr class="brandmix" style="display: none;">
                <th scope="row" >프로그램정보3</th>
                <td colspan="3">
                    <c:if test="${empty otherfile}">
                        <li>
                            <form id="fileForm8" method="POST" enctype="multipart/form-data">
                                <input type="file" name="file6" id="file8" style="width:30%;" title="파일첨부" onChange="javascript:html.othersize(this,6);" />
                                <input type="hidden" name="filekey" id="filekey8" title="파일번호" />
                                <input type="hidden" name="oldfilekey" id="oldfilekey8" title="파일번호" />
                            </form>
                        </li>
                    </c:if>
                    <c:if test="${!empty otherfile}">
                        <c:forEach var="items" items="${otherfile }" varStatus="status" begin="2" end="2">
                            <li>
                                <form id="fileForm8" method="POST" enctype="multipart/form-data">
                                    <input type="file" name="file${status.index }" id="file${status.index }" style="width:30%;" title="파일첨부" value="${items.realfilename }" onChange="javascript:html.filesize(this,${status.index });"/>
                                    <input type="hidden" name="filekey" id="filekey${status.index }" title="파일번호" value="${items.filekey }" />
                                    <input type="hidden" name="oldfilekey" id="oldfilekey${status.index }" title="파일번호" value="${items.filekey }" />
                                    <input type="text" name="altText" value="${items.altdesc }" />
                                    <div style="border-top:1px dotted #D5D5D5;width:98%;">등록 파일 : <a href="/manager/common/trfeefile/trfeeFileDownload.do?fileKey=${items.filekey }&uploadSeq=${items.uploadseq }&work=${items.work }" >${items.realfilename }</a></div>
                                </form>
                            </li>
                        </c:forEach>
                    </c:if>
                     시간 <input type="text" class="AXInput" name="time3" title="프로그램정보3" style="min-width:303px;" value="${detailpage.time3}"/>
                         <textarea style="width:100%;min-width:700px;min-height: 50px;resize: none;" name="note3"  maxlength="500"title="프로그램정보3">${detailpage.note3}</textarea>
                </td>
            </tr>
            <!-- 문화체험 -->
            <tr class="culture themaname" style="display: none;">
                <th scope="row" >테마명</th>
                <td colspan="3">
                    <input type="text" class="AXInput required" style="min-width:303px;" name="themename" maxlength="25" title="테마명" value="${detailpage.themename}"/>
                </td>
            </tr>
            <tr class="culture brand brandmix brandrightexp check" style="display: none;">
                <th scope="row" >정원</th>
                <td colspan="3">
                    <input type="hidden" class="required">
                    <span id="personhide">개인 <input type="text" id="nump" class="AXInput required check" title="정원(개인)" style="min-width:100px;" name="seatcount1" maxlength="100" oninput="maxLengthCheck(this)" value="${detailpage.seatcount1}"/></span>
                    <span id="seatcounthide"> 그룹<input type="text" id="numg" class="AXInput required" title="정원(그룹)" style="min-width:100px;" name="seatcount2" maxlength="100" oninput="maxLengthCheck(this)" value="${detailpage.seatcount2}"/></span>
                    <span id="seatInt"> 정원인원 <input type="text" id="numInt" class="AXInput required" title="정원(인원)" style="min-width:100px;" name="seatcount" maxlength="100" oninput="maxLengthCheck(this)" value="${detailpage.seatcount}" onkeydown="onlyNumber(this)"/></span>
                </td>
            </tr>
            <tr class="culture brand brandmix brandrightexp check" style="display: none;">
                <th scope="row" >체험시간</th>
                <td>
                    <input type="text" class="AXInput required" maxlength="50" title="체험시간" style="min-width:100px;" maxlength="25" name="usetime" value="${detailpage.usetime}"/>
                </td>
                <th scope="row" class="pusetimenote">체험시간 부가설명</th>
                <td class="pusetimenote">
                    <input type="text" class="AXInput" title="체험시간 부가설명" maxlength="100" style="width:95%;min-width:100px;" maxlength="500" name="usetimenote" value="${detailpage.usetimenote}"/>
                </td>
            </tr>
            <tr class="culture brand brandmix brandrightexp check" style="display: none;">
                <th >예약자격</th>
                <td>
                    <input type="text" class="AXInput required" title="예약자격" style="width:95%;min-width:303px;" maxlength="60" name="role" value="${detailpage.role}"/>
                </td>
                <th >예약자격 부가설명</th>
                <td>
                    <input type="text" class="AXInput" title="예약자격 부가설명" style="width:95%;min-width:303px;" maxlength="500" name="rolenote" value="${detailpage.rolenote}"/>
                </td>
            </tr>
            <tr class="culture brand brandmix brandrightexp check" style="display: none;">
                <th >준비물</th>
                <td colspan="3">
                    <input type="text" class="AXInput required" title="준비물" style="width:95%;min-width:303px;" maxlength="50" name="preparation" value="${detailpage.preparation}"/>
                </td>
            </tr>
            <!-- 브랜드 체험 -->
            <tr class="brand sumcheck" style="display: none;">
                <th scope="row" >섬네일</th>
                <td colspan="3">
                    <div class="fileWrap">
                        <ul>
                            <input type="button" value="파일초기화" id="reset" style="height: 28px;">
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
                                            <input type="text" name="altText${status.index}" id="altText${status.index}" value="${items.altdesc }" />
                                            <input type="file" name="file${status.index }" id="file${status.index }" style="width:30%;" title="파일첨부" value="${items.realfilename }" onChange="javascript:html.filesize(this,${status.index });"/>
                                            <input type="hidden" name="filekey" id="filekey${status.index }" title="파일번호" value="${items.filekey }" />
                                            <input type="hidden" name="oldfilekey" id="oldfilekey${status.index }" title="파일번호" value="${items.filekey }" />
                                            <c:if test="${status.index == 0}">
                                                <a href="#none" class="btn_green fileAdd">추가</a>
                                            </c:if>
                                            <c:if test="${status.index > 0}">
                                                <a href="javascript:;" class="btn_gray btnFileDelete">삭제</a>
                                            </c:if>
                                            <div style="border-top:1px dotted #D5D5D5;width:98%;">등록 파일 : <a href="/manager/common/trfeefile/trfeeFileDownload.do?fileKey=${items.filekey }&uploadSeq=${items.uploadseq }&work=${items.work }" >${items.realfilename }</a></div>
                                        </form>
                                    </li>
                                </c:forEach>
                            </c:if>
                        </ul>
                        <br>
                        <span>※이미지 설명은 이미지 등록시에만 적용 됩니다.</span>
                    </div>
                </td>
            </tr>
            <tr class="culture brand brandmix check brandrightexp" style="display: none;">
                <th scope="row" >키워드</th>
                <td colspan="3">
                    <input type="text" name="keyword" class="AXInput" maxlength="50" style="min-width:600px;" value="${detailpage.keyword}"/>
                </td>
            </tr>
            </tbody>
        </table>
        <div class="contents_title clear" style="padding-top: 15px;height: 15px;">
            <div class="fr">
                <a href="javascript:btnEvent.btnSave();" id="btnSave" class="btn_green" >수정</a>
            </div>
            <div align="center">
                <a href="javascript:;" id="btnReturn" class="btn_gray">목록</a>
                <a href="javascript:;" id="btnNext" class="btn_gray">다음 단계로</a>
            </div>
        </div>
</div>
<!-- Board List -->
</body>