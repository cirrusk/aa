package com._4csoft.aof.support.util;

import java.security.InvalidKeyException;

public class StaticEncEngine {
	private String sKey = "";

	private final int byteLength = 256;
	private final int keyLength = (byteLength / 8);
	private final int encMaxLength = 16;

	private static StaticEncEngine instance = null;
	private ARIAEngine engine = null;
	private byte[] mkKey = null;

	StaticEncEngine(String key) throws InvalidKeyException {
		sKey = key;
		engine = new ARIAEngine(byteLength);

		// Key Setting
		byte[] encKey = sKey.getBytes();
		int len = encKey.length;

		mkKey = new byte[keyLength];

		if (len > keyLength)
			len = keyLength;

		for (int inx = 0; inx < len; inx++) {
			mkKey[inx] = encKey[inx];
		}

		for (int inx = len; inx < keyLength; inx++) {
			mkKey[inx] = 0x00;
		}

		engine.setKey(mkKey);
		engine.setupRoundKeys();
	}

	public static StaticEncEngine getInstance(String key) throws Exception {
		if (instance == null) {
			instance = new StaticEncEngine(key);
		}

		return instance;
	}

	/**
	 * Encryption
	 * 
	 * @param inData
	 * @return
	 * @throws InvalidKeyException
	 */
	public String setEnc(String inData) throws Exception {
		String rtn = "";

		if (inData == null || inData.equals("")) {
			return rtn;
		}

		byte[] bIn = inData.getBytes();

		int iRoop = bIn.length / encMaxLength;
		int iMod = bIn.length % encMaxLength;
		if (iMod > 0)
			iRoop++;

		int encSize = iRoop * encMaxLength;

		byte[] encByte = new byte[encSize];

		if (iMod > 0) {
			for (int inx = 0; inx < encSize; inx++) {
				if (bIn.length > inx) {
					encByte[inx] = bIn[inx];
				} else {
					encByte[inx] = 0x00;
				}
			}
		}

		int iWhile = 0;
		int inCount = 0;

		while (iWhile < iRoop) {
			byte[] encTemp = new byte[encMaxLength];

			for (int inx = 0; inx < encMaxLength; inx++) {
				encTemp[inx] = encByte[inCount];
				inCount++;
			}

			byte[] result = null;

			result = engine.encrypt(encTemp, 0);

			rtn = rtn + byteToString(result);

			iWhile++;
		}

		return rtn;
	}

	/**
	 * Decryption
	 * 
	 * @param outData
	 * @return
	 * @throws InvalidKeyException
	 */
	public String getEnc(String outData) throws Exception {
		String rtn = "";

		if (outData == null || outData.equals("")) {
			return rtn;
		}

		byte[] decByte = null;

		decByte = StringTobyte(outData);

		int iRoop = decByte.length / encMaxLength;
		int iWhile = 0;
		int inCount = 0;

		while (iWhile < iRoop) {
			byte[] decTemp = new byte[encMaxLength];

			for (int inx = 0; inx < encMaxLength; inx++) {
				decTemp[inx] = decByte[inCount];
				inCount++;
			}

			byte[] result = null;
			result = engine.decrypt(decTemp, 0);

			rtn = rtn + new String(result).trim();

			iWhile++;
		}

		return rtn;
	}

	private String byteToString(byte[] a, int off, int len) {
		String hret = "";

		for (int i = 0; i < len; i++) {
			int hi = (a[off + i] >>> 4) & 0x0f;
			int lo = (a[off + i]) & 0x0f;

			hret = hret + Integer.toString(hi, 16) + Integer.toString(lo, 16);
		}

		return hret;
	}

	private String byteToString(byte[] a) {
		return byteToString(a, 0, a.length);
	}

	private byte[] StringTobyte(String src) throws NumberFormatException {
		String srcChg = src;

		int bLen = (src.length() / 2);

		byte btmp[] = new byte[bLen];

		int i = 0;

		while (i < bLen) {
			String srcSub = "0x" + srcChg.substring(0, 2);

			Integer srcInt = Integer.decode(srcSub);
			btmp[i] = srcInt.byteValue();

			srcChg = srcChg.substring(2);

			if (srcChg.length() == 0)
				break;

			i++;
		}

		return btmp;
	}
}
