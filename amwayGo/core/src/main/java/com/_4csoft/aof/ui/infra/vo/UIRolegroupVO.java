/*
 * Copyright (c) 1999 4CSoft Inc. All right reserved.
 * This software is the proprietary information of 4CSoft Inc.
 *
 */
package com._4csoft.aof.ui.infra.vo;

import java.io.Serializable;

import com._4csoft.aof.infra.support.util.StringUtil;
import com._4csoft.aof.infra.vo.RolegroupVO;

/**
 * @Project : aof5-demo-core
 * @Package : com._4csoft.aof.ui.infra.vo
 * @File : UIRolegroupVO.java
 * @Title : {간단한 프로그램의 명칭을 기록}
 * @date : 2013. 5. 8.
 * @author : 김종규
 * @descrption : {상세한 프로그램의 용도를 기록}
 */
public class UIRolegroupVO extends RolegroupVO implements Serializable {
	private static final long serialVersionUID = 1L;

	/** 상위 롤그룹명 */
	private String parentRolegroupName;

	/** 멀티 수정 처리 */
	private Long[] rolegroupSeqs;

	/** 신규등록시 셀렉트박스에서 rolegroupSeq(들어갈때는 parentSeq) + groupOrder 코드를 같이 받기 위한 변수 (예: 6::001001002) */
	private String groupOrderToken;

	/** 자신의 seq로 자식 그룹이 있는지 확인 자식이 있을경우 삭제 제한을 위한 값 */
	private Long sonCount;

	public String getParentRolegroupName() {
		return parentRolegroupName;
	}

	public void setParentRolegroupName(String parentRolegroupName) {
		this.parentRolegroupName = parentRolegroupName;
	}

	public Long[] getRolegroupSeqs() {
		return rolegroupSeqs;
	}

	public void setRolegroupSeqs(Long[] rolegroupSeqs) {
		this.rolegroupSeqs = rolegroupSeqs;
	}

	public String getGroupOrderToken() {
		return groupOrderToken;
	}

	public void setGroupOrderToken(String groupOrderToken) {
		this.groupOrderToken = groupOrderToken;

		// set 에서 parentSeq와 groupOrder 값 셋팅
		if (!StringUtil.isEmpty(groupOrderToken)) {
			String[] splitVar = groupOrderToken.split("::");
			if (splitVar.length == 2) {
				setParentSeq(Long.parseLong(splitVar[0]));
				setGroupOrder(splitVar[1]);
			}
		}
	}

	public Long getSonCount() {
		return sonCount;
	}

	public void setSonCount(Long sonCount) {
		this.sonCount = sonCount;
	}

}
