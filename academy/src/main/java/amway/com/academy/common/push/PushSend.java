package amway.com.academy.common.push;

import java.io.BufferedWriter;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStreamWriter;
import java.net.HttpURLConnection;
import java.net.URL;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;
import java.util.Map;
import java.util.Properties;
import java.util.UUID;
import java.util.Vector;

import org.apache.commons.codec.binary.Base64;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import com.jcraft.jsch.Channel;
import com.jcraft.jsch.ChannelSftp;
import com.jcraft.jsch.JSch;
import com.jcraft.jsch.JSchException;
import com.jcraft.jsch.Session;
import com.jcraft.jsch.SftpException;

import framework.com.cmm.lib.DataBox;
import framework.com.cmm.lib.RequestBox;
import framework.com.cmm.util.KisaSeedCBC;
import framework.com.cmm.util.StringUtil;


@Service
public class PushSend {
	
	private static final Logger LOGGER = LoggerFactory.getLogger(PushSend.class);
	
    private static final String RESULT_SUCCESS_200 = "200";
    private static final String RESULT_SUCCESS_201 = "201";
	
    /**
     * 암호화 대칭 키
     */
    private static final byte PB_USER_KEY[] = "NAVID_AMWAY_AUTH".getBytes();
    
    /**
     * CBC 대칭 키
     */
    private static final byte BSZ_IV[] = "NETIVE--NAVID1.0".getBytes();
	
    
    private static final String HEADER_KEY_APPID = "AppId";
    private static final String HEADER_KEY_URL = "url";
    private static final String HEADER_KEY_AUTHKEY = "AuthKey";
    private static final String HEADER_KEY_APIVER = "ApiVer";
	
	

