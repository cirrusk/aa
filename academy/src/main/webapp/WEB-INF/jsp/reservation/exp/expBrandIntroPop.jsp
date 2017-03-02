<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/jsp/framework/include/header.jsp" %>
<%@ include file="/WEB-INF/jsp/framework/include/layerPop.jsp" %>

<script type="text/javascript">

$(document.body).ready(function(){
	//카테고리 3셋팅
	setCategorytype3('F', '');
	
	$(".btnBasicGL").on("click", function(){
		
		try{
			self.close();
		}catch(e){
			//console.log(e);
		}
	});
});

function setCategorytype3(flag, paramCategory2){
	
	if(flag == "C"){
		$("#categorytype2").val("");
		$("#categorytype2").val(paramCategory2);
		
	}
	if(flag == "C" && $("#categorytype2").val() == "E0301"){
		$("#categorytype3").val("E030101");
	}
	var param = {
		  categorytype2 : $("#categorytype2").val()
		, ppseq : $("#ppseq").val()
	};
 	
	if(flag == "F" ||  $("#categorytype2").val() == "E0301"){
		
		$.ajax({
			url: "<c:url value="/reservation/setBrandCategorytype3Ajax.do"/>"
			, type : "POST"
			, async : false
			, data: param
			, success: function(data, textStatus, jqXHR){
				var brandCategoryType3 = data.searchBrandCategoryType3;
				var categorytype3Array = new Array();
				
				var html="";
				
				$("#appendBradnCategory").empty();
				
				html = "<h2 class='hide'>"+brandCategoryType3[0].categorytype2name+"</h2>";
				html += "<h3 class='pdNone2'><img src='/_ui/desktop/images/academy/h3_w020500250_02.gif' alt='브랜드 선택'></h3>";
				
				html += "<div class='programImg programImg1'>";
				html += "<span id='appendBrandImagePop'>";
				
				
				/* 브랜드 선택 이미지 셋팅 */
				for(var i = 0; i < brandCategoryType3.length; i++){
					if(brandCategoryType3[i].categorytype3 == $("#categorytype3").val()){
						$("#categorytype3").val(brandCategoryType3[i].categorytype3);
					}
					
					categorytype3Array.push(brandCategoryType3[i].categorytype3);
				}
				
				
				html += "</span>";
				html += "</div>";
				
				html += "<h3 class='pdNone2'><img src='/_ui/desktop/images/academy/h3_w020500290.gif' alt='프로그램 선택'></h3>";
				
				$("#appendBradnCategory").append(html);
				
				setBrandSelectImage(categorytype3Array);
				
			},
			error: function( jqXHR, textStatus, errorThrown) {
				var mag = '<spring:message code="errors.load"/>';
				alert(mag);
			}
		});
	}else{
		
		$("#categorytype2").val(paramCategory2);
		$("#categorytype3").val("");
		
	}

	
	setProductList(flag, $("#categorytype3").val(), '');
	
}

