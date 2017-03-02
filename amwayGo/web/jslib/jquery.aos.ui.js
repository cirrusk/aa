/**
 * jquery.aos.ui.js
 * author : jkk5246@gmail.com
 * created : 2011.11.17
 */
var _fileinfo_ = {
	version : "3.2.5"
};
var UI = {
	datepicker : function(selector, options, xOptions) {
		var xDefaults = {
			readOnly : false, 
			buttonImage : "",
			onClose : null, 
			clearText : I18N["Aos:Ui:Datepicker:ClearText"], // 지우기
			closeText : I18N["Aos:Ui:Datepicker:CloseText"], // 닫기
			buttonText : I18N["Aos:Ui:Datepicker:ButtonText"], // 달력
			currentText : I18N["Aos:Ui:Datepicker:CurrentText"], // 오늘
			dayNamesMin : [
				I18N["Aos:Ui:Datepicker:DayNamesMin:Sun"], 
				I18N["Aos:Ui:Datepicker:DayNamesMin:Mon"], 
				I18N["Aos:Ui:Datepicker:DayNamesMin:Tue"], 
				I18N["Aos:Ui:Datepicker:DayNamesMin:Wen"], 
				I18N["Aos:Ui:Datepicker:DayNamesMin:Thu"], 
				I18N["Aos:Ui:Datepicker:DayNamesMin:Fri"], 
				I18N["Aos:Ui:Datepicker:DayNamesMin:SAT"]
			], // ["일","월","화","수","목","금","토"]
			monthNamesShort : [
				I18N["Aos:Ui:Datepicker:MonthNamesShort:Jan"],
				I18N["Aos:Ui:Datepicker:MonthNamesShort:Fab"],
				I18N["Aos:Ui:Datepicker:MonthNamesShort:Mar"],
				I18N["Aos:Ui:Datepicker:MonthNamesShort:Apr"],
				I18N["Aos:Ui:Datepicker:MonthNamesShort:May"],
				I18N["Aos:Ui:Datepicker:MonthNamesShort:Jun"],
				I18N["Aos:Ui:Datepicker:MonthNamesShort:Jul"],
				I18N["Aos:Ui:Datepicker:MonthNamesShort:Aug"],
				I18N["Aos:Ui:Datepicker:MonthNamesShort:Sep"],
				I18N["Aos:Ui:Datepicker:MonthNamesShort:Oct"],
				I18N["Aos:Ui:Datepicker:MonthNamesShort:Nov"],
				I18N["Aos:Ui:Datepicker:MonthNamesShort:Dec"]
			] // ["1월","2월","3월","4월","5월","6월","7월","8월","9월","10월","11월","12월"]
		};
		xOptions = jQuery.extend(true, xDefaults, xOptions || {});

		var defaults = {
			changeYear : true,
			changeMonth : true,
			showMonthAfterYear : true,
			buttonImageOnly : true,
			showButtonPanel : true,
			constrainInput : true,
			dateFormat : "yy-mm-dd",
			monthNamesShort : xOptions.monthNamesShort,
			dayNamesMin : xOptions.dayNamesMin,
			showOn : "focus", // focus, button, both
			buttonImage : xOptions.buttonImage,
			buttonText : xOptions.buttonText,
			currentText : xOptions.currentText,
			closeText : xOptions.closeText,
			clearText : xOptions.clearText
		};
		options = jQuery.extend(true, defaults, options || {});
		options.gotoCurrent = false;

		var $datepickerback = jQuery("#datepickerback");
		if ($datepickerback.length == 0) {
			$datepickerback = jQuery("<iframe id='datepickerback'></iframe>");
			$datepickerback.appendTo(self.document.body);
			$datepickerback.css({
				"position"     : "absolute",
				"filter"       : "alpha(opacity=0)",
				"-moz-opacity" : "0",
				"opacity"      : "0",
				"border"       : "none"
			});
			$datepickerback.hide();
		}
		var showDatepickerback = function($datepicker) {
			var $widget = $datepicker.datepicker("widget");
			$datepickerback.css({
				"top"    : $widget.css("top"),
				"left"   : $widget.css("left"),
				"height" : $widget.height() + "px",
				"width"  : $widget.width() + "px"
			});
			$datepickerback.show();
		};
		var showClearButton = function($datepicker, text) {
			var $widget = $datepicker.datepicker("widget");
			var $buttonPane = $widget.find( ".ui-datepicker-buttonpane" );
			if ($buttonPane.find(".customClear").length == 0) {
				var $btn = jQuery('<button class="ui-datepicker-current ui-state-default ui-priority-secondary ui-corner-all customClear">' + options.clearText  + '</button>');      
				$btn.unbind("click").bind("click", function () {   
						jQuery.datepicker._clearDate($datepicker);
			  		}
				);   
				$btn.appendTo($buttonPane);
			}
		};
		var addCustomCss = function($datepicker) {
			var $widget = $datepicker.datepicker("widget");
			$widget.addClass("ui-widget-content-custom");
		}
		var $datepicker = null;
		var pair = typeof selector === "string" ? selector.split(",") : [];
		if (pair.length > 1) {
			options.beforeShow = function(input, inst) {
				var $this = jQuery(this);
				var index = -1;
				for (var i = 0; i < pair.length; i++) {
					if (("#" + $this.attr("id")) == pair[i].trim()) {
						index = i;
					}
				}
				if (index < 0) {
					return;
				}
				if (index - 1 >= 0) {
					var otherDate = jQuery(pair[index - 1].trim()).val();
					var date = jQuery.datepicker.parseDate(options.dateFormat, otherDate, inst.settings);
					$this.datepicker("option", "minDate", date);
				}
				if (index + 1 < pair.length) {
					var otherDate = jQuery(pair[index + 1].trim()).val();
					var date = jQuery.datepicker.parseDate(options.dateFormat, otherDate, inst.settings);
					$this.datepicker("option", "maxDate", date);
				}
				setTimeout(function() {
					showDatepickerback($this);
					showClearButton($this, options.clearText);
					addCustomCss($this);
				}, 1);
			};
			
		} else {
			options.beforeShow = function(input, inst) {
				var $this = jQuery(this);
				setTimeout(function() {
					showDatepickerback($this);
					showClearButton($this, options.clearText);
					addCustomCss($this);
				}, 1);
			};
		}
		options.onChangeMonthYear = function(year, month, inst) {
			var $this = jQuery(this);
			setTimeout(function() {
				showDatepickerback($this);
				showClearButton($this, options.clearText);
				addCustomCss($this);
			}, 1);
		};
		var exceptClick = function() {
			if (jQuery(".swfu-uploader").length > 0) { // ie9 이상일때, 업로더가 있을 때 오류가 발생한다.
				if (jQuery.browser.msie && parseInt(jQuery.browser.version, 10) >= 9) {
					$(document).unbind("mousedown", $.datepicker._checkExternalClick);
				}
			}
		};
		
		if (typeof xOptions.onClose === "function") {
			options.onClose = function(dateText, inst) {
				xOptions.onClose.call(this, jQuery(inst["input"])[0].name);
				$datepickerback.hide();
				exceptClick();
			};
		} else {
			options.onClose = function(dateText, inst) {
				$datepickerback.hide();
				exceptClick();
			};
		}
		
		$datepicker = jQuery(selector).datepicker(options);
		
		if (true == xOptions.readOnly) {
			jQuery(selector).attr("readOnly", true);
		}
		if (options.showOn != "focus") {
			jQuery(".ui-datepicker-trigger").css("cursor", "pointer");
		}
	},
	accordion : function(selector, options, xOptions) {
		var xDefaults = {
			changeCallback : null,	
			changeStartCallback : null	
		};
		xOptions = jQuery.extend(true, xDefaults, xOptions || {});
		var defaults = {
		    collapsible: true,
		    autoHeight : false
		};
		options = jQuery.extend(true, defaults, options || {});
		
		if (typeof xOptions.changeCallback === "function") {
		    options.change = function(event, ui) {
		    	xOptions.changeCallback.call(this, ui.newHeader.attr("id"));				
		    };
		}
		if (typeof xOptions.changeStartCallback === "function") {
			options.changestart = function(event, ui) {
				xOptions.changeStartCallback.call(this, ui.newHeader.attr("id"));				
			};
		}
		jQuery(selector).accordion(options);
	},
	/**
	 * @param arrayParam : [{elementId, postParams, options}] 
	 *                       elementId : uploader를 나타나게할 element의 id
	 *                       postParams : 업로드시 서버로 전송할 parameter
	 *                       options : {}
	 * @param completeCallback : 모든 업로드가 완료 되었을 때 실행될 callback 함수
	 */
	uploader : {
		create : function(completeCallback, arrayParam) {
			var swfu = SWFU.create({
				completeCallback : function() {
					if (typeof completeCallback === "function") {
						completeCallback.call(this);
					}
				},
				progressCallback : function(type, status) {
					var $loadingbar = jQuery.globalLoadingbar();
					switch (type) {
					case "open":
						$loadingbar.show(status, {
								button1 : {
									callback : function() {
										swfu.stopUpload();
									}
								}
							} 
						);
						break;
					case "progress":
						$loadingbar.show(status);
						break;
					case "close":
						$loadingbar.hide();
						break;
					}
				},
				fileLimitType : uploaderDefaultOption.fileLimitType
			});
			if (typeof arrayParam === "object") {
				this.generate(swfu, arrayParam);
			}
			if (jQuery.browser.msie && parseInt(jQuery.browser.version, 10) >= 9) {
				jQuery(window).unload(function() {
					jQuery(".swfu-uploader").empty();
				});
			}
			return swfu;
		},
		generate : function(swfu, arrayParam) {
			var defaultPostParam = {};
			if (typeof Global !== "undefined" && typeof Global.parameters === "string") {
				var params = Global.parameters.split("&");
				for (var x in params) {
					var pair = params[x].split("=");
					if (pair.length == 2) {
						defaultPostParam[pair[0]] = pair[1];
					}
				}
			}
			var defaultOption = {
				deleteIconUrl : uploaderDefaultOption.file.deleteIconUrl,
				buttonImageUrl : uploaderDefaultOption.file.buttonImageUrl,
				buttonWidth : uploaderDefaultOption.file.buttonWidth, 
				buttonHeight : uploaderDefaultOption.file.buttonHeight,
				inputWidth : 350,
				inputHeight : 20,
				inputBorderStyle : "1px solid #cdcdcd",
				inputStyleClass : "",
				fileTypes : "*.*",
				fileTypesDescription : "All Files",
				fileSizeLimit : "10 MB",
				fileUploadLimit : 1,
				immediatelyUpload : false
			};
	
			for (var index in arrayParam) {
				var param = arrayParam[index];
				param.options = jQuery.extend(true, defaultOption, param.options);
				param.postParams = jQuery.extend(true, defaultPostParam, param.postParams);
				
				var id = {
					"upload" : param.elementId + "-upload",
					"input" : param.elementId + "-input",
					"object" : param.elementId + "-object"
				};
				
				var style = {
					upload : [],
					input : [],
					item : [],
					icon : []
				};
				style.upload.push("text-align:left");
				style.upload.push("padding:0px");
				style.upload.push("font-size:12px");
				style.upload.push("line-height:22px");
				style.upload.push("vertical-align:top");
				if (param.options.inputWidth > 0) {
					style.upload.push("width:" + (param.options.inputWidth + param.options.buttonWidth + 13) + "px");
					style.upload.push("height:" + param.options.inputHeight + "px");
	
					style.input.push("display:inline-block");
					style.input.push("vertical-align:top");
					style.input.push("width:" + param.options.inputWidth + "px");
					style.input.push("height:" + param.options.inputHeight + "px");
					style.input.push("border:" + param.options.inputBorderStyle);
				} else {
					style.upload.push("width:" + param.options.buttonWidth + "px");
					style.upload.push("height:" + param.options.buttonHeight + "px");
					
					style.input.push("display:none");
				}
				if (param.options.fileUploadLimit > 1 || param.options.fileUploadLimit == 0) {
					style.input.push("overflow-x:hidden");
					style.input.push("overflow-y:auto");
					if (jQuery.browser.mozilla) { // firefox에서 최소 34px 이상에서 스크롤바가 생긴다.
						style.input.push("min-height:34px;"); 
						style.upload.push("min-height:34px;");
					}
				} else {
					style.input.push("overflow-x:hidden");
					style.input.push("overflow-y:hidden");
				}
				style.input.push("padding:0 3px");
				style.input.push("*float:left");
				style.input.push("*margin-right:3px");
				style.item.push("position:relative");
				style.item.push("padding:3px 0px 3px 15px");
				style.icon.push("position:absolute");
				style.icon.push("left:5px");
				style.icon.push("top:6px");
				style.icon.push("cursor:pointer");
				style.icon.push("line-height:0px");
				
				var html = [];
				html.push("<div id='" + id.upload + "' style='" + style.upload.join(";") + "'>");
				html.push("<div id='" + id.input + "' style='" + style.input.join(";") + "' class='" + param.options.inputStyleClass + "'></div>");
				html.push("<span id='" + id.object + "'></span>");
				html.push("</div>");
				jQuery("#" + param.elementId).addClass("swfu-uploader");
				jQuery(html.join(" ")).appendTo(jQuery("#" + param.elementId));
				
				var $previous = jQuery("#" + param.elementId).find(".previousFile");
				$previous.each(function(){
					var $this = jQuery(this);
					var $input = jQuery("#" + id.input);
					var $item = jQuery("<div style='" + style.item.join(";") + "' class='" + $this.attr("class") + "'>" + $this.html() + "</div>");
					var $icon = jQuery("<img style='" + style.icon.join(";") + "' src='" + param.options.deleteIconUrl + "'>");
					$icon.click(function() {
						eval($this.attr("onclick"));
						swfu.cancelUpload(id.object);
					});
					$icon.appendTo($item);
					$item.appendTo($input);
					$this.remove();
				});
				
				swfu.create(id.object, {
					button_image_url : param.options.buttonImageUrl,
					button_width : param.options.buttonWidth, 
					button_height : param.options.buttonHeight,
					upload_url : param.options.uploadUrl,
					file_types : param.options.fileTypes,
					file_types_description : param.options.fileTypesDescription,
					file_size_limit : param.options.fileSizeLimit,
					file_upload_limit : param.options.fileUploadLimit,
					custom_settings : {
						immediatelyUpload : param.options.immediatelyUpload,
						deleteIconUrl : param.options.deleteIconUrl,
						successCallback : param.options.successCallback,
						previousUploaded : $previous.length,
						uploaded : function(objectInfo, file) {
							var uploadId = objectInfo.id.replace(/-object$/, "");
							if (typeof objectInfo.successCallback === "function") {
								objectInfo.successCallback.call(this, uploadId, file);
							}
						},
						canceled : function(objectInfo) {
							var inputId = objectInfo.id.replace(/-object$/, "-input");
							var $input = jQuery("#" + inputId);
							$input.find("img").trigger("click");
						},
						selected : function(objectInfo, file) {
							if (typeof file === "object") {
								var inputId = objectInfo.id.replace(/-object$/, "-input");
								var $input = jQuery("#" + inputId);
		
								var $item = jQuery("<div style='" + style.item.join(";") + "'>" + file.name + "(" + UT.getFilesize(file.size) + ")</div>");
								var $icon = jQuery("<img style='" + style.icon.join(";") + "' src='" + objectInfo.deleteIconUrl + "'>");
								$icon.appendTo($item);
	
								$icon.click(function() {
									$icon.closest("div").remove();
									swfu.cancelUpload(objectInfo.id, file.id);
								});
								$item.appendTo($input);
							}
						}
					},
					post_params : param.postParams
				});
			}
			return swfu;
		},
		getUploadedData : function(swfu, elementId) {
			var uploadInfo = [];
			var data = swfu.getUploadedData(elementId + "-object");
			for (var index in data) {
				uploadInfo.push(data[index].fileInfo.attachUploadInfo);
			}
			return uploadInfo.join(",");
		},
		isAppendedFiles : function(swfu, elementId) {
			return swfu.isAppendedFiles(elementId + "-object");
		},
		runUpload : function(swfu, elementId) {
			swfu.runUpload(typeof elementId === "string" ? elementId + "-object" : elementId);
		},
		cancelUpload : function(swfu, elementId) {
			var $input = jQuery("#" + elementId + "-input");
			$input.find("img").trigger("click");
		},
		removeUpload : function(swfu, elementId) {
			jQuery("#" + elementId).empty();
			swfu.removeUpload(typeof elementId === "string" ? elementId + "-object" : elementId);
		},
		previousUploaded : function(swfu, elementId, count) {
			swfu.previousUploaded(typeof elementId === "string" ? elementId + "-object" : elementId, count);
		},
		setPostParams : function(swfu, elementId, addParams, removeParamNames) {
			swfu.setPostParams(typeof elementId === "string" ? elementId + "-object" : elementId, addParams, removeParamNames);
		}
	},
	editor : {
		smartEditors : [],
		create : function(elementId, options) {
			options = $.extend(true, {
				photo : true,
				startMode : "WYSIWYG"
			}, options);
			
			this.smartEditors.push(elementId);
			nhn.husky.EZCreator.createInIFrame({
				oAppRef : UI.editor.smartEditors,
				elPlaceHolder: elementId,
				sSkinURI: editorGlobalVariables.skin,
				fCreator: "createSEditor2",
				htParams : {
					SE_EditingAreaManager : {
						sDefaultEditingMode : options.startMode
					},
					fOnBeforeUnload : function() {} 
				},
				photo : options.photo 
			});
		},
		clearValue : function(elementId) {
			if (typeof this.smartEditors.getById === "object") {
				var element = this.smartEditors.getById[elementId];
				element.exec("SET_IR", [""]); 
			}
		},
		copyValue : function(fieldYn) {
			var htmlYn = "htmlYn";
			if (typeof fieldYn === "string") {
				htmlYn = fieldYn;
			}
			for (var elementId in this.smartEditors.getById) {
				var element = this.smartEditors.getById[elementId];
				if (typeof element === "object") {
					element.exec("UPDATE_CONTENTS_FIELD", []);
					var $element = jQuery("#" + elementId);
					$element.siblings(":input[name='" + htmlYn + "']").val(element.getEditingMode() == "TEXT" ? "N" : "Y");
					if ($element.val().startsWith("<br>")) {
						$element.val($element.val().substring(4));
					}
				}
			}
		},
		getEditingMode : function(elementId) {
			return this.smartEditors.getById[elementId].getEditingMode();
		}
	},
	tabs : function(selector) {
		return jQuery(selector).tabs({
			create : function(event, ui) {
				jQuery(this).css({border : "none", width : "100%"});
			}
		});
	},
	button : function() {
		jQuery(".button-delete").button({icons : {primary : "ui-icon-circle-close"}});
		jQuery(".button-create").button({icons : {secondary : "ui-icon-circle-plus"}});
		jQuery(".button-edit").button({icons : {secondary : "ui-icon-gear"}});
		jQuery(".button-save").button({icons : {secondary : "ui-icon-disk"}});
		jQuery(".button-cancel").button({icons : {secondary : "ui-icon-circle-arrow-w"}});
		jQuery(".button-list").button({icons : {secondary : "ui-icon-circle-arrow-w"}});
		jQuery(".button-browse").button({icons : {primary : "ui-icon-search"}});
		jQuery(".button-search").button({icons : {primary : "ui-icon-circle-check"}});
		jQuery(".button-reset").button({icons : {primary : "ui-icon-circle-minus"}});
	},
	effectTransfer : function(targetElementId, toElementId, transferClassName, callback) {
		var options = { to: "#" + toElementId, className: transferClassName};
		jQuery("#" + targetElementId).effect("transfer", options, 500, callback);
	},
	originalOfThumbnail : function(className) {
		var $img = jQuery("img");
		if (typeof className === "string") {
			$img = $img.filter("." + className);
		} else {
			$img = $img.filter("[src$='.thumb.jpg']");
		}
		$img.unbind("click");
		$img.bind("click", function() {
			var $this = jQuery(this);
			var srcThumb = $this.attr("src");
			var srcOrigin = srcThumb.replace(".thumb.jpg", "");
			var $img = jQuery("<img src='" + srcOrigin + "'>");
			$img.error(function() {
				this.src = srcThumb;
			});

			setTimeout(function() {
				var $dialog = jQuery.info({
					autoOpen : false,
					closeOnEscape : true, 
					modal : true,
					width : 10,
					height : 10,
					sizeAdjust : false,
					message : ""
				});
				var $widget = $dialog.dialog("widget");
				$widget.find(".ui-dialog-titlebar").hide();
				var $content = $widget.find(".ui-dialog-content");
				$content.css({"overflow" : "hidden"});
				var $p = $content.find("p:first");
				$p.css({left : "0px", top : "0px", "marginTop" : "0px", "overflow" : "hidden", "width" : "auto"});
				$img.appendTo($p);
				$img.click(function() {
					$dialog.dialog("close");
				});
				$img.css({
					maxWidth : "800px",
					maxHeight : "800px"
				});
				$dialog.dialog("open");

				var size = {
					"width" : $img.width(),
					"height" : $img.height()
				};
				$dialog.dialog("option", size);
				$dialog.dialog("option", "position", "center");
				$widget.css(size);
			}, 100);
		}).css("cursor", "pointer");
	},
	/**
	 * input 영역에 도움말 표시하기
	 */
	inputComment : function(container, commentClassName) {
		var $container = null; 
		if (typeof container === "string") {
			$container = jQuery("#" + container);
		} else {
			$container = jQuery(container);
		}
		$container.find("input[type='text'],textarea,input[type='password']").each(function() {
			var $this = jQuery(this);

			commentClassName = commentClassName || "comment";
			var $comment = $this.siblings("." + commentClassName);
			if ($comment.length == 0) {
				return true; // continue
			}
			$this.attr("title", $comment.text());
			
			var $wrap = jQuery("<div></div>");
			$wrap.css({
				position : "relative",
				display : "inline-block"
			});
			if (jQuery.browser.msie && parseInt(jQuery.browser.version, 10) < 8) { // ie7
				$wrap.css({
					"*display" : "inline",
					"*zoom": "1"
				});
			}			
			$wrap.insertAfter($this);
			$this.appendTo($wrap);
			$comment.appendTo($wrap);

			var zIndex = $this.css("zIndex") == "auto" ? 0 : parseInt($this.css("zIndex"), 10);
			
			$comment.css({
				"position" : "absolute",
				"left" : "0px",
				"top" : "0px",
				"zIndex" : (zIndex + 1),
				"paddingTop" : (parseInt($this.css("paddingTop"), 10) + 1) + "px", 
				"paddingBottom" : $this.css("paddingBottom"), 
				"paddingLeft" : $this.css("paddingLeft"), 
				"paddingRight" : $this.css("paddingRight"), 
				"lineHeight" : $this.css("lineHeight"),
				"fontSize" : $this.css("fontSize"),
				"width" : $this.width(),
				"height" : $this.height(),
				"backgroundColor" : "transparent",
				"border" : "none",
				"display" : "none"
			});
			if (jQuery.browser.mozilla) {
				$comment.css({
					"paddingTop" : (parseInt($comment.css("paddingTop"), 10) + 2) + "px"
				});
			}
			$comment.click(function() {
				$this.trigger("focus");
			});
			$this.focus(function() {
				$comment.hide();
			});
			$this.blur(function() {
				if ($this.val().replace(/^\s*|\s*$/g, "").length == 0) {
					$comment.show();
				} else {
					$comment.hide();
				}
			});
			$this.trigger("blur");
		});
	},
	/**
	 * 달력
	 */
	calendar : {
		create : function(elementId, options) {
			var defaultOptions = {
				header: {
					left: "prev,next today", // 이전년도(prevYear), 이전달,주,일(prev), 다음달,주,일(next), 다음년도(nextYear), 오늘
					center: "title",
					right: "month,basicWeek,agendaDay" 
				},
				dayNamesShort : [
					I18N["Aos:Ui:Calendar:DayNamesShort:Sun"],
					I18N["Aos:Ui:Calendar:DayNamesShort:Mon"],
					I18N["Aos:Ui:Calendar:DayNamesShort:Tue"],
					I18N["Aos:Ui:Calendar:DayNamesShort:Wen"],
					I18N["Aos:Ui:Calendar:DayNamesShort:Thu"],
					I18N["Aos:Ui:Calendar:DayNamesShort:Fri"],
					I18N["Aos:Ui:Calendar:DayNamesShort:SAT"]
				], //["일", "월", "화", "수", "목", "금", "토"],
				dayNames : [
					I18N["Aos:Ui:Calendar:DayNames:Sun"],
					I18N["Aos:Ui:Calendar:DayNames:Mon"],
					I18N["Aos:Ui:Calendar:DayNames:Tue"],
					I18N["Aos:Ui:Calendar:DayNames:Wen"],
					I18N["Aos:Ui:Calendar:DayNames:Thu"],
					I18N["Aos:Ui:Calendar:DayNames:Fri"],
					I18N["Aos:Ui:Calendar:DayNames:SAT"]
				], // ["일요일", "월요일", "화요일", "수요일", "목요일", "금요일", "토요일"],
				monthNamesShort : ["1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12"],
				monthNames : [
					I18N["Aos:Ui:Calendar:MonthNames:Jan"],
					I18N["Aos:Ui:Calendar:MonthNames:Fab"],
					I18N["Aos:Ui:Calendar:MonthNames:Mar"],
					I18N["Aos:Ui:Calendar:MonthNames:Apr"],
					I18N["Aos:Ui:Calendar:MonthNames:May"],
					I18N["Aos:Ui:Calendar:MonthNames:Jun"],
					I18N["Aos:Ui:Calendar:MonthNames:Jul"],
					I18N["Aos:Ui:Calendar:MonthNames:Aug"],
					I18N["Aos:Ui:Calendar:MonthNames:Sep"],
					I18N["Aos:Ui:Calendar:MonthNames:Oct"],
					I18N["Aos:Ui:Calendar:MonthNames:Nov"],
					I18N["Aos:Ui:Calendar:MonthNames:Dec"]
				], // ["1월", "2월", "3월", "4월", "5월", "6월", "7월", "8월", "9월", "10월", "11월", "12월"],
				buttonText : {
					month : I18N["Aos:Ui:Calendar:buttonText:Month"], // 월별
					week : I18N["Aos:Ui:Calendar:buttonText:Week"], // 주별 
					day : I18N["Aos:Ui:Calendar:buttonText:Day"], // 일별
					today : I18N["Aos:Ui:Calendar:buttonText:Today"] //오늘
				},
				titleFormat : {
					month : "yyyy년 MMMM", 
					week : "yyyy년 MMMM d" + I18N["Aos:Ui:Calendar:Text:Day"] + " ~ {[yyyy" + I18N["Aos:Ui:Calendar:Text:Year"] + "] [MMMM] d" + I18N["Aos:Ui:Calendar:Text:Day"] + "}", // 일, 년, 일
					day : "yyyy년 MMMM d" + I18N["Aos:Ui:Calendar:Text:Day"] + ", dddd" // 일
				},
				columnFormat : {
					month : "dddd",
					week : "MMM/d ddd",
					day : "MMM/d, ddd"
				},
				timeFormat : {
					agenda : "H:mm{-H:mm}",
					"" : "H:mm-{H:mm}"
				},
				axisFormat : "H:mm",
				allDayText : I18N["Aos:Ui:Calendar:Text:AllDay"], // 종일일정,
				slotMinutes : 30,
				selectable: false,
				selectHelper: false,
				unselectAuto : true, // 페이지의 아무곳이나 클릭하면 현재 선택(selelct)되어진 것이 unselect된다.
				editable: false,
				select: function(startDate, endDate, allDay, jsEvent, view) { 
					// selectable 이 true 일때 날짜가 선택되면 호출된다.
					// alert("select\n" + startDate +"/"+ endDate+"/"+ allDay+"/"+ jsEvent+"/"+ view)
				},
				unselect: function(view, jsEvent) { 
					// selectable 이 true 일때 날짜가 선택이 해제되면 호출된다.
					// alert("unselect\n" + view + "/" + jsEvent)
				},
				dayRender : function(date, cell) {
					// 날짜 cell 이 그려지면 호출된다.
					// alert("dayRender\n" + date + "/" + cell)
				},
				viewDisplay: function(view) {
					// 달력이 다 그려지면 호출된다.
					// alert("viewDisplay\n" + view)
			    },
				dayClick: function(date, allDay, jsEvent, view) {
					// 날짜를 클릭하면 호출된다. select 보다 먼저 호출된다.
					// alert("day click\n" + date + "/" + allDay + "/" + jsEvent + "/" + view)
			    },
				eventDrop : function(event, dayDelta, minuteDelta, allDay, revertFunc, jsEvent, ui, view) {
					// event를 다른 날짜로 drag & drop 했을때 호출된다.
					// alert("event drop\n" + event + "/" + dayDelta + "/" + minuteDelta + "/" + allDay + "/" + revertFunc + "/" + jsEvent + "/" + ui + "/" + view)
				},
				eventClick : function(event, jsEvent, view) {
					// 일정을 크릭하면 호출된다.
					// alert("event click\n" + event + "/" + jsEvent + "/" + view)
				},
				eventResize : function(event, dayDelta, minuteDelta, revertFunc, jsEvent, ui, view) {
					// 일정의 크기를 바꾸면 호출된다.
					// alert("event resize\n" + event + "/" + dayDelta + "/" + minuteDelta + "/" + revertFunc + "/" + jsEvent + "/" + ui + "/" + view)
				}
				
			};
			options = $.extend(true, defaultOptions, options);
			return $("#" + elementId).fullCalendar(options);
		},
		addEvent : function(calendar, arrayEvent) {
			if (calendar != null) {
				calendar.fullCalendar("addEventSource", {
					events : arrayEvent
				});
			}
		},
		removeEvent : function(calendar, eventId) { // eventId가 없으면 모두 지운다.
			if (calendar != null) {
				calendar.fullCalendar("removeEvents", eventId);
			}
		},
		destroy : function(calendar) {
			if (calendar != null) {
				calendar.fullCalendar("destroy");
			}
		},
		gotoDate : function(calendar, year, month, date) {
			if (calendar != null) {
				calendar.fullCalendar("gotoDate", year, month, date);
			}
		},
		get : function(calendar, data) {
			if (calendar != null) {
				return calendar.fullCalendar(data);
			} else {
				return null;
			}
		}
	},
	/**
	 * 자동완성byEnter
	 * css 필요 .aos-auto .aos-auto-combo 
	 */
	autoCompleteByEnter : function(element, sourceCallback, selectCallback) {
		var $element = jQuery(element);
		var $parent = $element.closest(".aos-auto");
		if ($parent.length == 0) {
			$parent = jQuery("<div class='aos-auto'></div>");
			$parent.insertBefore($element);
			$element.appendTo($parent);
			$parent.css({
				position : "relative",
				display : "inline-block"
			});
			if (jQuery.browser.msie && parseInt(jQuery.browser.version, 10) < 8) { // ie7
				$parent.css({
					"*display" : "inline",
					"*zoom": "1"
				});
			}
		}
		var $combo = $element.siblings(".aos-auto-combo");
		if ($combo.length == 0) {
			$combo = jQuery("<div class='aos-auto-combo'></div>");
			$combo.insertAfter($element);
		}
		var posTop = $element.height() + $element.css("paddingTop") + $element.css("paddingBottom");
		if (jQuery.browser.msie && parseInt(jQuery.browser.version, 10) <= 7) {
			posTop = $element.outerHeight();
		}
		$combo.css({
			width : $element.width() + "px",
			overflowX : "hidden",
			overflowY : "auto",
			position : "absolute",
			left : "0px",
			top : posTop + "px"
		}).hide();
		var timer = null;
		$element.blur(function() {
			clearInterval(timer);
		});
		$element.focus(function() {
			clearInterval(timer);
			var prevValue = element.value;
			timer = setInterval(function() {
				if (prevValue != element.value) {
					if (typeof selectCallback === "function") {
						selectCallback(null);
						clearInterval(timer);
					}
				}
			}, 100);
		});
		$element.keypress(function(event) {
			if (event.keyCode === 13 && $element.val().trim().length > 0) {
				$combo.empty().hide();
				if (typeof sourceCallback === "function") {
					sourceCallback.call(this, function(data) {
						if (data != null && data.length && data.length > 0) {
							for (var i = 0; i < data.length; i++) {
								var prop = [];
								for (var p in data[i]) {
									prop.push(p);
								}
								var html = [];
								html.push("<div class='item'><a href='javascript:void(0)' ");
								for (var idx in prop) {
									html.push(prop[idx] + "='" + data[i][prop[idx]] + "'");
								}
								html.push(">" + data[i].label + "</a></div>");
								var $item = jQuery(html.join(" "));
								$item.appendTo($combo);
								$item.find("a").click(function() {
									var $this = jQuery(this);
									if (typeof selectCallback === "function") {
										var selected = {};
										for (var idx in prop) {
											selected[prop[idx]] = $this.attr(prop[idx]);
										}
										selectCallback(selected);
										$combo.hide();
									}
								});
							}
							$combo.css({
								height : (Math.min(5, data.length) * $element.height()) + "px"
							}).show();
							jQuery(document.body).one("click", function() {
								$combo.hide();
							});
						}
					}, $element.val());
				}
			}
		});
	},

	/**
	 * 코드 에디터 codemirror 4.3 버전 사용.
	 */
	codeMirror : function(textareaId, options) {
		var defaultOption = {
			mode : "htmlmixed", // "javascript", "application/xml", "text/html"
			theme : "eclipse",
			lineNumbers : true,
			styleActiveLine : true,
			matchBrackets : true,
			indentUnit : 4,
			tabSize : 4,
			indentWithTabs : true,
			smartIndent : false
		};
		options = options || {};
		options = jQuery.extend(true, defaultOption, options);
		if (typeof options.fullscreen !== "boolean" || false !== options.fullscreen) {
			options.extraKeys = {
				"F11" : function(cm) {
					cm.setOption("fullScreen", !cm.getOption("fullScreen"));
				},
				"Esc": function(cm) {
					if (cm.getOption("fullScreen")) {
						cm.setOption("fullScreen", false);
					}
				}
			};
		}
		if (options.fullscreen) {
			delete options.fullscreen;
		}
		return CodeMirror.fromTextArea(document.getElementById(textareaId), options);
	}
	
};
(function($) {
	if (typeof $.fn.datepicker === "function") {
		var _gotoToday = $.datepicker._gotoToday;
		$.datepicker._gotoToday = function(id){
			var $target = $(id);
			var inst = this._getInst($target[0]);
			_gotoToday.call(this, id);
			$target.val($.datepicker._formatDate(inst, inst.selectedDay, inst.selectedMonth, inst.selectedYear));
		};
	}
})(jQuery);	

