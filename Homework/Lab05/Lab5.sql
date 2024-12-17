-- Câu hỏi và ví dụ về Triggers (101-110)

-- 101. Tạo một trigger để tự động cập nhật trường NgayCapNhat trong bảng ChuyenGia
mỗi khi có sự thay đổi thông tin.
ALTER TABLE ChuyenGia
ADD NgayCapNhat DATE;

CREATE TRIGGER Sua_NgayCapNhat ON ChuyenGia
FOR UPDATE AS
BEGIN
	UPDATE ChuyenGia
	SET NgayCapNhat=GETDATE()
	FROM ChuyenGia
	JOIN INSERTED ON ChuyenGia.MaChuyenGia=INSERTED.MaChuyenGia
END

-- 102. Tạo một trigger để ghi log mỗi khi có sự thay đổi trong bảng DuAn.
CREATE TABLE Log_DuAn (
  LogID INT IDENTITY(1,1) PRIMARY KEY,
  MaDuAn INT,
  TenDuAn NVARCHAR(200),
  ActionType NVARCHAR(10),
  ThoiGianThayDoi DATETIME
);

CREATE TRIGGER logThayDoi_DuAn ON DuAn
FOR INSERT, UPDATE, DELETE AS
BEGIN
  DECLARE @MaDuAn INT, @TenDuAn NVARCHAR(200), @ActionType NVARCHAR(10);

  IF EXISTS (SELECT * FROM INSERTED)
  BEGIN
    SELECT @MaDuAn=MaDuAn, @TenDuAn=TenDuAn FROM INSERTED;
    SET @ActionType='INSERT';
    INSERT INTO Log_DuAn (MaDuAn, TenDuAn, ActionType, ThoiGianThayDoi)
    VALUES (@MaDuAn, @TenDuAn, @ActionType, GETDATE());
  END

  IF EXISTS (SELECT * FROM DELETED)
  BEGIN
    SELECT @MaDuAn=MaDuAn, @TenDuAn=TenDuAn FROM DELETED;
    SET @ActionType='UPDATE';
    INSERT INTO Log_DuAn (MaDuAn, TenDuAn, ActionType, ThoiGianThayDoi)
    VALUES (@MaDuAn, @TenDuAn, @ActionType, GETDATE());
  END

  IF EXISTS (SELECT * FROM DELETED)
  BEGIN
    SELECT @MaDuAn=MaDuAn, @TenDuAn=TenDuAn FROM DELETED;
    SET @ActionType='DELETE';
    INSERT INTO Log_DuAn (MaDuAn, TenDuAn, ActionType, ThoiGianThayDoi)
    VALUES (@MaDuAn, @TenDuAn, @ActionType, GETDATE());
  END
END

-- 103. Tạo một trigger để đảm bảo rằng một chuyên gia không thể tham gia vào quá 5 dự án cùng một lúc.
CREATE TRIGGER KiemTra_SoDuAn ON ChuyenGia_DuAn
FOR INSERT AS
BEGIN
	DECLARE @SoDuAn INT, @MaChuyenGia INT

	SELECT @MaChuyenGia=MaChuyenGia FROM INSERTED
	SELECT @SoDuAn=(
		SELECT COUNT(*) FROM ChuyenGia_DuAn 
		WHERE MaChuyenGia=@MaChuyenGia
	)

	IF (@SoDuAn > 5)
	BEGIN
		PRINT 'Mot chuyen gia khong the tham gia vao qua 5 du an cung mot luc'
		ROLLBACK TRANSACTION
	END ELSE
	BEGIN
		PRINT 'Them thanh cong'
	END
END

