﻿CREATE DATABASE QuanLyGiaoVu;
USE QuanLyGiaoVu;

CREATE TABLE KHOA 
(
	MAKHOA VARCHAR(4),
	TENKHOA VARCHAR(40),
	NGTLAP SMALLDATETIME,
	TRGKHOA CHAR(4)
	CONSTRAINT PK_KHOA PRIMARY KEY (MAKHOA)
);

CREATE TABLE MONHOC
(
	MAMH VARCHAR(10),
	TENMH VARCHAR(40),
	TCLT TINYINT,
	TCTH TINYINT,
	MAKHOA VARCHAR(4),
	CONSTRAINT PK_MONHOC PRIMARY KEY (MAMH),
);

CREATE TABLE DIEUKIEN
(
	MAMH VARCHAR(10),
	MAMH_TRUOC VARCHAR(10),
	CONSTRAINT PK_DIEUKIEN PRIMARY KEY (MAMH, MAMH_TRUOC)
)

CREATE TABLE GIAOVIEN
(
	MAGV CHAR(4),
	HOTEN VARCHAR(40),
	HOCVI VARCHAR(10),
	HOCHAM VARCHAR(10),
	GIOITINH VARCHAR(3),
	NGSINH SMALLDATETIME,
	NGVL SMALLDATETIME,
	HESO NUMERIC(4,2),
	MUCLUONG MONEY,
	MAKHOA VARCHAR(4)
	CONSTRAINT PK_GIAOVIEN PRIMARY KEY (MAGV)
);

CREATE TABLE HOCVIEN
(
	MAHV CHAR(5),
	HO VARCHAR(40),
	TEN VARCHAR(10),
	NGSINH SMALLDATETIME,
	GIOITINH VARCHAR(3),
	NOISINH VARCHAR(40),
	MALOP CHAR(3),
	CONSTRAINT PK_HOCVIEN PRIMARY KEY (MAHV)
);

CREATE TABLE LOP
(
	MALOP CHAR(3),
	TENLOP VARCHAR(40),
	TRGLOP CHAR(5),
	SISO TINYINT,
	MAGVCN CHAR(4)
	CONSTRAINT PK_LOP PRIMARY KEY (MALOP)
);

CREATE TABLE GIANGDAY
(
	MALOP CHAR(3),
	MAMH VARCHAR(10),
	MAGV CHAR(4),
	HOCKY TINYINT,
	NAM SMALLINT,
	TUNGAY SMALLDATETIME,
	DENNGAY SMALLDATETIME
	CONSTRAINT PK_GIANGDAY PRIMARY KEY (MALOP, MAMH),
);

CREATE TABLE KETQUATHI
(
	MAHV CHAR(5),
	MAMH VARCHAR(10),
	LANTHI TINYINT,
	NGTHI SMALLDATETIME,
	DIEM NUMERIC(4,2),
	KQUA VARCHAR(10)
	CONSTRAINT PK_KETQUATHI PRIMARY KEY (MAHV, MAMH, LANTHI)
);

insert into KHOA values('KHMT','Khoa hoc may tinh','6/7/2005','GV01')
insert into KHOA values('HTTT','He thong thong tin','6/7/2005','GV02')
insert into KHOA values('CNPM','Cong nghe phan mem','6/7/2005','GV04')
insert into KHOA values('MTT','Mang va truyen thong','10/20/2005','GV03')
insert into KHOA values('KTMT','Ky thuat may tinh','12/20/2005','')

