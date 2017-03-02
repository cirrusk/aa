package framework.com.cmm.util;

import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.io.UnsupportedEncodingException;
import java.security.InvalidAlgorithmParameterException;
import java.security.InvalidKeyException;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.text.DecimalFormat;

import javax.crypto.BadPaddingException;
import javax.crypto.Cipher;
import javax.crypto.IllegalBlockSizeException;
import javax.crypto.NoSuchPaddingException;
import javax.crypto.SecretKey;
import javax.crypto.spec.IvParameterSpec;
import javax.crypto.spec.SecretKeySpec;

import org.apache.commons.codec.binary.Base64;

public class StringUtil {
	/**
     * upload 경로
     * @param String
     * @return String
     */
    public static String uploadPath() {
        //String result = "C:/egovframework/upload/";
    	String result = "/ainas";

        return result;
    }
    
    /**
     * 해당 문자열에서 older String 을 newer String 으로 교체한다.
     * @param String
     * @param String
     * @param String
     * @return String
     */
    public static String replace(String original, String older, String newer) {
        String result = original;

        if(original != null) {
            int idx = result.indexOf(older);
            int newLength = newer.length();

            while(idx >= 0) {
                if(idx == 0) {
                    result = newer + result.substring(older.length());
                } else {
                    result = result.substring(0, idx) + newer + result.substring(idx + older.length());
                }
                
                idx = result.indexOf(older, idx + newLength);
            }
        }

        return result;
    }

    /**
     * java.lang.String 패키지의 trim() 메소드와 기능은 동일, null 체크만 함
     * @param String
     * @return String
     */
    public static String trim(String str) {
        String result = "";

        if(str != null)
            result = str.trim();

        return result;
    }

    /**
     * java.lang.String 패키지의 substring() 메소드와 기능은 동일, null 체크만 함
     * @param String
     * @param int
     * @param int
     * @return String
     */
    public static String substring(String str, int beginIndex, int endIndex) {
        String result = "";
        
        if(str.length() < beginIndex) {
            result = "";
        } else if(str.length() < endIndex) {
            result = str.substring(beginIndex);
        } else if(str != null) {
            result = str.substring(beginIndex, endIndex);
        }

        return result;
    }

    /**
     * java.lang.String 패키지의 substring() 메소드와 기능은 동일, null 체크만 함
     * @param String
     * @param int
     * @return String
     */
    public static String substring(String str, int beginIndex) {
        String result = "";
        boolean isFinish = true;

        if(str == null || str.equals(""))
            isFinish = false;

        if(isFinish && str.length() < beginIndex)
            result = str;

        if(isFinish && !str.equals(""))
            result = str.substring(beginIndex);

        return result;
    }

    /**
     * java.lang.String 패키지의 substring() 메소드와 기능은 동일한데 오른쪽 문자끝부터 count 를 해서 자름
     * @param String
     * @param int
     * @return String
     */
    public static String rightstring(String str, int count) throws Exception {
        if(str == null)
        	return null;

        String result = null;
        
        try {
            if(count == 0)     //      갯수가 0 이면 공백을
                result = "";
            else if(count > str.length())    //  문자열 길이보다 크면 문자열 전체를
                result = str;
            else
                result = str.substring(str.length() - count,str.length());  //  오른쪽 count 만큼 리턴
        } catch(Exception ex) {
            throw new Exception("StringUtil.rightstring(\"" + str + "\"," + count + ")\r\n" + ex.getMessage());
        }

        return result;
    }

    /**
     * null 체크
     * @param String
     * @return String
     */
    public static String chkNull(String str) {
        if(str == null)
            return "";
        else
            return str;
    }
    
    public static String nvl(String str, String val) {
      if ((str == null) || (str.trim().equals(""))) {
    	  return val;
      }
      return str;
    }

    /**
     * String 형을 int 형으로 변환, null 및 "" 체크
     * @param String
     * @return int
     */
    public static int toInt(String str) {
    	int result = 0;
        if(str == null || str.equals("")) {
        	result = 0;
        } else {
        	try {
        		result = Integer.parseInt(str);
        	} catch(Exception e) {
        		result = 0;
        	}
        }
        
        return result; 
    }

    /**
     * 한글 인코딩
     * @param String
     * @return String
     */
    public static String korEncode(String str) throws UnsupportedEncodingException {
        if(str == null)
        	return null;
        
        return new String(str.getBytes("8859_1"), "KSC5601");
    }

    /**
     * 영문 인코딩
     * @param String
     * @return String
     */
    public static String engEncode(String str) throws UnsupportedEncodingException {
        if(str == null)
        	return null;
        
        return new String(str.getBytes("KSC5601"), "8859_1");
    }

