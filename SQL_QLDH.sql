-- Xóa cơ sở dữ liệu nếu đã tồn tại
IF EXISTS (SELECT * FROM sys.databases WHERE name = 'QUANLYGIAOHANG')
BEGIN
    USE master; -- Chuyển sang cơ sở dữ liệu master để có thể xóa được cơ sở dữ liệu khác
    ALTER DATABASE QUANLYGIAOHANG SET SINGLE_USER WITH ROLLBACK IMMEDIATE; -- Ngắt mọi kết nối
    DROP DATABASE QUANLYGIAOHANG; -- Xóa cơ sở dữ liệu
END
-- Lệnh tạo database QUANLYGIAOHANG
create database QUANLYGIAOHANG
go
-- Sử dụng database QUANLYGIAOHANG
use QUANLYGIAOHANG
-- Tạo table Khách hàng
create table KHACHHANG
(
	makhachhang char(5) primary key,
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
-- Tạo table Nhân Viên
create table NHANVIEN
(
	manhanvien char(5) primary key,
	ho nvarchar(10),
	ten nvarchar(10) not null,
	ngaysinh date,
	ngaylamviec date,
	diachi nvarchar(100) not null,
	dienthoai varchar(11) unique not null
		check(dienthoai like '[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]'
			or dienthoai like '[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]'),
	luongcoban decimal(18,0) check(luongcoban > 0),
	phucap decimal (18,0) check (phucap > 0 )
)
-- Tạo table Đơn đặt hàng
create table DONDATHANG
(
	sohoadon char(5) primary key,
	makhachhang char(5),
	manhanvien char(5),
	ngaydathang date not null
		check (ngaydathang <= getdate()),
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
-- Tạo table Nhà cung cấp
create table NHACUNGCAP
(
	macongty char(5) primary key,
	tencongty nvarchar(100),
	diachi nvarchar(100) not null,
	tengiaodich nvarchar(100),
	dienthoai varchar(11) unique not null
		check(dienthoai like '[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]'
			or dienthoai like '[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]'),
	fax varchar(11) unique,
	email varchar(50) unique not null
		check(email like '[a-z]%@%_'),
)
-- Tạo table Loại hàng
create table LOAIHANG
(
	maloaihang char(5) primary key,
	tenloaihang nvarchar(100),
)
-- Tạo table Mặt hàng
create table MATHANG
(
	mahang char(5) primary key,
	tenhang nvarchar(100),
	macongty char(5),
	maloaihang char(5),
	soluong int check(soluong > 0),
	donvitinh nvarchar(50) not null,
	giahang decimal(18,0) not null check(giahang >=0 ),
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
-- Tạo table Chi tiết đơn hàng
create table CHITIETDONHANG
(
	sohoadon char(5),
	mahang char(5),
	giaban decimal(18,0) not null check (giaban >= 0),
	soluong int check(soluong > 0),
	mucgiamgia decimal(5,2), 
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
go
-- Thay đổi cấu trúc bảng Chi tiết đơn đặt hàng
alter table CHITIETDONHANG
	add constraint DF_ChiTietDonHang_Soluong
			default 1 for soluong,
		constraint DF_ChiTietDonHang_MucGiamGia
			default 0 for mucgiamgia
-- Thay đổi cấu trúc bảng Đơn đặt hàng
alter table DONDATHANG
	add constraint CK_DonDatHang_ngayGiaoHang
			check(ngaygiaohang >= ngaydathang),
		constraint CK_DonDatHang_ngayChuyenHang
			check(ngaychuyenhang >= ngaydathang)
-- Thay đổi cấu trúc bảng Nhân viên
alter table NHANVIEN
	add constraint CK_NhanVien_ngayLamViec
			check (ngaylamviec >= dateadd(year,18,ngaysinh) 
				AND ngaylamviec <= dateadd(year,60,ngaysinh)),
		constraint CK_NhanVien_ngaySinh
			check (ngaysinh < getdate())
insert into KHACHHANG
values  ('KH001',N'Công ty xây dựng nhà ở',N'Mua hàng',N'59 Diên Hồng, Hòa Xuân, Cẩm Lệ, Đà Nẵng','huynee@gmail.com','0223333223','7255756766'),
	    ('KH002',N'Công ty bất động sản',N'Mua hàng',N'59 Hùng Vương, Thanh Hà, Hội An, Quảng Nam','hdongsan@gmail.com','0223442239','5544545444'),
	    ('KH003',N'Công ty TNHH xi măng',N'Dịch vụ',N'12, Lê Thánh Tông, Tràng Tiền, Hoàn Kiếm, Hà Nội','ximanwgn@gmail.com','0553482239','9876543211'),
	    ('KH004',N'Công ty sản xuất bánh kẹo',N'Mua hàng',N'89 Trần Phú, Hải Châu 1, Hải Châu, Đà Nẵng','banhkeo@gmail.com','0553742239','1234567899'),
	    ('KH005',N'Công ty sản xuất bánh mì',N'Mua hàng',N'35 Lạch Tray, Cầu Đất, Ngô Quyền, Hải Phòng','banhmi@gmail.com','0553443239','1587567899'),
	    ('KH006',N'Công ty sản xuất dầu gội',N'Mua hàng',N'55 Mai Am, Bình Trị Đông B, Bình Tân, TP Hồ Chí Minh','daugoi@gmail.com','0557742239','1554567899'),
	    ('KH007',N'Công ty cầu đường',N'Mua hàng',N'678 Trần Phú, Thành phố Huế, Thừa Thiên Huế','cauduong@gmail.com','0559842239','1554604699'),
	    ('KH008',N'Công ty sản xuất bàn phím',N'Mua hàng',N'123 Nguyễn Huệ, Quận 1, TP Hồ Chí Minh','banphim@gmail.com','0598442239','1554560299'),
	    ('KH009',N'Công ty sản xuất nước ngọt',N'Mua hàng',N'15 Đường 3/2, Thành phố Nha Trang, Khánh Hòa','nuocngot@gmail.com','0553782239','1554534899'),
	    ('KH010',N'Công ty sản xuất cốc nước',N'Dịch vụ',N'45 Lê Duẩn, Quận Hải Châu, Đà Nẵng','cocnuoc@gmail.com','0775367239','1554565499')
set dateformat dmy
insert into NHANVIEN
values  ('NV001', N'Nguyễn',N'An','15-1-2005','20-10-2024',N'12 Lê Thánh Tông, Tràng Tiền, Hoàn Kiếm, Hà Nội','0912345678',5000000,1000000),
		('NV002', N'Trần',N'Bình','20-3-1999','5-5-2019',N'45 Quang Trung, 7, Gò Vấp, TP Hồ Chí Minh','0987654321',6000000,1200000),
		('NV003', N'Phạm',N'Cường','10-3-2000','6-7-2021',N'89 Trần Phú, Hải Châu 1, Hải Châu, Đà Nẵng','0901234567',5500000,1100000),
		('NV004', N'Lê',N'Duy','25-4-1998','10-12-2023',N'35 Lạch Tray, Cầu Đất, Ngô Quyền, Hải Phòng','0934567890',5200000,900000),
		('NV005', N'Nguyễn',N'Lan','15-5-1999','25-1-2022',N'22 Tô Hiệu, Nguyễn Trãi, Hà Đông, Hà Nội','0945678901',5300000,950000),
		('NV006', N'Trần',N'Nam','5-5-2003','1-7-2024',N'120 Cộng Hòa, 15, Tân Bình, TP Hồ Chí Minh','0923456789',6100000,1500000),
		('NV007', N'Phạm',N'Phúc','18-4-1998','25-11-2023',N'76 Bạch Đằng, Thạch Thang, Hải Châu, Đà Nẵng','0910987654',5400000,1000000),
		('NV008', N'Lê',N'Quỳnh','20-5-1999','5-4-2022',N'234 Cầu Giấy, Quan Hoa, Cầu Giấy, Hà Nội','0981123456',5600000,980000),
		('NV009', N'Nguyễn',N'Sơn','10-10-2000','15-10-2023',N'55 Tên Lửa, Bình Trị Đông B, Bình Tân, TP Hồ Chí Minh','0909988776',5700000,1100000),
		('NV010', N'Trần',N'Tuấn','24-10-2005','30-9-2024',N'789 Kim Mã, Ngọc Khánh, Ba Đình, Hà Nội','0912233445',5800000,1150000)
set dateformat dmy
insert into DONDATHANG
values	('HD001','KH001','NV001','10-01-2024','15-01-2024','12-01-2024',N'Số 10 Trần Hưng Đạo, Phường Cô Giang, Quận 1, TP Hồ Chí Minh'),
		('HD002','KH002','NV002','01-02-2024','05-02-2024','02-02-2024',N'Số 12 Đường Đê La Thành, Đống Đa, Hà Nội'),
		('HD003','KH003','NV005','15-02-2024','20-02-2024','18-02-2024',N'Số 45 Lê Văn Khương, Phường Thới An, Quận 12, TP Hồ Chí Minh'),
		('HD004','KH002','NV002','25-01-2024','30-01-2024','28-01-2024',N'Số 20 Nguyễn Văn Cừ, Phường 3, Quận 5, TP Hồ Chí Minh'),
		('HD005','KH002','NV006','05-03-2024','10-03-2024','07-03-2024',N'Số 78 Ngọc Khánh, Ba Đình, Hà Nội'),
		('HD006','KH003','NV008','30-01-2024','04-02-2024','01-02-2024',N'Số 101 Lê Lai, Phường Bến Thành, Quận 1, TP Hồ Chí Minh'),
		('HD007','KH004','NV003','10-02-2024','15-02-2024','12-02-2024',N'Số 3 Nguyễn Hữu Cảnh, Bình Thạnh, TP Hồ Chí Minh'),
		('HD008','KH003','NV009','01-03-2024','05-03-2024','02-03-2024',N'Số 57 Lê Thị Riêng, Quận 1, TP Hồ Chí Minh'),
		('HD009','KH010','NV008','20-02-2024','25-02-2024','22-02-2024',N'Số 88 Đinh Tiên Hoàng, Bình Thạnh, TP Hồ Chí Minh'),
		('HD010','KH010','NV010','15-01-2024','20-01-2024','18-01-2024',N'Số 45 Phố Huế, Hai Bà Trưng, Hà Nội')
insert into LOAIHANG 
values	('LH001',N'Điện tử'),
		('LH002',N'Nội thất'),
		('LH003',N'Thời trang'),
		('LH004',N'Thực phẩm'),
		('LH005',N'Mỹ phẩm'),
		('LH006',N'Thể thao'),
		('LH007',N'Xây dựng'),
		('LH008',N'Học tập'),
		('LH009',N'Đồ chơi'),
		('LH010',N'Phụ kiện')
insert into NHACUNGCAP
values	('CC001',N'Công ty xây dựng',N'456 Lê Lợi, Quận Hải Châu, TP. Đà Nẵng', N'Bán hàng','0912345678', '0241234567', 'xaydung@gmail.com'),
		('CC002',N'Công ty Cổ phần Sản xuất nội thất','789 Hai Bà Trưng, Quận Hoàn Kiếm, TP. Hà Nội',N'Cung cấp hàng','0987654321', '0287654321', 'noithat@gmail.com'),
		('CC003',N'Công ty thời trang',N'Cung cấp hàng','101 Trần Hưng Đạo, Quận Ninh Kiều, TP. Cần Thơ','0901234567', '0236123456', 'thoitrang@gmail.com'),
		('CC004',N'Công ty Đầu tư và Phát triển thể thao',N'123 Nguyễn Trãi, Quận 1, TP. Hồ Chí Minh',N'Bán hàng','0934567890','0312345678','thethaoi@gmail.com'),
		('CC005',N'Công ty Cổ phần Sản xuất nội thất đồ chơi',N'202 Phạm Văn Đồng, Quận Liên Chiểu, TP. Đà Nẵng',N'Bán hàng','0945678901','0247654321','dochoi@gmail.com'),
		('CC006',N'Công ty Cổ phần Công nghệ Điện tử',N'303 Võ Văn Tần, Quận 3, TP. Hồ Chí Minh',N'Cung cấp hàng','0923456789','0288765432', 'dientu@gmail.com'),
		('CC007',N'Công ty TNHH Sản xuất đồ dùng học tập làm việc',N'404 Điện Biên Phủ, Quận Bình Thạnh, TP. Hồ Chí Minh',N'Cung cấp hàng', '0910987654','0236654321','hoctap@gmail.com'),
		('CC008',N'Công ty cổ phần Sản xuất mỹ phẩm',N'505 Cộng Hòa, Quận Tân Bình, TP. Hồ Chí Minh',N'Cung cấp hàng', '0981123456','0249988776','mypham@gmail.com'),
		('CC009',N'Công ty Thương mại Quốc tế',N'606 Trường Chinh, Quận Thanh Xuân, TP. Hà Nội',N'Cung cấp hàng','0909988776','0289988776','quocte@gmail.com'),
		('CC010',N'Công ty Phát triển Bất động sản',N'707 Phạm Hùng, Huyện Bình Chánh, TP. Hồ Chí Minh',N'Cung cấp hàng','0912233445','0242233445','batdongsan@gmail.com')
insert into MATHANG
values	('MH001',N'Tivi','CC006','LH001', 50,N'Chiếc',3000000),
		('MH002',N'Tủ lạnh','CC002','LH002', 30,N'Chiếc',8000000),
		('MH003',N'Điện thoại di động','CC006','LH001',100,N'Chiếc',1500000),
		('MH004',N'Bếp từ','CC002','LH002', 20,N'Chiếc',4500000),
		('MH005',N'Ghế sofa','CC002','LH002', 15,N'Bộ',12000000),
		('MH006',N'Bàn làm việc','CC007','LH008',25,N'Chiếc',2500000),
		('MH007',N'Xi măng','CC001','LH007', 40,N'Bao',3000000),
		('MH008',N'Giày thể thao','CC004','LH006',60,N'Đôi',800000),
		('MH009',N'Sách học','CC007','LH008',200,N'Cuốn',150000),
		('MH010',N'Nước hoa','CC008','LH005',150,N'Lọ',500000)
insert into CHITIETDONHANG
values	('HD001','MH001',2800000,2,0.1),
		('HD001','MH002',7800000,1,0.00),
		('HD002','MH009',1450000,3,0.15),
		('HD002','MH002',4200000,1,0.20),
		('HD003','MH001',11500000,2,0.00),
		('HD003','MH006',2400000,4,0.6),
		('HD004','MH003',2900000,5,0.5),
		('HD004','MH002',750000,3,0.2),
		('HD005','MH008',130000,10,0.3),
		('HD005','MH006',480000,5,0.03)
