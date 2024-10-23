IF EXISTS (SELECT * FROM sys.databases WHERE name = 'Tuan6_nhom2_124TCSDL06')
BEGIN
    USE master; -- Chuyển sang cơ sở dữ liệu master để có thể xóa được cơ sở dữ liệu khác
    ALTER DATABASE Tuan6_nhom2_124TCSDL06 SET SINGLE_USER WITH ROLLBACK IMMEDIATE; -- Ngắt mọi kết nối
    DROP DATABASE Tuan6_nhom2_124TCSDL06; -- Xóa cơ sở dữ liệu
END
go
create database Tuan6_nhom2_124TCSDL06
go
use Tuan6_nhom2_124TCSDL06
create table KHACHHANG
(
	makhachhang char(10) primary key,
	tencongty nvarchar(100),
	tengiaodich nvarchar(50),
	diachi nvarchar(100) not null,
	email varchar(50) unique
		check(email like '[a-z]%@%_'),
	dienthoai varchar(11) unique not null
		check(dienthoai like '[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]'
			or dienthoai like '[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]'),
	fax varchar(11) unique
)
create table NHANVIEN
(
	manhanvien char(10) primary key,
	ho nvarchar(10) not null,
	ten nvarchar(10) not null,
	ngaysinh date,
	ngaylamviec date,
	diachi nvarchar(100) not null,
	dienthoai varchar(11) unique not null
		check(dienthoai like '[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]'
			or dienthoai like '[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]'),
	luongcoban decimal(18,0)
			check(luongcoban>=0),
	phucap decimal (18,0)
			check(phucap>=0)
)
create table DONDATHANG
(
	sohoadon char(10) primary key,
	makhachhang char(10),
	manhanvien char(10),
	ngaydathang date,
	ngaygiaohang date,
	ngaychuyenhang date,
	noigiaohang nvarchar(100) not null,
	foreign key(makhachhang) references KHACHHANG(makhachhang)
		on update 
			cascade
		on delete 
			cascade,
	foreign key(manhanvien) references NHANVIEN(manhanvien)
		on update 
			cascade
		on delete 
			cascade
)
create table NHACUNGCAP
(
	macongty char(10) primary key,
	tencongty nvarchar(100),
	tengiaodich nvarchar(100),
	diachi nvarchar(100) not null,
	dienthoai varchar(11) unique not null
		check(dienthoai like '[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]'
			or dienthoai like '[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]'),
	fax varchar(11) unique,
	email varchar(50) unique not null
		check(email like '[a-z]%@%_'),
)
create table LOAIHANG
(
	maloaihang char(10) primary key,
	tenloaihang nvarchar(50),
)
create table MATHANG
(
	mahang char(10) primary key,
	tenhang nvarchar(100),
	macongty char(10),
	maloaihang char(10),
	soluong int default 1
		check(soluong>0),
	donvitinh nvarchar(50) not null,
	giahang decimal(18,0) not null
		check(giahang>0),
    foreign key (maloaihang) references LOAIHANG(maloaihang)
		on update 
			cascade
		on delete 
			cascade,
    foreign key (macongty) references NHACUNGCAP(macongty)
		on update 
			cascade
		on delete 
			cascade
)
create table CHITIETDATHANG
(
	sohoadon char(10),
	mahang char(10),
	giaban decimal(18,0) not null
		check(giaban>0),
	soluong int
		check(soluong>0),
	mucgiamgia decimal(5,2)
			check(mucgiamgia>=0), 
	primary key(sohoadon,mahang),
	foreign key (sohoadon) references DONDATHANG(sohoadon)
		on update 
			cascade
		on delete 
			cascade,
	foreign key (mahang) references MATHANG(mahang)
		on update 
			cascade
		on delete 
			cascade
)

alter table CHITIETDATHANG
	add constraint DF_ChiTietDonHang_Soluong
			default 1 for soluong,
		constraint DF_ChiTietDonHang_MucGiamGia
			default 0 for mucgiamgia
alter table DONDATHANG
	add constraint CK_DonDatHang_ngayGiaoHang
			check(ngaygiaohang >= ngaydathang AND ngaygiaohang <= getdate()),
		constraint CK_DonDatHang_ngayChuyenHang
			check(ngaychuyenhang >= ngaydathang AND ngaychuyenhang <= getdate())
alter table NHANVIEN
	add constraint CK_NhanVien_ngayLamViec
			check (ngaylamviec >= dateadd(year,18,ngaysinh) 
				AND ngaylamviec <= dateadd(year,60,ngaysinh) 
				AND ngaylamviec <=getdate()),
		constraint CK_NhanVien_ngaySinh check (ngaysinh < getdate())

