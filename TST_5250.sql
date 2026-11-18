CREATE DATABASE TST_5250;
GO

USE TST_5250;
GO

-- 1. BẢNG KHÁCH HÀNG (tblCustomer)
CREATE TABLE KhachHang (
    maKH VARCHAR(20) PRIMARY KEY,              
    tenKH NVARCHAR(100),                      
    soNha_TenDuong NVARCHAR(100),            
    phuongXa NVARCHAR(50),                    
    quanHuyen NVARCHAR(50),                    
    diaChiTTP NVARCHAR(50) DEFAULT N'Đà Nẵng', 
    SDT VARCHAR(20),                           
    Email VARCHAR(100),                      
    soDuTaiKhoan MONEY,                      
    DoB DATE,                               
    gioiTinh NVARCHAR(1) DEFAULT 'F'           
);
GO

ALTER TABLE KhachHang
ADD CONSTRAINT CK_KH_Email CHECK (
    Email LIKE '[a-zA-Z]%@gmail.com' OR
    Email LIKE '[a-zA-Z]%@yahoo.com' OR
    Email LIKE '[a-zA-Z]%@ute.udn.vn'
);
GO
-- Email phải duy nhất
ALTER TABLE KhachHang
ADD CONSTRAINT UQ_KH_Email UNIQUE (Email);
GO
-- TelNo: 10 hoặc 11 chữ số
ALTER TABLE KhachHang
ADD CONSTRAINT CK_KH_SDT CHECK (
    SDT LIKE '0[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]' OR
    SDT LIKE '0[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]'
);
GO
-- TelNo phải duy nhất
ALTER TABLE KhachHang
ADD CONSTRAINT UQ_KH_SDT UNIQUE (SDT);
GO
-- Địa chỉ Tỉnh/Thành phố chỉ nhận 1 trong 3 giá trị
ALTER TABLE KhachHang
ADD CONSTRAINT CK_KH_DiaChi CHECK (diaChiTTP IN (N'Đà Nẵng', N'TP Hồ Chí Minh', N'Quảng Nam'));
GO
-- Số dư tài khoản >= 0
ALTER TABLE KhachHang
ADD CONSTRAINT CK_KH_SoDu CHECK (soDuTaiKhoan >= 0);
GO
-- DoB: đủ 18 tuổi trở lên
ALTER TABLE KhachHang
ADD CONSTRAINT CK_KH_DoB CHECK (DoB <= DATEADD(YEAR, -18, GETDATE()));
GO
-- Gender: chỉ nhận 'F' hoặc 'M'
ALTER TABLE KhachHang
ADD CONSTRAINT CK_KH_GioiTinh CHECK (gioiTinh IN ('F', 'M'));
GO


-- 2. BẢNG NHÂN VIÊN (tblEmployee)
CREATE TABLE NhanVien (
    maNV VARCHAR(20) PRIMARY KEY,           
    tenNV NVARCHAR(100),                      
    SDT VARCHAR(20),                           
    Email VARCHAR(100),                       
    gioiTinh NVARCHAR(1) DEFAULT 'F',           
    DoB DATE,                                 
    Salary MONEY                             
);
GO

ALTER TABLE NhanVien
ADD CONSTRAINT CK_NV_Email CHECK (
    Email LIKE '[a-zA-Z]%@gmail.com' OR
    Email LIKE '[a-zA-Z]%@yahoo.com' OR
    Email LIKE '[a-zA-Z]%@ute.udn.vn'
);
GO
-- Email phải duy nhất
ALTER TABLE NhanVien
ADD CONSTRAINT UQ_NV_Email UNIQUE (Email);
GO
-- TelNo: 10 hoặc 11 chữ số
ALTER TABLE NhanVien
ADD CONSTRAINT CK_NV_SDT CHECK (
    SDT LIKE '0[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]' OR
    SDT LIKE '0[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]'
);
GO
-- TelNo phải duy nhất
ALTER TABLE NhanVien
ADD CONSTRAINT UQ_NV_SDT UNIQUE (SDT);
GO
-- DoB: đủ 18 tuổi trở lên
ALTER TABLE NhanVien
ADD CONSTRAINT CK_NV_DoB CHECK (DoB <= DATEADD(YEAR, -18, GETDATE()));
GO
-- Gender: chỉ nhận 'F' hoặc 'M'
ALTER TABLE NhanVien
ADD CONSTRAINT CK_NV_GioiTinh CHECK (gioiTinh IN ('F', 'M'));
GO
-- Salary >= 0
ALTER TABLE NhanVien
ADD CONSTRAINT CK_NV_Salary CHECK (Salary >= 0);
GO

-- 3. BẢNG NHÀ CUNG CẤP (tblSupplier)
CREATE TABLE NhaCungCap (
    maNCC VARCHAR(20) PRIMARY KEY,            
    tenNCC NVARCHAR(100),                    
    diaChiNCC NVARCHAR(200),                  
    tinhTP NVARCHAR(50) DEFAULT N'Đà Nẵng',   
    SDT VARCHAR(20),                           
    nhanVienLienHe NVARCHAR(100)               
);
GO
-- Địa chỉ Tỉnh/Thành phố chỉ nhận 1 trong 3 giá trị
ALTER TABLE NhaCungCap
ADD CONSTRAINT CK_NCC_TinhTP CHECK (tinhTP IN (N'Đà Nẵng', N'TP Hồ Chí Minh', N'Quảng Nam'));
GO

-- 4. BẢNG SẢN PHẨM (tblProduct)
CREATE TABLE SanPham (
    maSP CHAR(7) PRIMARY KEY,              
    tenSP NVARCHAR(100),                    
    donGiaBan MONEY,                        
    soLuongHienCon BIGINT,                  
    soLuongCanDuoi SMALLINT                
);
GO
ALTER TABLE SanPham
ADD CONSTRAINT CK_SP_DonGiaBan CHECK (donGiaBan >= 0);
GO
ALTER TABLE SanPham
ADD CONSTRAINT CK_SP_SoLuongHienCon CHECK (soLuongHienCon >= 0);
GO
ALTER TABLE SanPham
ADD CONSTRAINT CK_SP_SoLuongCanDuoi CHECK (soLuongCanDuoi >= 0);
GO

-- 5. BẢNG ĐƠN ĐẶT HÀNG - HÓA ĐƠN (tblOrderInvoice)
CREATE TABLE DonDatHang_HoaDon (
    maDH VARCHAR(20) PRIMARY KEY,            
    ngayTaoDH DATETIME,                     
    diaChiGiaoHang NVARCHAR(200),             
    SDTGiaoHang VARCHAR(20),                
    maHoaDonDienTu VARCHAR(50),              
    ngayThanhToan DATETIME,                   
    ngayGiaoHang DATETIME,                    
    trangThaiDonHang NVARCHAR(50),            
    tongTienDonHang MONEY,                    
    DelStatus VARCHAR(2) DEFAULT 'BT',       
    maKH VARCHAR(20),                         
    maNV VARCHAR(20),                      
    -- Khóa ngoại đến KhachHang, có ON DELETE/UPDATE CASCADE
    CONSTRAINT FK_DH_KH FOREIGN KEY (maKH) REFERENCES KhachHang(maKH)
        ON DELETE CASCADE ON UPDATE CASCADE,
    -- Khóa ngoại đến NhanVien, có ON DELETE/UPDATE CASCADE
    CONSTRAINT FK_DH_NV FOREIGN KEY (maNV) REFERENCES NhanVien(maNV)
        ON DELETE CASCADE ON UPDATE CASCADE
);
GO

-- OrderDate: nhỏ hơn ngày hiện tại
ALTER TABLE DonDatHang_HoaDon
ADD CONSTRAINT CK_DH_NgayTao CHECK (ngayTaoDH < GETDATE());
GO
-- InvDate: nhỏ hơn ngày hiện tại và lớn hơn OrderDate
ALTER TABLE DonDatHang_HoaDon
ADD CONSTRAINT CK_DH_NgayThanhToan CHECK (
    ngayThanhToan IS NULL OR
    (ngayThanhToan < GETDATE() AND ngayThanhToan > ngayTaoDH)
);
GO
-- DelDate: nhỏ hơn ngày hiện tại và lớn hơn InvDate
ALTER TABLE DonDatHang_HoaDon
ADD CONSTRAINT CK_DH_NgayGiao CHECK (
    ngayGiaoHang IS NULL OR
    (ngayGiaoHang < GETDATE() AND ngayGiaoHang > ngayThanhToan)
);
GO
-- OrdInvStatus: chỉ nhận 1 trong 4 giá trị
ALTER TABLE DonDatHang_HoaDon
ADD CONSTRAINT CK_DH_TrangThai CHECK (
    trangThaiDonHang IN (N'Chờ duyệt', N'Đã duyệt – Đang đóng gói', N'Đang giao', N'Đã giao')
);
GO
-- DelStatus: chỉ nhận 'BT', 'ER', 'LL'
ALTER TABLE DonDatHang_HoaDon
ADD CONSTRAINT CK_DH_DelStatus CHECK (DelStatus IN ('BT', 'ER', 'LL'));
GO
-- OrderTotalMoney >= 0
ALTER TABLE DonDatHang_HoaDon
ADD CONSTRAINT CK_DH_TongTien CHECK (tongTienDonHang >= 0);
GO
-- SĐT giao hàng: 10 hoặc 11 chữ số
ALTER TABLE DonDatHang_HoaDon
ADD CONSTRAINT CK_DH_SDTGiaoHang CHECK (
    SDTGiaoHang LIKE '0[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]' OR
    SDTGiaoHang LIKE '0[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]'
);
GO

