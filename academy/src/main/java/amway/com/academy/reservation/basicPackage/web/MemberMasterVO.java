package amway.com.academy.reservation.basicPackage.web;

import java.util.Map;

public class MemberMasterVO {
	
	private String memberNumber;
	
	private String aboNo;
	
	private String pinNumber;
	
	private String regionCode;
	
	private String age;
	
	private String cookingMaster;
	
	private int globalDailyReservationCount;
	
	private int globalWeeklyReservationCount;
	
	private int globalMonthlyReservationCount;
	
	private Map<String, Integer> ppDailyReservationCount;
	
	private Map<String, Integer> ppWeeklyReservationCount;
	
	private Map<String, Integer> ppMonthlyReservationCount;

	
	/** getter setter area */
	
	
	public String getMemberNumber() {
		return memberNumber;
	}

	public void setMemberNumber(String memberNumber) {
		this.memberNumber = memberNumber;
	}

	public String getAboNo() {
		return aboNo;
	}

	public void setAboNo(String aboNo) {
		this.aboNo = aboNo;
	}

	public String getPinNumber() {
		return pinNumber;
	}

	public void setPinNumber(String pinNumber) {
		this.pinNumber = pinNumber;
	}

	public String getRegionCode() {
		return regionCode;
	}

	public void setRegionCode(String regionCode) {
		this.regionCode = regionCode;
	}

	public String getAge() {
		return age;
	}

	public void setAge(String age) {
		this.age = age;
	}

	public String getCookingMaster() {
		return cookingMaster;
	}

	public void setCookingMaster(String cookingMaster) {
		this.cookingMaster = cookingMaster;
	}

	public int getGlobalDailyReservationCount() {
		return globalDailyReservationCount;
	}

	public void setGlobalDailyReservationCount(int globalDailyReservationCount) {
		this.globalDailyReservationCount = globalDailyReservationCount;
	}

	public int getGlobalWeeklyReservationCount() {
		return globalWeeklyReservationCount;
	}

	public void setGlobalWeeklyReservationCount(int globalWeeklyReservationCount) {
		this.globalWeeklyReservationCount = globalWeeklyReservationCount;
	}

	public int getGlobalMonthlyReservationCount() {
		return globalMonthlyReservationCount;
	}

	public void setGlobalMonthlyReservationCount(int globalMonthlyReservationCount) {
		this.globalMonthlyReservationCount = globalMonthlyReservationCount;
	}

	public Map<String, Integer> getPpDailyReservationCount() {
		return ppDailyReservationCount;
	}

	public void setPpDailyReservationCount(Map<String, Integer> ppDailyReservationCount) {
		this.ppDailyReservationCount = ppDailyReservationCount;
	}

	public Map<String, Integer> getPpWeeklyReservationCount() {
		return ppWeeklyReservationCount;
	}

	public void setPpWeeklyReservationCount(Map<String, Integer> ppWeeklyReservationCount) {
		this.ppWeeklyReservationCount = ppWeeklyReservationCount;
	}

	public Map<String, Integer> getPpMonthlyReservationCount() {
		return ppMonthlyReservationCount;
	}

	public void setPpMonthlyReservationCount(Map<String, Integer> ppMonthlyReservationCount) {
		this.ppMonthlyReservationCount = ppMonthlyReservationCount;
	}
}