function setBrandSelectImage(categorytype3Array){
	var param = {
		 categorytype3Array : categorytype3Array
	};
	
	$.ajax({
		url: "<c:url value='/reservation/searchExpBrandProgramKeyListAjax.do' />"
		, type : "POST"
		, data: param
		, success: function(data, textStatus, jqXHR){
			var brandProgramKeyList = data.brandProgramKeyList;
			var html = "";
			
			$("#appendBrandImagePop").empty();
			
			for(var i = 0; i < brandProgramKeyList.length; i++){
				if(brandProgramKeyList[i].filekey == 0 || brandProgramKeyList[i].filekey == null || brandProgramKeyList[i].filekey == ""){
					
					if($("#popFlag").val() == "P"){
						if(brandProgramKeyList[i].categorytype3 == "E030101"){
							html += "<a href='javascript:void(0);' onclick=\"javascript:setProductList('C', '"+brandProgramKeyList[i].categorytype3+"', this);\" class='active'>";
							html += "	<img src='/_ui/desktop/images/academy/@img_program"+(i+1)+".jpg' alt='"+brandProgramKeyList[i].categoryname3+"'>";
							html += "</a>";
							
						}else{
							html += "<a href='javascript:void(0);' onclick=\"javascript:setProductList('C', '"+brandProgramKeyList[i].categorytype3+"', this);\" >";
							html += "	<img src='/_ui/desktop/images/academy/@img_program"+(i+1)+".jpg' alt='"+brandProgramKeyList[i].categoryname3+"'>";
							html += "</a>";
						}
					}else {
						if(brandProgramKeyList[i].categorytype3 == $("#categorytype3").val()){
							html += "<a href='javascript:void(0);' onclick=\"javascript:setProductList('C', '"+brandProgramKeyList[i].categorytype3+"', this);\" class='active'>";
							html += "	<img src='/_ui/desktop/images/academy/@img_program"+(i+1)+".jpg' alt='"+brandProgramKeyList[i].categoryname3+"'>";
							html += "</a>";
							
						}else{
							html += "<a href='javascript:void(0);' onclick=\"javascript:setProductList('C', '"+brandProgramKeyList[i].categorytype3+"', this);\" >";
							html += "	<img src='/_ui/desktop/images/academy/@img_program"+(i+1)+".jpg' alt='"+brandProgramKeyList[i].categoryname3+"'>";
							html += "</a>";
						}
					}
					
				}else{
					if($("#popFlag").val() == "P"){
						if(brandProgramKeyList[i].categorytype3 == "E030101"){
							html += "<a href='javascript:void(0);' onclick=\"javascript:setProductList('C', '"+brandProgramKeyList[i].categorytype3+"', this);\" class='active'>";
// 							html += "	<img src='/reservation/imageView.do?filefullurl="+brandProgramKeyList[i].filefullurl+"&storefilename="+brandProgramKeyList[i].storefilename+"' alt='"+brandProgramKeyList[i].categoryname3+"'>";
							html += "	<img src='/reservation/imageView.do?file="+brandProgramKeyList[i].storefilename+"&mode=RSVBRAND' alt='"+brandProgramKeyList[i].categoryname3+"'>";
							html += "</a>";
							
						}else{
							html += "<a href='javascript:void(0);' onclick=\"javascript:setProductList('C', '"+brandProgramKeyList[i].categorytype3+"', this);\" >";
// 							html += "	<img src='/reservation/imageView.do?filefullurl="+brandProgramKeyList[i].filefullurl+"&storefilename="+brandProgramKeyList[i].storefilename+"' alt='"+brandProgramKeyList[i].categoryname3+"'>";
							html += "	<img src='/reservation/imageView.do?file="+brandProgramKeyList[i].storefilename+"&mode=RSVBRAND' alt='"+brandProgramKeyList[i].categoryname3+"'>";
							html += "</a>";
						}
					}else{
						if(brandProgramKeyList[i].categorytype3 == $("#categorytype3").val()){
							html += "<a href='javascript:void(0);' onclick=\"javascript:setProductList('C', '"+brandProgramKeyList[i].categorytype3+"', this);\" class='active'>";
// 							html += "	<img src='/reservation/imageView.do?filefullurl="+brandProgramKeyList[i].filefullurl+"&storefilename="+brandProgramKeyList[i].storefilename+"' alt='"+brandProgramKeyList[i].categoryname3+"'>";
							html += "	<img src='/reservation/imageView.do?file="+brandProgramKeyList[i].storefilename+"&mode=RSVBRAND' alt='"+brandProgramKeyList[i].categoryname3+"'>";
							html += "</a>";
							
						}else{
							html += "<a href='javascript:void(0);' onclick=\"javascript:setProductList('C', '"+brandProgramKeyList[i].categorytype3+"', this);\" >";
// 							html += "	<img src='/reservation/imageView.do?filefullurl="+brandProgramKeyList[i].filefullurl+"&storefilename="+brandProgramKeyList[i].storefilename+"' alt='"+brandProgramKeyList[i].categoryname3+"'>";
							html += "	<img src='/reservation/imageView.do?file="+brandProgramKeyList[i].storefilename+"&mode=RSVBRAND' alt='"+brandProgramKeyList[i].categoryname3+"'>";
							html += "</a>";
						}
					}
					
					
				}
					
			}
			
			$("#appendBrandImagePop").append(html);
		},
		error: function( jqXHR, textStatus, errorThrown) {
			var mag = '<spring:message code="errors.load"/>';
			alert(mag);
		}
	});
}


function setProgramChoice(flag, expseq, obj){
	
	/* 아코디언 닫기 */
	if($(obj).parent().is(".active") == true){
		
		$("#barnadContents01").children().removeClass("active");
		
	}else{
	/* 아코디언 열기 */
		if(flag == "C"){
			
			if($("#expseq").val() != null){
				$("#expseq").val(expseq);
				$("#barnadContents01").children().removeClass("active");
				
				$(obj).parent().addClass("active");
				$("#dd"+expseq).addClass("active");
			}else{
//	 			$("#expseq").val(expseq);
				$("#barnadContents01").children().removeClass("active");
				
				$(obj).parent().addClass("active");
//	 			$("#dd"+expseq).addClass("active");
			}
			
			$("#popFlag").val("");
			$("#popFlag").val("D");
		}
		
		if($("#popFlag").val() != "P"){
			var param = {
					  categorytype3 : $("#categorytype3").val()
					, categorytype2 : $("#categorytype2").val()
					, expseq : $("#expseq").val()
					, ppseq : $("#ppseq").val()
				};
				

				$.ajax({
					url: "<c:url value="/reservation/searchBrandProductDetailAjax.do"/>"
					, type : "POST"
					, async : false
					, data: param
					, success: function(data, textStatus, jqXHR){
						var brandProductDetail = data.searchBrandProductDetail;
						
//	 					console.log(brandProductDetail);
						
						if(brandProductDetail.categorytype2 == "E0301"){
							setBrandSelectDatil(brandProductDetail);
						}else if(brandProductDetail.categorytype2 == "E0302"){
							setBrandMixDatil(brandProductDetail);
						}else if(brandProductDetail.categorytype2 == "E0303"){
							setBrandTourDatil(brandProductDetail);
						}else if(brandProductDetail.categorytype2 == "E0304"){
							setBrandJointDatil(brandProductDetail);
						}
				
					},
					error: function( jqXHR, textStatus, errorThrown) {
						var mag = '<spring:message code="errors.load"/>';
						alert(mag);
					}
				});
		}
		
		
	}
	
	
	
	
}

