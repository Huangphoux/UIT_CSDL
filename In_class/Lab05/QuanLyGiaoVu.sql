USE QuanLyGiaoVu;

-- 9. Lớp trưởng của một lớp phải là học viên của lớp đó. 
CREATE TRIGGER ThemSua_Lop ON LOP
FOR INSERT, UPDATE
AS
BEGIN 
IF NOT EXISTS (
	SELECT * FROM INSERTED, HOCVIEN
	WHERE INSERTED.TRGLOP = HOCVIEN.MaHV AND INSERTED.MaLop = HOCVIEN.MaLop
)
	BEGIN 
		PRINT 'Lop truong khong la hoc vien cua lop!'
		ROLLBACK TRANSACTION
	END
END


CREATE TRIGGER Xoa_HocVien ON HOCVIEN
FOR DELETE
AS 
BEGIN
IF EXISTS (
	SELECT * FROM DELETED, LOP
	WHERE LOP.TRGLOP = DELETED.MaHV AND DELETED.MaLop = LOP.MaLop
)
	BEGIN 
		PRINT 'Hoc vien la lop truong cua lop nen khong the xoa!'
		ROLLBACK TRANSACTION
	END
END

-- 10. Trưởng khoa phải là giáo viên thuộc khoa và có học vị “TS” hoặc “PTS”. 
CREATE TRIGGER Sua_TrgKhoa ON KHOA
FOR UPDATE
AS 
BEGIN
	DECLARE @MaGV CHAR(4), @MaKhoaGV CHAR(4), @TrgKhoa CHAR(4), @MaKhoa CHAR(4)

	SELECT @MaKhoa = MaKhoa, @TrgKhoa = @TrgKhoa FROM INSERTED
	SELECT @MaGV = MaGV, @MaKhoaGV = MaKhoa FROM GIAOVIEN WHERE MaGV = @TrgKhoa

	IF (@MaKhoaGV = @MaKhoa
		AND @MaGV IN (
			SELECT MaGV FROM GIAOVIEN WHERE HocVi IN ('TS', 'PTS')
		)
	)
	BEGIN
		PRINT 'SUA THANH CONG!!!'
	END ELSE
	BEGIN 
		PRINT 'Truong khoa khong la giao vien thuoc khoa va co hoc vi TS, PTS'
		ROLLBACK TRANSACTION
	END
END

CREATE TRIGGER Sua_MaKhoa_HocVi ON GIAOVIEN
FOR UPDATE 
AS
BEGIN
	DECLARE @MaKhoaGV CHAR(4), @HocVi VARCHAR(10), @MaGV CHAR(4)
	SELECT @MaKhoaGV = MaKhoa, @HocVi = HocVi FROM INSERTED
	
	IF (@MaGV IN (SELECT TrgKhoa FROM KHOA) AND @HocVi IN ('TS', 'PTS'))
	BEGIN
		PRINT 'SUA THANH CONG!!!'
	END ELSE
	BEGIN
		PRINT 'Giao vien la truong khoa va co hoc vi la TS hoac PTS'
		ROLLBACK TRANSACTION
	END
END

-- 15. Học viên chỉ được thi một môn học nào đó khi lớp của học viên đã học xong môn học này. 
CREATE TRIGGER ThemSua_NgThi ON KETQUATHI
FOR INSERT, UPDATE
AS
BEGIN 
	DECLARE @NgThi SMALLDATETIME, @MaMH VARCHAR(10), @MaHV CHAR(5), @DenNgay SMALLDATETIME, @MaLop CHAR(3)

	SELECT @MaHV = MaHV, @MaMH = MaMH, @NgThi = NgThi
	FROM INSERTED
	
	SELECT @MaLop = MaLop FROM HOCVIEN
		WHERE MaHV = @MaHV

	SELECT @DenNgay = DenNgay FROM GiangDay
		WHERE MaLop = @MaLop AND MaMH = @MaMH

	IF (@NgThi > @DenNgay)
	BEGIN 
		PRINT 'Thuc hien thanh cong'
	END ELSE 
	BEGIN
		PRINT 'Ngay thi truoc ngay ket thuc mon hoc!'
		ROLLBACK TRANSACTION
	END
END

CREATE TRIGGER ThemSua_DenNgay ON GiangDay
FOR UPDATE
AS
BEGIN 
	DECLARE @MaMH VARCHAR(10), @NgThi SMALLDATETIME, @MaHV CHAR(5), @DenNgay SMALLDATETIME, @MaLop CHAR(3)

	SELECT @MaLop = MaLop, @MaMH = MaMH, @DenNgay = DenNgay
	FROM INSERTED

	SELECT @MaHV = MaHV FROM HOCVIEN
		WHERE MaLop = @MaLop

	SELECT @NgThi = NgThi FROM KETQUATHI
		WHERE MaHV = @MaHV AND MaMH = @MaMH

	IF (@NgThi > @DenNgay)
	BEGIN 
		PRINT 'Sua thanh cong!!!'
	END ELSE 
	BEGIN
		PRINT 'Ngay thi truoc ngay ket thuc mon hoc!'
		ROLLBACK TRANSACTION
	END
