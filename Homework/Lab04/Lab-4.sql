USE TestSubject;

-- 76. Liệt kê top 3 chuyên gia có nhiều kỹ năng nhất và số lượng kỹ năng của họ.
SELECT HoTen, COUNT(MaKyNang) AS SoLuongKyNang
FROM ChuyenGia_KyNang
JOIN ChuyenGia ON ChuyenGia.MaChuyenGia=ChuyenGia_KyNang.MaChuyenGia
GROUP BY HoTen
ORDER BY COUNT(MaKyNang) DESC;

-- 77. Tìm các cặp chuyên gia có cùng chuyên ngành
-- và số năm kinh nghiệm chênh lệch không quá 2 năm.
SELECT
	a.HoTen AS ChuyenGia1,
	b.HoTen AS ChuyenGia2,
	a.ChuyenNganh
FROM ChuyenGia a
JOIN ChuyenGia b
	ON a.ChuyenNganh=b.ChuyenNganh
	AND a.MaChuyenGia < b.MaChuyenGia
WHERE ABS(a.NamKinhNghiem - b.NamKinhNghiem) <= 2;


-- 78. Hiển thị tên công ty, số lượng dự án và
-- tổng số năm kinh nghiệm của các chuyên gia
-- tham gia dự án của công ty đó.
SELECT CongTy.TenCongTy,
	   COUNT(DISTINCT DuAn.MaDuAn) AS SoLuongDuAn,
	   SUM(NamKinhNghiem) AS TongNamKinhNghiem
FROM CongTy
JOIN DuAn ON DuAn.MaCongTy=CongTy.MaCongTy
JOIN ChuyenGia_DuAn ON ChuyenGia_DuAn.MaDuAn=DuAn.MaDuAn
JOIN ChuyenGia ON ChuyenGia.MaChuyenGia=ChuyenGia_DuAn.MaChuyenGia
GROUP BY CongTy.TenCongTy;

-- 79. Tìm các chuyên gia có ít nhất một kỹ năng cấp độ 5
-- nhưng không có kỹ năng nào dưới cấp độ 3.
SELECT HoTen FROM ChuyenGia
WHERE MaChuyenGia IN (
	SELECT DISTINCT MaChuyenGia FROM ChuyenGia_KyNang
	WHERE CapDo=5
	INTERSECT
	SELECT DISTINCT MaChuyenGia FROM ChuyenGia_KyNang
	WHERE CapDo>=3
);


-- 80. Liệt kê các chuyên gia và số lượng dự án họ tham gia,
-- bao gồm cả những chuyên gia không tham gia dự án nào.
SELECT HoTen, COUNT(MaDuAn) AS SoLuongDuAn
FROM ChuyenGia_DuAn
RIGHT JOIN ChuyenGia
ON ChuyenGia.MaChuyenGia=ChuyenGia_DuAn.MaChuyenGia
GROUP BY HoTen;

-- 81*. Tìm chuyên gia có kỹ năng ở cấp độ cao nhất
-- trong mỗi loại kỹ năng.
WITH RankedSkills AS (
    SELECT 
        ChuyenGia.HoTen,
        KyNang.LoaiKyNang,
        ChuyenGia_KyNang.CapDo,
        ROW_NUMBER() OVER (PARTITION BY KyNang.LoaiKyNang ORDER BY ChuyenGia_KyNang.CapDo DESC) AS Rank
    FROM ChuyenGia
    JOIN ChuyenGia_KyNang ON ChuyenGia.MaChuyenGia = ChuyenGia_KyNang.MaChuyenGia
    JOIN KyNang ON ChuyenGia_KyNang.MaKyNang = KyNang.MaKyNang
)

SELECT HoTen, LoaiKyNang, CapDo
FROM RankedSkills
WHERE Rank = 1;


-- 82. Tính tỷ lệ phần trăm của mỗi chuyên ngành trong tổng số chuyên gia.
WITH SoChuyenNganh AS (
    SELECT ChuyenNganh, COUNT(*) AS SoLuong FROM ChuyenGia
    GROUP BY ChuyenNganh
),
SoChuyenGia AS (
    SELECT COUNT(*) AS Tong FROM ChuyenGia
)
SELECT 
    SoChuyenNganh.ChuyenNganh,
    SoChuyenNganh.SoLuong,
    CAST(SoChuyenNganh.SoLuong AS FLOAT) / SoChuyenGia.Tong * 100 AS PhanTram
FROM SoChuyenNganh, SoChuyenGia;


-- 83. Tìm các cặp kỹ năng thường xuất hiện cùng nhau nhất trong hồ sơ của các chuyên gia.
WITH CapKyNang AS (
    SELECT A.MaKyNang AS MaKyNang1, B.MaKyNang AS MaKyNang2, COUNT(*) AS SoLan
    FROM ChuyenGia_KyNang A
    JOIN ChuyenGia_KyNang B
	ON A.MaChuyenGia = B.MaChuyenGia
	   AND A.MaKyNang < B.MaKyNang
    GROUP BY A.MaKyNang, B.MaKyNang
)
SELECT A.TenKyNang AS MaKyNang1, B.TenKyNang AS MaKyNang2, CapKyNang.SoLan
FROM CapKyNang
JOIN KyNang A ON CapKyNang.MaKyNang1 = A.MaKyNang
JOIN KyNang B ON CapKyNang.MaKyNang2 = B.MaKyNang
ORDER BY CapKyNang.SoLan DESC;


