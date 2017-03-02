<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%//@ page import="framework.com.cmm.util.StringUtil"%>

<%
	String sColNum = (String) request.getParameter("colNumIndex");
	String sThisIndex = (String) request.getParameter("thisIndex");
	String sLastPage = (String) request.getParameter("totalPage");
	
	if ((sColNum == null) || (sColNum.trim().equals(""))) {
		sColNum = "10";
	}
	if ((sThisIndex == null) || (sThisIndex.trim().equals(""))) {
		sThisIndex = "1";
	}
	if ((sLastPage == null) || (sLastPage.trim().equals(""))) {
		sLastPage = "1";
	}
	
	int colNum = Integer.parseInt(sColNum); 		// 화면에 표시할 페이지 수.
	int thisIndex = Integer.parseInt(sThisIndex); // 선택페이지
	int lastPage = Integer.parseInt(sLastPage);	// 마지막페이지
	
	int lastIndex = 0;
	if (lastPage == 0) { 
		lastIndex = 1; 
	} else {
		lastIndex = lastPage;
	}
	
	int firstIndex = 1;			//처음페이지
	int stIndex = 1;				//인덱스시작번호
	int edIndex = colNum;	//인덱스끝번호
	int prevIndex = 1;			//이전페이지
	int nextIndex = lastIndex; //다음페이지
	
	//인덱스시작번호 설정.
	if ( (thisIndex-colNum)<1 )  {
		stIndex = 1;
	} else if ( (thisIndex%colNum)==0 ) {
		stIndex = ((thisIndex/colNum) -1) * colNum +1;
	} else 	{
		stIndex = (thisIndex/colNum) * colNum +1;
	}
	
	//인덱스끝번호 설정.
	if ( (thisIndex%colNum)>0 ) {
		edIndex = ((thisIndex/colNum) +1) * colNum;
	} else 	{
		edIndex = (thisIndex/colNum) * colNum;
	}
	if ( edIndex > lastIndex ) {
		edIndex = lastIndex;
	}

	//이전페이지 설정
	if ( (thisIndex-1)<1 ) {
		prevIndex = 1;
	} else 	{
		prevIndex = thisIndex-1;
	}
	
	//다음페이지 설정
	if ( (thisIndex +1)>lastIndex ) {
		nextIndex = lastIndex;
	} else 	{
		nextIndex = thisIndex +1;
	}
/*
	//이전페이지 설정
	if ( (stIndex-colNum)<1 ) prevIndex = 1;
	else 							prevIndex = stIndex-colNum;
	
	//다음페이지 설정
	if ( (edIndex +1)>lastIndex ) nextIndex = lastIndex;
	else 									nextIndex = edIndex +1;
*/	
%>
				<div class="paging">
				<% if(thisIndex==firstIndex) { %>
					<a href="#none" class="pagingFirst" ><span class="hide">처음 페이지로 이동</span></a>
				<% } else { %>
					<a href="#" class="pagingFirst" onClick="indexpageRtn('<%=firstIndex%>')"></a>
				<% } 
				 	 if(thisIndex==prevIndex) { %>
					<a href="#none" class="pagingPrev"><span class="hide">이전 페이지로 이동</span></a>
				<% } else { %>
					<a href="#" class="pagingPrev" onClick="indexpageRtn('<%=prevIndex%>')"></a>
				<% } %>
					<span class="list">
				<% for(int i=stIndex; i<=edIndex; i++ ) { 
						if( i == thisIndex) { %>
						<strong><span class="hide">현재페이지</span><%=i %></strong>
				<%	} else { %>
						<a href="#none" onClick="indexpageRtn('<%=i %>')"><%=i %></a>		
				<% 	} 
					  }  %>
					</span>
				<% if(thisIndex==nextIndex) { %>
					<a href="#none" class="pagingNext"><span class="hide">다음 페이지로 이동</span></a>
				<% } else { %>
					<a href="#" class="pagingNext" onClick="indexpageRtn('<%=nextIndex%>')"></a>
				<% } %>
				<% if(thisIndex==lastIndex) { %>
					<a href="#none" class="pagingLast"><span class="hide">마지막 페이지로 이동</span></a>
				<% } else { %>
					<a href="#" class="pagingLast" onClick="indexpageRtn('<%=lastIndex%>')"></a>
				<% } %>
				</div>

<script type="text/javascript">
	function indexpageRtn(currIdx) {
		// 페이지이동 호출.
		doPage(currIdx);
	}
</script>