END

-- 16. Mỗi học kỳ của một năm học, một lớp chỉ được học tối đa 3 môn. 
CREATE TRIGGER Them_GiangDay ON GiangDay
FOR INSERT
AS
BEGIN
	DECLARE @MaLop CHAR(3), @SoMon INT
	
	SELECT @MaLop = MaLop FROM INSERTED
	SELECT @SoMon = (
		SELECT COUNT(*) FROM GiangDay
		WHERE MaLop = @MaLop
	)

	IF (@SoMon > 3)
	BEGIN 
		PRINT 'Mot lop chi hoc toi da 3 mon'
		ROLLBACK TRANSACTION
	END ELSE
	BEGIN
		PRINT 'Them thanh cong!!!'
	END
END

-- 17. Sỉ số của một lớp bằng với số lượng học viên thuộc lớp đó. 
CREATE TRIGGER Sua_SiSo ON LOP
FOR UPDATE
AS
BEGIN
	DECLARE @SoHV INT, @MaLop CHAR(3), @SiSo INT

	SELECT  @SiSo = SiSo, @MaLop = MaLop FROM INSERTED
	SELECT @SoHV = (
		SELECT COUNT(*) FROM HOCVIEN
		WHERE MaLop = @MaLop
	)

	IF (@SoHV = @SiSo)
	BEGIN 
		PRINT 'SUA THANH CONG!!!'
	END ELSE
	BEGIN
		PRINT 'Si so cua lop phai bang so luong hoc vien thuoc lop do.'
		ROLLBACK TRANSACTION
	END
END

CREATE TRIGGER ThemSua_MaLop ON HOCVIEN
FOR UPDATE, INSERT
AS
BEGIN
	DECLARE @SiSo INT, @MaLop CHAR(3), @SoHV INT, @MaHV CHAR(5)

	SELECT @MaLop = MaLop FROM INSERTED
	SELECT @SiSo = SiSo FROM LOP WHERE MaLop = @MaLop
	SELECT @SoHV = (
		SELECT COUNT(*) FROM HOCVIEN
		WHERE MaLop = @MaLop
	)

	IF (@SoHV = @SiSo)
	BEGIN 
		PRINT 'SUA THANH CONG!!!'
	END ELSE
	BEGIN
		PRINT 'Si so cua lop phai bang so luong hoc vien thuoc lop do.'
		ROLLBACK TRANSACTION
	END
END

-- 18. Trong quan hệ DIEUKIEN giá trị của thuộc tính MaMH và MAMH_TRUOC trong cùng 
-- một bộ không được giống nhau (“A”,”A”) và cũng không tồn tại hai bộ (“A”,”B”) và 
-- (“B”,”A”). 
CREATE TRIGGER ThemSua_DieuKien ON DIEUKIEN
FOR UPDATE, INSERT
AS
BEGIN
	DECLARE @MAMH_TRUOC VARCHAR(10), @MaMH VARCHAR(10)
	
	SELECT @MaMH = MaMH, @MAMH_TRUOC = @MAMH_TRUOC FROM INSERTED
	
	IF (@MaMH = @MAMH_TRUOC
		OR @MaMH IN (SELECT MaMH FROM DIEUKIEN WHERE MAMH_TRUOC = @MAMH_TRUOC)
	)
	BEGIN
		PRINT 'Thao tac khong thanh cong.'
		ROLLBACK TRANSACTION
	END ELSE
	BEGIN
		PRINT 'Thao tac thanh cong!!!'
	END 
END

-- 19. Các giáo viên có cùng học vị, học hàm, hệ số lương thì mức lương bằng nhau. 
CREATE TRIGGER ThemSua_GiaoVien ON GIAOVIEN
FOR INSERT, UPDATE
AS 
BEGIN
	DECLARE @HeSo NUMERIC(4,2), @MucLuong MONEY, @HocVi VARCHAR(10), @HocHam VARCHAR(10)
	
	SELECT @HeSo = HeSo, @HocHam = HocHam, @MucLuong = MucLuong, @HocVi = HocVi FROM INSERTED
	
	IF (@MucLuong != (
			SELECT MucLuong FROM GIAOVIEN
			WHERE HocVi = @HocVi AND HocHam = @HocHam AND HeSo = @HeSo
			)
	)
	BEGIN
		PRINT 'Muc luong khac nhau'
		ROLLBACK TRANSACTION
	END ELSE
	BEGIN 
		PRINT 'Thao tac thanh cong'
	END
END