-- 104. Tạo một trigger để tự động cập nhật số lượng nhân viên trong bảng CongTy mỗi khi có sự thay đổi trong bảng ChuyenGia.
CREATE TRIGGER CapNhat_SoNhanVien ON ChuyenGia
FOR INSERT, DELETE, UPDATE AS
BEGIN
	DECLARE @MaCongTy INT, @MaChuyenGia INT

	IF EXISTS (SELECT * FROM INSERTED)
	BEGIN
		SELECT @MaChuyenGia=MaChuyenGia FROM INSERTED
		SELECT @MaCongTy=DA.MaCongTy FROM ChuyenGia CG
		JOIN ChuyenGiaDuAn CGDA ON CG.MaChuyenGia=CGDA.MaChuyenGia
		JOIN CongTy CT ON CT.MaCongTy=DA.MaCongTy

		UPDATE CongTy
		SET SoNhanVien=SoNhanVien + 1
		WHERE MaCongTy=@MaCongTy
	END

	IF EXISTS (SELECT * FROM DELETED)
		BEGIN
		SELECT @MaChuyenGia=MaChuyenGia from DELETED
		SELECT @MaCongTy=DA.MaCongTy FROM ChuyenGia CG
		JOIN ChuyenGiaDuAn CGDA ON CG.MaChuyenGia=CGDA.MaChuyenGia
		JOIN CongTy CT ON CT.MaCongTy=DA.MaCongTy

		UPDATE CongTy
		SET SoNhanVien=SoNhanVien - 1
		WHERE MaCongTy=@MaCongTy
	END
END 

-- 105. Tạo một trigger để ngăn chặn việc xóa các dự án đã hoàn thành.
CREATE TRIGGER KiemTra_XoaDuAnHoanThanh ON DuAn
FOR DELETE AS
BEGIN
	IF EXISTS (SELECT * FROM DELETED WHERE TrangThai=N'Hoàn thành')
	BEGIN
		PRINT 'Du an nay da hoan thanh, khong the xoa'
		ROLLBACK TRANSACTION
	END ELSE
	BEGIN
		PRINT 'Xoa thanh cong'
	END
END

-- 106. Tạo một trigger để tự động cập nhật cấp độ kỹ năng của chuyên gia khi họ tham gia vào một dự án mới.
CREATE TRIGGER CapNhat_CapDo ON ChuyenGia_KyNang
FOR INSERT, UPDATE AS
BEGIN
	DECLARE @MaChuyenGia INT, @MaKyNang INT, @CapDo INT

	SELECT @MaChuyenGia=MaChuyenGia FROM INSERTED

	DECLARE CUR_CAPDO CURSOR
	FOR 
		SELECT MaKyNang, CapDo FROM ChuyenGia_KyNang
		WHERE MaChuyenGia=@MaChuyenGia

	OPEN CUR_CAPDO
	FETCH NEXT FROM CUR_CAPDO INTO @MaKyNang, @CapDo

	WHILE (@@FETCH_STATUS=0)
	BEGIN 
		SET @CapDo=@CapDo + 1

		UPDATE ChuyenGia_KyNang
		SET CapDo=@CapDo
		WHERE MaKyNang=@MaKyNang AND MaChuyenGia=@MaChuyenGia

		FETCH NEXT FROM CUR_CAPDO
		INTO @MaKyNang, @CapDo
	END

	CLOSE CUR_CAPDO
	DEALLOCATE CUR_CAPDO
END

-- 107. Tạo một trigger để ghi log mỗi khi có sự thay đổi cấp độ kỹ năng của chuyên gia.
CREATE TABLE Log_CapDoKyNang (
  LogID INT IDENTITY(1,1) PRIMARY KEY,
  MaChuyenGia INT,
  MaKyNang INT,
  CapDoCu INT,
  CapDoMoi INT,
  ThoiGianThayDoi DATE
);

CREATE TRIGGER LOG_CapDo_KyNang ON ChuyenGia_KyNang
FOR UPDATE AS
BEGIN
	DECLARE @MaChuyenGia INT, @MaKyNang INT, @CapDoCu INT, @CapDoMoi INT

	SELECT @MaChuyenGia=MaChuyenGia, @MaKyNang=MaKyNang, @CapDoCu=CapDo FROM DELETED
	SELECT @CapDoMoi=CapDo FROM INSERTED

	IF (@CapDoMoi <> @CapDoCu)
	BEGIN
		INSERT INTO Log_CapDoKyNang(MaChuyenGia, MaKyNang, CapDoCu, CapDoMoi, ThoiGianThayDoi)
		VALUES(@MaChuyenGia, @MaKyNang, @CapDoCu, @CapDoMoi, GETDATE() )
	END
END