function setBrandSelectDatil(brandProductDetail){
	var html = "";
	
	if(brandProductDetail.expseq != null){
		$("#dd"+brandProductDetail.expseq).empty();
		$("#dd"+brandProductDetail.expseq).addClass("active");
	}
	
	
	html  ="<section class='programInfoWrap'>";
	html +="	<div class='programInfo'>";
	if( brandProductDetail.intro != undefined && brandProductDetail.intro != null && brandProductDetail.intro != ""){
		html +="		<p class='tit'>"+brandProductDetail.intro+"</p>";
	}
	if(brandProductDetail.content != null && brandProductDetail.content != undefined && brandProductDetail.content != ""){
		html +="		<p>"+brandProductDetail.content+"</p>";
	}
	html +="		<div class='imgExplain'>";
	html +="			<div class='img'>이미지 없음</div>";
	//	 		html +="			<div class='img'><img src='/reservation/imageView.do?filefullurl="+brandProductDetail[i].filefullurl+"&storefilename="+brandProductDetail[i].storefilename+"' alt=''></div>";
	html +="			<ul class='listDotFS'>";
	if("N" != brandProductDetail.note1){
	html +="				<li>"+brandProductDetail.note1+"</li>";
	}else{
	html +="				<li></li>";
	}
	
	if("N" != brandProductDetail.note2){
		html +="			<li>"+brandProductDetail.note2+"</li>";
	}else{
		html +="			<li></li>";
	}
	
	if("N" != brandProductDetail.note3){
		html +="			<li>"+brandProductDetail.note3+"</li>";
	}else{
		html +="			<li></li>";
	}
	html +="			</ul>";
	html +="		</div>";
	html +="	</div>";
	html +="	<table class='roomInfoDetail'>";
	html +="		<colgroup>";
	html +="			<col style='width:20%'>";
	html +="			<col style='width:auto'>";
	html +="			<col style='width:20%'>";
	html +="			<col style='width:auto'>";
	html +="		</colgroup>";
	html +="		<tbody><tr>";
	html +="			<td class='title'><span class='icon1'>정원</span></td>";
	if(brandProductDetail.seatcount != "" && brandProductDetail.seatcount != null && brandProductDetail.seatcount != undefined){
	html +="			<td>"+brandProductDetail.seatcount+"</td>";
	}
	html +="			<td class='title'><span class='icon2'>체험시간</span></td>";
	
	if(brandProductDetail.usetime != null && brandProductDetail.usetime != undefined && brandProductDetail.usetime != ""){
		
		if(brandProductDetail.usetimenote != null && brandProductDetail.usetimenote != undefined && brandProductDetail.usetimenote != "") {
			html +="		<td>"+brandProductDetail.usetime+"<br/>("+brandProductDetail.usetimenote+")</td>";			
		}else {
			html +="		<td>"+brandProductDetail.usetime+"</td>";
		}
		
	}else{
		if(brandProductDetail.usetime != null && brandProductDetail.usetime != undefined && brandProductDetail.usetime != ""){
			html +="	<td>"+brandProductDetail.usetime+"</td>";
		}else{
			html +="	<td>"+brandProductDetail.usetimenote+"</td>";
		}
	}
// 	html +="			<td>"+brandProductDetail.usetime+"</td>";
	html +="		</tr>";
	html +="		<tr>";
	html +="			<td class='title'><span class='icon3'>예약자격</span></td>";
	html +="			<td>"+brandProductDetail.role+"<br><span class='normal'>"+brandProductDetail.rolenote+"</span></td>";
// 	html +="			<td>"+brandProductDetail.rolenote+"</td>";
	html +="			<td class='title'><span class='icon5'>준비물</span></td>";
	if(brandProductDetail.preparation != "" && brandProductDetail.preparation != null && brandProductDetail.preparation != undefined){
	html +="			<td>"+brandProductDetail.preparation+"</td>";
	}else{
	html +="			<td></td>";
	}
	html +="		</tr>";
	html +="	</tbody></table>";
	html +="</section>";
			
	$("#dd"+brandProductDetail.expseq).append(html);
	

	if(
		   (brandProductDetail.filekey1 == "N")
		&& (brandProductDetail.filekey2 == "N")
		&& (brandProductDetail.filekey3 == "N")
		&& (brandProductDetail.filekey4 == "N")
		&& (brandProductDetail.filekey5 == "N")
	){
		$(".img").empty();
		$(".img").append("-");
		
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

		
// 		console.log(filekey);
		
		setBrandSelectDatilImage(filekey);
	}
}

