CREATE DATABASE IF NOT EXISTS QL_KhoaHoc;
USE QL_KhoaHoc;

-- ====================================================================================================
--  1. TẠO CÁC BẢNG (TABLES)
-- ====================================================================================================

-- 1. Bảng Vai trò
CREATE TABLE VaiTro (
    VaiTro_id INT AUTO_INCREMENT PRIMARY KEY,
    VaiTro_name VARCHAR(50) NOT NULL
);

-- 2. Bảng Thông tin người dùng
CREATE TABLE Users (
    Users_id INT AUTO_INCREMENT PRIMARY KEY,
    VaiTro_id INT NOT NULL,
    Users_name VARCHAR(100) NOT NULL,
    MatKhau VARCHAR(255) NOT NULL,
    Email VARCHAR(100) NOT NULL,
    SDT VARCHAR(15) NOT NULL,
    NgayTao DATE NOT NULL DEFAULT (CURRENT_DATE)
);

-- 3. Bảng Danh mục khóa học
CREATE TABLE DanhMuc_KhoaHoc (
    DanhMuc_id INT AUTO_INCREMENT PRIMARY KEY,
    DanhMuc_name VARCHAR(100) NOT NULL,
    MoTa VARCHAR(500) NULL
);

-- 4. Bảng Khóa học
CREATE TABLE KhoaHoc (
    KhoaHoc_id INT AUTO_INCREMENT PRIMARY KEY,
    DanhMuc_id INT NOT NULL,
    GiangVien_id INT NOT NULL,
    KhoaHoc_name VARCHAR(200) NOT NULL,
    KhoaHoc_MoTa TEXT NULL,
    Gia DECIMAL(18, 2) NOT NULL DEFAULT 0,
    NgayTao DATE NOT NULL DEFAULT (CURRENT_DATE)
);

-- 5. Bảng Bài học
CREATE TABLE BaiHoc (
    BaiHoc_id INT AUTO_INCREMENT PRIMARY KEY,
    KhoaHoc_id INT NOT NULL,
    BaiHoc_name VARCHAR(200) NOT NULL,
    NoiDung_BaiHoc TEXT NULL,
    Video_Url VARCHAR(500) NULL,
    TrinhTu_BaiHoc INT NOT NULL
);

-- 6. Bảng Đơn đăng ký khóa học
CREATE TABLE DonDangKy (
    DonDK_id INT AUTO_INCREMENT PRIMARY KEY,
    HocVien_id INT NOT NULL,
    KhoaHoc_id INT NOT NULL,
    TrangThai_DonDK VARCHAR(50) NOT NULL DEFAULT 'Chờ thanh toán',
    NgayTao DATE NOT NULL DEFAULT (CURRENT_DATE)
);

-- 7. Bảng Tiến độ học tập
CREATE TABLE TienDoHocTap (
    TienDo_id INT AUTO_INCREMENT PRIMARY KEY,
    HocVien_id INT NOT NULL,
    BaiHoc_id INT NOT NULL,
    TrangThaiHoanThanh TINYINT(1) NOT NULL DEFAULT 0,
    ThoiGianHoanThanh DATETIME NULL
);