-- 6. BẢNG PHIẾU NHẬP
CREATE TABLE PhieuNhap (
    maPN CHAR(7) PRIMARY KEY,                 
    ngayNhapHang DATETIME,                   
    maNCC VARCHAR(20),                  
    -- Khóa ngoại đến NhaCungCap, có ON DELETE/UPDATE CASCADE
    CONSTRAINT FK_PN_NCC FOREIGN KEY (maNCC) REFERENCES NhaCungCap(maNCC)
        ON DELETE CASCADE ON UPDATE CASCADE
);
GO
ALTER TABLE PhieuNhap
ADD CONSTRAINT DF_PN_NgayNhap DEFAULT GETDATE() FOR ngayNhapHang;
GO

-- 7. BẢNG CHI TIẾT ĐƠN HÀNG (tblOrderInvoiceDetail)
CREATE TABLE ChiTietDonHang (
    maDH VARCHAR(20),
    maSP CHAR(7),
    soLuongDat INT,                      
    donGia MONEY,                           
    PRIMARY KEY (maDH, maSP),
    -- Khóa ngoại đến DonDatHang_HoaDon, có ON DELETE/UPDATE CASCADE
    CONSTRAINT FK_CTDH_DH FOREIGN KEY (maDH) REFERENCES DonDatHang_HoaDon(maDH)
        ON DELETE CASCADE ON UPDATE CASCADE,
    -- Khóa ngoại đến SanPham, có ON DELETE/UPDATE CASCADE
    CONSTRAINT FK_CTDH_SP FOREIGN KEY (maSP) REFERENCES SanPham(maSP)
        ON DELETE CASCADE ON UPDATE CASCADE
);
GO
ALTER TABLE ChiTietDonHang
ADD CONSTRAINT DF_CTDH_SoLuong DEFAULT 1 FOR soLuongDat;
GO
-- QtyOrdered >= 0
ALTER TABLE ChiTietDonHang
ADD CONSTRAINT CK_CTDH_SoLuong CHECK (soLuongDat >= 0);
GO
-- Amount >= 0
ALTER TABLE ChiTietDonHang
ADD CONSTRAINT CK_CTDH_DonGia CHECK (donGia >= 0);
GO

-- 8. BẢNG CHI TIẾT PHIẾU NHẬP
CREATE TABLE ChiTietPhieuNhap (
    maPN CHAR(7),
    maSP CHAR(7),
    soLuongNhap INT,
    giaNhap MONEY,
    PRIMARY KEY (maPN, maSP),
    -- Khóa ngoại đến PhieuNhap, có ON DELETE/UPDATE CASCADE
    CONSTRAINT FK_CTPN_PN FOREIGN KEY (maPN) REFERENCES PhieuNhap(maPN)
        ON DELETE CASCADE ON UPDATE CASCADE,
    -- Khóa ngoại đến SanPham, có ON DELETE/UPDATE CASCADE
    CONSTRAINT FK_CTPN_SP FOREIGN KEY (maSP) REFERENCES SanPham(maSP)
        ON DELETE CASCADE ON UPDATE CASCADE
);
GO
ALTER TABLE ChiTietPhieuNhap
ADD CONSTRAINT CK_CTPN_SoLuong CHECK (soLuongNhap >= 0);
GO
ALTER TABLE ChiTietPhieuNhap
ADD CONSTRAINT CK_CTPN_GiaNhap CHECK (giaNhap >= 0);
GO

-- 9. BẢNG KHUYẾN MÃI
CREATE TABLE KhuyenMai (
    maKM INT IDENTITY(1,1) PRIMARY KEY,      
    tenKM NVARCHAR(100) NOT NULL,
    soTienGiam MONEY,
    ngayBatDau DATE,
    ngayKetThuc DATE
);
GO
ALTER TABLE KhuyenMai
ADD CONSTRAINT CK_KM_SoTienGiam CHECK (soTienGiam >= 0);
GO
ALTER TABLE KhuyenMai
ADD CONSTRAINT CK_KM_Ngay CHECK (ngayKetThuc >= ngayBatDau);
GO

-- 10. BẢNG CHỨC VỤ (Position)
CREATE TABLE ChucVu (
    maChucVu INT IDENTITY(1,1) PRIMARY KEY,    
    tenChucVu NVARCHAR(50) DEFAULT N'Nhân viên bán hàng'
);
GO
ALTER TABLE ChucVu
ADD CONSTRAINT CK_CV_Ten CHECK (
    tenChucVu IN (N'Nhân viên bán hàng', N'Nhân viên kho', N'Nhân viên giao hàng', N'Quản lý viên')
);
GO

-- 11. BẢNG TRUNG GIAN NHÂN VIÊN - CHỨC VỤ
CREATE TABLE NhanVien_ChucVu (
    maNV VARCHAR(20),
    maChucVu INT,
    PRIMARY KEY (maNV, maChucVu),
    -- Khóa ngoại đến NhanVien, có ON DELETE/UPDATE CASCADE
    CONSTRAINT FK_NVCV_NV FOREIGN KEY (maNV) REFERENCES NhanVien(maNV)
        ON DELETE CASCADE ON UPDATE CASCADE,
    -- Khóa ngoại đến ChucVu, có ON DELETE/UPDATE CASCADE
    CONSTRAINT FK_NVCV_CV FOREIGN KEY (maChucVu) REFERENCES ChucVu(maChucVu)
        ON DELETE CASCADE ON UPDATE CASCADE
);
GO

SET DATEFORMAT dmy;
GO

--Bảng KhachHang gồm 10 dòng dữ liệu; cột họ tên (tenKH) gồm họ tên của 10 sinh viên trong lớp:
--4 sinh viên trước mình (KH01 -> KH04), chính mình (KH05 - viết tắt TST), và 5 sinh viên sau mình (KH06 -> KH10)
INSERT INTO KhachHang (maKH, tenKH, soNha_TenDuong, phuongXa, quanHuyen, diaChiTTP, SDT, Email, soDuTaiKhoan, DoB, gioiTinh) VALUES
('KH01', N'Trần Quốc Bảo', N'12 Lê Duẩn', N'Phường Thạch Thang', N'Quận Hải Châu', N'Đà Nẵng', '0905111001', 'baotq@gmail.com', 500000, '15/03/2004', 'M'),
('KH02', N'Trần Thị Minh Châu', N'45 Đống Đa', N'Phường Thạch Thang', N'Quận Hải Châu', N'Đà Nẵng', '0905111002', 'chauttm@yahoo.com', 1200000, '20/06/2004', 'F'),
('KH03', N'Trần Hoàng Dũng', N'78 Nguyễn Lương Bằng', N'Phường Hòa Khánh Bắc', N'Quận Liên Chiểu', N'Đà Nẵng', '0905111003', 'dungth@ute.udn.vn', 800000, '10/01/2004', 'M'),
('KH04', N'Trần Ngọc Hân', N'23 Điện Biên Phủ', N'Phường Chính Gián', N'Quận Thanh Khê', N'Đà Nẵng', '0905111004', 'hantn@gmail.com', 300000, '05/09/2004', 'F'),
('KH05', N'Trần Sơn Tùng', N'48 Cao Thắng', N'Phường Thanh Bình', N'Quận Hải Châu', N'Đà Nẵng', '0905111005', 'tungts@ute.udn.vn', 2500000, '12/11/2004', 'M'),
('KH06', N'Trần Văn Tuấn', N'90 Ngô Quyền', N'Phường An Hải Bắc', N'Quận Sơn Trà', N'Đà Nẵng', '0905111006', 'tuantv@gmail.com', 450000, '18/04/2004', 'M'),
('KH07', N'Trần Thanh Việt', N'15 Lê Lợi', N'Phường Minh An', N'TP Hội An', N'Quảng Nam', '0905111007', 'viettt@yahoo.com', 950000, '22/07/2004', 'M'),
('KH08', N'Trương Thị Thảo Vy', N'102 Nguyễn Thị Minh Khai', N'Phường Bến Nghé', N'Quận 1', N'TP Hồ Chí Minh', '0905111008', 'vyttt@gmail.com', 1500000, '30/08/2004', 'F'),
('KH09', N'Võ Hoàng Yến', N'56 Hùng Vương', N'Phường Hải Châu 1', N'Quận Hải Châu', N'Đà Nẵng', '0905111009', 'yenvh@ute.udn.vn', 600000, '14/02/2004', 'F'),
('KH10', N'Vũ Minh Quân', N'34 Hoàng Diệu', N'Phường Phước Ninh', N'Quận Hải Châu', N'Đà Nẵng', '0905111010', 'quanvm@gmail.com', 700000, '25/12/2004', 'M');
GO