function setBrandSelectDatilImage(filekey){
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
				$(".img").empty();
				
				for(var i = 0; i < imageFileKeyList.length; i++){
					var html = "<img src='/reservation/imageView.do?file="+imageFileKeyList[i].storefilename+"&mode=RESERVATION' title='"+imageFileKeyList[i].altdesc+"' >";
				}
				$(".img").append(html);
			}else{
				
			}
		},
		error: function( jqXHR, textStatus, errorThrown) {
			var mag = '<spring:message code="errors.load"/>';
			alert(mag);
		}
	});
}

function setBrandMixDatil(brandProductDetail){
	var html = "";
	
	if(brandProductDetail.expseq != null){
		$("#dd"+brandProductDetail.expseq).empty();
		$("#dd"+brandProductDetail.expseq).addClass("active");
	}
	
	
		
		html  ="<section class='programInfoWrap'>";
		html +="	<div class='programInfo'>";
		if(brandProductDetail.content != null && brandProductDetail.content != "" && brandProductDetail.content != undefined){
		html +="		<p>"+brandProductDetail.content+"</p>";
		}
		html +="		<div class='imgExplain div2'>";
		html +="		<div id='appendImage' style='display: -webkit-box'></div>";
		html +="	</div>";
		html +="	<table class='roomInfoDetail'>";
		html +="		<colgroup>";
		html +="			<col style='width:20%'>";
		html +="			<col style='width:auto'>";
		html +="			<col style='width:20%'>";
		html +="			<col style='width:auto'>";
		html +="		</colgroup>";
		html +="		<tbody><tr>";
		html +="			<td class='title'><span class='icon1'>정원</span></td>";
		if(brandProductDetail.seatcount != undefined && brandProductDetail.seatcount != "" && brandProductDetail.seatcount !=  null){
		html +="			<td>"+brandProductDetail.seatcount+"</td>";
		}
		html +="			<td class='title'><span class='icon2'>체험시간</span></td>";
		if((brandProductDetail.usetime != null && brandProductDetail.usetime != undefined && brandProductDetail.usetime != "") && (brandProductDetail.usetimenote != null && brandProductDetail.usetimenote != undefined && brandProductDetail.usetimenote != "")){
			html +="		<td>"+brandProductDetail.usetime+"<br/>("+brandProductDetail.usetimenote+")</td>";
		}else{
			if(brandProductDetail.usetime != null && brandProductDetail.usetime != undefined && brandProductDetail.usetime != ""){
				html +="		<td>"+brandProductDetail.usetime+"</td>";
			}else{
				html +="		<td>"+brandProductDetail.usetimenote+"</td>";
			}
		}
		html +="		</tr>";
		html +="		<tr>";
		html +="			<td class='title'><span class='icon3'>예약자격</span></td>";
		if((brandProductDetail.role != null && brandProductDetail.role != undefined && brandProductDetail.role != "") && (brandProductDetail.rolenote != null && brandProductDetail.rolenote != undefined && brandProductDetail.rolenote != "")){
			html +="		<td>"+brandProductDetail.role+"<br><span class='normal'>"+brandProductDetail.rolenote+"</span></td>";
		}else{
			if(brandProductDetail.role != null && brandProductDetail.role != undefined && brandProductDetail.role != ""){
				html +="	<td>"+brandProductDetail.role+"</td>";
			}else{
				html +="	<td>"+brandProductDetail.rolenote+"</td>";
			}
		}
		html +="			<td class='title'><span class='icon5'>준비물</span></td>";
		if(brandProductDetail.preparation != "" && brandProductDetail.preparation != null && brandProductDetail.preparation != undefined){
		html +="			<td>"+brandProductDetail.preparation+"</td>";
		}else{
		html +="			<td></td>";
		}
		html +="		</tr>";
		html +="	</tbody></table>";
		html +="</section>";
	
	
	
	$("#dd"+brandProductDetail.expseq).append(html);
	
	
	if(
			   (brandProductDetail.filekey6 == "N")
			&& (brandProductDetail.filekey7 == "N")
			&& (brandProductDetail.filekey8 == "N")
		){
			$("#appendImage").empty();
			$("#appendImage").append("-");
			
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
					html  = "<div class='first'>";
// 					html += "	<div class='img'><img src='/reservation/imageView.do?filefullurl="+imageFileKeyList[0].filefullurl+"&storefilename="+imageFileKeyList[0].storefilename+"' style='width: 147px;height: 108px;' alt=''></div>";
					html += "	<div class='img'><img src='/reservation/imageView.do?file="+imageFileKeyList[0].storefilename+"&mode=RESERVATION' title='"+imageFileKeyList[0].altdesc+"' style='width: 147px;height: 108px;' alt=''></div>";
					html += "	<strong>체험시간 : "+brandProductDetail.time1+"</strong>";
					html += "	<ul class='listDot'>";
					html += "		<li>"+brandProductDetail.note1+"</li>";
					html += "	</ul>";
					html += "</div>";
				} else if(imageFileKeyList.length == 2){
					html  = "<div class='first'>";
					html += "	<div class='img'><img src='/reservation/imageView.do?file="+imageFileKeyList[0].storefilename+"&mode=RESERVATION' title='"+imageFileKeyList[0].altdesc+"' style='width: 147px;height: 108px;' alt=''></div>";
					html += "	<strong>체험시간 : "+brandProductDetail.time1+"</strong>";
					html += "	<ul class='listDot'>";
					html += "		<li>"+brandProductDetail.note1+"</li>";
					html += "	</ul>";
					html += "</div>";
					
					html += "<div>";
					html += "	<div class='img'><img src='/reservation/imageView.do?file="+imageFileKeyList[1].storefilename+"&mode=RESERVATION' title='"+imageFileKeyList[1].altdesc+"' style='width: 147px;height: 108px;' alt=''></div>";
					html += "	<strong>체험시간 : "+brandProductDetail.time2+"</strong>";
					html += "	<ul class='listDot'>";
					html += "		<li>"+brandProductDetail.note2+"</li>";
					html += "	</ul>";
					html += "</div>";
					
					
				}else if(imageFileKeyList.length == 3){
					
					html  = "<div class='first'>";
					html += "	<div class='img'><img src='/reservation/imageView.do?file="+imageFileKeyList[0].storefilename+"&mode=RESERVATION' title='"+imageFileKeyList[0].altdesc+"' style='width: 147px;height: 108px;' alt=''></div>";
					html += "	<strong>체험시간 : "+brandProductDetail.time1+"</strong>";
					html += "	<ul class='listDot'>";
					html += "		<li>"+brandProductDetail.note1+"</li>";
					html += "	</ul>";
					html += "</div>";
					
					html += "<div>";
					html += "	<div class='img'><img src='/reservation/imageView.do?file="+imageFileKeyList[1].storefilename+"&mode=RESERVATION' title='"+imageFileKeyList[1].altdesc+"' style='width: 147px;height: 108px;' alt=''></div>";
					html += "	<strong>체험시간 : "+brandProductDetail.time2+"</strong>";
					html += "	<ul class='listDot'>";
					html += "		<li>"+brandProductDetail.note2+"</li>";
					html += "	</ul>";
					html += "</div>";
					
					html += "<div>";
					html += "	<div class='img'><img src='/reservation/imageView.do?file="+imageFileKeyList[2].storefilename+"&mode=RESERVATION' title='"+imageFileKeyList[2].altdesc+"' style='width: 147px;height: 108px;' alt=''></div>";
					html += "	<strong>체험시간 : "+brandProductDetail.time3+"</strong>";
					html += "	<ul class='listDot'>";
					html += "		<li>"+brandProductDetail.note3+"</li>";
					html += "	</ul>";
					html += "</div>";
				}
				
				$("#appendImage").append(html);
			}
		},
		error: function( jqXHR, textStatus, errorThrown) {
			var mag = '<spring:message code="errors.load"/>';
			alert(mag);
		}
	});
}

