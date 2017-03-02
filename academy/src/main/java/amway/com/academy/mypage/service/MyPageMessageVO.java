package amway.com.academy.mypage.service;

import java.util.HashMap;
import java.util.Map;

import framework.com.cmm.lib.RequestBox;
import framework.com.cmm.util.StringUtil;

public class MyPageMessageVO {
	private static final long serialVersionUID = -5483184827782226548L;
	
	/** 페이지 넘버 */ 
    private int page = 1;
    
    /** 레코드 번호 */ 
    private int rowPerPage = 1;
    
    /** 전체_건수 */ 
    private int totalCount = 0;
    
    /** 현재페이지 */
	private int pageIndex = 1;

	/** 페이지갯수 */
	private int pageUnit = 10;

	/** 페이지사이즈 */
	private int pageSize = 10;

	/** firstIndex */
	private int firstIndex = 1;

	/** lastIndex */
	private int lastIndex = 1;

	/** recordCountPerPage */
	private int recordCountPerPage = 10;
	
	/**
	 * 맞춤 메세지
	 * @return
	 */
	private String rn             ;
    private String gubun          ;
    private String notesendseq    ;
    private String noteservice    ;
    private String noteservicename;
    private String name           ;
    private String uid            ;
    private String noteitem       ;
    private String notecontent    ;
    private String senddate       ;
    private String sendtime       ;
    private String modifier       ;
    private String modifydate     ;
    private String registrant     ;
    private String registrantdate ;
    private String deleteyn       ;
    private String abono          ;
    private String schNoteservice ;
    private String schNotecontent ;
    private String checkAll       ;
	private String check1         ;
	private String check2         ;
	private String check3         ;
	private String check4         ;
	private String check5         ;
	private String schDt1         ;
	private String schDt2         ;
	private String year1          ;
	private String month1         ;
	private String day1           ;
	private String year2          ;
	private String month2         ;
	private String day2           ;
	private String serchList	  ;
    
	public String getCheck4() {
		return check4;
	}

	public void setCheck4(String check4) {
		this.check4 = check4;
	}

	public String getCheck5() {
		return check5;
	}

	public void setCheck5(String check5) {
		this.check5 = check5;
	}

	public String getYear1() {
		return year1;
	}

	public void setYear1(String year1) {
		this.year1 = year1;
	}

	public String getMonth1() {
		return month1;
	}

	public void setMonth1(String month1) {
		this.month1 = month1;
	}

	public String getDay1() {
		return day1;
	}

	public void setDay1(String day1) {
		this.day1 = day1;
	}

	public String getYear2() {
		return year2;
	}

	public void setYear2(String year2) {
		this.year2 = year2;
	}

	public String getMonth2() {
		return month2;
	}

	public void setMonth2(String month2) {
		this.month2 = month2;
	}

	public String getDay2() {
		return day2;
	}

	public void setDay2(String day2) {
		this.day2 = day2;
	}

	public String getSchDt1() {
		return schDt1;
	}

	public void setSchDt1(String schDt1) {
		this.schDt1 = schDt1;
	}

	public String getSchDt2() {
		return schDt2;
	}

	public void setSchDt2(String schDt2) {
		this.schDt2 = schDt2;
	}

	public String getSchNotecontent() {
		return schNotecontent;
	}

	public void setSchNotecontent(String schNotecontent) {
		this.schNotecontent = schNotecontent;
	}

	public String getCheckAll() {
		return checkAll;
	}

	public void setCheckAll(String checkAll) {
		this.checkAll = checkAll;
	}

	public String getCheck1() {
		return check1;
	}

	public void setCheck1(String check1) {
		this.check1 = check1;
	}

	public String getCheck2() {
		return check2;
	}

	public void setCheck2(String check2) {
		this.check2 = check2;
	}

	public String getCheck3() {
		return check3;
	}

	public void setCheck3(String check3) {
		this.check3 = check3;
	}

	public String getSchNoteservice() {
		return schNoteservice;
	}

	public void setSchNoteservice(String schNoteservice) {
		this.schNoteservice = schNoteservice;
	}

	public String getAbono() {
		return abono;
	}

	public void setAbono(String abono) {
		this.abono = abono;
	}

	public int getPageIndex() {
		return pageIndex;
	}

	public String getRn() {
		return rn;
	}

	public void setRn(String rn) {
		this.rn = rn;
	}

	public String getGubun() {
		return gubun;
	}

	public void setGubun(String gubun) {
		this.gubun = gubun;
	}

	public String getNotesendseq() {
		return notesendseq;
	}

	public void setNotesendseq(String notesendseq) {
		this.notesendseq = notesendseq;
	}

	public String getNoteservice() {
		return noteservice;
	}

	public void setNoteservice(String noteservice) {
		this.noteservice = noteservice;
	}

	public String getNoteservicename() {
		return noteservicename;
	}

	public void setNoteservicename(String noteservicename) {
		this.noteservicename = noteservicename;
	}

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

	public String getUid() {
		return uid;
	}

	public void setUid(String uid) {
		this.uid = uid;
	}

	public String getNoteitem() {
		return noteitem;
	}

	public void setNoteitem(String noteitem) {
		this.noteitem = noteitem;
	}

	public String getNotecontent() {
		return notecontent;
	}

	public void setNotecontent(String notecontent) {
		this.notecontent = notecontent;
	}