    /**
     * 제목을 보여줄때 제한된 길이를 초과하면 뒷부분을 짜르고 "..." 으로 대치한다.
     * @param String
     * @param int
     * @return String
     */
    public static String formatTitle(String title, int max) {
        if(title == null)
        	return null;

        if(title.length() <= max)
            return title;
        else
            return title.substring(0, max - 3) + "...";
    }

    /**
     * 제목을 보여줄때 제한된 길이를 초과하면 뒷부분을 짜르고 "..." 으로 대치한다.
     * @param String
     * @param int
     * @return String
     */
    public static String formatTitleForByte(String title, int max) {
        if(title == null)
        	return "";

        byte[] btitle = title.getBytes();

        if(btitle.length <= max) {
            return title;
        } else {
            byte[] result = new byte[max - 3];
            
            for(int i = 0 ; i < max - 3 ; i++) {
                result[i] = btitle[i];
            }
            
            return new String(result) + "...";
        }
    }

    /**
     * 제목을 보여줄때 제한된 길이를 초과하면 뒷부분을 짜르고 "..." 으로 대치한다.
     * @param String
     * @return String
     */
    public static String cutZero(String seq) {
        String result = "";

        try {
            result = Integer.parseInt(seq) + "";
        } catch( Exception e ) { }
        
        return result;
    }

    /**
     * 통화형으로 변환한다.
     * @param Object
     * @param boolean
     * @return String
     */
    public static String priceComma(Object price, boolean isTruncated) {
    	String str = price.toString();
    	
        if(str == null)
            return "0";
        
        if(str.trim().equals(""))
            return "0";
        
        if(str.trim().equals("&nbsp;"))
            return "&nbsp;";
        
        int pos = str.indexOf(".");
        
        if(pos != -1) {
            if(!isTruncated) {
                DecimalFormat commaFormat = new DecimalFormat("#,##0.00");
                return commaFormat.format(Float.parseFloat(str.trim()));
            } else {
                DecimalFormat commaFormat = new DecimalFormat("#,##0");
                return commaFormat.format(Long.parseLong(str.trim().substring(0, pos)));
            }
        } else {
            DecimalFormat commaFormat = new DecimalFormat("#,##0");
            return commaFormat.format(Long.parseLong(str.trim()));
        }
    }

    /**
     * 주민번호 형식으로 변환한다.
     * @param String
     * @return String
     */
    public static String juminno(String str) {
        String ret = "";

        try {
            if(str != null && str.length() == 13) {
                ret = substring(str, 0, 6) + "-" + substring(str, 6);
            }
        } catch (Exception e) { }
        
        return ret;
    }

    /**
     * 해당 문자열을 반복횟수만큼 반복한다.
     * @param String
     * @param int
     * @return String
     */
    public static String replicate(String str, int len) {
        String ret = "";

        try {
            for(int i = 0 ; i < len ; i++) {
                ret += str;
            }
        } catch (Exception e) { }
        
        return ret;
    }

/*    *//**
     * Object를 Json String으로
     * @param Object
     * @return String
     *//*
    public static String toJsonStr(Object obj) {
        String rv = null;
        try {
            if (obj != null) {
                GsonBuilder gb = new GsonBuilder();
                gb.serializeNulls();
                gb.registerTypeAdapter(CaseInsensitiveMap.class, new GMap2JsonConverter());
                gb.registerTypeAdapter(HashMap.class, new GMap2JsonConverter());
                gb.registerTypeAdapter(Map.class, new GMap2JsonConverter());
                gb.registerTypeAdapter(List.class, new GMap2JsonConverter());
                gb.registerTypeAdapter(String.class, new GString2JsonConverter());
                Gson gson = gb.create();
                rv = gson.toJson(obj);
            } else {
                rv = "{}";
            }
        } catch(Exception e) {
        	e.printStackTrace();
        }
        
        return rv;
    }*/

    /**
     * 데이타를 구분자로 나누어 배열로 리턴
     * @param String
     * @param String
     * @return String[]
     */
    public static String[] split(String str, String sepe_str) {
        int index = 0;
        String[] result = new String[search(str, sepe_str) + 1];
        String strCheck = new String(str);

        if(str.equals("")) {
            result[0] = "";
        } else {
            while(strCheck.length() != 0) {
                int begin = strCheck.indexOf(sepe_str);
                if(begin == -1) {
                    result[index] = strCheck;
                    break;
                } else {
                    int end = begin + sepe_str.length();
                    if(true) {
                        result[index++] = strCheck.substring(0, begin);
                    }

                    strCheck = strCheck.substring(end);

                    if(strCheck.length() == 0 && true) {
                        result[index] = strCheck;
                        break;
                    }
                }
            }
        }

        return result;
    }