function setBrandTourDatil(brandProductDetail){
	var html = "";
	
	if(brandProductDetail.expseq != null){
		$("#dd"+brandProductDetail.expseq).empty();
		$("#dd"+brandProductDetail.expseq).addClass("active");
	}
	
		html  ="<section class='programInfoWrap'>";
		html +="	<div class='programInfo'>";
		if(brandProductDetail.content != null && brandProductDetail.content != "" && brandProductDetail.content != undefined){
		html +="		<p>"+brandProductDetail.content+"</p>";
		}
		html +="		<div class='imgExplain div3'>";
		html +="			<div id='appendTourImage'  style='display: -webkit-box'></div>";
		html +="		</div>";
		html +="	</div>";
		html +="	<table class='roomInfoDetail'>";
		html +="		<colgroup>";
		html +="			<col style='width:20%'>";
		html +="			<col style='width:auto'>";
		html +="			<col style='width:20%'>";
		html +="			<col style='width:auto'>";
		html +="		</colgroup>";
		html +="		<tbody><tr>";
		html +="			<td class='title'><span class='icon1'>정원</span></td>";
		if(brandProductDetail.seatcount != undefined && brandProductDetail.seatcount != "" && brandProductDetail.seatcount !=  null){
		html +="			<td>"+brandProductDetail.seatcount+"</td>";
		}
		html +="			<td class='title'><span class='icon2'>체험시간</span></td>";
		if((brandProductDetail.usetime != null && brandProductDetail.usetime != undefined && brandProductDetail.usetime != "") && (brandProductDetail.usetimenote != null && brandProductDetail.usetimenote != undefined && brandProductDetail.usetimenote != "")){
			html +="		<td>"+brandProductDetail.usetime+"<br/>("+brandProductDetail.usetimenote+")</td>";
		}else{
			if(brandProductDetail.usetime != null && brandProductDetail.usetime != undefined && brandProductDetail.usetime != ""){
				html +="	<td>"+brandProductDetail.usetime+"</td>";
			}else{
				html +="	<td>"+brandProductDetail.usetimenote+"</td>";
			}
		}
		html +="		</tr>";
		html +="		<tr>";
		html +="			<td class='title'><span class='icon3'>예약자격</span></td>";
		html +="			<td>"+brandProductDetail.role+"<br><span class='normal'>"+brandProductDetail.rolenote+"</span></td>";
		html +="			<td class='title'><span class='icon5'>준비물</span></td>";
		if(brandProductDetail.preparation != "" && brandProductDetail.preparation != null && brandProductDetail.preparation != undefined){
		html +="			<td>"+brandProductDetail.preparation+"</td>";
		}else{
		html +="			<td></td>";
		}
		html +="		</tr>";
		html +="	</tbody></table>";
		html +="</section>";
	
	
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
			$("#appendTourImage").empty();
			$("#appendTourImage").append("-");
			
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
					html  = "<div class='first'>";
					html += "	<div class='img'><img src='/reservation/imageView.do?file="+imageFileKeyList[0].storefilename+"&mode=RESERVATION' title='"+imageFileKeyList[0].altdesc+"' style='width: 147px;height: 108px;' alt=''></div>";
					html += "	<strong>"+brandProductDetail.time1+"</strong>";
					html += "	<div class='figure'>"+brandProductDetail.note1+"</div>";
					html += "</div>";
					
				} else if(imageFileKeyList.length == 2){
					html  = "<div class='first'>";
					html += "	<div class='img'><img src='/reservation/imageView.do?file="+imageFileKeyList[0].storefilename+"&mode=RESERVATION' title='"+imageFileKeyList[0].altdesc+"' style='width: 147px;height: 108px;' alt=''></div>";
					html += "	<strong>"+brandProductDetail.time1+"</strong>";
					html += "	<div class='figure'>"+brandProductDetail.note1+"</div>";
					html += "</div>";
					
					html  = "<div>";
					html += "	<div class='img'><img src='/reservation/imageView.do?file="+imageFileKeyList[1].storefilename+"&mode=RESERVATION' title='"+imageFileKeyList[1].altdesc+"' style='width: 147px;height: 108px;' alt=''></div>";
					html += "	<strong>"+brandProductDetail.time2+"</strong>";
					html += "	<div class='figure'>"+brandProductDetail.note2+"</div>";
					html += "</div>";
					
					
				}else if(imageFileKeyList.length == 3){
					html  = "<div class='first'>";
					html += "	<div class='img'><img src='/reservation/imageView.do?file="+imageFileKeyList[0].storefilename+"&mode=RESERVATION' title='"+imageFileKeyList[0].altdesc+"' style='width: 147px;height: 108px;' alt=''></div>";
					html += "	<strong>"+brandProductDetail.time1+"</strong>";
					html += "	<div class='figure'>"+brandProductDetail.note1+"</div>";
					html += "</div>";
					
					html  = "<div>";
					html += "	<div class='img'><img src='/reservation/imageView.do?file="+imageFileKeyList[1].storefilename+"&mode=RESERVATION' title='"+imageFileKeyList[1].altdesc+"' style='width: 147px;height: 108px;' alt=''></div>";
					html += "	<strong>"+brandProductDetail.time2+"</strong>";
					html += "	<div class='figure'>"+brandProductDetail.note2+"</div>";
					html += "</div>";
					
					html  = "<div>";
					html += "	<div class='img'><img src='/reservation/imageView.do?file="+imageFileKeyList[2].storefilename+"&mode=RESERVATION' title='"+imageFileKeyList[2].altdesc+"' style='width: 147px;height: 108px;' alt=''></div>";
					html += "	<strong>"+brandProductDetail.time3+"</strong>";
					html += "	<div class='figure'>"+brandProductDetail.note3+"</div>";
					html += "</div>";
					
				}
				
				$("#appendTourImage").append(html);
			}
		},
		error: function( jqXHR, textStatus, errorThrown) {
			var mag = '<spring:message code="errors.load"/>';
			alert(mag);
		}
	});
}

