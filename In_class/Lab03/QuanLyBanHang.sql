﻿CREATE DATABASE QuanLyBanHang;
USE QuanLyBanHang;

CREATE TABLE KhachHang(
	MaKH CHAR(4) NOT NULL,
	HoTen VARCHAR(40),
	DChi VARCHAR(50),
	SoDT VARCHAR(20),
	NgSinh SMALLDATETIME,
	DoanhSo MONEY,
	NgDK SMALLDATETIME,

	CONSTRAINT PK_KhachHang PRIMARY KEY (MaKH),
);

CREATE TABLE NhanVien(
	MaNV CHAR(4) NOT NULL,
	HoTen VARCHAR(40),
	SoDT VARCHAR(20),
	NgVL SMALLDATETIME,

	CONSTRAINT PK_NhanVien PRIMARY KEY (MaNV),
);

CREATE TABLE SanPham(
	MaSP CHAR(4) NOT NULL,
	TenSP VARCHAR(40),
	DVT VARCHAR(20),
	NuocSX VARCHAR(40),
	Gia MONEY,

	CONSTRAINT PK_SanPham PRIMARY KEY (MaSP),
);

CREATE TABLE HoaDon(
	SoHD INT NOT NULL,
	NgHD SMALLDATETIME,
	MaKH CHAR(4),
	MaNV CHAR(4),
	TriGia MONEY,

	CONSTRAINT PK_HoaDon PRIMARY KEY (SoHD),

	CONSTRAINT FK_KhachHang_HoaDon FOREIGN KEY (MaKH) REFERENCES KhachHang(MaKH),
	CONSTRAINT FK_NhanVien_HoaDon FOREIGN KEY (MaNV) REFERENCES NhanVien(MaNV),
);

CREATE TABLE CTHD(
	SoHD INT NOT NULL,
	MaSP CHAR(4) NOT NULL,
	SL INT,
	
	CONSTRAINT PK_CTHD PRIMARY KEY (SoHD, MaSP),

	CONSTRAINT FK_HoaDon_CTHD FOREIGN KEY (SoHD) REFERENCES HoaDon(SoHD),
	CONSTRAINT FK_SanPham_CTHD FOREIGN KEY (MaSP) REFERENCES SanPham(MaSP),
);

SET DATEFORMAT dmy;
-- 1. Nhập dữ liệu cho các quan hệ trên
INSERT INTO KHACHHANG(MAKH, HOTEN, DCHI, SODT, NGSINH, DOANHSO, NGDK) VALUES('KH01', 'Nguyen Van A', '731 Tran Hung Dao,  Q5,  TpHCM', '08823451', '22/10/1960', '13060000', '22/07/2006')
INSERT INTO KHACHHANG(MAKH, HOTEN, DCHI, SODT, NGSINH, DOANHSO, NGDK) VALUES('KH02', 'Tran Ngoc Han', '23/5 Nguyen Trai,  Q5, TpHCM', '0908256478', '03/04/1974', '280000', '30/07/2006')
INSERT INTO KHACHHANG(MAKH, HOTEN, DCHI, SODT, NGSINH, DOANHSO, NGDK) VALUES('KH03', 'Tran Ngoc Linh', '45 Nguyen Canh Chan,  Q1,  TpHCM', '0938776266', '12/06/1980', '3860000', '05/08/2006')
INSERT INTO KHACHHANG(MAKH, HOTEN, DCHI, SODT, NGSINH, DOANHSO, NGDK) VALUES('KH04', 'Tran Minh Long', '50/34 Le Dai Hanh,  Q10,  TpHCM', '0917325476', '09/03/1965', '250000', '02/10/2006')
INSERT INTO KHACHHANG(MAKH, HOTEN, DCHI, SODT, NGSINH, DOANHSO, NGDK) VALUES('KH05', 'Le Nhat Minh', '34 Truong Dinh,  Q3,  TpHCM', '08246108', '10/03/1950', '21000', '28/10/2006')
INSERT INTO KHACHHANG(MAKH, HOTEN, DCHI, SODT, NGSINH, DOANHSO, NGDK) VALUES('KH06', 'Le Hoai Thuong', '227 Nguyen Van Cu,  Q5,  TpHCM', '08631738', '31/12/1981', '915000', '24/11/2006')
INSERT INTO KHACHHANG(MAKH, HOTEN, DCHI, SODT, NGSINH, DOANHSO, NGDK) VALUES('KH07', 'Nguyen Van Tam', '32/3 Tran Binh Trong,  Q5,  TpHCM', '0916783565', '06/04/1971', '12500', '01/12/2006')
INSERT INTO KHACHHANG(MAKH, HOTEN, DCHI, SODT, NGSINH, DOANHSO, NGDK) VALUES('KH08', 'Phan Thi Thanh', '45/2 An Duong Vuong,  Q5,  TpHCM', '0938435756', '10/01/1971', '365000', '13/12/2006')
INSERT INTO KHACHHANG(MAKH, HOTEN, DCHI, SODT, NGSINH, DOANHSO, NGDK) VALUES('KH09', 'Le Ha Vinh', '873 Le Hong Phong,  Q5,  TpHCM', '08654763', '03/09/1979', '70000', '14/01/2007')
INSERT INTO KHACHHANG(MAKH, HOTEN, DCHI, SODT, NGSINH, DOANHSO, NGDK) VALUES('KH10', 'Ha Duy Lap', '34/34B Nguyen Trai,  Q1,  TpHCM', '08768904', '02/05/1983', '675000', '16/01/2007')