-- 108. Tạo một trigger để đảm bảo rằng ngày kết thúc của dự án luôn lớn hơn ngày bắt đầu.
CREATE TRIGGER ThemSua_NgayDuAn ON DuAn
FOR INSERT, UPDATE AS 
BEGIN
	DECLARE @MaDuAn INT, @NgayBatDau DATE, @NgayKetThuc DATE

	SELECT @MaDuAn=MaDuAn FROM INSERTED
	SELECT @NgayBatDau=NgayBatDau, @NgayKetThuc=NgayKetThuc FROM DuAn
	WHERE MaDuAn=@MaDuAn

	IF (@NgayBatDau >= @NgayKetThuc)
	BEGIN 
		PRINT 'Ngay ket thuc phai lon hon ngay bat dau'
		ROLLBACK TRANSACTION
	END ELSE
	BEGIN
		PRINT 'Thao tac thanh cong'
	END
END 

-- 109. Tạo một trigger để tự động xóa các bản ghi liên quan trong bảng ChuyenGia_KyNang khi một kỹ năng bị xóa.
CREATE TRIGGER Xoa_KyNang ON KyNang
FOR DELETE AS
BEGIN
	DELETE FROM ChuyenGia_KyNang
	WHERE MaKyNang IN (SELECT MaKyNang FROM DELETED)
END

-- 110. Tạo một trigger để đảm bảo rằng một công ty không thể có quá 10 dự án đang thực hiện cùng một lúc.
CREATE TRIGGER KiemTra_SoDuAnQua10 ON DuAn
FOR INSERT, UPDATE AS
BEGIN
	DECLARE @SoDuAn INT, @MaCongTy INT

	SELECT @MaCongTy=MaCongTy FROM INSERTED
	SELECT @SoDuAn=(
		SELECT COUNT(*) FROM DuAn
		WHERE MaCongTy=@MaCongTy AND TrangThai=N'Đang thực hiện'
	)

	IF (@SoDuAn > 10)
	BEGIN
		PRINT 'Mot cong ty khong the co cung luc qua 10 du an dang thuc hien'
		ROLLBACK TRANSACTION
	END ELSE
	BEGIN
		PRINT 'Thao tac thanh cong'
	END
END

-- Câu hỏi và ví dụ về Triggers bổ sung (123-135)

-- 123. Tạo một trigger để tự động cập nhật lương của chuyên gia dựa trên cấp độ kỹ năng và số năm kinh nghiệm.
ALTER TABLE ChuyenGia
ADD Luong MONEY;

CREATE TRIGGER CapNhat_Luong ON ChuyenGia
FOR INSERT, UPDATE AS
BEGIN
	DECLARE @MaChuyenGia INT, @CapDo INT, @NamKinhNghiem INT, @Luong money

	SELECT @MaChuyenGia=MaChuyenGia FROM INSERTED

	SELECT @NamKinhNghiem=NamKinhNghiem FROM ChuyenGia
	WHERE MaChuyenGia=@MaChuyenGia

	SELECT @CapDo=(SELECT MAX(CapDo) FROM ChuyenGia_KyNang
	WHERE MaChuyenGia=@MaChuyenGia)

	SET @Luong=@CapDo * 5000 + @NamKinhNghiem * 3000

	UPDATE ChuyenGia
	SET Luong=@Luong
	WHERE MaChuyenGia=@MaChuyenGia
END

-- 124. Tạo một trigger để tự động gửi thông báo khi một dự án sắp đến hạn (còn 7 ngày).
CREATE TRIGGER KiemTraThoiHanDuAn ON DuAn
FOR INSERT, UPDATE AS
BEGIN
	DECLARE @MaDuAn INT, @NoiDung nvarchar(255), @NgayKetThuc DATE

	DECLARE CUR_NgayKetThuc cursor
	FOR (SELECT MaDuAn, NgayKetThuc FROM DuAn)

	OPEN CUR_NgayKetThuc
	FETCH NEXT FROM CUR_NgayKetThuc INTO @MaDuAn, @NgayKetThuc

	WHILE (@@FETCH_STATUS =0)
	BEGIN
		IF (DATEDIFF(DAY, GETDATE(), @NgayKetThuc) <= 7)
		BEGIN
			INSERT INTO ThongBao(MaDuAn, NoiDung)
			VALUES(@MaDuAn, 'Du an sap den han ket thuc!')
		END

		FETCH NEXT FROM CUR_NgayKetThuc INTO @MaDuAn, @NgayKetThuc
	END

	CLOSE CUR_NgayKetThuc
	DEALLOCATE CUR_NgayKetThuc