function setBrandJointDatil(brandProductDetail){
// 	console.log(brandProductDetail);
// 	console.log(brandProductDetail.usetimenote.length);
	var html = "";
	if(brandProductDetail.expseq != null){
		$("#dd"+brandProductDetail.expseq).empty();
		$("#dd"+brandProductDetail.expseq).addClass("active");
	}
	
// 	for(var i = 0; i < brandProductDetail.length; i++){
		html  ="<section class='programInfoWrap'>";
		html +="	<div class='programInfo'>";
		if( brandProductDetail.intro != undefined && brandProductDetail.intro != null && brandProductDetail.intro != ""){
		html +="		<p>"+brandProductDetail.content+"</p>";
		}
		html +="		<div class='imgExplain div3'>";
		html +="			<div class='first'>";
		html +="				<div class='img'><img src='/_ui/desktop/images/academy/@img_program_08.gif' alt=''></div>";
		html +="				<strong>날짜선택</strong>";
		html +="				<div class='figure'>맞춤식 체험을 원하시는 날짜를 선택해 주세요.</div>";
		html +="			</div>";
		html +="			<div>";
		html +="				<div class='img'><img src='/_ui/desktop/images/academy/@img_program_09.gif' alt=''></div>";
		html +="				<strong>전화상담</strong>";
		html +="				<div class='figure'>ABC 직원이 전화로 상담해 드립니다.</div>";
		html +="			</div>";
		html +="			<div>";
		html +="				<div class='img'><img src='/_ui/desktop/images/academy/@img_program_10.gif' alt=''></div>";
		html +="				<strong>시간&amp;체험 컨텐츠 결정</strong>";
		html +="				<div class='figure'>원하시는 시간과 원하시는 체험 컨텐츠를 결정합니다.</div>";
		html +="			</div>";
		html +="		</div>";
		html +="	</div>";
		html +="	<table class='roomInfoDetail'>";
		html +="		<colgroup>";
		html +="			<col style='width:20%'>";
		html +="			<col style='width:auto'>";
		html +="			<col style='width:20%'>";
		html +="			<col style='width:auto'>";
		html +="		</colgroup>";
		html +="		<tbody><tr>";
		html +="			<td class='title'><span class='icon1'>정원</span></td>";
		if(brandProductDetail.seatcount != undefined && brandProductDetail.seatcount != "" && brandProductDetail.seatcount !=  null){
		html +="			<td>"+brandProductDetail.seatcount+"</td>";
		}
		html +="			<td class='title'><span class='icon2'>체험시간</span></td>";
		if((brandProductDetail.usetime != undefined && brandProductDetail.usetime != null && brandProductDetail.usetime != "") && (brandProductDetail.usetimenote != undefined && brandProductDetail.usetimenote != null && brandProductDetail.usetimenote != "")){
			html +="		<td>"+brandProductDetail.usetime+"<br/>("+brandProductDetail.usetimenote+")</td>";
		}else{
			if(brandProductDetail.usetimenote != undefined && brandProductDetail.usetimenote != null && brandProductDetail.usetimenote != ""){
				html +="	<td>"+brandProductDetail.usetimenote+"</td>";
			}else{
				html +="	<td>"+brandProductDetail.usetime+"</td>";
			}
		}
// 		html +="			<td>"+brandProductDetail.usetime+"</td>";
		html +="		</tr>";
		html +="		<tr>";
		html +="			<td class='title'><span class='icon3'>예약자격</span></td>";
		if((brandProductDetail.role != null && brandProductDetail.role != undefined && brandProductDetail.role != "")&&(brandProductDetail.rolenote != null && brandProductDetail.rolenote != undefined && brandProductDetail.rolenote != "")){
		html +="			<td>"+brandProductDetail.role+"<br><span class='normal'>"+brandProductDetail.rolenote+"</span></td>";
		}else{
			if(brandProductDetail.role != null && brandProductDetail.role != undefined && brandProductDetail.role != ""){
				html +="	<td>"+brandProductDetail.role+"</td>";
			}else{
				html +="	<td>"+brandProductDetail.rolenote+"</td>";
			}
		}
// 		html +="			<td>"+brandProductDetail.rolenote+"</td>";
		html +="			<td class='title'><span class='icon5'>준비물</span></td>";
		if(brandProductDetail.preparation != "" && brandProductDetail.preparation != null && brandProductDetail.preparation != undefined){
		html +="			<td>"+brandProductDetail.preparation+"</td>";
		}else{
		html +="			<td></td>";
		}
		html +="		</tr>";
		html +="	</tbody></table>";
		html +="</section>";
// 	}
	
	
	
	$("#dd"+brandProductDetail.expseq).append(html);
}

