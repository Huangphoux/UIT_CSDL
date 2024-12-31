create database Test;
use Test;

create table TacGia (
	MaTG char(5) not null primary key,
	HoTen varchar(20),
	DiaChi varchar(50),
	NgSinh smalldatetime,
	SoDT varchar(15),
);

create table Sach (
	MaSach char(5) not null primary key,
	TenSach varchar(25),
	TheLoai varchar(25),
);

create table TacGia_Sach (
	MaTG char(5) not null,
	MaSach char(5) not null,
);

create table PhatHanh (
	MaPH char(5) not null primary key,
	MaSach char(5),
	NgayPH smalldatetime,
	SoLuong int,
	NhaXuatBan varchar(20),
);

set datetimeformat dmy;

alter table TacGia_Sach
add constraint PK_TacGia_Sach
primary key (MaTG, MaSach);

alter table TacGia_Sach
add constraint FK_TacGia_Sach_TacGia
foreign key (MaTG) references TacGia(MaTG);

alter table TacGia_Sach
add constraint FK_TacGia_Sach_Sach
foreign key (MaSach) references Sach(MaSach);

alter table PhatHanh
add constraint FK_PhatHanh_Sach
foreign key (MaSach) references Sach(MaSach);

create trigger NgayPhatHanh on PhatHanh
for insert, update as
begin
	if exists (
		select * from inserted
		join TacGia on TacGia_Sach.MaTG=TacGia.MaTG
		where MaSach=@MaSach and NgayPH > NgSinh
	)
	begin
		print('Thao tac thanh cong.')
	end else
	begin
		print('Ngay phat hanh sach phai lon hon ngay sinh cua tac gia.')
		rollback transaction
	end
end

create trigger NgayPhatHanh on Sach
for insert, update as
begin
	update PhatHanh
	set NhaXuatBan=N'Giáo dục'
	from inserted
	where inserted.MaSach=Sach.MaSach and TheLoai=N'Giáo khoa'
end

select MaTG, HoTen, SoDT
from TacGia
where MaTG in (
	select MaTG from TacGia_Sach
	join Sach on Sach.MaSach=TacGia_Sach.MaSach
	where TheLoai=N'Văn học' and MaSach in (
		select MaSach from PhatHanh
		Where NhaXuatBan=N'Trẻ'
	)
)

select top 1 with ties NhaXuatBan, count(TheLoai) As SoTheLoai
from PhatHanh, Sach
Where PhatHanh.MaSach=Sach.MaSach
group by NhaXuatBan
order by count(TheLoai) desc;

select NhaXuatBan, TG1.MaTG, HoTen
from TacGia TG1, PhatHanh PH, TacGia_Sach TGS
where TG1.MaTG=TGS.MaTG and TGS.MaSach=PH.MaSach 
	  and TG1.MaTG in (
	select top 1 with ties TG2.MaTG
	from TacGia TG2
	join TacGia_Sach on TacGia_Sach.MaTG=TG2.MaTG
	join PhatHanh on PhatHanh.MaSach=TacGia_Sach.MaSach
    where NV2.MaPhong = NV1.MaPhong
    group by NV2.MaNV
    order by COUNT(PhatHanh.MaSach) desc;
);

use master;
drop database Test;