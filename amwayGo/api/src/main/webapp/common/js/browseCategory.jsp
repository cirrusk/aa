<%@ page pageEncoding="UTF-8" contentType="text/javascript; charset=UTF-8"%><%@ include file="/WEB-INF/view/include/taglibs.jspf"%>
/**
    <script type="text/javascript" src="<c:url value="/common/js/browseCategory.jsp"/>"></script>
 	BrowseCategory.create({
 		"categoryTypeCd" : "CATEGORY_TYPE::DEGREE", // 교과목 구분
 		"yearTerm" : "", // 년도학기
		"callback" : "doSetCategorySeq",
		"selectedSeq" : "10",
		"appendToId" : "categoryStep",
		"selectOption" : "" // regist : 등록시에 마지막 단계 선택값을 callback 함수에 리턴한다
	});
 */
(function() {
	var methods = {
		create : function(options) {
			var _public = {

			};
			if (options.categoryTypeCd == "") {
				return;
			}
			var $options = jQuery("<input type='hidden' name='options'/>");
			$options.attr({
				categoryTypeCd : options.categoryTypeCd,
				yearTerm : options.yearTerm,
				callback : options.callback,
				selectedSeq : options.selectedSeq,
				appendToId : options.appendToId,
				selectOption : options.selectOption
			});	
			$options.appendTo(jQuery("#" + options.appendToId));
			
			if (options.selectedSeq == "" || options.selectedSeq == "0") {
				methods.levelList($options.get(0), 1);
			} else {
				methods.parentList($options.get(0));
			}
			return _public;
		},
		getOptions : function(element) {
			var $options = jQuery(element);
			if (element.tagName.toUpperCase() == "SELECT") {
				$options = jQuery(element).siblings(":input[name='options']");
			}
			return {
				categoryTypeCd : $options.attr("categoryTypeCd"),
				yearTerm : $options.attr("yearTerm"),
				callback : $options.attr("callback"),
				selectedSeq : $options.attr("selectedSeq"),
				appendToId : $options.attr("appendToId"),
				selectOption : $options.attr("selectOption")
			}
		}, 
		levelList : function(element, level) {
			var options = methods.getOptions(element);
			var comboName = methods.getComboName(level);
			
			var $combo = jQuery(element).siblings("select[name^='" + comboName + "']");
			if ($combo.length > 0) {
				$combo.remove();
			}
			var srch = {
				"seq" : 0,
				"level" : level,
				"child" : 1
			}
			if (element.tagName.toUpperCase() === "SELECT") {
				var selectedIndex = element.selectedIndex;
				
				srch.seq = element.options[selectedIndex].value;
				srch.child = parseInt(jQuery(element.options[selectedIndex]).attr("child"), 10);
	
				methods.callbackValue(element, options);
				if (selectedIndex == 0) {
					return;
				}
			}
			if (srch.child > 0) {
				var param = [];
				param.push("srchCategoryTypeCd=" + options.categoryTypeCd);
				if(level > 1) {
					param.push("srchYearTerm=" + options.yearTerm);
				}
				param.push("srchParentSeq=" + srch.seq);
				param.push("srchGroupLevel=" + srch.level);
				
				var action = $.action("ajax");
				action.config.type        = "json";
				action.config.url         = "<c:url value="/category/list/json.do"/>";
				action.config.parameters  = param.join("&");
				action.config.fn.complete = function(action, data) {
					if (data != null) {
						var object = methods.generateCombo(options, data.list, level);
						if (object != null) {
							object.combo.appendTo(jQuery("#" + options.appendToId));
							if (srch.level == 1) {
								object.combo.trigger("change");
							}
							methods.callbackValue(object.combo.get(0), options);
						}
					}
				};
				action.run();
			}
		},
		parentList : function(element) {
			var options = methods.getOptions(element);
		
			var param = [];
			param.push("srchCategoryTypeCd=" + options.categoryTypeCd);
			param.push("categorySeq=" + options.selectedSeq);
	
			var action = $.action("ajax");
			action.config.type        = "json";
			action.config.url         = "<c:url value="/category/parent/list/json.do"/>";
			action.config.parameters  = param.join("&");
			action.config.fn.complete = function(action, data) {
				if (data != null) {
					var $prevCombo = null;
					var selectedSeq = options.selectedSeq;
					if (data.list != null) {
						var maxLevel = 1;
						for (var i = 0; i < data.list.length; i++) {
							maxLevel = Math.max(parseInt(data.list[i].category.groupLevel, 10), maxLevel);
						}
						for (var level = maxLevel; level >= 1; level--) {
							var list = [];
							for (var i = 0; i < data.list.length; i++) {
								if (parseInt(data.list[i].category.groupLevel, 10) == level) {
									list.push(data.list[i]);
								}
							}
							var object = methods.generateCombo(options, list, level, selectedSeq);
							if (object != null) {
								if (level == maxLevel) {
									object.combo.appendTo(jQuery("#" + options.appendToId));
								} else {
									object.combo.insertBefore($prevCombo);
								}
								$prevCombo = object.combo;
								selectedSeq = object.selectedSeq;
							}
						}
					}
				}
			};
			action.run();
		},
		generateCombo : function(options, list, level, selectedSeq) {
			if (list != null && list.length > 0) {
				var comboName = methods.getComboName(level);
				var html = [];
				html.push("<select name='" + comboName + "' onchange='BrowseCategory.levelList(this, " + (level + 1) + ")'");
				if (level == 1) {
					html.push(" style='display:none'");
				}
				html.push(">");
				html.push("<option value=''></option>");
				for (var i = 0; i < list.length; i++) {
					var cat = list[i];
					html.push("<option value='" + cat.category.categorySeq + "' child='" + cat.category.childCount + "'");
					if ((typeof selectedSeq !== "undefined" && selectedSeq == cat.category.categorySeq) || (level == 1)) {
						html.push(" selected='selected' ");
						selectedSeq = cat.category.parentSeq;
					}
					html.push(">" + cat.category.categoryName + "</option>");
				}
				html.push("</select>");
				return {"combo" : jQuery(html.join("")), "selectedSeq" : selectedSeq};
			} else {
				return null;
			}
		},
		callbackValue : function(element) {
			var options = methods.getOptions(element);
			if (options.callback != "") {
				var seq = "";
				jQuery("#" + options.appendToId).find("select[name^='" + methods.getComboName(2) + "']").each(function() {
					if (options.selectOption == "regist") {
						seq = this.value;
					} else {
						if (this.value != "") {
							seq = this.value;
						}
					}
				});
				eval(options.callback + "(" + seq + ")");
			}
		},
		getComboName : function(level) {
			var id = [];
			id.push("_category_");
			for (var i = 0; i < level; i++) {
				id.push("1");			
			}
			return id.join("");
		}
	};
	BrowseCategory = {
		create : function(options) {
			return methods.create.apply(this, arguments);
		},
		levelList : function(element, level) {
			methods.levelList(element, level);
		}
	};
})();