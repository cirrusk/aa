<%@ page pageEncoding="UTF-8"%><%@ include file="/WEB-INF/view/include/taglibs.jspf"%>
<html decorator="<c:out value="${param['type'] eq 'run' ? 'guide-run' : 'ajax'}"/>">
<head>
<title></title>
<c:import url="/WEB-INF/view/include/chart.jsp"/>
</head>
<body>

<div class="guide-info">
    <div class="guide-title">
        차트
    </div>

    <div class="guide-desc">
        차트를 사용할 경우 &lt;c:import url="/WEB-INF/view/include/chart.jsp"/> 를 상단에 꼭 해 주어야 한다. 
    </div>
</div>

<div class="guide-code runnable">
    <div class="desc">
       bar chart 
    </div>


    <div class="html">
    <table id="statistics1" class="tbl-detail">
			<tr>
				<td></td>
				<td>접속자수</td>
				<td>신규등록수</td>
				<td>어제등록수</td>
			</tr>
			<tr>
				<td>1</td>
				<td>82</td>
				<td>52</td>
				<td>23</td>
			</tr>
			<tr>
				<td>2</td>
				<td>89</td>
				<td>45</td>
				<td>52</td>
			</tr>	
			<tr>
				<td>3</td>
				<td>82</td>
				<td>62</td>
				<td>45</td>
			</tr>
			<tr>
				<td>4</td>
				<td>80</td>
				<td>77</td>
				<td>62</td>
			</tr>
			<tr>
				<td>5</td>
				<td>92</td>
				<td>37</td>
				<td>77</td>
			</tr>					
	</table>
    </div>

    <div class="javascript">
			doCreateBarChart = function() {
				var strDomainName = "일";
				var strMaxCount = "100";
				var strBarWidth ="5";
			    var strDataTableID ="statistics1";
				var options = {
					chartCss : {
						width : "100%",
						height : "300px"
					},
					legend : { <%-- 범례 --%>
						style : "text-align:right;"
					},
					plot : {<%--  차트영역 --%>
						margin : {left : 50, right : 20, top : 20, bottom : 40}
					},
					domain : { <%--  기준축 --%>
						label : {
							name : strDomainName,
							position : "right"
						}
					},
					range : { <%--  값 축 --%>
						label : {
							name : "인원수",
							position : "top"
						},
						grid : {
							visibleStep : parseInt((parseInt(strMaxCount, 10) / 10), 10)
						},
						tick : {
							visibleStep : parseInt((parseInt(strMaxCount, 10) / 10), 10)
						},
						bound : {
							upper : parseFloat(strMaxCount)
						}
					},
					data : { <%--  데이타 --%>
						barWidth : parseInt(strBarWidth, 10),
						colors : ["#ff0000", "#0000ff","#CCCCCC"]
					}
				};
				jQuery.barchart(strDataTableID, options);
			};
	
			doCreateBarChart();
    </div>

</div>


<div class="guide-code runnable">
    <div class="desc">
       piechart chart 
    </div>


    <div class="html">
    <table id="statistics2" >
			<tr>
				<td></td>
				<td>접속자수</td>
				<td>신규등록수</td>
				<td>어제등록수</td>
			</tr>
			<tr>
				<td>1</td>
				<td>82</td>
				<td>52</td>
				<td>23</td>
			</tr>
			<tr>
				<td>2</td>
				<td>89</td>
				<td>45</td>
				<td>52</td>
			</tr>	
			<tr>
				<td>3</td>
				<td>82</td>
				<td>62</td>
				<td>45</td>
			</tr>
			<tr>
				<td>4</td>
				<td>80</td>
				<td>77</td>
				<td>62</td>
			</tr>
			<tr>
				<td>5</td>
				<td>92</td>
				<td>37</td>
				<td>77</td>
			</tr>	
	</table>
    </div>

    <div class="javascript">
			doCreatePieChart = function() {
				var strDomainName = "일";
				var strMaxCount = "100";
				var strBarWidth ="5";
			    var strDataTableID ="statistics2";
				var options = {
					chartCss : {
						width : "100%",
						height : "300px"
					},
					legend : { <%-- 범례 --%>
						style : "text-align:right;"
					},
					plot : {  <%-- 차트영역 --%>
						margin : {left : 50, right : 20, top : 20, bottom : 40}
					},
					domain : {  <%--  기준축 --%>
						label : {
							name : strDomainName,
							position : "center"
						}
					},
					range : { <%--   값 축 --%>
						label : {
							name : "인원수",
							position : "top"
						},
						grid : {
							visibleStep : parseInt((parseInt(strMaxCount, 10) / 10), 10)
						},
						tick : {
							visibleStep : parseInt((parseInt(strMaxCount, 10) / 10), 10)
						},
						bound : {
							upper : parseFloat(strMaxCount)
						}
					},
					data : {  <%--  데이타 --%>
						barWidth : parseInt(strBarWidth, 10),
						colors : ["#ff0000", "#0000ff","#CCCCCC"]
					}
				};
				jQuery.piechart(strDataTableID, options);
			};
	
			doCreatePieChart();
    </div>

</div>



<div class="guide-code runnable">
    <div class="desc">
       bar chart 
    </div>


    <div class="html">
    <table id="statistics3" class="tbl-detail">
			<tr>
				<td></td>
				<td>접속자수</td>
				<td>신규등록수</td>
				<td>어제등록수</td>
			</tr>
			<tr>
				<td>1</td>
				<td>82</td>
				<td>52</td>
				<td>23</td>
			</tr>
			<tr>
				<td>2</td>
				<td>89</td>
				<td>45</td>
				<td>52</td>
			</tr>	
			<tr>
				<td>3</td>
				<td>82</td>
				<td>62</td>
				<td>45</td>
			</tr>
			<tr>
				<td>4</td>
				<td>80</td>
				<td>77</td>
				<td>62</td>
			</tr>
			<tr>
				<td>5</td>
				<td>92</td>
				<td>37</td>
				<td>77</td>
			</tr>						
	</table>
    </div>

    <div class="javascript">
			doCreateLineChart = function() {
				var strDomainName = "일";
				var strMaxCount = "100";
				var strBarWidth ="5";
			    var strDataTableID ="statistics3";
				var options = {
					chartCss : {
						width : "100%",
						height : "300px"
					},
					legend : { <%-- 범례 --%>
						style : "text-align:right;"
					},
					plot : {  <%-- 차트영역 --%>
						margin : {left : 50, right : 20, top : 20, bottom : 40}
					},
					domain : {   <%--  기준축 --%>
						label : {
							name : strDomainName,
							position : "right"
						}
					},
					range : { <%--   값 축 --%>
						label : {
							name : "인원수",
							position : "top"
						},
						grid : {
							visibleStep : parseInt((parseInt(strMaxCount, 10) / 10), 10)
						},
						tick : {
							visibleStep : parseInt((parseInt(strMaxCount, 10) / 10), 10)
						},
						bound : {
							upper : parseFloat(strMaxCount)
						}
					},
					data : {  <%--  데이타 --%>
						barWidth : parseInt(strBarWidth, 10),
						colors : ["#ff0000", "#0000ff","#CCCCCC"]
					}
				};
				jQuery.linechart(strDataTableID, options);
			};
	
			doCreateLineChart();
    </div>

</div>

</body>
</html>