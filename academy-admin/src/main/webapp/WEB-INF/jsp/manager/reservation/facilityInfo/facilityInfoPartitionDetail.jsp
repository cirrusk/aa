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
        param={frmId:"${param.frmId}",menuAuth:"${param.menuAuth}"};
        pop.init();
        $(".fileWrap").fileUpload(); // 파일업로드 셋팅


        //목록이동
        $("#btnReturn").on("click",function(){
            var f = document.listForm;
            f.action = "/manager/reservation/facilityInfo/facilityInfoList.do";
            f.submit();
        });

        //다음으로이동
        $("#btnNext").on("click",function(val){
            $("#sTypeseq").val($("input[name='typeseq']:checked").val());
            pop.goTwoPage();
        });

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

        $(".btnFileDelete").on("click",function(){
            if(!confirm("삭제하시겠습니까?")){
                return;
            }
            $(this).closest("li").remove();
            return false;
        });
        myIframeResizeHeight("${listseq.frmId}");
    });

    var html = {
        filesize : function(file, num){
            if( isNull(file.files[0]) ) {
                if( isNull($("#oldfilekey"+num).val()) ) {
                    $("#filekey"+num).val("");
                } else {
                    $("#filekey"+num).val($("#oldfilekey"+num).val());
                }
                return;
            }

            var fSize = file.files[0].size;
            var maxSize = 1024*10240;
            if(fSize>maxSize) {
                alert("용량제한 10MB를 초과 하였습니다.");
                file.value="";
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
                if(!chkValidation({chkId:"#tblSearch", chkObj:"hidden|input|select"}) ){
                    return;
                }

                var startday = $("#startdate").val().replace("-","").replace("-","");
                var endday = $("#enddate").val().replace("-","").replace("-","");

                if(startday>endday || startday==endday){
                    alert("시작일과 종료일이 같을수없습니다.\n또는 시작일은 종료일을 넘길수 없습니다.");
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

                showLoading();

                selectMode.mode = "I";
                pop.doSave(selectMode.mode);

            });
        } // end Init
        , doSave : function(mode, fileKey,item, idx){
            if(mode == "I") {
                var sUrl = "<c:url value="/manager/reservation/facilityInfo/facilityInfoPartitionInsert.do"/>";
                var sMsg = "등록하였습니다.";

                var usekeyword = $("#keyword").val().replace(/^\s+|\s+$/g,"");

                var param = {
                    roomseqa : $("#roomseqa").val(),
                    roomseqb : $("#roomseqb").val(),
                    ppseq : $("#ppseq").val(),
                    typeseq : $("#typeseq").val(),
                    roomname : $("#roomname").val(),
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
        					var mag = '<spring:message code="errors.load"/>';
        					alert(mag);
                        } else {
                            $("#roomseq").val(data.listseq);
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
        }, goTwoPage : function(){
            var f = document.listForm;
            f.action = "/manager/reservation/facilityInfo/facilityInfoPartitionDetailTwo.do";
            f.submit();
        }
    }

</script>
</head>

<body class="bgw">
<form:form id="listForm" name="listForm" method="post">
    <input type="hidden" id="roomseqo" name="roomseq0"/>
    <input type="hidden" id="roomseq" name="roomseq" value="${listseq.roomseq}"/>
    <input type="hidden" id="roomseqa" name="roomseqa" value="${listseq.roomseq1}"/>
    <input type="hidden" id="roomseqb" name="roomseqb" value="${listseq.roomseq2}"/>
    <input type="hidden" name="menuAuth" id="menuAuth" value="${param.menuAuth}"/>
    <input type="hidden" name="frmId" value="${listseq.frmId}"/>
</form:form>
<!--title //-->
<div class="contents_title clear">
    <h2 class="fl">파티션룸 설정</h2>
</div>

<!--search table // -->
<div class="tbl_write">
        <table id="tblSearch" width="100%" border="0" cellspacing="0" cellpadding="0">
            <colgroup>
                <col width="12%" />
                <col width="38%" />
                <col width="12%" />
                <col width="38%" />
            </colgroup>
            <tr>
                <th scope="row" >PP</th>
                <td>
                    ${detailpage.ppname}
                    <input type="hidden" id="ppseq" value="${detailpage.ppseq}"/>
                </td>
                <th scope="row" >시설명</th>
                <td>
                    <input type="text" class="AXInput required" maxlength="10" style="min-width:303px;" id="roomname" title="시설명"/>
                    <br>(실제 시설명을 등록합니다. 예:101호 등)
                </td>
            </tr>
            <tr>
                <th scope="row" >시설 타입</th>
                <td id="facilitystatuscode">&nbsp;
                    <label class="required" title="시설 타입">
                    교육장
                    </label>
                    <input type="hidden" id="typeseq" name="typeseq" value="${detailpage.typeseq}"/>
                </td>
                <th scope="row" >운영기간</th>
                <td>
                    <input type="text" id="startdate" class="AXInput datepDay required" title="운영기간(시작)" readonly="readonly">
                    ~
                    <input type="text" id="enddate" class="AXInput datepDay required" title="운영기간(종료)" readonly="readonly">
                </td>
            </tr>
            <tr>
                <th scope="row" >상태</th>
                <td colspan="3">
                    <select id="statuscode" class="required" title="상태">
                        <option value="">선택</option>
                        <option value="B01">사용</option>
                        <option value="B02">미사용</option>
                    </select>
                </td>
            </tr>
            <tr>
                <th scope="row" >시설소개</th>
                <td colspan="3">
                    <textarea style="width:100%;min-width:700px;min-height: 80px;resize: none;" maxlength="100" id="intro" name="intro" class="required" title="시설소개"></textarea>
                </td>
            </tr>
            <tr>
                <th scope="row" >정원</th>
                <td>
                    <input type="text" class="AXInput required" title="정원" style="min-width:100px;" id="seatcount" maxlength="100" oninput="maxLengthCheck(this)"/>
                </td>
                <th scope="row" >이용시간</th>
                <td>
                    <input type="text" class="AXInput required" title="이용시간" style="min-width:100px;" id="usetime" maxlength="50" oninput="maxLengthCheck(this)"/>
                </td>
            </tr>
            <tr>
                <th >예약자격</th>
                <td>
                    <input type="text" class="AXInput required" title="예약자격" maxlength="10" style="min-width:303px;" id="role"/>
                </td>
                <th >예약자격 부가설명</th>
                <td>
                    <input type="text" class="AXInput" title="예약자격 부가설명" maxlength="500" style="min-width:303px;" id="rolenote"/>
                </td>
            </tr>
            <tr>
                <th scope="row" >부대시설</th>
                <td colspan="3">
                    <textarea style="width:100%;min-width:700px;min-height: 80px;resize: none;" maxlength="500" id="facility" class="required" title="부대시설"></textarea>
                </td>
            </tr>
            <tr>
                <th scope="row" >섬네일</th>
                <td colspan="3">
                    <div class="fileWrap">
                        <ul>
                            <input type="button" value="파일초기화" id="reset" style="height: 28px;">
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
                        </ul>
                        <span>※이미지 설명은 이미지 등록시에만 적용 됩니다.</span>
                    </div>
                </td>
            </tr>
            <tr>
                <th scope="row" >검색용 키워드</th>
                <td colspan="3">
                    <input type="text" class="AXInput" title="키워드" style="width:95%;min-width:600px;" id="keyword" maxlength="50" oninput="maxLengthCheck(this)" />
                    <br>콤마(,) 단위로 넣어 주세요.
                </td>
            </tr>
        </table>
        <div class="contents_title clear" style="padding-top: 15px;height: 15px;">
            <div class="fr">
                <a href="javascript:;" id="btnSave" class="btn_green" style="vertical-align:middle; margin-left:0px;">저장</a>
            </div>
            <div style="text-align: center;">
                <a href="javascript:;" id="btnReturn" class="btn_gray">목록</a>
            </div>
        </div>
</div>

<!-- Board List -->

</body>