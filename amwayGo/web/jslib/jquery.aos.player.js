var _fileinfo_ = {
	version : "3.2.2"
};
(function($) {
	var methods = {
		create : function(options) {
			options = $.extend(true, {
				playerType : "auto",
				mediaType : "video",
				autoStart : false,
				alwaysShowControl : true,
				stretchToFit : false,
				enableContextMenu : false,
				fullScreen : false,
				width : "100%",
				height : "100%"
			}, options);
			
			var players = [];
			this.each(function() {
				var $this = jQuery(this);
				var eachOptions = $.extend(true, {}, options);
				eachOptions.url = $this.attr("src") || $this.attr("href") || "";
				var url = eachOptions.url;
				if (url.indexOf("?") > -1) {
					var split = url.split("?");
					url = split[0];
				}
				var ext = "";
				if (url.indexOf(".") > -1) {
					var split = url.split(".");
					ext = split[split.length - 1].toLowerCase();
				}
				if (ext == "mp3" || ext == "wav") {
					eachOptions.mediaType = "audio";
				} else if (ext == "swf") {
					eachOptions.mediaType = "flash";
				}
				eachOptions.ext = ext;
				if (eachOptions.playerType == "auto") {
					eachOptions.playerType = creator.canPlayType(eachOptions).split(",")[0];
				}
			    if (eachOptions.playerType == "wmp") { 
			    	if (jQuery.browser.safari && jQuery.browser.webkit) {
			    		eachOptions.alwaysShowControl = true;
			    	}
			    	if (jQuery.isMobile) {
			    		eachOptions.playerType = "html5";
			    	}
			    }
				eachOptions.id = $this.attr("id");
				if ("100%" == eachOptions.width) {
					eachOptions.width = $this.parent().width();
				}
				if ("100%" == eachOptions.height) {
					eachOptions.height = $this.parent().height();
				}
				var $element = jQuery("<div></div>");
				$element.attr({
					"class" : $this.attr("class"),
					"id" : $this.attr("id")
				});
				$this.replaceWith($element);
				creator.player[eachOptions.playerType]($element, eachOptions);
				players.push($element);
			});

			return {
				getMaxLocation : function($aosPlayer) {
					var location = 0;
					if (typeof $aosPlayer === "object" && $aosPlayer.length > 0) {
						location = $aosPlayer.data("maxLocation");
					}
					return location;
				},
				setMaxLocation : function($aosPlayer, location) {
					if (typeof $aosPlayer === "object" && $aosPlayer.length > 0) {
						if (isNaN(parseFloat(location))) {
							location = 0;	
						} else {
							location = parseFloat(location);
						}
						$aosPlayer.data("maxLocation", location);
					}
				},
				moveToLocation : function($aosPlayer, location) {
					if (typeof $aosPlayer === "object" && $aosPlayer.length > 0) {
						var mPlayer = $aosPlayer.find(".aosp-object").get(0);
						if (typeof mPlayer === "object") {
							if (isNaN(parseFloat(location))) {
								location = 0;	
							} else {
								location = parseFloat(location);
							}
							try {
								if (typeof mPlayer.duration !== "undefined") { // html5
									mPlayer.currentTime = location;
									mPlayer.play();
								} else if (typeof mPlayer.currentMedia !== "undefined") { // wmp
									mPlayer.controls.currentPosition = location;
									mPlayer.controls.play();
								}
							} catch (e) {
								// 버퍼링(다운로드)가 되지 않아 이동할 수 없음.
							}
						}
					}
				},
				getCurrentLocation : function(mPlayer) {
					var location = 0;
					if (typeof mPlayer === "object") {
						if (typeof mPlayer.duration !== "undefined") { // html5
							location = mPlayer.currentTime;
						} else if (typeof mPlayer.currentMedia !== "undefined") { // wmp
							location = mPlayer.controls.currentPosition;
						}
					}
					return location;
				},
				getAosPlayer : function(elementId) {
					return jQuery("#" + elementId).find(".aos-player");
				},
				stop : function(mPlayer) {
					if (typeof mPlayer === "object") {
						if (typeof mPlayer.duration !== "undefined") { // html5
							mPlayer.ended = true;
						} else if (typeof mPlayer.currentMedia !== "undefined") { // wmp
							mPlayer.controls.stop();
						}
					}
				}
			};
		}
	};
	var creator = {
		displayControl : function($aosPlayer, options) {
			var $control = jQuery("<div class='aosp-control'></div>");
			var $areaPlay = jQuery("<div class='aosp-button aosp-play'></div>");
			var $areaMute = jQuery("<div class='aosp-button aosp-unmute'></div>");
			var $buttonPlay = jQuery("<button type='button' title='Play'></button>");
			var $buttonMute = jQuery("<button type='button' title='Mute Toggle'></button>");
			var $timeCurrent = jQuery("<div class='aosp-time aosp-current-time'><span>00:00</span></div>");
			var $timeTotal = jQuery("<div class='aosp-time aosp-total-time'><span>00:00</span></div>");
			var html = [];
			html.push("<div class='aosp-slider aosp-slider-time'>");
			html.push("<div class='aosp-slider-total aosp-time-total'>");
			html.push("<span class='aosp-slider-time-buffering'></span>");
			html.push("<span class='aosp-slider-current'></span>");
			html.push("<div class='aosp-slider-time-float'>");
			html.push("<em>00:00</em>");
			html.push("<span class='aosp-slider-time-float-arrow'></span>");
			html.push("</div>");
			html.push("</div>");
			html.push("</div>");
			var $sliderTime = jQuery(html.join(" "));
			html = [];
			html.push("<div class='aosp-slider'>");
			html.push("<div class='aosp-slider-total aosp-volume-total'>");
			html.push("<span class='aosp-slider-current'></span>");
			html.push("</div>");
			html.push("</div>");
			var $sliderVolume = jQuery(html.join(" "));
			
			$control.css({
				visibility : "hidden"
			});
			$areaPlay.append($buttonPlay);
			$areaMute.append($buttonMute);
			$control.append($areaPlay);
			$control.append($timeCurrent);
			$control.append($sliderTime);
			$control.append($timeTotal);
			$control.append($areaMute);
			if (!jQuery.browser.chrome && !(jQuery.browser.safari && jQuery.browser.webkit)) {
				$control.append($sliderVolume);
			}
			$aosPlayer.append($control);

			if (options.mediaType == "video" && options.alwaysShowControl == false) {
				var $frame = jQuery("<iframe class='aosp-iframe' scrolling='no'></iframe>");
				$aosPlayer.hover(function(){
					$control.show();
				}, function() {
					$control.hide();
				});
				$aosPlayer.append($frame);
			}
			$aosPlayer.append(jQuery("<div style='clear:both;height:0;'></div>"));
			
			var $objectPlayer = $aosPlayer.find(".aosp-object");
			var mPlayer = $objectPlayer.get(0);

			try { // firefox에서 가끔 동작 안할때가 있다.
				if (!jQuery.browser.chrome) { // 크롬에서는 첫 세팅이 지속되기 때문에 제외.
					if (options.playerType == "wmp") {
						mPlayer.settings.mute = true; // 로드시에는 mute
					} else if (options.playerType == "html5") {
						mPlayer.muted = true; // 로드시에는 mute
					}
				}
			} catch (e) {}
			
			if (options.alwaysShowControl == true) {
				$objectPlayer.closest(".aosp-media").css({
					width : $aosPlayer.width() + "px",
					height : ($aosPlayer.height() - $control.height()) + "px"
				});
			} else {
				$objectPlayer.closest(".aosp-media").css({
					width : "100%",
					height : "100%"
				});
				$control.css({
					position : "absolute",
					bottom : "0",
					left : "0"
				});
			}
			$control.css({
				visibility : "visible"
			});
			
			$buttonPlay.click(function() {
				var $button = jQuery(this).parent(".aosp-button");
				switch (options.playerType) {
				case "wmp":
					if (mPlayer.playState == 3) { // play중.
						mPlayer.controls.pause();
						$button.removeClass("aosp-pause");
					} else {
						if (!jQuery.browser.msie) { // ie가 아닌경우에
							if (notIEActiveMPlayer != null) {
								if (notIEActiveMPlayer.playState == 3) { // play중.
									notIEActiveMPlayer.controls.pause();
								}
							}
							notIEActiveMPlayer = mPlayer;
						}
						mPlayer.controls.play();
						$button.addClass("aosp-pause");
					}
					break;
				case "html5":
					if (mPlayer.paused == true || mPlayer.ended == true) { // pause, end 중.
						mPlayer.play();
						$button.addClass("aosp-pause");
					} else {
						mPlayer.pause();
						$button.removeClass("aosp-pause");
					}
					break;
				}
			});
			$buttonMute.click(function() {
				var $button = jQuery(this).parent(".aosp-button");
				switch (options.playerType) {
				case "wmp":
					if (mPlayer.settings.mute == true) {
						mPlayer.settings.mute = false;
						$button.removeClass("aosp-mute");
					} else {
						mPlayer.settings.mute = true;
						$button.addClass("aosp-mute");
					}				
					break;
				case "html5":
					if (mPlayer.muted == true) {
						mPlayer.muted = false;
						$button.removeClass("aosp-mute");
					} else {
						mPlayer.muted = true;
						$button.addClass("aosp-mute");
					}				
					break;
				}
			});
			
			if (options.mediaType == "video" && options.playerType == "wmp") {
				var $areaScreen = jQuery("<div class='aosp-button aosp-fullscreen'></div>");
				var $buttonScreen = jQuery("<button type='button' title='Fullscreen'></button>");
				$areaScreen.append($buttonScreen);
				$control.append($areaScreen);

				$buttonScreen.click(function() {
					if (mPlayer.playState == 3) { // play중.
						mPlayer.fullScreen = true;
					}
				});
			}

			var initialize = function() {
				var duration = "00:00";
				if (options.playerType == "wmp") {
					duration = mPlayer.currentMedia.durationString;
				} else if (options.playerType == "html5") {
					duration = creator.timeString(mPlayer.duration);
				}
				
				$timeTotal.find("span").text(duration);
				$timeCurrent.find("span").text(duration.replace(/[\d]/g, "0"));

				var w = 0;
				$sliderTime.siblings().each(function() {
					w += jQuery(this).width() + 5; // 5 is margin.
				});
				$sliderTime.find(".aosp-time-total").css({
					width : ($control.width() - w) + "px"
				});
				
				var $total = $sliderTime.find(".aosp-time-total");
				var $float = $sliderTime.find(".aosp-slider-time-float");
				var $volume = $sliderVolume.find(".aosp-slider-current");
				var offsetTime = $total.offset();
				var offsetVolume = $sliderVolume.offset();

				$sliderTime.find("span").hover(function(){
					jQuery(this).siblings(".aosp-slider-time-float").show();
				
				}, function() {
					jQuery(this).siblings(".aosp-slider-time-float").hide();
				
				}).bind("mousemove", function(e) {
					var percent = Math.round(parseInt(e.pageX - offsetTime.left, 10) / $total.width() * 100);
					$float.css({left : parseInt(e.pageX - offsetTime.left, 10) - ($float.width() / 2) + "px" });
					$float.find("em").text(creator.positionString(duration, percent));
				
				}).bind("mousedown", function(e) {
					if (options.playerType == "wmp") {
						if (!jQuery.browser.msie && mPlayer !== notIEActiveMPlayer) { // ie가 아닌경우에
							return;
						}
						if (mPlayer.playState == 2 || mPlayer.playState == 3) { // pause, play중.
							var percent = Math.round(parseInt(e.pageX - offsetTime.left, 10) / $total.width() * 100);
							mPlayer.controls.currentPosition = creator.position(duration, percent);
						}
					} else if (options.playerType == "html5") {
						if (mPlayer.ended == false ) { // pause, play중.
							var percent = Math.round(parseInt(e.pageX - offsetTime.left, 10) / $total.width() * 100);
							mPlayer.currentTime = creator.position(duration, percent);
						}
					}
				});
				$sliderVolume.bind("mousedown", function(e) {
					var percent = Math.round(parseInt(e.pageX - offsetVolume.left, 10) / $sliderVolume.width() * 10) * 10 + 10; // 10단위
					$volume.css({
						width : percent + "%"
					});
					if (options.playerType == "wmp") {
						mPlayer.settings.volume = percent;

					} else if (options.playerType == "html5") {
						mPlayer.volume = percent / 100;
					}
				});

				if (options.alwaysShowControl == false) {
					$control.hide();
				}
				$objectPlayer.css({
					visibility : "visible"
				});
				
				if (options.playerType == "wmp") {
					if (!jQuery.browser.msie) { // ie가 아닌경우에 - 이벤트가 발생한 wmp를 구별할 수 없기 때문에 autoStart 하면 안된다. 
						options.autoStart = false;
					}
					if (options.autoStart == false) {
						mPlayer.controls.pause();
						mPlayer.controls.currentPosition = 0.1;
					}
				} else if (options.playerType == "html5") {
					mPlayer.play();	
					if (options.autoStart == false) {
						mPlayer.currentTime = 0.1;
						mPlayer.pause();
					}
				}

				$volume.css({width : "50%"});
				if (options.playerType == "wmp") {
					mPlayer.settings.mute = false; // 초기화
					mPlayer.settings.volume = 50; // 초기화
				} else if (options.playerType == "html5") {
					mPlayer.muted = false; // 초기화
					mPlayer.volume = 0.5; // 초기화
				}
			};
			
			if (options.playerType == "wmp") {	
				var timer = setInterval(function() {
					if (typeof mPlayer.currentMedia !== "object" && typeof mPlayer.currentMedia !== "function") {
						return;
					}
					if (mPlayer.currentMedia.durationString == "00:00") {
						return;
					}
					initialize();
					clearInterval(timer);
				}, 1000);

			} else if (options.playerType == "html5") {
				$objectPlayer.bind("loadedmetadata", function() {
					initialize();
					
				}).bind("ended", function() {
					if (typeof $aosPlayer.data("timer") === "number") {
						clearInterval($aosPlayer.data("timer"));
						$aosPlayer.data("timer", "");
					}
					var $sliderCurrent = $aosPlayer.find(".aosp-time-total > .aosp-slider-current");
					$sliderCurrent.css("width", "100%");
					$aosPlayer.find(".aosp-play").removeClass("aosp-pause").removeClass("aosp-stop");
					$aosPlayer.data("maxLocation", mPlayer.duration);
				}).bind("pause", function() {
					if (typeof $aosPlayer.data("timer") === "number") {
						clearInterval($aosPlayer.data("timer"));
						$aosPlayer.data("timer", "");
					}
					$aosPlayer.find(".aosp-play").removeClass("aosp-pause").removeClass("aosp-stop");

				}).bind("play", function() {
					$aosPlayer.find(".aosp-play").addClass("aosp-pause").removeClass("aosp-stop");
					if (typeof $aosPlayer.data("timer") !== "number") {
						var $timeCurrent = $aosPlayer.find(".aosp-current-time > span");
						var $sliderCurrent = $aosPlayer.find(".aosp-time-total > .aosp-slider-current");
						var $sliderBuffering = $aosPlayer.find(".aosp-time-total > .aosp-slider-time-buffering");
						$aosPlayer.data("timer", setInterval(function() {
							$timeCurrent.text(creator.timeString(mPlayer.currentTime));
							var position = parseInt(mPlayer.currentTime / mPlayer.duration * 100, 10);
							$sliderCurrent.css("width",  position + "%");
							
							var maxLocation = $aosPlayer.data("maxLocation") || 0;
							var maxPosition = parseInt(maxLocation / mPlayer.duration * 100, 10);
							$sliderBuffering.css("width", (Math.max(maxPosition, position)) + "%");
							$aosPlayer.data("maxLocation", Math.max(maxLocation, mPlayer.currentTime));
						}, 500));
					}
				});
			}
			if (creator.canPlayType(options).indexOf(options.playerType) == -1) {
				$control.append(jQuery("<div class='aosp-notsupport'>" + creator.notSupportMessage + "</div>"));
				$objectPlayer.css({
					visibility : "visible",
					backgroundColor : "#000"
				});
			}
			
		},
		notSupportMessage : I18N["Aos:Player:NotSupportMediaType"], // 지원할 수 없는 미디어 타입입니다 
		generateId : function() {
			return (new Date()).getTime();
		},
		position : function(duration, percent) {
			var token = duration.split(":").reverse();
			var position = 0;
			for (var i = 0; i < token.length; i++) {
				position += Math.pow(60, i) * parseInt(token[i], 10); 
			}
			return Math.round(position * (percent / 100));
		},
		positionString : function(duration, percent) {
			var time = creator.position(duration, percent);
			return creator.timeString(time);
		},
		timeString : function(time) {
			time = parseInt(time, 10);
			var x = Math.floor(time / 60);
			var h = x > 59 ? Math.floor(x / 60) : 0;
			var m = x > 59 ? x % 60 : x;
			var s = time % 60;
			var str = [];
			if (h > 0) {
				str.push(h < 10 ? "0" + h : h);
			}
			str.push(m < 10 ? "0" + m : m);
			str.push(s < 10 ? "0" + s : s);
			return str.join(":");
		},
		canPlayType : function(options) {
			var playType = {
				audio : {
					"mp3"  : {msie8 : "wmp", msie9 : "wmp", msie11: "html5", mozilla : "wmp", chrome : "html5,wmp", safari : "html5,wmp", opera : "wmp"},
					"wav"  : {msie8 : "wmp", msie9 : "wmp", msie11: "wmp", mozilla : "html5", chrome : "html5", safari : "html5", opera : "html5"}
					//"ogg"  : {msie8 : "", msie9 : "", mozilla : "html5", chrome : "html5", safari : "", opera : "html5"} // ogg는 지원안한다. ie에서 안됨.
				},
				video : {
					"mp4"  : {msie8 : "wmp", msie9 : "html5,wmp", msie11: "html5", mozilla : "html5,wmp", chrome : "html5,wmp", safari : "html5,wmp", opera : "wmp"},
					"webm" : {msie8 : "wmp", msie9 : "wmp", msie11: "wmp", mozilla : "html5,wmp", chrome : "html5,wmp", safari : "wmp", opera : "html5,wmp"},
					//"ogg"  : {msie8 : "", msie9 : "", mozilla : "html5", chrome : "html5", safari : "", opera : "html5"}, // ogg는 지원안한다. ie에서 안됨.
					"wmv"  : {msie8 : "wmp", msie9 : "wmp", msie11: "wmp", mozilla : "wmp", chrome : "wmp", safari : "wmp", opera : "wmp"},
					"avi"  : {msie8 : "wmp", msie9 : "wmp", msie11: "wmp", mozilla : "wmp", chrome : "wmp", safari : "wmp", opera : "wmp"},
					"mov"  : {msie8 : "wmp", msie9 : "wmp", msie11: "wmp", mozilla : "wmp", chrome : "wmp", safari : "wmp", opera : "wmp"},
					"mpg"  : {msie8 : "wmp", msie9 : "wmp", msie11: "wmp", mozilla : "wmp", chrome : "wmp", safari : "wmp", opera : "wmp"},
					"mpeg" : {msie8 : "wmp", msie9 : "wmp", msie11: "wmp", mozilla : "wmp", chrome : "wmp", safari : "wmp", opera : "wmp"}
				},
				flash : {
					"swf"  : {msie8 : "flash", msie9 : "flash", msie11: "flash", mozilla : "flash", chrome : "flash", safari : "flash", opera : "flash"}
				}
			}
			var browser = "";
			if (jQuery.browser.msie && parseInt(jQuery.browser.version, 10) < 9 ) {
				browser = "msie8";
			} else if (jQuery.browser.msie && parseInt(jQuery.browser.version, 10) >= 9 ) {
				browser = "msie9";
			} else if (jQuery.browser.mozilla) {
				if ((/Trident\/7\./).test(navigator.userAgent)) { // ie11
					browser = "msie11";
				} else {
					browser = "mozilla";
				}
			} else if (jQuery.browser.chrome) {
				browser = "chrome";
			} else if (jQuery.browser.safari && jQuery.browser.webkit) {
				browser = "safari";
			} else if (jQuery.browser.opera) {
				browser = "opera";
			}
			var m = playType[options.mediaType][options.ext];
			//alert(options.mediaType + ":" + options.ext + ":" + browser + ":" + options.playerType + ":" + m[browser]);
			if (typeof m === "object" && typeof m[browser] === "string") {
				return m[browser];
			} else {
				return "notSupport";
			}
		},
		player : {
			wmp : function($element, options) {
				var html = [];
				if(jQuery.browser.msie) {
					html.push("<object classid='clsid:6BF52A52-394A-11d3-B153-00C04F79FAA6' class='aosp-object' id='" + creator.generateId() + "'");
					html.push(" onreadystatechange='OnReadyStateChange(this)'>");
					html.push("<param name='windowlessVideo' value='true' />");
				} else {
					html.push("<object type='application/x-ms-wmp' class='aosp-object' id='" + creator.generateId() + "'");
					html.push(">");
					html.push("<param name='windowlessVideo' value='false' />");
				}
				html.push("<param name='uiMode' value='none' />");
				html.push("<param name='enabled' value='true' />");
				html.push("<param name='autoStart' value='true' />"); // 로드시에 미디어 정보를 읽기 위해 autoStart 한다.
				html.push("<param name='wmode' value='transparent' />");
				html.push("<param name='url' value='" + options.url + "' />");
				html.push("<param name='enableContextMenu' value='" + options.enableContextMenu + "' />");
				html.push("<param name='stretchToFit' value='" + options.stretchToFit + "' />");
				html.push("<param name='fullScreen' value='" + options.fullScreen + "' />");
				html.push("</object>");

				var $objectPlayer = jQuery(html.join(""));
				var $aosPlayer = jQuery("<div class='aos-player'></div>");
				var $areaMedia = jQuery("<div class='aosp-media aosp-" + options.mediaType + "'></div>");

				$objectPlayer.css({
					visibility : "hidden"
				});
				$aosPlayer.css({
					"width" : options.width + "px",
					"height" : options.height + "px"
				});
				
				$areaMedia.append($objectPlayer);
				$aosPlayer.append($areaMedia);
				$element.append($aosPlayer);
				creator.displayControl($aosPlayer, options);
				
			},
			html5 : function($element, options) {
				var html = [];
				html.push("<" + options.mediaType + " preload class='aosp-object' style='width:100%;height:100%'>"); // autoStart를 하면 제어가 안된다.
				html.push("<source src='" + options.url + "'");
				if (options.mediaType == "audio") {
					if (options.ext == "ogg") {
						html.push("type='audio/ogg'");
					} else if (options.ext == "wav") {
						html.push("type='audio/wav'");
					} else {
						html.push("type='audio/mpeg'");
					}
				} else if (options.mediaType == "video") {
					if (options.ext == "ogg") {
						html.push("type='video/ogg'");
					} else if (options.ext == "webm") {
						html.push("type='video/webm'");
					} else {
						html.push("type='video/mp4'");
					}
				}
				html.push("/>");
				html.push("</" + options.mediaType + ">"); // video, audio
				
				var $objectPlayer = jQuery(html.join(""));
				var $aosPlayer = jQuery("<div class='aos-player'></div>");
				var $areaMedia = jQuery("<div class='aosp-media aosp-" + options.mediaType + "'></div>");

				$objectPlayer.css({
					visibility : "hidden"
				});
				$aosPlayer.css({
					"width" : options.width + "px",
					"height" : options.height + "px"
				});
				
				$areaMedia.append($objectPlayer);
				$aosPlayer.append($areaMedia);
				$element.append($aosPlayer);
				creator.displayControl($aosPlayer, options);
				
			},
			flash : function($element, options) {
				var html = [];
				html.push("<object type='application/x-shockwave-flash' id='" + creator.generateId() + "'");
				html.push(" data='" + options.url + "'");
				html.push(" style='width:100%;height:100%'>");
				html.push("<param name='wmode' value='opaque' />");
				html.push("<param name='movie' value='" + options.url + "' />");
				html.push("</object>");
				
				var $objectPlayer = jQuery(html.join(""));
				var $aosPlayer = jQuery("<div class='aos-player'></div>");
				$aosPlayer.css({
					"width" : options.width + "px",
					"height" : options.height + "px"
				});
				$aosPlayer.append($objectPlayer);
				$element.append($aosPlayer);
			},
			notSupport : function($element, options) {
				var $aosPlayer = jQuery("<div class='aos-player'></div>");
				var $areaMedia = jQuery("<div class='aosp-media aosp-" + options.mediaType + "'><div class='aosp-object' style='width:100%;height:100%'></div></div>");
				var $control = jQuery("<div class='aosp-control'><div class='aosp-notsupport'>" + creator.notSupportMessage + "</div></div>");
				$aosPlayer.append($areaMedia);
				$aosPlayer.append($control);
				$element.append($aosPlayer);
				$aosPlayer.css({
					"width" : options.width + "px",
					"height" : options.height + "px"
				});
				$areaMedia.css({
					width : $aosPlayer.width() + "px",
					height : ($aosPlayer.height() - $control.height()) + "px"
				});
			}
		}
	};
	$.fn.media = function() {
		return methods.create.apply(this, arguments);
	};
	$.fn.audio = function(options) {
		options = options || {}; 
		options["playerType"] = "html5";
		options["mediaType"] = "audio";
		return methods.create.apply(this, arguments);
	};
	$.fn.video = function(options) {
		options = options || {};
		options["playerType"] = "html5";
		options["mediaType"] = "video";
		return methods.create.apply(this, arguments);
	};

})(jQuery);

