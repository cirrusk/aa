/**
 * jquery.aos.chart.js (raphael-2.1.0.js 사용)
 * author : jkk5246@gmail.com
 * version : 1.0.0
 * created : 2012.07.25
 */
var _fileinfo_ = {
	version : "3.2.0"
};

(function($) {
	var chart = function(chart, elementId, options) {
		var linechart = function () {
			return {
				type : "line",
				$this : null,
				paper : null,
				plot : null,
				options : {},
				property : {domainTickName : []},
				dataSet : [],
				appendGroup : function(groupName) {
					this.dataSet.push({"groupName" : groupName, data : []});
					drawLegend(this, this.dataSet.length - 1);
				},
				appendTickname : function(tickName) {
					this.property.domainTickName.push("");
					var index = this.property.domainTickName.length - 1;
					while(index > 0) {
						if (this.property.domainTickName[index - 1] != "") {
							break;
						}
						index--;
					}
					this.property.domainTickName[index] = tickName;
				},
				append : function() {
					if (typeof arguments === "undefined") {
						return;
					}
					var index = 0;
					for (var groupIndex = 0; groupIndex < arguments.length; groupIndex++) {
						this.dataSet[groupIndex].data.push("");
						index = this.dataSet[groupIndex].data.length - 1;
						while(index > 0) {
							if (typeof this.dataSet[groupIndex].data[index - 1] === "object") {
								break;
							}
							index--;
						}
						this.dataSet[groupIndex].data[index] = makeData(this.options, groupIndex, arguments[groupIndex]);
					}
					drawData(this, index);
				}
			};
		};
		var barchart = function () {
			return {
				type : "bar",
				$this : null,
				paper : null,
				plot : null,
				options : {},
				property : {domainTickName : []},
				dataSet : [],
				appendGroup : function(groupName) {
					this.dataSet.push({"groupName" : groupName, data : []});
					drawLegend(this, this.dataSet.length - 1);
				},
				appendTickname : function(tickName) {
					this.property.domainTickName.push("");
					var index = this.property.domainTickName.length - 1;
					while(index > 0) {
						if (this.property.domainTickName[index - 1] != "") {
							break;
						}
						index--;
					}
					this.property.domainTickName[index] = tickName;
				},
				append : function() {
					if (typeof arguments === "undefined") {
						return;
					}
					var index = 0;
					for (var groupIndex = 0; groupIndex < arguments.length; groupIndex++) {
						this.dataSet[groupIndex].data.push("");
						index = this.dataSet[groupIndex].data.length - 1;
						while(index > 0) {
							if (typeof this.dataSet[groupIndex].data[index - 1] === "object") {
								break;
							}
							index--;
						}
						this.dataSet[groupIndex].data[index] = makeData(this.options, groupIndex, arguments[groupIndex]);
					}
					drawData(this, index);
				}
			};
		};
		var piechart = function () {
			return {
				type : "pie",
				$this : null,
				paper : null,
				plot : null,
				options : {},
				property : {domainTickName : []},
				dataSet : [],
				appendGroup : function(groupName) {
					this.dataSet.push({"groupName" : groupName, data : []});
					drawLegend(this, this.dataSet.length - 1);
				},
				appendTickname : function(tickName) {
					this.property.domainTickName.push("");
					var index = this.property.domainTickName.length - 1;
					while(index > 0) {
						if (this.property.domainTickName[index - 1] != "") {
							break;
						}
						index--;
					}
					this.property.domainTickName[index] = tickName;
				},
				append : function() {
					if (typeof arguments === "undefined") {
						return;
					}
					var index = 0;
					for (var groupIndex = 0; groupIndex < arguments.length; groupIndex++) {
						this.dataSet[groupIndex].data.push("");
						index = this.dataSet[groupIndex].data.length - 1;
						while(index > 0) {
							if (typeof this.dataSet[groupIndex].data[index - 1] === "object") {
								break;
							}
							index--;
						}
						this.dataSet[groupIndex].data[index] = makeData(this.options, groupIndex, arguments[groupIndex]);
					}
					drawData(this, index);
				}
			};
		};
		var f = 0.5;
		var dash = jQuery.browser.msie && parseInt(jQuery.browser.version, 10) < 9 ? "-" : ". ";
		var lineChartDefault = {
			chartCss : {
				width : "100%",
				height : "300px",
				backgroundColor : "#ffffff"
			},
			legend : { // 범례
				visible : true,
				style : "text-align:center;"
			},
			plot : { // 차트영역
				backgroundImage : "",
				backgroundColor : "#ffffff",
				lineColor : "#000000",
				lineWidth : 1,
				margin : {left : 30, right : 20, top : 20, bottom : 25},
				oriental : "vertical", // vertical or horizontal
				overflow : "hidden", // hidden or scroll
				scrollBuffers : 100  // overflow 가 scroll 일 경우 데이타 버퍼수 (버퍼수를 초과하면 지우고 다시 그린다)
			},
			domain : { // 기준축
				label : {
					name : "",
					font : {size : 11, family : "굴림, Arial", color : "#000000"},
					margin : 12,
					position : "center" // center or right(plot.oriental == 'vertical'), top(plot.oriental == 'horizontal')
				},
				grid : {
					color : "#cdcdcd",
					shape : "dotted",  // solid, dotted
					visibleStep : 1, // 0 is not display
					lineWidth : 1
				},
				tick : { // 단위
					visibleStep : 1, // 1 is all display, 0 is not display, other 
					font : {size : 11, family : "굴림, Arial", color : "#000000"},
					count : 0
				}
			},
			range : { // 값 축
				label : {
					name : "",
					font : {size : 11, family : "굴림, Arial", color : "#000000"},
					margin : 10,
					position : "center" // center or top(plot.oriental == 'vertical'), right(plot.oriental == 'horizontal')
				},
				grid : {
					color : "#cdcdcd",
					shape : "dotted",  // solid, dotted
					visibleStep : 10, // 0 is not display
					lineWidth : 1
				},
				tick : {
					visibleStep : 20, // 1 is all display, 0 is not display, other 
					font : {size : 11, family : "굴림, Arial", color : "#000000"}
				},
				bound : {
					upper : 100.0,
					lower : 0.0
				}
			},
			data : { // 데이타
				dotShape : "round",   // round, square, none
				dotWidth : 2,         // 0 is no line
				lineShape : "solid",  // solid, dotted
				lineWidth : 2,        // 0 is no line
				label : {
					visible : true,
					font : {size : 11, family : "굴림, Arial", color : "#000000"},
					position : "top" // top(default) or bottom or left or right
				},
				colors : ["#ff0000", "#00ff00", "#0000ff", "#ffff00", "#ff00ff", "#00ffff"]
			}
		};
		var barChartDefault = {
				chartCss : {
					width : "100%",
					height : "300px",
					backgroundColor : "#ffffff"
				},
				legend : { // 범례
					visible : true,
					style : "text-align:center;"
				},
				plot : { // 차트영역
					backgroundImage : "",
					backgroundColor : "#ffffff",
					lineColor : "#000000",
					lineWidth : 1,
					margin : {left : 30, right : 20, top : 20, bottom : 25},
					oriental : "vertical" // vertical or horizontal
				},
				domain : { // 기준축
					label : {
						name : "",
						font : {size : 11, family : "굴림, Arial", color : "#000000"},
						margin : 12,
						position : "center" // center or right(plot.oriental == 'vertical'), top(plot.oriental == 'horizontal')
					},
					grid : {
						color : "#cdcdcd",
						shape : "dotted",  // solid, dotted
						visibleStep : 1, // 0 is not display
						lineWidth : 1
					},
					tick : { // 단위
						visibleStep : 1, // 1 is all display, 0 is not display, other 
						font : {size : 11, family : "굴림, Arial", color : "#000000"},
						count : 0
					}
				},
				range : { // 값 축
					label : {
						name : "",
						font : {size : 11, family : "굴림, Arial", color : "#000000"},
						margin : 10,
						position : "center" // center or top(plot.oriental == 'vertical'), right(plot.oriental == 'horizontal')
					},
					grid : {
						color : "#cdcdcd",
						shape : "dotted",  // solid, dotted
						visibleStep : 10, // 0 is not display
						lineWidth : 1
					},
					tick : {
						visibleStep : 20, // 1 is all display, 0 is not display, other 
						font : {size : 11, family : "굴림, Arial", color : "#000000"}
					},
					bound : {
						upper : 100.0,
						lower : 0.0
					}
				},
				data : { // 데이타
					barWidth : 10,
					barBorderWidth : 1,
					barBorderColor : "#000000",
					label : {
						visible : true,
						font : {size : 11, family : "굴림, Arial", color : "#000000"},
						position : "top" // top(default) or bottom or left or right
					},
					colors : ["#ff0000", "#00ff00", "#0000ff", "#ffff00", "#ff00ff", "#00ffff"]
				}
		};
		var pieChartDefault = {
				chartCss : {
					width : "100%",
					height : "300px",
					backgroundColor : "#ffffff"
				},
				legend : { // 범례
					visible : true,
					style : "text-align:center;"
				},
				plot : { // 차트영역
					backgroundImage : "",
					backgroundColor : "#ffffff",
					lineColor : "#000000",
					lineWidth : 1,
					margin : {left : 30, right : 20, top : 20, bottom : 25},
					oriental : "vertical" // vertical or horizontal
				},
				domain : { // 기준축
					label : {
						name : "",
						font : {size : 11, family : "굴림, Arial", color : "#000000"},
						margin : 12,
						position : "center" // center or right(plot.oriental == 'vertical'), top(plot.oriental == 'horizontal')
					},
					grid : {
						color : "#cdcdcd",
						shape : "dotted",  // solid, dotted
						visibleStep : 1, // 0 is not display
						lineWidth : 1
					},
					tick : { // 단위
						visibleStep : 1, // 1 is all display, 0 is not display, other 
						font : {size : 11, family : "굴림, Arial", color : "#000000"},
						count : 0
					}
				},
				data : { // 데이타
					pieBorderWidth : 1,
					pieBorderColor : "#ffffff",
					startAngle : 0, // 0 : 3시, 90 : 12시, 180 : 9시, 270 : 6시
					label : {
						visible : true,
						font : {size : 11, family : "굴림, Arial", color : "#ffffff"},
						position : "in" // in(default) or out
					},
					colors : ["#ff0000", "#00ff00", "#0000ff", "#ffff00", "#ff00ff", "#00ffff"]
				}
		};
		var drawPlot = function(chart) {
			chart.property.plotAttr = {
				"stroke" : chart.options.plot.lineColor, 
				"fill" : chart.options.plot.backgroundColor,
				"stroke-width" : chart.options.plot.lineWidth
			};
			chart.paper.rect(
				Math.round(chart.property.x) + f, 
				Math.round(chart.property.y) + f, 
				Math.round(chart.property.w), 
				Math.round(chart.property.h)
			).attr(chart.property.plotAttr).toFront();
			
			if (typeof chart.options.plot.backgroundImage === "string" && chart.options.plot.backgroundImage != "") {
				chart.paper.image(
					chart.options.plot.backgroundImage, 
					Math.round(chart.property.x) + f, 
					Math.round(chart.property.y) + f, 
					Math.round(chart.property.w), 
					Math.round(chart.property.h)
				).toBack();
			}
		};
		var drawRangeLabel = function(chart) {
			if (chart.type == "pie") {
				return;
			}
			if (chart.options.range.label.name != "") {
				var label = {
					x : 0, y : 0, name : "", 
					attr : {
						"font-size" : chart.options.range.label.font.size, 
						"font-family" : chart.options.range.label.font.family, 
						"fill" : chart.options.range.label.font.color
					}
				};
				if (chart.options.plot.oriental == "horizontal") { // 가로형
					label.x = Math.round(chart.property.x + chart.property.w / 2) + f;
					label.y = Math.round(chart.property.height - chart.options.range.label.margin) + f;
					label.name =  chart.options.range.label.name;
				} else { // 세로형
					label.x = Math.round(chart.options.range.label.margin) + f;
					label.y = Math.round(chart.property.y + chart.property.h / 2) + f;
					label.name = chart.options.range.label.name.split("").join("\n"); 
				}			
				var text = chart.paper.text(label.x, label.y, label.name).attr(label.attr);
				var box = text.getBBox(true);
				if (chart.options.plot.oriental == "horizontal") {
					if (chart.options.range.label.position == "right") {
						text.attr({x : Math.round(chart.property.x + chart.property.w - (box.width / 2)) + f});
					}
				} else {
					if (chart.options.range.label.position == "top") {
						text.attr({y : Math.round(chart.property.y + box.height / 2) + f});
					}					
				}
				text.toFront();
			}
		};
		var drawDomainLabel = function(chart) {
			if (chart.options.domain.label.name != "") {
				var label = {
					x : 0, y : 0, name : "", 
					attr : {
						"font-size" : chart.options.domain.label.font.size, 
						"font-family" : chart.options.domain.label.font.family, 
						"fill" : chart.options.domain.label.font.color
					}
				};
				if (chart.options.plot.oriental == "horizontal") { // 가로형
					label.x = Math.round(chart.options.domain.label.margin) + f;
					label.y = Math.round(chart.property.y + chart.property.h / 2) + f;
					label.name = chart.options.domain.label.name.split("").join("\n"); 
				} else { // 세로형
					label.x = Math.round(chart.property.x + chart.property.w / 2) + f;
					label.y = Math.round(chart.property.height - chart.options.domain.label.margin) + f;
					label.name = chart.options.domain.label.name; 
				}			
				var text = chart.paper.text(label.x, label.y, label.name).attr(label.attr);
				var box = text.getBBox(true);
				if (chart.options.plot.oriental == "horizontal") {
					if (chart.options.domain.label.position == "top") {
						text.attr({y : Math.round(chart.property.y + box.height / 2) + f});
					}
				} else {
					if (chart.options.domain.label.position == "right") {
						text.attr({x : Math.round(chart.property.x + chart.property.w - (box.width / 2)) + f});
					}					
				}
				text.toFront();
			}
		};
		var drawRangeGrid = function(chart) {
			if (chart.type == "pie") {
				return;
			}
			var width = chart.property.width;
			var height = chart.property.height;
			var m = chart.property.m;
			var x = chart.property.x;
			var y = chart.property.y;
			var w = chart.property.w;
			var h = chart.property.h;
			var rangeGrid = {
				path : [],
				attr : {
					"stroke" : chart.options.range.grid.color, 
					"stroke-width" : chart.options.range.grid.lineWidth
				}
			};
			if (chart.options.range.grid.shape == "dotted") {
				rangeGrid.attr["stroke-dasharray"] = dash;
			}
			var zeroPath = null;
			if (chart.options.plot.oriental == "horizontal") { // 가로형
				chart.property.rangeSpacing = w / (chart.options.range.bound.upper - chart.options.range.bound.lower);
				chart.property.zero = chart.property.rangeSpacing * (-1) * chart.options.range.bound.lower;
				
				if (chart.options.range.grid.visibleStep > 0) {
					for (var i = 0; i < chart.options.range.bound.upper; i = i + chart.options.range.grid.visibleStep) {
						if (i != 0) {
							rangeGrid.path = rangeGrid.path.concat([
								"M", 
								Math.round(x + chart.property.zero + i * chart.property.rangeSpacing) + f, 
								Math.round(y) + f, 
								"V", 
								Math.round(y + h) + f
							]);
						}
					}
					for (var i = 0; i > chart.options.range.bound.lower; i = i - chart.options.range.grid.visibleStep) {
						if (i != 0) {
							rangeGrid.path = rangeGrid.path.concat([
								"M", 
								Math.round(x + chart.property.zero + i * chart.property.rangeSpacing) + f, 
								Math.round(y) + f, 
								"V", 
								Math.round(y + h) + f
							]);
						}
					}
				}
				if (chart.options.range.bound.lower < 0 && 0 < chart.options.range.bound.upper) {
					zeroPath = ["M", Math.round(x + chart.property.zero) + f, Math.round(y) + f, "V", Math.round(y + h) + f];
				}
			} else { // 세로형
				chart.property.rangeSpacing = h / (chart.options.range.bound.upper - chart.options.range.bound.lower);
				chart.property.zero = chart.property.rangeSpacing * (-1) * chart.options.range.bound.lower;
				
				if (chart.options.range.grid.visibleStep > 0) {
					for (var i = 0; i < chart.options.range.bound.upper; i = i + chart.options.range.grid.visibleStep) {
						if (i != 0) {
							rangeGrid.path = rangeGrid.path.concat([
								"M", 
								Math.round(x) + f, 
								Math.round(y + h - chart.property.zero - i * chart.property.rangeSpacing) + f, 
								"H", 
								Math.round(x + w) + f
							]);
						}
					}
					for (var i = 0; i > chart.options.range.bound.lower; i = i - chart.options.range.grid.visibleStep) {
						if (i != 0) {
							rangeGrid.path = rangeGrid.path.concat([
								"M", 
								Math.round(x) + f, 
								Math.round(y + h - chart.property.zero - i * chart.property.rangeSpacing) + f, 
								"H", 
								Math.round(x + w) + f
							]);
						}
					}
				}
				if (chart.options.range.bound.lower < 0 && 0 < chart.options.range.bound.upper) {
					zeroPath = ["M", Math.round(x) + f, Math.round(y + h - chart.property.zero) + f, "H", Math.round(x + w) + f];
				}
			}
			if (chart.options.range.grid.visibleStep > 0) {
				chart.paper.path(rangeGrid.path.join(",")).attr(rangeGrid.attr).toFront();
			}
		    if (zeroPath != null) {
		    	chart.paper.path(zeroPath.join(",")).attr(chart.property.plotAttr).toFront();
		    }
		};
		var drawRangeTick = function(chart) {
			if (chart.type == "pie") {
				return;
			}
			var width = chart.property.width;
			var height = chart.property.height;
			var m = chart.property.m;
			var x = chart.property.x;
			var y = chart.property.y;
			var w = chart.property.w;
			var h = chart.property.h;
			var rangeTick = []; 
			var rangeTickAttr = {
				"font-size" : chart.options.range.tick.font.size, 
				"font-family" : chart.options.range.tick.font.family, 
				"fill" : chart.options.range.tick.font.color
			};
			if (chart.options.plot.oriental == "horizontal") { // 가로형
				if (chart.options.range.tick.visibleStep > 0) {
					for (var i = 0; i <= chart.options.range.bound.upper; i = i + chart.options.range.tick.visibleStep) {
						if (i != 0) {
							rangeTick.push({
								pos : {
									x : Math.round(x + chart.property.zero + i * chart.property.rangeSpacing), 
									y : Math.round(y + h)
								},
								value : Math.round(i)
							});
						}
					}
					if (chart.options.range.bound.lower < 0 && 0 < chart.options.range.bound.upper) {
						rangeTick.push({
							pos : {
								x : Math.round(x + chart.property.zero), 
								y : Math.round(y + h)
							},
							value : Math.round(0)
						});
					}
					for (var i = 0; i >= chart.options.range.bound.lower; i = i - chart.options.range.tick.visibleStep) {
						if (i != 0) {
							rangeTick.push({
								pos : {
									x : Math.round(x + chart.property.zero + i * chart.property.rangeSpacing), 
									y : Math.round(y + h)
								},
								value : Math.round(i)
							});
						}
					}
				}
			} else { // 세로형
				if (chart.options.range.tick.visibleStep > 0) {
					for (var i = 0; i <= chart.options.range.bound.upper; i = i + chart.options.range.tick.visibleStep) {
						if (i != 0) {
							rangeTick.push({
								pos : {
									x : Math.round(x), 
									y : Math.round(y + h - chart.property.zero - i * chart.property.rangeSpacing)
								},
								value : Math.round(i)
							});
						}
					}
					if (chart.options.range.bound.lower < 0 && 0 < chart.options.range.bound.upper) {
						rangeTick.push({
							pos : {
								x : Math.round(x), 
								y : Math.round(y + h - chart.property.zero)
							},
							value : Math.round(0)
						});
					}
					for (var i = 0; i >= chart.options.range.bound.lower; i = i - chart.options.range.tick.visibleStep) {
						if (i != 0) {
							rangeTick.push({
								pos : {
									x : Math.round(x), 
									y : Math.round(y + h - chart.property.zero - i * chart.property.rangeSpacing)
								},
								value : Math.round(i)
							});
						}
					}
				}
			}
			for (var i = 0; i < rangeTick.length; i++) {
				var text = chart.paper.text(rangeTick[i].pos.x, rangeTick[i].pos.y, rangeTick[i].value).attr(rangeTickAttr);
				var box = text.getBBox(true);
				if (chart.options.plot.oriental == "horizontal") {
					text.attr({y : Math.round(chart.property.y + chart.property.h + box.height) + f});
				} else {
					text.attr({x : Math.round(chart.property.x - (box.width/2) - 7) + f});
				}
				text.toFront();
			}
		};
		var drawDomainGrid = function(chart) {
			var x = chart.property.x;
			var y = chart.property.y;
			var w = chart.property.w;
			var h = chart.property.h;
			var domainGrid = {
				path : [],
				attr : {
					"stroke" : chart.options.domain.grid.color, 
					"stroke-width" : chart.options.domain.grid.lineWidth
				}
			};
			if (chart.options.domain.grid.shape == "dotted") {
				domainGrid.attr["stroke-dasharray"] = dash;
			}
			if (chart.options.plot.oriental == "horizontal") { // 가로형
				if (chart.type == "line") {
					chart.property.domainSpacing = chart.options.domain.tick.count >= 3 ? h / (chart.options.domain.tick.count - 1) : h;
				} else if (chart.type == "bar") {
					chart.property.domainSpacing = chart.options.domain.tick.count >= 2 ? h / chart.options.domain.tick.count : h;
				} else if (chart.type == "pie") {
					chart.property.domainSpacing = chart.options.domain.tick.count >= 2 ? h / chart.options.domain.tick.count : h;
				}
				if (chart.options.domain.grid.visibleStep > 0) {
					for (var i = 0; i < chart.options.domain.tick.count; i++) {
						if (i % chart.options.domain.grid.visibleStep == 0) {
							domainGrid.path = domainGrid.path.concat([
								"M", 
								Math.round(x) + f, 
								Math.round(y + i * chart.property.domainSpacing) + f, 
								"H", 
								Math.round(x + w) + f
							]);
						}
					}
				}
			} else { // 세로형
				if (chart.type == "line") {
					chart.property.domainSpacing = chart.options.domain.tick.count >= 3 ? w / (chart.options.domain.tick.count - 1) : w;
				} else if (chart.type == "bar") {
					chart.property.domainSpacing = chart.options.domain.tick.count >= 2 ? w / chart.options.domain.tick.count : w;
				} else if (chart.type == "pie") {
					chart.property.domainSpacing = chart.options.domain.tick.count >= 2 ? w / chart.options.domain.tick.count : w;
				}
				if (chart.options.domain.grid.visibleStep > 0) {
					for (var i = 0; i < chart.options.domain.tick.count; i++) {
						if (i % chart.options.domain.grid.visibleStep == 0) {
							domainGrid.path = domainGrid.path.concat([
								"M", 
								Math.round(x + i * chart.property.domainSpacing) + f, 
								Math.round(y) + f, 
								"V", 
								Math.round(y + h) + f
							]);
						}
					}
				}
			}		
			if (domainGrid.path.length > 0) {
				chart.paper.path(domainGrid.path.join(",")).attr(domainGrid.attr).toFront();
			}
		};
		var drawDomainTick = function(chart, dataIndex, tickName) {
			if (dataIndex + 1 > chart.options.domain.tick.count) {
				return;
			}
			if (typeof chart.property.domainTick === "object" && typeof chart.property.domainTick[dataIndex] === "object") {
				chart.property.domainTick[dataIndex].attr({text : tickName});
			} else {
				if (typeof chart.property.domainTick === "undefined") {
					chart.property.domainTick = [];
				}
				if (chart.property.domainTick.length < dataIndex + 1) {
					var start = chart.property.domainTick.length;
					for (var i = start; i < dataIndex + 1; i++) {
						chart.property.domainTick.push("");
					}
				}
				var width = chart.property.width;
				var height = chart.property.height;
				var m = chart.property.m;
				var x = chart.property.x;
				var y = chart.property.y;
				var w = chart.property.w;
				var h = chart.property.h;
				var domainTick = null; 
				var domainTickAttr = {
					"font-size" : chart.options.domain.tick.font.size, 
					"font-family" : chart.options.domain.tick.font.family, 
					"fill" : chart.options.domain.tick.font.color
				};
				if (chart.options.plot.oriental == "horizontal") { // 가로형
					if (chart.options.domain.tick.visibleStep > 0 && (dataIndex % chart.options.domain.tick.visibleStep) == 0) {
						domainTick = {
							pos : {
								x : Math.round(x) + f, 
								y : Math.round(y + dataIndex * chart.property.domainSpacing) + f
							},
							value : tickName
						};
						if (chart.type == "bar" || chart.type == "pie") {
							domainTick.pos.y += Math.round(chart.property.domainSpacing / 2);
						}
					}
				} else { // 세로형
					if (chart.options.domain.tick.visibleStep > 0 && (dataIndex % chart.options.domain.tick.visibleStep) == 0) {
						domainTick = {
							pos : {
								x : Math.round(x + dataIndex * chart.property.domainSpacing) + f, 
								y : Math.round(y + h) + f
							},
							value : tickName
						};
						if (chart.type == "bar" || chart.type == "pie") {
							domainTick.pos.x += Math.round(chart.property.domainSpacing / 2);
						}
					}
				}			
				if (domainTick != null) {
					chart.property.domainTick[dataIndex] = chart.paper.text(domainTick.pos.x, domainTick.pos.y, domainTick.value).attr(domainTickAttr).toFront();
				}
			}
			if (typeof chart.property.domainTick === "object" && typeof chart.property.domainTick[dataIndex] === "object") {
				var box = chart.property.domainTick[dataIndex].getBBox(true);
				if (chart.options.plot.oriental == "horizontal") {
					chart.property.domainTick[dataIndex].attr({x : Math.round(chart.property.x - (box.width / 2) - 7) + f});
				} else {
					chart.property.domainTick[dataIndex].attr({y : Math.round(chart.property.y + chart.property.h + box.height) + f});
				}
				chart.property.domainTick[dataIndex].toFront();
			}
		};
		var drawPoint = function(chart, groupIndex, dataIndex) {
			var width = chart.property.width;
			var height = chart.property.height;
			var space = chart.property.domainSpacing;
			var zero = chart.property.zero;
			var m = chart.property.m;
			var x = chart.property.x;
			var y = chart.property.y;
			var w = chart.property.w;
			var h = chart.property.h;

			var data = chart.dataSet[groupIndex].data[dataIndex];
			if (typeof data.value !== "number") {
				return;
			}
			
			var ro = h / (chart.options.range.bound.upper - chart.options.range.bound.lower);
			if (chart.options.plot.oriental == "horizontal") {
				ro = w / (chart.options.range.bound.upper - chart.options.range.bound.lower);
			}
			data.pos.x = chart.options.plot.oriental == "horizontal" ? Math.round(zero + ro * data.value) + f : Math.round(dataIndex * space) + f;
			data.pos.y = chart.options.plot.oriental == "horizontal" ? Math.round(dataIndex * space) + f : Math.round(h - zero - ro * data.value) + f;
			
			if (chart.type == "line") {
				if (chart.options.data.dotShape == "round") {
					chart.plot.circle(data.pos.x, data.pos.y, chart.options.data.dotWidth).attr(data.attr).toBack();
				} else if (chart.options.data.dotShape == "square") {
					chart.plot.rect(data.pos.x - chart.options.data.dotWidth, data.pos.y - chart.options.data.dotWidth, chart.options.data.dotWidth * 2, chart.options.data.dotWidth * 2).attr(data.attr).toBack();
				}
			} else if (chart.type == "bar") {
				if (chart.options.plot.oriental == "horizontal") {
					data.pos.y += Math.round(space / (chart.dataSet.length + 1) * (groupIndex + 1));
				} else {
					data.pos.x += Math.round(space / (chart.dataSet.length + 1) * (groupIndex + 1));
				}
			}
			if (chart.options.data.label.visible == true) {
				var text = chart.plot.text(data.pos.x, data.pos.y, data.value).attr(data.label.attr);
				var box = text.getBBox(true);
				
				var sp1 = chart.type == "line" ? chart.options.data.dotWidth * 2 : 0;
				var sp2 = 3;
				switch (chart.options.data.label.position) {
				case "left":
					text.attr({x : data.pos.x - (box.width / 2) - sp1 - sp2});
					break;
				case "right":
					text.attr({x : data.pos.x + (box.width / 2) + sp1 + sp2});
					break;
				case "bottom":
					text.attr({y : data.pos.y + (box.height / 2) + sp1});
					break;
				case "top":
				default :
					text.attr({y : data.pos.y - (box.height / 2) - sp1});
					break;
				}
				box = text.getBBox(true);
				if (chart.options.plot.overflow != "scroll" || chart.options.plot.oriental != "vertical") {
					if (box.x <= f) {
						text.attr({x : data.pos.x + (0 - box.x)});
					}
					if (box.x2 > w) {
						text.attr({x : data.pos.x - (box.x2 - w)});
					}
				}
				if (chart.options.plot.overflow != "scroll" || chart.options.plot.oriental != "horizontal") {
					if (box.y <= f) {
						text.attr({y : (box.height / 2)});
					}
					if (box.y2 > h) {
						text.attr({y : h - (box.height / 2)});
					}
				}
				text.toFront();
			}
			if (chart.options.plot.overflow == "scroll") {
				if (chart.options.plot.oriental == "horizontal") {
					if (data.pos.y >= chart.property.h) {
						chart.property.overflow = dataIndex;
					}
				} else {
					if (data.pos.x >= chart.property.w) {
						chart.property.overflow = dataIndex;
					}
					
				}
			}
		};
		var drawLine = function(chart, groupIndex, dataIndex) {
			if (dataIndex == 0) {
				return;
			}
			var data1 = chart.dataSet[groupIndex].data[dataIndex - 1];
			var data2 = chart.dataSet[groupIndex].data[dataIndex];
			if (typeof data1.value !== "number" || typeof data2.value !== "number") {
				return;
			}
			var attr = {
				"stroke" : chart.options.data.colors[groupIndex], 
				"stroke-width" : chart.options.data.lineWidth
			};
			var line = [];
			line = line.concat(["M", data1.pos.x, data1.pos.y]); 
			line = line.concat(["L", data2.pos.x, data2.pos.y]); 
			chart.plot.path(line.join(",")).attr(attr).toBack();
		};
		var drawBar = function(chart, groupIndex, dataIndex) {
			var data = chart.dataSet[groupIndex].data[dataIndex];
			if (typeof data.value !== "number") {
				return;
			}
			var attr = {
				"fill" : chart.options.data.colors[groupIndex], 
				"stroke" : chart.options.data.barBorderColor, 
				"stroke-width" : chart.options.data.barBorderWidth
			};
			if (chart.options.plot.oriental == "horizontal") {
				chart.plot.rect(0, Math.round(data.pos.y - chart.options.data.barWidth / 2) + f, data.pos.x, chart.options.data.barWidth).attr(attr).toBack();
			} else {
				chart.plot.rect(Math.round(data.pos.x - chart.options.data.barWidth / 2) + f, data.pos.y, chart.options.data.barWidth, chart.property.h - data.pos.y).attr(attr).toBack();
			}
		};
		var drawPie = function(chart, dataIndex) {
			var data = [];
			for (var groupIndex = 0; groupIndex < chart.dataSet.length; groupIndex++) {
				data.push(chart.dataSet[groupIndex].data[dataIndex]);
			}
			var m = chart.property.m;
			var x = chart.property.x;
			var y = chart.property.y;
			var w = chart.property.w;
			var h = chart.property.h;
			var circle = {x : 0, y : 0, r : 0}
			if (chart.options.plot.oriental == "horizontal") { // 가로형
				circle.r = Math.round(Math.min(chart.property.domainSpacing, w) / 3);
				circle.x = Math.round(x + (w / 2)) + f;
				circle.y = Math.round(y + dataIndex * chart.property.domainSpacing) + Math.round(chart.property.domainSpacing / 2) + f;
			} else { // 세로형
				circle.r = Math.round(Math.min(chart.property.domainSpacing, h) / 3);
				circle.x = Math.round(x + dataIndex * chart.property.domainSpacing) + Math.round(chart.property.domainSpacing / 2) + f;
				circle.y = Math.round(y + (h / 2)) + f;
			}
			
			var radian = Math.PI / 180;
			var total = 0;
			var startAngle = chart.options.data.startAngle;
			for (var i = 0; i < data.length; i++) {
				total += data[i].value;
			}
			for (var i = 0; i < data.length; i++) {
				var plusAngle = 360 * data[i].value / total;
				var endAngle = startAngle + plusAngle;
				var textAngle = startAngle + (plusAngle / 2);
				var x1 = circle.x + circle.r * Math.cos(-startAngle * radian);
	            var x2 = circle.x + circle.r * Math.cos(-endAngle * radian);
	            var y1 = circle.y + circle.r * Math.sin(-startAngle * radian);
	            var y2 = circle.y + circle.r * Math.sin(-endAngle * radian);
	            var path = [];
	            path.push(["M", circle.x, circle.y]);
	            path.push(["L", x1, y1]);
	            path.push(["A", circle.r, circle.r, 0, +(endAngle - startAngle > 180), 0, x2, y2]);
	            path.push(["z"]);
	            var pie = chart.paper.path(path.join(","));
	            pie.attr({
					"fill" : chart.options.data.colors[i],
					"stroke" : chart.options.data.pieBorderColor, 
					"stroke-width" : chart.options.data.pieBorderWidth
				});
				var space = chart.options.data.label.position == "in" ? - Math.round(circle.r / 3) : Math.round(circle.r / 3);
				if (chart.options.data.label.visible == true) {
					var text = chart.paper.text(circle.x + (circle.r + space) * Math.cos(-textAngle * radian), 
						circle.y + (circle.r + space) * Math.sin(-textAngle * radian), data[i].originalValue);
					text.attr(data[i].label.attr);
				}
				startAngle += plusAngle;
			}
		};
		var drawLegend = function(chart, groupIndex) {
			if (chart.options.legend.visible == false) {
				return;
			}
			var $legend = chart.$this.find(".legend");
			if ($legend.length == 0) {
				var legend = [];
				legend.push("<div class='legend' ");
				if (chart.options.legend.style != "") {
					legend.push("style='" + chart.options.legend.style + "'");
				}
				legend.push("></div>");
				$legend = jQuery(legend.join("")); 
				$legend.appendTo(chart.$this);
			}
			var legend = [];
			legend.push("<span style='color:"+ chart.options.data.colors[groupIndex] +";'>" + (chart.options.data.dotShape == "square" ? "■" : "●") + "</span>");
			legend.push("<span style='margin:0px 15px 0px 5px;'>" + chart.dataSet[groupIndex].groupName + "</span>");
			jQuery(legend.join("")).appendTo($legend);
		};
		var drawData = function(chart, dataIndex) {

			if (chart.type == "line") {
				dataIndex = clearViewBox(chart, dataIndex);
			}
			
			drawDomainTick(chart, dataIndex, chart.property.domainTickName[dataIndex]);
			
			if (chart.type == "line" || chart.type == "bar") {
				for (var groupIndex = 0; groupIndex < chart.dataSet.length; groupIndex++) {
					drawPoint(chart, groupIndex, dataIndex); // 점
				
					if (chart.type == "line") {
						drawLine(chart, groupIndex, dataIndex); // 라인
					} else if (chart.type == "bar") {
						drawBar(chart, groupIndex, dataIndex); // 막대
					}
				}
			} else if (chart.type == "pie") {
				drawPie(chart, dataIndex); // 파이
			}
			
			if (chart.type == "line") {
				scrollViewBox(chart); // scroll
			}
		};
		var clearViewBox = function(chart, dataIndex) {
			if (jQuery.browser.msie && parseInt(jQuery.browser.version, 10) < 9) {
				chart.options.plot.scrollBuffers = chart.options.domain.tick.count;
			}
			if (chart.property.overflow + 1 >= chart.options.plot.scrollBuffers) {
				chart.plot.clear();
				for (var i = 0; i < chart.property.domainTick.length; i++) {
					if (typeof chart.property.domainTick[i] === "object") {
						chart.property.domainTick[i].attr({text : " "});
					}
				}
				chart.property.domainTickName = [].concat(chart.property.domainTickName.pop());
				for (var i = 0; i < chart.dataSet.length; i++) {
					chart.dataSet[i].data = [].concat(chart.dataSet[i].data.pop());
				}
				chart.plot.setViewBox(0, 0, chart.plot.width, chart.plot.height);
				chart.property.overflow = undefined;
				dataIndex = 0;
			} 
			return dataIndex;
		};
		var scrollViewBox = function(chart) {
			if (chart.options.plot.overflow == "scroll" && typeof chart.property.overflow === "number") {
				for (var i = 0; i < chart.options.domain.tick.count; i++) {
					var index = chart.property.overflow - (chart.options.domain.tick.count - i) + 1;
					var tickName = typeof chart.property.domainTickName[index] === "string" ? chart.property.domainTickName[index] : "";
					drawDomainTick(chart, i, tickName);
				}
				var sp = (chart.property.overflow - chart.options.domain.tick.count + 1) * chart.property.domainSpacing;
				if (chart.options.plot.oriental == "horizontal") {
					chart.plot.setViewBox(0, sp, chart.plot.width, chart.plot.height);
				} else {
					chart.plot.setViewBox(sp, 0, chart.plot.width, chart.plot.height);
				}
			}
		};
		var makeData = function(options, index, value) {
			var originalValue = value;
			value = parseFloat(value);
			if (isNaN(value)) {
				value = " ";
			}
			return {
				"value" : value,
				"originalValue" : originalValue,
				"pos" : {x : 0, y : 0},
				"width" : options.data.dotWidth,
				"attr" : {
					"fill": options.data.colors[index], 
					"stroke": options.data.colors[index], 
					"stroke-width": options.data.dotWidth
				},
				"label" : {
					"pos" : {x : 0, y : 0},
					"attr" : {
						"font-size" : options.data.label.font.size, 
						"font-family" : options.data.label.font.family, 
				    	"fill" : options.data.label.font.color
					}
				}
			};
		};
		var getDataSetTableData = function(table) {
			var tableData = {
				groupName : [],
				groupData : [],
				tickName : []
			};
			for (var i = 1; i < table.rows[0].cells.length; i++) {           // 첫째줄은 그룹 제목
				tableData.groupName.push($(table.rows[0].cells[i]).text());      
			}
			for (var i = 1; i < table.rows.length; i++) {                    // 둘째줄부터 데이타
				tableData.tickName.push($(table.rows[i].cells[0]).text());   // 첫째열은 도메인 tickname

				var data = [];
				for (var j = 1; j < table.rows[i].cells.length; j++) {              
					data.push($(table.rows[i].cells[j]).text());
				}
				tableData.groupData.push(data);
			}
			return tableData;
		};
		var createChart = function(type, elementId, options) {
			
			var chart = null;
			var $element = jQuery("#" + elementId);
			var elementWidth = $element.width();
			
			if (type == "line") {
				chart = new linechart();
				options = $.extend(true, lineChartDefault, options);
			} else if (type == "bar") {
				chart = new barchart();
				options = $.extend(true, barChartDefault, options);
			} else if (type == "pie") {
				chart = new piechart();
				options = $.extend(true, pieChartDefault, options);
			}
			chart.options = options;

			if ($element.get(0).tagName.toLowerCase() === "table") {
				chart.tableData = getDataSetTableData($element.get(0));
				var $chart = jQuery("<div></div>");
				$element.replaceWith($chart);
				chart.$this = $chart;
			} else {
				chart.$this = $element;
			}
			
			chart.$divPaper = jQuery("<div></div>");
			chart.$divPaper.css(options.chartCss);
			chart.$divPaper.css({"position" : "relative"});
			chart.$divPaper.appendTo(chart.$this);

			chart.$divPlot = jQuery("<div></div>");
			chart.$divPlot.appendTo(chart.$divPaper);

			chart.$this.width(chart.$divPaper.width());

			var m = chart.options.plot.margin;
			chart.property.width = chart.$divPaper.width();
			chart.property.height = chart.$divPaper.height();
			chart.property.m = m;
			chart.property.x = m.left;
			chart.property.y = m.top;
			chart.property.w = chart.property.width - m.left - m.right;
			chart.property.h = chart.property.height - m.top - m.bottom;

			chart.$divPlot.css({
				position : "absolute", 
				left : m.left + "px", 
				top : m.top + "px", 
				width : chart.property.w + "px", 
				height : chart.property.h + "px"
			});

			chart.paper = Raphael(chart.$divPaper.get(0));
			chart.plot = Raphael(chart.$divPlot.get(0));
			
			drawPlot(chart);
			if (type == "line" || type == "bar") {
				drawRangeLabel(chart);
				drawRangeGrid(chart);
				drawRangeTick(chart);
			}

			drawDomainLabel(chart);
			if (chart.tableData != null) {
				for (var i = 0; i < chart.tableData.groupName.length; i++) {
					chart.appendGroup(chart.tableData.groupName[i]);
				}
				for (var i = 0; i < chart.tableData.tickName.length; i++) {
					chart.appendTickname(chart.tableData.tickName[i]);
				}
				chart.options.domain.tick.count = Math.max(chart.options.domain.tick.count, chart.property.domainTickName.length);
			}
			drawDomainGrid(chart);
			if (chart.tableData != null) {
				for (var i = 0; i < chart.tableData.groupData.length; i++) {
					chart.append.apply(chart, chart.tableData.groupData[i]);
				}
			}
			return chart;
		};
		switch(chart) {
		case "linechart":
			return createChart("line", elementId, options); 
			break;
		case "barchart":
			return createChart("bar", elementId, options);
			break;
		case "piechart":
			return createChart("pie", elementId, options);
			break;
		}
	};
	$.linechart = function(elementId, options) {
		return chart("linechart", elementId, options);
	};
	$.barchart = function(elementId, options) {
		return chart("barchart", elementId, options);
	};
	$.piechart = function(elementId, options) {
		return chart("piechart", elementId, options);
	};

})(jQuery);