-- 84. Tính số ngày trung bình giữa ngày bắt đầu và ngày kết thúc của các dự án cho mỗi công ty.
SELECT CongTy.TenCongTy, AVG(DATEDIFF(day, DuAn.NgayBatDau, DuAn.NgayKetThuc)) AS TrungBinhSoNgay
FROM CongTy
JOIN DuAn ON CongTy.MaCongTy = DuAn.MaCongTy
GROUP BY CongTy.MaCongTy, CongTy.TenCongTy;

-- 85*. Tìm chuyên gia có sự kết hợp độc đáo nhất của các kỹ năng (kỹ năng mà chỉ họ có).
WITH KyNangDocDao AS (
    SELECT ChuyenGia.MaChuyenGia, ChuyenGia.HoTen, COUNT(*) AS SoKyNangDocDao
    FROM ChuyenGia
    JOIN ChuyenGia_KyNang ON ChuyenGia.MaChuyenGia = ChuyenGia_KyNang.MaChuyenGia
    WHERE ChuyenGia_KyNang.MaKyNang NOT IN (
        SELECT DISTINCT MaKyNang
        FROM ChuyenGia_KyNang
        WHERE MaChuyenGia != ChuyenGia.MaChuyenGia
    )
    GROUP BY ChuyenGia.MaChuyenGia, ChuyenGia.HoTen
)
SELECT HoTen, SoKyNangDocDao
FROM KyNangDocDao
ORDER BY SoKyNangDocDao DESC;

-- 86*. Tạo một bảng xếp hạng các chuyên gia dựa trên số lượng dự án và tổng cấp độ kỹ năng.
WITH SoDuAn AS (
    SELECT MaChuyenGia, COUNT(*) AS SoLuongDuAn FROM ChuyenGia_DuAn
    GROUP BY MaChuyenGia
),
TongCapDo AS (
    SELECT MaChuyenGia, SUM(CapDo) AS TongCapDoKyNang FROM ChuyenGia_KyNang
    GROUP BY MaChuyenGia
)
SELECT 
    RANK() OVER (ORDER BY COALESCE(SoDuAn.SoLuongDuAn, 0) + COALESCE(TongCapDo.TongCapDoKyNang, 0) DESC) AS XepHang,
    ChuyenGia.HoTen
FROM ChuyenGia
LEFT JOIN SoDuAn ON ChuyenGia.MaChuyenGia = SoDuAn.MaChuyenGia
LEFT JOIN TongCapDo ON ChuyenGia.MaChuyenGia = TongCapDo.MaChuyenGia;


-- 87. Tìm các dự án có sự tham gia của chuyên gia từ tất cả các chuyên ngành.
WITH DuAnChuyenNganh AS (
    SELECT MaDuAn, COUNT(DISTINCT ChuyenNganh) AS SoChuyenNganh FROM ChuyenGia_DuAn
    JOIN ChuyenGia ON ChuyenGia_DuAn.MaChuyenGia = ChuyenGia.MaChuyenGia
    GROUP BY MaDuAn
)
SELECT TenDuAn FROM DuAnChuyenNganh
JOIN DuAn ON DuAn.MaDuAN=DuAnChuyenNganh.MaDuAn
WHERE DuAnChuyenNganh.SoChuyenNganh = (
	SELECT COUNT(DISTINCT ChuyenNganh) AS TongSoChuyenNganh
    FROM ChuyenGia
);

-- 88. Tính tỷ lệ thành công của mỗi công ty
-- dựa trên số dự án hoàn thành so với tổng số dự án.
WITH TrangThaiDuAn AS (
    SELECT CongTy.MaCongTy,CongTy.TenCongTy,
		SUM(CASE WHEN DuAn.TrangThai = N'Hoàn thành' THEN 1 ELSE 0 END) AS SoDuAnHoanThanh,
        COUNT(*) AS TongSoDuAn
    FROM CongTy
    LEFT JOIN DuAn ON CongTy.MaCongTy = DuAn.MaCongTy
    GROUP BY CongTy.MaCongTy, CongTy.TenCongTy
)
SELECT 
    TenCongTy,
    (CASE WHEN TongSoDuAn > 0 THEN CAST(SoDuAnHoanThanh AS FLOAT) / TongSoDuAn * 100 ELSE 0 END) AS TyLeThanhCong
FROM TrangThaiDuAn;

-- 89. Tìm các chuyên gia có kỹ năng "bù trừ" nhau
-- (một người giỏi kỹ năng A nhưng yếu kỹ năng B, người kia ngược lại).
WITH SkillLevels AS (
    SELECT 
        CG.MaChuyenGia,
		CGK.MaKyNang,
        ROW_NUMBER() OVER (PARTITION BY CG.MaChuyenGia ORDER BY CGK.CapDo DESC) AS KyNangManh,
        ROW_NUMBER() OVER (PARTITION BY CG.MaChuyenGia ORDER BY CGK.CapDo ASC) AS KyNangYeu
    FROM ChuyenGia CG
    JOIN ChuyenGia_KyNang CGK ON CG.MaChuyenGia = CGK.MaChuyenGia
)
SELECT DISTINCT
    A.MaChuyenGia AS ChuyenGia1,
    B.MaChuyenGia AS ChuyenGia2
FROM SkillLevels A
JOIN SkillLevels B 
    ON A.MaChuyenGia <> B.MaChuyenGia
    AND ((A.KyNangManh = B.KyNangYeu) OR (A.KyNangYeu = B.KyNangManh))
ORDER BY ChuyenGia1, ChuyenGia2;