/**
 * jquery.aos.player.js는 jquery-1.7.2.js 를 이용해서 만들었는데
 * 브라우저 체크하는 부분만 jquery-1.8.2.js 의 소스를 가져왔다.
 */
(function() {
	var matched, browser;

	// Use of jQuery.browser is frowned upon.
	// More details: http://api.jquery.com/jQuery.browser
	// jQuery.uaMatch maintained for back-compat
	jQuery.uaMatch = function( ua ) {
		ua = ua.toLowerCase();

		var match = /(chrome)[ \/]([\w.]+)/.exec( ua ) ||
			/(webkit)[ \/]([\w.]+)/.exec( ua ) ||
			/(opera)(?:.*version|)[ \/]([\w.]+)/.exec( ua ) ||
			/(msie) ([\w.]+)/.exec( ua ) ||
			ua.indexOf("compatible") < 0 && /(mozilla)(?:.*? rv:([\w.]+)|)/.exec( ua ) ||
			[];

		return {
			browser: match[ 1 ] || "",
			version: match[ 2 ] || "0"
		};
	};

	matched = jQuery.uaMatch( navigator.userAgent );
	browser = {};

	if ( matched.browser ) {
		browser[ matched.browser ] = true;
		browser.version = matched.version;
	}

	// Chrome is Webkit, but Webkit is also Safari.
	if ( browser.chrome ) {
		browser.webkit = true;
	} else if ( browser.webkit ) {
		browser.safari = true;
	}

	jQuery.browser = browser;
})(jQuery);

