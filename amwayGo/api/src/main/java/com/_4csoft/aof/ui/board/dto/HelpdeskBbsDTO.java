package com._4csoft.aof.ui.board.dto;

import java.io.Serializable;
import java.util.List;

import com._4csoft.aof.ui.univ.dto.AttachDTO;

public class HelpdeskBbsDTO implements Serializable {
	private static final long serialVersionUID = 1L;

	private Long bbsSeq;
	private String bbsTitle;
	private String bbsDescription;
	private String secretYn;
	private String replyYn;
	private Long attachCount;
	private List<AttachDTO> attachList;
	private String articleUrl;
	private String regMemberName;
	private Long regMemberSeq;
	private String regDtime;
	private Long viewCount;
	private Long likeSum;
	private String companyName;
	private String position;

	/** 다운로드 가능여부 */
	private String downloadYn;

	/** cs_board_seq : 게시판 일련번호 */
	private Long boardSeq;

	/** cs_description : 내용 */
	private String description;
	
	/** likeYn : 좋아요여부 - like_history 카운트 */
	private String likeYn;

	/** cs_bbs_type : 게시글 유형 : 예) 공지사항(NOTICE) : 전체공지, 학사공지,일반공지, FAQ(FAQ) : 로그인, 학습, 시스템장애 */
	private String bbsTypeCd;

	/** cs_always_top_yn : 최상위 공지 여부 */
	private String alwaysTopYn;

	/** cs_html_yn : html 여부 */
	private String htmlYn;
	/** cs_target_rolegroup : 대상자 그룹 */
	private String targetRolegroup;

	/** cs_comment_count : 댓글수 */
	private Long commentCount;

	/** cs_parent_seq : 부모 일련번호 */
	private Long parentSeq;

	/** cs_group_seq : 그룹 일련번호 */
	private Long groupSeq;

	/** cs_group_level : 그룹 단계 */
	private Long groupLevel;

	/** cs_group_order : 그룹 순서 */
	private String groupOrder;

	/** 에디터 이미지 업로드 정보 (멀티 파일이면 콤마로 구분한다) */
	private String editorPhotoInfo;

	/** 원본글 게시자(답변등록시) */
	private Long parentRegMemberSeq;

	/** 알림메세지 사용여부 */
	private String alarmUseYn;

	/** 메세지 템플릿 타입 */
	private String templateTypeCd;

	/** cs_send_schedule_cd : 예약발송구분코드 */
	private String sendScheduleCd;

	/** cs_schedule_dtime : 예약발송시간 */
	private String scheduleDtime;
	
	private String regMemberPhoto;
	
	private String commSeq;
	
	/** 댓글내용 */
	private String commDescription;
	
	/** 댓글날짜 */
	private String commRegDtime;
	
	/** 댓글나만보기 */
	private String commSecretYn;

	public Long getBbsSeq() {
		return bbsSeq;
	}

	public void setBbsSeq(Long bbsSeq) {
		this.bbsSeq = bbsSeq;
	}

	public String getBbsTitle() {
		return bbsTitle;
	}

	public void setBbsTitle(String bbsTitle) {
		this.bbsTitle = bbsTitle;
	}
	
	public String getBbsDescription() {
		return bbsDescription;
	}

	public void setBbsDescription(String bbsDescription) {
		this.bbsDescription = bbsDescription;
	}
	

	public String getSecretYn() {
		return secretYn;
	}

	public void setSecretYn(String secretYn) {
		this.secretYn = secretYn;
	}

	public String getReplyYn() {
		return replyYn;
	}

	public void setReplyYn(String replyYn) {
		this.replyYn = replyYn;
	}

	public Long getAttachCount() {
		return attachCount;
	}

	public void setAttachCount(Long attachCount) {
		this.attachCount = attachCount;
	}

	public List<AttachDTO> getAttachList() {
		return attachList;
	}

	public void setAttachList(List<AttachDTO> attachList) {
		this.attachList = attachList;
	}

	public String getArticleUrl() {
		return articleUrl;
	}

	public void setArticleUrl(String articleUrl) {
		this.articleUrl = articleUrl;
	}

	public String getRegMemberName() {
		return regMemberName;
	}

	public void setRegMemberName(String regMemberName) {
		this.regMemberName = regMemberName;
	}

	public String getRegDtime() {
		return regDtime;
	}

	public void setRegDtime(String regDtime) {
		this.regDtime = regDtime;
	}

	public Long getViewCount() {
		return viewCount;
	}

	public void setViewCount(Long viewCount) {
		this.viewCount = viewCount;
	}

	public Long getBoardSeq() {
		return boardSeq;
	}

	public void setBoardSeq(Long boardSeq) {
		this.boardSeq = boardSeq;
	}

