<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/manager/frame/include/top.jsp" %>

<!-- js/이미지/공통  include -->
<%@ include file="/WEB-INF/jsp/manager/frame/include/include.jsp" %>

<script type="text/javascript">
    //Grid Init , 날짜/세션정보
    var dateGrid = new AXGrid(); // instance 상단그리드

    //Grid Default Param
    var dateParam = {
        sortColKey: "Rsv.programInfo.dateList"
        , sortIndex: 1
        , sortOrder:"DESC"
    };

    //Grid Init , 우선운영요일
    var firstGrid = new AXGrid(); // instance 상단그리드

    //Grid Default Param
    var firstParam = {
        sortColKey: "Rsv.programInfo.detailtwolist"
        , sortIndex: 1
        , sortOrder:"DESC"
    };

    //Grid Init , 예약자격/기간
    var termGrid = new AXGrid(); // instance 상단그리드
    //Grid Default Param
    var termParam = {
        sortColKey: "Rsv.programInfo.detailThreeExpTerm"
    };

    //Grid Init , 누적예약제한
    var disGrid = new AXGrid(); // instance 상단그리드
    //Grid Default Param
    var disParam = {
        sortColKey: "Rsv.programInfo.detailThreeExpDis"
    };

    //Grid Init , 취소패널티
    var cancelGrid = new AXGrid(); // instance 상단그리드
    //Grid Default Param
    var cancelParam = {
        sortColKey: "Rsv.facilityInfo.detailThreeCancel"
    };

    $(document).ready(function(){
        param={frmId:"${param.frmId}",menuAuth:"${param.menuAuth}"};

        dateList.init(); // 날짜/세션정보
        firstList.init(); //우선운영요일/휴무지정

        dateList.doSearch(); // 날짜/세션정보
        firstList.doSearch(); //우선운영요일/휴무지정

        /*리스트셋팅*/
        termList.init();//예약자격/기간 리스트
        disList.init(); //누적예약제한
        cancelList.init();//취소/패널티

        /*리스트 시작*/
        termList.doSearch();//예약자격/기간 리스트
        disList.doSearch(); //누적예약제한
        cancelList.doSearch();//취소/패널티

        //목록이동
        $("#btnReturn").on("click", function(){
            var f = document.listForm;
            f.action = "/manager/reservation/programInfo/programInfoList.do";
            f.submit();
        });

        //타입에따라 화면 분류 - E01(체성분측정),E02(피부측정),E03(브랜드체험),E04(문화체험) / 히든값
        var typecheck = $("#category").val(); // 1depth
        var type2depth = $("#category2").val(); //2depth
        var type3depth = $("#category3").val(); //3depth

        //카테고리
        var category2dep = $("#2depth");
        var category3dep  = $("#3depth");


        if(typecheck=="체성분측정" || typecheck == "피부측정"){
            $("#check").show();
        }else if(typecheck == "브랜드체험"){
            if(type2depth == "브랜드셀렉트"){
                $("#brand").show();
                category2dep.show();
                category3dep.show();

            }else if(type2depth == "브랜드믹스" || type2depth == "브랜드투어"){
                $("#mix").show();
                category2dep.show();

            }else if(type2depth == "맞춤식체험"){
                $("#rightexp").show();
                category2dep.show();
            }
        }else if(typecheck == "문화체험"){
             $("#culture").show();
        };
    });

    // 날짜/세션정보
    var dateList = {
        /** init : 초기 화면 구성 (Grid)
         */
        init : function() {
            var idx = 0; // 정렬 Index
            var _colGroup = [
                {key:"weekdate", label:"요일", width:"50", align:"center", sort:false}
                , {key:"sessionname", label:"세션", width:"80", align:"center", sort:false}
                , {key:"weektime", label:"시간", width:"80", align:"center", sort:false}
            ]

            var gridParam = {
                colGroup : _colGroup
                , fitToWidth: true
                , targetID : "AXGridDate_${param.frmId}"
                , height : "300px"
            }
            fnGrid.nonPageGrid(dateGrid, gridParam);
        }, doSearch : function(param) {
            // Param 셋팅(검색조건)
            var initParam = {
                expseq : $("#expseq").val()
            };
            $.extend(dateParam, param);
            $.extend(dateParam, initParam);

            $.ajaxCall({
                url: "<c:url value="/manager/reservation/programInfo/programInfoDetailDateAjax.do"/>"
                , data: dateParam
                , success: function( data, textStatus, jqXHR){
                    if(data.result < 1){
        				var mag = '<spring:message code="errors.load"/>';
        				alert(mag);
                        return;
                    } else {
                        callbackList(data);
                    }
                },
                error: function( jqXHR, textStatus, errorThrown) {
    				var mag = '<spring:message code="errors.load"/>';
    				alert(mag);
                }
            });

            function callbackList(data) {
                var obj = data; //JSON.parse(data);
                // Grid Bind
                var gridData = {
                    list: obj.dataList
                };
                // Grid Bind Real
                dateGrid.setData(gridData);
            }
        }
    }

    //운영일 휴무일 지정
    var firstList = {
        /** init : 초기 화면 구성 (Grid)
         */
        init : function() {
            var idx = 0; // 정렬 Index
            var _colGroup = [
                {key:"row_num", label:"No.", width:"40", align:"center", formatter:"money", sort:false}
                , {key:"worktypecode", label:"구분", width:"50", align:"center", sort:false, formatter: function(){
                    if(this.item.worktypecode=="S01"){
                        return "<span>운영<span>";
                    }else if(this.item.worktypecode=="S02"){
                        return "<span>휴무<span>";
                    }
                }}
                , {key:"setdate", label:"일자", width:"80", align:"center", sort:false}
                , {key: "sessioncount", label : "세션수", width: "360", align: "center", sort:false , formatter: function(){
                    if(this.item.worktypecode=="S01"){
                        return this.item.sessioncount;
                    }else if(this.item.worktypecode=="S02"){
                        return "-";
                    }
                }}
                , {key:"ki", addclass:idx++, label:"상세보기", width:"60", align:"center", sort:false, formatter: function(){
                    if(this.item.worktypecode=="S01"){
                        return "<a href=\"javascript:;\" class='btn_green' onclick=\"gridEvent.nameClick('" + this.item.setdate + "')\">보기</a>";
                    }else if(this.item.worktypecode=="S02"){
                        return "-";
                    }
                }}
            ]

            var gridParam = {
                colGroup : _colGroup
                , fitToWidth: true
                , targetID : "AXGridFirst_${param.frmId}"
                , height : "300px"
            }
            fnGrid.nonPageGrid(firstGrid, gridParam);
        }, doSearch : function(param) {
            // Param 셋팅(검색조건)
            var initParam = {
                expseq : $("#expseq").val()
            };
            $.extend(firstParam, param);
            $.extend(firstParam, initParam);

            $.ajaxCall({
                url: "<c:url value="/manager/reservation/programInfo/programInfoDetailTwoListAjax.do"/>"
                , data: firstParam
                , success: function( data, textStatus, jqXHR){
                    if(data.result < 1){
        				var mag = '<spring:message code="errors.load"/>';
        				alert(mag);
                        return;
                    } else {
                        callbackList(data);
                    }
                },
                error: function( jqXHR, textStatus, errorThrown) {
    				var mag = '<spring:message code="errors.load"/>';
    				alert(mag);
                }
            });

            function callbackList(data) {
                var obj = data; //JSON.parse(data);
                // Grid Bind
                var gridData = {
                    list: obj.dataList
                };
                // Grid Bind Real
                firstGrid.setData(gridData);
            }
        }
    }

    //미리보기
    var gridEvent = {
        nameClick: function (setdate) {

            var param = {
                setdate : setdate,
                expseq : $("#expseq").val()
            };

            var popParam = {
                url: "<c:url value="/manager/reservation/programInfo/programInfoDetailSessionPop.do" />"
                , width: "612"
                , height: "400"
                , params: param
                , targetId: "searchPopup"
            }

            window.parent.openManageLayerPopup(popParam);

        }
    }

    //예약자격 리스트
    var termList = {
        /** init : 초기 화면 구성 (Grid)
         */
        init : function() {
            var idx = 0; // 정렬 Index
            var _colGroup = [
                  {key:"exprole", label:"예약자격", width:"100", align:"center", sort:false}
                , {key:"startdate", label:"시작일", width:"100", align:"center", sort:false}
                , {key:"enddate", label:"종료일", width:"100", align:"center", sort:false}
                , {key:"setweek", label : "적용세션유형", width: "150", align: "center"}
            ]
            var gridParam = {
                colGroup : _colGroup
                , fitToWidth: true
                , colHead : {
                    heights : [ 20, 20 ],rows :
                            [
                                [
                                    {colSeq : 0, rowspan : 2, valign : "middle"},
                                    {colSeq : null, colspan : 2, valign : "middle", label : "예약가능시간", align : "center"},
                                    {colSeq : 3, rowspan : 2, valign : "middle"},
                                    {colSeq : 4, rowspan : 2, valign : "middle"}
                                ],[
                                {colSeq : 1},
                                {colSeq : 2}
                            ]
                            ]
                }
                , targetID : "AXGridTerm_${param.frmId}"
                , height : "300px"
            }
            fnGrid.nonPageGrid(termGrid, gridParam);
        }, doSearch : function(param) {
            // Param 셋팅(검색조건)
            var initParam = {
                expseq : $("#expseq").val()
            };
            $.extend(termParam, param);
            $.extend(termParam, initParam);

            $.ajaxCall({
                url: "<c:url value="/manager/reservation/programInfo/programInfoDetailTermListAjax.do"/>"
                , data: termParam
                , success: function( data, textStatus, jqXHR){
                    if(data.result < 1){
        				var mag = '<spring:message code="errors.load"/>';
        				alert(mag);
                        return;
                    } else {
                        callbackList(data);
                    }
                },
                error: function( jqXHR, textStatus, errorThrown) {
    				var mag = '<spring:message code="errors.load"/>';
    				alert(mag);
                }
            });

            function callbackList(data) {
                var obj = data; //JSON.parse(data);
                // Grid Bind
                var gridData = {
                    list: obj.dataList
                };
                // Grid Bind Real
                termGrid.setData(gridData);
            }
        }
    }

    //누적예약제한 리스트
    var disList = {
        /** init : 초기 화면 구성 (Grid)
         */
        init : function() {
            var idx = 0; // 정렬 Index
            var _colGroup = [
                {key:"role", label:"자격", width:"150", align:"center", sort:false}
                , {key:"globaldailycount", addClass:idx++, label:"일", width:"100", align:"center"}
                , {key:"globalweeklycount", addClass:idx++, label:"주", width:"100", align:"center"}
                , {key:"globalmonthlycount", addClass:idx++, label:"월", width:"100", align:"center"}
                , {key:"ppdailycount", addClass:idx++, label:"일", width:"100", align:"center"}
                , {key:"ppweeklycount", addClass:idx++, label:"주", width:"100", align:"center"}
                , {key:"ppmonthlycount", addClass:idx++, label:"월", width:"100", align:"center"}
            ]

            var gridParam = {
                colGroup : _colGroup
                , fitToWidth: true
                , colHead : {
                    heights : [ 20, 20 ],rows :
                            [
                                [
                                    {colSeq : 0, rowspan : 2, valign : "middle"},
                                    {colSeq : null, colspan : 3, valign :"middle", label:"전국PP예약제한횟수"},
                                    {colSeq : null, colspan : 3, valign :"middle", label:"PP별예약제한횟수"},
                                    {colSeq : 7, rowspan : 2, valign : "middle"}
                                ],[
                                {colSeq : 1},
                                {colSeq : 2},
                                {colSeq : 3},
                                {colSeq : 4},
                                {colSeq : 5},
                                {colSeq : 6}
                            ]
                            ]
                }
                , targetID : "AXGridDis_${param.frmId}"
                , height : "300px"
            }
            fnGrid.nonPageGrid(disGrid, gridParam);
        }, doSearch : function(param) {
            // Param 셋팅(검색조건)
            var initParam = {
                expseq : $("#expseq").val()
            };
            $.extend(disParam, param);
            $.extend(disParam, initParam);

            $.ajaxCall({
                url: "<c:url value="/manager/reservation/programInfo/programInfoDetailDisListAjax.do"/>"
                , data: disParam
                , success: function( data, textStatus, jqXHR){
                    if(data.result < 1){
        				var mag = '<spring:message code="errors.load"/>';
        				alert(mag);
                        return;
                    } else {
                        callbackList(data);
                    }
                },
                error: function( jqXHR, textStatus, errorThrown) {
    				var mag = '<spring:message code="errors.load"/>';
    				alert(mag);
                }
            });

            function callbackList(data) {
                var obj = data; //JSON.parse(data);
                // Grid Bind
                var gridData = {
                    list: obj.dataList
                };
                // Grid Bind Real
                disGrid.setData(gridData);
            }
        }
    }

    //취소/패널티 리스트
    var cancelList = {
        /** init : 초기 화면 구성 (Grid)
         */
        init : function() {
            var idx = 0; // 정렬 Index
            var _colGroup = [
                {key:"typecode", label:"구분", width:"150", align:"center", sort:false}
                , {key:"typedetailcode", label:"취소 기준", width:"150", align:"center", sort:false}
                , {key:"applytypecode", label:"패널티", width:"200", align:"center"}
            ]

            var gridParam = {
                colGroup : _colGroup
                , fitToWidth: true
                , targetID : "AXGridCancel_${param.frmId}"
                , height : "300px"
            }
            fnGrid.nonPageGrid(cancelGrid, gridParam);
        }, doSearch : function(param) {
            // Param 셋팅(검색조건)
            var initParam = {
                expseq : $("#expseq").val()
            };
            $.extend(cancelParam, param);
            $.extend(cancelParam, initParam);

            $.ajaxCall({
                url: "<c:url value="/manager/reservation/programInfo/programInfoDetailCancelListAjax.do"/>"
                , data: cancelParam
                , success: function( data, textStatus, jqXHR){
                    if(data.result < 1){
        				var mag = '<spring:message code="errors.load"/>';
        				alert(mag);
                        return;
                    } else {
                        callbackList(data);
                    }
                },
                error: function( jqXHR, textStatus, errorThrown) {
    				var mag = '<spring:message code="errors.load"/>';
    				alert(mag);
                }
            });

            function callbackList(data) {
                var obj = data; //JSON.parse(data);
                // Grid Bind
                var gridData = {
                    list: obj.dataList
                };
                // Grid Bind Real
                cancelGrid.setData(gridData);
            }
        }
    }