insert into GIAOVIEN values('GV01','Ho Thanh Son','PTS','GS','Nam','5/2/1950','1/11/2004',5.00,2250000,'KHMT')
insert into GIAOVIEN values('GV02','Tran Tam Thanh','TS','PGS','Nam','12/17/1965','4/20/2004',4.50,2025000,'HTTT')
insert into GIAOVIEN values('GV03','Do Nghiem Phung','TS','GS','Nu','8/1/1950','9/23/2004',4.00,1800000,'CNPM')
insert into GIAOVIEN values('GV04','Tran Nam Son','TS','PGS','Nam','2/22/1961','1/12/2005',4.50,2025000,'KTMT')
insert into GIAOVIEN values('GV05','Mai Thanh Danh','ThS','GV','Nam','3/12/1958','1/12/2005',3.00,1350000,'HTTT')
insert into GIAOVIEN values('GV06','Tran Doan Hung','TS','GV','Nam','3/11/1953','1/12/2005',4.50,2025000,'KHMT')
insert into GIAOVIEN values('GV07','Nguyen Minh Tien','ThS','GV','Nam','11/23/1971','3/1/2005',4.00,1800000,'KHMT')
insert into GIAOVIEN values('GV08','Le Thi Tran','KS','','Nu','3/26/1974','3/1/2005',1.69,760500,'KHMT')
insert into GIAOVIEN values('GV09','Nguyen To Lan','ThS','GV','Nu','12/31/1966','3/1/2005',4.00,1800000,'HTTT')
insert into GIAOVIEN values('GV10','Le Tran Anh Loan','KS','','Nu','7/17/1972','3/1/2005',1.86,837000,'CNPM')
insert into GIAOVIEN values('GV11','Ho Thanh Tung','CN','GV','Nam','1/12/1980','5/15/2005',2.67,1201500,'MTT')
insert into GIAOVIEN values('GV12','Tran Van Anh','CN','','Nu','3/29/1981','5/15/2005',1.69,760500,'CNPM')
insert into GIAOVIEN values('GV13','Nguyen Linh Dan','CN','','Nu','5/23/1980','5/15/2005',1.69,760500,'KTMT')
insert into GIAOVIEN values('GV14','Truong Minh Chau','ThS','GV','Nu','11/30/1976','5/15/2005',3.00,1350000,'MTT')
insert into GIAOVIEN values('GV15','Le Ha Thanh','ThS','GV','Nam','5/4/1978','5/15/2005',3.00,1350000,'KHMT')
 
insert into MONHOC values('THDC','Tin hoc dai cuong',4,1,'KHMT')
insert into MONHOC values('CTRR','Cau truc roi rac',5,0,'KHMT')
insert into MONHOC values('CSDL','Co so du lieu',3,1,'HTTT')
insert into MONHOC values('CTDLGT','Cau truc du lieu va giai thuat',3,1,'KHMT')
insert into MONHOC values('PTTKTT','Phan tich thiet ke thuat toan',3,0,'KHMT')
insert into MONHOC values('DHMT','Do hoa may tinh',3,1,'KHMT')
insert into MONHOC values('KTMT','Kien truc may tinh',3,0,'KTMT')
insert into MONHOC values('TKCSDL','Thiet ke co so du lieu',3,1,'HTTT')
insert into MONHOC values('PTTKHTTT','Phan tich thiet ke he thong thong tin',4,1,'HTTT')
insert into MONHOC values('HDH','He dieu hanh',4,0,'KTMT')
insert into MONHOC values('NMCNPM','Nhap mon cong nghe phan mem',3,0,'CNPM')
insert into MONHOC values('LTCFW','Lap trinh C for win',3,1,'CNPM')
insert into MONHOC values('LTHDT','Lap trinh huong doi tuong',3,1,'CNPM')

insert into LOP values('K11','Lop 1 khoa 1','K1108',11,'GV07')
insert into LOP values('K12','Lop 2 khoa 1','K1205',12,'GV09')
insert into LOP values('K13','Lop 3 khoa 1','K1305',12,'GV14')