function setProductList(flag, categorytype3, obj){
	if(flag == "C"){
		
		$("#categorytype3").val(categorytype3);
		
		/** 테두리 활성화 */
	 	$("#appendBradnCategory").find("span").each(function(){
	 		$(this).children().removeClass("active")
			$(obj).addClass("active");
		});
		$("#appendBradnCategory").find("dl").each(function(){
			
			
			if($(this).is("dl") === true){
				$(this).remove();
			}
		});
		
		$("#expseq").val("");
	}
	var param = {
		  categorytype3 : $("#categorytype3").val()
		, categorytype2 : $("#categorytype2").val()
		, ppseq : $("#ppseq").val()
	}
	
	$.ajax({
		url: "<c:url value="/reservation/searchBrandProductListAjax.do"/>"
		, type : "POST"
		, async : false
		, data: param
		, success: function(data, textStatus, jqXHR){
			var brandProductList = data.searchBrandProductList;
			var html="";
			
			/* 카테고리 3이 있을경우 카테고리 3이름 셋팅 */
			if(brandProductList[0].categorytype3name != "N"){
				html = "<h4 class='hide'>"+brandProductList[0].categorytype3name+"</h4>";	
			}else{
				/* 카테리고 3이 없을경우 카테고리 2가 이름으로 셋팅 */
				$("#appendBradnCategory").children().remove();
				html = "<h4 class='hide'>"+brandProductList[0].categorytype2name+"</h4>";	
				html += "<h3 class='pdNone2'><img src='/_ui/desktop/images/academy/h3_w020500290.gif' alt='프로그램 선택'></h3>";	
			}
			html += "<dl class='programList prgSection active' id='barnadContents01'>";
			
			/* 프로그램 이름 셋팅 */
			for(var i = 0; i < brandProductList.length; i++){
				if(brandProductList[i].expseq == $("#expseq").val()){
					
					html += "<dt class='active'><a href='javascript:void(0);'  onclick =\"javascript:setProgramChoice('C', "+brandProductList[i].expseq+", this);\">"+brandProductList[i].productname;
					html += "<span' class='btn'>상세보기</span></dt>";
					html += "<dd id='dd"+brandProductList[i].expseq+"'></dd>";
				}else{
					html += "<dt><a href='javascript:void(0);'  onclick=\"javascript:setProgramChoice('C', "+brandProductList[i].expseq+", this);\">"+brandProductList[i].productname;
					html += "<span' class='btn'>상세보기</span></dt>";
					html += "<dd id='dd"+brandProductList[i].expseq+"'></dd>";
					
					
				}
				
			}
			html += "</dl>";
			$("#appendBradnCategory").append(html);
			
		},
		error: function( jqXHR, textStatus, errorThrown) {
			var mag = '<spring:message code="errors.load"/>';
			alert(mag);
		}
	});
	
	if(flag == "F"){
		setProgramChoice('F', '', this);
	}
}
</script>
</head>
<body>
<form id="expInfoForm" name="expInfoForm" method="post">
	<input type="hidden" id="categorytype3" name="categorytype3" value="${reqData.categorytype3}">
	<input type="hidden" id="categorytype2" name="categorytype2" value="${reqData.categorytype2}">
	<input type="hidden" id="expseq" name="expseq" value="${reqData.popExpseq}">
	<input type="hidden" id="ppseq" name="ppseq" value="${reqData.popPpseq}">
	<input type="hidden" id="popFlag" name="popFlag" value="${reqData.popFlag}">
	<input type="hidden" id="typeseq" name="typeseq" value="${reqData.popTypeseq}">
