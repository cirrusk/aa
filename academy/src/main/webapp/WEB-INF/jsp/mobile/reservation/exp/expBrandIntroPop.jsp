<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<script type="text/javascript">

//아이프레임 높이 조정
function abnkoreaBrandPop_resize(){
	var iHeight = $("#uiLayerPop_brandExp").height() + 70;
	var isResize = false;
	if(iHeight == null){
		iHeight = $(document).height();
	}
	try
	{
		window.parent.postMessage(iHeight, "*");
		isResize = true;
		
		$("#layerMask").css("display", "none");
	}
	catch(e){
		isResize = false;
	}
	if(!isResize)
	{
		try{
		}
		catch(e){
		}
	}
}


function setCategorytype3Layer(flag, paramCategory2){
	$("#categorytype2Pop").val(paramCategory2);
	var param = {
		  categorytype2 : $("#categorytype2Pop").val()
		, ppseq : $("#ppseq").val()
	};

	$.ajax({
		url: "<c:url value="/mobile/reservation/setBrandCategorytype3Ajax.do"/>"
		, type : "POST"
		, async : false
		, data: param
		, success: function(data, textStatus, jqXHR){
			var brandCategoryType3Layer = data.searchBrandCategoryType3;
			
			var html="";
			
			$("#appendBradnCategoryLayer").empty();
			
			if(flag == "D"){
				
				$("#uiLayerPop_brandExp").find("#selectArea").find("a").each(function(){
					$(this).removeClass("active");
					
					if($(this).attr("id") == paramCategory2){
						$(this).addClass("active");
					}
				});
				
				detailBrandIntroLayer(brandCategoryType3Layer, flag);
			}else{
				
				clickBrandIntro(brandCategoryType3Layer, flag);
			}
			
			setTimeout(function(){ abnkoreaBrandPop_resize(); }, 500);
		},
		error: function( jqXHR, textStatus, errorThrown) {
			alert("처리도중 오류가 발생하였습니다.");
		}
	});
}

function detailBrandIntroLayer(brandCategoryType3Layer, flag){
	var html = "";
	var categorytype3Array = new Array();
	
	if($("#categorytype2Pop").val() == "E0301"){
		html  = "<div class='hWrap mgtS' id='brandSelect'>";
		html += "	<h2>브랜드 선택</h2>";
		html += "</div>";
		html += "	<div class='programSelect'>";
		html += "		<ul class='brandListCate' id='appendBrandImagePop'>";
		
		/* 브랜드 선택 이미지 셋팅 */
		for(var i = 0; i < brandCategoryType3Layer.length; i++){
			categorytype3Array.push(brandCategoryType3Layer[i].categorytype3);
		}
		
		html += "</ul>";
		html += "</div>";
		
		if(flag != "D"){
			
			html +="<div class='hWrap mgtS'>";
			html +="	<h2>프로그램 선택</h2>";
			html +="</div>";
		}
		
		$("#appendBradnCategoryLayer").css("display", "block");
		$("#appendBradnCategoryLayer").append(html);
		
		setBrandSelectImageLayer(categorytype3Array, flag);
		
		setProductListLayer('', $("#categorytype3Pop").val(), 'D');
	}else{
		
		
		html  ="<div class='hWrap mgtS'>";
		html +="	<h2>프로그램 선택</h2>";
		html +="</div>";
		
		$("#appendBradnCategoryLayer").css("display", "block");
		$("#appendBradnCategoryLayer").append(html);
		
		setProductListLayer('', '', 'D');
	}
	
}