	 // FTP를 이용한 대량 업로드 후 송신을 한다
    public DataBox sendPushByFile(RequestBox requestBox) throws Exception {
    	
    	String resultCode = ""; // 결과코드
    	
    	String pushYn = ""; // 푸시 실행 여부
    	String pushHttpUrl = ""; // 연결 URL
    	String pushHttpUserId = ""; // 연결권한 아이디
    	String pushSftpHost = ""; // FTP 서버
    	String pushSftpRemoteDir = ""; // FTP 서버 디렉토리
    	String pushSftpPort = ""; // FTP 서버 포트
    	String pushSftpUser = ""; // FTP 서버 아이디
    	String pushSftpPassword = ""; // FTP 서버 패스워드
    	
    	
    	
		String resourceName = "/config/props/framework.properties";
		ClassLoader loader = Thread.currentThread().getContextClassLoader();
		Properties props = new Properties();
		try {
			InputStream resourceStream = loader.getResourceAsStream(resourceName);
			props.load(resourceStream);
			pushYn = props.getProperty("interface.push.yn");
			pushHttpUrl = props.getProperty("interface.push.http.url.file");
			pushHttpUserId = props.getProperty("interface.push.http.user.id");
			
			pushSftpRemoteDir = props.getProperty("interface.push.sftp.remote.dir");
	    	pushSftpHost = props.getProperty("interface.push.sftp.host");
	    	pushSftpPort = props.getProperty("interface.push.sftp.port");
	    	pushSftpUser = props.getProperty("interface.push.sftp.user");
	    	pushSftpPassword = props.getProperty("interface.push.sftp.password");

	        String title = requestBox.getString("pushTitle");
	        String msg = requestBox.getString("pushMsg");
	        String url = requestBox.getString("pushUrl");
	        String category = requestBox.getString("pushCategory");
	        
	        @SuppressWarnings("unchecked")
			Vector<String> userIdVector = (Vector<String>) requestBox.getObject("pushUserIdVector");// 벡터형식의 userid
	        
	        int listSize = 0;
	        if(userIdVector !=null){
	        	listSize = userIdVector.size();
	        }
	        String blankStr = "";
	        String yStr = "Y";
	        if(listSize == 0 || blankStr.equals(title) || blankStr.equals(msg) ){  // 필수 파라미터 없음
	        	resultCode = "noparam"; 
	        }else if( !yStr.equals(pushYn) ) {  // 실행여부가 Y인 경우만 실행
	    		resultCode = "local";
	    	}else{
	    		
				URL urlObj = new URL(pushHttpUrl);
		    	final SimpleDateFormat simpleDateFormat = new SimpleDateFormat("yyyyMMddHHmmss");
		    	LOGGER.debug("SimpleDateFormat = " + simpleDateFormat.format(new Date()));
		    	final String authKey = encode(simpleDateFormat.format(new Date())+pushHttpUserId);
				
				//파일만들기
				String receiver = "";
				
				// 폴더 없는 경우 만들기
				String saveDir = StringUtil.uploadPath()+ File.separator + "pushFile";
				File saveFolder = new File(saveDir);
				if(!saveFolder.exists() || saveFolder.isFile()){
					saveFolder.mkdirs();
				}
	
		        String fileName = simpleDateFormat.format(new Date()) + UUID.randomUUID().toString().replaceAll("-", "")+".csv";
	            // 파일 객체 생성
	 
		        File file = new File(saveDir + File.separator  + fileName) ;
	            BufferedWriter out = new BufferedWriter(
	                    new OutputStreamWriter(
	                                           new FileOutputStream(saveDir + File.separator  + fileName),
	                                           "UTF8"
	                                           )
	                    );
	            
	            // 파일안에 대상자 문자열 쓰기
	            out.write("userId");
	            out.newLine();
	            for(int i=0; i<listSize; i++){
	            	out.write(userIdVector.get(i));
	                out.newLine();	
	            }
	
	            // 객체 닫기
	            out.close();
	           
	
	            // ftp 올리기
	
	            Session session = null;
	            Channel channel = null;
	            ChannelSftp channelSftp = null;
	     
	            FileInputStream in = null;
	            
	            JSch jsch = new JSch();
	     
	            try {
	                session = jsch.getSession(pushSftpUser, pushSftpHost, Integer.parseInt(pushSftpPort));
	                session.setPassword(pushSftpPassword);
	             
	                java.util.Properties config = new java.util.Properties();
	                config.put("StrictHostKeyChecking", "no"); // 인증서 검사를 하지 않음
	                session.setConfig(config);
	                
	                session.connect();
	     
	                channel = session.openChannel("sftp");
	                channel.connect();
	     
	                channelSftp = (ChannelSftp)channel;
	                LOGGER.debug("=> Connected to " + pushSftpHost);
	     
	                in = new FileInputStream(file);
	     
	                channelSftp.cd(pushSftpRemoteDir);
	                channelSftp.put(in, file.getName());
	                
	                LOGGER.debug("=> Uploaded : " + file.getPath() + " at " + pushSftpHost);
	            } catch(JSchException e) {
	                e.printStackTrace();
	            } finally {
	                try {
	                    in.close();
	                    channelSftp.exit();
	                    channel.disconnect();
	                    session.disconnect();
	                } catch(IOException e) {
	                    e.printStackTrace();
	                }
	            }
	
	            receiver = pushSftpRemoteDir + File.separator + fileName;
	            
		        HttpURLConnection urlConnection = (HttpURLConnection) urlObj.openConnection();
		        urlConnection.setDoOutput(true);
		        urlConnection.setDoInput(true);
		        urlConnection.setUseCaches(false);
		        urlConnection.setConnectTimeout(5000);
		        
		        
		        
		        urlConnection.setRequestMethod("POST");
		        urlConnection.setRequestProperty(HEADER_KEY_APPID, "AMWAY");
		        urlConnection.setRequestProperty(HEADER_KEY_URL, pushHttpUrl);
		        urlConnection.setRequestProperty(HEADER_KEY_AUTHKEY, authKey);
		        urlConnection.setRequestProperty(HEADER_KEY_APIVER, "1.0");
		        LOGGER.debug("######## PUSHLOG : HEADER_KEY_URL = " + pushHttpUrl + "   ######################");
		        LOGGER.debug("######## PUSHLOG : HEADER_KEY_AUTHKEY = " + authKey + "   ######################");
		
	      
		        OutputStreamWriter osw = new OutputStreamWriter(urlConnection.getOutputStream());
		        
		        osw.write("receiver="+receiver+"&title="+title+"&msg="+msg+"&category="+category+"&url="+url+"&msgType=0&img=");
		        osw.flush();
		        LOGGER.debug("######## PUSHLOG : PARAM = " + "receiver="+receiver+"&title="+title+"&msg="+msg+"&category="+category+"&url="+url+"&msgType=0&img=");
		        // 응답 헤더의 정보를 모두 출력
		        for (Map.Entry<String, List<String>> header : urlConnection.getHeaderFields().entrySet()) {
		            for (String value : header.getValue()) {
		                LOGGER.debug("######## PUSHLOG : HEADER = " + header.getKey() + " : " + value);
		            }
		        }
		        
		        resultCode = urlConnection.getHeaderField("ResultCode");
		        urlConnection.disconnect();
	    		
	    	}
		} catch (SftpException e) {
			LOGGER.debug(e.toString());
		} catch (FileNotFoundException e) {
			LOGGER.debug(e.toString());
		} catch( IOException e) {
			LOGGER.debug(e.toString());
		} catch (NumberFormatException e) {
			LOGGER.debug(e.toString());
		}
		LOGGER.debug("######## PUSHLOG : resultCode = " + resultCode + "   ######################");
		return getPushResult(resultCode);
    }
    
    
    