</form>
<div id="pbPopWrap">
	<header id="pbPopHeader">
		<h1><img src="/_ui/desktop/images/academy/h1_w020500250.gif" alt="브랜드체험 소개"></h1>
	</header>
	<a href="javascript:self.close();" class="btnPopClose"><img src="/_ui/desktop/images/common/btn_close.gif" alt="팝업창 닫힘"></a>
	<section id="pbPopContent">
		<div class="programWrap">
			<!-- @edit 20160707 전반적인 수정 -->
			<div class="hWrap">
				<h3 class="mgNone pdNone2"><img src="/_ui/desktop/images/academy/h3_w020500250_01.gif" alt="브랜드 카테고리 선택"></h3>
			</div>
			<div class="brselectArea mgtM">
				<c:forEach var="item" items="${brandCategoryType2}">
					<a href="javascript:void(0);" ${item.categorytype2 == reqData.categorytype2 ? "class='on'" : ""} onclick="javascript:setCategorytype3('C', '${item.categorytype2}');">${item.categorytype2name}</a>
				</c:forEach>
			</div>
			<div class=""  id="appendBradnCategory" style="display: block;">

				
			</div>
			
			
		</div>
		
		<div class="btnWrapC">
			<input type="button" class="btnBasicGL" value="닫기">
		</div>
	
	</section>
</div>
<!-- //content area | ### academy IFRAME End ### -->
<%@ include file="/WEB-INF/jsp/framework/include/footer.jsp" %>