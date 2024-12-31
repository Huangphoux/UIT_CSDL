create database Test;
use Test;

create table DocGia (
	MaDG char(5) not null primary key,
	HoTen varchar(30),
	NgaySinh smalldatetime,
	DiaChi varchar(30),
	SoDT varchar(15),
)

create table Sach(
	MaSach char(5) not null primary key,
	TenSach varchar(25),
	TheLoai varchar(25),
	NhaXuatBan varchar(30),
)

create table PhieuThue(
	MaPT char(5) not null primary key,
	MaDG char(5),
	NgayThue smalldatetime,
	NgayTra smalldatetime,
	SoSachThue int,
)

create table ChiTiet_PT(
	MaPT char(5) not null,
	MaSach char(5) not null,
)

alter table ChiTietPT
add constraint PK_ChiTietPT
primary key (MaPT, MaSach)

alter table PhieuThue
add constraint FK_PT_DG
foreign key MaDG references DocGia(MaDG)

alter table ChiTietPT
add constraint FK_CTPT_PT
foreign key MaPT references PhieuThue(MaPT)

alter table ChiTietPT
add constraint FK_CTPT_Sach
foreign key MaSach references Sach(MaSach)

alter table PhieuThue
add constraint ThueQuaHan
check datediff(day, NgayThue, NgayTra) <= 10

create trigger TRG_SoSachThue on PhieuThue
for insert, update, delete as
begin
	update PhieuThue
	set SoSachThue=count(MaSach)
	from ChiTiet_PT
	where PhieuThue.MaPT=ChiTiet_PT.MaPT
end

select MaDG, HoTen
from DocGia, PhieuThue
where DocGia.MaDG=PhieuThue.MaDG
and year(NgayThue)=2007
and MaPT in (
	select MaPT
	from ChiTiet_PT, Sach
	where ChiTiet_PT.MaSach=Sach.MaSach
	and TheLoai=N'Tin học'
)

select top 1 with ties MaDG, HoTen, count(TheLoai) as SoTheLoai
from DocGia DG
join PhieuThue PT on DG.MaDG=PT.MaDG
join ChiTiet_PT CT on CT.MaPT=PT.MaPT
join Sach on Sach.MaSach=CT.MaSach
group by MaDG
order by count(TheLoai) desc

select TheLoai, S1.TenSach
from Sach S1
where S1.MaSach in (
	select top 1 with ties S2.MaSach
	from Sach S2, ChiTiet_PT CT
	where S2.MaSach=CT.MaSach and S1.MaSach=S2.MaSach
	group by S2.MaSach
	order by count(MaPT) desc
)