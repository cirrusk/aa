<%@ page pageEncoding="UTF-8"%><%@ include file="/WEB-INF/view/include/taglibs.jspf" %>

<form name="FormDetailTeam" id="FormDetailTeam" method="post" onsubmit="return false;">
    <input type="hidden" name="courseTeamProjectSeq"/>
    <input type="hidden" name="courseTeamSeq"/>
    <input type="hidden" name="courseApplySeq"/>
</form>

<form name="FormDetailHomework" id="FormDetailHomework" method="post" onsubmit="return false;">
    <input type="hidden" name="courseTeamProjectSeq"/>
    <input type="hidden" name="courseTeamSeq"/>
    <input type="hidden" name="courseApplySeq"/>
</form>

<form name="FormEditHomework" id="FormEditHomework" method="post" onsubmit="return false;">
    <input type="hidden" name="courseTeamSeq"/>
    <input type="hidden" name="courseApplySeq"/>
</form>

<form name="FormProjectTeamHome" id="FormProjectTeamHome" method="post" onsubmit="return false;">
    <input type="hidden" name="courseApplySeq"/>
</form>

<form name="FormMutualeval" id="FormMutualeval" method="post" onsubmit="return false;">
    <input type="hidden" name="courseTeamProjectSeq"/>
    <input type="hidden" name="courseTeamSeq"/>
    <input type="hidden" name="courseApplySeq"/>
</form>