function setBrandSelectImageLayer(categorytype3Array, flag){
	
	var param = {
		 categorytype3Array : categorytype3Array
		};
		
		$.ajax({
			url: "<c:url value='/mobile/reservation/searchExpBrandProgramKeyListAjax.do' />"
			, type : "POST"
			, data: param
			, success: function(data, textStatus, jqXHR){
				var brandProgramKeyList = data.brandProgramKeyList;
				var html = "";
				
				$("#appendBrandImagePop").empty();
				
				for(var i = 0; i < brandProgramKeyList.length; i++){
					
					if(brandProgramKeyList[i].filekey == 0 || brandProgramKeyList[i].filekey == null || brandProgramKeyList[i].filekey == ""){
						
						if(flag == "C"){
							html += "<li>";
							html += "<a href='javascript:void(0);' onclick=\"javascript:setProductListLayer(this,'"+brandProgramKeyList[i].categorytype3+"', 'C');\">"
							html += "<span class='img'><img src='/_ui/mobile/images/academy/@brand_img.gif' alt='"+brandProgramKeyList[i].categoryname3+"'></span>";
							html += "</li>";
						}else{
							if(brandProgramKeyList[i].categorytype3 == $("#categorytype3Pop").val()){
								html += "<li>";
								html += "<a href='javascript:void(0);' onclick=\"javascript:setProductListLayer(this,'"+brandProgramKeyList[i].categorytype3+"', 'C');\" class='on'>"
								html += "<span class='img'><img src='/_ui/mobile/images/academy/@brand_img.gif' alt='"+brandProgramKeyList[i].categoryname3+"'></span>";
								html += "</li>";
							}else{
								html += "<li>";
								html += "<a href='javascript:void(0);' onclick=\"javascript:setProductListLayer(this,'"+brandProgramKeyList[i].categorytype3+"', 'C');\">"
								html += "<span class='img'><img src='/_ui/mobile/images/academy/@brand_img.gif' alt='"+brandProgramKeyList[i].categoryname3+"'></span>";
								html += "</li>";
							}
						}
						
					}else {
						if(flag == "C"){
							html += "<li>";
							html += "<a href='javascript:void(0);' onclick=\"javascript:setProductListLayer(this,'"+brandProgramKeyList[i].categorytype3+"', 'C');\">"
// 							html += "<span class='img'><img src='/reservation/imageView.do?filefullurl="+brandProgramKeyList[i].filefullurl+"&storefilename="+brandProgramKeyList[i].storefilename+"' alt='"+brandProgramKeyList[i].categoryname3+"'></span>";
							html += "<span class='img'><img src='/reservation/imageView.do?file="+brandProgramKeyList[i].storefilename+"&mode=RSVBRAND' alt='"+brandProgramKeyList[i].categoryname3+"'></span>";
							html += "</li>";
						}else{
							if(brandProgramKeyList[i].categorytype3 == $("#categorytype3Pop").val()){
								html += "<li>";
								html += "<a href='javascript:void(0);' onclick=\"javascript:setProductListLayer(this,'"+brandProgramKeyList[i].categorytype3+"', 'C');\" class='on'>"
// 								html += "<span class='img'><img src='/reservation/imageView.do?filefullurl="+brandProgramKeyList[i].filefullurl+"&storefilename="+brandProgramKeyList[i].storefilename+"' alt='"+brandProgramKeyList[i].categoryname3+"'></span>";
								html += "<span class='img'><img src='/reservation/imageView.do?file="+brandProgramKeyList[i].storefilename+"&mode=RSVBRAND' alt='"+brandProgramKeyList[i].categoryname3+"'></span>";
								html += "</li>";
							}else{
								html += "<li>";
								html += "<a href='javascript:void(0);' onclick=\"javascript:setProductListLayer(this,'"+brandProgramKeyList[i].categorytype3+"', 'C');\">"
// 								html += "<span class='img'><img src='/reservation/imageView.do?filefullurl="+brandProgramKeyList[i].filefullurl+"&storefilename="+brandProgramKeyList[i].storefilename+"' alt='"+brandProgramKeyList[i].categoryname3+"'></span>";
								html += "<span class='img'><img src='/reservation/imageView.do?file="+brandProgramKeyList[i].storefilename+"&mode=RSVBRAND' alt='"+brandProgramKeyList[i].categoryname3+"'></span>";
								html += "</li>";
							}
						}
					}
				}
				
				$("#appendBrandImagePop").append(html);
				setTimeout(function(){ abnkoreaBrandPop_resize(); }, 500);
			},
			error: function( jqXHR, textStatus, errorThrown) {
				alert("처리도중 오류가 발생하였습니다.");
			}
		});
}


function clickBrandIntro(brandCategoryType3Layer, flag){
	
	var html = "";
	var categorytype3Array = new Array();
	
	if($("#categorytype2Pop").val() == "E0301"){
		
		html  = "<div class='hWrap mgtS' id='brandSelect'>";
		html += "	<h2>브랜드 선택</h2>";
		html += "</div>";
		html += "	<div class='programSelect'>";
		html += "		<ul class='brandListCate' id='appendBrandImagePop'>";
		
		/* 브랜드 선택 이미지 셋팅 */
		for(var i = 0; i < brandCategoryType3Layer.length; i++){
			categorytype3Array.push(brandCategoryType3Layer[i].categorytype3);
		}
		
		html += "</ul>";
		html += "</div>";
		
		$("#appendBradnCategoryLayer").css("display", "block");
		$("#appendBradnCategoryLayer").append(html);
		
		setBrandSelectImageLayer(categorytype3Array, flag);
		
	}else{
		
		html  ="<div class='hWrap mgtS' id='layerSeleProgram'>";
		html +="	<h2>프로그램 선택</h2>";
		html +="</div>";
		
		$("#appendBradnCategoryLayer").css("display", "block");
		$("#appendBradnCategoryLayer").append(html);
		
		setProductListLayer('' ,'', 'C');
	}
	
}