	public String getDescription() {
		return description;
	}

	public void setDescription(String description) {
		this.description = description;
	}

	public String getBbsTypeCd() {
		return bbsTypeCd;
	}

	public void setBbsTypeCd(String bbsTypeCd) {
		this.bbsTypeCd = bbsTypeCd;
	}

	public String getAlwaysTopYn() {
		return alwaysTopYn;
	}

	public void setAlwaysTopYn(String alwaysTopYn) {
		this.alwaysTopYn = alwaysTopYn;
	}

	public String getHtmlYn() {
		return htmlYn;
	}

	public void setHtmlYn(String htmlYn) {
		this.htmlYn = htmlYn;
	}

	public String getTargetRolegroup() {
		return targetRolegroup;
	}

	public void setTargetRolegroup(String targetRolegroup) {
		this.targetRolegroup = targetRolegroup;
	}

	public Long getCommentCount() {
		return commentCount;
	}

	public void setCommentCount(Long commentCount) {
		this.commentCount = commentCount;
	}

	public Long getParentSeq() {
		return parentSeq;
	}

	public void setParentSeq(Long parentSeq) {
		this.parentSeq = parentSeq;
	}

	public Long getGroupSeq() {
		return groupSeq;
	}

	public void setGroupSeq(Long groupSeq) {
		this.groupSeq = groupSeq;
	}

	public Long getGroupLevel() {
		return groupLevel;
	}

	public void setGroupLevel(Long groupLevel) {
		this.groupLevel = groupLevel;
	}

	public String getGroupOrder() {
		return groupOrder;
	}

	public void setGroupOrder(String groupOrder) {
		this.groupOrder = groupOrder;
	}

	public String getEditorPhotoInfo() {
		return editorPhotoInfo;
	}

	public void setEditorPhotoInfo(String editorPhotoInfo) {
		this.editorPhotoInfo = editorPhotoInfo;
	}

	public Long getParentRegMemberSeq() {
		return parentRegMemberSeq;
	}

	public void setParentRegMemberSeq(Long parentRegMemberSeq) {
		this.parentRegMemberSeq = parentRegMemberSeq;
	}

	public String getAlarmUseYn() {
		return alarmUseYn;
	}

	public void setAlarmUseYn(String alarmUseYn) {
		this.alarmUseYn = alarmUseYn;
	}

	public String getTemplateTypeCd() {
		return templateTypeCd;
	}

	public void setTemplateTypeCd(String templateTypeCd) {
		this.templateTypeCd = templateTypeCd;
	}

	public String getSendScheduleCd() {
		return sendScheduleCd;
	}

	public void setSendScheduleCd(String sendScheduleCd) {
		this.sendScheduleCd = sendScheduleCd;
	}

	public String getScheduleDtime() {
		return scheduleDtime;
	}

	public void setScheduleDtime(String scheduleDtime) {
		this.scheduleDtime = scheduleDtime;
	}

	public Long getRegMemberSeq() {
		return regMemberSeq;
	}

	public void setRegMemberSeq(Long regMemberSeq) {
		this.regMemberSeq = regMemberSeq;
	}

	public Long getLikeSum() {
		return likeSum;
	}

	public void setLikeSum(Long likeSum) {
		this.likeSum = likeSum;
	}

	public String getDownloadYn() {
		return downloadYn;
	}

	public void setDownloadYn(String downloadYn) {
		this.downloadYn = downloadYn;
	}

	public String getRegMemberPhoto() {
		return regMemberPhoto;
	}

	public void setRegMemberPhoto(String regMemberPhoto) {
		this.regMemberPhoto = regMemberPhoto;
	}

	public String getCompanyName() {
		return companyName;
	}

	public void setCompanyName(String companyName) {
		this.companyName = companyName;
	}

	public String getPosition() {
		return position;
	}

	public void setPosition(String position) {
		this.position = position;
	}

	public String getLikeYn() {
		return likeYn;
	}

	public void setLikeYn(String likeYn) {
		this.likeYn = likeYn;
	}
	
	public String getCommSeq() {
		return commSeq;
	}

	public void setCommSeq(String commSeq) {
		this.commSeq = commSeq;
	}

	public String getCommDescription() {
		return commDescription;
	}

	public void setCommDescription(String commDescription) {
		this.commDescription = commDescription;
	}

	public String getCommRegDtime() {
		return commRegDtime;
	}

	public void setCommRegDtime(String commRegDtime) {
		this.commRegDtime = commRegDtime;
	}

	public String getCommSecretYn() {
		return commSecretYn;
	}

	public void setCommSecretYn(String commSecretYn) {
		this.commSecretYn = commSecretYn;
	}

}