/**
 * 모마일 브라우저인지 검사
 */
(function() {
	var ua = navigator.userAgent;
    var mobile = ua.match(/(iPhone|iPod|iPad|BlackBerry|Android)/);
    jQuery.isMobile = mobile;
	
})(jQuery);
var notIEActiveMPlayer = null; // ie가 아닌 경우 이벤트가 발생한 wmp를 구별할 수 없기 때문에 동시에 play시키지 않는다.
var OnReadyStateChange = function (playerElement) {
	if (playerElement.readyState == 4)  { // complete
		playerElement.attachEvent("Error", function() {
			try {
				OnDSErrorEvt(playerElement);
			} catch (e) {
			}
		});
		playerElement.attachEvent("PlayStateChange", function(newState) {
			try {
				OnDSPlayStateChangeEvt(newState, playerElement);
			} catch (e) {
			}
		});
	}
};
var OnDSPlayStateChangeEvt = function(newState, mPlayer) {
	var $objectPlayer = null;
	if (typeof mPlayer === "object") {
		$objectPlayer = jQuery(mPlayer);
	} else {
		mPlayer = notIEActiveMPlayer;
		$objectPlayer = jQuery(mPlayer);	
	}
	if ($objectPlayer == null || $objectPlayer.length == 0) {
		return;
	}
	var $aosPlayer = $objectPlayer.closest(".aos-player");
	try {
		switch (newState) {
		case 1 : // "Stopped : 멈춤";
			if (typeof $aosPlayer.data("timer") === "number") {
				clearInterval($aosPlayer.data("timer"));
				$aosPlayer.data("timer", "");
			}
			$aosPlayer.find(".aosp-play").removeClass("aosp-pause").removeClass("aosp-stop");
			break;
		case 2 : // "Paused : 일시정지"; 
			if (typeof $aosPlayer.data("timer") === "number") {
				clearInterval($aosPlayer.data("timer"));
				$aosPlayer.data("timer", "");
			}
			$aosPlayer.find(".aosp-play").removeClass("aosp-pause").removeClass("aosp-stop");
			break;
		case 3 : // "Playing : 재생중";
			$aosPlayer.find(".aosp-play").addClass("aosp-pause").removeClass("aosp-stop");
			if (typeof $aosPlayer.data("timer") !== "number") {
				var $timeCurrent = $aosPlayer.find(".aosp-current-time > span");
				var $sliderCurrent = $aosPlayer.find(".aosp-time-total > .aosp-slider-current");
				var $sliderBuffering = $aosPlayer.find(".aosp-time-total > .aosp-slider-time-buffering");
				$aosPlayer.data("timer", setInterval(function() {
					$timeCurrent.text(mPlayer.controls.currentPositionString);
					var position = parseInt(mPlayer.controls.currentPosition / mPlayer.currentMedia.duration * 100, 10);
					$sliderCurrent.css("width",  position + "%");
					var maxLocation = $aosPlayer.data("maxLocation") || 0;
					var maxPosition = parseInt(maxLocation / mPlayer.currentMedia.duration * 100, 10);
					$sliderBuffering.css("width", (Math.max(maxPosition, position)) + "%");
					$aosPlayer.data("maxLocation", Math.max(maxLocation, mPlayer.controls.currentPosition));
				}, 250));
			}
			break;
		case 4 : // "Fast Forward : 빨리감기"; 
			break;
		case 5 : // "Rewind : 빨리되감기"; 
			break;
		case 6 : // "Buffering : 버퍼링"; 
			break;
		case 7 : // Waiting : 잠시 기다려주세요";
			break;
		case 8 : // Ended : 재생끝";
			$aosPlayer.find(".aosp-time-total > .aosp-slider-current").css("width",  "100%");
			$aosPlayer.find(".aosp-current-time > span").text(mPlayer.currentMedia.durationString);
			$aosPlayer.data("maxLocation", mPlayer.currentMedia.duration);
			break;
		case 9 : // Transitioning : 전송중"; Preparing new media item. 
			break;
		case 10 : // Player Ready : 준비중";
			break;
		}
	} catch ( Exception ) {
	}
};
var OnDSErrorEvt = function(mPlayer) {
	var $objectPlayer = null;
	if (typeof mPlayer === "object") {
		$objectPlayer = jQuery(mPlayer);
	} else {
		mPlayer = notIEActiveMPlayer;
		$objectPlayer = jQuery(mPlayer);	
	}
	if ($objectPlayer == null || $objectPlayer.length == 0) {
		return;
	}
	alert(mPlayer.error.item(mPlayer.error.errorCount - 1).errorDescription);
};

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/**
 * lcms 비표준 콘텐츠(동영상) 관련 함수
 */