END

-- Tạo bảng ThongBao nếu chưa có
CREATE TABLE ThongBao (
  MaThongBao INT IDENTITY(1,1) PRIMARY KEY,
  MaDuAn INT,
  NoiDung NVARCHAR(255),
  NgayThongBao DATETIME DEFAULT GETDATE()
);

-- 125. Tạo một trigger để ngăn chặn việc xóa hoặc cập nhật thông tin của chuyên gia đang tham gia dự án.
CREATE TRIGGER KiemTra_XoaChuyenGia ON ChuyenGia
FOR DELETE, UPDATE AS 
BEGIN
	DECLARE @MaChuyenGia INT 

	SELECT @MaChuyenGia=MaChuyenGia FROM DELETED

	IF EXISTS (
		SELECT * FROM ChuyenGia_DuAn
		WHERE MaChuyenGia=@MaChuyenGia
	)
	BEGIN
		PRINT 'Chuyen gia dang tham gia du an, khong the xoa'
		ROLLBACK TRANSACTION
	END ELSE
	BEGIN
		PRINT 'Xoa thanh cong'
	END
END 

-- 126. Tạo một trigger để tự động cập nhật số lượng chuyên gia trong mỗi chuyên ngành.
CREATE TRIGGER CapNhat_SoLuongChuyenGia ON ChuyenGia
FOR UPDATE, DELETE, INSERT
AS
BEGIN
	DELETE FROM ThongKeChuyenNganh
	INSERT INTO ThongKeChuyenNganh(ChuyenNganh, SoLuongChuyenGia) 

	SELECT ChuyenNganh, COUNT(*) AS SoLuongChuyenGia FROM ChuyenGia
	GROUP BY ChuyenNganh
END

-- Tạo bảng ThongKeChuyenNganh nếu chưa có
CREATE TABLE ThongKeChuyenNganh (
  ChuyenNganh NVARCHAR(50) PRIMARY KEY,
  SoLuongChuyenGia INT DEFAULT 0
);

-- 127. Tạo một trigger để tự động tạo bản sao lưu của dự án khi nó được đánh dấu là hoàn thành.
CREATE TRIGGER SaoLuu_DuAnHoanThanh ON DuAn
FOR INSERT, UPDATE AS
BEGIN
	DECLARE  @MaDuAn INT, @TenDuAn NVARCHAR(200), @MaCongTy INT, @NgayBatDau DATE, @NgayKetThuc DATE, @TrangThai NVARCHAR(50)

	SELECT @TrangThai=TrangThai FROM INSERTED

	IF (@TrangThai=N'Hoàn thành')
	BEGIN
		SELECT @TenDuAn=TenDuAn, @MaCongTy=MaCongTy, @NgayBatDau=NgayBatDau, @NgayKetThuc=NgayKetThuc, @TrangThai=TrangThai
		FROM INSERTED

		INSERT INTO DuAnHoanThanh (MaDuAn, TenDuAn, MaCongTy, NgayBatDau, NgayKetThuc, TrangThai)
		VALUES(@MaDuAn, @TenDuAn, @MaCongTy, @NgayBatDau, @NgayKetThuc, @TrangThai)
	END
END 

-- Tạo bảng DuAnHoanThanh nếu chưa có
CREATE TABLE DuAnHoanThanh (
  MaDuAn INT PRIMARY KEY,
  TenDuAn NVARCHAR(200),
  MaCongTy INT,
  NgayBatDau DATE,
  NgayKetThuc DATE,
  TrangThai NVARCHAR(50),
  FOREIGN KEY (MaCongTy) REFERENCES CongTy(MaCongTy)
);

