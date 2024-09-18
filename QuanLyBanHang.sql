CREATE DATABASE QuanLyBanHang;
USE QuanLyBanHang;

CREATE TABLE KhachHang(
	MaKH CHAR(4) NOT NULL,
	HoTen VARCHAR(40),
	DChi VARCHAR(50),
	SoDT VARCHAR(20),
	NgSinh SMALLDATETIME,
	NgDK SMALLDATETIME,
	DoanhSo MONEY,

	CONSTRAINT PK_MaKH PRIMARY KEY (MaKH),
);

CREATE TABLE NhanVien(
	MaNV CHAR(4) NOT NULL,
	HoTen VARCHAR(40),
	SoDT VARCHAR(20),
	NgVL SMALLDATETIME,

	CONSTRAINT PK_MaNV PRIMARY KEY (MaNV),
);

CREATE TABLE SanPham(
	MaSP CHAR(4) NOT NULL,
	TenSP VARCHAR(40),
	DVT VARCHAR(20),
	NuocSX VARCHAR(40),
	Gia MONEY,

	CONSTRAINT PK_MaSP PRIMARY KEY (MaSP),
);

CREATE TABLE HoaDon(
	SoHD INT NOT NULL,
	NgHD SMALLDATETIME,
	MaKH CHAR(4),
	MaNV CHAR(4),
	TriGia MONEY,

	CONSTRAINT PK_SoHD PRIMARY KEY (SoHD),
	CONSTRAINT FK_KhachHang_HoaDon FOREIGN KEY (MaKH) REFERENCES KhachHang(MaKH),
	CONSTRAINT FK_NhanVien_HoaDon FOREIGN KEY (MaNV) REFERENCES NhanVien(MaNV),
);

CREATE TABLE CTHD(
	SoHD INT NOT NULL,
	MaSP CHAR(4) NOT NULL,
	SL INT,
	
	CONSTRAINT PK_SoHD_MaSP PRIMARY KEY (SoHD, MaSP),
	CONSTRAINT FK_HoaDon_CTHD FOREIGN KEY (SoHD) REFERENCES HoaDon(SoHD),
	CONSTRAINT FK_SanPham_CTHD FOREIGN KEY (MaSP) REFERENCES SanPham(MaSP),
);

-- Thêm vào thuộc tính GHICHU có kiểu dữ liệu varchar(20) cho quan hệ SANPHAM
SELECT * FROM SanPham;

ALTER TABLE SanPham
ADD GhiChu VARCHAR(20);
SELECT * FROM SanPham;

-- Thêm vào thuộc tính LOAIKH có kiểu dữ liệu là tinyint cho quan hệ KHACHHANG
SELECT * FROM KhachHang;

ALTER TABLE KhachHang
ADD LoaiKH TINYINT;
SELECT * FROM KhachHang;

-- Sửa kiểu dữ liệu của thuộc tính GHICHU trong quan hệ SANPHAM thành varchar(100)
ALTER TABLE SanPham
ALTER COLUMN GhiChu VARCHAR(100);

-- Xóa thuộc tính GHICHU trong quan hệ SANPHAM
ALTER TABLE SanPham
DROP COLUMN GhiChu;

-- Sửa kiểu dữ liệu của thuộc tính LoaiKH trong quan hệ KhachHang thành varchar(20)
ALTER TABLE KhachHang
ALTER COLUMN LoaiKH VARCHAR(20);

-- Đơn vị tính của sản phẩm chỉ có thể là (“cay”,”hop”,”cai”,”quyen”,”chuc”
ALTER TABLE SanPham
ADD CHECK (DVT = 'cay' OR DVT = 'hop' OR DVT = 'cai' OR DVT = 'quyen' OR DVT = 'chuc')

-- Giá bán của sản phẩm từ 500 đồng trở lên
ALTER TABLE SanPham
ADD CHECK (Gia > 500);

-- Mỗi lần mua hàng, khách hàng phải mua ít nhất 1 sản phẩm
ALTER TABLE CTHD
ADD CHECK (SL > 0)

-- Ngày khách hàng đăng ký là khách hàng thành viên phải lớn hơn ngày sinh của người đó
ALTER TABLE KhachHang
ADD CHECK (NgDK > NgSinh);

USE master;
DROP DATABASE QuanLyBanHang;