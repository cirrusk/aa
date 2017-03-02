<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/framework/include/header_reservation.jsp"%>
<%@ include file="/WEB-INF/jsp/framework/include/layerPop.jsp"%>

<!-- //Adobe Analytics Header 호출 include -->
<%@ include
	file="/WEB-INF/jsp/framework/include/inc_analyticsHeader.jsp"%>

<script type="text/javascript">
	var ppSeq = "";
	var ppName = "";
	var expseq = "";
	var typeseq = "";

	$(document.body)
			.ready(
					function() {

						$("#stepDone").hide();
						$(".brSelectWrap").show();

						setPpInfoList();

						$("#step1Btn")
								.on(
										"click",
										function() {
											if (selectCheckedPp() == true) {
												if ($("#appendToSession")
														.children().length <= 1) {

													/* 패널티 정보 조회 */
													searchExpPenalty();

													nextMonthCalendar("F");
												}
											}

										});

						$(".btnBasicGS").on("click", function() {
							$("#tempResult").show();

						});

						$(".btnBasicGL")
								.on(
										"click",
										function() {
											location.href = "<c:url value='${pageContext.request.contextPath}/reservation/expSkinForm.do'/>";
										});
					});

	function selectCheckedPp() {
		if ($("#ppAppend").children().length == 0
				|| $("#ppAppend").children().is(".on") == false) {
			alert("PP를 선택해 주십시오.");

			/* step2 열기 */
			$("#step1Btn").parents('.brWrap').find('.modifyBtn').hide();
			$("#step1Btn").parents('.brWrap').find('.result').hide();
			$("#step1Btn").parents('.brWrap').find('.sectionWrap').stop()
					.slideDown(
							function() {
								$("#step1Btn").parents('.brWrap').find(
										'.stepTit').find('.close').hide();
								$("#step1Btn").parents('.brWrap').find(
										'.stepTit').find('.open').show();
								$("#step1Btn").parents('.brWrap').removeClass(
										'finish').addClass('current');
							});

			$("#step2Btn").parents('.brWrap').find('.sectionWrap').stop()
					.slideUp(
							function() {
								$("#step2Btn").parents('.brWrap').find(
										'.stepTit').find('.close').show();
								$("#step2Btn").parents('.brWrap').find(
										'.stepTit').find('.open').hide();

								$("#ststep2Btnep1Btn").parents('.brWrap').find(
										'.modifyBtn').show();
								$("#step2Btn").parents('.brWrap').find('.req')
										.show(); //결과값 보기
								$("#step2Btn").parents('.brWrap').removeClass(
										'current').addClass('finish');
							});

			return false;
		} else {
			return true;
		}
	}

	function viewRsvConfirm() {
		var frm = document.expSkinForm
		var url = "<c:url value="/reservation/expSkinRsvConfirmPop.do"/>";
		var title = "testpop";
		var status = "toolbar=no, width=754, height=900, directories=no, status=no, scrollbars=yes, resizable=no";
		window.open("", title, status);

		frm.target = title;
		frm.action = url;
		frm.method = "post";
		frm.submit();
	}

	/* 월 변경시 on클래스 먹이기,  파라미터값 셋팅  */
	function changeMonth(obj, year, month) {

		var msg = "해당월에 선택된 세션리스트는 삭제됩니다.";

		/* 해당 날짜의 세션리스트 가 있음 경고창 */
		if ($("#appendToSession").children().hasClass("tblDetailHead") == true) {

			if (confirm(msg) == true) {
				var html = "";

				/* 해딩 세션 리스트 삭제 */
				$(".tblDetailHead").remove();

				/* 파라미터로 쓰일 년월 초기화 */
				$("#getYear").val("");
				$("#getMonth").val("");

				/* 월 두 자릿수 맞추기 */
				if (month < 10) {
					$("#getMonth").val("0" + month);
					$("#getYear").val(year);
				} else {
					$("#getYear").val(year);
					$("#getMonth").val(month);
				}

				/* 기존 월에 on을 지우기 */
				$("#viewTempMonth").each(function() {
					if ($(this).children().children().is(".on") === true) {
						$(this).children().children().removeClass("on");
					}
				});
				/* 새로 클릭한 월에 on걸기 */
				$(obj).addClass("on");

				/* 선택한 월로 셋팅 */
				$("#calMonth").empty();
				$("#calMonth").append(month + "월 예약가능 잔여회수");

				$(".noSelectDate").show();

				/* 달력 다시 그리는 함수 호출 */
				nextMonthCalendar("C");

			} else {
				return false;
			}
		} else {
			/* 선택된 세션이 없음  */
			$("#getYear").val("");
			$("#getMonth").val("");

			if (month < 10) {
				$("#getMonth").val("0" + month);
				$("#getYear").val(year);
			} else {
				$("#getYear").val(year);
				$("#getMonth").val(month);
			}

			$("#viewTempMonth").each(function() {
				if ($(this).children().children().is(".on") === true) {
					$(this).children().children().removeClass("on");
				}
			});
			$(obj).addClass("on");

			$("#calMonth").empty();
			$("#calMonth").append(month + "월 예약가능 잔여회수");

			nextMonthCalendar("C");
		}

	}

	/* 잔여일 표시 - 달력의 '월'을 클릭 후 우상단에 남은 잔여일을 쿼리 하는 기능 */
	function getRemainDayByMonth() {
		var param = {
			reservationdate : $("#getYear").val() + $("#getMonth").val() + "01",
			rsvtypecode : "R02",
			ppseq : ppSeq,
			typeseq : typeseq,
			expseq : expseq
		};

		$.ajaxCall({
			url : "<c:url value='/reservation/getRemainDayByMonthAjax.do'/>",
			type : "GET",
			data : param,
			async : false,
			success : function(data, textStatus, jqXHR) {
				if (data) {
					$("#remainDay").empty();
					$("#remainDay").append(data.remainDay);
				} else {
					$("#remainDay").empty();
					$("#remainDay").append("0");
				}
			},
			error : function(jqXHR, textStatus, errorThrown) {
				var mag = '<spring:message code="errors.load"/>';
				alert(mag);
			}
		});
	}

	function setCalendarClassName(yearMonthList) {

		var html = "";

		//html += "<span class='year'><img src='/_ui/desktop/images/academy/img_2016.gif' alt="+yearMonthList[0].year+"년/></span>";
		html += "<div class='monthlyWrap' id='viewTempMonth'>";

		for (var i = 0; i < yearMonthList.length; i++) {

			if (i >= 7) {
				break;
			}

			if (i == 0) {
				html += "	<span><a href='javascript:void(0);' class='"
						+ yearMonthList[i].engmonth
						+ " on' onclick=\"javascript:changeMonth(this, '"
						+ yearMonthList[i].year + "', '"
						+ yearMonthList[i].month + "');\">"
						+ yearMonthList[i].month + "월</a></span>";
			} else {
				html += "	<span><a href='javascript:void(0);' class='"
						+ yearMonthList[i].engmonth
						+ "' onclick=\"javascript:changeMonth(this, '"
						+ yearMonthList[i].year + "', '"
						+ yearMonthList[i].month + "');\">"
						+ yearMonthList[i].month + "월</a></span>";
			}
		}
		// 	html += "	<span><a href='javascript:void(0);' class='"+yearMonthList[1].engmonth+"' onclick=\"javascript:changeMonth(this, '"+yearMonthList[1].year+"', '"+yearMonthList[1].month+"');\">"+yearMonthList[1].month+"월</a></span>";
		// 	html += "	<span><a href='javascript:void(0);' class='"+yearMonthList[2].engmonth+"' onclick=\"javascript:changeMonth(this, '"+yearMonthList[2].year+"', '"+yearMonthList[2].month+"');\">"+yearMonthList[2].month+"월</a></span>";
		html += "</div>";
		html += "<div class='hText availabilityCount'>";
		html += "</div>";

		$("#getYearPop").val(yearMonthList[0].year);

		if (yearMonthList[0].month < 10) {
			$("#getMonthPop").val("0" + yearMonthList[0].month);
		}

		$("#ppName").empty();
		$("#ppName").append(ppName);

		$("#appendYYMM").empty();
		$("#appendYYMM").append(html);

		//  	getRemainDayByMonth();

	}

	function setPpInfoList() {
		$
				.ajaxCall({
					url : "<c:url value="/reservation/searchExpSkinPpInfoListAjax.do"/>",
					type : "POST",
					async : false,
					success : function(data, textStatus, jqXHR) {
						var ppList = data.ppCodeList;
						var lastPp = data.searchLastRsvPp;

						if (null == ppList || "" == ppList) {
							alert("아직 프로그램이 등록되지 않았습니다. 운영자에 의해 프로그램이 등록 된 이후 사용 바랍니다.");
							return;
						}

						/**-----------------------캘린더의 필요한 현재 년,월 파라미터  셋팅-----------------------------*/
						var getMonth;
						var getYear;
						if (data.ppCodeList[0].getmonth < 10) {
							getMonth = "0" + data.ppCodeList[0].getmonth;
							getYear = data.ppCodeList[0].getyear;
						} else {
							getMonth = data.ppCodeList[0].getmonth;
							getYear = data.ppCodeList[0].getyear;
						}

						$("#getYear").val("");
						$("#getMonth").val("");

						$("#getYear").val(getYear);
						$("#getMonth").val(getMonth);

						$("#getYearPop").val("");
						$("#getMonthPop").val("");

						$("#getYearPop").val(getYear);
						$("#getMonthPop").val(getMonth);

						/**-----------------------------------------------------------------------------*/

						var html = "";

						for (var i = 0; i < ppList.length; i++) {
							if (ppList[i].ppseq == lastPp.ppseq) {
								html += "<a href='javascript:void(0);' class = 'on' id='detailPpSeq"
										+ ppList[i].ppseq
										+ "' onclick=\"javascript:detailPp('"
										+ ppList[i].ppseq
										+ "', '"
										+ ppList[i].ppname
										+ "', '"
										+ ppList[i].expseq
										+ "');\">"
										+ ppList[i].ppname + "</a>";
								// 					html += "<a href='javascript:void(0);' id='detailPpSeq" + ppList[i].ppseq +"' onclick=\"javascript:detailPp('"+ppList[i].ppseq+"', '"+ppList[i].ppname+"', '"+ppList[i].expseq+"');\">"+ppList[i].ppname+"</a>";

								ppSeq = ppList[i].ppseq;
								ppName = ppList[i].ppname;
								expseq = ppList[i].expseq;

								detailPp(ppList[i].ppseq, ppList[i].ppname,
										ppList[i].expseq);
							} else {
								html += "<a href='javascript:void(0);' id='detailPpSeq"
										+ ppList[i].ppseq
										+ "' onclick=\"javascript:detailPp('"
										+ ppList[i].ppseq
										+ "', '"
										+ ppList[i].ppname
										+ "', '"
										+ ppList[i].expseq
										+ "');\">"
										+ ppList[i].ppname + "</a>";
							}
						}

						$("#ppAppend").empty();
						$("#ppAppend").append(html);

					},
					error : function(jqXHR, textStatus, errorThrown) {
						var mag = '<spring:message code="errors.load"/>';
						alert(mag);
					}
				});
	}

	function searchExpPenalty() {
		var param = {
			expseq : this.expseq
		}

		$.ajaxCall({
			url : "<c:url value="/reservation/searchExpPenaltyAjax.do"/>",
			type : "POST",
			data : param,
			success : function(data, textStatus, jqXHR) {

				var expPenalty = data.searchExpPenalty;

				if (null == data.searchExpPenalty) {
					$("#penaltyInfo").hide();
				} else {
					$("#penaltyInfo").show();
					$("#penaltyInfo").empty();
					$("#penaltyInfo").append(
							"※ 측정 예약 후, 사전 취소 없이 불참하실 경우  <strong id='applyTypeValue'>"
									+ expPenalty.applytypevalue
									+ "일</strong>간 패널티가 적용됩니다.");
				}

			},
			error : function(jqXHR, textStatus, errorThrown) {
				var mag = '<spring:message code="errors.load"/>';
				alert(mag);
			}
		});

	}

	/* 다음달 캘린더의 날짜 호출 한다. */
	function nextMonthCalendar(flag) {

		this.sessionCnt = 0;

		var param = {
			getYear : $("#getYear").val(),
			getMonth : $("#getMonth").val(),
			ppSeq : ppSeq,
			expseq : expseq
		};

		$
				.ajaxCall({
					url : "<c:url value="/reservation/expSkinNextMonthCalendarAjax.do"/>",
					type : "POST",
					data : param,
					success : function(data, textStatus, jqXHR) {

						/* 다음달 날짜 리스트 */
						var calList = data.nextMonthCalendar;

						/* 캘린더에 해당 pp의 휴무일의 정보를 담기 위한 휴무일 데이터 */
						var holiDayList = data.searchExpSkinHoliDayList;

						/* 예약 가능한 세션의 수  */
						var rsvAbleCntList = data.rsvAbleCntList;

						/* 클래스 명으로 사용될 영어 월, 월, 년도 리스트 */
						var yearMonthList = data.nextYearMonth;

						/* 다음달 캘린더를 그리는 함수 호출 */
						gridNextMonth(calList, holiDayList);

						/* 예약 가능한 세션의 수  */
						setRsvAbleCnt(rsvAbleCntList);

						/* calendar 헤더 부분 렌더링 : F = 첫페이지 로딩시 */
						if ($("#getMonthPop").val() == $("#getMonth").val()) {
							// 			if(flag == "F"){
							setCalendarClassName(yearMonthList);
						}

						getRsvAvailabilityCount()

					},
					error : function(jqXHR, textStatus, errorThrown) {
						var mag = '<spring:message code="errors.load"/>';
						alert(mag);
					}
				});

	}

	/* 누적 예약 가능 횟수 (월, 주, 일) 조회 */
	function getRsvAvailabilityCount() {
		var param = {
			ppseq : ppSeq,
			typeseq : typeseq,
			expseq : expseq
		};

		$
				.ajaxCall({
					url : "<c:url value='/reservation/getRsvAvailabilityCountAjax.do'/>",
					type : "POST",
					data : param,
					async : false,
					success : function(data, textStatus, jqXHR) {
						var getRsvAvailabilityCount = data.getRsvAvailabilityCount;

						var cnt = 0;

						var html = "<div class=\"hText availabilityCount\">"
								+ "<span>";

						if (null != getRsvAvailabilityCount) {
							if (null != getRsvAvailabilityCount.ppdailycount
									&& null != getRsvAvailabilityCount.globaldailycount) {
								var dailyCount = getRsvAvailabilityCount.ppdailycount > getRsvAvailabilityCount.globaldailycount ? getRsvAvailabilityCount.globaldailycount
										: getRsvAvailabilityCount.ppdailycount;
								html += "일 <strong>" + dailyCount
										+ "</strong>회 ";
								cnt++;
							} else if (null == getRsvAvailabilityCount.ppdailycount
									&& null != getRsvAvailabilityCount.globaldailycount) {
								html += "일 <strong>"
										+ getRsvAvailabilityCount.globaldailycount
										+ "</strong>회 ";
								cnt++;
							} else if (null != getRsvAvailabilityCount.ppdailycount
									&& null == getRsvAvailabilityCount.globaldailycount) {
								html += "일 <strong>"
										+ getRsvAvailabilityCount.ppdailycount
										+ "</strong>회 ";
								cnt++;
							}

							if (null != getRsvAvailabilityCount.ppweeklycount
									&& null != getRsvAvailabilityCount.globalweeklycount) {
								var weeklyCount = getRsvAvailabilityCount.ppweeklycount > getRsvAvailabilityCount.globalweeklycount ? getRsvAvailabilityCount.globalweeklycount
										: getRsvAvailabilityCount.ppweeklycount;
								html += "주 <strong>" + weeklyCount
										+ "</strong>회 ";
								cnt++;
							} else if (null == getRsvAvailabilityCount.ppweeklycount
									&& null != getRsvAvailabilityCount.globalweeklycount) {
								html += "주 <strong>"
										+ getRsvAvailabilityCount.globalweeklycount
										+ "</strong>회 ";
								cnt++;
							} else if (null != getRsvAvailabilityCount.ppweeklycount
									&& null == getRsvAvailabilityCount.globalweeklycount) {
								html += "주 <strong>"
										+ getRsvAvailabilityCount.ppweeklycount
										+ "</strong>회 ";
								cnt++;
							}

							if (null != getRsvAvailabilityCount.ppmonthlycount
									&& null != getRsvAvailabilityCount.globalmonthlycount) {
								var monthlyCount = getRsvAvailabilityCount.ppmonthlycount > getRsvAvailabilityCount.globalmonthlycount ? getRsvAvailabilityCount.globalmonthlycount
										: getRsvAvailabilityCount.ppmonthlycount;
								html += "월 <strong>" + monthlyCount
										+ "</strong>회 ";
								cnt++;
							} else if (null == getRsvAvailabilityCount.ppmonthlycount
									&& null != getRsvAvailabilityCount.globalmonthlycount) {
								html += "월 <strong>"
										+ getRsvAvailabilityCount.globalmonthlycount
										+ "</strong>회 ";
								cnt++;
							} else if (null != getRsvAvailabilityCount.ppmonthlycount
									&& null == getRsvAvailabilityCount.globalmonthlycount) {
								html += "월 <strong>"
										+ getRsvAvailabilityCount.ppmonthlycount
										+ "</strong>회 ";
								cnt++;
							}

						}

						html += "예약가능</span>" + "</div>";

						$(".availabilityCount").remove();

						if (cnt != 0) {
							$(".calenderHeader").append(html);
						} else if (null == getRsvAvailabilityCount) {
							$(".calenderHeader")
									.append(
											"<div class=\"hText availabilityCount\"></div>");
						} else {
							$(".calenderHeader")
									.append(
											"<div class=\"hText availabilityCount\">-</div>");
						}

					},
					error : function(jqXHR, textStatus, errorThrown) {
						var mag = '<spring:message code="errors.load"/>';
						alert(mag);
					}
				});
	}

	/* 달력 그리기 */
	function gridNextMonth(calList, holiDayList) {
		/* 
			1. 달력을 먼저 그린다.
			2. 그려진 달력에 데이터를 삽입한다.
		 */

		var html = "";
		var yymm = "";
		yymm = $("#getYear").val();
		yymm += $("#getMonth").val();

		var html = "";

		$("#nextMontCalTbody").empty();

		for (var i = 0; i < calList.length; i++) {
			html += "<tr>"
			html += "		<td class='weekSun'><a href='javascript:void(0);' id='cal"
					+ yymm
					+ calList[i].weekSun
					+ "' onclick=\"javascript:deleteSelcOnCal('"
					+ calList[i].weekSun
					+ "');\">"
					+ calList[i].weekSun.replace(/(^0+)/, "");
			+"</a></td>"
			html += "		<td class=''><a href='javascript:void(0);' id='cal"
					+ yymm + calList[i].weekMon
					+ "' onclick=\"javascript:deleteSelcOnCal('"
					+ calList[i].weekMon + "');\">"
					+ calList[i].weekMon.replace(/(^0+)/, "");
			+"</a></td>"
			html += "		<td class=''><a href='javascript:void(0);' id='cal"
					+ yymm + calList[i].weekTue
					+ "' onclick=\"javascript:deleteSelcOnCal('"
					+ calList[i].weekTue + "');\">"
					+ calList[i].weekTue.replace(/(^0+)/, "");
			+"</a></td>"
			html += "		<td class=''><a href='javascript:void(0);' id='cal"
					+ yymm + calList[i].weekWed
					+ "' onclick=\"javascript:deleteSelcOnCal('"
					+ calList[i].weekWed + "');\">"
					+ calList[i].weekWed.replace(/(^0+)/, "");
			+"</a></td>"
			html += "		<td class=''><a href='javascript:void(0);' id='cal"
					+ yymm + calList[i].weekThur
					+ "' onclick=\"javascript:deleteSelcOnCal('"
					+ calList[i].weekThur + "');\">"
					+ calList[i].weekThur.replace(/(^0+)/, "");
			+"</a></td>"
			html += "		<td class=''><a href='javascript:void(0);' id='cal"
					+ yymm + calList[i].weekFri
					+ "' onclick=\"javascript:deleteSelcOnCal('"
					+ calList[i].weekFri + "');\">"
					+ calList[i].weekFri.replace(/(^0+)/, "");
			+"</a></td>"
			html += "		<td class='weekSat'><a href='javascript:void(0);' id='cal"
					+ yymm
					+ calList[i].weekSat
					+ "' onclick=\"javascript:deleteSelcOnCal('"
					+ calList[i].weekSat
					+ "');\">"
					+ calList[i].weekSat.replace(/(^0+)/, "");
			+"</a></td>"
			html += "</tr>";
		}
		$("#nextMontCalTbody").append(html);

		/* 해당 pp의 휴무일을 캘린더상에 표현한다.  */
		calendarSetData(holiDayList);

// 		getRemainDayByMonth();
	}

	/* 해당 pp의 휴무일을 캘린더상에 표현한다. */
	function calendarSetData(holiDayList) {
		var html = "";
		var html = "";
		var tempI = "";
		var yymm = "";
		yymm = $("#getYear").val();
		yymm += $("#getMonth").val();

		for (var i = 1; i < 32; i++) {
			if (i < 10) {
				tempI = "0" + i;
			} else {
				tempI = i;
			}

			for (var j = 0; j < holiDayList.length; j++) {
				if (Number(holiDayList[j].setdate) == $("#cal" + yymm + tempI)
						.text().replace(/\s/gi, '')) {

					$("#cal" + yymm + tempI).parent().addClass("late");
					$("#cal" + yymm + tempI).removeAttr("onclick");
					html = "<span><em>휴무</em></span>";

					$("#cal" + yymm + tempI).append(html);
				}
			}
		}
	}

	/* 체성분 측정 예약 요청(선텍된 값들을 팝업 으로 보낸다) */
	function reservationReq() {

		$("#expSkinFormForPopup").empty();
		$("#checkLimitCount").empty();

		var currentMonth = $("#expSkinForm > #getMonth").val();
		var currentYear = $("#expSkinForm > #getYear").val()

		$("#expSkinFormForPopup").html("");

		$("#expSkinFormForPopup")
				.append(
						"<input type='hidden' name='getMonth' value='" + currentMonth + "' > ");
		$("#expSkinFormForPopup")
				.append(
						"<input type='hidden' name='getYear' value='" + currentYear + "' > ");

		var cnt = 0;
		$("a[name=startSession]")
				.each(
						function(index) {

							if ($(this).is(".on") === true) {

								$("#expSkinFormForPopup")
										.append(
												"<input type= 'hidden' name = 'expsessionseq' value = '"
														+ $(this)
																.find(
																		"input[name='tempExpSessionseq']")
																.val() + "'>");
								$("#expSkinFormForPopup")
										.append(
												"<input type= 'hidden' name = 'sessionTime' value = '"
														+ $(this)
																.find(
																		"input[name='tempSessionTime']")
																.val() + "'>");
								$("#expSkinFormForPopup")
										.append(
												"<input type= 'hidden' name = 'rsvflag' value = '"
														+ $(this)
																.find(
																		"input[name='tempRsvflag']")
																.val() + "'>");

								$("#expSkinFormForPopup")
										.append(
												"<input type= 'hidden' name = 'startdatetime' value = '"
														+ $(this)
																.find(
																		"input[name='tempStartdatetime']")
																.val() + "'>");
								$("#expSkinFormForPopup")
										.append(
												"<input type= 'hidden' name = 'enddatetime' value = '"
														+ $(this)
																.find(
																		"input[name='tempEnddatetime']")
																.val() + "'>");

								$("#checkLimitCount")
										.append(
												"<input type= 'hidden' name = 'reservationDate' value = '"
														+ $(this)
																.find(
																		"input[name='tempReservationDate']")
																.val() + "'>");
								$("#checkLimitCount")
										.append(
												"<input type= 'hidden' name = 'typeSeq' value = '"+typeseq+"'>");

								$("#expSkinFormForPopup")
										.append(
												"<input type= 'hidden' name = 'dateFormat' value = '"
														+ $(this)
																.find(
																		"input[name='tempDateFormat']")
																.val() + "'>");
								$("#expSkinFormForPopup")
										.append(
												"<input type= 'hidden' name = 'reservationDate' value = '"
														+ $(this)
																.find(
																		"input[name='tempReservationDate']")
																.val() + "'>");
								$("#expSkinFormForPopup")
										.append(
												"<input type= 'hidden' name = 'ppSeq' value = '"+ppSeq+"'>");
								$("#expSkinFormForPopup")
										.append(
												"<input type= 'hidden' name = 'ppName' value = '"+ppName+"'>");
								$("#expSkinFormForPopup")
										.append(
												"<input type= 'hidden' name = 'expseq' value = '"+expseq+"'>");
								$("#expSkinFormForPopup")
										.append(
												"<input type= 'hidden' name = 'typeSeq' value = '"+typeseq+"'>");

								cnt++;
							}

						});

		/* 세션 선택이 없을 경우 step2의 달력을 오픈한다 */
		if (cnt == 0) {
			alert("세션을 선택해 주십시오.");

			$("#step2Btn").parents('.brWrap').find('.sectionWrap').stop()
					.slideDown(
							function() {
								$("#step2Btn").parents('.brWrap').find(
										'.stepTit').find('.close').hide();
								$("#step2Btn").parents('.brWrap').find(
										'.stepTit').find('.open').show();
								$("#step2Btn").parents('.brWrap').removeClass(
										'finish').addClass('current');
							});

			/* 세션 선택이 있을 경우 팝업으로 데이터를 넘긴다. */
		} else {

			/* 패널티 유효성 중간 검사 */
			if (middlePenaltyCheck()) {
				checkLimitCount();
			}

			// 		var frm = document.expSkinFormForPopup
			// 		var url = "<c:url value="/reservation/expSkinRsvRequestPop.do"/>";
			// 		var title = "testpop";
			// 		var status = "toolbar=no, width=540, height=467, directories=no, status=no, scrollbars=yes, resizable=no";
			// 		window.open("", title,status);

			// 		frm.target = title;
			// 		frm.action = url;
			// 		frm.method = "post";
			// 		frm.submit();
		}
	}

	function checkLimitCount() {
		/* typeseq, ppseq, roomseq 일, 주, 월 예약 가능 횟수 조회 변수*/
		$("#checkLimitCount")
				.append(
						"<input type=\"hidden\" name=\"typeseq\" value=\""+typeseq+"\">");
		$("#checkLimitCount").append(
				"<input type=\"hidden\" name=\"ppseq\" value=\""+ppSeq+"\">");
		$("#checkLimitCount").append(
				"<input type=\"hidden\" name=\"expseq\" value=\""+expseq+"\">");

		$
				.ajaxCall({
					url : "<c:url value='/reservation/rsvAvailabilityCheckAjax.do'/>",
					type : "POST",
					data : $("#checkLimitCount").serialize(),
					success : function(data, textStatus, jqXHR) {
						if (data.rsvAvailabilityCheck) {
							duplicateCheck();
							/* 세션 선택이 있을 경우 팝업으로 데이터를 넘긴다. */
							// 			var frm = document.expSkinFormForPopup
							// 			var url = "<c:url value="/reservation/expSkinRsvRequestPop.do"/>";
							// 			var title = "testpop";
							// 			var status = "toolbar=no, width=540, height=467, directories=no, status=no, scrollbars=yes, resizable=no";
							// 			window.open("", title,status);
							// 			frm.target = title;
							// 			frm.action = url;
							// 			frm.method = "post";
							// 			frm.submit();
							// 			setTimeout(function(){ abnkorea_resize(); }, 500);
						} else {
							alert("예약가능 범위 또는 잔여 회수를 초과 하였습니다. 예약가능 범위 및 잔여회수를 확인하시고 선택해 주세요.");
						}

					},
					error : function(jqXHR, textStatus, errorThrown) {
						var mag = '<spring:message code="errors.load"/>';
						alert(mag);
					}
				});
	}

	function middlePenaltyCheck() {

		var penaltyCheck = true;

		$.ajaxCall({
			url : "<c:url value='/reservation/rsvMiddlePenaltyCheckAjax.do'/>",
			type : "POST",
			data : $("#checkLimitCount").serialize(),
			async : false,
			success : function(data, textStatus, jqXHR) {
				if (!data.middlePenaltyCheck) {
					alert("패널티로 인해서 예약이 불가 합니다.");
					penaltyCheck = false;
				}

			},
			error : function(jqXHR, textStatus, errorThrown) {
				var mag = '<spring:message code="errors.load"/>';
				alert(mag);
			}
		});

		return penaltyCheck;
	}

	/* 예약 가능 체크 */
	function duplicateCheck() {

		var param = $("#expSkinFormForPopup").serialize();

		$.ajaxCall({
			url : "<c:url value='/reservation/expSkinDuplicateCheckAjax.do'/>",
			type : "POST",
			data : param,
			success : function(data, textStatus, jqXHR) {
				var cancelDataList = data.cancelDataList;

				if (cancelDataList.length == 0) {
					/* 예약정보 확인 팝업 */
					expSkinRsvRequestPop();
				} else {
					/* 예약불가 알림 팝업 (파라미터 cancelDataList)*/
					expSkinDisablePop(cancelDataList);
				}

			},
			error : function(jqXHR, textStatus, errorThrown) {
				var mag = '<spring:message code="errors.load"/>';
				alert(mag);
			}
		});
	}

	/* 예약정보 확인 팝업 */
	function expSkinRsvRequestPop() {
		/* 세션 선택이 있을 경우 팝업으로 데이터를 넘긴다. */
		var frm = document.expSkinFormForPopup
		var url = "<c:url value="/reservation/expSkinRsvRequestPop.do"/>";
		var title = "testpop";
		var status = "toolbar=no, width=540, height=467, directories=no, status=no, scrollbars=yes, resizable=no";
		window.open("", title, status);

		frm.target = title;
		frm.action = url;
		frm.method = "post";
		frm.submit();

		setTimeout(function() {
			abnkorea_resize();
		}, 500);
	}

	/* 예약불가 알림 팝업(중복) */
	function expSkinDisablePop(cancelDataList) {
		var url = "<c:url value='/reservation/expHealthDisablePop.do'/>";
		var title = "testpop";
		var status = "toolbar=no, width=600, height=387, directories=no, status=no, scrollbars=yes, resizable=no";
		window.open("", title, status);

		$("#cancelList").empty();
		var $form = $('#cancelList');
		$form.attr('action', url);
		$form.attr('method', 'post');
		$form.attr('target', title);
		$form.appendTo('body');

		/* 중복 데이터 삭제 */
		for ( var num in cancelDataList) {
			$form
					.append("<input type= 'hidden' name = 'reservationdate' value = '"+cancelDataList[num].reservationdate+"'>");
			$form
					.append("<input type= 'hidden' name = 'expsessionseq' value = '"+cancelDataList[num].expsessionseq+"'>");
			$form
					.append("<input type= 'hidden' name = 'reservationweek' value = '"+cancelDataList[num].reservationweek+"'>");
			$form
					.append("<input type= 'hidden' name = 'ppname' value = '"+cancelDataList[num].ppname+"'>");
			$form
					.append("<input type= 'hidden' name = 'programname' value = '"+cancelDataList[num].programname+"'>");
			$form
					.append("<input type= 'hidden' name = 'sessionname' value = '"+cancelDataList[num].sessionname+"'>");
			$form
					.append("<input type= 'hidden' name = 'starttime' value = '"+cancelDataList[num].starttime+"'>");
			$form
					.append("<input type= 'hidden' name = 'endtime' value = '"+cancelDataList[num].endtime+"'>");
			$form
					.append("<input type= 'hidden' name = 'standbynumber' value = '"+cancelDataList[num].standbynumber+"'>");
		}

		$form.submit();

	}

	function setRsvAbleCnt(rsvAbleCntList) {

		//console.log(rsvAbleCntList);

		var html = "";
		var yymm = "";
		yymm = $("#getYear").val();
		yymm += $("#getMonth").val();

		var tempSettypecode = "";
		var tempWorktypecode = "";
		var tempSetdate = "";
		var tempGetYmd = "";

		if (rsvAbleCntList.length == 0) {
			$("#nextMontCalTbody").find("td").each(function() {
				$(this).removeClass();
				$(this).addClass("late");
				$(this).children().removeAttr("onclick");

			});

			var months = $(".monthlyWrap > span").length;

			if (1 < months) {
				msg = "예약 조건이 일치하지 않습니다. 예약 필수 안내를 참조하여 주십시오.";
			} else {
				msg = "예약 자격/조건이 맞지 않습니다.";
			}

			alert(msg);

			return false;
		}

		for (var i = 0; i < rsvAbleCntList.length; i++) {

			if (tempGetYmd != rsvAbleCntList[i].getymd) {
				tempSettypecode = rsvAbleCntList[i].settypecode;
				tempWorktypecode = rsvAbleCntList[i].worktypecode;
				tempSetdate = rsvAbleCntList[i].setdate;
				tempGetYmd = rsvAbleCntList[i].getymd;
			}

			if (rsvAbleCntList[i].settypecode == tempSettypecode) {

				// 			if(rsvAbleCntList[i].gettoday < rsvAbleCntList[i].getymd && $("#cal"+rsvAbleCntList[i].getymd).children("span").text() == ""){
				if ($("#cal" + rsvAbleCntList[i].getymd).children("span")
						.text() == "") {
					if (rsvAbleCntList[i].rsvsessiontotalcnt != 0) {
						html = "<em style='color: #555;'> ("
								+ rsvAbleCntList[i].rsvsessiontotalcnt
								+ ")</em>";
						$("#cal" + rsvAbleCntList[i].getymd).append(html);
					} else if (rsvAbleCntList[i].rsvsessiontotalcnt == 0) {
						if (rsvAbleCntList[i].rsvsessiontotalcnt == 0
								&& rsvAbleCntList[i].rsvsessioncnt == 0
								&& rsvAbleCntList[i].totalsessioncnt == 0) {
							$("#cal" + rsvAbleCntList[i].getymd).parent()
									.addClass("late");
							$("#cal" + rsvAbleCntList[i].getymd).removeAttr(
									"onclick");
						} else {
							$("#cal" + rsvAbleCntList[i].getymd).parent()
									.addClass("late");
							$("#cal" + rsvAbleCntList[i].getymd).removeAttr(
									"onclick");
							html = "<span><em>예약마감</em></span>";
							$("#cal" + rsvAbleCntList[i].getymd).append(html);
						}
					}
				} else if (rsvAbleCntList[i].gettoday >= rsvAbleCntList[i].getymd) {
					$("#cal" + rsvAbleCntList[i].getymd).parent().addClass(
							"late");
					$("#cal" + rsvAbleCntList[i].getymd).removeAttr("onclick");
				}

			}
		}

		$("#nextMontCalTbody").find("td").each(function() {
			if ($(this).find("em").length == 0) {
				$(this).removeClass();
				$(this).addClass("late");
				$(this).children().removeAttr("onclick");
			}

		});
	}

	/* 팝업 창에서 전달 받은 예약한 데이터를 보여줌  */
	function expSkinRsvDetail(expSkinRsvList, totalCnt) {

		$('#pbContent').each(function() {
			this.scrollIntoView(true);
		});

		/* show box & hide box */
		var $brWrap = $("#step2Btn").parents('.brWrap');
		var stepTit = $brWrap.find('.stepTit');
		var result = $brWrap.find('.result');

		$("#stepDone").show();

		$brWrap.find('.sectionWrap').stop().slideUp(function() {
			$brWrap.find(stepTit).find('.close').show();
			$brWrap.find(stepTit).find('.open').hide();

			$brWrap.find('.modifyBtn').show();
			$brWrap.find('.req').show(); //결과값 보기
			$brWrap.removeClass('current').addClass('finish');
		});

		/* rendering html */

		var snsHtml = "";

		$("#expSkinConfirm").append(
				"<p class='total'>총  " + totalCnt + " 건</p>");

		for (var i = 0; i < expSkinRsvList.length; i++) {

			var html = "";

			if (i == 0) {
				snsHtml += "[한국암웨이]시설/체험 예약내역 (총 " + totalCnt + "건) \n";
			}

			/* 동반자 여부 -> R01 abo  */
			if (expSkinRsvList[i].partnerTypeCode == "R01") {
				/* 대기 여부 -> 예약가능(100) */
				if (expSkinRsvList[i].rsvflag == "100"
						&& expSkinRsvList[i].standbynumber == "0") {
					html += "<p>" + expSkinRsvList[i].dateFormat + "<em>|</em>"
							+ expSkinRsvList[i].sessionTime
							+ "<em>|</em>ABO</p>"
					snsHtml += "■" + expSkinRsvList[i].ppName + "(피부측정)"
							+ expSkinRsvList[i].dateFormat + "| \n"
							+ expSkinRsvList[i].sessionTime + "| ABO\n";
					/* 대기 여부 -> 예약대기(200) */
				} else if (expSkinRsvList[i].rsvflag == "200"
						|| expSkinRsvList[i].standbynumber == "1") {
					html += "<p>" + expSkinRsvList[i].dateFormat + "<em>|</em>"
							+ expSkinRsvList[i].sessionTime
							+ " (예약대기)<em>|</em>ABO</p>"
					snsHtml += "■" + expSkinRsvList[i].ppName + "(피부측정)"
							+ expSkinRsvList[i].dateFormat + "| \n"
							+ expSkinRsvList[i].sessionTime + " (예약대기) | ABO\n";
				}

				/* 동반자 여부 -> 일반인 */
			} else if (expSkinRsvList[i].partnerTypeCode == "R02") {
				/* 대기 여부 -> 예약가능(100) */
				if (expSkinRsvList[i].rsvflag == "100"
						&& expSkinRsvList[i].standbynumber == "0") {
					html += "<p>" + expSkinRsvList[i].dateFormat + "<em>|</em>"
							+ expSkinRsvList[i].sessionTime
							+ "<em>|</em>일반인동반</p>"
					snsHtml += "■" + expSkinRsvList[i].ppName + "(피부측정)"
							+ expSkinRsvList[i].dateFormat + "| \n"
							+ expSkinRsvList[i].sessionTime + " | 일반인동반\n";
				} else if (expSkinRsvList[i].rsvflag == "200"
						|| expSkinRsvList[i].standbynumber == "1") {
					/* 대기 여부 -> 예약대기(200) */
					html += "<p>" + expSkinRsvList[i].dateFormat + "<em>|</em>"
							+ expSkinRsvList[i].sessionTime
							+ " (예약대기)<em>|</em>일반인동반</p>"
					snsHtml += "■" + expSkinRsvList[i].ppName + "(피부측정)"
							+ expSkinRsvList[i].dateFormat + "| \n"
							+ expSkinRsvList[i].sessionTime
							+ " (예약대기) | 일반인동반\n";
				}

			} else if (expSkinRsvList[i].partnerTypeCode == "R03") {
				/* 대기 여부 -> 예약가능(100) */
				if (expSkinRsvList[i].rsvflag == "100"
						&& expSkinRsvList[i].standbynumber == "0") {
					html += "<p>" + expSkinRsvList[i].dateFormat + "<em>|</em>"
							+ expSkinRsvList[i].sessionTime
							+ "<em>|</em>비동반</p>"
					snsHtml += "■" + expSkinRsvList[i].ppName + "(피부측정)"
							+ expSkinRsvList[i].dateFormat + "| \n"
							+ expSkinRsvList[i].sessionTime + " | 비동반\n";
				} else if (expSkinRsvList[i].rsvflag == "200"
						|| expSkinRsvList[i].standbynumber == "1") {
					/* 대기 여부 -> 예약대기(200) */
					html += "<p>" + expSkinRsvList[i].dateFormat + "<em>|</em>"
							+ expSkinRsvList[i].sessionTime
							+ " (예약대기)<em>|</em>비동반</p>"
					snsHtml += "■" + expSkinRsvList[i].ppName + "(피부측정)"
							+ expSkinRsvList[i].dateFormat + "| \n"
							+ expSkinRsvList[i].sessionTime + " (예약대기) | 비동반\n";
				}
			}

			$("#expSkinConfirm").append(html);

		}

		$("#snsText").empty();
		$("#snsText").val(snsHtml);
	}

	/* 세션 선택시 테두리 활성화 */
	function selectedSession(obj) {

		if ($(obj).is(".on") === true) {
			if ($(obj).children().find("line2 on") == true) {
				$(obj).removeClass("on");
			} else {
				$(obj).removeClass("on");
			}
		} else if ($(obj).children().find("line2") === true) {
			$(obj).addClass("on line2");
		} else {
			$(obj).addClass("on");
		}
	}

	/* 세션 테이블에서 삭제 버튼 클릭  */
	function deleteSessionDetail(obj) {
		/* 세션 테이블에 id값이 년 월 일 이기 때문에 세션테이블에 id값과 캘린더 상에 날짜(캘린더 속 날짜 또한 날짜가 id값) 매칭 시켜 삭제함 */

		if ($("#appendToSession").children("dl").length == 1) {
			$(".noSelectDate").show();
		}

		/* 세션 테이블에 id값 가져오기  */
		var selectedDate = $(obj).parent().attr("id");
		/* 날짜만 남겨주고 자르기 */
		// 	selectedDate = Number(selectedDate.substring(6, 8));
		$("#cal" + selectedDate).removeAttr("class");
		$(obj).parent().parent().remove();
	}

	/* 캘린더 에서 선택한 세션 & 날짜 삭제 */
	function deleteSelcOnCal(date, year, month) {
		var tempDate = date;
		var year = $("#getYear").val();
		var month = $("#getMonth").val();

		/* 데이터가 없을 경우  */
		if (date == "") {
			return false;
		} else {

			/* 캘린더에서 날짜가  이미 선택이 된 경우  해당 날짜의 세션과 캘린의 선택을 지워줌 */
			if ($("#cal" + year + month + date).attr("class") == "selcOn") {
				$("#cal" + year + month + date).removeAttr("class");
				$("#" + year + month + tempDate).parent().remove();

				if ($("#appendToSession").children("dl").length == 0) {
					$(".noSelectDate").show();
				}

				/* 캘린더에 새로운 날짜를 선택한 경우 */
			} else {
				/* 날짜가 한자리수일 경우 앞에 0을 붙여준다  */

				$("#cal" + year + month + date).attr("class", "selcOn");
				$(".brSessionWrap").show();

				$(".noSelectDate").hide();

				/* 선택 날짜의 세션 정보 상세보기 */
				showSession(tempDate, year, month);
			}
		}
	}

	/* 선택 날짜의 세션 상세보기 */
	function showSession(tempDate, year, month) {

		var param = {
			ppSeq : ppSeq,
			year : year,
			month : month,
			date : tempDate,
			expseq : expseq
		};

		$
				.ajaxCall({
					url : "<c:url value="/reservation/searchSkinSeesionListAjax.do"/>",
					type : "POST",
					data : param,
					success : function(data, textStatus, jqXHR) {
						var html = "";
						var sessionTime = data.searchStartSeesionTimeListAjax;

						// 			console.log(sessionTime);

						html = "<dl class='tblDetailHead mgNone'>"
						html += "<dt id="+sessionTime[0].idvalue+">"
								+ sessionTime[0].date
								+ "<a href= 'javascript:void(0);' class= 'btnDel' onclick='javascript:deleteSessionDetail(this)'>삭제</a></dt>"
						html += "<dd class= 'brselectArea'>"

						for (var i = 0; i < sessionTime.length; i++) {
							/* 대기자는 없고 신청된 예약이 존재하면 예약 대기 */
							if (sessionTime[i].rsvflag == 200) {
								html += "<a href= 'javascript:void(0);' id='"
										+ sessionTime[i].idvalue
										+ "_"
										+ sessionTime[i].expsessionseq
										+ "' name = 'startSession' onclick='javascript:selectedSession(this)' class='line2'>"
										+ sessionTime[i].tempstartdatetime
										+ "<br>(대기신청)"
								html += "<input type= 'hidden' name = 'tempExpSessionseq' value = '"+sessionTime[i].expsessionseq+"'>"
								html += "<input type= 'hidden' name = 'tempSessionTime' value = '"+sessionTime[i].session+"'>"
								html += "<input type= 'hidden' name = 'tempRsvflag' value = '"+sessionTime[i].rsvflag+"'>"
								html += "<input type= 'hidden' name = 'tempStartdatetime' value = '"+sessionTime[i].startdatetime+"'>"
								html += "<input type= 'hidden' name = 'tempEnddatetime' value = '"+sessionTime[i].enddatetime+"'>"

								html += "<input type= 'hidden' name = 'tempDateFormat' value = '"+sessionTime[i].date+"'>"
								html += "<input type= 'hidden' name = 'tempReservationDate' value = '"+sessionTime[i].idvalue+"'></a>"
							} else if (sessionTime[i].rsvflag == 300) {
								/* 대기자도 있고 신청된 예약도 있음 예약 마감 */
								html += "<a href= 'javascript:void(0);' id='"
										+ sessionTime[i].idvalue
										+ "_"
										+ sessionTime[i].expsessionseq
										+ "' name = 'startSession' class='line2'>"
										+ sessionTime[i].tempstartdatetime
										+ "<br>(예약마감)</a>"
							} else if (sessionTime[i].rsvflag == 100) {
								/* 대기자도 없고 신청된 예약도 없음 */
								html += "<a href= 'javascript:void(0);' id='"
										+ sessionTime[i].idvalue
										+ "_"
										+ sessionTime[i].expsessionseq
										+ "' name = 'startSession' onclick='javascript:selectedSession(this)'>"
										+ sessionTime[i].tempstartdatetime
								html += "<input type= 'hidden' name = 'tempExpSessionseq' value = '"+sessionTime[i].expsessionseq+"'>"
								html += "<input type= 'hidden' name = 'tempSessionTime' value = '"+sessionTime[i].session+"'>"
								html += "<input type= 'hidden' name = 'tempRsvflag' value = '"+sessionTime[i].rsvflag+"'>"
								html += "<input type= 'hidden' name = 'tempStartdatetime' value = '"+sessionTime[i].startdatetime+"'>"
								html += "<input type= 'hidden' name = 'tempEnddatetime' value = '"+sessionTime[i].enddatetime+"'>"

								html += "<input type= 'hidden' name = 'tempDateFormat' value = '"+sessionTime[i].date+"'>"
								html += "<input type= 'hidden' name = 'tempReservationDate' value = '"+sessionTime[i].idvalue+"'></a>"
							}
						}
						html += "</dd>"
						html += "</dl>"
						$("#appendToSession").append(html)
					},
					error : function(jqXHR, textStatus, errorThrown) {
						var mag = '<spring:message code="errors.load"/>';
						alert(mag);
					}
				});

	}

	/* 해당 pp의 준비물, 이용자격 등을 조회 */
	function detailPp(getPpseq, getPpname, getExpseq) {

		/* getPpseq : 사용자가 선택한 ppSeq, ppSeq : 기존 전역 변수에 저장 되었던 ppSeq  */
		if (getPpseq != ppSeq) {
			/* 이전 pp선택 한것과 현재 선택한 pp가 다를 경우  해당 날짜에 세션 정보 삭제  */
			$(".tblDetailHead").remove();

			/* 전역 변수  ppSeq에 새로운  ppSeq를 삽입  */
			ppSeq = getPpseq;
			ppName = getPpname;
			expseq = getExpseq;

			$("#getYear").val($("#getYearPop").val());
			$("#getMonth").val($("#getMonthPop").val());

			$("#appendToSession").empty();

			html = "<div class='noSelectDate'>";
			html += "	<span>상단 캘린더에서 날짜를 선택해 주세요.</span>";
			html += "</div>";

			$("#appendToSession").append(html);

			/* 이전 pp선택 한것과 현재 선택한 pp가 다를 경우 캘린더 다시그리기  */
			// 		nextMonthCalendar("F");
		}

		/* 새로운 pp버튼 클릭시 이전 pp버튼 선택 테두리 지우기 */
		$(".on").attr("class", "");
		ppSeq = "";
		ppName = "";

		/* pp버튼 클릭시 선택 테두리 활성화*/
		$("#detailPpSeq" + getPpseq).attr("class", "on");
		ppSeq = getPpseq;
		ppName = getPpname;
		expseq = getExpseq;

		/* 해당 pp선택시 중비물&사진등 을 담고있는 화면 활성화 */
		$(".brSelectWrap").show();

		var param = {
			"commoncodeseq" : getPpseq
		};

		$
				.ajaxCall({
					url : "<c:url value="/reservation/expSkinDetailInfoAjax.do"/>",
					type : "POST",
					data : param,
					success : function(data, textStatus, jqXHR) {
						var detailCode = data.expSkinDetailInfo;
						$("#afterProductName").empty();/*  */
						$("#afterSeatcount").empty(); /* 정원 */
						$("#afterUseTime").empty(); /* 이용시간 */
						$("#afterUseTimeTip").empty(); /* 이용시간(달력밑의 팁) */
						$("#afterPreparation").empty(); /* 준비물 */
						$("#afterRoleNote").empty(); /* 이용자격  */

						//console.log(data);
						expseq = detailCode.expseq;
						typeseq = detailCode.typeseq;

						$("#afterProductName").append(
								detailCode.productname + "-<br/>"
										+ detailCode.content);

						if (detailCode.seatcount2 == null
								|| detailCode.seatcount2 == ""
								|| detailCode.seatcount2 == "undefined") {
							$("#afterSeatcount").append(
									"개인:" + detailCode.seatcount1);
						} else {
							$("#afterSeatcount").append(
									"개인:" + detailCode.seatcount1 + "<br/>"
											+ "(단체:" + detailCode.seatcount2
											+ ")");
						}

						if (detailCode.usetimenote == null
								|| detailCode.usetimenote == ""
								|| detailCode.usetimenote == "undefined") {
							$("#afterUseTime").append(detailCode.usetime);
						} else {
							$("#afterUseTime").append(
									detailCode.usetime + "<br/>" + "("
											+ detailCode.usetimenote + ")");
						}

						$("#afterUseTimeTip").append(detailCode.usetime);
						// 			$("#afterRoleNote").append(detailCode.rolenote);
						$("#afterRoleNote").append(
								detailCode.role
										+ "<br/><span class=\"normal\">"
										+ detailCode.rolenote + "</span>");
						$("#afterPreparation").append(detailCode.preparation);

						$("#getDayPop").val(detailCode.gettoday.substr(6, 2))

						if ((detailCode.filekey1 == null || detailCode.filekey1 == 0)
								&& (detailCode.filekey2 == null || detailCode.filekey2 == 0)
								&& (detailCode.filekey3 == null || detailCode.filekey3 == 0)
								&& (detailCode.filekey4 == null || detailCode.filekey4 == 0)
								&& (detailCode.filekey5 == null || detailCode.filekey5 == 0)
								&& (detailCode.filekey6 == null || detailCode.filekey6 == 0)
								&& (detailCode.filekey7 == null || detailCode.filekey7 == 0)
								&& (detailCode.filekey8 == null || detailCode.filekey8 == 0)
								&& (detailCode.filekey9 == null || detailCode.filekey9 == 0)
								&& (detailCode.filekey10 == null || detailCode.filekey10 == 0)) {
							var html = "";
							$("#touchSlider ul").empty();
							html = "<li></li>";
							$("#touchSlider ul").append(html);
							touchsliderFn();
						} else {
							var filekey = [ detailCode.filekey1,
									detailCode.filekey2, detailCode.filekey3,
									detailCode.filekey4, detailCode.filekey5,
									detailCode.filekey6, detailCode.filekey7,
									detailCode.filekey8, detailCode.filekey9,
									detailCode.filekey10 ];

							setFileKeyList(filekey);
						}

					},
					error : function(jqXHR, textStatus, errorThrown) {
						var mag = '<spring:message code="errors.load"/>';
						alert(mag);
					}
				});
	}

	function setFileKeyList(filekey) {
		var param = {
			filekey : filekey
		};

		$
				.ajaxCall({
					url : "<c:url value='/reservation/searchExpSkinFileKeyListAjax.do' />",
					type : "POST",
					data : param,
					success : function(data, textStatus, jqXHR) {
						var imageFileKeyList = data.expImageFileKeyList;
						var html = "";

						$("#touchSlider ul").empty();

						if (imageFileKeyList.length != 0) {
							for (var i = 0; i < imageFileKeyList.length; i++) {
								html += "	<li style='float: none; display: block; position: absolute; top: 0px; left: 0px; width: 228px; height: 148px;'>";
								html += "		<img src='/reservation/imageView.do?file="
										+ imageFileKeyList[i].storefilename
										+ "&mode=RESERVATION' title='"
										+ imageFileKeyList[i].altdesc + "' />";
								html += "	</li>";
							}

							$("#touchSlider ul").append(html);

							touchsliderFn();
						} else {
							html = "<li></li>";

							$("#touchSlider ul").append(html);

							touchsliderFn();
						}

						// 			html  ="<ul style='width: 228px; height: 148px; overflow: visible;'>";

					},
					error : function(jqXHR, textStatus, errorThrown) {
						var mag = '<spring:message code="errors.load"/>';
						alert(mag);
					}
				});
	}

	function tempSharing(url, sns) {

		if (sns == 'facebook') {

			var currentUrl = "${currentDomain}/reservation/simpleReservation.do?reservation="
					+ $("#transactionTime").val(); // Returns full URL
			var title = "abnKorea - 피부 측정 예약";
			var content = $("#snsText").val();
			var imageUrl = "/_ui/desktop/images/academy/h1_w020500070.gif";

			sharing(currentUrl, title, sns, content);

		} else {

			var title = "abnKorea";
			var content = $("#snsText").val();

			sharing(url, title, sns, content);
		}

	}

	/* 예약 현황 확인 페이지 이동 */
	function accessParentPage() {
		var newUrl = "/reservation/expInfoList";
		top.window.location.href = "${hybrisUrl}" + newUrl;
	}
	// function temp(url){

	// 	var tempUrl = encodeURIComponent(url);
	// 	console.log(tempUrl);
	// 	window.open('https://story.kakao.com/share?url='+tempUrl, '', 'resizable=no,status=no,location=no,toolbar=no,menubar=no,fullscreen=no,scrollbars=no,dependent=no,width=600,height=600'); return false;
	// }