function setProductListLayer(obj ,categorytype3, flag){

	$("#categorytype3Pop").val(categorytype3);
	
	if(flag != "D"){
		$("#appendBradnCategoryLayer").children(".programSelect").find("li").each(function(){
			if($(this).children().is(".on") === true){
				$(this).children().removeClass("on");
			}
		});
	}
	
	$(obj).addClass("on");
	
	$("#appendBradnCategoryLayer").find("dl").each(function(){
		$(this).remove();
	});

	var param = {
		  categorytype3 : $("#categorytype3Pop").val()
		, categorytype2 : $("#categorytype2Pop").val()
		, ppseq : $("#ppseq").val()
	}
	
	$.ajax({
		url: "<c:url value="/mobile/reservation/searchBrandProductListAjax.do"/>"
		, type : "POST"
		, async : false
		, data: param
		, success: function(data, textStatus, jqXHR){
			var brandProductList = data.searchBrandProductList;
			var html="";
			
			if(brandProductList[0].categorytype3name == "N"){
				$("#appendBradnCategoryLayer").empty();
				html  ="<div class='hWrap mgtS' id='layerSeleProgram'>";
				html +="	<h2>프로그램 선택</h2>";
				html +="</div>";
			}else{
				$("#layerSeleProgram").remove();
				
				html  ="<div class='hWrap mgtS' id='layerSeleProgram'>";
				html +="	<h2>프로그램 선택</h2>";
				html +="</div>";
			}
		
			html += "<dl class='programList' id='barnadContents01'>";
			
			/* 프로그램 이름 셋팅 */
			for(var i = 0; i < brandProductList.length; i++){
				
				if(brandProductList[i].expseq == $("#expseqPop").val()){
					
					html += "<dt class='active'><a href='javascript:void(0);'  onclick =\"javascript:setProgramChoice('C', "+brandProductList[i].expseq+", this);\">"+brandProductList[i].productname;
					html += "<span class='btn'>상세보기</span></dt>";
					html += "<dd id='dd"+brandProductList[i].expseq+"'></dd>";
				}else{
					html += "<dt><a href='javascript:void(0);'  onclick=\"javascript:setProgramChoice('C', "+brandProductList[i].expseq+", this);\">"+brandProductList[i].productname;
					html += "<span class='btn'>상세보기</span></dt>";
					html += "<dd id='dd"+brandProductList[i].expseq+"'></dd>";
				}
				
			}
			html += "</dl>";
			$("#appendBradnCategoryLayer").append(html);
			
			
			setTimeout(function(){ abnkoreaBrandPop_resize(); }, 500);
			
		},
		error: function( jqXHR, textStatus, errorThrown) {
			alert("처리도중 오류가 발생하였습니다.");
		}
	});
	
	if(flag == "D"){
		
		setProgramChoice(flag, $("#expseqPop").val(), '');
	}
}

function setProgramChoice(flag, expseq, obj){
	var tempExpSeq = "dd"+expseq;
	
	/* 아코디언 닫기 */
	if($(obj).parent().is(".active") == true){
		
		$("#barnadContents01").children().removeClass("active");
	}else{
		if(flag == "C"){
			
			$("#expseqPop").val(expseq);
			$("#barnadContents01").children().removeClass("active");
			
			$(obj).parent().addClass("active");
			
		}
		
		$("#dd"+expseq).prev().addClass("active");
		
		var param = {
			  categorytype3 : $("#categorytype3Pop").val()
			, categorytype2 : $("#categorytype2Pop").val()
			, expseq : $("#expseqPop").val()
			, ppseq : $("#ppseq").val()
		};

		$.ajax({
			url: "<c:url value="/mobile/reservation/searchBrandProductDetailAjax.do"/>"
			, type : "POST"
			, async : false
			, data: param
			, success: function(data, textStatus, jqXHR){
				var brandProductDetail = data.searchBrandProductDetail;
				
				if(brandProductDetail.categorytype2 == "E0301"){
					setBrandSelectDatil(brandProductDetail);
				}else if(brandProductDetail.categorytype2 == "E0302"){
					setBrandMixDatil(brandProductDetail);
				}else if(brandProductDetail.categorytype2 == "E0303"){
					setBrandTourDatil(brandProductDetail);
				}else if(brandProductDetail.categorytype2 == "E0304"){
					setBrandJointDatil(brandProductDetail);
				}
				
				setTimeout(function(){ abnkoreaBrandPop_resize(); }, 500);
			},
			error: function( jqXHR, textStatus, errorThrown) {
				alert("처리도중 오류가 발생하였습니다.");
			}
		});
	}
}