-- 128. Tạo một trigger để tự động cập nhật điểm đánh giá trung bình của công ty dựa trên điểm đánh giá của các dự án.
ALTER TABLE CongTy
ADD DiemDanhGiaTB DECIMAL(5, 2) DEFAULT 0

ALTER TABLE DuAn
ADD DiemDanhGia DECIMAL(5, 2) DEFAULT 0

CREATE TRIGGER capNhatDanhGiaCongTy ON DuAn
FOR INSERT, UPDATE, DELETE AS
BEGIN
	UPDATE CongTy
	SET DiemDanhGiaTB=(
		SELECT ISNULL(AVG(DiemDanhGia),0) FROM DuAn DA WHERE DA.MaCongTy=CongTy.MaCongTy
	)
	WHERE MaCongTy IN (
		SELECT DISTINCT MaCongTy FROM INSERTED
		UNION
		SELECT DISTINCT MaCongTy FROM DELETED
	)
END

-- 129. Tạo một trigger để tự động phân công chuyên gia vào dự án dựa trên kỹ năng và kinh nghiệm.
CREATE TRIGGER phancong_ChuyenGia ON DuAn
FOR INSERT
AS
BEGIN
	DECLARE @MaDuAn INT, @ChuyenNganh NVARCHAR(50)

	DECLARE CUR_DUAN CURSOR
	FOR (
		SELECT MaDuAn, LinhVuc FROM DuAn DA JOIN CongTy CT ON DA.MaCongTy=CT.MaCongTy
		WHERE MaDuAn IN (SELECT MaDuAn FROM INSERTED)
	)

	OPEN CUR_DUAN
	FETCH NEXT FROM CUR_DUAN INTO @MaDuAn, @ChuyenNganh

	WHILE (@@FETCH_STATUS=0)
	BEGIN
		INSERT INTO ChuyenGia_DuAn(MaChuyenGia, MaDuAn, VaiTro)

		SELECT TOP 5 CG.MaChuyenGia, @MaDuAn, N'Chuyen gia ' + @ChuyenNganh
		FROM ChuyenGia CG JOIN ChuyenGia_KyNang CGKN ON CG.MaChuyenGia=CGKN.MaChuyenGia
		WHERE ChuyenNganh=@ChuyenNganh AND NOT EXISTS(
			SELECT * FROM ChuyenGia_DuAn CGDA
			WHERE CGDA.MaChuyenGia=CG.MaChuyenGia AND CGDA.MaDuAn=@MaDuAn
		)
		ORDER BY CapDo DESC, NamKinhNghiem DESC

		FETCH NEXT FROM CUR_DUAN INTO @MaDuAn, @ChuyenNganh
	END

	CLOSE CUR_DUAN
	DEALLOCATE CUR_DUAN
END

-- 130. Tạo một trigger để tự động cập nhật trạng thái "bận" của chuyên gia khi họ được phân công vào dự án mới.
ALTER TABLE ChuyenGia
ADD TrangThai NVARCHAR(50)

CREATE TRIGGER CapNhat_TrangThaiChuyenGia ON ChuyenGia_DuAn
FOR INSERT, UPDATE AS
BEGIN
	DECLARE @MaChuyenGia INT

	SELECT @MaChuyenGia=MaChuyenGia FROM INSERTED

	UPDATE ChuyenGia
	SET TrangThai=N'Bận'
	WHERE MaChuyenGia=@MaChuyenGia
END

-- 131. Tạo một trigger để ngăn chặn việc thêm kỹ năng trùng lặp cho một chuyên gia.
CREATE TRIGGER KiemTra_ThemKyNang ON ChuyenGia_KyNang
FOR INSERT AS
BEGIN
	DECLARE @MaChuyenGia INT, @MaKyNang INT

	SELECT @MaChuyenGia=MaChuyenGia, @MaKyNang=MaKyNang FROM INSERTED

	IF EXISTS(
		SELECT * FROM ChuyenGia_KyNang
		WHERE MaChuyenGia=@MaChuyenGia AND MaKyNang=@MaKyNang
	)
	BEGIN 
		PRINT 'Ky nang nay chuyen gia da co roi!'
		ROLLBACK TRANSACTION
	END ELSE
	BEGIN
		PRINT 'Them thanh cong'
	END
