create database Test
use Test

create table KhachHang (
	MaKH char(5) not null primary key,
	HoTen varchar(30),
	DiaChi varchar(30),
	SoDT varchar(15),
	LoaiKH varchar(10),
)

create table Bang_Dia (
	MaBD char(5) not null primary key,
	TenBD varchar(25),
	TheLoai varchar(25),
)

create table PhieuThue (
	MaPT char(5) not null primary key,
	MaKH char(5),
	NgayThue smalldatetime,
	NgayTra smalldatetime,
	SoLuongThue int,
)

create table ChiTiet_PM (
	MaPT char(5) not null,
	MaBD char(5) not null,
)

alter table ChiTiet_PM
add constraint PK_ChiTiet
primary key (MaPT, MaBD)

alter table PhieuThue
add constraint FK_PT_KH
foreign key (MaKH) references KhachHang(MaKH)


alter table ChiTiet_PM
add constraint FK_CT_PT
foreign key (MaPT) references PhieuThue(MaPT)


alter table ChiTiet_PM
add constraint FK_CT_BD
foreign key (MaBD) references Bang_Dia(MaBD)


alter table Bang_Dia
add constraint TheLoaiBangDia
check (TheLoai in (
	N'ca nhạc',
	N'phim hành động',
	N'phim tình cảm',
	N'phim hoạt hình')
)

create trigger TRG_ChiKHVIP on PhieuThue
for insert, update as
begin
	if exists (
		select * from inserted i, KhachHang KH
		where SoLuongThue > 5 and i.MaKH=KH.MaKH
		and LoaiKH='VIP'
	)
	begin
		print('Chi khach hang VIP moi thue duoc 5 bang dia.')
		rollback transaction
	end else
	begin
		print('Thao tac thanh cong')
	end
end

select MaKH, HoTen from KhachHang
where MaKH in (
	select MaKH from PhieuThue PT, ChiTiet_PM CT
	where SoLuongThue>3 and PT.MaPT=CT.MaPT
	and MaBD in (
		select MaBD from Bang_Dia
		where TheLoai=N'phim tình cảm'
	)
)

select MaKH, HoTen from KhachHang KH, PhieuThue PT
where LoaiKH='VIP' and KH.MaKH=PT.MaKH
and count(MaPT) >= ALL (
	select count(MaPT) from PhieuThue
	group by MaKH
)

select TheLoai, KH1.TenKH from Bang_Dia BD
join KhachHang KH1 on KH1.MaKH=PT.MaKH
join PhieuThue PT on PT.MaPT=CT.MaPT
join ChiTiet_PM CT on CT.MaBD=BD.MaBD
where KH1.MaKH in (
	select top 1 with ties KH2.MaKH
	from KhachHang KH2
	where KH1.MaKH=KH2.MaKH and PT.MaKH=KH2.MaKH
	group by KH2.MaKH
	order by count(MaPT) desc
)