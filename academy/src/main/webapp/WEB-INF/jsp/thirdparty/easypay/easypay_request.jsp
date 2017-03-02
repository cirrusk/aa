<%@ page contentType="text/html; charset=utf-8" %>
<%@ page import="java.security.Security" %>

<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<%@ include file="./inc/easypay_config.jsp" %>
<%--
    /*****************************************************************************
     * Easypay 기본 설정정보를 include한다
     ****************************************************************************/
--%>
<%@ page import="com.kicc.*" %>
<%@ page import="java.util.Enumeration"%>

<%!
    /**
     * 파라미터 체크 메소드
     */
    public String getNullToSpace(String param) {
        return (param == null) ? "" : param.trim();
    }
%>
<%

/*
System.out.println("easypay_request.jsp");
System.out.println("==============================================================================================================");

Enumeration e = request.getParameterNames();
String name = null;
while (e.hasMoreElements()){
	name = e.nextElement().toString();
	System.out.println(">> " + name + " : " + request.getParameter(name));
}

System.out.println("==============================================================================================================");
*/

    /* -------------------------------------------------------------------------- */
    /* ::: 처리구분 설정                                                          */
    /* -------------------------------------------------------------------------- */
    final String TRAN_CD_NOR_PAYMENT    = "00101000";   // 승인(일반, 에스크로)
    final String TRAN_CD_NOR_MGR        = "00201000";   // 변경(일반, 에스크로)
    final String TRAN_CD_NOR_MALL       = "00201030";   // 셀러
    
    String mall_id          = getNullToSpace(request.getParameter("EP_mall_id"));         // [필수]몰아이디
    
    /* -------------------------------------------------------------------------- */
    /* ::: 플러그인 응답정보 설정                                                 */
    /* -------------------------------------------------------------------------- */
    String tr_cd            = getNullToSpace(request.getParameter("EP_tr_cd"));           // [필수]요청구분
    String trace_no         = getNullToSpace(request.getParameter("EP_trace_no"));        // [필수]추적고유번호
    String sessionkey       = getNullToSpace(request.getParameter("EP_sessionkey"));      // [필수]암호화키
    String encrypt_data     = getNullToSpace(request.getParameter("EP_encrypt_data"));    // [필수]암호화 데이타
    
    String pay_type         = getNullToSpace(request.getParameter("EP_ret_pay_type"));    // [선택]결제수단
    String complex_yn       = getNullToSpace(request.getParameter("EP_ret_complex_yn"));  // [선택]복합결제유무    
    String card_code        = getNullToSpace(request.getParameter("EP_card_code"));       // [선택]신용카드 카드코드
    
    String client_ip        = request.getRemoteAddr();                                    // [필수]결제고객 IP
    
    /* -------------------------------------------------------------------------- */
    /* ::: 결제 주문 정보 설정                                                    */
    /* -------------------------------------------------------------------------- */    
    String user_type        = getNullToSpace(request.getParameter("EP_user_type"));       // [선택]사용자구분구분[1:일반,2:회원]
    String order_no         = getNullToSpace(request.getParameter("EP_order_no"));        // [필수]주문번호
    String memb_user_no     = getNullToSpace(request.getParameter("EP_memb_user_no"));    // [선택]가맹점 고객일련번호
    String user_id          = getNullToSpace(request.getParameter("EP_user_id"));         // [선택]고객 ID
    String user_nm          = getNullToSpace(request.getParameter("EP_user_name"));       // [필수]고객명
    String user_mail        = getNullToSpace(request.getParameter("EP_user_mail"));       // [필수]고객 E-mail
    String user_phone1      = getNullToSpace(request.getParameter("EP_user_phone1"));     // [필수]가맹점 고객 연락처1
    String user_phone2      = getNullToSpace(request.getParameter("EP_user_phone2"));     // [선택]가맹점 고객 연락처2
    String user_addr        = getNullToSpace(request.getParameter("EP_user_addr"));       // [선택]가맹점 고객 주소
    String product_type     = getNullToSpace(request.getParameter("EP_product_type"));    // [필수]상품정보구분[0:실물,1:컨텐츠]
    String product_nm       = getNullToSpace(request.getParameter("EP_product_nm"));      // [필수]상품명
    String product_amt      = getNullToSpace(request.getParameter("EP_product_amt"));     // [필수]상품금액
    
    /* -------------------------------------------------------------------------- */
    /* ::: 변경관리 정보 설정                                                     */
    /* -------------------------------------------------------------------------- */
    String mgr_txtype       = getNullToSpace(request.getParameter("mgr_txtype"));         // [필수]거래구분
    String mgr_subtype      = getNullToSpace(request.getParameter("mgr_subtype"));        // [선택]변경세부구분
    String org_cno          = getNullToSpace(request.getParameter("org_cno"));            // [필수]원거래고유번호
    String mgr_amt          = getNullToSpace(request.getParameter("mgr_amt"));            // [선택]부분취소/환불요청 금액
    String mgr_rem_amt      = getNullToSpace(request.getParameter("mgr_rem_amt"));        // [선택]부분취소 잔액
    String mgr_bank_cd      = getNullToSpace(request.getParameter("mgr_bank_cd"));        // [선택]환불계좌 은행코드
    String mgr_account      = getNullToSpace(request.getParameter("mgr_account"));        // [선택]환불계좌 번호
    String mgr_depositor    = getNullToSpace(request.getParameter("mgr_depositor"));      // [선택]환불계좌 예금주명
    String mgr_socno        = getNullToSpace(request.getParameter("mgr_socno"));          // [선택]환불계좌 주민번호
    String mgr_telno        = getNullToSpace(request.getParameter("mgr_telno"));          // [선택]환불고객 연락처
    String deli_cd          = getNullToSpace(request.getParameter("deli_cd"));            // [선택]배송구분[자가:DE01,택배:DE02]
    String deli_corp_cd     = getNullToSpace(request.getParameter("deli_corp_cd"));       // [선택]택배사코드
    String deli_invoice     = getNullToSpace(request.getParameter("deli_invoice"));       // [선택]운송장 번호
    String deli_rcv_nm      = getNullToSpace(request.getParameter("deli_rcv_nm"));        // [선택]수령인 이름
    String deli_rcv_tel     = getNullToSpace(request.getParameter("deli_rcv_tel"));       // [선택]수령인 연락처
    String req_ip           = getNullToSpace(request.getParameter("req_ip"));             // [필수]요청자 IP
    String req_id           = getNullToSpace(request.getParameter("req_id"));             // [선택]요청자 ID
    String mgr_msg          = getNullToSpace(request.getParameter("mgr_msg"));            // [선택]변경 사유
    String mgr_paytype      = getNullToSpace(request.getParameter("mgr_paytype"));        // [선택]결제수단
    String mgr_tax_flg      = getNullToSpace(request.getParameter("mgr_tax_flg"));        // [필수]과세구분 플래그
    String mgr_tax_amt      = getNullToSpace(request.getParameter("mgr_tax_amt"));        // [필수]과세부분 취소 금액
    String mgr_free_amt     = getNullToSpace(request.getParameter("mgr_free_amt"));       // [필수]비과세 부분취소 금액
    String mgr_vat_amt      = getNullToSpace(request.getParameter("mgr_vat_amt"));        // [필수]부가세 부분취소 금액
    
    /* -------------------------------------------------------------------------- */
    /* ::: 셀러관리 정보 설정                                                     */
    /* -------------------------------------------------------------------------- */
    String mall_txtype      = getNullToSpace(request.getParameter("mall_txtype"));        // [필수]등록구분
    String seller_id        = getNullToSpace(request.getParameter("seller_id"));          // [필수]셀러ID(Sub)
    String bank_cd          = getNullToSpace(request.getParameter("bank_cd"));            // [선택]은행코드
    String accnt_no         = getNullToSpace(request.getParameter("accnt_no"));           // [선택]계좌번호
    String depositor        = getNullToSpace(request.getParameter("depositor"));          // [선택]예금주명
    String buss_no          = getNullToSpace(request.getParameter("buss_no"));            // [선택]사업자번호
    String corp_nm          = getNullToSpace(request.getParameter("corp_nm"));            // [선택]상호명
    String daepyo_nm        = getNullToSpace(request.getParameter("daepyo_nm"));          // [선택]대표자명
    String charge_nm        = getNullToSpace(request.getParameter("charge_nm"));          // [선택]당당자명
    String corp_zip_cd      = getNullToSpace(request.getParameter("corp_zip_cd"));        // [선택]사업자 우편번호
    String corp_addr        = getNullToSpace(request.getParameter("corp_addr"));          // [선택]사업자 주소
    String corp_tel_no      = getNullToSpace(request.getParameter("corp_tel_no"));        // [선택]사업자 전화번호
    
    /* -------------------------------------------------------------------------- */
    /* ::: 전문                                                                   */
    /* -------------------------------------------------------------------------- */
    String mgr_data    = "";     // 변경정보
    String mall_data   = "";     // 요청전문
    
    /* -------------------------------------------------------------------------- */
    /* ::: 결제 결과                                                              */
    /* -------------------------------------------------------------------------- */
    String bDBProc          = "";
    String res_cd           = "";
    String res_msg          = "";
    String r_order_no       = ""; 
    String r_complex_yn     = "";
    String r_msg_type       = "";     //거래구분 
    String r_noti_type      = "";     //노티구분
    String r_cno            = "";     //PG거래번호 
    String r_amount         = "";     //총 결제금액 
    String r_auth_no        = "";     //승인번호 
    String r_tran_date      = "";     //거래일시 
    String r_pnt_auth_no    = "";     //포인트 승인 번호 
    String r_pnt_tran_date  = "";     //포인트 승인 일시 
    String r_cpon_auth_no   = "";     //쿠폰 승인 번호 
    String r_cpon_tran_date = "";     //쿠폰 승인 일시 
    String r_card_no        = "";     //카드번호 
    String r_issuer_cd      = "";     //발급사코드 
    String r_issuer_nm      = "";     //발급사명 
    String r_acquirer_cd    = "";     //매입사코드 
    String r_acquirer_nm    = "";     //매입사명 
    String r_install_period = "";     //할부개월 
    String r_noint          = "";     //무이자여부 
    String r_bank_cd        = "";     //은행코드
    String r_bank_nm        = "";     //은행명 
    String r_account_no     = "";     //계좌번호 
    String r_deposit_nm     = "";     //입금자명 
    String r_expire_date    = "";     //계좌사용 만료일
    String r_cash_res_cd    = "";     //현금영수증 결과코드 
    String r_cash_res_msg   = "";     //현금영수증 결과메세지 
    String r_cash_auth_no   = "";     //현금영수증 승인번호 
    String r_cash_tran_date = "";     //현금영수증 승인일시 
    String r_auth_id        = "";     //PhoneID 
    String r_billid         = "";     //인증번호 
    String r_mobile_no      = "";     //휴대폰번호 
    String r_ars_no         = "";     //ARS 전화번호 
    String r_cp_cd          = "";     //포인트사 
    String r_used_pnt       = "";     //사용포인트 
    String r_remain_pnt     = "";     //잔여한도 
    String r_pay_pnt        = "";     //할인/발생포인트 
    String r_accrue_pnt     = "";     //누적포인트 
    String r_remain_cpon    = "";     //쿠폰잔액 
    String r_used_cpon      = "";     //쿠폰 사용금액 
    String r_mall_nm        = "";     //제휴사명칭  
    String r_escrow_yn      = "";     //에스크로 사용유무
    String r_canc_acq_date  = "";     //매입취소일시 
    String r_canc_date      = "";     //취소일시 
    String r_refund_date    = "";     //환불예정일시
    
    /* -------------------------------------------------------------------------- */
    /* ::: EasyPayClient 인스턴스 생성 [변경불가 !!].                             */
    /* -------------------------------------------------------------------------- */
    EasyPayClient easyPayClient = new EasyPayClient();
    
    String gatewayUrl = request.getAttribute("gatewayURL");
	String gatewayPort = request.getAttribute("gatewayPort");
	String certFile = request.getAttribute("certFileLocation");
	String logFileLocation = request.getAttribute("logFileLocation");
    
    //easyPayClient.easypay_setenv_init( g_gw_url, g_gw_port, g_cert_file, g_log_dir );
    easyPayClient.easypay_setenv_init( gatewayUrl, gatewayPort, certFile, logFileLocation );
    easyPayClient.easypay_reqdata_init();
    
    /* -------------------------------------------------------------------------- */
    /* ::: 승인요청(플러그인 암호화 전문 설정)                                    */
    /* -------------------------------------------------------------------------- */
    if( TRAN_CD_NOR_PAYMENT.equals(tr_cd) ){
      
        // 승인요청 전문 설정
        easyPayClient.easypay_set_trace_no(trace_no);
        easyPayClient.easypay_encdata_set(encrypt_data, sessionkey);
        
    /* -------------------------------------------------------------------------- */
    /* ::: 변경관리 요청                                                          */
    /* -------------------------------------------------------------------------- */
    }else if( TRAN_CD_NOR_MGR.equals( tr_cd ) ) {

        int easypay_mgr_data_item;
        easypay_mgr_data_item = easyPayClient.easypay_item( "mgr_data" );

        easyPayClient.easypay_deli_us( easypay_mgr_data_item, "mgr_txtype"    , mgr_txtype    );
        easyPayClient.easypay_deli_us( easypay_mgr_data_item, "mgr_subtype"   , mgr_subtype   );
        easyPayClient.easypay_deli_us( easypay_mgr_data_item, "org_cno"       , org_cno       );
        easyPayClient.easypay_deli_us( easypay_mgr_data_item, "order_no"      , order_no      );
        easyPayClient.easypay_deli_us( easypay_mgr_data_item, "pay_type"      , pay_type      );
        easyPayClient.easypay_deli_us( easypay_mgr_data_item, "mgr_amt"       , mgr_amt       );
        easyPayClient.easypay_deli_us( easypay_mgr_data_item, "mgr_rem_amt"   , mgr_rem_amt   );
        easyPayClient.easypay_deli_us( easypay_mgr_data_item, "mgr_tax_flg"   , mgr_tax_flg   );
        easyPayClient.easypay_deli_us( easypay_mgr_data_item, "mgr_tax_amt"   , mgr_tax_amt   );
        easyPayClient.easypay_deli_us( easypay_mgr_data_item, "mgr_free_amt"  , mgr_free_amt  );
        easyPayClient.easypay_deli_us( easypay_mgr_data_item, "mgr_vat_amt"   , mgr_vat_amt   );
        easyPayClient.easypay_deli_us( easypay_mgr_data_item, "mgr_bank_cd"   , mgr_bank_cd   );
        easyPayClient.easypay_deli_us( easypay_mgr_data_item, "mgr_account"   , mgr_account   );
        easyPayClient.easypay_deli_us( easypay_mgr_data_item, "mgr_depositor" , mgr_depositor );
        easyPayClient.easypay_deli_us( easypay_mgr_data_item, "mgr_socno"     , mgr_socno     );
        easyPayClient.easypay_deli_us( easypay_mgr_data_item, "mgr_telno"     , mgr_telno     );
        easyPayClient.easypay_deli_us( easypay_mgr_data_item, "deli_cd"       , deli_cd       );
        easyPayClient.easypay_deli_us( easypay_mgr_data_item, "deli_corp_cd"  , deli_corp_cd  );
        easyPayClient.easypay_deli_us( easypay_mgr_data_item, "deli_invoice"  , deli_invoice  );
        easyPayClient.easypay_deli_us( easypay_mgr_data_item, "deli_rcv_nm"   , deli_rcv_nm   );
        easyPayClient.easypay_deli_us( easypay_mgr_data_item, "deli_rcv_tel"  , deli_rcv_tel  );
        easyPayClient.easypay_deli_us( easypay_mgr_data_item, "req_ip"        , req_ip        );
        easyPayClient.easypay_deli_us( easypay_mgr_data_item, "req_id"        , req_id        );
        easyPayClient.easypay_deli_us( easypay_mgr_data_item, "mgr_msg"       , mgr_msg       );
        
    /* -------------------------------------------------------------------------- */
    /* ::: 셀러관리 요청                                                          */
    /* -------------------------------------------------------------------------- */
    
    }else if( TRAN_CD_NOR_MALL.equals( tr_cd ) ) {

        int easypay_mall_data_item;
        easypay_mall_data_item = easyPayClient.easypay_item( "mall_data" );

        easyPayClient.easypay_deli_us( easypay_mall_data_item, "mall_txtype"  , mall_txtype   );
        easyPayClient.easypay_deli_us( easypay_mall_data_item, "seller_id"    , seller_id     );
        easyPayClient.easypay_deli_us( easypay_mall_data_item, "bank_cd"      , bank_cd       );
        easyPayClient.easypay_deli_us( easypay_mall_data_item, "accnt_no"     , accnt_no      );
        easyPayClient.easypay_deli_us( easypay_mall_data_item, "depositor"    , depositor     );
        easyPayClient.easypay_deli_us( easypay_mall_data_item, "buss_no"      , buss_no       );
        easyPayClient.easypay_deli_us( easypay_mall_data_item, "corp_nm"      , corp_nm       );
        easyPayClient.easypay_deli_us( easypay_mall_data_item, "daepyo_nm"    , daepyo_nm     );
        easyPayClient.easypay_deli_us( easypay_mall_data_item, "charge_nm"    , charge_nm     );
        easyPayClient.easypay_deli_us( easypay_mall_data_item, "corp_zip_cd"  , corp_zip_cd   );
        easyPayClient.easypay_deli_us( easypay_mall_data_item, "corp_addr"    , corp_addr     );
        easyPayClient.easypay_deli_us( easypay_mall_data_item, "corp_tel_no"  , corp_tel_no   );
    }

    /* -------------------------------------------------------------------------- */
    /* ::: 실행                                                                   */
    /* -------------------------------------------------------------------------- */         
    if ( tr_cd.length() > 0 ) {
        easyPayClient.easypay_run( mall_id, tr_cd, order_no );
        
        res_cd = easyPayClient.res_cd;
        res_msg = easyPayClient.res_msg;
    } 
    else {
        res_cd  = "M114";
        res_msg = "연동 오류|tr_cd값이 설정되지 않았습니다.";
    }
    /* -------------------------------------------------------------------------- */
    /* ::: 결과 처리                                                              */
    /* -------------------------------------------------------------------------- */
    r_cno             = easyPayClient.easypay_get_res( "cno"             );    //PG거래번호 
    r_amount          = easyPayClient.easypay_get_res( "amount"          );    //총 결제금액
    r_order_no        = easyPayClient.easypay_get_res( "order_no"        );    //주문번호    
    r_auth_no         = easyPayClient.easypay_get_res( "auth_no"         );    //승인번호
    r_tran_date       = easyPayClient.easypay_get_res( "tran_date"       );    //승인일시
    r_pnt_auth_no     = easyPayClient.easypay_get_res( "pnt_auth_no"     );    //포인트승인번호
    r_pnt_tran_date   = easyPayClient.easypay_get_res( "pnt_tran_date"   );    //포인트승인일시
    r_cpon_auth_no    = easyPayClient.easypay_get_res( "cpon_auth_no"    );    //쿠폰승인번호
    r_cpon_tran_date  = easyPayClient.easypay_get_res( "cpon_tran_date"  );    //쿠폰승인일시
    r_card_no         = easyPayClient.easypay_get_res( "card_no"         );    //카드번호
    r_issuer_cd       = easyPayClient.easypay_get_res( "issuer_cd"       );    //발급사코드
    r_issuer_nm       = easyPayClient.easypay_get_res( "issuer_nm"       );    //발급사명
    r_acquirer_cd     = easyPayClient.easypay_get_res( "acquirer_cd"     );    //매입사코드
    r_acquirer_nm     = easyPayClient.easypay_get_res( "acquirer_nm"     );    //매입사명
    r_install_period  = easyPayClient.easypay_get_res( "install_period"  );    //할부개월
    r_noint           = easyPayClient.easypay_get_res( "noint"           );    //무이자여부
    r_bank_cd         = easyPayClient.easypay_get_res( "bank_cd"         );    //은행코드
    r_bank_nm         = easyPayClient.easypay_get_res( "bank_nm"         );    //은행명
    r_account_no      = easyPayClient.easypay_get_res( "account_no"      );    //계좌번호
    r_deposit_nm      = easyPayClient.easypay_get_res( "deposit_nm"      );    //입금자명
    r_expire_date     = easyPayClient.easypay_get_res( "expire_date"     );    //계좌사용만료일
    r_cash_res_cd     = easyPayClient.easypay_get_res( "cash_res_cd"     );    //현금영수증 결과코드
    r_cash_res_msg    = easyPayClient.easypay_get_res( "cash_res_msg"    );    //현금영수증 결과메세지
    r_cash_auth_no    = easyPayClient.easypay_get_res( "cash_auth_no"    );    //현금영수증 승인번호
    r_cash_tran_date  = easyPayClient.easypay_get_res( "cash_tran_date"  );    //현금영수증 승인일시
    r_auth_id         = easyPayClient.easypay_get_res( "auth_id"         );    //PhoneID
    r_billid          = easyPayClient.easypay_get_res( "billid"          );    //인증번호
    r_mobile_no       = easyPayClient.easypay_get_res( "mobile_no"       );    //휴대폰번호
    r_ars_no          = easyPayClient.easypay_get_res( "ars_no"          );    //전화번호
    r_cp_cd           = easyPayClient.easypay_get_res( "cp_cd"           );    //포인트사/쿠폰사
    r_used_pnt        = easyPayClient.easypay_get_res( "used_pnt"        );    //사용포인트
    r_remain_pnt      = easyPayClient.easypay_get_res( "remain_pnt"      );    //잔여한도
    r_pay_pnt         = easyPayClient.easypay_get_res( "pay_pnt"         );    //할인/발생포인트
    r_accrue_pnt      = easyPayClient.easypay_get_res( "accrue_pnt"      );    //누적포인트
    r_remain_cpon     = easyPayClient.easypay_get_res( "remain_cpon"     );    //쿠폰잔액
    r_used_cpon       = easyPayClient.easypay_get_res( "used_cpon"       );    //쿠폰 사용금액
    r_mall_nm         = easyPayClient.easypay_get_res( "mall_nm"         );    //제휴사명칭
    r_escrow_yn       = easyPayClient.easypay_get_res( "escrow_yn"       );    //에스크로 사용유무
    r_complex_yn      = easyPayClient.easypay_get_res( "complex_yn"      );    //복합결제 유무
    r_canc_acq_date   = easyPayClient.easypay_get_res( "canc_acq_date"   );    //매입취소일시
    r_canc_date       = easyPayClient.easypay_get_res( "canc_date"       );    //취소일시
    r_refund_date     = easyPayClient.easypay_get_res( "refund_date"     );    //환불예정일시
    
    /* -------------------------------------------------------------------------- */
    /* ::: 가맹점 DB 처리                                                         */
    /* -------------------------------------------------------------------------- */
    /* 응답코드(res_cd)가 "0000" 이면 정상승인 입니다.                            */
    /* r_amount가 주문DB의 금액과 다를 시 반드시 취소 요청을 하시기 바랍니다.     */
    /* DB 처리 실패 시 취소 처리를 해주시기 바랍니다.                             */
    /* -------------------------------------------------------------------------- */
    if ( res_cd.equals("0000") ) {
%>
    	<script>
    		window.parent.roomEduPaymentInfoEasyPay();
		</script>    			
<%    	
        bDBProc = "true";     // DB처리 성공 시 "true", 실패 시 "false"
        
        if ( bDBProc.equals("false") ) {
            // 승인요청이 실패 시 아래 실행
            if( TRAN_CD_NOR_PAYMENT.equals(tr_cd) ) {
                int easypay_mgr_data_item;
              
                easyPayClient.easypay_reqdata_init();
              
                tr_cd = TRAN_CD_NOR_MGR; 
                easypay_mgr_data_item = easyPayClient.easypay_item( "mgr_data" );
                if ( !r_escrow_yn.equals( "Y" ) ) {
                    easyPayClient.easypay_deli_us( easypay_mgr_data_item, "mgr_txtype", "40"   );
                }
                else {
                    easyPayClient.easypay_deli_us( easypay_mgr_data_item, "mgr_txtype",  "61"   );
                    easyPayClient.easypay_deli_us( easypay_mgr_data_item, "mgr_subtype", "ES02" );
                }
                easyPayClient.easypay_deli_us( easypay_mgr_data_item, "org_cno",  r_cno     );
                easyPayClient.easypay_deli_us( easypay_mgr_data_item, "order_no", order_no  );
                easyPayClient.easypay_deli_us( easypay_mgr_data_item, "req_ip",   client_ip );
                easyPayClient.easypay_deli_us( easypay_mgr_data_item, "req_id",   "MALL_R_TRANS" );
                easyPayClient.easypay_deli_us( easypay_mgr_data_item, "mgr_msg",  "DB 처리 실패로 망취소"  );
              
                easyPayClient.easypay_run( mall_id, tr_cd, order_no );
              
                res_cd = easyPayClient.res_cd;
                res_msg = easyPayClient.res_msg;
                r_cno = easyPayClient.easypay_get_res( "cno"             );    // PG거래번호 
                r_canc_date = easyPayClient.easypay_get_res( "canc_date"       );    //취소일시
            }
        }
    }
