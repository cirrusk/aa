package framework.com.cmm.lib;

import java.lang.reflect.Array;
import java.util.Enumeration;
import java.util.HashMap;
import java.util.Map;
import java.util.Vector;

import javax.annotation.Resource;
import javax.servlet.http.HttpSession;

import egovframework.rte.fdl.property.EgovPropertyService;

public class RequestBox extends java.util.Hashtable<String, Object> {
    /**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	protected String name = null;

	@Resource(name = "propertiesService")
    protected EgovPropertyService propertiesService;

	/** 페이지 넘버 */ 
    private int page = 1;
    
    /** 레코드 번호 */ 
    private int rowPerPage = 1;
    
    /** 전체_건수 */ 
    private int totalCount = 0;
    
    private String pageSortColumn = null;
    
    private String pageSortOrder = null;

	/**
     * Hashtable 명을 설정한다.
     */
    public RequestBox(String name) {
        super();
        this.name = name;
    }

    /**
     * box 객체에 담긴 parameter value 의 String 타입을 얻는다.
     * @param key parameter key
     * @return String value 를 반환한다.
     */
    public String get(String key) {
        return getString(key);
    }
    
    /**
     * box 객체에 담긴 parameter value 의 String 타입을 얻는다.
     * @param key parameter key
     * @return String value 를 반환한다.
     */
    public Object getObject(String key) {
        return super.get(key);
    }

    /**
     * box 객체에 담긴 parameter value 의 boolean 타입을 얻는다.
     * @param key parameter key
     * @return boolean value 를 반환한다.
     */
    public boolean getBoolean(String key) {
        String value = getString(key);
        boolean isTrue = false;
        try {
            isTrue = (new Boolean(value)).booleanValue();
        }
        catch(Exception e){}
        return isTrue;
    }

    /**
     * box 객체에 담긴 parameter value 의 double 타입을 얻는다.
     * @param key parameter key
     * @return double value 를 반환한다.
     */
    public double getDouble(String key) {
        String value = removeComma(getString(key));
        if ( value.equals("") ) return 0;
        double num = 0;
        try {
            num = Double.valueOf(value).doubleValue();
        }
        catch(Exception e) {
            num = 0;
        }
        return num;
    }

    /**
     * box 객체에 담긴 parameter value 의 float 타입을 얻는다.
     * @param key parameter key
     * @return float value 를 반환한다.
     */
    public float getFloat(String key) {
        return (float)getDouble(key);
    }

    /**
     * box 객체에 담긴 parameter value 의 int 타입을 얻는다.
     * @param key parameter key
     * @return int value 를 반환한다.
     */
    public int getInt(String key) {
        double value = getDouble(key);
        return (int)value;
    }

    /**
     * box 객체에 담긴 parameter value 의 long 타입을 얻는다.
     * @param key parameter key
     * @return long value 를 반환한다.
     */
    public long getLong(String key) {
        String value = removeComma(getString(key));
        if ( value.equals("") ) return 0L;

        long lvalue = 0L;
        try {
            lvalue = Long.valueOf(value).longValue();
        }
        catch(Exception e) {
            lvalue = 0L;
        }
        return lvalue;
    }
    
    /**
     * box 객체에 담긴 parameter value 의 String 타입을 얻는다.
     * @param key parameter key
     * @return String value 를 반환한다.
     */
    @SuppressWarnings("unused")
    public String getString(String key) {
        String value = null;
        try {
            Object o = (Object)super.get(key);
            @SuppressWarnings("rawtypes")
            Class c = o.getClass();
            if ( o == null ) {
                value = "";
            } else if(c.isArray()) {
                int length = Array.getLength(o);
                if(length == 0)
                    value = "";
                else {
                    Object item = Array.get(o, 0);
                    if(item == null)
                        value = "";
                    else
                        value = item.toString();
                }
            } else {
                value = o.toString();
            }
        } catch(Exception e) {
            value = "";
        }

        return value;
    }
    