insert into HOCVIEN values('K1101','Nguyen Van','A','1/27/1986','Nam','TpHCM','K11')
insert into HOCVIEN values('K1102','Tran Ngoc','Han','3/1/1986','Nu','Kien Giang','K11')
insert into HOCVIEN values('K1103','Ha Duy','Lap','4/18/1986','Nam','Nghe An','K11')
insert into HOCVIEN values('K1104','Tran Ngoc','Linh','3/30/1986','Nu','Tay Ninh','K11')
insert into HOCVIEN values('K1105','Tran Minh','Long','2/27/1986','Nam','TpHCM','K11')
insert into HOCVIEN values('K1106','Le Nhat','Minh','1/24/1986','Nam','TpHCM','K11')
insert into HOCVIEN values('K1107','Nguyen Nhu','Nhut','1/27/1986','Nam','Ha Noi','K11')
insert into HOCVIEN values('K1108','Nguyen Manh','Tam','2/27/1986','Nam','Kien Giang','K11')
insert into HOCVIEN values('K1109','Phan Thi Thanh','Tam','1/27/1986','Nu','Vinh Long','K11')
insert into HOCVIEN values('K1110','Le Hoai','Thuong','2/5/1986','Nu','Can Tho','K11')
insert into HOCVIEN values('K1111','Le Ha','Vinh','12/25/1986','Nam','Vinh Long','K11')
insert into HOCVIEN values('K1201','Nguyen Van','B','2/11/1986','Nam','TpHCM','K12')
insert into HOCVIEN values('K1202','Nguyen Thi Kim','Duyen','1/18/1986','Nu','TpHCM','K12')
insert into HOCVIEN values('K1203','Tran Thi Kim','Duyen','9/17/1986','Nu','TpHCM','K12')
insert into HOCVIEN values('K1204','Truong My','Hanh','5/19/1986','Nu','Dong Nai','K12')
insert into HOCVIEN values('K1205','Nguyen Thanh','Nam','4/17/1986','Nam','TpHCM','K12')
insert into HOCVIEN values('K1206','Nguyen Thi Truc','Thanh','3/4/1986','Nu','Kien Giang','K12')
insert into HOCVIEN values('K1207','Tran Thi Bich','Thuy','2/8/1986','Nu','Nghe An','K12')
insert into HOCVIEN values('K1208','Huynh Thi Kim','Trieu','4/8/1986','Nu','Tay Ninh','K12')
insert into HOCVIEN values('K1209','Pham Thanh','Trieu','2/23/1986','Nam','TpHCM','K12')
insert into HOCVIEN values('K1210','Ngo Thanh','Tuan','2/14/1986','Nam','TpHCM','K12')
insert into HOCVIEN values('K1211','Do Thi','Xuan','3/9/1986','Nu','Ha Noi','K12')
insert into HOCVIEN values('K1212','Le Thi Phi','Yen','3/12/1986','Nu','TpHCM','K12')
insert into HOCVIEN values('K1301','Nguyen Thi Kim','Cuc','6/9/1986','Nu','Kien Giang','K13')
insert into HOCVIEN values('K1302','Truong Thi My','Hien','3/18/1986','Nu','Nghe An','K13')
insert into HOCVIEN values('K1303','Le Duc','Hien','3/12/1986','Nam','Tay Ninh','K13')
insert into HOCVIEN values('K1304','Le Quang','Hien','4/18/1986','Nam','TpHCM','K13')
insert into HOCVIEN values('K1305','Le Thi','Huong','3/27/1986','Nu','TpHCM','K13')
insert into HOCVIEN values('K1306','Nguyen Thai','Huu','3/30/1986','Nam','Ha Noi','K13')
insert into HOCVIEN values('K1307','Tran Minh','Man','5/28/1986','Nam','TpHCM','K13')
insert into HOCVIEN values('K1308','Nguyen Hieu','Nghia','4/8/1986','Nam','Kien Giang','K13')
insert into HOCVIEN values('K1309','Nguyen Trung','Nghia','1/18/1987','Nam','Nghe An','K13')
insert into HOCVIEN values('K1310','Tran Thi Hong','Tham','4/22/1986','Nu','Tay Ninh','K13')
insert into HOCVIEN values('K1311','Tran Minh','Thuc','4/4/1986','Nam','TpHCM','K13')
insert into HOCVIEN values('K1312','Nguyen Thi Kim','Yen','9/7/1986','Nu','TpHCM','K13')