--Bảng NhanVien gồm 10 dòng dữ liệu; cột họ tên (tenNV) gồm họ tên của 10 sinh viên trong lớp:
--4 sinh viên trước mình (NV01 -> NV04), chính mình (NV05 - viết tắt TST), và 5 sinh viên sau mình (NV06 -> NV10)
INSERT INTO NhanVien (maNV, tenNV, SDT, Email, gioiTinh, DoB, Salary) VALUES
('NV01', N'Trần Quốc Bảo', '0914222001', 'nvbaotq@gmail.com', 'M', '15/03/2004', 8500000),
('NV02', N'Trần Thị Minh Châu', '0914222002', 'nvchauttm@yahoo.com', 'F', '20/06/2004', 9000000),
('NV03', N'Trần Hoàng Dũng', '0914222003', 'nvdungth@ute.udn.vn', 'M', '10/01/2004', 8000000),
('NV04', N'Trần Ngọc Hân', '0914222004', 'nvhantn@gmail.com', 'F', '05/09/2004', 8200000),
('NV05', N'Trần Sơn Tùng', '0914222005', 'nvtungts@ute.udn.vn', 'M', '12/11/2004', 12000000),
('NV06', N'Trần Văn Tuấn', '0914222006', 'nvtuantv@gmail.com', 'M', '18/04/2004', 7800000),
('NV07', N'Trần Thanh Việt', '0914222007', 'nvviettt@yahoo.com', 'M', '22/07/2004', 8500000),
('NV08', N'Trương Thị Thảo Vy', '0914222008', 'nvvyttt@gmail.com', 'F', '30/08/2004', 9500000),
('NV09', N'Võ Hoàng Yến', '0914222009', 'nvyenvh@ute.udn.vn', 'F', '14/02/2004', 8800000),
('NV10', N'Vũ Minh Quân', '0914222010', 'nvquanvm@gmail.com', 'M', '25/12/2004', 9200000);
GO

--Bảng NhaCungCap gồm 10 dòng dữ liệu
INSERT INTO NhaCungCap (maNCC, tenNCC, diaChiNCC, tinhTP, SDT, nhanVienLienHe) VALUES
('NCC01', N'Công ty TNHH Điện tử Hòa Phát', N'10 Đường số 2, KCN Hòa Cầm', N'Đà Nẵng', '02363111001', N'Nguyễn Văn An'),
('NCC02', N'Công ty CP Thiết bị Số Miền Trung', N'55 Nguyễn Văn Linh', N'Đà Nẵng', '02363111002', N'Lê Thị Bình'),
('NCC03', N'Công ty TNHH Thương mại Á Châu', N'120 Lê Lợi', N'Quảng Nam', '02353111003', N'Phạm Văn Cường'),
('NCC04', N'Công ty CP Công nghệ Sài Gòn', N'200 Cách Mạng Tháng 8', N'TP Hồ Chí Minh', '02838111004', N'Hoàng Minh Đức'),
('NCC05', N'Công ty TNHH Phân phối FPT', N'88 Điện Biên Phủ', N'Đà Nẵng', '02363111005', N'Đặng Thị Hoa'),
('NCC06', N'Công ty CP Thế Giới Số', N'15 Nguyễn Huệ', N'TP Hồ Chí Minh', '02838111006', N'Bùi Quang Huy'),
('NCC07', N'Công ty TNHH Linh kiện Đại Việt', N'42 Phan Châu Trinh', N'Đà Nẵng', '02363111007', N'Đỗ Thanh Hùng'),
('NCC08', N'Công ty CP Thiết bị Văn phòng Quảng Nam', N'30 Trần Phú', N'Quảng Nam', '02353111008', N'Ngô Thị Lan'),
('NCC09', N'Công ty TNHH MTV Minh Khang', N'75 Hàm Nghi', N'Đà Nẵng', '02363111009', N'Lý Văn Nam'),
('NCC10', N'Công ty CP Đầu tư Công nghệ Nam Việt', N'310 Võ Văn Tần', N'TP Hồ Chí Minh', '02838111010', N'Trịnh Thị Oanh');
GO

--Bảng SanPham gồm 10 dòng dữ liệu; cột maSP có 3 ký tự là 3 chữ số cuối cùng trong mã sinh viên (250)
INSERT INTO SanPham (maSP, tenSP, donGiaBan, soLuongHienCon, soLuongCanDuoi) VALUES
('SP25001', N'Chuột không dây Logitech', 350000, 120, 10),
('SP25002', N'Bàn phím cơ DareU', 750000, 80, 10),
('SP25003', N'Tai nghe Bluetooth Sony', 1200000, 50, 5),
('SP25004', N'Màn hình LG 24 inch', 3200000, 40, 5),
('SP25005', N'Ổ cứng SSD Kingston 500GB', 1100000, 90, 10),
('SP25006', N'RAM Laptop 8GB DDR4', 650000, 100, 15),
('SP25007', N'USB SanDisk 64GB', 180000, 200, 20),
('SP25008', N'Webcam Full HD Logitech', 950000, 60, 8),
('SP25009', N'Giá đỡ Laptop nhôm', 250000, 8, 15),
('SP25010', N'Bộ vệ sinh Laptop chuyên dụng', 80000, 3, 30);
GO