    /**
     * checkbox와 같이 동일한 key 에 value 를 여러개 선택하여 넘길 경우, 각 선택된 value의 list를 Vector에 담아 반환한다.
     * @param key parameter key
     * @return vector parameter values 를 담은 Vector 를 반환한다.
     */
    public Vector<Object> getVector(String key) {
        Vector<Object> vector = new Vector<Object>();
        try {
            Object o = (Object)super.get(key);
            @SuppressWarnings("rawtypes")
            Class c = o.getClass();
            if(o != null) {
                if(c.isArray()) {
                    int length = Array.getLength(o);
                    if(length != 0) {
                        for(int i = 0 ; i < length ; i++) {
                            Object tiem = Array.get(o, i);
                            if (tiem == null ) vector.addElement("");
                            else vector.addElement(tiem.toString());
                        }
                    }
                } else if(o instanceof Vector) {
                    @SuppressWarnings("unchecked")
                    Vector<Object> v = (Vector<Object>)o;

                    for(int i = 0 ; i < v.size() ; i++) {
                        vector.addElement((String)v.elementAt(i));
                    }
                } else {
                    vector.addElement(o.toString());
                }
            }
        } catch(Exception e) { }

        return vector;
    }
    
    /**
     * box 객체에 담긴 parameter value 의 String 타입을 얻는다.
     * key에 해당하는 값이 없으면 defstr을 반환한다.
     * @param key parameter key
     * @return String value 를 반환한다.
     */
    public String getStringDefault(String key, String defstr) {
        return (getString(key).equals("") ? defstr : getString(key));
    }
    
    private static String removeComma(String s) {
        if(s == null)
            return null;

        if(s.indexOf(",") != -1) {
            StringBuffer buf = new StringBuffer();
            for(int i = 0 ; i < s.length() ; i++) {
                char c = s.charAt(i);
                if ( c != ',')
                    buf.append(c);
            }

            return buf.toString();
        }

        return s;
    }

    /**
     * box 객체에 담겨져있는 모든 key, value 를 String 타입으로 반환한다.
     * @return String 모든 key, value 를 String 타입으로 반환한다.
     */
    @SuppressWarnings("rawtypes")
    public synchronized String toString() {
        int max = size() - 1;
        StringBuffer buf = new StringBuffer();
        Enumeration keys = keys();
        Enumeration objects = elements();
        buf.append("{");

        for(int i = 0 ; i <= max ; i++) {
            String key = keys.nextElement().toString();
            String value = null;
            Object o = objects.nextElement();

            if(o == null) {
                value = "";
            } else {
                Class c = o.getClass();
                if(c.isArray()) {
                    int length = Array.getLength(o);

                    if ( length == 0 )  {
                        value = "";
                    } else if(length == 1) {
                        Object item = Array.get(o, 0);
                        if(item == null)
                            value = "";
                        else
                            value = item.toString();
                    } else {
                        StringBuffer valueBuf = new StringBuffer();
                        valueBuf.append("[");

                        for(int j = 0 ; j < length ; j++) {
                            Object item = Array.get(o, j);
                            if(item != null)
                                valueBuf.append(item.toString());
                            if(j<length - 1)
                                valueBuf.append(",");
                        }

                        valueBuf.append("]");
                        value = valueBuf.toString();
                    }
                } else {
                    value = o.toString();
                }
            }

            buf.append(key + "=" + value);
            if(i < max)
                buf.append(", ");
        }

        buf.append("}");

        return "RequestBox[" + name + "]=" + buf.toString();
    }

    /**
     * box 객체에 담긴 session 객체를 반환한다.
     * @return session
     */
    public HttpSession getHttpSession() {
        HttpSession session = null;

        try {
            session = (HttpSession)super.get("session");
        } catch(Exception e) { }

        return session;
    }

    /**
     * String 타입의 세션변수을 저장한다.
     * @param key String
     * @param s_value String
     */
    public void setSession(String key, String s_value) {
        HttpSession session = this.getHttpSession();

        if(session != null) {
            session.setAttribute(key, s_value);
        }
    }

    /**
     * int 타입의 세션변수을 저장한다.
     * @param key String
     * @param s_value int
     */
    public void setSession(String key, int i_value) {
        HttpSession session = this.getHttpSession();

        if(session != null) {
            session.setAttribute(key, new Integer(i_value));
        }
    }

    /**
     * String 타입의 세션변수을 가지고온다.
     * @param key String
     * @return s_value String
     */
    public String getSession(String key) {
        HttpSession session = this.getHttpSession();
        String s_value = "" ;

        if(session != null) {
            Object obj = session.getAttribute(key);
            if(obj != null) {
                s_value = obj.toString();
            }
        }

        return s_value ;
    }