insert into khachhang
	values 
		('KH001', N'Công Ty A', N'Nguyễn Văn A', N'123 Đường ABC, Quận 1', 'a@gmail.com', '0123456789', '0212345678'),
		('KH002', N'Công Ty B', N'Trần Thị B', N'456 Đường DEF, Quận 2', 'b@gmail.com', '0987654321', '0298765432'),
		('KH003', N'Công Ty C', N'Lê Văn C', N'789 Đường GHI, Quận 3', 'c@gmail.com', '0123456780', '0212345670'),
		('KH004', N'Công Ty D', N'Phạm Thị D', N'321 Đường JKL, Quận 4', 'd@gmail.com', '0987654320', '0298765430'),
		('KH005', N'Công Ty E', N'Nguyễn Văn E', N'654 Đường MNO, Quận 5', 'e@gmail.com', '0123456781', '0212345671'),
		('KH006', N'Công Ty F', N'Trần Thị F', N'987 Đường PQR, Quận 6', 'f@gmail.com', '0987654322', '0298765431'),
		('KH007', N'Công Ty G', N'Lê Văn G', N'135 Đường STU, Quận 7', 'g@gmail.com', '0123456782', '0212345672'),
		('KH008', N'Công Ty H', N'Phạm Thị H', N'246 Đường VWX, Quận 8', 'h@gmail.com', '0987654323', '0298765433'),
		('KH009', N'Công Ty I', N'Nguyễn Văn I', N'357 Đường YZ, Quận 9', 'i@gmail.com', '0123456783', '0212345673'),
		('KH010', N'Công Ty J', N'Trần Thị J', N'468 Đường ABCD, Quận 10', 'j@gmail.com', '0987654324', '0298765434')
set dateformat ymd
insert into nhanvien
	values
		('NV001', N'Nguyễn', N'An', '1990-01-15', '2020-05-01', N'123 Đường A, Quận 1', '0123456789', 5000000, 1000000),
		('NV002', N'Trần', N'Bình', '1988-02-20', '2019-06-10', N'456 Đường B, Quận 2', '0987654321', 6000000, 1200000),
		('NV003', N'Lê', N'Cường', '1992-03-05', '2021-07-15', N'789 Đường C, Quận 3', '0123456790', 5500000, 1100000),
		('NV004', N'Phạm', N'Duy', '1995-04-10', '2022-08-20', N'321 Đường D, Quận 4', '0987654312', 5800000, 1150000),
		('NV005', N'Nguyễn', N'Em', '1991-05-25', '2020-09-01', N'654 Đường E, Quận 5', '0123456781', 5200000, 1050000),
		('NV006', N'Trần', N'Phú', '1989-06-30', '2023-01-15', N'987 Đường F, Quận 6', '0987654323', 6300000, 1250000),
		('NV007', N'Lê', N'Quang', '1993-07-18', '2021-11-30', N'135 Đường G, Quận 7', '0123456782', 5400000, 1100000),
		('NV008', N'Phạm', N'Hạnh', '1994-08-22', '2020-12-01', N'246 Đường H, Quận 8', '0987654324', 5000000, 1000000),
		('NV009', N'Nguyễn', N'Thảo', '1990-09-10', '2018-03-15', N'357 Đường I, Quận 9', '0123456783', 5700000, 1150000),
		('NV010', N'Trần', N'Mai', '1992-10-05', '2022-04-10', N'468 Đường J, Quận 10', '0987654325', 5900000, 1200000)
set dateformat ymd
insert into DONDATHANG
	values
		('HD001', 'KH001', 'NV001', '2023-01-15', '2023-01-20', '2023-01-19', N'123 Đường A, Quận 1'),
		('HD002', 'KH002', 'NV002', '2023-02-01', '2023-02-05', '2023-02-04', N'456 Đường B, Quận 2'),
		('HD003', 'KH003', 'NV003', '2023-03-10', '2023-03-15', '2023-03-14', N'789 Đường C, Quận 3'),
		('HD004', 'KH004', 'NV004', '2023-04-12', '2023-04-18', '2023-04-17', N'321 Đường D, Quận 4'),
		('HD005', 'KH005', 'NV005', '2023-05-05', '2023-05-10', '2023-05-09', N'654 Đường E, Quận 5'),
		('HD006', 'KH006', 'NV006', '2023-06-15', '2023-06-20', '2023-06-19', N'987 Đường F, Quận 6'),
		('HD007', 'KH007', 'NV007', '2023-07-22', '2023-07-27', '2023-07-26', N'135 Đường G, Quận 7'),
		('HD008', 'KH008', 'NV008', '2023-08-30', '2023-09-05', '2023-09-04', N'246 Đường H, Quận 8'),
		('HD009', 'KH009', 'NV009', '2023-09-15', '2023-09-20', '2023-09-19', N'357 Đường I, Quận 9'),
		('HD010', 'KH010', 'NV010', '2023-10-10', '2023-10-15', '2023-10-14', N'468 Đường J, Quận 10')