function setBrandSelectDatil(brandProductDetail){
	
	var html = "";
	
	$("#dd"+brandProductDetail.expseq).empty();
	$("#dd"+brandProductDetail.expseq).addClass("active");
	
	
	html  = "<section class='programInfoWrap'>";
	html += "	<div class='programInfo'>";
	if( brandProductDetail.intro != undefined && brandProductDetail.intro != null && brandProductDetail.intro != ""){
	html += "		<p class='tit'>"+brandProductDetail.intro+"</p>";
	}
	if(brandProductDetail.content != null && brandProductDetail.content != undefined && brandProductDetail.content != ""){
	html += "		<p>"+brandProductDetail.content+"</p>";
	}
	html += "		<div class='imgExplain'>";
	html += "			<div class='img' id = 'appendImg'>이미지 없음</div>";
	html += "				<ul class='listDash'>";
	if("N" != brandProductDetail.note1){
	html += "					<li>"+brandProductDetail.note1+"</li>";
	}
	if("N" != brandProductDetail.note2){
	html += "					<li>"+brandProductDetail.note2+"</li>";
	}
	if("N" != brandProductDetail.note3){
	html += "					<li>"+brandProductDetail.note3+"</li>";
	}
	html += "				</ul>";
	html += "		</div>";
	html += "	</div>";
	html += "	<dl class='roomTbl'>";
	html += "		<dt><span class='bizIcon icon1'></span>정원</dt>";
	if(brandProductDetail.seatcount != "" && brandProductDetail.seatcount != null && brandProductDetail.seatcount != undefined){
	html += "		<dd>"+brandProductDetail.seatcount+"</dd>";
	}
	html += "		<dt><span class='bizIcon icon2'></span>체험시간</dt>";
	if(brandProductDetail.usetime != undefined && brandProductDetail.usetime != null && brandProductDetail.usetime != ""){

		if (brandProductDetail.usetimenote != undefined && brandProductDetail.usetimenote != null && brandProductDetail.usetimenote != "") {
			html += "		<dd>"+brandProductDetail.usetime+"<br/>("+brandProductDetail.usetimenote+")</dd>";
		} else {
			html += "		<dd>"+brandProductDetail.usetime+"</dd>";
		}
	}else{
		if(brandProductDetail.usetime != undefined && brandProductDetail.usetime != null && brandProductDetail.usetime != ""){
			html += "		<dd>"+brandProductDetail.usetime+"</dd>";
		}else{
			html += "		<dd>"+brandProductDetail.usetimenote+"</dd>";
		}
	}
	html += "		<dt><span class='bizIcon icon3'></span>예약자격</dt>";
	if((brandProductDetail.role != undefined && brandProductDetail.role != null  && brandProductDetail.role != "") && (brandProductDetail.rolenote != undefined && brandProductDetail.rolenote != null && brandProductDetail.rolenote != "")){
	html += "		<dd>"+brandProductDetail.role+"<br><span class='fsS'>("+brandProductDetail.rolenote+")</span></dd>";
	}else{
		if(brandProductDetail.role != undefined && brandProductDetail.role != null && brandProductDetail.role != ""){
			html += "		<dd>"+brandProductDetail.role+"</dd>";
		}else{
			html += "		<dd>"+brandProductDetail.rolenote+"</dd>";
		}
	}
	html += "		<dt><span class='bizIcon icon5'></span>준비물</dt>";
	if(brandProductDetail.preparation != "" && brandProductDetail.preparation != null && brandProductDetail.preparation != undefined){
	html += "		<dd>"+brandProductDetail.preparation+"</dd>";
	}else{
	html += "		<dd></dd>";
	}
	html += "</section>";
	
	$("#dd"+brandProductDetail.expseq).append(html);
	
	if(
		   (brandProductDetail.filekey1 == "N")
		&& (brandProductDetail.filekey2 == "N")
		&& (brandProductDetail.filekey3 == "N")
		&& (brandProductDetail.filekey4 == "N")
		&& (brandProductDetail.filekey5 == "N")
		
	){
		$("#detailImgPop").empty();
		$("#detailImgPop").append("-");
	}else{
		
		var filekey = new Array(); 
		if(brandProductDetail.filekey1 != "N"){
			filekey.push(brandProductDetail.filekey1);
		}
		if(brandProductDetail.filekey2 != "N"){
			filekey.push(brandProductDetail.filekey2);
		}
		if(brandProductDetail.filekey3 != "N"){
			filekey.push(brandProductDetail.filekey3);
		}
		if(brandProductDetail.filekey4 != "N"){
			filekey.push(brandProductDetail.filekey4);
		}
		if(brandProductDetail.filekey5 != "N"){
			filekey.push(brandProductDetail.filekey5);
		}
		
		setBrandSelectDatilImage(filekey);
	}
}

function setBrandSelectDatilImage(filekey){
	var param = {filekey : filekey};
	
	$.ajaxCall({
		url: "<c:url value='/mobile/reservation/searchExpBrandFileKeyListAjax.do' />"
		, type : "POST"
		, data: param
		, success: function(data, textStatus, jqXHR){
			var imageFileKeyList = data.expImageFileKeyList;
			
			var html = "";
			
			if(imageFileKeyList.length != 0){
				$("#appendImg").empty();
				
				for(var i = 0; i < imageFileKeyList.length; i++){
					var html = "<img src='/reservation/imageView.do?file="+imageFileKeyList[i].storefilename+"&mode=RESERVATION' alt=''>";
				}
				$("#appendImg").append(html);
			}else{
				
			}
			
		},
		error: function( jqXHR, textStatus, errorThrown) {
			alert("처리도중 오류가 발생하였습니다.");
		}
	});
}