-- 8. Bảng Hỗ trợ học viên
CREATE TABLE HoTroHocVien (
    HoTro_id INT AUTO_INCREMENT PRIMARY KEY,
    HocVien_id INT NOT NULL,
    NhanVien_id INT NULL,
    TieuDe VARCHAR(200) NOT NULL,
    NoiDung TEXT NOT NULL,
    TrangThai VARCHAR(50) NOT NULL DEFAULT 'Đang xử lý',
    NgayTao DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- 9. Bảng Chứng chỉ
CREATE TABLE ChungChi (
    ChungChi_id INT AUTO_INCREMENT PRIMARY KEY,
    HocVien_id INT NOT NULL,
    KhoaHoc_id INT NOT NULL,
    GiangVien_id INT NOT NULL,
    NgayCap DATE NOT NULL DEFAULT (CURRENT_DATE),
    DuongDanFile VARCHAR(500) NULL
);

-- ====================================================================================================
--  2. KHÓA NGOẠI & CÁC RÀNG BUỘC (CONSTRAINTS)
-- ====================================================================================================

-- Khóa ngoại Users
ALTER TABLE Users 
    ADD CONSTRAINT FK_Users_VaiTro FOREIGN KEY (VaiTro_id) REFERENCES VaiTro(VaiTro_id);

-- Khóa ngoại KhoaHoc
ALTER TABLE KhoaHoc 
    ADD CONSTRAINT FK_KhoaHoc_DanhMuc FOREIGN KEY (DanhMuc_id) REFERENCES DanhMuc_KhoaHoc(DanhMuc_id),
    ADD CONSTRAINT FK_KhoaHoc_GiangVien FOREIGN KEY (GiangVien_id) REFERENCES Users(Users_id);

-- Khóa ngoại BaiHoc
ALTER TABLE BaiHoc 
    ADD CONSTRAINT FK_BaiHoc_KhoaHoc FOREIGN KEY (KhoaHoc_id) REFERENCES KhoaHoc(KhoaHoc_id) ON DELETE CASCADE;

-- Khóa ngoại DonDangKy
ALTER TABLE DonDangKy 
    ADD CONSTRAINT FK_DonDK_HocVien FOREIGN KEY (HocVien_id) REFERENCES Users(Users_id),
    ADD CONSTRAINT FK_DonDK_KhoaHoc FOREIGN KEY (KhoaHoc_id) REFERENCES KhoaHoc(KhoaHoc_id);

-- Khóa ngoại TienDoHocTap
ALTER TABLE TienDoHocTap 
    ADD CONSTRAINT FK_TienDo_HocVien FOREIGN KEY (HocVien_id) REFERENCES Users(Users_id),
    ADD CONSTRAINT FK_TienDo_BaiHoc FOREIGN KEY (BaiHoc_id) REFERENCES BaiHoc(BaiHoc_id);

-- Khóa ngoại HoTroHocVien
ALTER TABLE HoTroHocVien 
    ADD CONSTRAINT FK_HoTro_HocVien FOREIGN KEY (HocVien_id) REFERENCES Users(Users_id),
    ADD CONSTRAINT FK_HoTro_NhanVien FOREIGN KEY (NhanVien_id) REFERENCES Users(Users_id);

-- Khóa ngoại ChungChi
ALTER TABLE ChungChi 
    ADD CONSTRAINT FK_ChungChi_HocVien FOREIGN KEY (HocVien_id) REFERENCES Users(Users_id),
    ADD CONSTRAINT FK_ChungChi_KhoaHoc FOREIGN KEY (KhoaHoc_id) REFERENCES KhoaHoc(KhoaHoc_id),
    ADD CONSTRAINT FK_ChungChi_GiangVien FOREIGN KEY (GiangVien_id) REFERENCES Users(Users_id);

-- Ràng buộc Duy nhất (UNIQUE)
ALTER TABLE Users ADD CONSTRAINT UQ_Users_Email UNIQUE (Email);
ALTER TABLE VaiTro ADD CONSTRAINT UQ_VaiTro_Name UNIQUE (VaiTro_name);
ALTER TABLE DanhMuc_KhoaHoc ADD CONSTRAINT UQ_DanhMuc_Name UNIQUE (DanhMuc_name);

-- Ràng buộc Kiểm tra (CHECK)
ALTER TABLE Users ADD CONSTRAINT CK_Users_SDT CHECK (CHAR_LENGTH(SDT) BETWEEN 9 AND 11 AND SDT NOT REGEXP '[^0-9]');
ALTER TABLE KhoaHoc ADD CONSTRAINT CK_KhoaHoc_Gia CHECK (Gia >= 0);
ALTER TABLE BaiHoc ADD CONSTRAINT CK_BaiHoc_TrinhTu CHECK (TrinhTu_BaiHoc > 0);
ALTER TABLE DonDangKy ADD CONSTRAINT CK_DonDK_TrangThai CHECK (TrangThai_DonDK IN ('Chờ thanh toán', 'Đã thanh toán', 'Đã hủy'));
ALTER TABLE TienDoHocTap ADD CONSTRAINT CK_TienDo_HoanThanh CHECK (TrangThaiHoanThanh IN (0, 1));
ALTER TABLE HoTroHocVien ADD CONSTRAINT CK_HoTro_TrangThai CHECK (TrangThai IN ('Chờ xử lý', 'Đang xử lý', 'Đã giải quyết'));

-- ====================================================================================================
--  3. DỮ LIỆU MẪU (INSERT DATA)
-- ====================================================================================================

INSERT INTO VaiTro (VaiTro_name) VALUES 
    ('Quản lý'),
    ('Nhân viên'),
    ('Giảng viên'),
    ('Học viên');

-- Cần có dữ liệu mẫu cho Users trước để các bảng khác tham chiếu đến
INSERT INTO Users (VaiTro_id, Users_name, MatKhau, Email, SDT) VALUES
    (1, 'Admin System', 'hash_pass_1', 'admin@gmail.com', '0901111111'),
    (2, 'Lê Nhân Viên', 'hash_pass_2', 'nhanvien@gmail.com', '0902222222'),
    (3, 'Nguyễn Văn A', 'hash_pass_3', 'giangvien@gmail.com', '0903333333'),
    (4, 'Trần Thị B', 'hash_pass_4', 'hocvien1@gmail.com', '0904444444'),
    (4, 'Phạm Văn C', 'hash_pass_5', 'hocvien2@gmail.com', '0905555555');

INSERT INTO DanhMuc_KhoaHoc (DanhMuc_name, MoTa) VALUES 
    ('Lập trình Web', 'Các khóa học xây dựng website từ Front-end đến Back-end'),
    ('Lập trình Di động', 'Phát triển ứng dụng Android và iOS với Flutter, React Native, Swift'),
    ('Khoa học Dữ liệu', 'Phân tích dữ liệu, Trực quan hóa dữ liệu và Machine Learning'),
    ('Trí tuệ nhân tạo (AI)', 'Nghiên cứu Deep Learning, Computer Vision và xử lý ngôn ngữ tự nhiên (NLP)'),
    ('An toàn thông tin', 'Bảo mật hệ thống, Kiểm thử xâm nhập (Penetration Testing) và Bất hợp pháp'),
    ('Điện toán đám mây', 'Quản trị và triển khai hệ thống trên AWS, Azure, Google Cloud'),
    ('DevOps & System', 'Tự động hóa quy trình CI/CD, Docker, Kubernetes và quản trị Linux'),
    ('Cơ sở dữ liệu', 'Thiết kế, tối ưu hóa CSDL SQL Server, MySQL, PostgreSQL và MongoDB'),
    ('Kiểm thử phần mềm', 'Manual Testing, Automation Testing với Selenium, Katalon'),
    ('Thiết kế UI/UX', 'Thiết kế giao diện và trải nghiệm người dùng với Figma, Adobe XD'),
    ('Thiết kế Đồ họa', 'Sử dụng Photoshop, Illustrator, Premiere cho truyền thông số'),
    ('Tin học Văn phòng', 'Thành thạo Excel, Word, PowerPoint cho công sở và báo cáo'),
    ('Ngoại ngữ CNTT', 'Tiếng Anh chuyên ngành Công nghệ thông tin và luyện thi chứng chỉ'),
    ('Marketing Digital', 'SEO, Google Ads, Facebook Ads và Content Marketing'),
    ('Quản trị Dự án CNTT', 'Phương pháp luận Agile, Scrum và công cụ quản lý dự án Jira'),
    ('Lập trình Game', 'Phát triển game 2D/3D với Unity, Unreal Engine, C#'),
    ('Công nghệ Blockchain', 'Phát triển Hợp đồng thông minh (Smart Contract) và DApp'),
    ('Lập trình Nhúng & IoT', 'Lập trình C/C++, Arduino, Raspberry Pi cho thiết bị thông minh'),
    ('Kỹ năng mềm', 'Kỹ năng giao tiếp, làm việc nhóm và giải quyết vấn đề trong môi trường tech'),
    ('Khởi nghiệp Tech', 'Kiến thức xây dựng sản phẩm công nghệ và gọi vốn Startup');

INSERT INTO KhoaHoc (DanhMuc_id, GiangVien_id, KhoaHoc_name, KhoaHoc_MoTa, Gia, NgayTao) VALUES 
    (1, 3, 'Lập trình Web Fullstack với Node.js và React', 'Học làm trang web hoàn chỉnh từ Front-end đến Back-end', 1200000.00, CURRENT_DATE),
    (2, 3, 'Lập trình ứng dụng Android & iOS bằng Flutter', 'Xây dựng app đa nền tảng từ cơ bản đến nâng cao', 1500000.00, CURRENT_DATE),
    (3, 3, 'Phân tích dữ liệu với Python và Pandas', 'Thành thạo xử lý dữ liệu lớn và trực quan hóa dữ liệu', 990000.00, CURRENT_DATE),
    (4, 3, 'Nhập môn Machine Learning & Deep Learning', 'Học thuật toán học máy và ứng dụng xây dựng mô hình AI', 2000000.00, CURRENT_DATE),
    (5, 3, 'Bảo mật Web và Kiểm thử xâm nhập (Ethical Hacking)', 'Nghiên cứu các lỗ hổng OWASP và kỹ thuật phòng chống tấn công', 1800000.00, CURRENT_DATE),
    (6, 3, 'Chuyện nghề AWS - Luyện thi chứng chỉ Solutions Architect', 'Kiến thức thực tế triển khai hạ tầng trên cloud AWS', 2500000.00, CURRENT_DATE),
    (7, 3, 'DevOps thực chiến với Docker, Kubernetes và CI/CD', 'Tự động hóa quy trình đóng gói và triển khai phần mềm', 1750000.00, CURRENT_DATE),
    (8, 3, 'Thiết kế và Tối ưu hóa SQL Server chuyên sâu', 'Viết truy vấn nâng cao, làm chủ Index, Stored Procedure và Transaction', 850000.00, CURRENT_DATE),
    (9, 3, 'Kỹ năng Kiểm thử phần mềm (Tester) cho người mới', 'Học viết Test Case, Test Plan và kiểm thử thủ công/tự động', 750000.00, CURRENT_DATE),
    (10, 3, 'Thiết kế giao diện Mobile & Web chuyên nghiệp với Figma', 'Quy trình thiết kế Wireframe, Prototype và Design System', 1100000.00, CURRENT_DATE),
    (11, 3, 'Làm chủ Photoshop & Illustrator từ chưa biết gì', 'Thiết kế banner, poster và bộ nhận diện thương hiệu', 650000.00, CURRENT_DATE),
    (12, 3, 'Tuyệt chiêu Excel ứng dụng trong Báo cáo & Phân tích', 'Hàm nâng cao, PivotTable và tự động hóa với VBA cơ bản', 450000.00, CURRENT_DATE),
    (13, 3, 'Tiếng Anh giao tiếp và viết Tài liệu Kỹ thuật cho IT', 'Từ vựng chuyên ngành, cách viết Email và giao tiếp với khách hàng tây', 500000.00, CURRENT_DATE),
    (14, 3, 'SEO và Google Ads thực chiến cho Website', 'Đưa website lên Top Google và tối ưu hóa chi phí quảng cáo', 890000.00, CURRENT_DATE),
    (15, 3, 'Quản trị dự án Agile/Scrum với Jira Software', 'Vận hành dự án phần mềm theo mô hình Linh hoạt hiệu quả', 1300000.00, CURRENT_DATE),
    (16, 3, 'Phát triển Game 2D đơn giản với Unity và C#', 'Tự tay làm ra trò chơi đầu tay và phát hành lên Google Play', 1400000.00, CURRENT_DATE),
    (17, 3, 'Lập trình Smart Contract trên Ethereum với Solidity', 'Xây dựng ứng dụng phi tập trung (DApp) và Token ERC-20', 2200000.00, CURRENT_DATE),
    (18, 3, 'Lập trình IoT với Arduino và ESP32', 'Xây dựng hệ thống nhà thông minh (Smart Home) kết nối Wifi/Bluetooth', 1600000.00, CURRENT_DATE),
    (19, 3, 'Kỹ năng Giao tiếp và Làm việc nhóm hiệu quả cho Lập trình viên', 'Nâng cao EQ, giải quyết mâu thuẫn và kỹ năng thuyết trình', 350000.00, CURRENT_DATE),
    (20, 3, 'Xây dựng sản phẩm MVP và Gọi vốn Startup Công nghệ', 'Từ ý tưởng đến mô hình kinh doanh và tìm kiếm nhà đầu tư', 1900000.00, CURRENT_DATE);

INSERT INTO BaiHoc (KhoaHoc_id, BaiHoc_name, NoiDung_BaiHoc, Video_Url, TrinhTu_BaiHoc) VALUES 
    (1, 'Giới thiệu tổng quan về Web Fullstack', 'Nội dung tổng quan về Front-end, Back-end và các công cụ cần cài đặt.', NULL, 1),
    (1, 'Cơ bản về HTML5 & CSS3', 'Cấu trúc thẻ HTML5 cơ bản, cách định dạng giao diện bằng CSS3.', NULL, 2),
    (1, 'Lập trình ES6 Javascript nâng cao', 'Các tính năng Arrow function, Destructuring, Promise và Async/Await.', NULL, 3),
    (1, 'Xây dựng RESTful API với Express.js', 'Tạo các endpoint GET, POST, PUT, DELETE xử lý dữ liệu.', NULL, 4),
    (1, 'Tích hợp ReactJS và Kết nối API', 'Sử dụng React Hooks, State, Props để dựng giao diện tương tác API.', NULL, 5),
    (2, 'Cài đặt môi trường Flutter & Dart SDK', 'Hướng dẫn cài đặt Flutter trên Windows/Mac và thiết lập Android Studio.', NULL, 1),
    (2, 'Lập trình ngôn ngữ Dart cơ bản', 'Biến, kiểu dữ liệu, hàm và lập trình hướng đối tượng OOP trong Dart.', NULL, 2),
    (2, 'Các Widget cơ bản trong Flutter', 'Tìm hiểu Container, Row, Column, ListView và Text Widget.', NULL, 3),
    (3, 'Cài đặt Jupyter Notebook và Python base', 'Cài đặt Anaconda, môi trường làm việc Jupyter Notebook.', NULL, 1),
    (3, 'Làm chủ thư viện Numpy', 'Thao tác trên mảng đa chiều và tính toán số học với Numpy.', NULL, 2),
    (3, 'Xử lý và làm sạch dữ liệu với Pandas', 'Đọc file CSV, Excel, xử lý giá trị thiếu (Null) và lọc dữ liệu.', NULL, 3),
    (4, 'Tổng quan về Trí tuệ nhân tạo & Machine Learning', 'Phân biệt Supervised Learning, Unsupervised Learning và Reinforcement Learning.', NULL, 1),
    (4, 'Thuật toán Linear Regression & Logistic Regression', 'Mô hình hồi quy tuyến tính và bài toán phân loại nhị phân.', NULL, 2),
    (4, 'Xây dựng Mạng Nơ-ron nhân tạo với PyTorch', 'Cấu trúc Neural Network, Activation Functions và Backpropagation.', NULL, 3),
    (5, 'Tổng quan về lỗ hổng OWASP Top 10', 'Giới thiệu các rủi ro an toàn thông tin phổ biến nhất hiện nay.', NULL, 1),
    (5, 'Kỹ thuật tấn công và phòng chống SQL Injection', 'Cách phát hiện điểm yếu SQL Injection và sử dụng Parameterized Query.', NULL, 2),
    (5, 'Tấn công XSS (Cross-Site Scripting)', 'Phân loại Stored XSS, Reflected XSS và giải pháp Escaping dữ liệu.', NULL, 3),
    (6, 'Tổng quan về hạ tầng AWS Cloud', 'Tìm hiểu Cloud Computing, Region và Availability Zone.', NULL, 1),
    (6, 'Quản lý truy cập IAM (Identity and Access Management)', 'Tạo User, Role, Group và phân quyền bằng Policy.', NULL, 2),
    (6, 'Khởi tạo máy chủ ảo Amazon EC2', 'Tạo EC2 Instance, Security Group, SSH vào máy chủ Linux.', NULL, 3),
    (7, 'Tổng quan về DevOps và Containerization', 'Sự khác biệt giữa Virtual Machine và Docker Container.', NULL, 1),
    (7, 'Viết Dockerfile và đóng gói ứng dụng', 'Các câu lệnh FROM, RUN, COPY, CMD trong Dockerfile.', NULL, 2),
    (7, 'Xây dựng quy trình CI/CD với GitHub Actions', 'Viết file YAML tự động test và deploy code lên server.', NULL, 3),
    (8, 'Tổng quan về Kiến trúc SQL Server', 'Cấu trúc lưu trữ dữ liệu, Transaction Log và Buffer Pool.', NULL, 1),
    (8, 'Tối ưu hóa chỉ mục (Index) Clustered & Non-Clustered', 'Cách tạo và tối ưu chỉ mục giúp tăng tốc độ truy vấn SELECT.', NULL, 2),
    (8, 'Viết Stored Procedure & Transaction an toàn', 'Quản lý giao dịch, các cấp độ Isolation Level để tránh Deadlock.', NULL, 3),
    (9, 'Quy trình kiểm thử phần mềm (STLC)', 'Các bước trong vòng đời kiểm thử phần mềm từ Requirement đến Report.', NULL, 1),
    (9, 'Kỹ thuật viết Test Case chuẩn chỉnh', 'Cách thiết kế Kịch bản kiểm thử, preconditions và expected results.', NULL, 2),
    (10, 'Làm quen với giao diện Figma', 'Các công cụ Canvas, Frame, Shape và Text trong Figma.', NULL, 1),
    (10, 'Tạo Component và Auto-layout', 'Tối ưu thiết kế giao diện bằng Component tái sử dụng và Auto-layout.', NULL, 2),
    (11, 'Cơ bản về Layer và Selection trong Photoshop', 'Quản lý lớp, tách nền ảnh bằng Pen Tool và Lasso Tool.', NULL, 1),
    (11, 'Thiết kế Banner đồ họa với Illustrator', 'Sử dụng Shape Builder, Gradient và Typography.', NULL, 2),
    (12, 'Thành thạo các hàm xử lý chuỗi và điều kiện', 'Ứng dụng IF, AND, OR, VLOOKUP, XLOOKUP và INDEX/MATCH.', NULL, 1),
    (12, 'Tạo Báo cáo Động với PivotTable', 'Tổng hợp dữ liệu lớn và vẽ biểu đồ báo cáo Dashboard.', NULL, 2),
    (13, 'Từ vựng Tiếng Anh chuyên ngành Phần mềm', 'Thuật ngữ mô tả chức năng, thuật toán và tài liệu kỹ thuật.', NULL, 1),
    (13, 'Kỹ năng viết Email giao tiếp với Khách hàng', 'Cấu trúc email báo cáo tiến độ, giải trình bug và trao đổi yêu cầu.', NULL, 2),
    (14, 'Nghiên cứu Từ khóa và Tối ưu SEO Onpage', 'Sử dụng Google Keyword Planner, tối ưu Title, Meta Description.', NULL, 1),
    (14, 'Tạo chiến dịch Quảng cáo Google Search', 'Cách thiết lập ngân sách, chọn từ khóa và viết mẫu quảng cáo.', NULL, 2),
    (15, 'Tổng quan về Mô hình Agile & Scrum Framework', 'Tìm hiểu các vai trò Product Owner, Scrum Master và Development Team.', NULL, 1),
    (15, 'Quản lý Sprint và Backlog trên Jira', 'Tạo User Story, ước lượng Story Point và theo dõi Burndown Chart.', NULL, 2),
    (16, 'Cài đặt Unity và Giao diện Editor', 'Tìm hiểu Scene View, Game View, Hierarchy và Inspector.', NULL, 1),
    (16, 'Viết Script điều khiển nhân vật di chuyển', 'Sử dụng C# để viết logic di chuyển, nhảy và va chạm (Collision).', NULL, 2),
    (17, 'Giới thiệu EVM và Ngôn ngữ Solidity', 'Cấu trúc một file hợp đồng thông minh (.sol) cơ bản.', NULL, 1),
    (17, 'Viết và Deploy Token ERC-20 lên Testnet', 'Xây dựng các hàm transfer, approve, balanceOf theo chuẩn ERC-20.', NULL, 2),
    (18, 'Làm quen với Bo mạch ESP32', 'Sơ đồ chân Cổng I/O, giao tiếp Serial và nạp code qua Arduino IDE.', NULL, 1),
    (18, 'Đọc dữ liệu Cảm biến và hiển thị lên Web', 'Lập trình đọc cảm biến nhiệt độ DHT11 và truyền dữ liệu qua Wi-Fi.', NULL, 2),
    (19, 'Lắng nghe chủ động và Truyền đạt ý tưởng', 'Cách trình trình bày giải pháp kỹ thuật cho người không làm IT hiểu.', NULL, 1),
    (19, 'Quản lý xung đột trong Team Dev', 'Giải quyết bất đồng quan điểm khi Code Review và phân chia công việc.', NULL, 2),
    (20, 'Định hình Sản phẩm Khả thi Tối thiểu (MVP)', 'Phương pháp xác định các tính năng cốt lõi cần làm trước.', NULL, 1),
    (20, 'Xây dựng Pitch Deck thuyết phục Nhà đầu tư', 'Cấu trúc slide trình bày về bài toán, giải pháp và mô hình doanh thu.', NULL, 2);

INSERT INTO DonDangKy (HocVien_id, KhoaHoc_id, TrangThai_DonDK, NgayTao) VALUES 
    (4, 1, 'Đã thanh toán', '2026-01-10'),
    (4, 2, 'Đã thanh toán', '2026-01-12'),
    (4, 3, 'Chờ thanh toán', '2026-01-15'),
    (4, 4, 'Đã thanh toán', '2026-01-20'),
    (4, 5, 'Đã hủy', '2026-01-22'),
    (4, 6, 'Đã thanh toán', '2026-02-01'),
    (4, 7, 'Chờ thanh toán', '2026-02-03'),
    (4, 8, 'Đã thanh toán', '2026-02-05'),
    (4, 9, 'Đã thanh toán', '2026-02-10'),
    (4, 10, 'Đã hủy', '2026-02-12'),
    (5, 11, 'Đã thanh toán', '2026-02-15'),
    (5, 12, 'Chờ thanh toán', '2026-02-18'),
    (5, 13, 'Đã thanh toán', '2026-02-20'),
    (5, 14, 'Đã thanh toán', '2026-02-25'),
    (5, 15, 'Chờ thanh toán', '2026-03-01'),
    (5, 16, 'Đã thanh toán', '2026-03-02'),
    (5, 17, 'Đã hủy', '2026-03-05'),
    (5, 18, 'Đã thanh toán', '2026-03-10'),
    (5, 19, 'Đã thanh toán', '2026-03-12'),
    (5, 20, 'Chờ thanh toán', '2026-03-15');

INSERT INTO TienDoHocTap (HocVien_id, BaiHoc_id, TrangThaiHoanThanh, ThoiGianHoanThanh) VALUES 
    (4, 1, 1, '2026-01-11 08:30:00'),
    (4, 2, 1, '2026-01-11 10:15:00'),
    (4, 3, 1, '2026-01-12 14:20:00'),
    (4, 4, 1, '2026-01-13 09:00:00'),
    (4, 5, 1, '2026-01-14 16:45:00'),
    (4, 6, 1, '2026-01-15 11:00:00'),
    (4, 7, 0, NULL),
    (5, 9, 1, '2026-01-16 19:30:00'),
    (5, 10, 1, '2026-01-17 20:00:00'),
    (5, 11, 0, NULL);

INSERT INTO HoTroHocVien (HocVien_id, NhanVien_id, TieuDe, NoiDung, TrangThai, NgayTao) VALUES 
    (4, 2, 'Lỗi thanh toán khóa học 1', 'Em đã chuyển khoản thành công khóa học Web Fullstack nhưng hệ thống chưa duyệt ạ.', 'Đã giải quyết', '2026-01-10 09:00:00'),
    (4, 2, 'Không xem được slide bài học 3', 'Slide bài học ES6 Javascript bị lỗi đường dẫn 404 không tải được.', 'Đã giải quyết', '2026-01-12 15:30:00'),
    (5, 2, 'Hỏi về thời gian nhận chứng chỉ', 'Sau khi hoàn thành khóa học thì bao lâu em sẽ có chứng chỉ online ạ?', 'Đã giải quyết', '2026-01-15 10:15:00'),
    (4, 2, 'Xin gia hạn khóa học Flutter', 'Sắp tới em bận thi học kỳ nên cho em xin gia hạn thêm 1 tháng học nhé.', 'Đang xử lý', '2026-02-01 14:00:00'),
    (5, 2, 'Lỗi nạp bài tập trên hệ thống', 'Em upload file nạp bài học Python bị báo lỗi dung lượng vượt quá 10MB.', 'Đang xử lý', '2026-02-05 16:20:00'),
    (4, NULL, 'Tài khoản không đăng nhập được', 'Em bấm quên mật khẩu nhưng chưa nhận được mail gửi mã OTP reset.', 'Chờ xử lý', '2026-02-10 08:45:00'),
    (5, NULL, 'Thắc mắc về lịch Livestream', 'Cho em hỏi lịch hỗ trợ trực tiếp của giảng viên khóa Data Science rơi vào thứ mấy ạ?', 'Chờ xử lý', '2026-02-12 11:00:00'),
    (4, 2, 'Xin tài liệu phụ trợ bài học 5', 'Nhân viên gửi giúp em file source code mẫu của phần kết nối ReactJS API với ạ.', 'Đã giải quyết', '2026-02-15 13:10:00'),
    (5, 2, 'Thay đổi thông tin cá nhân', 'Em bị gõ sai tên trên chứng chỉ, nhờ hỗ trợ đổi từ Phạm C sang Phạm Văn C.', 'Đang xử lý', '2026-02-18 09:30:00'),
    (4, NULL, 'Góp ý giao diện trang web', 'Nên thêm chế độ Dark Mode cho khu vực bài học để bớt mỏi mắt buổi tối ạ.', 'Chờ xử lý', '2026-02-20 21:00:00');

INSERT INTO ChungChi (HocVien_id, KhoaHoc_id, GiangVien_id, NgayCap, DuongDanFile) VALUES 
    (4, 1, 3, '2026-01-15', NULL),
    (4, 3, 3, '2026-01-25', NULL),
    (4, 6, 3, '2026-02-08', NULL),
    (4, 8, 3, '2026-02-12', NULL),
    (4, 11, 3, '2026-02-22', NULL),
    (5, 2, 3, '2026-01-18', NULL),
    (5, 4, 3, '2026-01-28', NULL),
    (5, 9, 3, '2026-02-15', NULL),
    (5, 12, 3, '2026-02-25', NULL),
    (5, 14, 3, '2026-03-01', NULL);