</script>
</head>
<body>
	<form id="expSkinForm" name="expSkinForm" method="post">
		<input type="hidden" id="getMonth" name="getMonth"> <input
			type="hidden" id="getYear" name="getYear"> <input
			type="hidden" id="getMonthPop" name="getMonthPop"> <input
			type="hidden" id="getYearPop" name="getYearPop"> <input
			type="hidden" id="getDayPop" name="getDayPop">
	</form>
	<form id="expSkinFormForPopup" name="expSkinFormForPopup" method="post"></form>
	<form id="checkLimitCount" name="checkLimitCount" method="post"></form>
	<form id="cancelList" name="cancelList" method="post"></form>

	<!-- content area | ### academy IFRAME Start ### -->
	<section id="pbContent" class="bizroom">

		<input type="hidden" id="transactionTime" value="" /> <input
			type="hidden" id="snsText" name="snsText">

		<div class="hWrap">
			<h1>
				<img src="/_ui/desktop/images/academy/h1_w020500190.gif"
					alt="피부측정 예약">
			</h1>
			<p>
				<img src="/_ui/desktop/images/academy/txt_w020500190.gif"
					alt="아티스트리 피부 측정을 신청 하실 수 있습니다.">
			</p>
		</div>
		<div class="brIntro">
			<!-- @edit 20160701 인트로 토글 링크영역 변경 -->
			<h2 class="hide">피부측정 예약 필수 안내</h2>
			<a href="#uiToggle_01" class="toggleTitle"><strong>피부측정
					예약 필수 안내</strong> <span class="btnArrow"><em class="hide">내용보기</em></span></a>
			<div id="uiToggle_01" class="toggleDetail">
				<!-- //@edit 20160701 인트로 토글 링크영역 변경 -->
				<c:out value="${reservationInfo}" escapeXml="false" />
			</div>
		</div>
		<div class="brWrapAll">
			<span class="hide">피부측정 예약 스텝</span>
			<!-- 스텝1 -->
			<div class="brWrap current" id="step1">
				<h2 class="stepTit">
					<span class="close"><img
						src="/_ui/desktop/images/academy/h2_w02_apexp_01.gif"
						alt="Step1/지역" class="mglS" /></span> <span class="open"><img
						src="/_ui/desktop/images/academy/h2_w02_apexp_01_current.gif"
						alt="Step1/지역 - 지역을 선택하세요" class="mglS" /></span>
				</h2>
				<div class="brSelectWrapAll">
					<div class="sectionWrap">
						<section class="brSelectWrap">
							<div class="relative">
								<h3 class="mgNone">
									<img src="/_ui/desktop/images/academy/h3_w02_aproom_01.gif"
										alt="지역 선택">
								</h3>
								<!-- 							<span class="btnR"><a href="#uiLayerPop_01" class="btnCont uiApBtnOpen" onclick="javascript:showApInfo();"><span>AP 안내</span></a></span> -->
								<span class="btnR"><a href="#uiLayerPop_01"
									class="btnCont uiApBtnOpen"><span>AP 안내</span></a></span>
							</div>

							<!-- layer popup -->
							<%@ include file="/WEB-INF/jsp/reservation/exp/apInfoPop.jsp"%>
							<!--// layer popup -->

							<div class="brselectArea" id="ppAppend"></div>
						</section>
						<section class="brSelectWrap">
							<h3>
								<img src="/_ui/desktop/images/academy/h3_w020500160.gif"
									alt="프로그램 정보">
							</h3>
							<div class="roomInfo prgInfo">
								<dl>
									<dt>
										<p class="tit">피부측정 예약</p>
										<p id="afterProductName"></p>
									</dt>
									<dd>
										<div class="roomImg touchSliderWrap">
											<a href="#none" class="btnPrev">이전</a> <a href="#none"
												class="btnNext">다음</a>
											<div class="touchSlider" id="touchSlider">
												<ul style="width: 228px; height: 148px; overflow: visible;">
													<!-- 												<li style="float: none; display: block; position: absolute; top: 0px; left: 0px; width: 228px; height: 148px;"><img src="/_ui/desktop/images/academy/@bodycomposition1.gif" alt="룸 사진"></li> -->
													<!-- 												<li style="float: none; display: block; position: absolute; top: 0px; left: 228px; width: 228px; height: 148px;"><img src="/_ui/desktop/images/academy/@bodycomposition1.gif" alt="룸 사진"></li> -->
												</ul>
											</div>
											<div class="sliderPaging">
												<a href="#none" class="btnPage on"><img
													src="/_ui/desktop/images/academy/btn_slideb_on.png"
													alt="룸 사진"></a><a href="#none" class="btnPage"><img
													src="/_ui/desktop/images/academy/btn_slideb_off.png"
													alt="룸 사진"></a>
											</div>
										</div>
									</dd>
								</dl>
								<table class="roomInfoDetail">
									<colgroup>
										<col width="15%" />
										<col width="35%" />
										<col width="15%" />
										<col width="35%" />
									</colgroup>
									<tr>
										<td class="title"><span class="icon1">정원</span></td>
										<td id="afterSeatcount"></td>
										<td class="title"><span class="icon2">체험시간</span></td>
										<td id="afterUseTime"></td>
									</tr>
									<tr>
										<td class="title"><span class="icon3">예약자격</span></td>
										<td id="afterRoleNote"></span></td>
										<!-- 									<td>ABO 이상<br/><span class="normal">일반소비자<br/> 동반 가능</span></td> -->
										<td class="title"><span class="icon5">준비물</span></td>
										<td id="afterPreparation"></td>
									</tr>
								</table>
							</div>
						</section>
						<div class="btnWrapR">
							<a href="javascript:void(0);" id="step1Btn"
								class="btnBasicBS stepBtn">다음</a>
						</div>
					</div>
					<div class="result req">
						<p id="ppName">
					</div>
				</div>

				<%
					//<div class="modifyBtn"><a href="javascript:void(0);"><img src="/_ui/desktop/images/academy/btn_down.gif" alt="변경하기" /></a></div>
				%>

			</div>
			<!-- //스텝1 -->
			<!-- 스텝2 -->
			<div class="brWrap" id="step2">
				<h2 class="stepTit">
					<span class="close"><img
						src="/_ui/desktop/images/academy/h2_w02_apexp_02.gif"
						alt="Step2/날짜, 시간" /></span> <span class="open"><img
						src="/_ui/desktop/images/academy/h2_w02_apexp_02_current.gif"
						alt="Step2/날짜, 시간 - 날짜 선택 후 시간을 선택하세요." /></span>
				</h2>
				<div class="brSelectWrapAll">
					<div class="sectionWrap">
						<section class="calenderBookWrap">
							<div class="hWrap">
								<h3 class="mgNone">
									<img src="/_ui/desktop/images/academy/h3_w02_aproom_04.gif"
										alt="날짜선택">
								</h3>
								<span class="btnR"><a href="javascript:void(0);"
									title="새창 열림" class="btnCont"
									onclick="javascript:viewRsvConfirm();"><span>체험예약
											현황확인</span></a></span>
							</div>
							<!-- 1월 jan, 2월 feb, 3월 mar, 4월 apr, 5월 may, 6월 june, 7월 july, 8월 aug, 9월 sep, 10월 oct, 11월 nov, 12월 dec -->
							<div class="calenderHeader" id="appendYYMM"></div>
							<table class="tblBookCalendar">
								<caption>캘린더형 - 날짜별 시설예약가능 시간</caption>
								<colgroup>
									<col style="width: 15%" span="2">
									<col style="width: 14%" span="5">
								</colgroup>
								<thead>
									<tr>
										<th scope="col" class="weekSun">일</th>
										<th scope="col" class="weekMon">월</th>
										<th scope="col" class="weekTue">화</th>
										<th scope="col" class="weekWed">수</th>
										<th scope="col" class="weekThur">목</th>
										<th scope="col" class="weekFri">금</th>
										<th scope="col" class="weekSat">토</th>
									</tr>
								</thead>
								<tbody id="nextMontCalTbody">
									<!--날짜 append-->
								</tbody>
							</table>
							<ul class="listWarning">
								<li>※ 날짜를 선택하시면 예약가능 시간(세션)을 확인 할 수 있습니다.</li>
								<li>※ 날짜 옆 괄호안 숫자는 예약 가능 세션 수 입니다.</li>
							</ul>
						</section>
						<section class="brSessionWrap">
							<div class="relative">
								<h3>
									<img src="/_ui/desktop/images/academy/h3_w02_apexp_01.gif"
										alt="시간 선택">
								</h3>
								<span class="hText">프로그램은 <span id="afterUseTimeTip">30분</span>
									단위로 진행됩니다.
								</span>
							</div>

							<div id="appendToSession">
								<div class="noSelectDate">
									<span>상단 캘린더에서 날짜를 선택해 주세요.</span>
								</div>
								<!-- 세션 append -->
							</div>

							<!-- 세션 append -->
							<ul class="listWarning mgtS">
								<li>※ 함께 체험하실 동반 인원이 있으시면 체크해 주세요. (동반인 포함 총 2명)</li>
								<li>※ 평일은 오전 11시부터 오후 20시 00분까지, 토요일/일요일은 오전 11시부터 오후 18시
									00분 까지만 이용이 가능합니다.</li>
								<li>※ 2인 측정의 경우, 1인 상담시간은 15분으로 진행 됩니다.</li>
								<!-- 							<li>※  측정 예약 후, 사전 취소 없이 불참하실 경우 2개월간 패널티가 적용됩니다.</li> -->
								<li id="penaltyInfo">※ 측정 예약 후, 사전 취소 없이 불참하실 경우 <strong
									id="applyTypeValue">2개월</strong>간 패널티가 적용됩니다.
								</li>
							</ul>
						</section>
						<div class="btnWrapR">
							<a href="javascript:void(0);" class="btnBasicGS">이전</a> <a
								id="step2Btn" href="javascript:reservationReq();"
								class="btnBasicBS">예약요청</a>
						</div>
					</div>
					<div class="result" id="tempResult">
						<p>날짜와 시간을 선택해 주세요.</p>
					</div>
					<div id="expSkinConfirm" class="result lines req"
						style="display: none">
						<!-- 예약정보 append -->
					</div>
				</div>

				<%
					//<div class="modifyBtn"><a href="javascript:void(0);"><img src="/_ui/desktop/images/academy/btn_down.gif" alt="변경하기" /></a></div>
				%>

			</div>
			<!-- //스텝2 -->
			<!-- 예약완료 -->
			<div class="brWrap" id="stepDone">
				<p>
					<img src="/_ui/desktop/images/academy/brTextDone.gif"
						alt="예약이 완료 되었습니다. 이용해 주셔서 감사합니다." />
				</p>
				<div class="snsWrap">
					<!-- 20150313 : SNS영역 수정 -->
					<span class="snsLink"> <!-- @eidt 20160627 URL 복사 삭제 --> <a
						href="#" id="snsKs" class="snsCs"
						onclick="javascript:tempSharing('${httpDomain}', 'kakaoStory');"
						title="새창열림"><span class="hide">카카오스토리</span></a> <a href="#"
						class="snsBand"
						onclick="javascript:tempSharing('${httpDomain}', 'band');"
						title="새창열림"><span class="hide">밴드</span></a> <a href="#"
						id="snsFb" class="snsFb"
						onclick="javascript:tempSharing('${httpDomain}', 'facebook');"
						title="새창열림"><span class="hide">페이스북</span></a>
					</span>
					<!-- //20150313 : SNS영역 수정 -->
					<span class="snsText"><img
						src="/_ui/desktop/images/academy/sns_text.gif" alt="예약내역공유" /></span>
				</div>
				<div class="btnWrapC">
					<a href="javascript:void(0);" class="btnBasicGL">예약계속하기</a> <a
						href="javascript:void(0);"
						onclick="javascript:accessParentPage();" class="btnBasicBL">예약현황확인</a>
				</div>
			</div>
			<!-- //예약완료 -->
		</div>

	</section>
	<!-- //content area | ### academy IFRAME End ### -->

	<!-- //Adobe Analytics Footer 호출 include -->
	<%@ include
		file="/WEB-INF/jsp/framework/include/inc_analyticsFooter.jsp"%>

	<!-- 	<div class="skipNaviReturn"> -->
	<%@ include file="/WEB-INF/jsp/framework/include/footer.jsp"%>