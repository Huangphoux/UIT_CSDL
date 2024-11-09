USE QuanLyBanHang;

-- 19. Có bao nhiêu hóa đơn không phải của khách hàng đăng ký thành viên mua? 
SELECT COUNT(*) AS SoHoaDon
FROM HOADON
WHERE MaKH NOT IN (
	SELECT MaKH FROM KHACHHANG
	WHERE KHACHHANG.MAKH = HOADON.MAKH
);

-- 20. Có bao nhiêu sản phẩm khác nhau được bán ra trong năm 2006.
SELECT COUNT(MaSP) AS SoSanPham
FROM SANPHAM
WHERE MaSP IN (
	SELECT DISTINCT MaSP FROM CTHD
	JOIN HoaDon ON HoaDon.SoHD=CTHD.SoHD
	WHERE YEAR(NgHD)=2006
);

-- 21. Cho biết trị giá hóa đơn cao nhất, thấp nhất là bao nhiêu? 
SELECT MAX(TriGia) AS MaxTriGia, MIN(TriGia) AS MinTriGia
FROM HoaDon;

-- 22. Trị giá trung bình của tất cả các hóa đơn được bán ra trong năm 2006 là bao nhiêu?
SELECT AVG(TriGia) AS TriGiaTrungBinh FROM HoaDon
WHERE YEAR(NgHD)=2006;

-- 23. Tính doanh thu bán hàng trong năm 2006. 
SELECT SUM(TriGia) AS DoanhThu FROM HoaDon
WHERE YEAR(NgHD)=2006;


-- 24. Tìm số hóa đơn có trị giá cao nhất trong năm 2006. 
SELECT TOP 1 SoHD FROM HoaDon
WHERE YEAR(NgHD)=2006
GROUP BY SoHD, TriGia
ORDER BY TriGia DESC;


-- 25. Tìm họ tên khách hàng đã mua hóa đơn có trị giá cao nhất trong năm 2006. 
SELECT HoTen FROM KHACHHANG
JOIN HoaDon ON KhachHang.MaKH=HoaDon.MaKH
WHERE YEAR(NgHD)=2006 AND TriGia = (
	SELECT MAX(TriGia) FROM HoaDon
);

-- 26. In ra danh sách 3 khách hàng (MAKH, HOTEN) có doanh số cao nhất. 
SELECT TOP 3 HoTen FROM KHACHHANG
ORDER BY DoanhSo DESC;


-- 27. In ra danh sách các sản phẩm (MASP, TENSP) có giá bán bằng 1 trong 3 mức giá cao nhất. 
SELECT MaSP, TenSP FROM SanPham
WHERE Gia IN (
	SELECT DISTINCT TOP 3 Gia FROM SanPham
	ORDER BY Gia DESC
);

-- 28. In ra danh sách các sản phẩm (MASP, TENSP) do “Thai Lan” sản xuất có giá bằng 1 trong 3 mức 
-- giá cao nhất (của tất cả các sản phẩm). 
SELECT MaSP, TenSP FROM SanPham
WHERE NuocSX='Thai Lan' AND Gia IN (
	SELECT DISTINCT TOP 3 Gia FROM SanPham
	ORDER BY Gia DESC
);

-- 29. In ra danh sách các sản phẩm (MASP, TENSP) do “Trung Quoc” sản xuất có giá bằng 1 trong 3 mức 
-- giá cao nhất (của sản phẩm do “Trung Quoc” sản xuất). 
SELECT MaSP, TenSP FROM SanPham
WHERE NuocSX='Trung Quoc' AND Gia IN (
	SELECT DISTINCT TOP 3 Gia FROM SanPham
	WHERE NuocSX='Trung Quoc'
	ORDER BY Gia DESC
);

-- 30. * In ra danh sách 3 khách hàng có doanh số cao nhất (sắp xếp theo kiểu xếp hạng).
SELECT TOP 3 MAKH, HOTEN, RANK() OVER (ORDER BY DOANHSO DESC) RANK_KH
FROM KHACHHANG

-- 31. Tính tổng số sản phẩm do “Trung Quoc” sản xuất. 
SELECT COUNT(MaSP) AS SoSP FROM SanPham
WHERE NuocSX='Trung Quoc';

-- 32. Tính tổng số sản phẩm của từng nước sản xuất.
SELECT NuocSX, COUNT(MaSP) AS SoSP FROM SanPham
GROUP BY NuocSX;


