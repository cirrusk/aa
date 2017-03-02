if(typeof window.nhn=='undefined') window.nhn = {};
if (!nhn.husky) nhn.husky = {};

/**
 * @fileOverview This file contains application creation helper function, which would load up an HTML(Skin) file and then execute a specified create function.
 * @name HuskyEZCreator.js
 */
nhn.husky.EZCreator = new (function(){
	this.nBlockerCount = 0;

	this.createInIFrame = function(htOptions){
		if(arguments.length == 1){
			var oAppRef = htOptions.oAppRef;
			var elPlaceHolder = htOptions.elPlaceHolder;
			var sSkinURI = htOptions.sSkinURI;
			var fCreator = htOptions.fCreator;
			var fOnAppLoad = htOptions.fOnAppLoad;
			var bUseBlocker = htOptions.bUseBlocker;
			var htParams = htOptions.htParams || null;
		}else{
			// for backward compatibility only
			var oAppRef = arguments[0];
			var elPlaceHolder = arguments[1];
			var sSkinURI = arguments[2];
			var fCreator = arguments[3];
			var fOnAppLoad = arguments[4];
			var bUseBlocker = arguments[5];
			var htParams = arguments[6];
		}

		if(bUseBlocker) nhn.husky.EZCreator.showBlocker();

		var attachEvent = function(elNode, sEvent, fHandler){
			if(elNode.addEventListener){
				elNode.addEventListener(sEvent, fHandler, false);
			}else{
				elNode.attachEvent("on"+sEvent, fHandler);
			}
		}

		if(!elPlaceHolder){
			alert("Placeholder is required!");
			return;
		}

		if(typeof(elPlaceHolder) != "object")
			elPlaceHolder = document.getElementById(elPlaceHolder);

		var elIFrame, nEditorWidth, nEditorHeight;


		try{
			elIFrame = document.createElement("<IFRAME frameborder=0 scrolling=no>");
		}catch(e){
			elIFrame = document.createElement("IFRAME");
			elIFrame.setAttribute("frameborder", "0");
			elIFrame.setAttribute("scrolling", "no");
		}

		elIFrame.style.width = "1px";
		elIFrame.style.height = "1px";
		elPlaceHolder.parentNode.insertBefore(elIFrame, elPlaceHolder.nextSibling);

		attachEvent(elIFrame, "load", function(){
			fCreator = elIFrame.contentWindow[fCreator] || elIFrame.contentWindow.createSEditor2;

//			top.document.title = ((new Date())-window.STime);
//			window.STime = new Date();

			try{

				nEditorWidth = elIFrame.contentWindow.document.body.scrollWidth || "500px";
				nEditorHeight = elIFrame.contentWindow.document.body.scrollHeight + 12;
				elIFrame.style.width =  "100%";
				elIFrame.style.height = nEditorHeight+ "px";
				elIFrame.contentWindow.document.body.style.margin = "0";
			}catch(e){
				nhn.husky.EZCreator.hideBlocker(true);
				elIFrame.style.border = "5px solid red";
				elIFrame.style.width = "500px";
				elIFrame.style.height = "500px";
				alert("Failed to access "+sSkinURI);
				return;
			}

			var oApp = fCreator(elPlaceHolder, htParams);	// oEditor


			oApp.elPlaceHolder = elPlaceHolder;

			oAppRef[oAppRef.length] = oApp;
			if(!oAppRef.getById) oAppRef.getById = {};

			if(elPlaceHolder.id) oAppRef.getById[elPlaceHolder.id] = oApp;

			oApp.run({fnOnAppReady:fOnAppLoad});

			// jkk88 추가 시작
			var doc = elIFrame.contentWindow.document;
			if (htOptions.photo === true) {
				var $photo = jQuery(doc).find(".husky_seditor_ui_photo_attach");
				var s = jQuery("script");
				var i18n = "";
				s.each(function() {
					var index = this.src.indexOf("/js/lib/jquery.aos.i18n.");
					if (index > -1) {
						i18n = this.src.substring(index);
						return true;
					}
				});
				var domain = "";
				s.each(function() {
					var index = this.src.indexOf("/js/lib/jquery.aos.ui.min.js");
					if (index > -1) {
						domain = this.src.substring(0, index);
						return true;
					}
				});
				var src = [
				    i18n,
		            "/js/jquery/jquery-1.7.2.min.js",
		            "/js/3rdparty/swfupload/swfobject.js",
		            "/js/3rdparty/swfupload/swfupload.js",
					"/js/lib/jquery.aos.min.js",
					"/js/lib/jquery.aos.ui.min.js",
					"/js/lib/jquery.aos.util.min.js",
					"/js/lib/jquery.aos.swfu.min.js"
				];
				for (var i in src) {
					var script = doc.createElement("script");
					script.type = "text/javascript";
					script.src = domain + src[i];
					doc.getElementsByTagName("head")[0].appendChild(script);
				}
				$photo.find("button").hide();
				var $div = jQuery("<div style='padding:3px 5px;'></div>");
				var $element = jQuery("<div id='" + (new Date()).getTime() + "'></div>");
				$element.appendTo($div);
				$div.appendTo($photo);

				setTimeout(function() {
					var win = elIFrame.contentWindow;
					win.jQuery.globalLoadingbar = jQuery.globalLoadingbar;
					win.uploaderDefaultOption = uploaderDefaultOption;
					win.UI.uploader.create(function() {}, // completeCallback
						[{
							"elementId" : $element.attr("id"),
							"postParams" : {},
							"options" : {
								uploadUrl : editorGlobalVariables.uploadUrl,
								buttonImageUrl : editorGlobalVariables.buttonImageUrl,
								buttonWidth: 23,
								inputWidth : 0,	
								fileTypes : "*.jpg;*.gif",
								fileTypesDescription : "Image Files",
								fileSizeLimit : "10 MB",
								immediatelyUpload : true,
								successCallback : function(id, file) {
									var data = [];
									if (file != null) {
										var fileInfo = file.serverData.fileInfo;
										var tempPath = fileInfo.savePath + "/" + fileInfo.saveName;
										var $photoInfo = jQuery("#" + elPlaceHolder.id).siblings(":input[name='editorPhotoInfo']");
										var photos = $photoInfo.val() == "" ? [] : $photoInfo.val().split(","); 
										photos.push(tempPath);
										$photoInfo.val(photos.join(","));
										data.push("<img src='" + editorGlobalVariables.imageContext + tempPath + "'>");
									}
									if (data.length > 0) {
										oApp.exec("PASTE_HTML", data);
									}
								}
							}
						}]
					);
				}, 500);
				
			}
			jQuery(doc).find(".se2_conversion_mode").find(".se2_to_text").closest("li").hide(); // text 모드 안보이게.
			// jkk88 추가 끝

//			top.document.title += ", "+((new Date())-window.STime);
			nhn.husky.EZCreator.hideBlocker();
		});
//		window.STime = new Date();
		elIFrame.src = sSkinURI;
	};

	this.showBlocker = function(){
		if(this.nBlockerCount<1){
			var elBlocker = document.createElement("DIV");
			elBlocker.style.position = "absolute";
			elBlocker.style.top = 0;
			elBlocker.style.left = 0;
			elBlocker.style.backgroundColor = "#FFFFFF";
			elBlocker.style.width = "100%";

			document.body.appendChild(elBlocker);

			nhn.husky.EZCreator.elBlocker = elBlocker;
		}

		nhn.husky.EZCreator.elBlocker.style.height = Math.max(document.body.scrollHeight, document.body.clientHeight)+"px";

		this.nBlockerCount++;
	};

	this.hideBlocker = function(bForce){
		if(!bForce){
			if(--this.nBlockerCount > 0) return;
		}

		this.nBlockerCount = 0;

		if(nhn.husky.EZCreator.elBlocker) nhn.husky.EZCreator.elBlocker.style.display = "none";
	}
})();