insert into GIANGDAY values('K11','THDC','GV07',1,2006,'1/2/2006','5/12/2006')
insert into GIANGDAY values('K12','THDC','GV06',1,2006,'1/2/2006','5/12/2006')
insert into GIANGDAY values('K13','THDC','GV15',1,2006,'1/2/2006','5/12/2006')
insert into GIANGDAY values('K11','CTRR','GV02',1,2006,'1/9/2006','5/17/2006')
insert into GIANGDAY values('K12','CTRR','GV02',1,2006,'1/9/2006','5/17/2006')
insert into GIANGDAY values('K13','CTRR','GV08',1,2006,'1/9/2006','5/17/2006')
insert into GIANGDAY values('K11','CSDL','GV05',2,2006,'6/1/2006','7/15/2006')
insert into GIANGDAY values('K12','CSDL','GV09',2,2006,'6/1/2006','7/15/2006')
insert into GIANGDAY values('K13','CTDLGT','GV15',2,2006,'6/1/2006','7/15/2006')
insert into GIANGDAY values('K13','CSDL','GV05',3,2006,'8/1/2006','12/15/2006')
insert into GIANGDAY values('K13','DHMT','GV07',3,2006,'8/1/2006','12/15/2006')
insert into GIANGDAY values('K11','CTDLGT','GV15',3,2006,'8/1/2006','12/15/2006')
insert into GIANGDAY values('K12','CTDLGT','GV15',3,2006,'8/1/2006','12/15/2006')
insert into GIANGDAY values('K11','HDH','GV04',1,2007,'1/2/2007','2/18/2007')
insert into GIANGDAY values('K12','HDH','GV04',1,2007,'1/2/2007','3/20/2007')
insert into GIANGDAY values('K11','DHMT','GV07',1,2007,'2/18/2007','3/20/2007')

insert into DIEUKIEN values('CSDL','CTRR')
insert into DIEUKIEN values('CSDL','CTDLGT')
insert into DIEUKIEN values('CTDLGT','THDC')
insert into DIEUKIEN values('PTTKTT','THDC')
insert into DIEUKIEN values('PTTKTT','CTDLGT')
insert into DIEUKIEN values('DHMT','THDC')
insert into DIEUKIEN values('LTHDT','THDC')
insert into DIEUKIEN values('PTTKHTTT','CSDL')