    /**
     * 문자열에서 특정 문자열의 위치를 돌려준다.
     * @param String
     * @param String
     * @return int
     */
    public static int search(String strTarget, String strSearch) {
        int result = 0;
        String strCheck = new String(strTarget);
        
        for(int i = 0; i < strTarget.length();) {
            int loc = strCheck.indexOf(strSearch);
            if(loc == -1) {
                break;
            } else {
                result++;
                i = loc + strSearch.length();
                strCheck = strCheck.substring(i);
            }
        }
        
        return result;
    }

    /**
     * 문자열에서 HTML 테그를 제거해준다.
     * @param String
     * @return String
     */
    public static String removeTag(String str) {
        String buf = str;

        int begin = 0;
        int end = 0;
        int old_begin = 0;

        buf = buf.toLowerCase();

        String result = "";
        /* javascript tag 제거 */
        while(true) {
            if((begin = buf.indexOf("<script", begin)) == -1)
                break;
            
            if((end = buf.indexOf("</script>", end)) == -1)
                break;
            
            if(end > begin) {               
                result += buf.substring(old_begin, begin);
                old_begin = end + 9;
            }
            
            ++end;
            ++begin;
        }
        
        result = buf;
        
        /* html 태그 제거 */
        buf = result.replaceAll("&[a-z]+;", " ");
        result = buf.replaceAll("(<([a-z!/]+)[^>]*>)|([\\t\\x0B\\f]+)|(([\\r\\n][\\r\\n])+)|(-->)", "");       

        buf = "";
        int len = result.length();
        int i = 0;
        
        // 공백 문자 제거
        while(len > i) {
            while((len > i) && (result.charAt(i) == ' '))
            	++i;
            
            while((len > i) && (result.charAt(i) != ' '))
                buf += result.charAt(i++);
            
            if(len > i)
                buf += " ";
        }

        return buf;
    }
    
    /**
     * 특수문자를 HTML 특수문자로 고쳐준다.
     * @param String
     * @return String
     */
    public static String htmlSpecialChar(String str) {
        if(str == null) 
            return "";
        
        str = str.replaceAll("&", "&amp;");
        str = str.replaceAll("<", "&lt;");
        str = str.replaceAll(">", "&gt;");
        str = str.replaceAll("\'", "&apos;");
        str = str.replaceAll("\'", "&#039;");
        str = str.replaceAll("\"", "&quot;");
        str = str.replaceAll("\"", "&#034;");
        str = str.replaceAll("\r\n", "<BR>");
        str = str.trim();
        
        return str;
    }
    
    /**
     * HTML 특수 문자를 TAG로 변환
     * @param value
     * @return
     */
    public static String replaceTag(String value) {
		if (value == null || value.trim().equals("")) {
			return "";
		}

		String returnValue = value;

		returnValue = returnValue.replaceAll("&amp;","&" );
		returnValue = returnValue.replaceAll("&lt;" ,"<" );
		returnValue = returnValue.replaceAll("&gt;" , ">");
		returnValue = returnValue.replaceAll("&#34;","\"");
		returnValue = returnValue.replaceAll("&quot;","\"");
		returnValue = returnValue.replaceAll("&#39;","\'");
		returnValue = returnValue.replaceAll("&#46;","." );
		returnValue = returnValue.replaceAll("&#47;","4%2F");
		return returnValue;
	}
    
    /**
     * 문자열을 해당 캐릭터 셋으로 인코딩 하여 변환
     * @param str
     * @param encoding
     * @return
     * @throws IOException
     */
	public static String convert(String str, String encoding) throws IOException { 
		ByteArrayOutputStream requestOutputStream = new ByteArrayOutputStream(); 
		requestOutputStream.write(str.getBytes(encoding));   
		return requestOutputStream.toString(encoding); 
	}
	
    /**
     * 임시비밀번호를 생성하여 반환한다.
     * @return String
     * @throws IOException
     */
    public static String makeTempPassword() throws IOException {
        String password = "";
        
        for(int i = 0 ; i < 10 ; i++) {
            //char upperStr = (char)(Math.random() * 26 + 65);
            char lowerStr = (char)(Math.random() * 26 + 97);
            
            if(i % 2 == 0) {
                password += (int)(Math.random() * 10);
            } else {
                password += lowerStr;
            }
        }
        
        return password;
    }
    