-- 33. Với từng nước sản xuất, tìm giá bán cao nhất, thấp nhất, trung bình của các sản phẩm.
SELECT NuocSX, Max(Gia) AS GiaBanCaoNhat, Min(Gia) AS GiaBanThapNhat, Avg(Gia) AS GiaBanTrungBinh
FROM SanPham
GROUP BY NuocSX;


-- 34. Tính doanh thu bán hàng mỗi ngày. 
SELECT NGHD, SUM(TriGia) AS DoanhThu FROM HOADON
GROUP BY NgHD;

-- 35. Tính tổng số lượng của từng sản phẩm bán ra trong tháng 10/2006. 
SELECT MaSP, SUM(SL) AS TongSoLuong
FROM CTHD
JOIN HoaDON ON HoaDon.SoHD=CTHD.SoHD
WHERE MONTH(NgHD)=10 AND YEAR(NgHD)=2006
GROUP BY MaSP;

-- 36. Tính doanh thu bán hàng của từng tháng trong năm 2006. 
SELECT MONTH(NGHD) AS THANG, SUM(TRIGIA) AS DOANHTHU
FROM HOADON 
WHERE YEAR(NGHD)=2006
GROUP BY MONTH(NGHD);

-- 37. Tìm hóa đơn có mua ít nhất 4 sản phẩm khác nhau. 
SELECT SOHD FROM CTHD
GROUP BY SOHD 
HAVING COUNT(DISTINCT MASP) >= 4;

-- 38. Tìm hóa đơn có mua 3 sản phẩm do “Viet Nam” sản xuất (3 sản phẩm khác nhau). 
SELECT SOHD FROM CTHD, SanPham
WHERE CTHD.MaSP=SanPham.MaSP AND NuocSX='Viet Nam'
GROUP BY SOHD
HAVING COUNT(DISTINCT CTHD.MASP) >= 3;

-- 39. Tìm khách hàng (MAKH, HOTEN) có số lần mua hàng nhiều nhất.  
SELECT TOP 1 KhachHang.MaKH, HoTen
FROM KhachHang, HoaDon
WHERE KhachHang.MaKH=HoaDon.MaKH
GROUP BY KhachHang.MaKH, HoTen
ORDER BY COUNT(SoHD) DESC;

-- 40. Tháng mấy trong năm 2006, doanh số bán hàng cao nhất ? 
SELECT TOP 1 WITH TIES MONTH(NgHD) AS Thang
FROM HoaDon
GROUP BY MONTH(NgHD)
ORDER BY SUM(TriGia) DESC;

-- 41. Tìm sản phẩm (MASP, TENSP) có tổng số lượng bán ra thấp nhất trong năm 2006. 
SELECT TOP 1 WITH TIES SanPham.MaSP, TenSP
FROM SanPham
JOIN CTHD ON CTHD.MaSP=SanPham.MaSP
JOIN HoaDON ON HoaDon.SoHD=CTHD.SoHD AND YEAR(NgHD)=2006
GROUP BY SanPham.MaSP, TenSP
ORDER BY SUM(SL);

-- 42. *Mỗi nước sản xuất, tìm sản phẩm (MASP,TENSP) có giá bán cao nhất. 
SELECT NUOCSX, MASP, TENSP FROM (
	SELECT NUOCSX, MASP, TENSP, GIA,
		   RANK() OVER (PARTITION BY NUOCSX ORDER BY GIA DESC) RANK_GIA
	FROM SANPHAM
) AS A 
WHERE RANK_GIA = 1

-- 43. Tìm nước sản xuất sản xuất ít nhất 3 sản phẩm có giá bán khác nhau. 
SELECT NUOCSX FROM SANPHAM 
GROUP BY NUOCSX
HAVING COUNT(DISTINCT GIA) >= 3

-- 44. *Trong 10 khách hàng có doanh số cao nhất, tìm khách hàng có số lần mua hàng nhiều nhất.
SELECT TOP 1 Top10.MaKH, HoTen
FROM (SELECT TOP 10 MaKH, HoTen FROM KhachHang
	  ORDER BY DoanhSo DESC)
	  AS Top10, HoaDon
WHERE Top10.MaKH=HoaDon.MaKH
GROUP BY Top10.MaKH, HoTen
ORDER BY COUNT(SoHD) DESC