--Bảng DonDatHang_HoaDon gồm 10 dòng dữ liệu:
-- + Cột mã DDHHD (maDH) có 3 ký tự là viết tắt của họ tên của mình
-- + Tồn tại ít nhất 1 khách hàng mua hơn 1 đơn hàng (KH01 mua DHTST01, DHTST02; KH05 mua DHTST05, DHTST06)
-- + Tồn tại ít nhất 1 nhân viên xử lý hơn 1 đơn hàng (NV01 xử lý DHTST01, DHTST02; NV05 xử lý DHTST05, DHTST06)
-- + Tồn tại ít nhất 2 đơn hàng có cùng phường xã cần giao hàng (DHTST01, DHTST02, DHTST03 cùng giao ở Phường Thạch Thang; DHTST05, DHTST06 cùng giao ở Phường Thanh Bình)
-- + Tồn tại đơn hàng giao thành công do nhân viên giao hàng thực hiện (DHTST04 do NV04, DHTST07 do NV06)
-- + Tồn tại đơn hàng không cần xuất hóa đơn điện tử (DHTST09, DHTST10 có maHoaDonDienTu nhận giá trị NULL)
INSERT INTO DonDatHang_HoaDon (maDH, ngayTaoDH, diaChiGiaoHang, SDTGiaoHang, maHoaDonDienTu, ngayThanhToan, ngayGiaoHang, trangThaiDonHang, tongTienDonHang, DelStatus, maKH, maNV) VALUES
('DHTST01', '01/03/2026', N'12 Lê Duẩn, Phường Thạch Thang, Quận Hải Châu, Đà Nẵng', '0905111001', 'HDDT001', '02/03/2026', '03/03/2026', N'Đã giao', 1450000, 'BT', 'KH01', 'NV01'),
('DHTST02', '04/03/2026', N'12 Lê Duẩn, Phường Thạch Thang, Quận Hải Châu, Đà Nẵng', '0905111001', 'HDDT002', '05/03/2026', '06/03/2026', N'Đã giao', 1200000, 'BT', 'KH01', 'NV01'),
('DHTST03', '07/03/2026', N'45 Đống Đa, Phường Thạch Thang, Quận Hải Châu, Đà Nẵng', '0905111002', 'HDDT003', '08/03/2026', '09/03/2026', N'Đã giao', 3200000, 'BT', 'KH02', 'NV02'),
('DHTST04', '10/03/2026', N'78 Nguyễn Lương Bằng, Phường Hòa Khánh Bắc, Quận Liên Chiểu, Đà Nẵng', '0905111003', 'HDDT004', '11/03/2026', '12/03/2026', N'Đã giao', 1100000, 'BT', 'KH03', 'NV04'),
('DHTST05', '13/03/2026', N'48 Cao Thắng, Phường Thanh Bình, Quận Hải Châu, Đà Nẵng', '0905111005', 'HDDT005', '14/03/2026', '15/03/2026', N'Đã giao', 1300000, 'BT', 'KH05', 'NV05'),
('DHTST06', '16/03/2026', N'48 Cao Thắng, Phường Thanh Bình, Quận Hải Châu, Đà Nẵng', '0905111005', 'HDDT006', '17/03/2026', '18/03/2026', N'Đang giao', 350000, 'BT', 'KH05', 'NV05'),
('DHTST07', '19/03/2026', N'90 Ngô Quyền, Phường An Hải Bắc, Quận Sơn Trà, Đà Nẵng', '0905111006', 'HDDT007', '20/03/2026', '21/03/2026', N'Đã giao', 950000, 'BT', 'KH06', 'NV06'),
('DHTST08', '22/03/2026', N'15 Lê Lợi, Phường Minh An, TP Hội An, Quảng Nam', '0905111007', 'HDDT008', '23/03/2026', NULL, N'Đã duyệt – Đang đóng gói', 250000, 'BT', 'KH07', 'NV07'),
('DHTST09', '25/03/2026', N'56 Hùng Vương, Phường Hải Châu 1, Quận Hải Châu, Đà Nẵng', '0905111009', NULL, NULL, NULL, N'Chờ duyệt', 160000, 'LL', 'KH09', 'NV09'),
('DHTST10', '28/03/2026', N'34 Hoàng Diệu, Phường Phước Ninh, Quận Hải Châu, Đà Nẵng', '0905111010', NULL, NULL, NULL, N'Chờ duyệt', 750000, 'BT', 'KH10', 'NV10'),
-- Đơn hàng bổ sung phục vụ kiểm tra câu d (KH >= 10 lần mua), câu h (khách VIP > 5 lần), câu e (tính tiền đơn mới nhất), câu f (số lượng đặt > tồn kho)
('DHTST11', '01/04/2026', N'12 Lê Duẩn, Phường Thạch Thang, Quận Hải Châu, Đà Nẵng', '0905111001', 'HDDT011', '02/04/2026', '03/04/2026', N'Đã giao', 350000, 'BT', 'KH01', 'NV01'),
('DHTST12', '04/04/2026', N'12 Lê Duẩn, Phường Thạch Thang, Quận Hải Châu, Đà Nẵng', '0905111001', 'HDDT012', '05/04/2026', '06/04/2026', N'Đã giao', 350000, 'BT', 'KH01', 'NV01'),
('DHTST13', '07/04/2026', N'12 Lê Duẩn, Phường Thạch Thang, Quận Hải Châu, Đà Nẵng', '0905111001', 'HDDT013', '08/04/2026', '09/04/2026', N'Đã giao', 350000, 'BT', 'KH01', 'NV01'),
('DHTST14', '10/04/2026', N'12 Lê Duẩn, Phường Thạch Thang, Quận Hải Châu, Đà Nẵng', '0905111001', 'HDDT014', '11/04/2026', '12/04/2026', N'Đã giao', 350000, 'BT', 'KH01', 'NV01'),
('DHTST15', '13/04/2026', N'12 Lê Duẩn, Phường Thạch Thang, Quận Hải Châu, Đà Nẵng', '0905111001', 'HDDT015', '14/04/2026', '15/04/2026', N'Đã giao', 350000, 'BT', 'KH01', 'NV01'),
('DHTST16', '16/04/2026', N'12 Lê Duẩn, Phường Thạch Thang, Quận Hải Châu, Đà Nẵng', '0905111001', 'HDDT016', '17/04/2026', '18/04/2026', N'Đã giao', 350000, 'BT', 'KH01', 'NV01'),
('DHTST17', '19/04/2026', N'12 Lê Duẩn, Phường Thạch Thang, Quận Hải Châu, Đà Nẵng', '0905111001', 'HDDT017', '20/04/2026', '21/04/2026', N'Đã giao', 350000, 'BT', 'KH01', 'NV01'),
('DHTST18', '22/04/2026', N'12 Lê Duẩn, Phường Thạch Thang, Quận Hải Châu, Đà Nẵng', '0905111001', 'HDDT018', '23/04/2026', '24/04/2026', N'Đã giao', 350000, 'BT', 'KH01', 'NV01'),
('DHTST19', '02/04/2026', N'48 Cao Thắng, Phường Thanh Bình, Quận Hải Châu, Đà Nẵng', '0905111005', 'HDDT019', '03/04/2026', '04/04/2026', N'Đã giao', 750000, 'BT', 'KH05', 'NV05'),
('DHTST20', '05/04/2026', N'48 Cao Thắng, Phường Thanh Bình, Quận Hải Châu, Đà Nẵng', '0905111005', 'HDDT020', '06/04/2026', '07/04/2026', N'Đã giao', 750000, 'BT', 'KH05', 'NV05'),
('DHTST21', '08/04/2026', N'48 Cao Thắng, Phường Thanh Bình, Quận Hải Châu, Đà Nẵng', '0905111005', 'HDDT021', '09/04/2026', '10/04/2026', N'Đã giao', 750000, 'BT', 'KH05', 'NV05'),
('DHTST22', '25/04/2026', N'48 Cao Thắng, Phường Thanh Bình, Quận Hải Châu, Đà Nẵng', '0905111005', 'HDDT022', NULL, NULL, N'Chờ duyệt', 2500000, 'BT', 'KH05', 'NV05');
GO

-- Yêu cầu: Bảng PhieuNhap gồm các dòng dữ liệu; cột maPN có 3 ký tự là 3 chữ số kề cuối trong mã sinh viên (525)
INSERT INTO PhieuNhap (maPN, ngayNhapHang, maNCC) VALUES
('PN52501', '01/02/2026', 'NCC01'),
('PN52502', '03/02/2026', 'NCC02'),
('PN52503', '05/02/2026', 'NCC03'),
('PN52504', '07/02/2026', 'NCC04'),
('PN52505', '09/02/2026', 'NCC05'),
('PN52506', '11/02/2026', 'NCC06'),
('PN52507', '13/02/2026', 'NCC07'),
('PN52508', '15/02/2026', 'NCC08'),
('PN52509', '17/02/2026', 'NCC09'),
('PN52510', '19/02/2026', 'NCC10'),
-- Phiếu nhập bổ sung cho NCC01 để có số lần nhập hàng > 3 (phục vụ câu 1 n)
('PN52511', '22/02/2026', 'NCC01'),
('PN52512', '25/02/2026', 'NCC01'),
('PN52513', '28/02/2026', 'NCC01');
GO

--Bảng ChiTietDonHang gồm các dòng dữ liệu:
-- + Tồn tại ít nhất 1 sản phẩm xuất hiện trong nhiều hơn 1 đơn hàng (SP25001 xuất hiện trong DHTST01, DHTST02, DHTST06; SP25002 xuất hiện trong DHTST01, DHTST10)
-- + Tồn tại ít nhất 1 đơn hàng có nhiều hơn 1 loại sản phẩm trong đơn (DHTST01 có 2 loại sản phẩm: SP25001 và SP25002)
INSERT INTO ChiTietDonHang (maDH, maSP, soLuongDat, donGia) VALUES
('DHTST01', 'SP25001', 2, 350000),
('DHTST01', 'SP25002', 1, 750000),
('DHTST02', 'SP25001', 1, 350000),
('DHTST03', 'SP25004', 1, 3200000),
('DHTST04', 'SP25005', 1, 1100000),
('DHTST05', 'SP25006', 2, 650000),
('DHTST06', 'SP25001', 1, 350000),
('DHTST07', 'SP25008', 1, 950000),
('DHTST08', 'SP25009', 1, 250000),
('DHTST10', 'SP25002', 1, 750000),
-- Chi tiết đơn hàng bổ sung:
('DHTST11', 'SP25001', 1, 350000),
('DHTST12', 'SP25001', 1, 350000),
('DHTST13', 'SP25001', 1, 350000),
('DHTST14', 'SP25001', 1, 350000),
('DHTST15', 'SP25001', 1, 350000),
('DHTST16', 'SP25001', 1, 350000),
('DHTST17', 'SP25001', 1, 350000),
('DHTST18', 'SP25001', 1, 350000),
('DHTST19', 'SP25002', 1, 750000),
('DHTST20', 'SP25002', 1, 750000),
('DHTST21', 'SP25002', 1, 750000),
-- Đơn hàng DHTST22 đặt SP25009 số lượng 10 (vượt quá tồn kho = 8) phục vụ câu f
('DHTST22', 'SP25009', 10, 250000);
GO

--Bảng ChiTietPhieuNhap gồm các dòng dữ liệu:
-- + Tồn tại ít nhất 1 phiếu nhập có nhiều hơn 1 loại sản phẩm trong đơn (PN52501 có 3 loại sản phẩm: SP25001, SP25002, SP25003)
-- + Tồn tại ít nhất 1 sản phẩm xuất hiện trong nhiều hơn 1 phiếu nhập (SP25001 xuất hiện trong PN52501, PN52502, PN52510, PN52511)
INSERT INTO ChiTietPhieuNhap (maPN, maSP, soLuongNhap, giaNhap) VALUES
('PN52501', 'SP25001', 50, 250000),
('PN52501', 'SP25002', 30, 550000),
('PN52501', 'SP25003', 20, 900000),
('PN52502', 'SP25001', 40, 245000),
('PN52503', 'SP25004', 15, 2700000),
('PN52504', 'SP25005', 35, 850000),
('PN52505', 'SP25006', 50, 480000),
('PN52506', 'SP25007', 100, 110000),
('PN52507', 'SP25008', 25, 700000),
('PN52508', 'SP25009', 60, 150000),
('PN52509', 'SP25010', 50, 50000),
('PN52510', 'SP25001', 30, 248000),
-- Chi tiết phiếu nhập bổ sung cho NCC01
('PN52511', 'SP25001', 30, 250000),
('PN52512', 'SP25002', 20, 550000),
('PN52513', 'SP25003', 15, 900000);
GO