INSERT INTO NHANVIEN(MANV, HOTEN, SODT, NGVL) VALUES('NV01', 'Nguyen Nhu Nhut', '0927345678', '13/04/2006')
INSERT INTO NHANVIEN(MANV, HOTEN, SODT, NGVL) VALUES('NV02', 'Le Thi Phi Yen', '0987567390', '21/04/2006')
INSERT INTO NHANVIEN(MANV, HOTEN, SODT, NGVL) VALUES('NV03', 'Nguyen Van B', '0997047382', '27/04/2006')
INSERT INTO NHANVIEN(MANV, HOTEN, SODT, NGVL) VALUES('NV04', 'Ngo Thanh Tuan', '0913758498', '24/06/2006')
INSERT INTO NHANVIEN(MANV, HOTEN, SODT, NGVL) VALUES('NV05', 'Nguyen Thi Truc Thanh', '0918590387', '20/07/2006')

INSERT INTO SANPHAM(MASP, TENSP, DVT, NUOCSX, GIA) VALUES('BC01', 'But chi', 'cay', 'Singapore', '3000')
INSERT INTO SANPHAM(MASP, TENSP, DVT, NUOCSX, GIA) VALUES('BC02', 'But chi', 'cay', 'Singapore', '5000')
INSERT INTO SANPHAM(MASP, TENSP, DVT, NUOCSX, GIA) VALUES('BC03', 'But chi', 'cay', 'Viet Nam', '3500')
INSERT INTO SANPHAM(MASP, TENSP, DVT, NUOCSX, GIA) VALUES('BC04', 'But chi', 'hop', 'Viet Nam', '30000')
INSERT INTO SANPHAM(MASP, TENSP, DVT, NUOCSX, GIA) VALUES('BB01', 'But bi', 'cay', 'Viet Nam', '5000')
INSERT INTO SANPHAM(MASP, TENSP, DVT, NUOCSX, GIA) VALUES('BB02', 'But bi', 'cay', 'Trung Quoc', '5000')
INSERT INTO SANPHAM(MASP, TENSP, DVT, NUOCSX, GIA) VALUES('BB03', 'But bi', 'hop', 'Thai Lan', '100000')
INSERT INTO SANPHAM(MASP, TENSP, DVT, NUOCSX, GIA) VALUES('TV01', 'Tap 100 giay mong', 'quyen', 'Trung Quoc', '2500')
INSERT INTO SANPHAM(MASP, TENSP, DVT, NUOCSX, GIA) VALUES('TV02', 'Tap 200 giay mong', 'quyen', 'Trung Quoc', '4500')
INSERT INTO SANPHAM(MASP, TENSP, DVT, NUOCSX, GIA) VALUES('TV03', 'Tap 100 giay tot', 'quyen', 'Viet Nam', '3000')
INSERT INTO SANPHAM(MASP, TENSP, DVT, NUOCSX, GIA) VALUES('TV04', 'Tap 200 giay tot', 'quyen', 'Viet Nam', '5500')
INSERT INTO SANPHAM(MASP, TENSP, DVT, NUOCSX, GIA) VALUES('TV05', 'Tap 100 trang', 'chuc', 'Viet Nam', '23000')
INSERT INTO SANPHAM(MASP, TENSP, DVT, NUOCSX, GIA) VALUES('TV06', 'Tap 200 trang', 'chuc', 'Viet Nam', '53000')
INSERT INTO SANPHAM(MASP, TENSP, DVT, NUOCSX, GIA) VALUES('TV07', 'Tap 100 trang', 'chuc', 'Trung Quoc', '34000')
INSERT INTO SANPHAM(MASP, TENSP, DVT, NUOCSX, GIA) VALUES('ST01', 'So tay 500 trang', 'quyen', 'Trung Quoc', '40000')
INSERT INTO SANPHAM(MASP, TENSP, DVT, NUOCSX, GIA) VALUES('ST02', 'So tay loai 1', 'quyen', 'Viet Nam', '55000')
INSERT INTO SANPHAM(MASP, TENSP, DVT, NUOCSX, GIA) VALUES('ST03', 'So tay loai 2', 'quyen', 'Viet Nam', '51000')
INSERT INTO SANPHAM(MASP, TENSP, DVT, NUOCSX, GIA) VALUES('ST04', 'So tay', 'quyen', 'Thai Lan', '55000')
INSERT INTO SANPHAM(MASP, TENSP, DVT, NUOCSX, GIA) VALUES('ST05', 'So tay mong', 'quyen', 'Thai Lan', '20000')
INSERT INTO SANPHAM(MASP, TENSP, DVT, NUOCSX, GIA) VALUES('ST06', 'Phan viet bang', 'hop', 'Viet Nam', '5000')
INSERT INTO SANPHAM(MASP, TENSP, DVT, NUOCSX, GIA) VALUES('ST07', 'Phan khong bui', 'hop', 'Viet Nam', '7000')
INSERT INTO SANPHAM(MASP, TENSP, DVT, NUOCSX, GIA) VALUES('ST08', 'Bong bang', 'cai', 'Viet Nam', '5000')
INSERT INTO SANPHAM(MASP, TENSP, DVT, NUOCSX, GIA) VALUES('ST09', 'But long', 'cay', 'Viet Nam', '5000')
INSERT INTO SANPHAM(MASP, TENSP, DVT, NUOCSX, GIA) VALUES('ST10', 'But long', 'cay', 'Trung Quoc', '7000')

