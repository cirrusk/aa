package framework.com.cmm.util;

import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;

public class DateUtil {
	private static final String DATE_FORMAT = "yyyy.MM.dd";
	private static final String TIME_FORMAT = "HH:mm:ss";
	private static final String DATETIME_FORMAT = "yyyy.MM.dd HH:mm:ss";
	
    /**
     * 시간을 스트링으로 받어서 type 형태로 리턴한다.
     * 예) getFormatTime("1200","HH:mm") - > "12:00"
     *    getFormatTime("1200","HH:mm:ss") - > "12:00:00"
     *    getFormatTime("120003","HH:mm") - > "12:00"
     *    getFormatTime("120003","HH:mm ss") - > "12:00 03"
     * @param String 시간
     * @param String 시간타입
     * @return String 변경된 시간타입을 반환함
     */
    public static String getFormatTime(String time, String type) throws Exception {
        if(time == null || type == null)
        	return "";

        String result= "";
        int hour = 0, min = 0, sec = 0;

        try {
            try {
            	hour = Integer.parseInt(time.substring(0, 2));
            	min = Integer.parseInt(time.substring(2, 4));
            	sec = Integer.parseInt(time.substring(4, 6));
            } catch(IndexOutOfBoundsException ex) {
                // ignore
            }
            
            Calendar calendar = Calendar.getInstance();
            calendar.set(0, 0, 0, hour, min, sec);
            result = (new SimpleDateFormat(type)).format(calendar.getTime());
        } catch(Exception ex) {
            throw new Exception("DateUtil.getFormatTime(\"" + time + ", \"" + type + "\")\r\n" + ex.getMessage());
        }

        return result;
    }
    
    /**
     * 시간을 스트링으로 받어서 기본 형태로 리턴한다.
     * 예) getFormatTime("120003") - > 상수로 정의된 기본형태
     * @param String 시간
     * @return String 변경된 시간타입을 반환함
     */
    public static String getFormatTime(String time) throws Exception {
        return getFormatTime(time, TIME_FORMAT);
    }
    
    /**
     * 날짜( +시간)을 스트링으로 받어서 type 형태로 리턴한다.
     * 예) getFormatDate("19991201","yyyy/MM/dd") - > "1999/12/01"
     *    getFormatDate("19991201","yyyy-MM-dd") - > "1999-12-01"
     *    getFormatDate("1999120112","yyyy-MM-dd HH") - > "1999-12-01 12"
     *    getFormatDate("199912011200","yyyy-MM-dd HH:mm ss") - > "1999-12-01 12:00 00"
     *    getFormatDate("19991231115959","yyyy-MM-dd-HH-mm-ss") - > "1999-12-31-11-59-59"
     * @param String 날짜
     * @param String 날짜타입
     * @return String 변경된 날짜타입을 반환함
     */
    public static String getFormatDateTime(String date, String type) throws Exception {
        if(date == null || type == null)
        	return "";

        String result = "";
        int year = 0, month = 0, day = 0, hour = 0, min = 0, sec = 0, length = date.length();

        try {
            if(length >= 8) {  // 날짜
                year = Integer.parseInt(StringUtil.substring(date, 0, 4));
                month = Integer.parseInt(StringUtil.substring(date, 4, 6)); // month 는 Calendar 에서 0 base 으로 작동하므로 1 을 빼준다.
                day = Integer.parseInt(StringUtil.substring(date, 6, 8));

                if(length == 10) {     // 날짜 +시간
                    hour = Integer.parseInt(StringUtil.substring(date, 8, 10));
                }
                
                if(length == 12) {     // 날짜 +시간
                    hour = Integer.parseInt(StringUtil.substring(date, 8, 10));
                    min = Integer.parseInt(StringUtil.substring(date, 10, 12));
                }
                
                if(length == 14) {     // 날짜 +시간
                    hour = Integer.parseInt(StringUtil.substring(date, 8, 10));
                    min = Integer.parseInt(StringUtil.substring(date, 10, 12));
                    sec = Integer.parseInt(StringUtil.substring(date, 12, 14));
                }
                
                Calendar calendar=Calendar.getInstance();
                calendar.set(year, month - 1, day, hour, min, sec);
                result = (new SimpleDateFormat(type)).format(calendar.getTime());
            }
        } catch(Exception ex) {
            throw new Exception("DateUtil.getFormatDateTime(\"" + date + "\", \"" + type + "\")\r\n" + ex.getMessage());
        }

        return result;
    }
    
    /**
     * 날짜( +시간)을 스트링으로 받어서 기본 형태로 리턴한다.
     * 예) getFormatDate("19991231115959") - > 상수로 정의된 기본형태
     * @param String 날짜
     * @return String 변경된 날짜타입을 반환함
     */
    public static String getFormatDateTime(String date) throws Exception {
        return getFormatDateTime(date, DATETIME_FORMAT);
    }
    