function setBrandMixDatil(brandProductDetail){
	var html = "";
	
	$("#dd"+brandProductDetail.expseq).empty();
	$("#dd"+brandProductDetail.expseq).addClass("active");
	
	html  = "<section class='programInfoWrap'>";
	html += "	<div class='programInfo'>";
	if(brandProductDetail.content != null && brandProductDetail.content != undefined){
	html += "		<p>"+brandProductDetail.content+"</p>";
	}
	html += "		<div class='imgExplain' id='appendImage'>";
// 	html += "			<div class='img' id='appendImage'><img src='/_ui/desktop/images/academy/@img_program_02.gif' alt=''></div>";
// 	html += "			<strong>체험시간 : 40분</strong>";
// 	html += "			<ul class='listDash'>";
// 	html += "				<li>- 피부 고유의 보습 능력 체계</li>";
// 	html += "				<li>- 써플리먼트, 드링크소개</li>";
// 	html += "				<li>- 뉴트리라이트 뷰티 습관</li>";
// 	html += "				<li>- 아쿠아 드링크 시음</li>";
// 	html += "			</ul>";
	html += "		</div>";
	html += "	</div>";
	html += "	<dl class='roomTbl'>";
	html += "		<dt><span class='bizIcon icon1'></span>인원</dt>";
	if(brandProductDetail.seatcount != "" && brandProductDetail.seatcount != null && brandProductDetail.seatcount != undefined){
		html += "		<dd>"+brandProductDetail.seatcount+"</dd>";
	}
	html += "		<dt><span class='bizIcon icon2'></span>체험시간</dt>";
	if((brandProductDetail.usetime != null && brandProductDetail.usetime != undefined && brandProductDetail.usetime != "") && (brandProductDetail.usetimenote != null && brandProductDetail.usetimenote != undefined && brandProductDetail.usetimenote != "")){
	html += "		<dd>"+brandProductDetail.usetime+"<br/>("+brandProductDetail.usetimenote+")</dd>";
	}else{
		if(brandProductDetail.usetime != null && brandProductDetail.usetime != undefined && brandProductDetail.usetime != ""){
			html += "		<dd>"+brandProductDetail.usetime+"</dd>";
		}else{
			html += "		<dd>"+brandProductDetail.usetimenote+"</dd>";
		}
	}
	html += "		<dt><span class='bizIcon icon3'></span>예약자격</dt>";
	if((brandProductDetail.role != null && brandProductDetail.role != undefined && brandProductDetail.role != "") && (brandProductDetail.rolenote != null && brandProductDetail.rolenote != undefined && brandProductDetail.rolenote != "")){
	html += "		<dd>"+brandProductDetail.role+"<br><span class='fsS'>("+brandProductDetail.rolenote+")</span></dd>";
	}else{
		if(brandProductDetail.role != null && brandProductDetail.role != undefined && brandProductDetail.role != ""){
			html += "		<dd>"+brandProductDetail.role+"</dd>";
		}else{
			html += "		<dd>"+brandProductDetail.rolenote+"</dd>";
		}
	}
	html += "		<dt><span class='bizIcon icon5'></span>준비물</dt>";
	if(brandProductDetail.preparation != "" && brandProductDetail.preparation != null && brandProductDetail.preparation != undefined){
	html += "		<dd>"+brandProductDetail.preparation+"</dd>";
	}else{
	html += "		<dd></dd>";
	}
	html += "	</dl>";
	html += "</section>";
	
	
	$("#dd"+brandProductDetail.expseq).append(html);
	
	if(
		   (brandProductDetail.filekey6 == "N")
		&& (brandProductDetail.filekey7 == "N")
		&& (brandProductDetail.filekey8 == "N")
	){
		$("#detailImgPop").empty();
		$("#detailImgPop").append("-");
	}else{
		
		var filekey = new Array(); 
		if(brandProductDetail.filekey6 != "N"){
			filekey.push(brandProductDetail.filekey6);
		}
		if(brandProductDetail.filekey7 != "N"){
			filekey.push(brandProductDetail.filekey7);
		}
		if(brandProductDetail.filekey8 != "N"){
			filekey.push(brandProductDetail.filekey8);
		}
// 		if(brandProductDetail.filekey4 != "N"){
// 			filekey.push(brandProductDetail.filekey4);
// 		}
// 		if(brandProductDetail.filekey5 != "N"){
// 			filekey.push(brandProductDetail.filekey5);
// 		}
		
		setBrandMixDatilImage(filekey, brandProductDetail);
	}
}

function setBrandMixDatilImage(filekey, brandProductDetail){
	
	var param = {filekey : filekey};
	
	$.ajaxCall({
		url: "<c:url value='/reservation/searchExpBrandFileKeyListAjax.do' />"
		, type : "POST"
		, data: param
		, success: function(data, textStatus, jqXHR){
			var imageFileKeyList = data.expImageFileKeyList;
			
			var html = "";
			
// 			console.log(imageFileKeyList);
			
			if(imageFileKeyList.length != 0){
				$("#appendImage").empty();
				
				if(imageFileKeyList.length == 1){
					
				 	html  = "<div class='img'><img src='/reservation/imageView.do?file="+imageFileKeyList[0].storefilename+"&mode=RESERVATION' style='width: 147px;height: 108px;' alt=''></div>";
				 	html += "<strong>체험시간 : "+brandProductDetail.time1+"</strong>";
				 	html += "<ul class='listDash'>";
				 	html += "	<li>"+brandProductDetail.note1+"</li>";
				 	html += "</ul>";
					
					
				} else if(imageFileKeyList.length == 2){
					html  = "<div class='img'><img src='/reservation/imageView.do?file="+imageFileKeyList[0].storefilename+"&mode=RESERVATION' style='width: 147px;height: 108px;' alt=''></div>";
				 	html += "<strong>체험시간 : "+brandProductDetail.time1+"</strong>";
				 	html += "<ul class='listDash'>";
				 	html += "	<li>"+brandProductDetail.note1+"</li>";
				 	html += "</ul>";
				 	
					html += "<div class='img'><img src='/reservation/imageView.do?file="+imageFileKeyList[1].storefilename+"&mode=RESERVATION' style='width: 147px;height: 108px;' alt=''></div>";
				 	html += "<strong>체험시간 : "+brandProductDetail.time2+"</strong>";
				 	html += "<ul class='listDash'>";
				 	html += "	<li>"+brandProductDetail.note2+"</li>";
				 	html += "</ul>";
					
					
					
				}else if(imageFileKeyList.length == 3){
					
					html  = "<div class='img'><img src='/reservation/imageView.do?file="+imageFileKeyList[0].storefilename+"&mode=RESERVATION' style='width: 147px;height: 108px;' alt=''></div>";
				 	html += "<strong>체험시간 : "+brandProductDetail.time1+"</strong>";
				 	html += "<ul class='listDash'>";
				 	html += "	<li>"+brandProductDetail.note1+"</li>";
				 	html += "</ul>";
				 	
					html += "<div class='img'><img src='/reservation/imageView.do?file="+imageFileKeyList[1].storefilename+"&mode=RESERVATION' style='width: 147px;height: 108px;' alt=''></div>";
				 	html += "<strong>체험시간 : "+brandProductDetail.time2+"</strong>";
				 	html += "<ul class='listDash'>";
				 	html += "	<li>"+brandProductDetail.note2+"</li>";
				 	html += "</ul>";
				 	
					html += "<div class='img'><img src='/reservation/imageView.do?file="+imageFileKeyList[2].storefilename+"&mode=RESERVATION' style='width: 147px;height: 108px;' alt=''></div>";
				 	html += "<strong>체험시간 : "+brandProductDetail.time3+"</strong>";
				 	html += "<ul class='listDash'>";
				 	html += "	<li>"+brandProductDetail.note3+"</li>";
				 	html += "</ul>";
				}
				
				$("#appendImage").append(html);
			}
		},
		error: function( jqXHR, textStatus, errorThrown) {
			alert("처리도중 오류가 발생하였습니다.");
		}
	});
}