    /**
	 * 암호화 설정
	 * @param srcString
	 * @return String
	 * @exception Exception
	 * @see
	 */
	public static String getEncryptStr(String strVal) {
		String rtnEncode = ""; 
		
		final String TRANSFORMATION = "AES/CBC/PKCS5Padding"; 	// 알고리즘/모드/패딩방식
        final String ALGORITHM = "AES"; 	// 암호화 알고리즘
        final String DIGEST = "MD5"; 			// MD5 해싱을 통해 암호화를 위한 16바이트 key, iv 생성 
        final String KEY = "123"; 					// KEY 초기 값 
        final String IV = "456"; 					// IV 초기 값
        
        try {
			final Cipher cipher = Cipher.getInstance(TRANSFORMATION);										// 알고리즘/모드/패딩방식 설정 -> AES/CBC/PKCS7Padding
			final MessageDigest md = MessageDigest.getInstance(DIGEST); 									// KEY와 IV를 MD5 해싱
			final SecretKey key = new SecretKeySpec(md.digest(KEY.getBytes("UTF8")), ALGORITHM); 	// AES 암호화를 위한 key 생성
			final IvParameterSpec ivParamSpec = new IvParameterSpec(md.digest(IV.getBytes("UTF8"))); 	// 암호화를 위한 iv(initial vector) 생성
			
			cipher.init(Cipher.ENCRYPT_MODE, key, ivParamSpec); 
			
			byte[] utf8Value = strVal.getBytes("UTF8"); 		// Get a UTF-8 byte array from a unicode string.
			byte[] arrCipherData = cipher.doFinal(utf8Value); 						// AES 암호화 실행
			rtnEncode = new String(Base64.encodeBase64(arrCipherData)); 	// 암호화된 데이터를 문자열로 변환

        }catch(InvalidKeyException e){
			e.printStackTrace();
        	rtnEncode = "";
        }catch(IllegalBlockSizeException e){
			e.printStackTrace();
        	rtnEncode = "";
        }catch(InvalidAlgorithmParameterException e){
			e.printStackTrace();
        	rtnEncode = "";
		}catch(UnsupportedEncodingException e){
			e.printStackTrace();
        	rtnEncode = "";
        }catch(NoSuchPaddingException e){
			e.printStackTrace();
        	rtnEncode = "";
        }catch(BadPaddingException e){
			e.printStackTrace();
        	rtnEncode = "";
        }catch(NoSuchAlgorithmException e){
			e.printStackTrace();
        	rtnEncode = "";
        }
        
		return rtnEncode;
	}
	
	/**
	 * 복호화 설정
	 * @param srcString
	 * @return String
	 * @exception Exception
	 * @see
	 */
	public static String getDecryptStr(String strVal) throws Exception {
		String rtnDecode = "";
		
		final String TRANSFORMATION = "AES/CBC/PKCS5Padding"; 	// 알고리즘/모드/패딩방식
        final String ALGORITHM = "AES"; 		// 복호화 알고리즘
        final String DIGEST = "MD5"; 				// MD5 해싱을 통해 복호화를 위한 16바이트 key, iv 생성 
        final String KEY = "123"; 						// KEY 초기 값 
        final String IV = "456"; 						// IV 초기 값
        
        try  {
        	final Cipher cipher = Cipher.getInstance(TRANSFORMATION);										// 복호화 알고리즘/모드/패딩방식 설정 -> AES/CBC/PKCS7Padding
            final MessageDigest md = MessageDigest.getInstance(DIGEST); 									// KEY와 IV를 MD5 해싱
            final SecretKey key = new SecretKeySpec(md.digest(KEY.getBytes("UTF8")), ALGORITHM); 	// AES 복호화를 위한 key 생성
            final IvParameterSpec ivParamSpec = new IvParameterSpec(md.digest(IV.getBytes("UTF8"))); 	// 복호화를 위한 iv(initial vector) 생성

            cipher.init(Cipher.DECRYPT_MODE, key, ivParamSpec); 		// 복호화 모드로 객체 초기화
            
            byte[] encryptedValue = Base64.decodeBase64(strVal); 		// Base64 디코딩, 아스키 텍스트 -> 바이트 스트림
            byte[] decryptedValue = cipher.doFinal(encryptedValue); 	// AES 복호화 실행 문자열로 변환
            
            rtnDecode = new String(decryptedValue, "UTF8");

        }catch(IOException e){
			e.printStackTrace();
        	rtnDecode = "";
        }
		
		return rtnDecode;
	}
}