END 

-- 132. Tạo một trigger để tự động tạo báo cáo tổng kết khi một dự án kết thúc.
CREATE TABLE BaoCao (
  MaBaoCao INT IDENTITY(1,1) PRIMARY KEY,
  MaDuAn INT,
  TenDuAn NVARCHAR(200),
  NgayKetThuc DATE,
  TrangThai NVARCHAR(50),
  NoiDung NVARCHAR(255),
  NgayBaoCao DATETIME DEFAULT GETDATE()
);

CREATE TRIGGER KiemTra_DuAnKetThuc ON DuAn
FOR INSERT, UPDATE AS 
BEGIN
	DECLARE @MaDuAn INT, @TenDuAn INT, @NgayKetThuc date, @TrangThai nvarchar(50), @NoiDung nvarchar(255)

	DECLARE CUR_DUAN CURSOR
	FOR (
		SELECT MaDuAn, TenDuAn, NgayKetThuc, TrangThai FROM INSERTED
		WHERE TrangThai=N'Hoàn thành'
	)

	OPEN CUR_DUAN
	FETCH NEXT FROM CUR_DUAN INTO @MaDuAn, @TenDuAn, @NgayKetThuc, @TrangThai

	WHILE (@@FETCH_STATUS=0)
	BEGIN
		INSERT INTO BaoCao(MaDuAn, TenDuAn, NgayKetThuc, TrangThai, NoiDung)
		VALUES (@MaDuAn, @TenDuAn, @NgayKetThuc, @TrangThai, 'Da hoan thanh xong')

		FETCH NEXT FROM CUR_DUAN INTO @MaDuAn, @TenDuAn, @NgayKetThuc, @TrangThai
	END
END

-- 133. Tạo một trigger để tự động cập nhật thứ hạng của công ty dựa trên số lượng dự án hoàn thành và điểm đánh giá.
ALTER TABLE CongTy
ADD ThuHang INT DEFAULT NULL

ALTER TABLE CongTy
ADD SoDuAnHoanThanh INT DEFAULT 0

CREATE TRIGGER CapNhat_ThuHang ON DuAn
FOR INSERT, UPDATE, DELETE AS 
BEGIN
	UPDATE CongTy 
	SET SoDuAnHoanThanh=(
		SELECT COUNT(*) FROM DuAn WHERE TrangThai=N'Hoàn thành' AND CongTy.MaCongTy=DuAn.MaCongTy
	),
	DiemDanhGiaTB=ISNULL((SELECT AVG(DiemDanhGia) FROM DuAn WHERE DuAn.MaCongTy=CongTy.MaCongTy AND TrangThai=N'Hoàn thành'), 0);

	WITH RankCongTy AS (
		SELECT MaCongTy, RANK () OVER (ORDER BY SoDuAnHoanThanh DESC, DiemDanhGiaTB DESC) AS RankMoi
		FROM CongTy
	)

	UPDATE CongTy
	SET ThuHang=RankMoi
	FROM CongTy CT JOIN RankCongTy ON CT.MaCongTy=RankCongTy.MaCongTy
END

-- 134. Tạo một trigger để tự động gửi thông báo khi một chuyên gia được thăng cấp (dựa trên số năm kinh nghiệm).
CREATE TABLE ThongBaoChuyenGia (
  MaThongBao INT IDENTITY PRIMARY KEY,
  MaChuyenGia INT,
  ThongDiep NVARCHAR(200),
  NgayThongBao DATETIME DEFAULT GETDATE()
)

CREATE TRIGGER KiemTra_ThangCap	ON ChuyenGia
FOR UPDATE AS
BEGIN
	INSERT INTO ThongBaoChuyenGia(MaChuyenGia, ThongDiep)

	SELECT INSERTED.MaChuyenGia, N'Chuyen gia ' + INSERTED.HoTen + N' duoc thang cap do co ' + CAST(INSERTED.NamKinhNghiem AS nvarchar(10))+ N' nam kinh nghiem'
	FROM INSERTED
	JOIN DELETED ON INSERTED.MaChuyenGia=DELETED.MaChuyenGia
	WHERE INSERTED.NamKinhNghiem >= 10 AND DELETED.NamKinhNghiem < 10
