/*
 * Copyright (c) 1999 4CSoft Inc. All right reserved.
 * This software is the proprietary information of 4CSoft Inc.
 *
 */
package com._4csoft.aof.ui.board.support;

import org.springframework.stereotype.Component;

import com._4csoft.aof.board.support.validator.BoardValidator;
import com._4csoft.aof.board.vo.BbsVO;
import com._4csoft.aof.board.vo.BoardVO;
import com._4csoft.aof.board.vo.CommentAgreeVO;
import com._4csoft.aof.board.vo.CommentVO;
import com._4csoft.aof.board.vo.PopupVO;
import com._4csoft.aof.infra.support.validator.Validator;
import com._4csoft.aof.infra.vo.base.ValidateType;
import com._4csoft.aof.ui.board.vo.UIBbsVO;
import com._4csoft.aof.ui.board.vo.UIBoardVO;
import com._4csoft.aof.ui.board.vo.UICommentAgreeVO;
import com._4csoft.aof.ui.board.vo.UICommentVO;
import com._4csoft.aof.ui.board.vo.UIPopupVO;

/**
 * @Project : aof5-demo-core
 * @Package : com._4csoft.aof.ui.board.support
 * @File : UIBoardValidator.java
 * @Title : Board Validator
 * @date : 2013. 5. 8.
 * @author : 김종규
 * @descrption : Board 관련 Validator
 */
@Component ("UIBoardValidator")
public class UIBoardValidator extends Validator implements BoardValidator {

	/**
	 * @param BbsVO
	 * @param validateType
	 * @throws Exception
	 */
	public void validate(BbsVO voBbs, ValidateType validateType) throws Exception {
		UIBbsVO vo = (UIBbsVO)voBbs;
		validateAudit(vo, validateType);

		if (ValidateType.delete == validateType) {
			validate("bbsSeq", vo.getBbsSeq().toString(), DataValidator.REQUIRED);
			return;
		}
		if (ValidateType.update == validateType) {
			validate("bbsSeq", vo.getBbsSeq().toString(), DataValidator.REQUIRED);
		}
		if (ValidateType.insert == validateType) {
			validate("boardSeq", vo.getBoardSeq().toString(), DataValidator.REQUIRED);
			validate("bbsTitle", vo.getBbsTitle(), DataValidator.REQUIRED);
			validate("description", vo.getDescription(), DataValidator.REQUIRED);
		}

		validate("bbsTitle", vo.getBbsTitle(), CompareValidator.MAX_LENGTH, 200);
		validate("bbsTypeCd", vo.getBbsTypeCd(), CompareValidator.MAX_LENGTH, 50);
		validate("alwaysTopYn", vo.getAlwaysTopYn(), CompareValidator.FIX_LENGTH, 1);
		validate("htmlYn", vo.getHtmlYn(), CompareValidator.FIX_LENGTH, 1);
		validate("secretYn", vo.getSecretYn(), CompareValidator.FIX_LENGTH, 1);
	}

	/**
	 * @param CommentVO
	 * @param validateType
	 * @throws Exception
	 */
	public void validate(CommentVO voComment, ValidateType validateType) throws Exception {
		UICommentVO vo = (UICommentVO)voComment;
		validateAudit(vo, validateType);

		if (ValidateType.delete == validateType) {
			validate("commentSeq", vo.getCommentSeq().toString(), DataValidator.REQUIRED);
			return;
		}
		if (ValidateType.update == validateType) {
			validate("commentSeq", vo.getCommentSeq().toString(), DataValidator.REQUIRED);
		}
		if (ValidateType.insert == validateType) {
			validate("bbsSeq", vo.getBbsSeq().toString(), DataValidator.REQUIRED);
			validate("description", vo.getDescription(), DataValidator.REQUIRED);
		}

		validate("secretYn", vo.getSecretYn(), CompareValidator.FIX_LENGTH, 1);
	}

	/**
	 * @param CommentAgreeVO
	 * @param validateType
	 * @throws Exception
	 */
	public void validate(CommentAgreeVO voCommentAgree, ValidateType validateType) throws Exception {
		UICommentAgreeVO vo = (UICommentAgreeVO)voCommentAgree;
		validateAudit(vo, validateType);

		if (ValidateType.delete == validateType) {
		}
		if (ValidateType.update == validateType) {
		}
		if (ValidateType.insert == validateType) {
			validate("commentSeq", vo.getCommentSeq().toString(), DataValidator.REQUIRED);
			validate("regMemberSeq", vo.getRegMemberSeq().toString(), DataValidator.REQUIRED);
		}
	}