insert into NHACUNGCAP
	values
		('CT001', N'Công Ty A', N'Nguyễn Văn A', N'123 Đường A, Quận 1', '0123456789', '0123456780', 'a@gmail.com'),
		('CT002', N'Công Ty B', N'Trần Thị B', N'456 Đường B, Quận 2', '0987654321', '0987654320', 'b@gmail.com'),
		('CT003', N'Công Ty C', N'Lê Văn C', N'789 Đường C, Quận 3', '0123456790', '0123456791', 'c@gmail.com'),
		('CT004', N'Công Ty D', N'Phạm Thị D', N'321 Đường D, Quận 4', '0987654312', '0987654313', 'd@gmail.com'),
		('CT005', N'Công Ty E', N'Nguyễn Văn E', N'654 Đường E, Quận 5', '0123456782', '0123456783', 'e@gmail.com'),
		('CT006', N'Công Ty F', N'Trần Thị F', N'987 Đường F, Quận 6', '0987654323', '0987654324', 'f@gmail.com'),
		('CT007', N'Công Ty G', N'Lê Văn G', N'135 Đường G, Quận 7', '0123456784', '0123456785', 'g@gmail.com'),
		('CT008', N'Công Ty H', N'Phạm Thị H', N'246 Đường H, Quận 8', '0987654325', '0987654326', 'h@gmail.com'),
		('CT009', N'Công Ty I', N'Nguyễn Văn I', N'357 Đường I, Quận 9', '0123456786', '0123456787', 'i@gmail.com'),
		('CT010', N'Công Ty J', N'Trần Thị J', N'468 Đường J, Quận 10', '0987654327', '0987654328', 'j@gmail.com')
insert into LOAIHANG
	values
		('LH001', N'Điện tử'),
		('LH002', N'Gia dụng'),
		('LH003', N'Thời trang'),
		('LH004', N'Thực phẩm'),
		('LH005', N'Văn phòng phẩm'),
		('LH006', N'Mỹ phẩm'),
		('LH007', N'Phụ kiện'),
		('LH008', N'Đồ chơi'),
		('LH009', N'Thiết bị thể thao'),
		('LH010', N'Sách')
insert into MATHANG
	values
		('MH001', N'Sản phẩm A', 'CT001', 'LH001', 100, N'Cái', 150000),
		('MH002', N'Sản phẩm B', 'CT001', 'LH002', 200, N'Cái', 250000),
		('MH003', N'Sản phẩm C', 'CT002', 'LH001', 150, N'Cái', 300000),
		('MH004', N'Sản phẩm D', 'CT003', 'LH003', 80, N'Cái', 120000),
		('MH005', N'Sản phẩm E', 'CT002', 'LH002', 50, N'Cái', 200000),
		('MH006', N'Sản phẩm F', 'CT004', 'LH001', 120, N'Cái', 175000),
		('MH007', N'Sản phẩm G', 'CT005', 'LH003', 60, N'Cái', 220000),
		('MH008', N'Sản phẩm H', 'CT006', 'LH002', 30, N'Cái', 280000),
		('MH009', N'Sản phẩm I', 'CT007', 'LH001', 90, N'Cái', 140000),
		('MH010', N'Sản phẩm J', 'CT008', 'LH003', 70, N'Cái', 190000)
insert into CHITIETDATHANG
	values 
		('HD001', 'MH001', 100000, 2, 5.00),
		('HD001', 'MH002', 200000, 1, 0.00),
		('HD002', 'MH001', 100000, 3, 10.00),
		('HD002', 'MH003', 150000, 2, 15.00),
		('HD003', 'MH002', 200000, 1, 5.00),
		('HD003', 'MH004', 300000, 4, 20.00),
		('HD004', 'MH005', 250000, 5, 0.00),
		('HD005', 'MH001', 100000, 2, 5.00),
		('HD006', 'MH003', 150000, 3, 10.00),
		('HD007', 'MH002', 200000, 1, 0.00)