	 // 개별 송신을 한다
    public DataBox sendPushByUser(RequestBox requestBox) throws Exception {
    	
    	String resultCode = ""; // 결과코드
    	
    	String pushYn = ""; // 푸시 실행 여부
    	String pushHttpUrl = ""; // 연결 URL
    	String pushHttpUserId = ""; // 연결권한 아이디
    	try{
			String resourceName = "/config/props/framework.properties";
			ClassLoader loader = Thread.currentThread().getContextClassLoader();
			Properties props = new Properties();
			
			InputStream resourceStream = loader.getResourceAsStream(resourceName);
			props.load(resourceStream);
			pushYn = props.getProperty("interface.push.yn");
			pushHttpUrl = props.getProperty("interface.push.http.url.user");
			pushHttpUserId = props.getProperty("interface.push.http.user.id");
	
	        String userId = requestBox.getString("pushUserId");
	        String title = requestBox.getString("pushTitle");
	        String msg = requestBox.getString("pushMsg");
	        String url = requestBox.getString("pushUrl");
	        String category = requestBox.getString("pushCategory");
	        
	        String blankStr = "";
	        String yStr = "Y";
	        if(blankStr.equals(userId) || blankStr.equals(title) || blankStr.equals(msg) ){  // 필수 파라미터 없음
	        	resultCode = "noparam"; 
	        }else if( !yStr.equals(pushYn) ) {  // 로컬인 경우 실행하지 않음
	    		resultCode = "local";
	    	}else{
	   		
	
				URL urlObj = new URL(pushHttpUrl);
		    	final SimpleDateFormat simpleDateFormat = new SimpleDateFormat("yyyyMMddHHmmss");
		    	LOGGER.debug("SimpleDateFormat = " + simpleDateFormat.format(new Date()));
		    	final String authKey = encode(simpleDateFormat.format(new Date())+pushHttpUserId);
		
		        HttpURLConnection urlConnection = (HttpURLConnection) urlObj.openConnection();
		        urlConnection.setDoOutput(true);
		        urlConnection.setDoInput(true);
		        urlConnection.setUseCaches(false);
		        urlConnection.setConnectTimeout(5000);

		        urlConnection.setRequestMethod("POST");
		        urlConnection.setRequestProperty(HEADER_KEY_APPID, "AMWAY");
		        urlConnection.setRequestProperty(HEADER_KEY_URL, pushHttpUrl);
		        urlConnection.setRequestProperty(HEADER_KEY_AUTHKEY, authKey);
		        urlConnection.setRequestProperty(HEADER_KEY_APIVER, "1.0");
		        LOGGER.debug("######## PUSHLOG : HEADER_KEY_URL = " + pushHttpUrl + "   ######################");
		        LOGGER.debug("######## PUSHLOG : HEADER_KEY_AUTHKEY = " + authKey + "   ######################");
		
	      
		        OutputStreamWriter osw = new OutputStreamWriter(urlConnection.getOutputStream());
		        
		        osw.write("userId="+userId+"&title="+title+"&msg="+msg+"&category="+category+"&url="+url+"&msgType=0&img=");
		        osw.flush();
		        LOGGER.debug("######## PUSHLOG : PARAM = " + "userId="+userId+"&title="+title+"&msg="+msg+"&category="+category+"&url="+url+"&msgType=0&img=" + "   ######################");
		        // 응답 헤더의 정보를 모두 출력
		        for (Map.Entry<String, List<String>> header : urlConnection.getHeaderFields().entrySet()) {
		            for (String value : header.getValue()) {
		                LOGGER.debug("######## PUSHLOG : HEADER = " + header.getKey() + " : " + value + "#################");
		            }
		        }
		        
		        resultCode = urlConnection.getHeaderField("ResultCode");
		        LOGGER.debug("######## PUSHLOG : resultCode = " + resultCode + " ############ ");
		        urlConnection.disconnect();
	    	}
		} catch (FileNotFoundException e) {
			LOGGER.debug(e.toString());
		} catch( IOException e) {
			LOGGER.debug(e.toString());
		} catch (NumberFormatException e) {
			LOGGER.debug(e.toString());
		}
        return getPushResult(resultCode);
    }
    
    
    
