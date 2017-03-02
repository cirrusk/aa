/*
 * Copyright (c) 1999 4CSoft Inc. All right reserved.
 * This software is the proprietary information of 4CSoft Inc.
 *
 */
package com._4csoft.aof.ui.infra.support;

import org.springframework.security.authentication.encoding.ShaPasswordEncoder;

import com._4csoft.aof.infra.support.security.PasswordEncoder;
import com._4csoft.aof.support.util.StaticEncEngine;

/**
 * @Project : lgaca-api
 * @Package : com._4csoft.aof.ui.infra.support
 * @File : UIAPIPasswordEncoder.java
 * @Title : {간단한 프로그램의 명칭을 기록}
 * @date : 2015. 3. 28.
 * @author : 노성용
 * @descrption : {상세한 프로그램의 용도를 기록}
 */
public class UIAPIPasswordEncoder extends ShaPasswordEncoder implements PasswordEncoder {
	private boolean useSalt = true;

	public UIAPIPasswordEncoder() {
		super(1);
	}

	public UIAPIPasswordEncoder(int strength) {
		super(strength);
	}

	/**
	 * 비밀번호 인코딩
	 * 
	 * 인코딩을 하지 않으려면 rawPass를 return 해주면 된다
	 */
	public String encodePassword(String rawPass, Object salt) {

		if (rawPass.length() > 31) {
			try {

				String enckey = rawPass.substring(0, 31);
				String encpasskey = rawPass.substring(31, rawPass.length());

				StaticEncEngine instance = StaticEncEngine.getInstance(enckey);
				rawPass = instance.getEnc(encpasskey);

			} catch (Exception e) {
				// log.debug("encodePassword ERROR rawPass : " + rawPass + " salt : " + salt);
				rawPass = "";

			}
		}

		return super.encodePassword(rawPass, salt);
	}

	/**
	 * salt 사용여부 설정
	 * 
	 * @param useSalt
	 */
	public void setUseSalt(boolean useSalt) {
		this.useSalt = useSalt;
	}

	/**
	 * salt 사용여부
	 * 
	 * @return
	 * @throws Exception
	 */
	public boolean isUseSalt() throws Exception {
		return this.useSalt;
	}
}