insert into KETQUATHI values('K1101','CSDL',1,'7/20/2006',10.00,'Dat')
insert into KETQUATHI values('K1101','CTDLGT',1,'12/28/2006',9.00,'Dat')
insert into KETQUATHI values('K1101','THDC',1,'5/20/2006',9.00,'Dat')
insert into KETQUATHI values('K1101','CTRR',1,'5/13/2006',9.50,'Dat')
insert into KETQUATHI values('K1102','CSDL',1,'7/20/2006',4.00,'Khong Dat')
insert into KETQUATHI values('K1102','CSDL',2,'7/27/2006',4.25,'Khong Dat')
insert into KETQUATHI values('K1102','CSDL',3,'8/10/2006',4.50,'Khong Dat')
insert into KETQUATHI values('K1102','CTDLGT',1,'12/28/2006',4.50,'Khong Dat')
insert into KETQUATHI values('K1102','CTDLGT',2,'1/5/2007',4.00,'Khong Dat')
insert into KETQUATHI values('K1102','CTDLGT',3,'1/15/2007',6.00,'Dat')
insert into KETQUATHI values('K1102','THDC',1,'5/20/2006',5.00,'Dat')
insert into KETQUATHI values('K1102','CTRR',1,'5/13/2006',7.00,'Dat')
insert into KETQUATHI values('K1103','CSDL',1,'7/20/2006',3.50,'Khong Dat')
insert into KETQUATHI values('K1103','CSDL',2,'7/27/2006',8.25,'Dat')
insert into KETQUATHI values('K1103','CTDLGT',1,'12/28/2006',7.00,'Dat')
insert into KETQUATHI values('K1103','THDC',1,'5/20/2006',8.00,'Dat')
insert into KETQUATHI values('K1103','CTRR',1,'5/13/2006',6.50,'Dat')
insert into KETQUATHI values('K1104','CSDL',1,'7/20/2006',3.75,'Khong Dat')
insert into KETQUATHI values('K1104','CTDLGT',1,'12/28/2006',4.00,'Khong Dat')
insert into KETQUATHI values('K1104','THDC',1,'5/20/2006',4.00,'Khong Dat')
insert into KETQUATHI values('K1104','CTRR',1,'5/13/2006',4.00,'Khong Dat')
insert into KETQUATHI values('K1104','CTRR',2,'5/20/2006',3.50,'Khong Dat')
insert into KETQUATHI values('K1104','CTRR',3,'6/30/2006',4.00,'Khong Dat')
insert into KETQUATHI values('K1201','CSDL',1,'7/20/2006',6.00,'Dat')
insert into KETQUATHI values('K1201','CTDLGT',1,'12/28/2006',5.00,'Dat')
insert into KETQUATHI values('K1201','THDC',1,'5/20/2006',8.50,'Dat')
insert into KETQUATHI values('K1201','CTRR',1,'5/13/2006',9.00,'Dat')
insert into KETQUATHI values('K1202','CSDL',1,'7/20/2006',8.00,'Dat')
insert into KETQUATHI values('K1202','CTDLGT',1,'12/28/2006',4.00,'Khong Dat')
insert into KETQUATHI values('K1202','CTDLGT',2,'1/5/2007',5.00,'Dat')
insert into KETQUATHI values('K1202','THDC',1,'5/20/2006',4.00,'Khong Dat')
insert into KETQUATHI values('K1202','THDC',2,'5/27/2006',4.00,'Khong Dat')
insert into KETQUATHI values('K1202','CTRR',1,'5/13/2006',3.00,'Khong Dat')
insert into KETQUATHI values('K1202','CTRR',2,'5/20/2006',4.00,'Khong Dat')
insert into KETQUATHI values('K1202','CTRR',3,'6/30/2006',6.25,'Dat')
insert into KETQUATHI values('K1203','CSDL',1,'7/20/2006',9.25,'Dat')
insert into KETQUATHI values('K1203','CTDLGT',1,'12/28/2006',9.50,'Dat')
insert into KETQUATHI values('K1203','THDC',1,'5/20/2006',10.00,'Dat')
insert into KETQUATHI values('K1203','CTRR',1,'5/13/2006',10.00,'Dat')
insert into KETQUATHI values('K1204','CSDL',1,'7/20/2006',8.50,'Dat')
insert into KETQUATHI values('K1204','CTDLGT',1,'12/28/2006',6.75,'Dat')
insert into KETQUATHI values('K1204','THDC',1,'5/20/2006',4.00,'Khong Dat')
insert into KETQUATHI values('K1204','CTRR',1,'5/13/2006',6.00,'Dat')
insert into KETQUATHI values('K1301','CSDL',1,'12/20/2006',4.25,'Khong Dat')
insert into KETQUATHI values('K1301','CTDLGT',1,'7/25/2006',8.00,'Dat')
insert into KETQUATHI values('K1301','THDC',1,'5/20/2006',7.75,'Dat')
insert into KETQUATHI values('K1301','CTRR',1,'5/13/2006',8.00,'Dat')
insert into KETQUATHI values('K1302','CSDL',1,'12/20/2006',6.75,'Dat')
insert into KETQUATHI values('K1302','CTDLGT',1,'7/25/2006',5.00,'Dat')
insert into KETQUATHI values('K1302','THDC',1,'5/20/2006',8.00,'Dat')
insert into KETQUATHI values('K1302','CTRR',1,'5/13/2006',8.50,'Dat')
insert into KETQUATHI values('K1303','CSDL',1,'12/20/2006',4.00,'Khong Dat')
insert into KETQUATHI values('K1303','CTDLGT',1,'7/25/2006',4.50,'Khong Dat')
insert into KETQUATHI values('K1303','CTDLGT',2,'8/7/2006',4.00,'Khong Dat')
insert into KETQUATHI values('K1303','CTDLGT',3,'8/15/2006',4.25,'Khong Dat')
insert into KETQUATHI values('K1303','THDC',1,'5/20/2006',4.50,'Khong Dat')
insert into KETQUATHI values('K1303','CTRR',1,'5/13/2006',3.25,'Khong Dat')
insert into KETQUATHI values('K1303','CTRR',2,'5/20/2006',5.00,'Dat')
insert into KETQUATHI values('K1304','CSDL',1,'12/20/2006',7.75,'Dat')
insert into KETQUATHI values('K1304','CTDLGT',1,'7/25/2006',9.75,'Dat')
insert into KETQUATHI values('K1304','THDC',1,'5/20/2006',5.50,'Dat')
insert into KETQUATHI values('K1304','CTRR',1,'5/13/2006',5.00,'Dat')
insert into KETQUATHI values('K1305','CSDL',1,'12/20/2006',9.25,'Dat')
insert into KETQUATHI values('K1305','CTDLGT',1,'7/25/2006',10.00,'Dat')
insert into KETQUATHI values('K1305','THDC',1,'5/20/2006',8.00,'Dat')
insert into KETQUATHI values('K1305','CTRR',1,'5/13/2006',10.00,'Dat')