    /**
     * <pre>
     * 리턴된 resultCode 으로 결과 처리
     *
     * @param resultCode
     * @return DataBox
     * @author sang42
     * </pre>
     */
    protected  DataBox getPushResult(final String resultCode)
    {
    	
        final DataBox data = new DataBox();
        String returnMsg = "";
        String status = "";
        data.put("resultCode", resultCode);
        if (RESULT_SUCCESS_200.equals(resultCode) || RESULT_SUCCESS_201.equals(resultCode))
        {
        	returnMsg = "성공";
        	status = "OK";
        }
        else
        {
        	status = "NO";
            switch (resultCode)
            {
                case "300":
                	returnMsg = "권한 없음";
                    break;
                case "301":
                	returnMsg = "인증 실패";
                    break;
                case "302":
                	returnMsg = "유효하지 않는 인증키";
                    break;
                case "303":
                	returnMsg = "인증키 생성 실패";
                    break;
                case "400":
                	returnMsg = "파라미터가 부족";
                    break;
                case "401":
                	returnMsg = "파라미터 유효하지 않음";
                    break;
                case "402":
                	returnMsg = "데이터 중복";
                    break;
                case "403":
                	returnMsg = "로그인 아이디 중복";
                    break;
                case "404":
                	returnMsg = "이름 중복";
                    break;
                case "500":
                	returnMsg = "DB 연결 실패";
                    break;
                case "501":
                	returnMsg = "DB 실패";
                    break;
                case "599":
                	returnMsg = "기타 에러";
                    break;
                case "local":
                	returnMsg = "로컬호스트 푸시서버연결 불가";
                    break;
                case "noparam":
                	returnMsg = "필수파라미터없음";
                    break;
                default:
                	returnMsg = "에러";
                    break;
            }
            LOGGER.debug("######## PUSHLOG : resultCode = " + resultCode + " ############ ");
            LOGGER.debug("######## returnMsg : " + returnMsg + "에러메시지");
            LOGGER.debug("######## resultCode : " + resultCode + "결과코드");
        }
        data.put("status",status);
        data.put("resultCode",resultCode);
        data.put("returnMsg",returnMsg);
        return data;

    }
    
    
    /**
     * <pre>
     * 암호화
     * 1. SEED_CBC_Encrypt 처리
     * 2. encodeBase64 처리
     *
     * @param str
     * @return String
     * @author sang42
     * </pre>
     */
    public static String encode(final String str)
    {
        final byte[] encoded = Base64.encodeBase64(KisaSeedCBC.SEED_CBC_Encrypt(PB_USER_KEY, BSZ_IV, str.getBytes(), 0, str.getBytes().length));
        return new String(encoded);
    }
}
