package com._4csoft.aof.ui.api.dto;

import java.io.Serializable;
import java.util.List;


public class HelpdeskBbsDTO implements Serializable {
	private static final long serialVersionUID = 1L;
	
	private Long bbsSeq;
	private String bbsTitle;
	private String secretYn;
	private String replyYn;
	private Long attachCount;
	private List<AttachDTO> attachList;
	private String articleUrl;
	private String regMemberName;
	private String regDtime;
	private Long viewCount;
	
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
	
}