    /**
     * 날짜를 스트링으로 받어서 type 형태로 리턴한다.
     * 예) getFormatDate("19991201","yyyy/MM/dd") - > "1999/12/01"
     *    getFormatDate("19991201","yyyy-MM-dd") - > "1999-12-01"
     * @param String 날짜
     * @param String 날짜타입
     * @return String 변경된 날짜타입을 반환함
     */
    public static String getFormatDate(String date, String type) throws Exception {
        if(date == null || type == null)
        	return "";

        String result = "";
        int year = 0, month = 0, day = 0, length = date.length();

        try {
            if(length >= 8) {  // 날짜
                year = Integer.parseInt(StringUtil.substring(date, 0, 4));
                month = Integer.parseInt(StringUtil.substring(date, 4, 6)); // month 는 Calendar 에서 0 base 으로 작동하므로 1 을 빼준다.
                day = Integer.parseInt(StringUtil.substring(date, 6, 8));

                Calendar calendar=Calendar.getInstance();
                calendar.set(year, month - 1, day, 0, 0, 0);
                result = (new SimpleDateFormat(type)).format(calendar.getTime());
            }
        } catch(Exception ex) {
            throw new Exception("DateUtil.getFormatDate(\"" + date + "\", \"" + type + "\")\r\n" + ex.getMessage());
        }

        return result;
    }
    
    /**
     * 날짜를 스트링으로 받어서 기본 형태로 리턴한다.
     * 예) getFormatDate("19991201") - > 상수에 정의된 기본 형태
     * @param String 날짜
     * @param String 날짜타입
     * @return String 변경된 날짜타입을 반환함
     */
    public static String getFormatDate(String date) throws Exception {
        return getFormatDate(date, DATE_FORMAT);
    }
    
    /**
     * 날짜를 여러 타입으로 리턴한다.
     * 예) getDate("yyyyMMdd");
     *    getDate("yyyyMMddHHmmss");
     *    getDate("yyyyMMddHHmmssSSS");
     *    getDate("yyyy/MM/dd HH:mm:ss");
     *    getDate("yyyy/MM/dd");
     *    getDate("HHmm");
     * @param type 날짜타입
     * @return result  변경된 날짜타입을 반환함
     */
    public static String getDateType(String type) throws Exception {
        if ( type == null ) return null;

        String s= "";
        try {
            s = new SimpleDateFormat(type).format(new Date());
        } catch ( Exception ex ) {
            throw new Exception("getFormatDate.getDateType(\"" +type + "\")\r\n" +ex.getMessage() );
        }

        return s;
    }
    
    /**
     * 오늘 날짜를 기본형태로 반환한다..
     * 예) getDate();
     * @return result 기본형태로 변경된 오늘 날짜
     */
    public static String getDate() throws Exception {
        String s= "";
        try {
            s = new SimpleDateFormat(DATE_FORMAT).format(new Date());
        } catch ( Exception ex ) {
            throw new Exception("getFormatDate.getDate()\r\n" +ex.getMessage() );
        }

        return s;
    }
    
    /**
     * 현재 시간을 기본형태로 반환한다..
     * 예) getTime();
     * @return result 기본형태로 변경된 현재시간
     */
    public static String getTime() throws Exception {
        String s= "";
        try {
            s = new SimpleDateFormat(TIME_FORMAT).format(new Date());
        } catch ( Exception ex ) {
            throw new Exception("getFormatDate.getTime()\r\n" +ex.getMessage() );
        }

        return s;
    }
    
    /**
     * 오늘 날짜와 현재 시간을 기본형태로 반환한다..
     * 예) getDateTime();
     * @return result 기본형태로 변경된 오늘 날짜와 현재시간
     */
    public static String getDateTime() throws Exception {
        String s= "";
        try {
            s = new SimpleDateFormat(DATETIME_FORMAT).format(new Date());
        } catch ( Exception ex ) {
            throw new Exception("getFormatDate.getDateTime()\r\n" +ex.getMessage() );
        }

        return s;
    }
    
    /**
     * 입력받은 날짜와 시간의 형태를 '년월일' 형태로 표현한다. <br>
     * 예 ) datetime : 20160615 => 2016년 6월 15일
     * 예 ) type : YMD or MD
     * 
     * @param date
     * @param type
     * @return
     * @throws Exception
     */
    public static String getKoreanDate(String date, String type)throws Exception {
    	
    	String s = "";
    	
    	int year = 0;
    	int month = 0;
    	int day = 0;
    	
    	try{
    		
    		if ( 8 != date.length() ) {
    			return "false";
    		}
    		
    		year = Integer.parseInt(StringUtil.substring(date, 0, 4));
    		month = Integer.parseInt(StringUtil.substring(date, 4, 6));
    		day = Integer.parseInt(StringUtil.substring(date, 6, 8));
    		
    	}catch (Exception e) {
    		throw new Exception("getKoreanDate()\r\n" + e.getMessage() );
    	}
    	
    	if ( -1 != type.indexOf("Y")) {
    		s += " " + year + " 년";
    	}
    	
    	if ( -1 != type.indexOf("M")) {
    		s += " " + month + " 월";
    	}
    	
    	if ( -1 != type.indexOf("D")) {
    		s += " " + day + " 일";
    	}
    	
    	return s;
    }
    