/**
 * 스크롤바 - 스크롤바를 만들 영역에 overflow-x, overflow-y가 정의 되어있어야 한다. auto, scroll 일 경우 적용된다. 
 * var sbar = jQuery.aosScroller("elementId"); 
 * sbar.scroll("top"); // top, bottom, left, right 
 * 
 * 다음과 같은 css 필요함.
 * .aos-scroller                   {}
 * .aos-scroller .scrollbar        {background-color:#cdcdcd; opacity:0.70; border-radius:5px; -moz-border-radius:5px; -webkit-border-radius:5px; visibility:hidden; }
 * .aos-scroller .scrollbar .thumb {background-color:#000000; border-radius:5px; -moz-border-radius:5px; -webkit-border-radius:5px; }
 * .aos-scroller .vscroll          {width:10px; height:100%; }
 * .aos-scroller .vscroll .thumb   {width:8px; height:20px; margin-left:1px;}
 * .aos-scroller .hscroll          {width:100%; height:10px; }
 * .aos-scroller .hscroll .thumb   {width:20px; height:8px; margin-top:1px;}
 * .aos-scroller:hover .scrollbar  {visibility:visible;}
 * .aos-scroller .active           {visibility:visible;}
 */
(function($) {
	var publics = function() {
		return {
			"id" : "",
			$element : null,
			$content : null,
			$vscroll : null,
			$hscroll : null,
			$vthumb : null,
			$hthumb : null,
			vthumbSize : 20,
			hthumbSize : 20,
			scroll : function(s) {
				switch(s.toLowerCase()) {
				case "top":
					this.$content.scrollTop(0);
					break;
				case "bottom":
					this.$content.scrollTop(this.$content.get(0).scrollHeight);
					break;
				case "left":
					this.$content.scrollLeft(0);
					break;
				case "right":
					this.$content.scrollLeft(this.$content.get(0).scrollWidth);
					break;
				}
			},
			vScroll : function(top) {
				var min = 0;
				var max = this.$vscroll.height() - this.vthumbSize;
				top = Math.min(max, Math.max(min, top));
				this.$vthumb.css({"top" : top + "px"});

				var content = this.$content.get(0);
				if (top == max) {
					this.$content.scrollTop(content.scrollHeight);
				} else if (top == min) {
					this.$content.scrollTop(0);
				} else {
					this.$content.scrollTop(Math.round(content.scrollHeight * top / this.$vscroll.height()));
				}
			},
			hScroll : function(left) {
				var min = 0;
				var max = this.$hscroll.width() - this.hthumbSize;
				left = Math.min(max, Math.max(min, left));
				this.$hthumb.css({"left" : left + "px"});
				
				var content = this.$content.get(0);
				if (left == max) {
					this.$content.scrollLeft(content.scrollWidth);
				} else if (left == min) {
					this.$content.scrollLeft(0);
				} else {
					this.$content.scrollLeft(Math.round(content.scrollWidth * left / this.$hscroll.width()));
				}
			},
			reset : function() {
				var _this = this;
				var thumbMinSize = 20;

				// 초기화
				this.$vscroll = null;
				this.$hscroll = null;
				this.$vthumb = null;
				this.$hthumb = null;
				this.vthumbSize = 20;
				this.hthumbSize = 20;
				this.$element.find(".scrollbar").remove();

				var events = {
					"vmousedown" : function(event) {
						vDrag = true;
						_this.$vscroll.addClass("active");
						vOffset = event.pageY;
						vStartTop = parseInt(_this.$vthumb.css("top"), 10);
						jQuery(document).bind("mousemove", events.vmousemove).bind("mouseup", events.vmouseup).bind("select", events.select);
						return false;
					},
					"vmousemove" : function(event) {
						if (vDrag == false) {
							return;
						}
						_this.vScroll(event.pageY - vOffset + vStartTop);
						return false;
					},
					"vmouseup" : function(event) {
						vDrag = false;
						jQuery(document).unbind("mousemove", events.vmousemove).unbind("mouseup", events.vmouseup).unbind("select", events.select);
						_this.$vscroll.removeClass("active");
					},
					"vbardown" : function(event) {
						if (vDrag == true) {
							return;
						}
						_this.vScroll((event.offsetY || event.originalEvent.layerY) - (_this.vthumbSize * 0.5));
					},
					"hmousedown" : function(event) {
						hDrag = true;
						_this.$hscroll.addClass("active");
						hOffset = event.pageX;
						hStartLeft = parseInt(_this.$hthumb.css("left"), 10);
						jQuery(document).bind("mousemove", events.hmousemove).bind("mouseup", events.hmouseup).bind("select", events.select);
						return false;
					},
					"hmousemove" : function(event) {
						if (hDrag == false) {
							return;
						}
						_this.hScroll(event.pageX - hOffset + hStartLeft);
						return false;
					},
					"hmouseup" : function(event) {
						hDrag = false;
						jQuery(document).unbind("mousemove", events.hmousemove).unbind("mouseup", events.hmouseup).unbind("select", events.select);
						_this.$hscroll.removeClass("active");
					},
					"hbardown" : function(event) {
						if (hDrag == true) {
							return;
						}
						_this.hScroll((event.offsetX || event.originalEvent.layerX) - (_this.hthumbSize * 0.5));
					},
					"select" : function(event) {
						return false;
					},
					"scroll" : function(event) {
						if (_this.$vscroll != null) {
							var sT = content.scrollTop;
							var h = _this.$vscroll.height();
							var sH = content.scrollHeight;
							var top = Math.round(sT * h / sH);
							if (top > h - _this.vthumbSize) {
								top = h - _this.vthumbSize;
							}
							_this.$vthumb.css({"top" :  top + "px"});
						}
						if (_this.$hscroll != null) {
							var sL = content.scrollLeft;
							var w = _this.$hscroll.width();
							var sW = content.scrollWidth;
							var left = Math.round(sL * w / sW);
							if (left > w - _this.hthumbSize) {
								left = w - _this.hthumbSize;
							}
							_this.$hthumb.css({"left" :  left + "px"});
						}
					}
				}
				
				var content = this.$content.get(0);
				var scroller = false;
				if (content.scrollHeight > this.$content.height() && "hidden" !== this.$content.css("overflowY")) {
					var vDrag = false;
					var vOffset = 0;
					var vStartTop = 0;
					var wBar = content.offsetWidth - content.clientWidth;
					this.$vscroll = jQuery("<div class='scrollbar vscroll'></div>");
					this.$vscroll.css({
						"position" : "absolute",
						"right" : "0px",
						"top" : "0px"
					});
					this.$vscroll.mousedown(events.vbardown);
					this.$vthumb = jQuery("<div class='thumb'></div>");
					this.$vthumb.appendTo(this.$vscroll);
					this.$vthumb.mousedown(events.vmousedown);
					this.$vscroll.appendTo(this.$element);
					this.$content.css({
						"width" : (this.$content.width() + wBar) + "px" 
					});
					scroller = true;
				}
				if (content.scrollWidth > this.$content.width() && "hidden" !== this.$content.css("overflowX")) {
					var hDrag = false;
					var hOffset = 0;
					var hStartLeft = 0;
					var hEvent = {
					}
					var hBar = content.offsetHeight - content.clientHeight;
					this.$hscroll = jQuery("<div class='scrollbar hscroll'></div>");
					this.$hscroll.css({
						"position" : "absolute",
						"left" : "0px",
						"bottom" : "0px"
					});
					this.$hscroll.mousedown(events.hbardown);
					this.$hthumb = jQuery("<div class='thumb'></div>");
					this.$hthumb.appendTo(this.$hscroll);
					this.$hthumb.mousedown(events.hmousedown);
					this.$hscroll.appendTo(this.$element);
					this.$content.css({
						"height" : (this.$content.height() + hBar) + "px" 
					});
					scroller = true;
				}
				if (scroller == true) {
					this.$element.addClass("aos-scroller");
				} else {
					return;
				}
				if (this.$vscroll != null && this.$hscroll != null) {
					this.$vscroll.css({
						"height" : (this.$vscroll.height() - this.$hscroll.height()) + "px"
					});
					this.$hscroll.css({
						"width" : (this.$hscroll.width() - this.$vscroll.width()) + "px"
					});
				}
				if (this.$vscroll != null) {
					this.vthumbSize = Math.round(this.$content.height() * this.$vscroll.height() / content.scrollHeight);
					if (this.vthumbSize < thumbMinSize) {
						this.vthumbSize = thumbMinSize;
					}
					this.$vthumb.css({
						"position" : "absolute",
						"top" : "0",
						"height" : this.vthumbSize 
					});
				}
				if (this.$hscroll != null) {
					this.hthumbSize = Math.round(this.$content.width() * this.$hscroll.width() / content.scrollWidth);
					if (this.hthumbSize < thumbMinSize) {
						this.hthumbSize = thumbMinSize;
					}
					this.$hthumb.css({
						"position" : "absolute",
						"left" : "0",
						"width" : this.hthumbSize 
					});
				}
				this.$content.bind("scroll wheel", events.scroll);				
			}
		};
	};
	var create = function(elementId, options) {
		var pub = new publics();
		pub.id = elementId;
		pub = $.extend(true, pub, options);
		
		pub.$content = jQuery("#" + pub.id);
		pub.$element = jQuery("<div></div>");
		pub.$element.css({
			"position" : "relative",
			"width" : pub.$content.width() + "px",
			"height" : pub.$content.height() + "px",
			"overflow" : "hidden"
		});
		pub.$element.insertAfter(pub.$content);
		pub.$content.appendTo(pub.$element);
		
		pub.reset();
		return pub;
	};
	
	$.aosScroller = function(elementId, options) {
		return create(elementId, options);
	};

})(jQuery);

