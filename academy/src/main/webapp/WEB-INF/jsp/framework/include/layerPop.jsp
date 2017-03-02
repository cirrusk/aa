<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<script type="text/javascript">
	var openLayerPopup = function(options){
		// 하나로 통일
		var targetId = "acdemyLayerPop";
		
		var default_value =  {	
			targetId : "acdemyLayerPop"
			, width : 850
			, height : 600
			, maxHeight : 600
			, callback : false
			, params : ""
			, level : "1"
		};
		
		var opts = $.extend({}, default_value, options);
		
		opts.width = parseFloat(opts.width);
		opts.height = parseFloat(opts.height);
		opts.height = opts.height > opts.maxHeight ? opts.maxHeight : opts.height;
			
		var xindex = "10001";
		
		// modal
		var parentDoc = $(document).find('body');
		parentDoc.append('<div class="layerMask" id="layerMask" style="display:block;"></div>');
		
		// 기존 Layer 삭제
		$("#" + targetId).remove();
		$(document).find("body").append('<div id="' + targetId + '" tabindex="0"></div>');
		
		// Layer 레이아웃
		var obj = $(document).find('#'+ targetId);
		
		$.ajax({
			url: opts.url,
			type:'post',
			data : opts.params,
			success: function(data){
				// 열린 Ifrm ID 설정
				obj.html(data);
				$(window).scrollTop();
				setTimeout(function(){ $("#uiLayerPop_w02" ).attr("tabindex","0").focus(); }, 500);
				// 닫기 버튼 이벤트
				$(".btnPopClose").on("click", function(){
					$('#layerMask').remove();
					$('#acdemyLayerPop').remove();
				});
			},
			error: function(xhr,status,error){
				$('#layerMask').remove();
				$('#acdemyLayerPop').remove();
				alert("code:"+xhr.status);
			}
		});	
	};
	
</script>

