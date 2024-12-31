create database Test;
use Test;

create table NhanVien (
	MaNV char(5) not null primary key,
	HoTen varchar(20),
	NgayVL smalldatetime,
	HSLuong numeric(4,2),
	MaPhong char(5),
);

create table PhongBan (
	MaPhong char(5) not null primary key,
	TenPhong varchar(25),
	TruongPhong char(5),
);

create table Xe (
	MaXe char(5) not null,
	LoaiXe varchar(20),
	SoChoNgoi int,
	NamSX int,
);

create table PhanCong (
	MaPC char(5) not null primary key,
	MaNV char(5),
	MaXe char(5),
	NgayDi smalldatetime,
	NgayVe smalldatetime,
	NoiDen varchar(25),
);

set datetimeformat dmy;

alter table NhanVien
add constraint PK_NhanVien_Phong
foreign key (MaPhong) references Phong(MaPhong);

alter table PhongBan
add constraint FK_PhongBan_NhanVien
foreign key (TruongPhong) references NhanVien(MaNV);

alter table PhanCong
add constraint FK_PhanCong_NhanVien
foreign key (MaNV) references NhanVien(MaNV);

alter table PhanCong
add constraint FK_PhanCong_Xe
foreign key (MaXe) references Xe(MaXe);

alter table Xe
add constraint NamSanXuat
check (LoaiXe='Toyota' and NamSX > 2006);

create trigger NgayPhatHanh on PhanCong
for insert, update as
begin
	if exists (
		select * from inserted
		join NhanVien on NhanVien.MaNV=PhanCong.MaNV
		join PhongBan on PhongBan.MaPhong=NhanVien.MaPhong and TenPhong=N'Ngoại thành'
		join Xe on PhanCong.MaXe=Xe.MaXe
		where LoaiXe='Toyota'
	)
	begin
		print('Thao tac thanh cong.')
	end else
	begin
		print('Nhan vien thuoc phong lai xe Ngoai thanh chi duoc phan cong lai xe loai Toyota.')
		rollback transaction
	end
end

select MaNV, HoTen from NhanVien
join PhongBan on PhongBan.MaPhong=NhanVien.MaPhong and TenPhong=N'Nội thành'
join PhanCong on NhanVien.MaNV=PhanCong.MaNV
join Xe on Xe.MaXe=PhanCong.MaXe and SoChoNgoi=4;

select MaNV, Hoten from NhanVien A
where MaNV in (
	select TruongPhong in PhongBan B
) and not exists (
	select * from xe
	where not exists (
		select * from PhanCong AB
		where AB.MaNV=A.MaNV and AB.MaXe=B.MaXe
	)
);


select MaPhong, NV1.MaNV, HoTen
from NhanVien NV1, PhongBan
where NV1.MaPhong=PhongBan.MaPhong and TG1.MaTG in (
	select top 1 with ties NV2.MaNV
	from NhanVien NV2
	join PhanCong PC on PC.MaNV=NV2.MaNV
	join Xe on Xe.MaXe=PC.MaXe
	where NV2.MaPhong = NV1.MaPhong and LoaiXe='Toyota'
    group by NV2.MaNV
    order by COUNT(MaPC) asc;
);

use master;
drop database Test;