-- 20. Học viên chỉ được thi lại (lần thi >1) khi điểm của lần thi trước đó dưới 5. 
CREATE TRIGGER ThemSua_LanThi ON KETQUATHI
FOR INSERT, UPDATE
AS
BEGIN
	DECLARE @MaMH VARCHAR(10), @Diem NUMERIC(4,2), @LanThi TINYINT, @MaHV CHAR(5), @LanThiTruoc TINYINT
	
	SELECT @MaMH = MaMH, @MaHV = MaHV , @LanThi = LanThi FROM INSERTED
	SELECT @LanThiTruoc = (
		SELECT COUNT(*) FROM KETQUATHI
		WHERE MaHV = @MaHV AND MaMH = @MaMH
	)
	SELECT @Diem = Diem FROM KETQUATHI
	WHERE MaHV = @MaHV AND MaMH = @MaMH AND LanThi = @LanThiTruoc
	
	IF (@LanThi > 1 AND @Diem < 5)
	BEGIN
		PRINT 'THAO TAC THANH CONG!!!'
	END ELSE
	BEGIN 
		PRINT 'Hoc vien chi duoc thi lai khi diem lan thi truoc < 5'
		ROLLBACK TRANSACTION
	END
END

-- 21. Ngày thi của lần thi sau phải lớn hơn ngày thi của lần thi trước (cùng học viên, cùng môn học). 
CREATE TRIGGER ThemSua_NgThi_LanThi ON KETQUATHI
FOR INSERT, UPDATE
AS
BEGIN
	DECLARE @NgThiTRUOC SMALLDATETIME, @MaMH VARCHAR(10), @LanThi TINYINT, @LanThiTruoc TINYINT, @NgThi SMALLDATETIME, @MaHV CHAR(5)
	
	SELECT @MaHV = MaHV, @MaMH = MaMH, @LanThi = LanThi FROM INSERTED
	SELECT @LanThiTruoc = (
		SELECT COUNT(*) FROM KETQUATHI WHERE MaHV = @MaHV AND MaMH = @MaMH
	)
	SELECT @NgThiTRUOC = NgThi FROM KETQUATHI
	WHERE MaHV = @MaHV AND MaMH = @MaMH AND LanThi = @LanThiTruoc

	SELECT @NgThi = NgThi FROM KETQUATHI
	WHERE MaHV = @MaHV AND MaMH = @MaMH AND LanThi = @LanThi
	
	IF (@NgThi >= @NgThiTRUOC)
	BEGIN
		PRINT 'THAO TAC THANH CONG!!!'
	END ELSE
	BEGIN 
		PRINT 'Ngay thi cua lan thi sau phai lon hon ngay thi cua lan thi truoc do.'
		ROLLBACK TRANSACTION
	END
END

-- 22. Khi phân công giảng dạy một môn học, phải xét đến thứ tự trước sau giữa các môn học
-- (sau khi học xong những môn học phải học trước mới được học những môn liền sau). 
CREATE TRIGGER ThemSua_GiangDay ON GiangDay
FOR INSERT, UPDATE
AS 
BEGIN
	DECLARE @MaMH VARCHAR(10), @MaLop CHAR(3), @MaGV CHAR(4)

	SELECT @MaLop = MaLop, @MaGV = MaGV, @MaMH = MaMH FROM INSERTED
	
	IF EXISTS (
		SELECT * FROM DIEUKIEN
        LEFT JOIN KETQUATHI
		ON DIEUKIEN.MAMH_TRUOC = KETQUATHI.MaMH AND KETQUATHI.MaHV IN (
			SELECT MaHV FROM HOCVIEN WHERE MaLop = @MaLop
		)
		WHERE DIEUKIEN.MaMH = @MaMH	
	)
	BEGIN 
		PRINT 'Phai hoc het cac mon hoc truoc'
		ROLLBACK TRANSACTION
	END ELSE
	BEGIN 
		PRINT 'THAO TAC THANH CONG!!!'
	END
END

-- 23. Giáo viên chỉ được phân công dạy những môn thuộc khoa giáo viên đó phụ trách.
CREATE TRIGGER ThemSua_PhanCong_GiangDay ON GiangDay
FOR INSERT, UPDATE
AS
BEGIN
	DECLARE @MaKhoaMH VARCHAR(4), @MaMH VARCHAR(10), @MaKhoaGV VARCHAR(4), @MaGV CHAR(4)
	
	SELECT @MaMH = MaMH, @MaGV = MaGV FROM INSERTED
	SELECT @MaKhoaGV = MaKhoa FROM GIAOVIEN WHERE MaGV = @MaGV
	SELECT @MaKhoaMH = MaKhoa FROM MONHOC WHERE MaMH = @MaMH
	
	IF (@MaKhoaGV != @MaKhoaMH)
	BEGIN
		PRINT 'Giao vien chi duoc phan cong day cac mon thuoc khoa giao vien do phu trach'
		ROLLBACK TRANSACTION
	END ELSE
	BEGIN
		PRINT 'THAO TAC THANH CONG!!!'
	END
END