INSERT INTO HOADON(SOHD, NGHD, MAKH, MANV, TRIGIA) VALUES('1001', '23/07/2006', 'KH01', 'NV01', '320000')
INSERT INTO HOADON(SOHD, NGHD, MAKH, MANV, TRIGIA) VALUES('1002', '12/08/2006', 'KH01', 'NV02', '840000')
INSERT INTO HOADON(SOHD, NGHD, MAKH, MANV, TRIGIA) VALUES('1003', '23/08/2006', 'KH02', 'NV01', '100000')
INSERT INTO HOADON(SOHD, NGHD, MAKH, MANV, TRIGIA) VALUES('1004', '01/09/2006', 'KH02', 'NV01', '180000')
INSERT INTO HOADON(SOHD, NGHD, MAKH, MANV, TRIGIA) VALUES('1005', '20/10/2006', 'KH01', 'NV02', '3800000')
INSERT INTO HOADON(SOHD, NGHD, MAKH, MANV, TRIGIA) VALUES('1006', '16/10/2006', 'KH01', 'NV03', '2430000')
INSERT INTO HOADON(SOHD, NGHD, MAKH, MANV, TRIGIA) VALUES('1007', '28/10/2006', 'KH03', 'NV03', '510000')
INSERT INTO HOADON(SOHD, NGHD, MAKH, MANV, TRIGIA) VALUES('1008', '28/10/2006', 'KH01', 'NV03', '440000')
INSERT INTO HOADON(SOHD, NGHD, MAKH, MANV, TRIGIA) VALUES('1009', '28/10/2006', 'KH03', 'NV04', '200000')
INSERT INTO HOADON(SOHD, NGHD, MAKH, MANV, TRIGIA) VALUES('1010', '01/11/2006', 'KH01', 'NV01', '5200000')
INSERT INTO HOADON(SOHD, NGHD, MAKH, MANV, TRIGIA) VALUES('1011', '04/11/2006', 'KH04', 'NV03', '250000')
INSERT INTO HOADON(SOHD, NGHD, MAKH, MANV, TRIGIA) VALUES('1012', '30/11/2006', 'KH05', 'NV03', '21000')
INSERT INTO HOADON(SOHD, NGHD, MAKH, MANV, TRIGIA) VALUES('1013', '12/12/2006', 'KH06', 'NV01', '5000')
INSERT INTO HOADON(SOHD, NGHD, MAKH, MANV, TRIGIA) VALUES('1014', '31/12/2006', 'KH03', 'NV02', '3150000')
INSERT INTO HOADON(SOHD, NGHD, MAKH, MANV, TRIGIA) VALUES('1015', '01/01/2007', 'KH06', 'NV02', '910000')
INSERT INTO HOADON(SOHD, NGHD, MAKH, MANV, TRIGIA) VALUES('1016', '01/01/2007', 'KH07', 'NV02', '12500')
INSERT INTO HOADON(SOHD, NGHD, MAKH, MANV, TRIGIA) VALUES('1017', '02/01/2007', 'KH08', 'NV03', '35000')
INSERT INTO HOADON(SOHD, NGHD, MAKH, MANV, TRIGIA) VALUES('1018', '13/01/2007', 'KH01', 'NV03', '330000')
INSERT INTO HOADON(SOHD, NGHD, MAKH, MANV, TRIGIA) VALUES('1019', '13/01/2007', 'KH01', 'NV03', '30000')
INSERT INTO HOADON(SOHD, NGHD, MAKH, MANV, TRIGIA) VALUES('1020', '14/01/2007', 'KH09', 'NV04', '70000')
INSERT INTO HOADON(SOHD, NGHD, MAKH, MANV, TRIGIA) VALUES('1021', '16/01/2007', 'KH10', 'NV03', '67500')
INSERT INTO HOADON(SOHD, NGHD, MAKH, MANV, TRIGIA) VALUES('1022', '16/01/2007',  NULL, 'NV03', '7000')
INSERT INTO HOADON(SOHD, NGHD, MAKH, MANV, TRIGIA) VALUES('1023', '17/01/2007',  NULL, 'NV01', '330000')