function setBrandTourDatil(brandProductDetail){
var html = "";
	
	$("#dd"+brandProductDetail.expseq).empty();
	$("#dd"+brandProductDetail.expseq).addClass("active");
	
	html  = "<section class='programInfoWrap'>";
	html += "	<div class='programInfo' id='appendTourImage'>";
	if(brandProductDetail.content != null && brandProductDetail.content != undefined){
	html += "		<p>"+brandProductDetail.content+"</p>";
	}
	html += "	</div>";
	html += "	<dl class='roomTbl'>";
	html += "		<dt><span class='bizIcon icon1'></span>정원</dt>";
	if(brandProductDetail.seatcount != "" && brandProductDetail.seatcount != null && brandProductDetail.seatcount != undefined){
	html += "		<dd>"+brandProductDetail.seatcount+"</dd>";
	}
	html += "		<dt><span class='bizIcon icon2'></span>체험시간</dt>";
	if((brandProductDetail.usetime != null && brandProductDetail.usetime != undefined && brandProductDetail.usetime != "") && (brandProductDetail.usetimenote != null && brandProductDetail.usetimenote != undefined && brandProductDetail.usetimenote != "")){
	html += "		<dd>"+brandProductDetail.usetime+"<br/>("+brandProductDetail.usetimenote+")</dd>";	
	}else{
		if(brandProductDetail.usetime != null && brandProductDetail.usetime != undefined && brandProductDetail.usetime != ""){
			html += "		<dd>"+brandProductDetail.usetime+"</dd>";
		}else{
			html += "		<dd>"+brandProductDetail.usetimenote+"</dd>";
		}
	}
	html += "		<dt><span class='bizIcon icon3'></span>예약자격</dt>";
	if((brandProductDetail.role != undefined && brandProductDetail.role != null && brandProductDetail.role != "") && (brandProductDetail.rolenote != undefined && brandProductDetail.rolenote != null && brandProductDetail.rolenote != "")){
	html += "		<dd>"+brandProductDetail.role+"<br><span class='fsS'>("+brandProductDetail.rolenote+")</span></dd>";
	}else{
		if(brandProductDetail.role != undefined && brandProductDetail.role != null && brandProductDetail.role != ""){
			html += "		<dd>"+brandProductDetail.role+"</dd>";
		}else{
			html += "		<dd>"+brandProductDetail.rolenote+"</dd>";
		}
	}
	html += "		<dt><span class='bizIcon icon5'></span>준비물</dt>";
	if(brandProductDetail.preparation != "" && brandProductDetail.preparation != null && brandProductDetail.preparation != undefined && brandProductDetail.preparation != ""){
	html += "		<dd>"+brandProductDetail.preparation+"</dd>";
	}else{
	html += "		<dd></dd>";
	}
	html += "	</dl>";
	html += "</section>";
	
	
	$("#dd"+brandProductDetail.expseq).append(html);
	
	if(
		   (brandProductDetail.filekey1 == "N")
		&& (brandProductDetail.filekey2 == "N")
		&& (brandProductDetail.filekey3 == "N")
		&& (brandProductDetail.filekey4 == "N")
		&& (brandProductDetail.filekey5 == "N")
		&& (brandProductDetail.filekey6 == "N")
		&& (brandProductDetail.filekey7 == "N")
		&& (brandProductDetail.filekey8 == "N")
	){
		$("#detailImgPop").empty();
		$("#detailImgPop").append("-");
	}else{
		
		var filekey = new Array(); 
		if(brandProductDetail.filekey1 != "N"){
			filekey.push(brandProductDetail.filekey1);
		}
		if(brandProductDetail.filekey2 != "N"){
			filekey.push(brandProductDetail.filekey2);
		}
		if(brandProductDetail.filekey3 != "N"){
			filekey.push(brandProductDetail.filekey3);
		}
		if(brandProductDetail.filekey4 != "N"){
			filekey.push(brandProductDetail.filekey4);
		}
		if(brandProductDetail.filekey5 != "N"){
			filekey.push(brandProductDetail.filekey5);
		}
		if(brandProductDetail.filekey6 != "N"){
			filekey.push(brandProductDetail.filekey6);
		}
		if(brandProductDetail.filekey7 != "N"){
			filekey.push(brandProductDetail.filekey7);
		}
		if(brandProductDetail.filekey8 != "N"){
			filekey.push(brandProductDetail.filekey8);
		}
		
		setBrandTourDetailImage(filekey, brandProductDetail);
	}
}