	public String getSenddate() {
		return senddate;
	}

	public void setSenddate(String senddate) {
		this.senddate = senddate;
	}

	public String getSendtime() {
		return sendtime;
	}

	public void setSendtime(String sendtime) {
		this.sendtime = sendtime;
	}

	public String getModifier() {
		return modifier;
	}

	public void setModifier(String modifier) {
		this.modifier = modifier;
	}

	public String getModifydate() {
		return modifydate;
	}

	public void setModifydate(String modifydate) {
		this.modifydate = modifydate;
	}

	public String getRegistrant() {
		return registrant;
	}

	public void setRegistrant(String registrant) {
		this.registrant = registrant;
	}

	public String getRegistrantdate() {
		return registrantdate;
	}

	public void setRegistrantdate(String registrantdate) {
		this.registrantdate = registrantdate;
	}

	public String getDeleteyn() {
		return deleteyn;
	}

	public void setDeleteyn(String deleteyn) {
		this.deleteyn = deleteyn;
	}

	public static long getSerialversionuid() {
		return serialVersionUID;
	}

	public void setPageIndex(int pageIndex) {
		this.pageIndex = pageIndex;
	}

	public int getPageUnit() {
		return pageUnit;
	}

	public void setPageUnit(int pageUnit) {
		this.pageUnit = pageUnit;
	}

	public int getPageSize() {
		return pageSize;
	}

	public void setPageSize(int pageSize) {
		this.pageSize = pageSize;
	}

	public int getFirstIndex() {
		return firstIndex;
	}

	public void setFirstIndex(int firstIndex) {
		this.firstIndex = firstIndex;
	}

	public int getLastIndex() {
		return lastIndex;
	}

	public void setLastIndex(int lastIndex) {
		this.lastIndex = lastIndex;
	}

	public int getRecordCountPerPage() {
		return recordCountPerPage;
	}

	public void setRecordCountPerPage(int recordCountPerPage) {
		this.recordCountPerPage = recordCountPerPage;
	}

	private String pageSortColumn = null;
    
    private String pageSortOrder = null;

	public String getSerchList() {
		return serchList;
	}

	public void setSerchList(String serchList) {
		this.serchList = serchList;
	}

	public MyPageMessageVO() {
    	// Do Nothing
	}
	
    public MyPageMessageVO(RequestBox requestBox) {
		// Page & RowNum
		if(requestBox.containsKey("sortIndex")) {
			this.setPage(requestBox.getInt("page"));
			this.setRowPerPage(requestBox.getInt("rowPerPage"));
		}
    }

	public int getPage() {
		if(this.page > getTotalCount()) {
            return getTotalCount();
        }
	        
		return page;
	}
	
	public void setPage(int page) {
		int num = 1;
		if(page < num) {
            this.page = 1;
        } else {
            this.page = page;
        }
	}
	
    public void setPage(String page) {
    	if("".equals(StringUtil.nvl(page, ""))) {
            this.page = 1;
        }
        
        try {
            this.page = Integer.parseInt(page);
        } catch(NumberFormatException nfe) {
        	throw new IllegalArgumentException(nfe);
        }
    }
    
    public void setPage(Object page) {
        setPage(String.valueOf(page));
    }

	public int getRowPerPage() {
		return rowPerPage < 1 ? 10 : rowPerPage;
	}

	public void setRowPerPage(int rowPerPage) {
		this.rowPerPage = rowPerPage;
	}
	
    public void setRowPerPage(String rowPerPage) {
    	if("".equals(StringUtil.nvl(rowPerPage, ""))) {
            this.rowPerPage = 1;
        }
        
        try {
            this.rowPerPage = Integer.parseInt(rowPerPage);
        } catch(NumberFormatException nfe) {
        	throw new IllegalArgumentException(nfe);
        }
    }
    
    public void setRowPerPage(Object page) {
    	setRowPerPage(String.valueOf(page));
    }

	public int getTotalCount() {
		return totalCount;
	}
	
	public void setTotalCount(int totalCount) {
		this.totalCount = totalCount;
	}
	public void setTotalCount(String totalCount) {
    	if("".equals(StringUtil.nvl(totalCount, ""))) {
            this.totalCount = 0;
        }
        
        try {
            this.totalCount = Integer.parseInt(totalCount);
        } catch(NumberFormatException nfe) {
        	throw new IllegalArgumentException(nfe);
        }
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
    
    public int getTotalPages() {
    	int iTotalPage = 1;
    	int num = 1;
    	int zeroNum = 0;
    	
        if(getTotalCount() < num) {
        	iTotalPage = 1;
        }
        
		if(getTotalCount() < num) {
			iTotalPage = 1;
		} else if(getTotalCount() >= num) {
			iTotalPage =  getTotalCount() / getRowPerPage();
			
			if( (getTotalCount() % getRowPerPage()) > zeroNum ) {
				iTotalPage = iTotalPage + 1; //나머지가 있다면 1증가 
			}
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
    	map.put("firstIndex", ((getPage() - 1) * getRowPerPage()) + 1 );
        
    	// 2. Order Paging Key
    	if (pageSortColumn != null && pageSortOrder != null) {
    		map.put("sortColumn", pageSortColumn);
    		map.put("sortOrder", pageSortOrder);
    	}
    	
    	return map;
    }
}