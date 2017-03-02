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
            pop.goTwoPage();
        });

        //keyword value 값 제거
        $("[name='keyword']").one("click",function(){
            $("[name='keyword']").val("");
            $.trim($("[name='keyword']").val());
        });

        $("#keyword").one("click",function(){
            $("#keyword").val("");
            $.trim($("#keyword").val());
        });

		//측정인경우
		<c:if test="${layerMode.listMode eq 'CHECK' }">
		$("#categorytypecheck").on('change',function() {
			if ($("[name='categorytype1']").val() == "E01" || $("[name='categorytype1']").val() == "E02") {
				$(".check").show();
				$("#seatcounthide").hide();
				$("#seatInt").hide();
			}
		});
		</c:if>
        //카테고리
        $("#categorytype1").on('change',function(item){
        	if($("[name='categorytype1']").val()=="E03"){
        		$(".culture").hide();
        		$(".brand").hide();
        		$(".brandmix").hide();
    			$(".brandrightexp").hide();
				$(".pcontent").show();
				$("#categorytype2").show();
				$("#categorytype3").show();
				// 카테고리 2
				var tmpHTML = "";
				var tmpHTML = "<option value=''>선택</option>";

				$.each(categorytype2, function (i,val) {
					if(val.upCode=="E03") {
						tmpHTML = tmpHTML + "<option value='"+val.minorCd+"'>"+val.cdName+"</option>";
					}
				});

				$("#categorytype2").html(tmpHTML);
        	}else {
        		$(".brand").hide();
				$(".culture").show();
				$("#personhide").show();
				$(".pcontent").show();
				$("#seatcounthide").hide();
				$("#categorytype2").hide();
				$("#categorytype3").hide();

        	}
        	 myIframeResizeHeight("${layerMode.frmId}");
        });

        $("#categorytype2").on('change',function(){
        	var depth2 = $("[name='categorytype2']").val();
        	if($("[name='categorytype1']").val()=="E03"){
	    		if (depth2 == "E0301") {
	    			$(".brandmix").hide();
	    			$(".brandrightexp").hide();
					$("#personhide").show();
					$("#seatcounthide").show();
	    			$(".brand").show();
					$(".pcontent").show();
					$("[name='categorytype3']").show();
	    		}else if(depth2 == "E0302" || depth2 == "E0303"){
	    			$(".brand").hide();
	    			$(".brandrightexp").hide();
					$("#personhide").show();
					$("#seatcounthide").show();
	    			$(".brandmix").show();
					$(".pcontent").show();
					$("[name='categorytype3']").hide();
	    		}else if(depth2 == "E0304"){
	    			$(".brand").hide();
					$(".pcontent").hide();
					$(".pusetimenote").hide();
	    			$(".brandmix").hide();
					$("#personhide").show();
					$("#seatcounthide").show();
	    			$(".brandrightexp").show();
					$("[name='categorytype3']").hide();
	    		}
	    		// 카테고리 2
    			var tmpHTML = "<option value=''>선택</option>";

    			$.each(categorytype3, function (i,val) {
    				if(val.upCode==depth2) {
	    				tmpHTML = tmpHTML + "<option value='"+val.minorCd+"'>"+val.cdName+"</option>";
    				}
            	});
    			$("#categorytype3 option").remove();
    			$("#categorytype3").append(tmpHTML);
        	}
        	myIframeResizeHeight("${layerMode.frmId}");
        });

        fnInit();

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
					//alert("[파일업로드] 처리도중 오류가 발생하였습니다.");
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


    var btnEvent = {
    	btnSave : function() {
    		// 프로그램타입 체크
    		if(isNull($("[name='categorytype1'] option:selected").val())) {
    			alert("프로그램 타입 값이 없습니다. \n프로그램 타입 은(는) 필수 입력값입니다.");
    			$("[name='categorytype1'] option:selected").focus();
    			return;
    		} else {
    			if($("[name='categorytype1'] option:selected").val()=="E03") {
    				if(isNull($("[name='categorytype2'] option:selected").val())) {
    					alert("프로그램 타입 값이 없습니다. \n프로그램 타입 은(는) 필수 입력값입니다.");
    	    			$("[name='categorytype2'] option:selected").focus();
    	    			return;
    				} else if($("[name='categorytype2'] option:selected").val()=="E0301") {
    					if(isNull($("[name='categorytype3'] option:selected").val())) {
        					alert("프로그램 타입 값이 없습니다. \n프로그램 타입 은(는) 필수 입력값입니다.");
        	    			$("[name='categorytype3'] option:selected").focus();
        	    			return;
        				}
    				}
    			}
    		}

			var startday = $("[name='startdate']").val().replace("-","").replace("-","");
			var endday = $("[name='enddate']").val().replace("-","").replace("-","");

			if(startday>endday || startday==endday){
				alert("시작일과 종료일이 같을수없습니다.\n또는 시작일은 종료일을 넘길수 없습니다.");
				return;
			}

			//공통
			var startdate = $("[name='startdate']").val();
			var enddate = $("[name='enddate']").val();
			var pp = $("[name='ppseq']").val();
			var statuscode = $("[name='statuscode']").val();
			var productname = $("[name='productname']").val();
			// 프로그램소개
			var pcontent = $("[name='content']").val();

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

			if(isNull(productname)){
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

			var depth1 = $("[name='categorytype1']").val();
			var depth2 = $("[name='categorytype2']").val();

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
					alert("정원(개인) 값이 없습니다. \n정원(개인) 은(는) 필수 입력값입니다.");
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
					alert("정원(개인) 값이 없습니다. \n정원(개인) 은(는) 필수 입력값입니다.");
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
				if(confirm("등록하시겠습니까?")){
					btnEvent.doSave("");
					return;
				}
			 }else{
			 btnEvent.doSaveFile();
			 }

    	},
    	doSaveFile : function() {
    		// 파일 저장 후 doSave 호춯(파일 키 리턴)
    		showLoading();
            if(confirm("프로그램타입정보는 등록 후 수정이 불가능합니다.\n진행하시겠습니까?")){
				btnEvent.doSave();
        	}
    	}
    	, doSave : function(fileKey,item, idx){

			var usekeyword = $("[name='keyword']").val().replace(/\s/gi, '');

            var param = {
                categorytype1:$("[name='categorytype1'] option:selected").val(),
                categorytype2:$("[name='categorytype2'] option:selected").val(),
                categorytype3:$("[name='categorytype3'] option:selected").val(),
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
                keyword : usekeyword,
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
                url: "<c:url value="/manager/reservation/programInfo/programInfoOneInsert.do"/>"
               	, data: param
                , success: function( data, textStatus, jqXHR){
					if(data.result.errCode < 0){
						var msg = '<spring:message code="errors.load"/>';
						alert(msg);
					} else if(data.result.errCode == 2) {
						alert("이미 등록되어 사용중인 프로그램이 있습니다.");
                    } else {
                        $("#expseq").val(data.listtype);
                        var sExpSeq = data.listtype;
						$("#category").val($("[name='categorytype1']").val());
						btnEvent.goTwoPage(sExpSeq);
                        alert("등록했습니다.");
                    }
                },
                error: function( jqXHR, textStatus, errorThrown) {
    				var mag = '<spring:message code="errors.load"/>';
    				alert(mag);
                }
            });

        }, goTwoPage : function(val){
			var f = document.listForm;
			f.expseq.value = val;
			f.listMode.value = "I";
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
	    <c:if test="${layerMode.listMode eq 'CHECK' }">
	        <h2 class="fl">측정프로그램 등록</h2>
	    </c:if>
	    <c:if test="${layerMode.listMode eq 'EXP' }">
	        <h2 class="fl">체험프로그램 등록</h2>
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
<div class="tbl_write">
	<form:form id="listForm" name="listForm" method="post">
	    <input type="hidden" id="expseq" name="expseq" value="${listtype.expseq}"/>
	    <input type="hidden" id="type" name="type" value="${listtype.type}"/>
		<input type="hidden" id="category" name="category" value="${listtype.categorytype1}"/>
	    <input type="hidden" name="listMode" value="${layerMode.listMode}"/>
		<input type="hidden" name="frmId" value="${param.frmId}"/>
		<input type="hidden" name="menuAuth" id="menuAuth" value="${param.menuAuth}"/>
	</form:form>
  	<span>* 코드는 자동 생성됩니다.</span>
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
					<c:if test="${layerMode.listMode eq 'CHECK' }">
						<select id="categorytypecheck" name="categorytype1" class="required" title="프로그램 타입">
							<option value="">선택</option>
							<c:forEach var="item" items="${typeCheck}">
								<option value="${item.type}">${item.name}</option>
							</c:forEach>
						</select>
					</c:if>
					<c:if test="${layerMode.listMode eq 'EXP' }">
						<select id="categorytype1" name="categorytype1" class="required" title="프로그램 타입">
							<option value="">선택</option>
						</select>
						<select id="categorytype2" name="categorytype2">
							<option value="">선택</option>
						</select>

						<select id="categorytype3" name="categorytype3">
							<option value="">선택</option>
						</select>
					</c:if>
                </td>
            </tr>
            <tr>
                <th scope="row">운영기간</th>
                <td>
                    <input type="text" name="startdate" class="AXInput datepDay required" title="운영기간(시작)" readonly="readonly">
                    ~
                    <input type="text" name="enddate" class="AXInput datepDay required" title="운영기간(종료)" readonly="readonly">
                </td>
                <th scope="row">프로그램 명</th>
                <td>
                    <input type="text" class="AXInput required" maxlength="50" title="프로그램 명" style="min-width:303px;" name="productname"/>
                </td>
            </tr>
			<tr>
                <th scope="row">PP</th>
                <td>
                    <select name="ppseq" class="required" title="PP">
                        <option value="">선택</option>
                        <c:forEach var="item" items="${ppCodeList}">
                            <option value="${item.commonCodeSeq}">${item.codeName}</option>
                        </c:forEach>
                    </select>
                </td>
                <th scope="row">상태</th>
                <td>
                    <select name="statuscode" class="required" title="상태">
                        <option value="">선택</option>
                        <option value="B01">사용</option>
                        <option value="B02">미사용</option>
                    </select>
                </td>
            </tr>
            <tr>
                <th scope="row" class="pcontent">프로그램소개</th>
                <td colspan="3" class="pcontent">
                    <textarea style="width:100%;min-width:700px;min-height: 50px;resize: none;" maxlength="500" name="content" class="required" title="프로그램소개"></textarea>
                </td>
            </tr>
		</tbody>
  	</table>
  	<br/>
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
	                <textarea style="width:100%;min-width:700px;min-height: 50px;resize: none;" maxlength="500" name="intro" class="required" title="프로그램개요"></textarea>
	            </td>
            </tr>
            <!-- 브랜드셀렉트 -->
            <tr class="brandmix" style="display: none;">
	        	<th scope="row" >프로그램정보1</th>
	            <td colspan="3">
					<form id="fileForm6" method="POST" enctype="multipart/form-data">
						<input type="file" name="file6" id="file6" style="width:30%;" title="파일첨부" onChange="javascript:html.othersize(this,6);" />
						<input type="hidden" name="filekey" id="filekey6" title="파일번호" />
						<input type="hidden" name="oldfilekey" id="oldfilekey6" title="파일번호" />
					</form>
					시간 <input type="text" name="time1" title="프로그램정보1" class="AXInput" style="min-width:303px;"/>
	                 <br/> 내용 <textarea style="width:100%;min-width:700px;min-height: 50px;resize: none;" maxlength="500" name="note1" title="프로그램내용1"></textarea>
	             </td>
	        </tr>
         	<tr class="brandmix" style="display: none;">
            	<th scope="row" >프로그램정보2</th>
             	<td colspan="3">
					<form id="fileForm7" method="POST" enctype="multipart/form-data">
						<input type="file" name="file7" id="file7" style="width:30%;" title="파일첨부" onChange="javascript:html.othersize(this,7);" />
						<input type="hidden" name="filekey" id="filekey7" title="파일번호" />
						<input type="hidden" name="oldfilekey" id="oldfilekey7" title="파일번호" />
					</form>
					시간 <input type="text" class="AXInput" name="time2" title="프로그램정보2" style="min-width:303px;"/>
			       <br/>내용 <textarea style="width:100%;min-width:700px;min-height: 50px;resize: none;" maxlength="500" name="note2" title="프로그램내용2"></textarea>
             	</td>
         	</tr>
         	<tr class="brandmix" style="display: none;">
            	<th scope="row" >프로그램정보3</th>
             	<td colspan="3">
					<form id="fileForm8" method="POST" enctype="multipart/form-data">
						<input type="file" name="file8" id="file8" style="width:30%;" title="파일첨부" onChange="javascript:html.othersize(this,8);" />
						<input type="hidden" name="filekey" id="filekey8" title="파일번호" />
						<input type="hidden" name="oldfilekey" id="oldfilekey8" title="파일번호" />
					</form>
					시간 <input type="text" class="AXInput" name="time3" title="프로그램정보3" style="min-width:303px;"/>
				<br/>내용 <textarea style="width:100%;min-width:700px;min-height: 50px;resize: none;" maxlength="500" name="note3" title="프로그램내용3"></textarea>
             	</td>
         	</tr>
         	<!-- 문화체험 -->
            <tr class="culture" style="display: none;">
                <th scope="row" >테마명</th>
                <td colspan="3">
                    <input type="text" class="AXInput required" style="min-width:303px;" maxlength="25" name="themename" title="테마명"/>
                </td>
            </tr>
            <tr class="culture brand brandmix brandrightexp check" style="display: none;">
            	<th scope="row" >정원</th>
                <td colspan="3">
					<input type="hidden" class="required">
					<span id="personhide">개인 <input type="text" id="nump" class="AXInput required check" title="정원(개인)" style="min-width:100px;" name="seatcount1" maxlength="100" oninput="maxLengthCheck(this)"/></span>
				   	<span id="seatcounthide">/ 그룹 <input type="text" id="numg" class="AXInput required" title="정원(그룹)" style="min-width:100px;" name="seatcount2" maxlength="100" oninput="maxLengthCheck(this)"/></span>
					<span id="seatInt"> 개인정원인원 <input type="text" id="numInt" class="AXInput required" title="정원(인원)" style="min-width:100px;" name="seatcount" maxlength="100" oninput="maxLengthCheck(this)" onkeydown="onlyNumber(this)"/></span>
                </td>
             </tr>
             <tr class="culture brand brandmix brandrightexp check" style="display: none;">
                 <th scope="row" >체험시간</th>
                 <td>
                     <input type="text" class="AXInput required" title="체험시간" maxlength="30" style="min-width:100px;" name="usetime"/>
                 </td>
                 <th scope="row" class="pusetimenote">체험시간 부가설명</th>
                 <td class="pusetimenote">
                     <input type="text" class="AXInput" title="체험시간 부가설명" style="width:95%;min-width:100px;" maxlength="100" name="usetimenote"/>
                 </td>
             </tr>
            <tr class="culture brand brandmix brandrightexp check" style="display: none;">
                <th >예약자격</th>
                <td>
                    <input type="text" class="AXInput required" title="예약자격" style="width:95%;min-width:303px;" maxlength="60" name="role"/>
                </td>
                <th >예약자격 부가설명</th>
                <td>
                    <input type="text" class="AXInput" title="예약자격 부가설명" style="width:95%;min-width:303px;" maxlength="100" name="rolenote"/>
                </td>
            </tr>
            <tr class="culture brand brandmix brandrightexp check" style="display: none;">
                <th >준비물</th>
                <td colspan="3">
                    <input type="text" class="AXInput required" title="준비물" maxlength="30" style="width:95%;min-width:303px;" name="preparation"/>
                </td>
            </tr>
            <!-- 브랜드 체험 -->
            <tr class="brand check" style="display: none;">
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
            <tr class="culture brand brandmix check brandrightexp" style="display: none;">
	            <th scope="row" >키워드</th>
	            <td colspan="3">
	                <input type="text" name="keyword" class="AXInput"  maxlength="50" style="min-width:600px;"/>
					<br>콤마(,) 단위로 넣어 주세요.
	            </td>
        	</tr>
       </tbody>
    </table>
    <div class="contents_title clear" style="padding-top: 15px;height: 15px;">
		<div class="fr">
			<a href="javascript:btnEvent.btnSave();" id="btnSave" class="btn_green" >저장</a>
		</div>
        <div align="center">
            <a href="javascript:;" id="btnReturn" class="btn_gray">목록</a>
            <c:if test="${layerMode.listMode eq 'U'}">
                <a href="javascript:;" id="btnNext" class="btn_gray">다음 단계로</a>
            </c:if>
        </div>
    </div>
</div>

<!-- Board List -->

</body>