INSERT INTO CTHD(SOHD, MASP, SL) VALUES('1001', 'TV02', '10')
INSERT INTO CTHD(SOHD, MASP, SL) VALUES('1001', 'ST01', '5')
INSERT INTO CTHD(SOHD, MASP, SL) VALUES('1001', 'BC01', '5')
INSERT INTO CTHD(SOHD, MASP, SL) VALUES('1001', 'BC02', '10')
INSERT INTO CTHD(SOHD, MASP, SL) VALUES('1001', 'ST08', '10')
INSERT INTO CTHD(SOHD, MASP, SL) VALUES('1001', 'BC04', '20')
INSERT INTO CTHD(SOHD, MASP, SL) VALUES('1002', 'BB01', '20')
INSERT INTO CTHD(SOHD, MASP, SL) VALUES('1002', 'BB02', '20')
INSERT INTO CTHD(SOHD, MASP, SL) VALUES('1003', 'BB03', '10')
INSERT INTO CTHD(SOHD, MASP, SL) VALUES('1004', 'TV01', '20')
INSERT INTO CTHD(SOHD, MASP, SL) VALUES('1004', 'TV02', '10')
INSERT INTO CTHD(SOHD, MASP, SL) VALUES('1004', 'TV03', '10')
INSERT INTO CTHD(SOHD, MASP, SL) VALUES('1004', 'TV04', '10')
INSERT INTO CTHD(SOHD, MASP, SL) VALUES('1005', 'TV05', '50')
INSERT INTO CTHD(SOHD, MASP, SL) VALUES('1005', 'TV06', '50')
INSERT INTO CTHD(SOHD, MASP, SL) VALUES('1006', 'TV07', '20')
INSERT INTO CTHD(SOHD, MASP, SL) VALUES('1006', 'ST01', '30')
INSERT INTO CTHD(SOHD, MASP, SL) VALUES('1006', 'ST02', '10')
INSERT INTO CTHD(SOHD, MASP, SL) VALUES('1007', 'ST03', '10')
INSERT INTO CTHD(SOHD, MASP, SL) VALUES('1008', 'ST04', '8')
INSERT INTO CTHD(SOHD, MASP, SL) VALUES('1009', 'ST05', '10')
INSERT INTO CTHD(SOHD, MASP, SL) VALUES('1010', 'TV07', '50')
INSERT INTO CTHD(SOHD, MASP, SL) VALUES('1010', 'ST07', '50')
INSERT INTO CTHD(SOHD, MASP, SL) VALUES('1010', 'ST08', '100')
INSERT INTO CTHD(SOHD, MASP, SL) VALUES('1010', 'ST04', '50')
INSERT INTO CTHD(SOHD, MASP, SL) VALUES('1010', 'TV03', '100')
INSERT INTO CTHD(SOHD, MASP, SL) VALUES('1011', 'ST06', '50')
INSERT INTO CTHD(SOHD, MASP, SL) VALUES('1012', 'ST07', '3')
INSERT INTO CTHD(SOHD, MASP, SL) VALUES('1013', 'ST08', '5')
INSERT INTO CTHD(SOHD, MASP, SL) VALUES('1014', 'BC02', '80')
INSERT INTO CTHD(SOHD, MASP, SL) VALUES('1014', 'BB02', '100')
INSERT INTO CTHD(SOHD, MASP, SL) VALUES('1014', 'BC04', '60')
INSERT INTO CTHD(SOHD, MASP, SL) VALUES('1014', 'BB01', '50')
INSERT INTO CTHD(SOHD, MASP, SL) VALUES('1015', 'BB02', '30')
INSERT INTO CTHD(SOHD, MASP, SL) VALUES('1015', 'BB03', '7')
INSERT INTO CTHD(SOHD, MASP, SL) VALUES('1016', 'TV01', '5')
INSERT INTO CTHD(SOHD, MASP, SL) VALUES('1017', 'TV02', '1')
INSERT INTO CTHD(SOHD, MASP, SL) VALUES('1017', 'TV03', '1')
INSERT INTO CTHD(SOHD, MASP, SL) VALUES('1017', 'TV04', '5')
INSERT INTO CTHD(SOHD, MASP, SL) VALUES('1018', 'ST04', '6')
INSERT INTO CTHD(SOHD, MASP, SL) VALUES('1019', 'ST05', '1')
INSERT INTO CTHD(SOHD, MASP, SL) VALUES('1019', 'ST06', '2')
INSERT INTO CTHD(SOHD, MASP, SL) VALUES('1020', 'ST07', '10')
INSERT INTO CTHD(SOHD, MASP, SL) VALUES('1021', 'ST08', '5')
INSERT INTO CTHD(SOHD, MASP, SL) VALUES('1021', 'TV01', '7')
INSERT INTO CTHD(SOHD, MASP, SL) VALUES('1021', 'TV02', '10')
INSERT INTO CTHD(SOHD, MASP, SL) VALUES('1022', 'ST07', '1')
INSERT INTO CTHD(SOHD, MASP, SL) VALUES('1023', 'ST04', '6')

