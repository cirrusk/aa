var curPage = 1;  // 첫 페이지 지정

// 페이지 수만큼 생성 (N:일반 페이지, V:동영상페이지, A:오디오페이지)

var navi_page = new Array();
	navi_page[0]  = 'N';
	navi_page[1]  = 'N';
	navi_page[2]  = 'N';
	navi_page[3]  = 'N';
	navi_page[4]  = 'A';
	navi_page[5]  = 'V';
	navi_page[6]  = 'A';
	navi_page[7]  = 'A';
	navi_page[8]  = 'A';
	navi_page[9]  = 'A';
	navi_page[10] = 'A';
	navi_page[11] = 'A';
	navi_page[12] = 'A';
	navi_page[13] = 'V';
	navi_page[14] = 'V';
	navi_page[15] = 'V';
	navi_page[16] = 'V';
	navi_page[17] = 'V';
	navi_page[18] = 'N';
	navi_page[19] = 'N';
	navi_page[20] = 'N';
	navi_page[21] = 'N';
	navi_page[22] = 'N';

var navi_linkfile = new Array();
	navi_linkfile[0]  = 'http://mvod.artistry.smartucc.kr/encodeFile/73/2014/02/26/3648c3756e183ea50f4fbcfd919bf3d7_M.mp3';
	navi_linkfile[1]  = 'http://mvod.artistry.smartucc.kr/encodeFile/73/2014/02/26/306f2e1a0b5d413ce79a4de3285ec647_M.mp3';
	navi_linkfile[2]  = 'http://mvod.artistry.smartucc.kr/encodeFile/73/2014/02/26/8b3e3580588efa04b31a74837d81a021_M.mp3';
	navi_linkfile[3]  = 'http://mvod.artistry.smartucc.kr/encodeFile/73/2014/02/26/a726ab53ae8e04ad372aacd84bf81e6f_M.mp3';
	navi_linkfile[4]  = 'http://mvod.artistry.smartucc.kr/encodeFile/73/2014/02/26/3ceca1f49e4eccc9e60a441257c4aa8b_M.mp3';
	navi_linkfile[5]  = 'http://mvod.artistry.smartucc.kr/encodeFile/73/2014/02/26/8c8167b28128f506e6eb67d38050b9e1_W.mp4';
	navi_linkfile[6]  = 'http://mvod.artistry.smartucc.kr/encodeFile/73/2014/02/26/f44b505c56528c5090cff4d523fbd5a5_M.mp3';
	navi_linkfile[7]  = 'http://mvod.artistry.smartucc.kr/encodeFile/73/2014/02/26/7dcf29215ce4032b4ffd8e13a028d5c9_M.mp3';
	navi_linkfile[8]  = 'http://mvod.artistry.smartucc.kr/encodeFile/73/2014/02/26/109ccdfd3516276f6b3bf6a9d75d1973_M.mp3';
	navi_linkfile[9]  = 'http://mvod.artistry.smartucc.kr/encodeFile/73/2014/02/26/edfb243ff758948f44828bde0d1841e6_M.mp3';
	navi_linkfile[10] = 'http://mvod.artistry.smartucc.kr/encodeFile/73/2014/02/26/63f6fa2ad5f777b61d58b3510f112529_M.mp3';
	navi_linkfile[11] = 'http://mvod.artistry.smartucc.kr/encodeFile/73/2014/02/26/ba767f7dedb36cef4bda1b0f56e9c892_M.mp3';
	navi_linkfile[12] = 'http://mvod.artistry.smartucc.kr/encodeFile/73/2014/02/26/e93a44abb59f3bbd42551ea5eb6ef206_M.mp3';
	navi_linkfile[13] = 'http://mvod.artistry.smartucc.kr/encodeFile/73/2014/02/26/79eab9a7ac5b6b3c15095ac34d6c0a13_W.mp4';
	navi_linkfile[14] = 'http://mvod.artistry.smartucc.kr/encodeFile/73/2014/02/26/707b6f46e8cea097504ee3f73ef33bcd_W.mp4';
	navi_linkfile[15] = 'http://mvod.artistry.smartucc.kr/encodeFile/73/2014/02/26/f7902daf2b77a4b22a573b7ba3f83c61_W.mp4';
	navi_linkfile[16] = 'http://mvod.artistry.smartucc.kr/encodeFile/73/2014/02/26/9bc2b0e320b96efc05608e59ec717961_W.mp4';
	navi_linkfile[17] = 'http://mvod.artistry.smartucc.kr/encodeFile/73/2014/02/26/e0bfc7c003761e72f8208fc10d81851c_W.mp4';
	navi_linkfile[18] = 'http://mvod.artistry.smartucc.kr/encodeFile/73/2014/02/26/2b84032b24246cd084a455c0d5b34563_M.mp3';
	navi_linkfile[19] = 'http://mvod.artistry.smartucc.kr/encodeFile/73/2014/02/26/e261468a46e057e69342ef30f97baf43_M.mp3';
	navi_linkfile[20] = 'http://mvod.artistry.smartucc.kr/encodeFile/73/2014/02/26/bc9b4996699f8cb94de1303f5952117d_M.mp3';
	navi_linkfile[21] = 'http://mvod.artistry.smartucc.kr/encodeFile/73/2014/02/26/7fcb44696f62ff3864958437803f3a11_M.mp3';
	navi_linkfile[22] = 'http://mvod.artistry.smartucc.kr/encodeFile/73/2014/02/26/04f09fe1febd0bf47dab6aa3321500de_M.mp3';