END

-- 135. Tạo một trigger để tự động cập nhật trạng thái "khẩn cấp" cho dự án khi thời gian còn lại ít hơn 10% tổng thời gian dự án.
CREATE TRIGGER KiemTra_KhanCapDuAn ON DuAn
FOR INSERT, UPDATE AS
BEGIN
	DECLARE @MaDuAn INT, @NgayBatDau DATE, @NgayKetThuc DATE, @TongThoiGian INT, @ThoiGianConLai INT

	DECLARE CUR_ThoiGian CURSOR	
	FOR (
		SELECT MaDuAn, NgayBatDau, NgayKetThuc FROM DuAn
	)

	OPEN CUR_ThoiGian
	FETCH NEXT FROM CUR_ThoiGian INTO @MaDuan, @NgayBatDau, @NgayKetThuc

	WHILE (@@FETCH_STATUS=0)
	BEGIN
		SET @TongThoiGian=DATEDIFF(day, @NgayBatDau, @NgayKetThuc)
		SET @ThoiGianConLai=DATEDIFF(day, GETDATE(), @NgayKetThuc)

		IF (@ThoiGianConLai > 0 AND @ThoiGianConLai <= (@TongThoiGian * 0.1))
		BEGIN
			UPDATE DuAn
			SET TrangThai=N'Khẩn cấp'
			WHERE MaDuAn=@MaDuAn
		END

		FETCH NEXT FROM CUR_ThoiGian INTO @MaDuAn, @NgayBatDau, @NgayKetThuc
	END

	CLOSE CUR_ThoiGian
	DEALLOCATE CUR_ThoiGian
END

-- 136. Tạo một trigger để tự động cập nhật số lượng dự án đang thực hiện của mỗi chuyên gia.
ALTER TABLE ChuyenGia
ADD SoLuongDuAnDangThucHien INT;

CREATE TRIGGER CapNhatSoDuAn ON ChuyenGia_DuAn
FOR INSERT, DELETE AS 
BEGIN
	UPDATE ChuyenGia 
	SET SoLuongDuAnDangThucHien=(
		SELECT COUNT(*) FROM ChuyenGia_DuAn CGDA JOIN DuAn DA ON DA.MaDuAn=CGDA.MaDuAn
		WHERE TrangThai=N'Đang thực hiện' AND ChuyenGia.MaChuyenGia=CGDA.MaChuyenGia
	)
	WHERE MaChuyenGia IN (
		SELECT MaChuyenGia FROM INSERTED
		UNION	
		SELECT MaChuyenGia FROM DELETED
	)
END

-- 137. Tạo một trigger để tự động tính toán và cập nhật tỷ lệ thành công của công ty dựa trên số dự án hoàn thành và tổng số dự án.
ALTER TABLE CongTy
ADD TyLeThanhCong DECIMAL(5, 2) DEFAULT 0

CREATE TRIGGER CapNhat_TyLeThanhCong ON DuAn
FOR INSERT, UPDATE, DELETE AS
BEGIN
	DECLARE @TongDuAn DECIMAL(5,2), @SoDuAnHoanThanh DECIMAL(5,2), @MaCongTy INT

	IF EXISTS (SELECT * FROM INSERTED)
	BEGIN
		SELECT @MaCongTy=MaCongTy FROM INSERTED
	END

	IF EXISTS (SELECT * FROM DELETED)
	BEGIN
		SELECT @MaCongTy=MaCongTy FROM DELETED
	END

	SET @TongDuAn=(SELECT COUNT(*) FROM DuAn WHERE MaCongTy=@MaCongTy)
	IF (@TongDuAn =0)
	BEGIN
		SET @SoDuAnHoanThanh=0
	END ELSE
	BEGIN
		SET @SoDuAnHoanThanh=(SELECT COUNT(*) FROM DuAn WHERE MaCongTy=@MaCongTy AND TrangThai=N'Hoàn thành')
		UPDATE CongTy 
		SET TyLeThanhCong=@TongDuAn / @SoDuAnHoanThanh * 100
		WHERE MaCongTy=@MaCongTy 
	END
END

