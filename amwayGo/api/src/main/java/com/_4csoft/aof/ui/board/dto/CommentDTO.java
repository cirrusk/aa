package com._4csoft.aof.ui.board.dto;

import java.io.Serializable;
import java.util.List;

import com._4csoft.aof.infra.vo.AttachVO;
import com._4csoft.aof.ui.univ.dto.AttachDTO;

public class CommentDTO implements Serializable {
	private static final long serialVersionUID = 1L;
	/** cs_comment_seq : 댓글 일련번호 */
	private Long commentSeq;

	/** cs_bbs_seq : 게시글 일련번호 */
	private Long bbsSeq;

	/** cs_description : 내용 */
	private String description;

	/** cs_agree_count : 찬성수 */
	private Long agreeCount;

	/** cs_disagree_count : 반대수 */
	private Long disagreeCount;

	/** cs_secret_yn : 비밀글 여부 */
	private String secretYn;

	/** 등록자 사진 */
	private String regMemberPhoto;

	/** 등록자 닉네임 */
	private String regMemberNickname;

	private String regMemberName;

	/** cs_reg_member_seq */
	private Long regMemberSeq;

	/** cs_reg_dtime */
	private String regDtime;

	/** cs_reg_ip */
	private String regIp;

	/** cs_upd_member_seq */
	private Long updMemberSeq;

	/** cs_upd_dtime */
	private String updDtime;

	/** cs_upd_ip */
	private String updIp;

	/** 교강사 정보 */
	private String profYn;
	private String activeLecturerTypeCd;
	private String activeLecturerType;
	
	/** 교강사 정보 */
	private List<AttachDTO> commPhoto;

	/** 게시글 작성자 일련번호 */

	public Long getCommentSeq() {
		return commentSeq;
	}

	public void setCommentSeq(Long commentSeq) {
		this.commentSeq = commentSeq;
	}

	public Long getBbsSeq() {
		return bbsSeq;
	}

	public void setBbsSeq(Long bbsSeq) {
		this.bbsSeq = bbsSeq;
	}

	public String getDescription() {
		return description;
	}

	public void setDescription(String description) {
		this.description = description;
	}

	public Long getDisagreeCount() {
		return disagreeCount;
	}

	public void setDisagreeCount(Long disagreeCount) {
		this.disagreeCount = disagreeCount;
	}

	public String getSecretYn() {
		return secretYn;
	}

	public void setSecretYn(String secretYn) {
		this.secretYn = secretYn;
	}

	public Long getAgreeCount() {
		return agreeCount;
	}

	public void setAgreeCount(Long agreeCount) {
		this.agreeCount = agreeCount;
	}

	public String getRegMemberPhoto() {
		return regMemberPhoto;
	}

	public void setRegMemberPhoto(String regMemberPhoto) {
		this.regMemberPhoto = regMemberPhoto;
	}

	public String getRegMemberNickname() {
		return regMemberNickname;
	}

	public void setRegMemberNickname(String regMemberNickname) {
		this.regMemberNickname = regMemberNickname;
	}

	public String getRegMemberName() {
		return regMemberName;
	}

	public void setRegMemberName(String regMemberName) {
		this.regMemberName = regMemberName;
	}

	public Long getRegMemberSeq() {
		return regMemberSeq;
	}

	public void setRegMemberSeq(Long regMemberSeq) {
		this.regMemberSeq = regMemberSeq;
	}

	public String getRegDtime() {
		return regDtime;
	}

	public void setRegDtime(String regDtime) {
		this.regDtime = regDtime;
	}

	public String getRegIp() {
		return regIp;
	}

	public void setRegIp(String regIp) {
		this.regIp = regIp;
	}

	public Long getUpdMemberSeq() {
		return updMemberSeq;
	}

	public void setUpdMemberSeq(Long updMemberSeq) {
		this.updMemberSeq = updMemberSeq;
	}

	public String getUpdDtime() {
		return updDtime;
	}

	public void setUpdDtime(String updDtime) {
		this.updDtime = updDtime;
	}

	public String getUpdIp() {
		return updIp;
	}

	public void setUpdIp(String updIp) {
		this.updIp = updIp;
	}

	public String getProfYn() {
		return profYn;
	}

	public void setProfYn(String profYn) {
		this.profYn = profYn;
	}

	public String getActiveLecturerTypeCd() {
		return activeLecturerTypeCd;
	}

	public void setActiveLecturerTypeCd(String activeLecturerTypeCd) {
		this.activeLecturerTypeCd = activeLecturerTypeCd;
	}

	public String getActiveLecturerType() {
		return activeLecturerType;
	}

	public void setActiveLecturerType(String activeLecturerType) {
		this.activeLecturerType = activeLecturerType;
	}

	public List<AttachDTO> getCommPhoto() {
		return commPhoto;
	}

	public void setCommPhoto(List<AttachDTO> commPhoto) {
		this.commPhoto = commPhoto;
	}
}