	/**
	 * @param BoardVO
	 * @param validateType
	 * @throws Exception
	 */
	public void validate(BoardVO voBoard, ValidateType validateType) throws Exception {
		UIBoardVO vo = (UIBoardVO)voBoard;
		validateAudit(vo, validateType);

		if (ValidateType.delete == validateType) {
			validate("boardSeq", vo.getBoardSeq().toString(), DataValidator.REQUIRED);
			return;
		}
		if (ValidateType.update == validateType) {
			validate("boardSeq", vo.getBoardSeq().toString(), DataValidator.REQUIRED);
		}
		if (ValidateType.insert == validateType) {
			validate("boardTypeCd", vo.getBoardTypeCd(), DataValidator.REQUIRED);
			validate("referenceSeq", vo.getReferenceSeq().toString(), DataValidator.REQUIRED);
			validate("referenceType", vo.getReferenceType(), DataValidator.REQUIRED);
			validate("boardTitle", vo.getBoardTitle(), DataValidator.REQUIRED);
		}
		if (ValidateType.copy == validateType) {
			validate("sourceReferenceSeq", vo.getSourceReferenceSeq().toString(), DataValidator.REQUIRED);
			validate("targetReferenceSeq", vo.getTargetReferenceSeq().toString(), DataValidator.REQUIRED);
			validate("referenceType", vo.getReferenceType(), DataValidator.REQUIRED);
		}
		validate("boardTypeCd", vo.getBoardTypeCd(), CompareValidator.MAX_LENGTH, 50);
		validate("referenceType", vo.getReferenceType(), CompareValidator.MAX_LENGTH, 50);
		validate("boardTitle", vo.getBoardTitle(), CompareValidator.MAX_LENGTH, 30);
		validate("description", vo.getDescription(), CompareValidator.MAX_LENGTH, 1000);
		validate("useYn", vo.getUseYn(), CompareValidator.FIX_LENGTH, 1);
		validate("secretYn", vo.getSecretYn(), CompareValidator.FIX_LENGTH, 1);
		validate("editorYn", vo.getEditorYn(), CompareValidator.FIX_LENGTH, 1);
		validate("commentYn", vo.getCommentYn(), CompareValidator.FIX_LENGTH, 1);
		validate("replyTypeCd", vo.getReplyTypeCd(), CompareValidator.MAX_LENGTH, 50);
	}

	/**
	 * @param PopUpVO
	 * @param validateType
	 * @throws Exception
	 */
	public void validate(PopupVO voPopup, ValidateType validateType) throws Exception {
		UIPopupVO vo = (UIPopupVO)voPopup;
		validateAudit(vo, validateType);

		if (ValidateType.delete == validateType) {
			validate("popupSeq", vo.getPopupSeq().toString(), DataValidator.REQUIRED);
			return;
		}
		if (ValidateType.update == validateType) {
			validate("popupSeq", vo.getPopupSeq().toString(), DataValidator.REQUIRED);
		}
		if (ValidateType.insert == validateType) {
			validate("popupTypeCd", vo.getPopupTypeCd(), DataValidator.REQUIRED);
			validate("popupInputTypeCd", vo.getPopupInputTypeCd(), DataValidator.REQUIRED);
			validate("popupTitle", vo.getPopupTitle(), DataValidator.REQUIRED);
			validate("startDtime", vo.getStartDtime(), DataValidator.REQUIRED);
			validate("endDtime", vo.getEndDtime(), DataValidator.REQUIRED);
			validate("widthSize", vo.getWidthSize().toString(), DataValidator.REQUIRED);
			validate("heightSize", vo.getHeightSize().toString(), DataValidator.REQUIRED);
		}
		validate("popupTypeCd", vo.getPopupTypeCd(), CompareValidator.MAX_LENGTH, 50);
		validate("popupInputTypeCd", vo.getPopupInputTypeCd(), CompareValidator.MAX_LENGTH, 50);
		validate("popupTitle", vo.getPopupTitle(), CompareValidator.MAX_LENGTH, 200);
		validate("startDtime", vo.getStartDtime(), CompareValidator.MAX_LENGTH, 14);
		validate("endDtime", vo.getEndDtime(), CompareValidator.MAX_LENGTH, 14);
		validate("areaSetting", vo.getAreaSetting(), CompareValidator.MAX_LENGTH, 14);
		validate("useYn", vo.getUseYn(), CompareValidator.FIX_LENGTH, 1);
	}

}
