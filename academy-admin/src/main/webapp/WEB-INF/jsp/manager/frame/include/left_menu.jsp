<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<script type="text/javascript">

	var leftMenuTree = new AXTree();
	 
	var fnObjLeftMenu = {
		tree2: function(){

			leftMenuTree.setConfig({
				targetID : "AXTreeLeftMenu",
				theme : "AXTree_none",
				//height : "auto",
				xscroll : false,
				indentRatio : 0.7,
				reserveKeys : {
					parentHashKey : "pHash",	// 부모 트리 포지션
					hashKey : "hash", 			// 트리 포지션
					openKey : "open", 			// 확장여부
					subTree : "subTree", 		// 자식개체키
					displayKey : "display" 		// 표시여부
				},
				colGroup: [
					{
						key : "nodeName",
						label : "제목",
						align : "left",
						indent : true
						, relation: {
							parentKey: "upperGroup"	// 부모아이디 키
							, childKey: "menuCd" 	// 자식아이디 키 
						}
						, getIconClass : function(){
							//folder, AXfolder, movie, img, zip, file, fileTxt, fileTag
							var iconNames = "folder, AXfolder, movie, img, zip, file, fileTxt, fileTag".split(/, /g);
							var iconName = "file";
							//if(this.item.type) iconName = iconNames[this.item.type];
							return iconName;
						},
						formatter:function(){
							return "<b class=\"bigFont\">"+this.item.menuText + "</b>";// + this.item.activity
						}
					}
				],
				body: {
					onclick:function(idx, item){
						//toast.push(Object.toJSON(this.item));
						var jsonObj = JSON.parse(Object.toJSON(this.item));
						if(jsonObj.linkurl == "#" && jsonObj.menuYn == "Y"){
							//alert('준비중입니다');
							//페이지 이동시에 아래 주석 풀고 저리
							addTabMenu(Object.toJSON(this.item));
						} else if(jsonObj.linkurl == "#" && jsonObj.menuYn != "Y"){
							// 폴더이므로 Tree 펼침 처리 필요
							leftMenuTree.expandToggleList(idx, item, true);
							//leftMenuTree.click(idx, "open", true);
						} else {
							addTabMenu(Object.toJSON(this.item));
						}
					}
				}
			});

		}
	};
	
	$(document).ready(function(){
		fnObjLeftMenu.tree2();		// Tree

		//Array - list Array setConfig 에서 정의한 relation 의 부모, 자식키 값을 이용하여 list형 데이터를 tree형 데이터로 변환하여 트리를 구성합니다.
		var List = [{}];
		var treeData = {};
		
		<c:forEach var="leftMenu" items="${adminLeftMenu}" varStatus="status">
		treeData = {};
		treeData.no = "${leftMenu.menucode}";
		treeData.pno = "${leftMenu.uppergroup}";
		//treeData.nodeName = "${leftMenu.menucode}";
		//treeData.activity = "${leftMenu.menuname}";
		treeData.menuCd = "${leftMenu.menucode}";
		treeData.upperGroup = "${leftMenu.uppergroup}";
		treeData.menuText = "${leftMenu.menuname}";
		treeData.linkurl = "${leftMenu.linkurl}";
		treeData.menuYn = "${leftMenu.menuyn}";
		treeData.menuAuth = "${leftMenu.menuauth}";
		List[${status.count - 1}] = treeData;
		</c:forEach>
		/* 
		treeData = {};
		treeData.no = "top_1";
		treeData.pno = "Academy";
		treeData.menuCd = "top_1";
		treeData.upperGroup = "Academy";
		treeData.menuText = "시스템 관리";
		treeData.linkurl = "#";
		treeData.menuYn = "N";
		List[${fn:length(adminLeftMenu)}] = treeData;
		
		treeData = {};
		treeData.no = "bbs_1";
		treeData.pno = "top_1";
		treeData.menuCd = "bbs_1";
		treeData.upperGroup = "top_1";
		treeData.menuText = "메뉴  관리";
		treeData.linkurl = "/manager/common/menu/menuList.do";
		treeData.menuYn = "Y";
		List[${fn:length(adminLeftMenu)} + 1] = treeData;
		
        treeData = {};
        treeData.no = "bbs_2";
        treeData.pno = "top_1";
        treeData.menuCd = "bbs_2";
        treeData.upperGroup = "top_1";
        treeData.menuText = "Q&A관리";
        treeData.linkurl = "/manage/common/bbs/manageBbsList.mvc";
        treeData.menuYn = "Y";
        List[${fn:length(adminLeftMenu)} + 2] = treeData;

        treeData = {};
        treeData.no = "bbs_3";
        treeData.pno = "top_1";
        treeData.menuCd = "bbs_3";
        treeData.upperGroup = "top_1";
        treeData.menuText = "자료실 관리";
        treeData.linkurl = "/manage/common/bbs/manageBbsList.mvc";
        treeData.menuYn = "Y";
        List[${fn:length(adminLeftMenu)} + 3] = treeData;
 */
        leftMenuTree.setList(List);
	});

</script>

		<div id="lnbwrap">
<!-- 			<div class="tree_search"><label for="treesearch"><img src="/static/axisj/ui/arongi/images/icon_tree_search.png" width="29" height="29" /></label><input name="" type="text" id="treesearch" /></div> -->
			<div id="AXTreeLeftMenu" class="lnb"></div>
		</div>