    /**
     * int 타입의 세션변수을 가지고온다.(해당값이 없을때 default 로 돌려줄 값을 파라메터로 넘겨받아야 한다.)
     * @param key String
     * @param defaultValue int
     * @return s_value int
     */
    public int getSession(String key, int defaultValue) {
        int i_value = defaultValue;
        String s_value = this.getSession(key);

        if(!s_value.equals("")) {
            try {
                i_value = Integer.parseInt(s_value);
            } catch(Exception ex) {
                i_value = defaultValue;
            }
        }

        return i_value;
    }

    /**
     * 세션id 를 얻는다.
     * @return sessionId String
     */
    public String getSessionId() {
        HttpSession session = this.getHttpSession();
        String sessionId = "" ;

        if(session != null) {
            sessionId = session.getId();
        }

        return sessionId;
    }

    /**
     * 현재 사용자가 세션을 가지고 있는지 여부. (세션변수에 userid 가 공백이 아닌지 여부로 판단.. )
     * @param key String userid
     * @return boolean userid 를 가지고 있으면 true 를 반환한다.
     */
    public boolean hasSession(String key) {
        return !getSession(key).equals("");
    }
    
//    public Map<String, Object> toMapData() {
//    	Map<String, Object> map = new HashMap<String, Object>();
//
//    	// 1. Basic Paging Key
//    	map.put("page", getPage());
//    	map.put("rowPerPage", getRowPerPage());
//    	map.put("totalPage", getTotalPages());
//    	map.put("totalCount", getTotalCount());
//    	map.put("firstIndex", ((getPage() - 1) * getRowPerPage() ) + 1 );
//        
//    	// 2. Order Paging Key
//    	if (pageSortColumn != null && pageSortOrder != null) {
//    		map.put("sortColumn", pageSortColumn);
//    		map.put("sortOrder", pageSortOrder);
//    	}
//    	
//    	return map;
//    }
    public int getPage() {
		if(this.page > getTotalCount()){
            return getTotalCount();
        }
	        
		return page;
	}
	public void setPage(int page) {
		if(page < 1){
            this.page = 1;
        } else {
            this.page = page;
        }
	}
    public void setPage(Object page){
        setPage(String.valueOf(page));
    }

	public int getRowPerPage() {
		return rowPerPage < 1 ? 10 : rowPerPage;
	}


	public void setRowPerPage(int rowPerPage) {
		this.rowPerPage = rowPerPage;
	}
    public void setRowPerPage(Object page){
    	setRowPerPage(String.valueOf(page));
    }


	public int getTotalCount() {
		return totalCount;
	}
	public void setTotalCount(int totalCount) {
		this.totalCount = totalCount;
	}

	public String getPageSortColumn() {
		return pageSortColumn;
	}
	public void setPageSortColumn(String pageSortColumn) {
		this.pageSortColumn = pageSortColumn;
	}

	public String getPageSortOrder() {
		return pageSortOrder;
	}
	public void setPageSortOrder(String pageSortOrder) {
		this.pageSortOrder = pageSortOrder;
	}
    

    public int getTotalPages(){
    	int iTotalPage = 1;
        if(getTotalCount() < 1){
        	iTotalPage = 1;
        }
		if(getTotalCount() < 1){
			iTotalPage = 1;
		} else if(getTotalCount() >= 1){
			iTotalPage =  (getTotalCount() / getRowPerPage()) + 1;
		} 
    
        return iTotalPage;
    }
    
    public Map<String, Object> toMapData() {
    	Map<String, Object> map = new HashMap<String, Object>();

    	// 1. Basic Paging Key
    	map.put("page", getPage());
    	map.put("rowPerPage", getRowPerPage());
    	map.put("totalPage", getTotalPages());
    	map.put("totalCount", getTotalCount());
    	map.put("firstIndex", ((getPage() - 1) * getRowPerPage() ) + 1 );
        
    	// 2. Order Paging Key
    	if (pageSortColumn != null && pageSortOrder != null) {
    		map.put("sortColumn", pageSortColumn);
    		map.put("sortOrder", pageSortOrder);
    	}
    	
    	return map;
    }
}