ALTER TABLE LOP ADD CONSTRAINT FK_TRGLOP FOREIGN KEY (TRGLOP) REFERENCES HOCVIEN(MAHV)
ALTER TABLE LOP ADD	CONSTRAINT FK_MAGVCN FOREIGN KEY (MAGVCN) REFERENCES GIAOVIEN(MAGV)
ALTER TABLE HOCVIEN ADD CONSTRAINT FK_LOP FOREIGN KEY (MALOP) REFERENCES LOP(MALOP)
ALTER TABLE GIAOVIEN ADD CONSTRAINT FK_MAKHOA FOREIGN KEY (MAKHOA) REFERENCES KHOA(MAKHOA)
ALTER TABLE GIANGDAY ADD CONSTRAINT FK_MAMH FOREIGN KEY (MAMH) REFERENCES MONHOC(MAMH)
ALTER TABLE KHOA ADD CONSTRAINT FK_MAGV FOREIGN KEY (TRGKHOA) REFERENCES GIAOVIEN(MAGV)
ALTER TABLE MONHOC ADD CONSTRAINT FK_MAKHOA_2 FOREIGN KEY (MAKHOA) REFERENCES KHOA(MAKHOA)
ALTER TABLE DIEUKIEN ADD CONSTRAINT FK_MAMH_TRUOC FOREIGN KEY (MAMH_TRUOC) REFERENCES MONHOC(MAMH)
ALTER TABLE DIEUKIEN ADD CONSTRAINT FK_MAMH_2 FOREIGN KEY (MAMH) REFERENCES MONHOC(MAMH)
ALTER TABLE KETQUATHI ADD CONSTRAINT FK_MAHV FOREIGN KEY (MAHV) REFERENCES HOCVIEN(MAHV)

-- 1. Tăng hệ số lương thêm 0.2 cho những giáo viên là trưởng khoa.
UPDATE GIAOVIEN
SET HESO=HESO+0.2
WHERE MAGV IN (SELECT TRGKHOA FROM KHOA);

SELECT * FROM GIAOVIEN
WHERE MAGV IN (SELECT TRGKHOA FROM KHOA);

-- 2. Cập nhật giá trị điểm trung bình tất cả các môn học (DIEMTB) của mỗi học viên
-- (tất cả các môn học đều có hệ số 1 và nếu học viên thi một môn nhiều lần,
-- chỉ lấy điểm của lần thi sau cùng).
ALTER TABLE HOCVIEN
ADD DIEMTB NUMERIC(4,2);

UPDATE HOCVIEN
SET DIEMTB = DTB_HOCVIEN.DTB
FROM HOCVIEN HV LEFT JOIN (
	SELECT MAHV, AVG(DIEM) AS DTB 
	FROM KETQUATHI A
	WHERE NOT EXISTS (
		SELECT 1 FROM KETQUATHI B 
		WHERE (A.MAHV = B.MAHV AND A.MAMH = B.MAMH AND A.LANTHI < B.LANTHI)
	)
	GROUP BY MAHV
) DTB_HOCVIEN
ON HV.MAHV = DTB_HOCVIEN.MAHV;

SELECT * FROM HOCVIEN;


-- 3. Cập nhật giá trị cho cột GHICHU là “Cam thi” đối với trường hợp: học viên có một môn bất 
-- kỳ thi lần thứ 3 dưới 5 điểm.
ALTER TABLE HOCVIEN
ADD GHICHU VARCHAR(20);