/**
 * overflow 시 스크롤 버튼이 나타난다.
 * (예)
 * <div id="scroller" style="position:relative; width:100px; height:18px; white-space:nowrap;">
 *      <div class="scroll-left"    style="position:absolute; left:0; top:0; width:10px; height:15px; border:solid 1px #000000; background-color:#ffffff; ">&lt;</div>
 *      <div class="scroll-right"   style="position:absolute; right:0; bottom:0; width:10px; height:15px; border:solid 1px #000000; background-color:#ffffff;">&gt;</div>
 *      <div class="scroll-content">123456789012345678901234567890</div>
 * </div>
 * <script type="text/javascript">
 *      jQuery.aosButtonScroller("scroller");
 * </script>	
 */
(function($) {
	var publics = function() {
		return {
			$element : null,
			$content : null,
			button : {
				$left : null,
				$right : null,
				$top : null,
				$bottom : null
			},
			scroll : function(s) {
				var _this = this;
				var content = _this.$content.get(0);
				switch(s.toLowerCase()) {
				case "left":
					_this.$content.animate({scrollLeft : content.scrollLeft - Math.round(this.$content.width() / 2)}, function() {
						_this.reset();
					});
					break;
				case "right":
					_this.$content.animate({scrollLeft : content.scrollLeft + Math.round(this.$content.width() / 2)}, function() {
						_this.reset();
					});
					break;
				case "top":
					_this.$content.animate({scrollTop : content.scrollTop - Math.round(this.$content.height() / 2)}, function() {
						_this.reset();
					});
					break;
				case "bottom":
					_this.$content.animate({scrollTop : content.scrollTop + Math.round(_this.$content.height() / 2)}, function() {
						_this.reset();
					});
					break;
				}
			},
			reset : function() {
				var _this = this;
				var content = _this.$content.get(0);
				if (content.scrollWidth > _this.$content.width()) {
					if (content.scrollLeft > 0) {
						_this.button.$left.show();
					} else {
						_this.button.$left.hide();
					}
					if (content.scrollLeft < (content.scrollWidth - _this.$content.width())) {
						_this.button.$right.show();
					} else {
						_this.button.$right.hide();
					}
				} else {
					_this.button.$left.hide();
					_this.button.$right.hide();
				}
				if (content.scrollHeight > _this.$content.height()) {
					if (content.scrollTop > 0) {
						_this.button.$top.show();
					} else {
						_this.button.$top.hide();
					}
					if (content.scrollTop < (content.scrollHeight - _this.$content.height())) {
						_this.button.$bottom.show();
					} else {
						_this.button.$bottom.hide();
					}
				} else {
					_this.button.$top.hide();
					_this.button.$bottom.hide();
				}
			},
			width : function(w) {
				this.$content.width(w);
				this.reset();
			},
			height : function(h) {
				this.$content.height(h);
				this.reset();
			}
		};
	};
	var create = function(elementId) {
		var pub = new publics();
		pub.$element = jQuery("#" + elementId);
		pub.$content = pub.$element.find(".scroll-content");
		pub.$content.css("overflow", "hidden");
		pub.button.$left = pub.$element.find(".scroll-left").hide();
		pub.button.$right = pub.$element.find(".scroll-right").hide();
		pub.button.$top = pub.$element.find(".scroll-top").hide();
		pub.button.$bottom = pub.$element.find(".scroll-bottom").hide();
		
		pub.button.$left.click(function() {
			pub.scroll("left");
		});
		pub.button.$right.click(function() {
			pub.scroll("right");
		});
		pub.button.$top.click(function() {
			pub.scroll("top");
		});
		pub.button.$bottom.click(function() {
			pub.scroll("bottom");
		});
		
		pub.reset();
		return pub;
	};
	
	$.aosButtonScroller = function(elementId) {
		return create(elementId);
	};
	
})(jQuery);