    /**
     * 입력받은 날짜와 시간의 형태를 '년월일시분' 형태로 표현한다. <br>
     * 예 ) datetime : 201606151325 => 2016년 6월 15일 13시 25분
     * 예 ) type : YMDhm or YMD or MDhm
     * @return
     */
    public static String getKoreanDateTime(String datetime, String type)throws Exception {
    	
    	String s = "";

    	int year = 0;
    	int month = 0;
    	int day = 0;
    	int hour = 0;
    	int min = 0;
    	
    	try{
    		
    		if ( 12 != datetime.length() ) {
    			return "false";
    		}
    		
    		year = Integer.parseInt(StringUtil.substring(datetime, 0, 4));
    		month = Integer.parseInt(StringUtil.substring(datetime, 4, 6));
    		day = Integer.parseInt(StringUtil.substring(datetime, 6, 8));
        	hour = Integer.parseInt(StringUtil.substring(datetime, 8, 10));
        	min = Integer.parseInt(StringUtil.substring(datetime, 10, 12));
    	}catch (Exception e) {
    		throw new Exception("getFormatDate.getDateTime()\r\n" + e.getMessage() );
    	}
    	
    	if ( -1 != type.indexOf("Y")) {
    		s += " " + year + " 년";
    	}
    	
    	if ( -1 != type.indexOf("M")) {
    		s += " " + month + " 월";
    	}
    	
    	if ( -1 != type.indexOf("D")) {
    		s += " " + day + " 일";
    	}
    	
    	if ( -1 != type.indexOf("h")) {
    		if(hour < 10){
    			s += " 0" + hour + " 시";
    		}else{
    			s += " " + hour + " 시";
    		}
    	}
    	
    	if ( -1 != type.indexOf("m")) {
    		if(min < 10){
    			s += " 0" + min + " 분";
    		}else{
    			s += " " + min + " 분";
    		}
    	}
    	
    	return s;
    }
    
    /**
     * 해당날짜의 요일을 계산한다. (년월일(6자리)을 지정하는데 지정되지 않으면 default 값을 사용한다. 2000.2)
     * 예) getDayOfWeek("2000")     - > 토 (2000/1/1)
     *    getDayOfWeek("200002")   - > 화 (2000/2/1)
     *    getDayOfWeek("20000225") - > 금 (2000/2/25)
     * @param String 날짜타입
     * @return String 해당일의 요일
     */
    public static String getDayOfWeek(String date) {
        if(date == null)
        	return "";

        int yyyy = 0, MM = 1, dd = 1, day_of_week; // default

        String days[] = { "일","월","화","수","목","금","토"};

        try {
            yyyy = Integer.parseInt(StringUtil.substring(date, 0, 4));
            MM = Integer.parseInt(StringUtil.substring(date, 4, 6));
            dd = Integer.parseInt(StringUtil.substring(date, 6, 8));
        } catch(Exception ex) {
            // do nothing
        }

        Calendar calendar = Calendar.getInstance();
        calendar.set(yyyy, MM - 1, dd);
        day_of_week = calendar.get(Calendar.DAY_OF_WEEK); // 1(일),2(월),3(화),4(수),5(목),6(금),7(토)

        return days[day_of_week - 1];
    }

    /**
     * 오늘의 요일을 계산한다.
     * @return 오늘의 요일을 반환함
     */
    public static String getDayOfWeek() throws Exception {
        return getDayOfWeek(getDateType("yyyyMMdd"));
    }
    
    /**
     * 년, 월, 일, 시, 분등과 관련된 HTML <option> 을 출력한다.
     * @param int 시작시간
     * @param int 종료시간
     * @param int default 값이 선택됨
     * @return String <option> 을 출력
     */
    public static String getDateOptions(int start, int end, int nDefault) {
        String result = "";

        for(int i = start ; i <= end ; i++) {
            if(i < 100) {
            	String temp = "";
            	temp = String.valueOf(i + 100);
            	temp = temp.substring(1);

                if(i == nDefault) {
                    result += "<option value='" +temp + "' selected> " + i;
                } else {
                    result += "<option value='" +temp + "'> " + i;
                }
            } else {
                if(i == nDefault) {
                    result += "<option value='" + i + "' selected> " + i;
                } else {
                    result += "<option value='" + i + "'> " + i;
                }
            }
            
            result += "</option>";
        }

        return result;
    }
    
    /**
     * 주어진 시간동안 아무일도 안한다.
     * @param int 1/1000 초
     */
    public static void sleep(int milisecond) throws Exception {
        if(milisecond > 0) {
            long endTime = System.currentTimeMillis() + milisecond;

            while(System.currentTimeMillis() < endTime);    // 주어진 초동안 아무일도 안한다.
        }
    }
}