drop database if exists QUANLYGIAOHANG
create database QUANLYGIAOHANG
go
use QUANLYGIAOHANG
create table KHACHHANG
(
	makhachhang char(5) primary key,
	tencongty nvarchar(100),
	tengiaodich nvarchar(50),
	diachi nvarchar(100),
	email varchar(50) unique not null
		check(email like '[a-z]%@%_'),
	dienthoai varchar(11) unique not null
		check(dienthoai like '[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]'
			or dienthoai like '[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]'),
	fax varchar(11) unique
)
create table NHANVIEN
(
	manhanvien char(5) primary key,
	ho nvarchar(10),
	ten nvarchar(10),
	ngaysinh date,
	ngaylamviec date,
	diachi nvarchar(100),
	dienthoai varchar(11) unique not null
		check(dienthoai like '[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]'
			or dienthoai like '[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]'),
	luongcoban decimal(18,0) check (luongcoban >0),
	phucap decimal (18,0) check (phucap >0)
)
create table DONDATHANG
(
	sohoadon char(5) primary key,
	makhachhang char(5),
	manhanvien char(5),
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
	macongty char(5) primary key,
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
	maloaihang char(5) primary key,
	tenloaihang nvarchar(50)
)
create table MATHANG
(
	mahang char(5) primary key,
	tenhang nvarchar(100),
	macongty char(5),
	maloaihang char(5),
	soluong int check(soluong >0),
	donvitinh nvarchar(50),
	giahang decimal(18,0) check(giahang >0),
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
create table CHITIETDONHANG
(
	sohoadon char(5),
	mahang char(5),
	giaban decimal(18,0) check(giaban >0),
	soluong int check(soluong >0),
	mucgiamgia decimal(5,2) check(mucgiamgia >=0), 
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
alter table CHITIETDONHANG
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
--chèn dữ liệu--
insert into KHACHHANG
values
	('KH001', N'Công ty ABC', N'Nguyễn Văn A', N'123 Đường Trần Hưng Đạo', 'contact@abc.com', '0909123456', '0909123457'),
	('KH002', N'Công ty XYZ', N'Phạm Thị B', N'456 Đường Lê Lợi', 'info@xyz.com', '0912345678', '0912345679'),
	('KH003', N'Công ty Thịnh Vượng', N'Lê Văn C', N'789 Đường Nguyễn Huệ', 'sales@thinhvuong.com', '0923456789', '0923456790'),
	('KH004', N'Công ty Vĩnh Phát', N'Trần Minh D', N'12 Đường Pasteur', 'support@vinhphat.com', '0934567890', '0934567891'),
	('KH005', N'Công ty Phát Đạt', N'Hoàng Văn E', N'34 Đường Nam Kỳ Khởi Nghĩa', 'admin@phatdat.com', '0945678901', '0945678902'),
	('KH006', N'Công ty Thành Công', N'Nguyễn Thị F', N'56 Đường Võ Thị Sáu', 'contact@thanhcong.com', '0956789012', '0956789013'),
	('KH007', N'Công ty Tài Lộc', N'Phạm Văn G', N'78 Đường Phạm Ngũ Lão', 'info@tailoc.com', '0967890123', '0967890124'),
	('KH008', N'Công ty Hoàng Gia', N'Lê Thị H', N'90 Đường Lý Tự Trọng', 'support@hoanggia.com', '0978901234', '0978901235'),
	('KH009', N'Công ty Đại Phát', N'Võ Văn I', N'101 Đường Hai Bà Trưng', 'admin@daiphat.com', '0989012345', '0989012346'),
	('KH010', N'Công ty Phú Mỹ', N'Trần Thị J', N'202 Đường Điện Biên Phủ', 'info@phumy.com', '0990123456', '0990123457');
insert into NHANVIEN
values 
	('NV001', 'Nguyen', 'Anh', '1990-01-01', '2010-05-10', 'Hanoi', '0987654321', 7000000, 1000000),
	('NV002', 'Tran', 'Binh', '1985-02-02', '2011-06-20', 'Hanoi', '0978654321', 8000000, 1200000),
	('NV003', 'Le', 'Cuong', '1992-03-03', '2012-07-15', 'Hanoi', '0968654321', 9000000, 1500000),
	('NV004', 'Pham', 'Duy', '1991-04-04', '2013-08-22', 'Danang', '0958654321', 8500000, 1300000),
	('NV005', 'Hoang', 'Khanh', '1988-05-05', '2014-09-30', 'Saigon', '0948654321', 7800000, 1100000),
	('NV006', 'Vu', 'Lam', '1993-06-06', '2015-10-12', 'Saigon', '0938654321', 7200000, 1000000),
	('NV007', 'Do', 'Mai', '1987-07-07', '2016-11-21', 'Danang', '0928654321', 8800000, 1250000),
	('NV008', 'Nguyen', 'Nam', '1989-08-08', '2017-12-15', 'Hanoi', '0918654321', 7500000, 1150000),
	('NV009', 'Tran', 'Phuc', '1986-09-09', '2018-01-10', 'Hanoi', '0908654321', 9000000, 1400000),
	('NV010', 'Le', 'Quoc', '1994-10-10', '2019-02-28', 'Saigon', '0998654321', 9500000, 1500000);
insert into NHACUNGCAP
values
	('CT001', 'Công Ty TNHH ABC', 'Ông Nguyễn Văn A', '123 Đường 1, Quận 1, TP.HCM', '0123456789', '0123456789', 'abc@example.com'),
	('CT002', 'Công Ty Cổ Phần XYZ', 'Bà Trần Thị B', '456 Đường 2, Quận 2, TP.HCM', '0987654321', '0987654321', 'xyz@example.com'),
	('CT003', 'Công Ty TNHH DEF', 'Ông Lê Văn C', '789 Đường 3, Quận 3, TP.HCM', '0234567890', '0234567890', 'def@example.com'),
	('CT004', 'Công Ty Cổ Phần GHI', 'Bà Phạm Thị D', '101 Đường 4, Quận 4, TP.HCM', '0345678901', '0345678901', 'ghi@example.com'),
	('CT005', 'Công Ty TNHH JKL', 'Ông Trần Văn E', '202 Đường 5, Quận 5, TP.HCM', '0456789012', '0456789012', 'jkl@example.com'),
	('CT006', 'Công Ty Cổ Phần MNO', 'Bà Đỗ Thị F', '303 Đường 6, Quận 6, TP.HCM', '0567890123', '0567890123', 'mno@example.com'),
	('CT007', 'Công Ty TNHH PQR', 'Ông Nguyễn Văn G', '404 Đường 7, Quận 7, TP.HCM', '0678901234', '0678901234', 'pqr@example.com'),
	('CT008', 'Công Ty Cổ Phần STU', 'Bà Trần Thị H', '505 Đường 8, Quận 8, TP.HCM', '0789012345', '0789012345', 'stu@example.com'),
	('CT009', 'Công Ty TNHH VWX', 'Ông Lê Văn I', '606 Đường 9, Quận 9, TP.HCM', '0890123456', '0890123456', 'vwx@example.com'),
	('CT010', 'Công Ty Cổ Phần YZ', 'Bà Phạm Thị K', '707 Đường 10, Quận 10, TP.HCM', '0901234567', '0901234567', 'yz@example.com');
insert into LOAIHANG
values
	('LH001', 'Đồ điện tử'),
	('LH002', 'Thời trang'),
	('LH003', 'Đồ gia dụng'),
	('LH004', 'Sách vở'),
	('LH005', 'Văn phòng phẩm'),
	('LH006', 'Thực phẩm'),
	('LH007', 'Đồ chơi trẻ em'),
	('LH008', 'Dụng cụ thể thao'),
	('LH009', 'Mỹ phẩm'),
	('LH010', 'Đồ nội thất');
insert into MATHANG
values
	('MH001', 'Điện thoại iPhone', 'CT001', 'LH001', 100, 'Chiếc', 20000000),
	('MH002', 'Áo thun nam', 'CT002', 'LH002', 200, 'Cái', 250000),
	('MH003', 'Nồi cơm điện', 'CT003', 'LH003', 150, 'Chiếc', 800000),
	('MH004', 'Sách lập trình', 'CT004', 'LH004', 300, 'Quyển', 120000),
	('MH005', 'Bút bi Thiên Long', 'CT005', 'LH005', 1000, 'Cây', 5000),
	('MH006', 'Sữa tươi Vinamilk', 'CT006', 'LH006', 500, 'Hộp', 15000),
	('MH007', 'Xe đạp trẻ em', 'CT007', 'LH007', 50, 'Chiếc', 1200000),
	('MH008', 'Giày thể thao', 'CT008', 'LH008', 100, 'Đôi', 800000),
	('MH009', 'Son môi', 'CT009', 'LH009', 200, 'Thỏi', 300000),
	('MH010', 'Bàn làm việc', 'CT010', 'LH010', 30, 'Cái', 2500000);
insert into DONDATHANG
values
	('HD001', 'KH001', 'NV001', '2024-01-01', '2024-01-05', '2024-01-04', '123 Đường ABC, Phường XYZ'),
	('HD002', 'KH002', 'NV002', '2024-01-03', '2024-01-08', '2024-01-07', '456 Đường DEF, Phường XYZ'),
	('HD003', 'KH003', 'NV003', '2024-01-04', '2024-01-10', '2024-01-09', '789 Đường GHI, Phường XYZ'),
	('HD004', 'KH004', 'NV004', '2024-01-06', '2024-01-11', '2024-01-10', '123 Đường JKL, Phường XYZ'),
	('HD005', 'KH005', 'NV005', '2024-01-08', '2024-01-13', '2024-01-12', '456 Đường MNO, Phường XYZ'),
	('HD006', 'KH006', 'NV006', '2024-01-09', '2024-01-15', '2024-01-14', '789 Đường PQR, Phường XYZ'),
	('HD007', 'KH007', 'NV007', '2024-01-11', '2024-01-16', '2024-01-15', '123 Đường STU, Phường XYZ'),
	('HD008', 'KH008', 'NV008', '2024-01-13', '2024-01-18', '2024-01-17', '456 Đường VWX, Phường XYZ'),
	('HD009', 'KH009', 'NV009', '2024-01-14', '2024-01-20', '2024-01-19', '789 Đường YZ, Phường XYZ'),
	('HD010', 'KH010', 'NV010', '2024-01-16', '2024-01-22', '2024-01-21', '123 Đường ABC, Phường XYZ');
insert into CHITIETDONHANG
values
	('HD001', 'MH001', 50000, 2, 5.00),
	('HD001', 'MH002', 30000, 1, 0.00),
	('HD002', 'MH003', 70000, 1, 10.00),
	('HD002', 'MH001', 50000, 3, 0.00),
	('HD003', 'MH002', 30000, 2, 0.00),
	('HD003', 'MH004', 80000, 1, 15.00),
	('HD004', 'MH001', 50000, 4, 5.00),
	('HD004', 'MH002', 30000, 2, 0.00),
	('HD005', 'MH003', 70000, 2, 0.00),
	('HD005', 'MH004', 80000, 1, 10.00);