</script>
</head>

<body class="bgw">
<!--title //-->
<div class="contents_title clear">
    <h2 class="fl">프로그램 정보 상세</h2>
</div>
<form:form id="listForm" name="listForm" method="post">
    <input type="hidden" id="expseq" name="expseq" value="${listtype.expseq}"/>
    <input type="hidden" id="type" name="type" value="${listtype.type}"/>
    <input type="hidden" id="category" name="category" value="${check.categorytype1name}"/>
    <input type="hidden" id="category2" name="category2" value="${check.categorytype2name}"/>
    <input type="hidden" id="category3" name="category3" value="${check.categorytype3name}"/>
    <input type="hidden" name="frmId" value="${param.frmId}"/>
    <input type="hidden" name="menuAuth" id="menuAuth" value="${param.menuAuth}"/>
</form:form>
<!--search table // -->
<div class="tbl_write" style="height: 800px;overflow-y:scroll;">
    <form id="frmFile" name="fileform" method="post" enctype="multipart/form-data">
        <table id="tblSearch" width="100%" border="0" cellspacing="0" cellpadding="0" style="line-height: 1;">
            <tr>
                <th scope="row" style="text-align: center;height:30px;width: 150px;">프로그램 코드</th>
                <td>${detailpage.expseq}</td>
            </tr>
            <tr>
                <th scope="row" style="text-align: center;">프로그램 타입</th>
                <td>
                    ${detailpage.categorytype1name} &nbsp;
                    <span id="2depth" style="display: none;">${detailpage.categorytype2name}</span>&nbsp;
                    <span id="3depth" style="display: none;">${detailpage.categorytype3name}</span>
                </td>
            </tr>
        <%--측정인 경우--%>
        <tbody id="check" style="display:none;">
            <tr>
                <th scope="row" style="text-align: center;">프로그램 명</th>
                <td>
                    ${detailpage.productname}
                </td>
            </tr>
            <tr>
                <th scope="row" style="text-align: center;">PP</th>
                <td>${detailpage.ppname}</td>
            </tr>
            <tr>
                <th scope="row" style="text-align: center;">운영기간</th>
                <td>${detailpage.startdate}~${detailpage.enddate}</td>
            </tr>
            <tr>
                <th scope="row" style="text-align: center;">상태</th>
                <td>${detailpage.statuscode}</td>
            </tr>
            <tr>
                <th scope="row" style="text-align: center;">프로그램소개</th>
                <td>${detailpage.content}</td>
            </tr>
            <tr>
                <th scope="row" style="text-align: center;">정원</th>
                <td>개인 ${detailpage.seatcount1}</td>
            </tr>
            <tr>
                <th scope="row" style="text-align: center;">체험시간</th>
                <td>${detailpage.usetime}</td>
            </tr>
            <tr>
                <th scope="row" style="text-align: center;">체험시간 부가설명</th>
                <td>${detailpage.usetimenote}</td>
            </tr>
            <tr>
                <th style="text-align: center;">예약자격</th>
                <td>${detailpage.role}</td>
            </tr>
            <tr>
                <th style="text-align: center;">예약자격 부가설명</th>
                <td>${detailpage.rolenote}</td>
            </tr>
            <tr>
                <th style="text-align: center;">준비물</th>
                <td>${detailpage.preparation}</td>
            </tr>
            <tr>
                <th scope="row" style="text-align: center;">섬네일</th>
                <td>
                    <c:forEach var="item" items="${detailfile}" varStatus="status">
                        <div>
                            <img src="/manager/trainingFee/proof/imageView.do?filefullurl=${item.filefullurl }&storefilename=${item.storefilename }" width="400px;" style="max-height:148px;max-width: 228px;">
                        </div>
                        <div>
                            ${item.realfilename }
                            <br>
                            ${item.altdesc }
                        </div>
                    </c:forEach>
                </td>
            </tr>
        </tbody>

        <%--문화체험인 경우--%>
        <tbody id="culture" style="display: none;">
            <tr>
                <th scope="row" style="text-align: center;">테마명</th>
                <td>${detailpage.themename}</td>
            </tr>
            <tr>
                <th scope="row" style="text-align: center;">프로그램 명</th>
                <td>${detailpage.productname}</td>
            </tr>
            <tr>
                <th scope="row" style="text-align: center;">PP</th>
                <td>${detailpage.ppname}</td>
            </tr>
            <tr>
                <th scope="row" style="text-align: center;">운영기간</th>
                <td>${detailpage.startdate}~${detailpage.enddate}</td>
            </tr>
            <tr>
                <th scope="row" style="text-align: center;" class="required">상태</th>
                <td>${detailpage.statuscode}</td>
            </tr>
            <tr>
                <th scope="row" style="text-align: center;">프로그램소개</th>
                <td>${detailpage.content}</td>
            </tr>
            <tr>
                <th scope="row" style="text-align: center;">정원</th>
                <td>
                    <span>개인 ${detailpage.seatcount1} </span>
                    <span>개인정원인원 ${detailpage.seatcount} </span>
                </td>
            </tr>
            <tr >
                <th scope="row" style="text-align: center;">체험시간</th>
                <td>${detailpage.usetime}</td>
            </tr>
            <tr>
                <th scope="row" style="text-align: center;">체험시간 부가설명</th>
                <td>${detailpage.usetimenote}</td>
            </tr>
            <tr>
                <th style="text-align: center;">예약자격</th>
                <td>${detailpage.role}</td>
            </tr>
            <tr>
                <th style="text-align: center;">예약자격 부가설명</th>
                <td>${detailpage.rolenote}</td>
            </tr>
            <tr>
                <th style="text-align: center;">준비물</th>
                <td>${detailpage.preparation}</td>
            </tr>
        </tbody>

        <%--브랜드체험 브랜드 셀렉트--%>
        <tbody id="brand" style="display: none;">
            <tr>
                <th scope="row" style="text-align: center;">프로그램 명</th>
                <td>${detailpage.productname}</td>
            </tr>
            <tr>
                <th scope="row" style="text-align: center;">PP</th>
                <td>${detailpage.ppname}</td>
            </tr>
            <tr>
                <th scope="row" style="text-align: center;">운영기간</th>
                <td>${detailpage.startdate}~${detailpage.enddate}</td>
            </tr>
            <tr>
                <th scope="row" style="text-align: center;">상태</th>
                <td>${detailpage.statuscode}</td>
            </tr>
            <tr>
                <th scope="row" style="text-align: center;">프로그램개요</th>
                <td>${detailpage.intro}</td>
            </tr>
            <tr>
                <th scope="row" style="text-align: center;">프로그램소개</th>
                <td>${detailpage.content}</td>
            </tr>
            <tr>
                <th scope="row" style="text-align: center;">정원</th>
                <td>
                    <c:choose>
                         <c:when test="${!empty detailpage.seatcount1}">
                             <span>개인 ${detailpage.seatcount1} </span>
                             <span>개인정원인원 ${detailpage.seatcount} </span>
                         </c:when>
                        <c:when test="${!empty detailpage.seatcount2}">
                             <span>그룹 ${detailpage.seatcount2} </span>
                        </c:when>
                    </c:choose>
                </td>
            </tr>
            <tr >
                <th scope="row" style="text-align: center;">체험시간</th>
                <td>${detailpage.usetime}</td>
            </tr>
            <tr>
                <th scope="row" style="text-align: center;">체험시간 부가설명</th>
                <td>${detailpage.usetimenote}</td>
            </tr>
            <tr>
                <th style="text-align: center;">예약자격</th>
                <td>${detailpage.role}</td>
            </tr>
            <tr>
                <th style="text-align: center;">예약자격 부가설명</th>
                <td>${detailpage.rolenote}</td>
            </tr>
            <tr>
                <th style="text-align: center;">준비물</th>
                <td>${detailpage.preparation}</td>
            </tr>
            <tr>
                <th scope="row" style="text-align: center;">섬네일</th>
                <td>
                    <c:forEach var="item" items="${detailfile}" varStatus="status">
                        <div>
                            <img src="/manager/trainingFee/proof/imageView.do?filefullurl=${item.filefullurl }&storefilename=${item.storefilename }" width="400px;" style="max-height:148px;max-width: 228px;">
                        </div>
                        <div>
                            ${item.realfilename }
                            <br>
                            ${item.altdesc }
                        </div>
                    </c:forEach>
                </td>
            </tr>
        </tbody>
        <%--브랜드체험 브랜드 믹스,투어--%>
        <tbody id="mix" style="display: none;">
            <tr>
                <th scope="row" style="text-align: center;">프로그램 명</th>
                <td>${detailpage.productname}</td>
            </tr>
            <tr>
                <th scope="row" style="text-align: center;">PP</th>
                <td>${detailpage.ppname}</td>
            </tr>
            <tr>
                <th scope="row" style="text-align: center;">운영기간</th>
                <td>${detailpage.startdate}~${detailpage.enddate}</td>
            </tr>
            <tr>
                <th scope="row" style="text-align: center;">상태</th>
                <td>${detailpage.statuscode}</td>
            </tr>
            <tr>
                <th scope="row" style="text-align: center;">프로그램소개</th>
                <td>${detailpage.content}</td>
            </tr>
            <tr>
                <th scope="row" style="text-align: center;">프로그램정보</th>
                <td>
                    <c:forEach var="item" items="${detailfile}" varStatus="status">
                        <span>
                            <img src="/manager/trainingFee/proof/imageView.do?filefullurl=${item.filefullurl }&storefilename=${item.storefilename }" width="400px;" style="max-height:148px;max-width: 228px;">
                            <span>${item.realfilename }</span>&nbsp;&nbsp;<span>${item.altdesc }</span>
                        </span>
                    </c:forEach>
                </td>
            </tr>
            <tr>
                <th scope="row" style="text-align: center;">정원</th>
                <td>
                    <c:choose>
                        <c:when test="${!empty detailpage.seatcount1}">
                            <span>개인 ${detailpage.seatcount1} </span>
                            <span>개인정원인원 ${detailpage.seatcount} </span>
                        </c:when>
                        <c:when test="${!empty detailpage.seatcount2}">
                            <span>그룹 ${detailpage.seatcount2} </span>
                        </c:when>
                    </c:choose>
                </td>
            </tr>
            <tr >
                <th scope="row" style="text-align: center;">체험시간</th>
                <td>${detailpage.usetime}</td>
            </tr>
            <tr>
                <th style="text-align: center;">예약자격</th>
                <td>${detailpage.role}</td>
            </tr>
            <tr>
                <th style="text-align: center;">예약자격 부가설명</th>
                <td>${detailpage.rolenote}</td>
            </tr>
            <tr>
                <th style="text-align: center;">준비물</th>
                <td>${detailpage.preparation}</td>
            </tr>
            </tbody>

            <%--브랜드체험 맞춤식체험--%>
            <tbody id="rightexp" style="display: none;">
            <tr>
                <th scope="row" style="text-align: center;">프로그램 명</th>
                <td>${detailpage.productname}</td>
            </tr>
            <tr>
                <th scope="row" style="text-align: center;">PP</th>
                <td>${detailpage.ppname}</td>
            </tr>
            <tr>
                <th scope="row" style="text-align: center;">운영기간</th>
                <td>${detailpage.startdate}~${detailpage.enddate}</td>
            </tr>
            <tr>
                <th scope="row" style="text-align: center;">상태</th>
                <td>${detailpage.statuscode}</td>
            </tr>
            <tr>
                <th scope="row" style="text-align: center;">프로그램개요</th>
                <td>${detailpage.intro}</td>
            </tr>
            <tr>
                <th scope="row" style="text-align: center;">정원</th>
                <td>
                    <c:choose>
                        <c:when test="${!empty detailpage.seatcount1}">
                            <span>개인 ${detailpage.seatcount1} </span>
                            <span>개인정원인원 ${detailpage.seatcount} </span>
                        </c:when>
                        <c:when test="${!empty detailpage.seatcount2}">
                            <span>그룹 ${detailpage.seatcount2} </span>
                        </c:when>
                    </c:choose>
                </td>
            </tr>
            <tr>
                <th scope="row" style="text-align: center;">체험시간</th>
                <td>${detailpage.usetime}</td>
            </tr>
            <tr>
                <th style="text-align: center;">예약자격</th>
                <td>${detailpage.role}</td>
            </tr>
            <tr>
                <th style="text-align: center;">예약자격 부가설명</th>
                <td>${detailpage.rolenote}</td>
            </tr>
            <tr>
                <th style="text-align: center;">준비물</th>
                <td>${detailpage.preparation}</td>
            </tr>
            </tbody>
            <tr>
                <th scope="row" style="text-align: center;">키워드</th>
                <td>${detailpage.keyword}</td>
            </tr>
        </table>
        <br>
        <!-- grid -->
        <div class="contents_title clear">
            <h2 class="fl">．날짜/세션 정보</h2>
        </div>
        <div id="AXGridDate">
            <div id="AXGridDate_${param.frmId}"></div>
        </div>
        <!-- grid -->
        <div class="contents_title clear">
            <h2 class="fl">．우선운영요일/휴무지정</h2>
        </div>
        <div id="AXGridFirst">
            <div id="AXGridFirst_${param.frmId}"></div>
        </div>

        <div class="contents_title clear" style="font-size: 20px;">
            <h2 class="fl"> 예약 조건</h2>
        </div>
        <!-- grid -->
        <div class="contents_title clear">
            <h2 class="fl">．&nbsp;예약 자격/기간</h2>
        </div>
        <div id="AXGridTerm">
            <div id="AXGridTerm_${param.frmId}"></div>
        </div>
        <!-- grid -->
        <div class="contents_title clear">
            <h2 class="fl">．&nbsp;누적 예약 제한</h2>
        </div>
        <div id="AXGridDis">
            <div id="AXGridDis_${param.frmId}"></div>
        </div>
        <!-- grid -->
        <div class="contents_title clear">
            <h2 class="fl">．&nbsp;취소/패널티</h2>
        </div>
        <div id="AXGridCancel">
            <div id="AXGridCancel_${param.frmId}"></div>
        </div>

        <div class="contents_title clear" style="padding-top: 15px;height: 15px;">
            <div style="text-align: center;">
                <a href="javascript:;" id="btnReturn" class="btn_gray">목록</a>
            </div>
        </div>
    </form>
</div>

<!-- Board List -->
</body>