function setBrandTourDetailImage(filekey, brandProductDetail){
	var param = {filekey : filekey};
	
	$.ajaxCall({
		url: "<c:url value='/reservation/searchExpBrandFileKeyListAjax.do' />"
		, type : "POST"
		, data: param
		, success: function(data, textStatus, jqXHR){
			var imageFileKeyList = data.expImageFileKeyList;
			
			var html = "";
			
			if(imageFileKeyList.length != 0){
				$("#appendTourImage").empty();
				
				if(imageFileKeyList.length == 1){
					
				 	html  = "		<div class='imgExplain'>";
				 	html += "			<div class='img'><img src='/reservation/imageView.do?file="+imageFileKeyList[0].storefilename+"&mode=RESERVATION' style='width: 147px;height: 108px;' alt=''></div>";
				 	html += "			<strong>"+brandProductDetail.time1+"</strong>";
				 	html += "			<ul class='listDash'>";
				 	html += "				<li>"+brandProductDetail.note1+"</li>";
				 	html += "			</ul>";
				 	html += "		</div>";
					
					
				} else if(imageFileKeyList.length == 2){
					html  = "		<div class='imgExplain'>";
				 	html += "			<div class='img'><img src='/reservation/imageView.do?file="+imageFileKeyList[0].storefilename+"&mode=RESERVATION' style='width: 147px;height: 108px;' alt=''></div>";
				 	html += "			<strong>"+brandProductDetail.time1+"</strong>";
				 	html += "			<ul class='listDash'>";
				 	html += "				<li>"+brandProductDetail.note1+"</li>";
				 	html += "			</ul>";
				 	html += "		</div>";
				 	
					html += "		<div class='imgExplain'>";
				 	html += "			<div class='img'><img src='/reservation/imageView.do?file="+imageFileKeyList[1].storefilename+"&mode=RESERVATION' style='width: 147px;height: 108px;' alt=''></div>";
				 	html += "			<strong>"+brandProductDetail.time2+"</strong>";
				 	html += "			<ul class='listDash'>";
				 	html += "				<li>"+brandProductDetail.note2+"</li>";
				 	html += "			</ul>";
				 	html += "		</div>";
					
				}else if(imageFileKeyList.length == 3){
					html  = "		<div class='imgExplain'>";
				 	html += "			<div class='img'><img src='/reservation/imageView.do?file="+imageFileKeyList[0].storefilename+"&mode=RESERVATION' style='width: 147px;height: 108px;' alt=''></div>";
				 	html += "			<strong>"+brandProductDetail.time1+"</strong>";
				 	html += "			<ul class='listDash'>";
				 	html += "				<li>"+brandProductDetail.note1+"</li>";
				 	html += "			</ul>";
				 	html += "		</div>";
				 	
					html += "		<div class='imgExplain'>";
				 	html += "			<div class='img'><img src='/reservation/imageView.do?file="+imageFileKeyList[1].storefilename+"&mode=RESERVATION' style='width: 147px;height: 108px;' alt=''></div>";
				 	html += "			<strong>"+brandProductDetail.time2+"</strong>";
				 	html += "			<ul class='listDash'>";
				 	html += "				<li>"+brandProductDetail.note2+"</li>";
				 	html += "			</ul>";
				 	html += "		</div>";
				 	
					html += "		<div class='imgExplain'>";
				 	html += "			<div class='img'><img src='/reservation/imageView.do?file="+imageFileKeyList[2].storefilename+"&mode=RESERVATION' style='width: 147px;height: 108px;' alt=''></div>";
				 	html += "			<strong>"+brandProductDetail.time3+"</strong>";
				 	html += "			<ul class='listDash'>";
				 	html += "				<li>"+brandProductDetail.note3+"</li>";
				 	html += "			</ul>";
				 	html += "		</div>";
					
				}
				
				$("#appendTourImage").append(html);
			}
		},
		error: function( jqXHR, textStatus, errorThrown) {
			alert("처리도중 오류가 발생하였습니다.");
		}
	});
}