--Bảng KhuyenMai gồm 10 dòng dữ liệu (cột maKM tự động tăng bằng IDENTITY)
INSERT INTO KhuyenMai (tenKM, soTienGiam, ngayBatDau, ngayKetThuc) VALUES
(N'Khuyến mãi Tết Nguyên Đán', 100000, '01/01/2026', '15/02/2026'),
(N'Khuyến mãi Quốc tế Phụ nữ 8/3', 50000, '01/03/2026', '10/03/2026'),
(N'Khuyến mãi Ngày thành lập Đoàn 26/3', 30000, '20/03/2026', '27/03/2026'),
(N'Khuyến mãi Đại lễ 30/4 - 1/5', 150000, '25/04/2026', '05/05/2026'),
(N'Khuyến mãi Chào Hè Sôi Động', 80000, '01/06/2026', '30/06/2026'),
(N'Khuyến mãi Tựu trường Tân Sinh viên', 200000, '15/08/2026', '15/09/2026'),
(N'Khuyến mãi Quốc khánh 2/9', 120000, '30/08/2026', '05/09/2026'),
(N'Khuyến mãi Phụ nữ Việt Nam 20/10', 60000, '15/10/2026', '22/10/2026'),
(N'Khuyến mãi Ngày Nhà giáo 20/11', 90000, '15/11/2026', '22/11/2026'),
(N'Khuyến mãi Siêu Sale Cuối Năm', 250000, '01/12/2026', '31/12/2026');
GO

--Bảng ChucVu gồm 10 dòng dữ liệu (cột maChucVu tự động tăng bằng IDENTITY)
INSERT INTO ChucVu (tenChucVu) VALUES
(N'Nhân viên bán hàng'),
(N'Nhân viên kho'),
(N'Nhân viên giao hàng'),
(N'Quản lý viên'),
(N'Nhân viên bán hàng'),
(N'Nhân viên kho'),
(N'Nhân viên giao hàng'),
(N'Quản lý viên'),
(N'Nhân viên bán hàng'),
(N'Nhân viên kho');
GO

--Bảng NhanVien_ChucVu gồm các dòng dữ liệu (1 nhân viên có thể giữ 2 chức vụ và 1 chức vụ có nhiều nhân viên)
INSERT INTO NhanVien_ChucVu (maNV, maChucVu) VALUES
('NV01', 1),
('NV01', 2),
('NV02', 1),
('NV03', 2),
('NV04', 3),
('NV05', 4),
('NV05', 1),
('NV06', 3),
('NV07', 2),
('NV08', 1),
('NV09', 1),
('NV10', 1);
GO



-- 1 a Hãy hiển thị thông tin các sản phẩm có giá bán ra nằm trong 3 mức giá cao nhất
SELECT *
FROM SanPham
WHERE donGiaBan IN (
    SELECT DISTINCT TOP 3 donGiaBan
    FROM SanPham
    ORDER BY donGiaBan DESC
)
ORDER BY donGiaBan DESC;
GO

-- 1 b Hãy hiển thị thông tin sản phẩm có số lần nhập hàng về nhiều nhất
SELECT TOP 1 WITH TIES 
    sp.maSP, 
    sp.tenSP, 
    sp.donGiaBan, 
    sp.soLuongHienCon, 
    sp.soLuongCanDuoi,
    COUNT(ctpn.maPN) AS SoLanNhapHang
FROM SanPham sp
INNER JOIN ChiTietPhieuNhap ctpn ON sp.maSP = ctpn.maSP
GROUP BY sp.maSP, sp.tenSP, sp.donGiaBan, sp.soLuongHienCon, sp.soLuongCanDuoi
ORDER BY COUNT(ctpn.maPN) DESC;
GO

-- 1 c thống kê những sản phẩm thuộc top 3 bán chạy nhất  
SELECT TOP 3 WITH TIES 
    sp.maSP,
    sp.tenSP,
    sp.donGiaBan,
    SUM(ctdh.soLuongDat) AS TongSoLuongBan
FROM SanPham sp
INNER JOIN ChiTietDonHang ctdh ON sp.maSP = ctdh.maSP
GROUP BY sp.maSP, sp.tenSP, sp.donGiaBan
ORDER BY TongSoLuongBan DESC;
GO

-- 1 d thống kê những sản phẩm chưa bán được cái nào  
SELECT *
FROM SanPham
WHERE maSP NOT IN (
    SELECT DISTINCT maSP 
    FROM ChiTietDonHang
    WHERE maSP IS NOT NULL
);
GO

-- 1 e hiển thị những đơn hàng giao thành công và thông tin cụ thể của người giao hàng
SELECT 
    dh.maDH,
    dh.ngayTaoDH,
    dh.ngayGiaoHang,
    dh.diaChiGiaoHang,
    dh.trangThaiDonHang,
    dh.tongTienDonHang,
    nv.maNV,
    nv.tenNV,
    nv.SDT AS SDT_NhanVien,
    cv.tenChucVu AS ChucVu
FROM DonDatHang_HoaDon dh
INNER JOIN NhanVien nv ON dh.maNV = nv.maNV
INNER JOIN NhanVien_ChucVu nvcv ON nv.maNV = nvcv.maNV
INNER JOIN ChucVu cv ON nvcv.maChucVu = cv.maChucVu
WHERE dh.trangThaiDonHang = N'Đã giao'
  AND cv.tenChucVu = N'Nhân viên giao hàng';
GO

-- 1 f hiển thị những đơn hàng của khách hàng ở Đà Nẵng hoặc Quảng Nam
SELECT 
    dh.maDH,
    dh.ngayTaoDH,
    dh.ngayGiaoHang,
    dh.diaChiGiaoHang,
    dh.trangThaiDonHang,
    dh.tongTienDonHang,
    kh.maKH,
    kh.tenKH,
    kh.diaChiTTP AS TinhThanhPho_KH
FROM DonDatHang_HoaDon dh
INNER JOIN KhachHang kh ON dh.maKH = kh.maKH
WHERE kh.diaChiTTP IN (N'Đà Nẵng', N'Quảng Nam');
GO

-- 1 g hiển thị những sản phẩm có giá từ 500k – 2.000k 
SELECT *
FROM SanPham
WHERE donGiaBan BETWEEN 500000 AND 2000000;
GO

-- 1 h những tháng có doanh thu trên 2000000 (có tham số là định mức tiền)  
DECLARE @DinhMucTien MONEY = 2000000;

SELECT 
    YEAR(ngayTaoDH) AS Nam,
    MONTH(ngayTaoDH) AS Thang,
    SUM(tongTienDonHang) AS TongDoanhThu
FROM DonDatHang_HoaDon
WHERE trangThaiDonHang = N'Đã giao'
GROUP BY YEAR(ngayTaoDH), MONTH(ngayTaoDH)
HAVING SUM(tongTienDonHang) > @DinhMucTien
ORDER BY Nam DESC, Thang DESC;
GO

-- 1 i thống kê số lượng khách theo từng tỉnh/thành phố (sắp xếp giảm dần)  
SELECT 
    diaChiTTP AS [Tỉnh/Thành phố],
    COUNT(maKH) AS [Số lượng khách hàng]
FROM KhachHang
GROUP BY diaChiTTP
ORDER BY COUNT(maKH) DESC;
GO

-- ==============================================================================
-- CHUẨN HÓA ĐỊA CHỈ: TÁCH THỰC THỂ TỈNH/TP, QUẬN/HUYỆN, PHƯỜNG/XÃ
-- ==============================================================================

-- 1. Tạo 3 bảng thực thể Tỉnh/Thành phố, Quận/Huyện, Phường/Xã
CREATE TABLE Tinh_ThanhPho (
    maTTP VARCHAR(10) PRIMARY KEY,
    tenTTP NVARCHAR(50) NOT NULL UNIQUE
);

