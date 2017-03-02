package com._4csoft.aof.ui.infra.service.impl;

import java.io.File;
import java.util.ArrayList;
import java.util.List;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import com._4csoft.aof.infra.support.Constants;
import com._4csoft.aof.infra.support.util.MailUtil;
import com._4csoft.aof.infra.vo.base.ResultSet;
import com._4csoft.aof.ui.infra.service.UIEmailSendService;
import com._4csoft.aof.ui.infra.vo.resultset.UIMessageReceiveRS;

import egovframework.rte.fdl.cmmn.AbstractServiceImpl;

/**
 * 
 * @Project : aof5-univ-ui-core
 * @Package : com._4csoft.aof.ui.infra.service
 * @File : UIEmailSendServiceImpl.java
 * @Title : 이메일 발송서비스
 * @date : 2014. 4. 3.
 * @author : 김영학
 * @descrption : {상세한 프로그램의 용도를 기록}
 */
@Service ("UIEmailSendService")
public class UIEmailSendServiceImpl extends AbstractServiceImpl implements UIEmailSendService {

	@Resource (name = "MailUtil")
	protected MailUtil mailUtil;

	
	/**
	 * 메일 발송
	 */
	public boolean send(ResultSet messageReceive) throws Exception {

		boolean success = false;

		File file = null;
		String filePath = null;

		UIMessageReceiveRS rs = (UIMessageReceiveRS)messageReceive;

		// 첨부파일조회
		if (rs.getMessageSend().getAttachCount() > 0) {
			if (rs.getMessageSend().getAttachList() != null && rs.getMessageSend().getAttachList().size() > 0) {
				for (int index = 0; index < rs.getMessageSend().getAttachList().size(); index++) {
					filePath = Constants.UPLOAD_PATH_FILE + rs.getMessageSend().getAttachList().get(index).getSavePath() + "/"
							+ rs.getMessageSend().getAttachList().get(index).getSaveName();
				}
			}
		}

		// 파일생성
		if (filePath != null) {
			file = new File(filePath);
		}

		// 템플릿 메세지 변환
		String emailMessage = messageReplace(rs.getMessageSend().getDescription(), rs.getReceiveMember().getMemberName(), rs.getReceiveMember().getMemberId(),
				rs.getCategory().getCategoryName());

		// 메일발송
		success = mailUtil.send(rs.getMessageReceive().getReferenceInfo(), rs.getReceiveMember().getMemberName(), rs.getSendMember().getMemberName(), rs
				.getMessageSend().getMessageTitle(), emailMessage, "html", file);

		return success;
	}
	
	/**
	 * 이메일 템플릿(파라미터 치환)
	 * 
	 * @param message
	 * @param memberInfo
	 * @return
	 */
	public String messageReplace(String message, String receiveMemberName, String receiveMemberId, String categoryName) throws Exception {

		String value = message;

		List<String> patten = new ArrayList<String>();
		patten.add("$이름");
		patten.add("$학과");
		patten.add("$아이디");

		if (patten != null && !patten.isEmpty()) {
			for (int i = 0; i < patten.size(); i++) {
				if ("$이름".equals(patten.get(i))) {
					value = value.replace(patten.get(i), receiveMemberName);
				} else if ("$학과".equals(patten.get(i))) {
					// 학과는 필수정보가 아니므로 데이터가 없으면 변경하지않음.
					if (!"".equals(categoryName)) {
						value = value.replace(patten.get(i), categoryName);
					}
				} else if ("$아이디".equals(patten.get(i))) {
					value = value.replace(patten.get(i), receiveMemberId);
				}
			}
		}

		return value;
	}

}