var apiHandle = null;
var findAPITries = 0;
var noAPIFound = "false";
function findAPI(win) {
   while (win.API_1484_11 == null && win.parent != null && win.parent != win) {
      findAPITries++;
      if (findAPITries > 500) {
         alert( "Error finding API -- too deeply nested.");
         return null;
      }
      win = win.parent;
   }
   return win.API_1484_11;
}
function getAPI() {
	var theAPI = findAPI(window);
	if (theAPI == null && window.opener != null && typeof (window.opener) !== "undefined") {
		theAPI = findAPI(window.opener);
	}
	if (theAPI == null) {
		noAPIFound = "true";
	}
	return theAPI;
}
function getAPIHandle() {
	if (apiHandle == null) {
		if (noAPIFound == "false") {
			apiHandle = getAPI();
		}
	}
	return apiHandle;
}
function retrieveDataValue(name) {
    var api = getAPIHandle();
    if ( api == null ) {
        return "";
    } else {
        var value = api.GetValue(name);
        return api.GetLastError() == "0" ? value : "";
    }
}
function storeDataValue(name, value) {
	var api = getAPIHandle();
	if (api == null) {
		return false;
	} else {
		return api.SetValue(name, value) == "true" ? true : false;
	}
}
/**
 * url의 queryString parameter로 넘어온 값들 중에 width와 height를 리턴한다.
 */