function setBrandJointDatil(brandProductDetail){
// 	console.log(brandProductDetail)
	
	var html = "";
	if(brandProductDetail.expseq != null){
		$("#dd"+brandProductDetail.expseq).empty();
		$("#dd"+brandProductDetail.expseq).addClass("active");
	}
	
	html  = "<section class='programInfoWrap'>";
	html += "	<div class='programInfo'>";
	if( brandProductDetail.intro != undefined && brandProductDetail.intro != null && brandProductDetail.intro != ""){
	html += "		<p>"+brandProductDetail.intro+"</p>";
	}
	html += "		<div class='imgExplain'>";
	html += "			<div class='img'><img src='/_ui/desktop/images/academy/@img_program_08.gif' alt=''></div>";
	html += "			<strong>날짜선택</strong>";
	html += "			<ul class='listDash'>";
	html += "				<li>- 맞춤식 체험을 원하시는 날짜를 선택해 주세요.</li>";
	html += "			</ul>";
	html += "		</div>";
	html += "		<div class='imgExplain'>";
	html += "			<div class='img'><img src='/_ui/desktop/images/academy/@img_program_09.gif' alt=''></div>";
	html += "			<strong>전화상담</strong>";
	html += "			<ul class='listDash'>";
	html += "				<li>- ABC 직원이 전화로 상담해 드립니다.</li>";
	html += "			</ul>";
	html += "		</div>";
	html += "		<div class='imgExplain'>";
	html += "			<div class='img'><img src='/_ui/desktop/images/academy/@img_program_10.gif' alt=''></div>";
	html += "			<strong>시간&amp;체험 컨텐츠 결정</strong>";
	html += "			<ul class='listDash'>";
	html += "				<li>- 원하시는 시간과 원하시는 체험 컨텐츠를 결정합니다.</li>";
	html += "			</ul>";
	html += "		</div>";
	html += "	</div>";
	html += "	<dl class='roomTbl'>";
	html += "		<dt><span class='bizIcon icon1'></span>정원</dt>";
	if(brandProductDetail.seatcount != "" && brandProductDetail.seatcount != null && brandProductDetail.seatcount != undefined){
	html += "		<dd>"+brandProductDetail.seatcount+"</dd>";
	}
	html += "		<dt><span class='bizIcon icon2'></span>체험시간</dt>";
	if((brandProductDetail.usetime != undefined && brandProductDetail.usetime != null && brandProductDetail.usetime != "") && (brandProductDetail.usetimenote != undefined && brandProductDetail.usetimenote != null && brandProductDetail.usetimenote != "")){
	html += "		<dd>"+brandProductDetail.usetime+"<br/>("+brandProductDetail.usetimenote+")</dd>";
	}else{
		if(brandProductDetail.usetimenote != undefined && brandProductDetail.usetimenote != null && brandProductDetail.usetimenote != ""){
			html += "		<dd>"+brandProductDetail.usetimenote+"</dd>";
		}else{
			html += "		<dd>"+brandProductDetail.usetime+"</dd>";
		}
	}
	html += "		<dt><span class='bizIcon icon3'></span>예약자격</dt>";
	if((brandProductDetail.role != null && brandProductDetail.role != undefined && brandProductDetail.role != "")&&(brandProductDetail.rolenote != null && brandProductDetail.rolenote != undefined && brandProductDetail.rolenote != "")){
	html += "		<dd>"+brandProductDetail.role+"<br><span class='fsS'>("+brandProductDetail.rolenote+")</span></dd>";
	}else{
		if(brandProductDetail.role != null && brandProductDetail.role != undefined && brandProductDetail.role != ""){
			html += "		<dd>"+brandProductDetail.role+"</dd>";
		}else{
			html += "		<dd>"+brandProductDetail.rolenote+"</dd>";
		}
	}
	html += "		<dt><span class='bizIcon icon5'></span>준비물</dt>";
	if(brandProductDetail.preparation != "" && brandProductDetail.preparation != null && brandProductDetail.preparation != undefined){
	html += "		<dd>"+brandProductDetail.preparation+"</dd>";
	}else{
	html += "		<dd></dd>";
	}
	html += "	</dl>";
	html += "</section>";
	
	
	$("#dd"+brandProductDetail.expseq).append(html);
}


function closeBrandIntroLayer(){
	$("#uiLayerPop_brandExp").hide();
	$("#layerMask").remove();
}

</script>

<!-- layer popoup -->
<div class="pbLayerPopup fixedFullsize" id="uiLayerPop_brandExp" tabindex="0" style="display: block; top: 0px;">
	<div class="pbLayerHeader">
		<strong>브랜드체험 소개</strong>
	</div>
	<div class="pbLayerContent" style="height: 816px; overflow: auto;">
	
		<!-- @edit 20160708 전반적 수정 -->
		<!-- Layer Pop Content -->
		<div class="hWrap">
			<h2>브랜드 카테고리 선택</h2>
		</div>
		<div class="selcWrap">
			<div class="programWrap">
				<div class="selectArea sizeM" id="selectArea">
<!-- 					<a href="#pGroup1" class="active">브랜드 셀렉트</a><a href="#pGroup2" class="">브랜드 믹스</a><a href="#pGroup3" class="">브랜드 투어</a><a href="#pGroup4" class="">맞춤식 체험</a> -->
					<c:forEach var="item" items="${brandCategoryType2}">
						<a href="#" id="${item.categorytype2}" onclick="javascript:setCategorytype3Layer('C', '${item.categorytype2}');">${item.categorytype2name}</a>
					</c:forEach>
				</div>
			
				<div class="" id="appendBradnCategoryLayer" style="display: block;">
				</div>
			
				<!-- //programListWrap -->
			</div>
			<!-- //programWrap -->
		</div>
		<div class="btnWrap bNumb1">
			<a href="#" class="btnBasicGL" onclick="javascript:closeBrandIntroLayer();">닫기</a>
		</div>
	</div>
	<a href="#none" class="btnPopClose"><img src="/_ui/mobile/images/common/btn_close.gif" alt="창 닫기"></a>
</div>