/**
 * scroll start & end event 정의
 */
(function($) {
	var dispatch = $.event.dispatch || $.event.handle;
	var special = $.event.special;
	var date = new Date();
	var uid1 = "uid-" + date.getTime();
	var uid2 = "uid-" + date.getTime() + 1;

	special.scrollstart = {
		setup : function(data) {
			var _data = $.extend({
				latency: special.scrollstop.latency
			}, data);

			var timer = null;
			var handler = function(event) {
				var _self = this;
				var _args = arguments;

				if (timer) {
					clearTimeout(timer);
				} else {
					event.type = "scrollstart";
					dispatch.apply(_self, _args);
				}

				timer = setTimeout(function() {
					timer = null;
				}, _data.latency);
			};

			$(this).bind("scroll", handler).data(uid1, handler);
		},
		teardown : function() {
			$(this).unbind("scroll", $(this).data(uid1));
		}
	};

	special.scrollstop = {
		latency: 200,
		setup : function(data) {
			var _data = $.extend({
				latency: special.scrollstop.latency
			}, data);

			var timer = null;
			var handler = function(event) {
				var _self = this;
				var _args = arguments;

				if (timer) {
					clearTimeout(timer);
				}

				timer = setTimeout(function() {
					timer = null;
					event.type = "scrollstop";
					dispatch.apply(_self, _args);
				}, _data.latency);
			};

			$(this).bind("scroll", handler).data(uid2, handler);
		},
		teardown: function() {
			$(this).unbind("scroll", $(this).data(uid2));
		}
	};

})(jQuery);