UPDATE HOCVIEN
SET GHICHU = 'Cam thi'
WHERE MAHV IN (
	SELECT MAHV FROM KETQUATHI 
	WHERE (LANTHI = 3 AND DIEM < 5)
);

SELECT * FROM HOCVIEN;

-- 4. Cập nhật giá trị cho cột XEPLOAI trong quan hệ HOCVIEN như sau:
-- o Nếu DIEMTB  9 thì XEPLOAI =”XS”
-- o Nếu 8  DIEMTB < 9 thì XEPLOAI = “G”
-- o Nếu 6.5  DIEMTB < 8 thì XEPLOAI = “K”
-- o Nếu 5  DIEMTB < 6.5 thì XEPLOAI = “TB”
-- o Nếu DIEMTB < 5 thì XEPLOAI = ”Y”
ALTER TABLE HOCVIEN
ADD XEPLOAI CHAR(2);

UPDATE HOCVIEN SET XEPLOAI = CASE 
	WHEN DIEMTB >= 9 THEN 'XS'
	WHEN DIEMTB >= 8 THEN 'G'
	WHEN DIEMTB >= 6.5 THEN 'K'
	WHEN DIEMTB >= 5 THEN 'TB'
	ELSE 'Y'
END;

SELECT * FROM HOCVIEN;

-- 6. Tìm tên những môn học mà giáo viên có tên “Tran Tam Thanh”
-- dạy trong học kỳ 1 năm 2006.
SELECT TENMH FROM MONHOC
WHERE MAMH IN (
	SELECT DISTINCT MAMH FROM GIANGDAY
	WHERE HOCKY=1 AND NAM=2006 AND MAGV IN (
		SELECT MAGV FROM GIAOVIEN
		WHERE (HOTEN='Tran Tam Thanh')
	)
);

-- 7. Tìm những môn học (mã môn học, tên môn học)
-- mà giáo viên chủ nhiệm lớp “K11” dạy trong học kỳ 1 năm 2006.
SELECT MAMH, TENMH FROM MONHOC
WHERE MAMH IN (
	SELECT DISTINCT MAMH FROM GIANGDAY
	WHERE HOCKY=1 AND NAM=2006 AND MAGV IN (
		SELECT MAGVCN FROM LOP
		WHERE (MALOP='K11')
	)
);

-- 8. Tìm họ tên lớp trưởng của các lớp
--mà giáo viên có tên “Nguyen To Lan” dạy môn “Co So Du Lieu”.
SELECT HO, TEN FROM HOCVIEN
WHERE MAHV IN (
	SELECT TRGLOP FROM LOP
	WHERE MAGVCN IN (
		SELECT GIANGDAY.MAGV FROM GIAOVIEN
		JOIN GIANGDAY ON GIAOVIEN.MAGV=GIANGDAY.MAGV
		JOIN MONHOC ON MONHOC.MAMH=GIANGDAY.MAMH
		WHERE HOTEN='Nguyen To Lan' AND TENMH='Co So Du Lieu'
	)
);

-- 9. In ra danh sách những môn học (mã môn học, tên môn học)
-- phải học liền trước môn “Co So Du Lieu”.
SELECT MAMH, TENMH FROM MONHOC
WHERE MAMH IN (
	SELECT MAMH_TRUOC FROM DIEUKIEN
	WHERE MAMH IN (
		SELECT MAMH FROM MONHOC
		WHERE TENMH='Co So Du Lieu'
	)
);

-- 10. Môn “Cau Truc Roi Rac” là môn bắt buộc phải học liền trước
-- những môn học (mã môn học, tên môn học) nào.
SELECT MAMH, TENMH FROM MONHOC
WHERE MAMH IN (
	SELECT MAMH FROM DIEUKIEN
	WHERE MAMH_TRUOC IN (
		SELECT MAMH FROM MONHOC
		WHERE TENMH='Cau Truc Roi Rac'
	)
);

