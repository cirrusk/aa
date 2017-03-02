package com._4csoft.aof.ui.infra.service.impl;

import java.util.ArrayList;
import java.util.List;

import org.springframework.stereotype.Service;

import com._4csoft.aof.infra.vo.AttachVO;
import com._4csoft.aof.infra.vo.MemberVO;
import com._4csoft.aof.infra.vo.MessageSendVO;
import com._4csoft.aof.ui.infra.service.UISmsSendService;

import egovframework.rte.fdl.cmmn.AbstractServiceImpl;

/**
 * 
 * @Project : aof5-univ-ui-core
 * @Package : com._4csoft.aof.ui.infra.service
 * @File    : UISmsSendServiceImpl.java
 * @Title   : SMS 발송서비스
 * @date    : 2014. 4. 3.
 * @author  : 김영학
 * @descrption :
 * {상세한 프로그램의 용도를 기록}
 */
@Service ("UISmsSendService")
public class UISmsSendServiceImpl extends AbstractServiceImpl implements UISmsSendService{
	
	/**
	 * SMS 발송서비스
	 * TODO : 외부프로젝트에서 별도의 로직에 의해 구현이 필요
	 * messageSendVO : 발송자 정보 및 메세지
	 * voAttach : 발송시 첨부한 파일
	 * receiveMemberList : 수신자 정보
	 */
	public int send(MessageSendVO messageSendVO, AttachVO voAttach, List<MemberVO> receiveMemberList) throws Exception {
		
		int success = 0;
		
		//원본 발신메세지
		String sendMessage = messageSendVO.getDescription();
		
		for(int i = 0; i < receiveMemberList.size(); i++ ){
			
			//발신 메세지 템플릿 적용
			String messageDescription = messageReplace(sendMessage, receiveMemberList.get(i));
			
			//sms발송 타입에 따라 분류
			if("SMS_TYPE::SHORT".equals(messageSendVO.getSmsTypeCd())){


				//sms발송 타입이 단문이지만 80byte로 분할 발송 (한글기준 40자로 분리) 
				if(messageDescription.length() > 40){
					//문자길이체크로 몇번을 분할해야 하는지 결정 (40자 기준)
					int maxLength = 40;
					int forNum = messageDescription.length() / maxLength;
					int subNum = messageDescription.length() % maxLength;
					if(subNum != 0){
						forNum = forNum + 1;
					}
					
					//결정된 분할수만큼 문자를 40글자씩 나누어 전송
					for(int j = 0; j < forNum; j++){
						int startNum = j * 40;
						int lastNum = 40 * (j+1);
						
						//마지막 반복구문일시
						if(j == forNum - 1){
							lastNum = messageDescription.length();
						}
						//메세지 분할
						String smsMessage = messageDescription.substring(startNum, lastNum);
						
						//분할된 메세지 셋팅
						messageSendVO.setDescription(smsMessage);
						/**
						 * TODO : 이후 해당 프로젝트의 서비스에따라 추가구현필요
						 * messageSendVO.getMessageTitle()  : 발송제목
						 * messageSendVO.getSendMemberSeq() : 발송자 SEQ
						 * messageSendVO.getDescription()   : 발송메세지
						 * messageSendVO.getSendMemberName(): 발송자이름
						 * 
						 * receiveMemberList.get(i).getMemberSeq()  : 수신자 SEQ
						 * receiveMemberList.get(i).getMemberId()   : 수신자 ID
						 * receiveMemberList.get(i).getMemberName() : 수신자 이름
						 * receiveMemberList.get(i).getPhoneMobile() : 수신자 핸드폰번호
						 */
						
						/**
						 * TODO : 이후 발송서비스에 따라 아래의 성공여부를 체크하는 부분의 수정필요
						 */
						success++;
					}								
				}else{
					//메세지 셋팅
					messageSendVO.setDescription(messageDescription);
					
					/**
					 * TODO : 이후 해당 프로젝트의 서비스에따라 추가구현필요
					 * messageSendVO.getMessageTitle()  : 발송제목
					 * messageSendVO.getSendMemberSeq() : 발송자 SEQ
					 * messageSendVO.getDescription()   : 발송메세지
					 * messageSendVO.getSendMemberName(): 발송자이름
					 * 
					 * receiveMemberList.get(i).getMemberSeq()  : 수신자 SEQ
					 * receiveMemberList.get(i).getMemberId()   : 수신자 ID
					 * receiveMemberList.get(i).getMemberName() : 수신자 이름
					 * receiveMemberList.get(i).getPhoneMobile() : 수신자 핸드폰번호
					 */	
					
					/**
					 * TODO : 이후 발송서비스에 따라 아래의 성공여부를 체크하는 부분의 수정필요
					 */
					success++;
				}
			}else{
				//메세지 셋팅
				messageSendVO.setDescription(messageDescription);
				
				/**
				 * TODO : 이후 해당 프로젝트의 서비스에따라 추가구현필요
				 * messageSendVO.getMessageTitle()  : 발송제목
				 * messageSendVO.getSendMemberSeq() : 발송자 SEQ
				 * messageSendVO.getDescription()   : 발송메세지
				 * messageSendVO.getSendMemberName(): 발송자이름
				 * 
				 * receiveMemberList.get(i).getMemberSeq()  : 수신자 SEQ
				 * receiveMemberList.get(i).getMemberId()   : 수신자 ID
				 * receiveMemberList.get(i).getMemberName() : 수신자 이름
				 * receiveMemberList.get(i).getPhoneMobile() : 수신자 핸드폰번호
				 */
				
				/**
				 * TODO : 이후 발송서비스에 따라 아래의 성공여부를 체크하는 부분의 수정필요
				 */
				success++;
			}
		}
		
		return success;
	}

	/**
	 * 템플릿메세지 치환(파라미터 치환)
	 * 
	 * @param message
	 * @param memberInfo
	 * @return
	 */
	public String messageReplace(String message, MemberVO memberInfo) {

		try {
			String value = message;

			List<String> patten = new ArrayList<String>();
			patten.add("$이름");
			patten.add("$학과");
			patten.add("$아이디");

			if (patten != null && !patten.isEmpty()) {
				for (int i = 0; i < patten.size(); i++) {
					if ("$이름".equals(patten.get(i))) {
						value = value.replace(patten.get(i), memberInfo.getMemberName());
					} else if ("$학과".equals(patten.get(i))) {
						value = value.replace(patten.get(i), memberInfo.getCategoryOrganizationString());
					} else if ("$아이디".equals(patten.get(i))) {
						value = value.replace(patten.get(i), memberInfo.getMemberId());
					}
				}
			}

			return value;

		} catch (Exception e) {
			return message;
		}
	}
}
