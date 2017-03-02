package com._4csoft.aof.ui.univ.vo;

import java.io.Serializable;

import com._4csoft.aof.univ.vo.UnivCourseActiveOrganizationItemVO;

/**
 * @Project : aof5-univ-ui-admin
 * @Package : com._4csoft.aof.ui.univ.vo
 * @File : UIUnivCourseActiveOrganizaionItemVO.java
 * @Title : 개설과목 주차 학습보조자료
 * @date : 2014. 4. 7.
 * @author : 장용기
 * @descrption : {상세한 프로그램의 용도를 기록}
 */
public class UIUnivCourseActiveOrganizationItemVO extends UnivCourseActiveOrganizationItemVO implements Serializable {
	private static final long serialVersionUID = 1L;
	
	/** */
	private Long [] organizationItemSeqs;
	
	/** */
	private Long [] activeSeqs;
	
	/** */
	private Long [] elementSeqs;
	
	/** */
	private Long [] organizationSeqs;
	
	/** */
	private Long [] itemSeqs;
	
	/** 첨부파일 업로드 정보 (멀티 파일이면 콤마로 구분한다) */
	private String [] attachUploadInfos;
	
	/** 첨부파일 삭제 정보 (멀티 파일이면 콤마로 구분한다) */
	private String [] attachDeleteInfos;

	public Long[] getOrganizationItemSeqs() {
		return organizationItemSeqs;
	}

	public void setOrganizationItemSeqs(Long[] organizationItemSeqs) {
		this.organizationItemSeqs = organizationItemSeqs;
	}
	
	public Long[] getActiveSeqs() {
		return activeSeqs;
	}

	public void setActiveSeqs(Long[] activeSeqs) {
		this.activeSeqs = activeSeqs;
	}

	public Long[] getElementSeqs() {
		return elementSeqs;
	}

	public void setElementSeqs(Long[] elementSeqs) {
		this.elementSeqs = elementSeqs;
	}

	public Long[] getOrganizationSeqs() {
		return organizationSeqs;
	}

	public void setOrganizationSeqs(Long[] organizationSeqs) {
		this.organizationSeqs = organizationSeqs;
	}

	public Long[] getItemSeqs() {
		return itemSeqs;
	}

	public void setItemSeqs(Long[] itemSeqs) {
		this.itemSeqs = itemSeqs;
	}

	public String[] getAttachUploadInfos() {
		return attachUploadInfos;
	}

	public void setAttachUploadInfos(String[] attachUploadInfos) {
		this.attachUploadInfos = attachUploadInfos;
	}

	public String[] getAttachDeleteInfos() {
		return attachDeleteInfos;
	}

	public void setAttachDeleteInfos(String[] attachDeleteInfos) {
		this.attachDeleteInfos = attachDeleteInfos;
	}
	
}