-- 11. Tìm họ tên giáo viên dạy môn CTRR
-- cho cả hai lớp “K11” và “K12”
-- trong cùng học kỳ 1 năm 2006.
SELECT HOTEN FROM GIAOVIEN
WHERE MAGV IN (
	SELECT MAGV FROM GIANGDAY
	WHERE MALOP='K11' AND HOCKY=1 AND NAM=2006
	INTERSECT
	SELECT MAGV FROM GIANGDAY
	WHERE MALOP='K12' AND HOCKY=1 AND NAM=2006
);

-- 12. Tìm những học viên (mã học viên, họ tên)
-- thi không đạt môn CSDL ở lần thi thứ 1
-- nhưng chưa thi lại môn này.
SELECT MAHV, HO, TEN FROM HOCVIEN
WHERE MAHV IN (
	SELECT MAHV FROM KETQUATHI
	WHERE KQUA='Khong Dat' AND MAMH='CSDL'
	EXCEPT
	SELECT MAHV FROM KETQUATHI
	WHERE KQUA='Khong Dat' AND MAMH='CSDL' AND LANTHI>1
);

-- 13. Tìm giáo viên (mã giáo viên, họ tên)
-- không được phân công giảng dạy bất kỳ môn học nào.
SELECT MAGV, HOTEN FROM GIAOVIEN
WHERE MAGV NOT IN (
	SELECT MAGV FROM GIANGDAY
);

-- 14. Tìm giáo viên (mã giáo viên, họ tên)
-- không được phân công giảng dạy bất kỳ môn học nào 
-- thuộc khoa giáo viên đó phụ trách.
SELECT MAGV, HOTEN FROM GIAOVIEN
WHERE MAGV NOT IN (
	SELECT GD.MAGV
	FROM GIANGDAY AS GD
	JOIN GIAOVIEN AS GV ON GV.MAGV=GD.MAGV
	JOIN MONHOC AS MH ON MH.MAMH=GD.MAMH
	WHERE GV.MAKHOA=MH.MAKHOA
);

-- 15. Tìm họ tên các học viên thuộc lớp “K11”
-- thi một môn bất kỳ quá 3 lần vẫn “Khong dat” 
-- hoặc thi lần thứ 2 môn CTRR được 5 điểm.
SELECT HO, TEN FROM HOCVIEN
WHERE MALOP='K11' AND MAHV IN (
	SELECT MAHV FROM KETQUATHI
	WHERE (LANTHI>=3 AND KQUA='Khong Dat') OR (LANTHI=2 AND MAMH='CTRR' AND DIEM=5)
);

-- 16. Tìm họ tên giáo viên dạy môn CTRR
-- cho ít nhất hai lớp
-- trong cùng một học kỳ của một năm học.
SELECT HOTEN FROM GIAOVIEN
WHERE MAGV IN (
	SELECT MAGV FROM GIANGDAY
	WHERE MAMH='CTRR'
	GROUP BY MAGV, HOCKY, NAM 
	HAVING COUNT(MALOP) >= 2
);

-- 17. Danh sách học viên và điểm thi môn CSDL (chỉ lấy điểm của lần thi sau cùng).
SELECT A.MAHV, DIEM FROM KETQUATHI AS A
WHERE MAMH='CSDL' AND NOT EXISTS (
	SELECT 1 FROM KETQUATHI AS B 
	WHERE A.MAHV=B.MAHV AND A.MAMH=B.MAMH AND A.LANTHI<B.LANTHI
);

SELECT MAHV, DIEM FROM KETQUATHI AS A
WHERE MAMH='CSDL' AND LANTHI = (
    SELECT MAX(LANTHI) FROM KETQUATHI AS B
    WHERE B.MAMH='CSDL' AND A.MAHV=B.MAHV
)
ORDER BY MAHV;


-- 18. Danh sách học viên và điểm thi môn “Co So Du Lieu”
-- (chỉ lấy điểm cao nhất của các lần thi).
SELECT MAHV, MAX(DIEM) AS DIEM FROM KETQUATHI 
WHERE MAMH IN (
	SELECT MAMH FROM MONHOC 
	WHERE TENMH = 'Co So Du Lieu'
) 
GROUP BY MAHV;

USE master;
DROP DATABASE QuanLyGiaoVu;
