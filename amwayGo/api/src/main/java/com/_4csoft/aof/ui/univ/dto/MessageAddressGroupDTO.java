package com._4csoft.aof.ui.univ.dto;

import com._4csoft.aof.ui.infra.vo.resultset.UIMessageAddressRS;

public class MessageAddressGroupDTO {
	
	private Long   memberSeq;
	private String name;
	private String groupName;
	private Long   groupSeq;
	private String major;
	private String phone;
	private String phoneReceiveYn;
	private String email;
	private String emailReceiveYn;
		
	public MessageAddressGroupDTO(UIMessageAddressRS rs) {
		this.memberSeq = rs.getMessageAddress().getMemberSeq();
		this.name = rs.getMember().getMemberName();        
		this.groupName = rs.getMessageAddressGroup().getGroupName();
		this.groupSeq = rs.getMessageAddress().getAddressGroupSeq();
		this.major = rs.getMember().getOrganizationString();
		this.phone = rs.getMember().getPhoneMobile();
		this.phoneReceiveYn = rs.getMember().getSmsYn();
		this.email = rs.getMember().getEmail();
		this.emailReceiveYn = rs.getMember().getEmailYn();
	}

	public Long getMemberSeq() {
		return memberSeq;
	}

	public String getName() {
		return name;
	}

	public String getGroupName() {
		return groupName;
	}

	public Long getGroupSeq() {
		return groupSeq;
	}

	public String getMajor() {
		return major;
	}

	public String getPhone() {
		return phone;
	}

	public String getPhoneReceiveYn() {
		return phoneReceiveYn;
	}

	public String getEmail() {
		return email;
	}

	public String getEmailReceiveYn() {
		return emailReceiveYn;
	}

}