-- 138. Tạo một trigger để tự động ghi log mỗi khi có thay đổi trong bảng lương của chuyên gia.
CREATE TABLE LogLuongChuyenGia (
  LogID INT IDENTITY(1,1) PRIMARY KEY,
  MaChuyenGia INT,
  LuongCu MONEY,
  LuongMoi MONEY,
  NgayDoi DATETIME DEFAULT GETDATE(),
  HanhDong NVARCHAR(50)
); 

CREATE TRIGGER KiemTraLuong ON ChuyenGia
FOR UPDATE, INSERT AS
BEGIN
	DECLARE @MaChuyenGia INT, @LuongCu money, @LuongMoi money, @HanhDong nvarchar(50)

	IF EXISTS (SELECT * FROM DELETED)
	BEGIN
		SET @HanhDong='UPDATE'
		SELECT @MaChuyenGia=MaChuyenGia, @LuongMoi=Luong FROM INSERTED
		SELECT @LuongCu=Luong	FROM DELETED
		INSERT INTO LogLuongChuyenGia (MaChuyenGia, LuongCu, LuongMoi, HanhDong)
		VALUES(@MaChuyenGia, @LuongCu, @LuongMoi, @HanhDong)
	END ELSE
	BEGIN
		SET @HanhDong='INSERT'
		SELECT @MaChuyenGia=MaChuyenGia, @LuongMoi=Luong FROM INSERTED
		INSERT INTO LogLuongChuyenGia (MaChuyenGia, LuongMoi, HanhDong)
		VALUES(@MaChuyenGia, @LuongMoi, @HanhDong)
	END
END

-- 139. Tạo một trigger để tự động cập nhật số lượng chuyên gia cấp cao trong mỗi công ty.
ALTER TABLE CongTy
ADD SoChuyenGiaCapCao INT DEFAULT 0

CREATE TRIGGER CapNhat_SoChuyenGiaCapCao ON ChuyenGia
FOR INSERT, UPDATE, DELETE AS
BEGIN
	UPDATE CongTy 
	SET SoChuyenGiaCapCao=(
		SELECT COUNT(*) FROM ChuyenGia CG
		JOIN ChuyenGia_DuAn CGDA ON CG.MaChuyenGia=CGDA.MaChuyenGia
		JOIN DuAn DA ON DA.MaDuAn=CGDA.MaDuAn
		WHERE CG.NamKinhNghiem > 8 AND CongTy.MaCongTy=DA.MaCongTy
	)
	WHERE MaCongTy IN (
		SELECT CT.MaCongTy FROM CongTy CT
		JOIN DuAn DA ON DA.MaCongTy=CT.MaCongTy
		JOIN ChuyenGia_DuAn CGDA ON CGDA.MaDuAn=DA.MaDuAn
		JOIN INSERTED i ON i.MaChuyenGia=CGDA.MaChuyenGia
		UNION
		SELECT CT.MaCongTy FROM CongTy CT
		JOIN DuAn DA ON DA.MaCongTy=CT.MaCongTy
		JOIN ChuyenGia_DuAn CGDA ON CGDA.MaDuAn=DA.MaDuAn
		JOIN DELETED d ON d.MaChuyenGia=CGDA.MaChuyenGia
	)
END

-- 140. Tạo một trigger để tự động cập nhật trạng thái "cần bổ sung nhân lực" cho dự án khi số lượng chuyên gia tham gia ít hơn yêu cầu.
ALTER TABLE DuAn
ADD SoLuongNhanVienYeuCau INT;

CREATE TRIGGER KiemTra_TrangThaiNhanLuc ON ChuyenGia_DuAn
FOR DELETE, INSERT AS
BEGIN
	UPDATE DuAn
	SET TrangThai=CASE WHEN (
		SELECT COUNT(*) FROM ChuyenGia_DuAn
		WHERE MaDuAn=DuAn.MaDuAn) < DuAn.SoLuongNhanVienYeuCau
	
		THEN N'Cần bổ sung nhân lực'
		END
		WHERE MaDuAn IN (
			SELECT DISTINCT MaDuAn FROM INSERTED
			UNION 
			SELECT DISTINCT MaDuAn FROM DELETED
		)
END