function getStudyDimension(url) {
	var index = url.indexOf("?");
	parameter = index > -1 ? url.substring(index + 1) : "";
	var dimension = {
		width : $(window).width(),
		height : $(window).height()
	};
	var param = parameter.split("&");
	for (var p in param) {
		var pair = param[p].split("=");
		if (pair.length == 2) {
			if (pair[0].toLowerCase() == "width") {
				dimension.width = pair[1];
			} else if (pair[0].toLowerCase() == "height") {
				dimension.height = pair[1];
			}
		}
	}
	return dimension;
}
/**
 * lcms의 비표준 콘텐츠(동영상) 시작.
 */
function doStartNonScormPlayer(mediaUrl) {
	var dimension = getStudyDimension(self.location.href);
	var $div = jQuery("<div></div>");
	$div.css({
		width : dimension.width + "px", height : dimension.height + "px"
	});
	var $a = jQuery("<a href='" + mediaUrl + "' id='media'>Media</a>");
	$div.append($a);
	jQuery(document.body).append($div);
	
	var media = jQuery("#media").media();
	setTimeout(function(){
		var $aosPlayer = media.getAosPlayer("media");
		if ($aosPlayer.length > 0) {
			var maxLocation = retrieveDataValue("etc.movie_max_time"); // 저장된 학습 최대위치(시간)
			var lastLocation = retrieveDataValue("cmi.location"); // 저장된 마지막 학습위치(시간)

			media.setMaxLocation($aosPlayer, maxLocation);
			if (lastLocation != "" && parseInt(lastLocation, 10) > 1) {
				if(confirm(I18N["Aos:Player:ToGoPreviousStudy"])) { // 이전에 학습하신 곳으로 이동하시겠습니까?
					media.moveToLocation($aosPlayer, lastLocation);
				}
			}
			var mPlayer = $aosPlayer.find(".aosp-object").get(0);
			setInterval(function() {  // lcms 비표준 동영상 콘텐츠의 진도율을 계산하기 위한 데이타 저장하기.
				var currentLocation = media.getCurrentLocation(mPlayer);
				var maxLocation = media.getMaxLocation($aosPlayer);
				
				storeDataValue("cmi.location", currentLocation); // 현재 시간(위치)
				storeDataValue("etc.movie_max_time", Math.max(currentLocation, maxLocation)); // 학습 최대위치(시간)
			}, 1000 * 3);
		}
	}, 1000);
	/*
	*/
}
/**
 * lcms의 비표준 콘텐츠(플레쉬) 시작.
 */
function doStartNonScormPlayerFlash(mediaUrl) {
	var dimension = getStudyDimension(self.location.href);
	var $div = jQuery("<div></div>");
	$div.css({
		width : dimension.width + "px", height : dimension.height + "px"
	});
	var $a = jQuery("<a href='" + mediaUrl + "' id='media'>Media</a>");
	$div.append($a);
	jQuery(document.body).append($div);
	
	var media = jQuery("#media").media({playerType : "flash"});
}
//--- 이상 lcms 용 끝