-- 12. Tìm các số hóa đơn đã mua sản phẩm có mã số “BB01” hoặc “BB02”,
-- mỗi sản phẩm mua với số lượng từ 10 đến 20.
SELECT SoHD FROM CTHD
WHERE (MaSP IN ('BB01', 'BB02') AND SL BETWEEN 10 AND 20);


-- 13. Tìm các số hóa đơn mua cùng lúc 2 sản phẩm có mã số “BB01” và “BB02”, mỗi sản phẩm mua với 
-- số lượng từ 10 đến 20.
SELECT SoHD FROM CTHD
WHERE (MaSP='BB01' AND SL BETWEEN 10 AND 20)
INTERSECT
SELECT SoHD FROM CTHD
WHERE (MaSP='BB02' AND SL BETWEEN 10 AND 20);

-- 14. In ra danh sách các sản phẩm (MASP,TENSP)
-- do “Trung Quoc” sản xuất hoặc các sản phẩm được 
-- bán ra trong ngày 1/1/2007.
SELECT SanPham.MaSP, TenSP FROM SanPham WHERE (NuocSX='Trung Quoc')
UNION
SELECT SanPham.MaSP, TenSP FROM SanPham
JOIN CTHD ON SanPham.MaSP=CTHD.MaSP
JOIN HoaDon ON HoaDon.SoHD=CTHD.SoHD
WHERE (NGHD='1/1/2007');