CREATE TABLE Quan_Huyen (
    maQH VARCHAR(10) PRIMARY KEY,
    tenQH NVARCHAR(50) NOT NULL,
    maTTP VARCHAR(10) FOREIGN KEY REFERENCES Tinh_ThanhPho(maTTP) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE Phuong_Xa (
    maPX VARCHAR(10) PRIMARY KEY,
    tenPX NVARCHAR(50) NOT NULL,
    maQH VARCHAR(10) FOREIGN KEY REFERENCES Quan_Huyen(maQH) ON DELETE CASCADE ON UPDATE CASCADE
);
GO

-- 2. Thêm dữ liệu mẫu vào 3 thực thể từ dữ liệu của bảng KhachHang hiện có
INSERT INTO Tinh_ThanhPho (maTTP, tenTTP) VALUES
('TTP01', N'Đà Nẵng'),
('TTP02', N'Quảng Nam'),
('TTP03', N'TP Hồ Chí Minh');

INSERT INTO Quan_Huyen (maQH, tenQH, maTTP) VALUES
('QH01', N'Quận Hải Châu', 'TTP01'),
('QH02', N'Quận Liên Chiểu', 'TTP01'),
('QH03', N'Quận Thanh Khê', 'TTP01'),
('QH04', N'Quận Sơn Trà', 'TTP01'),
('QH05', N'TP Hội An', 'TTP02'),
('QH06', N'Quận 1', 'TTP03');

INSERT INTO Phuong_Xa (maPX, tenPX, maQH) VALUES
('PX01', N'Phường Thạch Thang', 'QH01'),
('PX02', N'Phường Hòa Khánh Bắc', 'QH02'),
('PX03', N'Phường Chính Gián', 'QH03'),
('PX04', N'Phường Thanh Bình', 'QH01'),
('PX05', N'Phường An Hải Bắc', 'QH04'),
('PX06', N'Phường Minh An', 'QH05'),
('PX07', N'Phường Bến Nghé', 'QH06'),
('PX08', N'Phường Hải Châu 1', 'QH01'),
('PX09', N'Phường Phước Ninh', 'QH01');
GO

-- Hiển thị dữ liệu 3 bảng thực thể địa chỉ vừa thêm
SELECT * FROM Tinh_ThanhPho;
SELECT * FROM Quan_Huyen;
SELECT * FROM Phuong_Xa;
GO

-- 3. Bổ sung khóa ngoại maPX vào bảng KhachHang và cập nhật dữ liệu tương ứng
ALTER TABLE KhachHang ADD maPX VARCHAR(10) FOREIGN KEY REFERENCES Phuong_Xa(maPX);
GO

UPDATE kh
SET kh.maPX = px.maPX
FROM KhachHang kh
INNER JOIN Phuong_Xa px ON kh.phuongXa = px.tenPX;
GO

-- Hiển thị bảng KhachHang sau khi cập nhật mã phường xã (maPX)
SELECT maKH, tenKH, soNha_TenDuong, phuongXa, quanHuyen, diaChiTTP, maPX
FROM KhachHang;
GO

-- 4. Thống kê số lượng khách theo từng Tỉnh/Thành phố dựa trên 3 thực thể vừa bổ sung
SELECT 
    ttp.maTTP AS [Mã Tỉnh/TP],
    ttp.tenTTP AS [Tên Tỉnh/Thành phố],
    COUNT(kh.maKH) AS [Số lượng khách hàng]
FROM Tinh_ThanhPho ttp
LEFT JOIN Quan_Huyen qh ON ttp.maTTP = qh.maTTP
LEFT JOIN Phuong_Xa px ON qh.maQH = px.maQH
LEFT JOIN KhachHang kh ON px.maPX = kh.maPX
GROUP BY ttp.maTTP, ttp.tenTTP
ORDER BY [Số lượng khách hàng] DESC;
GO

-- 1 j thống kê giá trung bình, giá max, giá min nhập hàng cho mỗi sản phẩm
SELECT 
    sp.maSP,
    sp.tenSP,
    AVG(ctpn.giaNhap) AS GiaNhapTrungBinh,
    MAX(ctpn.giaNhap) AS GiaNhapCaoNhat,
    MIN(ctpn.giaNhap) AS GiaNhapThapNhat
FROM SanPham sp
LEFT JOIN ChiTietPhieuNhap ctpn ON sp.maSP = ctpn.maSP
GROUP BY sp.maSP, sp.tenSP;
GO

-- 1 k hiển thị giá trung bình, giá max, giá min bán ra cho mỗi sản phẩm
SELECT 
    sp.maSP,
    sp.tenSP,
    AVG(ctdh.donGia) AS GiaBanTrungBinh,
    MAX(ctdh.donGia) AS GiaBanCaoNhat,
    MIN(ctdh.donGia) AS GiaBanThapNhat
FROM SanPham sp
INNER JOIN ChiTietDonHang ctdh ON sp.maSP = ctdh.maSP
GROUP BY sp.maSP, sp.tenSP;
GO

-- 1 l thống kê số lần khách hàng mua hàng của từng khách hàng
SELECT 
    kh.maKH,
    kh.tenKH,
    COUNT(dh.maDH) AS SoLanMuaHang
FROM KhachHang kh
LEFT JOIN DonDatHang_HoaDon dh ON kh.maKH = dh.maKH
GROUP BY kh.maKH, kh.tenKH
ORDER BY SoLanMuaHang DESC;
GO

-- 1 m hiển thị thông tin chi tiết của các sản phẩm mà có số lần nhập hàng nhiều nhất  
SELECT TOP 1 WITH TIES 
    sp.maSP,
    sp.tenSP,
    sp.donGiaBan,
    sp.soLuongHienCon,
    sp.soLuongCanDuoi,
    COUNT(ctpn.maPN) AS SoLanNhapHang
FROM SanPham sp
INNER JOIN ChiTietPhieuNhap ctpn ON sp.maSP = ctpn.maSP
GROUP BY sp.maSP, sp.tenSP, sp.donGiaBan, sp.soLuongHienCon, sp.soLuongCanDuoi
ORDER BY COUNT(ctpn.maPN) DESC;
GO

-- 1 n hiển thị thông tin chi tiết của các nhà cung cấp mà có số lần nhập hàng lớn hơn 3 
SELECT 
    ncc.maNCC,
    ncc.tenNCC,
    ncc.diaChiNCC,
    ncc.tinhTP,
    ncc.SDT,
    ncc.nhanVienLienHe,
    COUNT(pn.maPN) AS SoLanNhapHang
FROM NhaCungCap ncc
INNER JOIN PhieuNhap pn ON ncc.maNCC = pn.maNCC
GROUP BY ncc.maNCC, ncc.tenNCC, ncc.diaChiNCC, ncc.tinhTP, ncc.SDT, ncc.nhanVienLienHe
HAVING COUNT(pn.maPN) > 3;
GO

-- 2 Hiển thị những đơn hàng không cần được xuất hóa đơn
SELECT 
    dh.maDH,
    dh.ngayTaoDH,
    dh.diaChiGiaoHang,
    dh.SDTGiaoHang,
    dh.maHoaDonDienTu,
    dh.trangThaiDonHang,
    dh.tongTienDonHang,
    dh.maKH,
    dh.maNV
FROM DonDatHang_HoaDon dh
WHERE dh.maHoaDonDienTu IS NULL;
GO

-- ==============================================================================
-- 1. CÁC ĐOẠN LỆNH ĐỂ THỰC HIỆN CÁC CÔNG VIỆC SAU:
-- ==============================================================================

-- a. Hãy xuất dạng Text giá tiền của những sản phẩm có giá tiền lớn nhất
DECLARE @GiaTienMax MONEY;
SELECT @GiaTienMax = MAX(donGiaBan) FROM SanPham;

PRINT N'Giá tiền lớn nhất: ' + CAST(@GiaTienMax AS NVARCHAR(50)) + N' VNĐ';

SELECT 
    maSP,
    tenSP,
    CAST(donGiaBan AS NVARCHAR(50)) AS GiaTienDangText
FROM SanPham
WHERE donGiaBan = @GiaTienMax;
GO

-- b. Hãy viết đoạn lệnh để lấy giá trị id lớn nhất của mã sản phẩm (tách phần chữ và số riêng biệt);
DECLARE @MaxMaSP VARCHAR(20);
SELECT @MaxMaSP = MAX(maSP) FROM SanPham;

SELECT 
    @MaxMaSP AS [Mã SP lớn nhất],
    LEFT(@MaxMaSP, 2) AS [Phần chữ],
    SUBSTRING(@MaxMaSP, 3, LEN(@MaxMaSP)) AS [Phần số];
GO

-- c. Hãy viết đoạn lệnh để tìm giá trị id tiếp theo của bảng sản phẩm - bằng cách lấy mã lớn nhất và tăng thêm 1 đơn vị, và viết câu lệnh chèn dữ liệu vào bảng sản phẩm với id tiếp theo vừa tìm được đó;
DECLARE @MaxMaSP VARCHAR(20);
DECLARE @PhanChu VARCHAR(10);
DECLARE @PhanSo INT;
DECLARE @MaSPMoi VARCHAR(20);

SELECT @MaxMaSP = MAX(maSP) FROM SanPham;
SET @PhanChu = LEFT(@MaxMaSP, 2);
SET @PhanSo = CAST(SUBSTRING(@MaxMaSP, 3, LEN(@MaxMaSP)) AS INT);
SET @MaSPMoi = @PhanChu + RIGHT('00000' + CAST(@PhanSo + 1 AS VARCHAR(10)), 5);

INSERT INTO SanPham (maSP, tenSP, donGiaBan, soLuongHienCon, soLuongCanDuoi)
VALUES (@MaSPMoi, N'Tai nghe Gaming Kingston HyperX Cloud', 1450000, 30, 5);

SELECT * 
FROM SanPham 
WHERE maSP = @MaSPMoi;
GO

-- d. Hãy viết đoạn lệnh để đếm số lần mua hàng của từng khách hàng, nếu số lần mua lớn hơn hoặc bằng 10 thì ghi ‘Khách hàng thân thiết’, ngược lại ghi ‘Khách hàng tiềm năng’
SELECT 
    kh.maKH,
    kh.tenKH,
    COUNT(dh.maDH) AS SoLanMuaHang,
    CASE 
        WHEN COUNT(dh.maDH) >= 10 THEN N'Khách hàng thân thiết'
        ELSE N'Khách hàng tiềm năng'
    END AS LoaiKhachHang
FROM KhachHang kh
LEFT JOIN DonDatHang_HoaDon dh ON kh.maKH = dh.maKH
GROUP BY kh.maKH, kh.tenKH
ORDER BY SoLanMuaHang DESC;
GO

-- e. Hãy viết đoạn lệnh để tính tiền cho đơn hàng mới nhất (đơn hàng vừa được mua).
--    i. Nếu tổng tiền lớn hơn 1.000.000 thì áp dụng giảm 10% và cập nhật lại tổng tiền mới cần trả;
--    ii. Nếu tổng tiền từ 400.000 đến dưới 1.000.000 thì tổng tiền không cần cộng phí ship;
--    iii. Nếu tổng tiền nhỏ hơn 400.000 thì tổng tiền gồm tổng tiền hàng và phí ship (giả sử phí ship là 40.000)
DECLARE @MaDHMoiNhat VARCHAR(20);
DECLARE @TongTienBanDau MONEY;
DECLARE @TongTienMoi MONEY;
DECLARE @GhiChuApDung NVARCHAR(100);

SELECT TOP 1 
    @MaDHMoiNhat = maDH, 
    @TongTienBanDau = tongTienDonHang 
FROM DonDatHang_HoaDon 
ORDER BY ngayTaoDH DESC, maDH DESC;

IF @TongTienBanDau > 1000000
BEGIN
    SET @TongTienMoi = @TongTienBanDau * 0.9;
    SET @GhiChuApDung = N'Giảm 10% do tổng tiền > 1.000.000';
    
    UPDATE DonDatHang_HoaDon
    SET tongTienDonHang = @TongTienMoi
    WHERE maDH = @MaDHMoiNhat;
END
ELSE IF @TongTienBanDau >= 400000
BEGIN
    SET @TongTienMoi = @TongTienBanDau;
    SET @GhiChuApDung = N'Miễn phí ship (tổng tiền từ 400.000 đến dưới 1.000.000)';
END
ELSE
BEGIN
    SET @TongTienMoi = @TongTienBanDau + 40000;
    SET @GhiChuApDung = N'Cộng phí ship 40.000 (tổng tiền < 400.000)';
    
    UPDATE DonDatHang_HoaDon
    SET tongTienDonHang = @TongTienMoi
    WHERE maDH = @MaDHMoiNhat;
END;

SELECT 
    @MaDHMoiNhat AS [Mã đơn hàng mới nhất],
    @TongTienBanDau AS [Tổng tiền ban đầu],
    @TongTienMoi AS [Tổng tiền mới cần trả],
    @GhiChuApDung AS [Chính sách áp dụng];
GO

-- f. Hãy viết đoạn lệnh để thực hiện yêu cầu: kiểm tra xem có đơn hàng nào mà tồn tại số lượng mua lớn hơn số lượng hiện có -> nếu có thì cập nhật số lượng hiện còn của các sản phẩm nằm trong giỏ hàng mà có số lượng đặt lớn hơn số lượng hiện còn bằng cách gán về số lượng đặt là 0
IF EXISTS (
    SELECT 1 
    FROM ChiTietDonHang ctdh
    INNER JOIN SanPham sp ON ctdh.maSP = sp.maSP
    WHERE ctdh.soLuongDat > sp.soLuongHienCon
)
BEGIN
    UPDATE ctdh
    SET ctdh.soLuongDat = 0
    FROM ChiTietDonHang ctdh
    INNER JOIN SanPham sp ON ctdh.maSP = sp.maSP
    WHERE ctdh.soLuongDat > sp.soLuongHienCon;
END;

SELECT 
    ctdh.maDH,
    ctdh.maSP,
    sp.tenSP,
    ctdh.soLuongDat,
    sp.soLuongHienCon,
    N'Đã gán số lượng đặt về 0 do vượt tồn kho' AS TrangThaiXuLy
FROM ChiTietDonHang ctdh
INNER JOIN SanPham sp ON ctdh.maSP = sp.maSP
WHERE ctdh.soLuongDat = 0;
GO

-- g. Viết đoạn lệnh để tính khuyến mãi theo điều kiện sau: nếu đơn hàng trên 1 triệu thì được giảm 10%, cứ tăng thêm 1 triệu nữa thì được giảm thêm 2% nữa (tối đa giảm 30%)
SELECT 
    dh.maDH,
    dh.ngayTaoDH,
    dh.tongTienDonHang AS [Tổng tiền đơn hàng],
    CASE 
        WHEN dh.tongTienDonHang <= 1000000 THEN 0
        ELSE 
            CASE 
                WHEN 10 + FLOOR((dh.tongTienDonHang - 1000000) / 1000000) * 2 > 30 THEN 30
                ELSE 10 + FLOOR((dh.tongTienDonHang - 1000000) / 1000000) * 2
            END
    END AS [Phần trăm giảm (%)],
    CASE 
        WHEN dh.tongTienDonHang <= 1000000 THEN 0
        ELSE 
            dh.tongTienDonHang * (
                CASE 
                    WHEN 10 + FLOOR((dh.tongTienDonHang - 1000000) / 1000000) * 2 > 30 THEN 30
                    ELSE 10 + FLOOR((dh.tongTienDonHang - 1000000) / 1000000) * 2
                END
            ) / 100.0
    END AS [Số tiền giảm],
    dh.tongTienDonHang - (
        CASE 
            WHEN dh.tongTienDonHang <= 1000000 THEN 0
            ELSE 
                dh.tongTienDonHang * (
                    CASE 
                        WHEN 10 + FLOOR((dh.tongTienDonHang - 1000000) / 1000000) * 2 > 30 THEN 30
                        ELSE 10 + FLOOR((dh.tongTienDonHang - 1000000) / 1000000) * 2
                    END
                ) / 100.0
        END
    ) AS [Tiền cần thanh toán]
FROM DonDatHang_HoaDon dh;
GO

-- h. Viết đoạn lệnh để đếm số lần mua của mỗi khách hàng, nếu số lần mua trên 5 thì hiển thị “Khách Vip”, ngược lại hiển thị “Khách tiềm năng”
SELECT 
    kh.maKH,
    kh.tenKH,
    COUNT(dh.maDH) AS SoLanMua,
    CASE 
        WHEN COUNT(dh.maDH) > 5 THEN N'Khách Vip'
        ELSE N'Khách tiềm năng'
    END AS LoaiKhachHang
FROM KhachHang kh
LEFT JOIN DonDatHang_HoaDon dh ON kh.maKH = dh.maKH
GROUP BY kh.maKH, kh.tenKH
ORDER BY SoLanMua DESC;
GO

-- ==============================================================================
-- 2. VIẾT CÁC THỦ TỤC
-- ==============================================================================

-- a. Tăng tự động các column ID cho tất cả các table được sinh từ thực thể mạnh (viết cả hàm và thủ tục để thực hiện việc này)

-- 1. Hàm tự động sinh mã tiếp theo dựa trên mã hiện tại, tiền tố và độ dài phần số
CREATE OR ALTER FUNCTION fn_TangMaTuDong (
    @MaHienTai VARCHAR(20),
    @TienTo VARCHAR(10),
    @DoDaiSo INT
)
RETURNS VARCHAR(20)
AS
BEGIN
    IF @MaHienTai IS NULL OR @MaHienTai = ''
        RETURN @TienTo + RIGHT(REPLICATE('0', @DoDaiSo) + '1', @DoDaiSo);

    DECLARE @PhanSo INT;
    SET @PhanSo = CAST(SUBSTRING(@MaHienTai, LEN(@TienTo) + 1, LEN(@MaHienTai)) AS INT) + 1;
    RETURN @TienTo + RIGHT(REPLICATE('0', @DoDaiSo) + CAST(@PhanSo AS VARCHAR(10)), @DoDaiSo);
END;
GO

-- 2. Thủ tục hiển thị mã ID tự động tăng tiếp theo cho tất cả các bảng sinh từ thực thể mạnh
CREATE OR ALTER PROCEDURE pr_TangMaTuDong
    @TenBang NVARCHAR(50) = NULL
AS
BEGIN
    DECLARE @MaxKH VARCHAR(20), @MaxNV VARCHAR(20), @MaxNCC VARCHAR(20), 
            @MaxSP VARCHAR(20), @MaxDH VARCHAR(20), @MaxPN VARCHAR(20);

    SELECT @MaxKH = MAX(maKH) FROM KhachHang;
    SELECT @MaxNV = MAX(maNV) FROM NhanVien;
    SELECT @MaxNCC = MAX(maNCC) FROM NhaCungCap;
    SELECT @MaxSP = MAX(maSP) FROM SanPham;
    SELECT @MaxDH = MAX(maDH) FROM DonDatHang_HoaDon;
    SELECT @MaxPN = MAX(maPN) FROM PhieuNhap;

    IF @TenBang IS NULL
    BEGIN
        SELECT N'KhachHang' AS [Tên Bảng (Thực thể mạnh)], @MaxKH AS [Mã Hiện Tại Lớn Nhất], dbo.fn_TangMaTuDong(@MaxKH, 'KH', 2) AS [Mã Tự Động Tiếp Theo]
        UNION ALL
        SELECT N'NhanVien', @MaxNV, dbo.fn_TangMaTuDong(@MaxNV, 'NV', 2)
        UNION ALL
        SELECT N'NhaCungCap', @MaxNCC, dbo.fn_TangMaTuDong(@MaxNCC, 'NCC', 2)
        UNION ALL
        SELECT N'SanPham', @MaxSP, dbo.fn_TangMaTuDong(@MaxSP, 'SP', 5)
        UNION ALL
        SELECT N'DonDatHang_HoaDon', @MaxDH, dbo.fn_TangMaTuDong(@MaxDH, 'DHTST', 2)
        UNION ALL
        SELECT N'PhieuNhap', @MaxPN, dbo.fn_TangMaTuDong(@MaxPN, 'PN', 5);
    END
    ELSE IF @TenBang = N'KhachHang'
        SELECT N'KhachHang' AS [Tên Bảng], @MaxKH AS [Mã Hiện Tại Lớn Nhất], dbo.fn_TangMaTuDong(@MaxKH, 'KH', 2) AS [Mã Tự Động Tiếp Theo];
    ELSE IF @TenBang = N'NhanVien'
        SELECT N'NhanVien' AS [Tên Bảng], @MaxNV AS [Mã Hiện Tại Lớn Nhất], dbo.fn_TangMaTuDong(@MaxNV, 'NV', 2) AS [Mã Tự Động Tiếp Theo];
    ELSE IF @TenBang = N'NhaCungCap'
        SELECT N'NhaCungCap' AS [Tên Bảng], @MaxNCC AS [Mã Hiện Tại Lớn Nhất], dbo.fn_TangMaTuDong(@MaxNCC, 'NCC', 2) AS [Mã Tự Động Tiếp Theo];
    ELSE IF @TenBang = N'SanPham'
        SELECT N'SanPham' AS [Tên Bảng], @MaxSP AS [Mã Hiện Tại Lớn Nhất], dbo.fn_TangMaTuDong(@MaxSP, 'SP', 5) AS [Mã Tự Động Tiếp Theo];
    ELSE IF @TenBang = N'DonDatHang_HoaDon'
        SELECT N'DonDatHang_HoaDon' AS [Tên Bảng], @MaxDH AS [Mã Hiện Tại Lớn Nhất], dbo.fn_TangMaTuDong(@MaxDH, 'DHTST', 2) AS [Mã Tự Động Tiếp Theo];
    ELSE IF @TenBang = N'PhieuNhap'
        SELECT N'PhieuNhap' AS [Tên Bảng], @MaxPN AS [Mã Hiện Tại Lớn Nhất], dbo.fn_TangMaTuDong(@MaxPN, 'PN', 5) AS [Mã Tự Động Tiếp Theo];
END;
GO

-- Thực thi thủ tục hiển thị mã tự động tăng tiếp theo cho tất cả các bảng thực thể mạnh
EXEC pr_TangMaTuDong;
GO

-- b. thống kê các sản phẩm bán chạy (có tham số)
CREATE OR ALTER PROCEDURE pr_ThongKeSanPhamBanChay
    @TopN INT = 3
AS
BEGIN
    SELECT TOP (@TopN) WITH TIES 
        sp.maSP,
        sp.tenSP,
        sp.donGiaBan,
        SUM(ctdh.soLuongDat) AS TongSoLuongBan
    FROM SanPham sp
    INNER JOIN ChiTietDonHang ctdh ON sp.maSP = ctdh.maSP
    GROUP BY sp.maSP, sp.tenSP, sp.donGiaBan
    ORDER BY TongSoLuongBan DESC;
END;
GO

-- Thực thi thủ tục: lấy top 3 sản phẩm bán chạy nhất
EXEC pr_ThongKeSanPhamBanChay 3;
GO

-- c. những tháng có doanh thu trên 200000 (có tham số là định mức tiền)
CREATE OR ALTER PROCEDURE pr_DoanhThuTheoThang
    @DinhMucTien MONEY = 200000
AS
BEGIN
    SELECT 
        YEAR(ngayTaoDH) AS Nam,
        MONTH(ngayTaoDH) AS Thang,
        SUM(tongTienDonHang) AS TongDoanhThu
    FROM DonDatHang_HoaDon
    WHERE trangThaiDonHang = N'Đã giao'
    GROUP BY YEAR(ngayTaoDH), MONTH(ngayTaoDH)
    HAVING SUM(tongTienDonHang) > @DinhMucTien
    ORDER BY Nam DESC, Thang DESC;
END;
GO

-- Thực thi thủ tục: lọc các tháng có doanh thu trên 200.000 VNĐ
EXEC pr_DoanhThuTheoThang 200000;
GO

-- d. thống kê số lượng khách nhau theo từng tỉnh/thành phố (sắp xếp giảm dần)
CREATE OR ALTER PROCEDURE pr_ThongKeKhachHangTheoTinhTP
AS
BEGIN
    SELECT 
        diaChiTTP AS [Tỉnh/Thành phố],
        COUNT(maKH) AS [Số lượng khách hàng]
    FROM KhachHang
    GROUP BY diaChiTTP
    ORDER BY COUNT(maKH) DESC;
END;
GO

-- Thực thi thủ tục
EXEC pr_ThongKeKhachHangTheoTinhTP;
GO

-- e. thống kê giá trung bình, giá max, giá min ở các phiếu nhập hàng cho mỗi sản phẩm
CREATE OR ALTER PROCEDURE pr_ThongKeGiaNhapSanPham
AS
BEGIN
    SELECT 
        sp.maSP,
        sp.tenSP,
        AVG(ctpn.giaNhap) AS GiaNhapTrungBinh,
        MAX(ctpn.giaNhap) AS GiaNhapCaoNhat,
        MIN(ctpn.giaNhap) AS GiaNhapThapNhat
    FROM SanPham sp
    LEFT JOIN ChiTietPhieuNhap ctpn ON sp.maSP = ctpn.maSP
    GROUP BY sp.maSP, sp.tenSP;
END;
GO

-- Thực thi thủ tục
EXEC pr_ThongKeGiaNhapSanPham;
GO

-- f. thống kê số lần khách hàng mua hàng (sắp xếp giảm dần)
CREATE OR ALTER PROCEDURE pr_ThongKeSoLanMuaHang
AS
BEGIN
    SELECT 
        kh.maKH,
        kh.tenKH,
        COUNT(dh.maDH) AS SoLanMuaHang
    FROM KhachHang kh
    LEFT JOIN DonDatHang_HoaDon dh ON kh.maKH = dh.maKH
    GROUP BY kh.maKH, kh.tenKH
    ORDER BY SoLanMuaHang DESC;
END;
GO

-- Thực thi thủ tục
EXEC pr_ThongKeSoLanMuaHang;
GO

-- g. thông kê năm có doanh thu lớn nhất (cả thông tin về năm và thông tin về doanh thu) ➔ phải dùng thủ tục (vì có 2 giá trị đầu ra)
CREATE OR ALTER PROCEDURE pr_NamDoanhThuLonNhat
    @Nam INT OUTPUT,
    @DoanhThuMax MONEY OUTPUT
AS
BEGIN
    SELECT TOP 1 
        @Nam = YEAR(ngayTaoDH),
        @DoanhThuMax = SUM(tongTienDonHang)
    FROM DonDatHang_HoaDon
    WHERE trangThaiDonHang = N'Đã giao'
    GROUP BY YEAR(ngayTaoDH)
    ORDER BY SUM(tongTienDonHang) DESC;
END;
GO

-- Thực thi thủ tục: truyền biến OUTPUT và xuất kết quả dạng bảng
DECLARE @NamMax INT;
DECLARE @DoanhThuMax MONEY;

EXEC pr_NamDoanhThuLonNhat 
    @Nam = @NamMax OUTPUT, 
    @DoanhThuMax = @DoanhThuMax OUTPUT;

SELECT 
    @NamMax AS [Năm có doanh thu lớn nhất], 
    @DoanhThuMax AS [Doanh thu lớn nhất];
GO