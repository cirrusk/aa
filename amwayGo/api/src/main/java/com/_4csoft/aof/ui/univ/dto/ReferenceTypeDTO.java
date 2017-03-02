package com._4csoft.aof.ui.univ.dto;

import java.io.Serializable;

public class ReferenceTypeDTO implements Serializable {
	private static final long serialVersionUID = 1L;

	// 각 일련번호
	private Long typeSeq;
	
	// 제목
	private String title;
	
	// 시작일
	private String startDtime;
	
	// 종료일
	private String endDtime;
	
	// 요소 타입(중간,기말,보충 구분) 
	private String kindTypeCd;
	
	// 시험 제한시간
	private Long limitTime;
	
	// 상태 (대기, 진행, 종료)
	private String Status;
	
	// 시작시간(시험&과제 2차기간, 팀프로젝트 과제기간)
	private String startDtimeSec;
	
	// 종료기간(시험&과제 2차기간, 팀프로젝트 과제기간)
	private String endDtimeSec;
	
	// 진행상태(팀프로젝트 과제 제출여부)
	private String process;
	
	// 진행상태(팀프로젝트 게시판 참여여부)
	private String processSec;
	
	// 토론 내글수
	private Long bbsMemberCount;
	
	// 토론 전체글수
	private Long bbsCount;
	
	// 제출일
	private String sendDtime;
	
	// 상세페이지 url
	private String detailUrl;

	public Long getTypeSeq() {
		return typeSeq;
	}

	public void setTypeSeq(Long typeSeq) {
		this.typeSeq = typeSeq;
	}

	public String getTitle() {
		return title;
	}

	public void setTitle(String title) {
		this.title = title;
	}

	public String getStartDtime() {
		return startDtime;
	}

	public void setStartDtime(String startDtime) {
		this.startDtime = startDtime;
	}

	public String getEndDtime() {
		return endDtime;
	}

	public void setEndDtime(String endDtime) {
		this.endDtime = endDtime;
	}

	public String getKindTypeCd() {
		return kindTypeCd;
	}

	public void setKindTypeCd(String kindTypeCd) {
		this.kindTypeCd = kindTypeCd;
	}

	public Long getLimitTime() {
		return limitTime;
	}

	public void setLimitTime(Long limitTime) {
		this.limitTime = limitTime;
	}

	public String getStatus() {
		return Status;
	}

	public void setStatus(String status) {
		Status = status;
	}

	public String getStartDtimeSec() {
		return startDtimeSec;
	}

	public void setStartDtimeSec(String startDtimeSec) {
		this.startDtimeSec = startDtimeSec;
	}

	public String getEndDtimeSec() {
		return endDtimeSec;
	}

	public void setEndDtimeSec(String endDtimeSec) {
		this.endDtimeSec = endDtimeSec;
	}

	public String getProcess() {
		return process;
	}

	public void setProcess(String process) {
		this.process = process;
	}

	public String getProcessSec() {
		return processSec;
	}

	public void setProcessSec(String processSec) {
		this.processSec = processSec;
	}

	public Long getBbsMemberCount() {
		return bbsMemberCount;
	}

	public void setBbsMemberCount(Long bbsMemberCount) {
		this.bbsMemberCount = bbsMemberCount;
	}

	public Long getBbsCount() {
		return bbsCount;
	}

	public void setBbsCount(Long bbsCount) {
		this.bbsCount = bbsCount;
	}

	public String getSendDtime() {
		return sendDtime;
	}

	public void setSendDtime(String sendDtime) {
		this.sendDtime = sendDtime;
	}

	public String getDetailUrl() {
		return detailUrl;
	}

	public void setDetailUrl(String detailUrl) {
		this.detailUrl = detailUrl;
	}
	
}
