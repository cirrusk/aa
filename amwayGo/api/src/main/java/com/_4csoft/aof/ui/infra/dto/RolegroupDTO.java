package com._4csoft.aof.ui.infra.dto;

import java.io.Serializable;

public class RolegroupDTO implements Serializable {
	private static final long serialVersionUID = 1L;
	/** cs_rolegroup_seq : 롤그룹일련번호 */
	private Long rolegroupSeq;

	/** cs_rolegroup_name : 롤그룹명 */
	private String rolegroupName;

	/** cs_cf_string : 참조문자열 */
	private String cfString;

	/** cs_sort_order : 정렬순서 */
	private Long sortOrder;

	/** cs_role_cd : 롤코드 */
	private String roleCd;

	public Long getRolegroupSeq() {
		return rolegroupSeq;
	}

	public void setRolegroupSeq(Long rolegroupSeq) {
		this.rolegroupSeq = rolegroupSeq;
	}

	public String getRolegroupName() {
		return rolegroupName;
	}

	public void setRolegroupName(String rolegroupName) {
		this.rolegroupName = rolegroupName;
	}

	public String getCfString() {
		return cfString;
	}

	public void setCfString(String cfString) {
		this.cfString = cfString;
	}

	public Long getSortOrder() {
		return sortOrder;
	}

	public void setSortOrder(Long sortOrder) {
		this.sortOrder = sortOrder;
	}

	public String getRoleCd() {
		return roleCd;
	}

	public void setRoleCd(String roleCd) {
		this.roleCd = roleCd;
	}

}