-- 15. In ra danh sách các sản phẩm (MASP,TENSP) không bán được.
SELECT SanPham.MaSP, TenSP FROM SanPham
EXCEPT
SELECT SanPham.MaSP, TenSP FROM SanPham
JOIN CTHD ON SanPham.MaSP=CTHD.MaSP;

-- 16. In ra danh sách các sản phẩm (MASP,TENSP)
-- không bán được trong năm 2006.
SELECT SanPham.MaSP, TenSP FROM SanPham
EXCEPT
SELECT SanPham.MaSP, TenSP FROM SanPham
JOIN CTHD ON SanPham.MaSP=CTHD.MaSP
JOIN HoaDon On HoaDon.SoHD=CTHD.SoHD
WHERE (YEAR(NgHD)=2006);

-- 17. In ra danh sách các sản phẩm (MASP,TENSP)
-- do “Trung Quoc” sản xuất không bán được trong năm 2006.
SELECT SanPham.MaSP, TenSP FROM SanPham WHERE (NUOCSX='Trung Quoc')
EXCEPT
SELECT SanPham.MaSP, TenSP FROM SanPham
WHERE MaSP IN (
	SELECT MaSP FROM CTHD
	WHERE YEAR(NgHD)=2006 AND SoHD IN (
		SELECT SoHD FROM HoaDon
		WHERE NUOCSX='Trung Quoc'
	)
);

-- 18. Tìm số hóa đơn trong năm 2006
-- đã mua ít nhất tất cả các sản phẩm do Singapore sản xuất.
SELECT * FROM CTHD AS sx
JOIN HoaDon ON sx.SoHD=HoaDon.SoHD
WHERE YEAR(NgHD)=2006 AND NOT EXISTS (
           (SELECT MaSP FROM SanPham AS p WHERE NUOCSX='Singapore')
            EXCEPT
           (SELECT sp.MaSP FROM CTHD AS sp WHERE sp.SoHD = sx.SoHD)
);


USE master;
DROP DATABASE QuanLyBanHang;