%>


<html>
<meta name="robots" content="noindex, nofollow">
<script type="text/javascript">
    function f_submit(){
        document.frm.submit();
    }
</script>

<body onload="f_submit();">
<form name="frm" method="post" action="${currentDomain}/thirdparty/easypay/result.jsp" >
    <input type="hidden" name="res_cd"          value="<%=res_cd%>">            <!-- 결과코드 //-->
    <input type="hidden" name="res_msg"         value="<%=res_msg%>">           <!-- 결과메시지 //-->
    <input type="hidden" name="order_no"        value="<%=order_no%>">          <!-- 주문번호 //-->
    <input type="hidden" name="user_nm"         value="<%=user_nm%>">           <!-- 구매자명  //-->
    <input type="hidden" name="cno"             value="<%=r_cno%>">             <!-- PG거래번호 //-->
    <input type="hidden" name="amount"          value="<%=r_amount%>">          <!-- 총 결제금액 //-->
    <input type="hidden" name="auth_no"         value="<%=r_auth_no%>">         <!-- 승인번호 //-->
    <input type="hidden" name="tran_date"       value="<%=r_tran_date%>">       <!-- 거래일시 //-->
    <input type="hidden" name="pnt_auth_no"     value="<%=r_pnt_auth_no%>">     <!-- 포인트 승인 번호 //-->
    <input type="hidden" name="pnt_tran_date"   value="<%=r_pnt_tran_date%>">   <!-- 포인트 승인 일시 //-->
    <input type="hidden" name="cpon_auth_no"    value="<%=r_cpon_auth_no%>">    <!-- 쿠폰 승인 번호 //-->
    <input type="hidden" name="cpon_tran_date"  value="<%=r_cpon_tran_date%>">  <!-- 쿠폰 승인 일시 //-->
    <input type="hidden" name="card_no"         value="<%=r_card_no%>">         <!-- 카드번호 //-->
    <input type="hidden" name="issuer_cd"       value="<%=r_issuer_cd%>">       <!-- 발급사코드 //-->
    <input type="hidden" name="issuer_nm"       value="<%=r_issuer_nm%>">       <!-- 발급사명 //-->
    <input type="hidden" name="acquirer_cd"     value="<%=r_acquirer_cd%>">     <!-- 매입사코드 //-->
    <input type="hidden" name="acquirer_nm"     value="<%=r_acquirer_nm%>">     <!-- 매입사명 //-->
    <input type="hidden" name="install_period"  value="<%=r_install_period%>">  <!-- 할부개월 //-->
    <input type="hidden" name="noint"           value="<%=r_noint%>">           <!-- 무이자여부 //-->
    <input type="hidden" name="bank_cd"         value="<%=r_bank_cd%>">         <!-- 은행코드 //-->
    <input type="hidden" name="bank_nm"         value="<%=r_bank_nm%>">         <!-- 은행명 //-->
    <input type="hidden" name="account_no"      value="<%=r_account_no%>">      <!-- 계좌번호 //-->
    <input type="hidden" name="deposit_nm"      value="<%=r_deposit_nm%>">      <!-- 입금자명 //-->
    <input type="hidden" name="expire_date"     value="<%=r_expire_date%>">     <!-- 계좌사용만료일시 //-->
    <input type="hidden" name="cash_res_cd"     value="<%=r_cash_res_cd%>">     <!-- 현금영수증 결과코드 //-->
    <input type="hidden" name="cash_res_msg"    value="<%=r_cash_res_msg%>">    <!-- 현금영수증 결과메세지 //-->
    <input type="hidden" name="cash_auth_no"    value="<%=r_cash_auth_no%>">    <!-- 현금영수증 승인번호 //-->
    <input type="hidden" name="cash_tran_date"  value="<%=r_cash_tran_date%>">  <!-- 현금영수증 승인일시 //-->
    <input type="hidden" name="auth_id"         value="<%=r_auth_id%>">         <!-- PhoneID //-->
    <input type="hidden" name="billid"          value="<%=r_billid%>">          <!-- 인증번호 //-->
    <input type="hidden" name="mobile_no"       value="<%=r_mobile_no%>">       <!-- 휴대폰번호 //-->
    <input type="hidden" name="ars_no"          value="<%=r_ars_no%>">          <!-- ARS 전화번호 //-->
    <input type="hidden" name="cp_cd"           value="<%=r_cp_cd%>">           <!-- 포인트사 //-->
    <input type="hidden" name="used_pnt"        value="<%=r_used_pnt%>">        <!-- 사용포인트 //-->
    <input type="hidden" name="remain_pnt"      value="<%=r_remain_pnt%>">      <!-- 잔여한도 //-->
    <input type="hidden" name="pay_pnt"         value="<%=r_pay_pnt%>">         <!-- 할인/발생포인트 //-->
    <input type="hidden" name="accrue_pnt"      value="<%=r_accrue_pnt%>">      <!-- 누적포인트 //-->
    <input type="hidden" name="remain_cpon"     value="<%=r_remain_cpon%>">     <!-- 쿠폰잔액 //-->
    <input type="hidden" name="used_cpon"       value="<%=r_used_cpon%>">       <!-- 쿠폰 사용금액 //-->
    <input type="hidden" name="mall_nm"         value="<%=r_mall_nm%>">         <!-- 제휴사명칭 //-->
    <input type="hidden" name="escrow_yn"       value="<%=r_escrow_yn%>">       <!-- 에스크로 사용유무 //-->
    <input type="hidden" name="complex_yn"      value="<%=r_complex_yn%>">      <!-- 복합결제 유무 //-->
    <input type="hidden" name="canc_acq_date"   value="<%=r_canc_acq_date%>">   <!-- 매입취소일시 //-->
    <input type="hidden" name="canc_date"       value="<%=r_canc_date%>">       <!-- 취소일시 //-->
    <input type="hidden" name="refund_date"     value="<%=r_refund_date%>">     <!-- 환불예정일시 //-->    
    <input type="hidden" name="pay_type"        value="<%=pay_type%>">          <!-- 결제수단 //-->
</form>
</body>
</html>
