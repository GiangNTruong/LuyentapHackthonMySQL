create database baiTonghop2;
use baiTonghop2;
CREATE TABLE if not exists Category (
                          Id INT PRIMARY KEY AUTO_INCREMENT,
                          Name VARCHAR(100) NOT NULL UNIQUE,
                          Status TINYINT DEFAULT 1 CHECK (Status IN (0, 1))
);


CREATE TABLE if not exists Room (
                                    Id INT PRIMARY KEY AUTO_INCREMENT,
                                    Name VARCHAR(150) NOT NULL,
                                    Status TINYINT DEFAULT 1 CHECK (Status IN (0, 1)),
                                    Price FLOAT not null CHECK (Price >= 100000),
                                    SalePrice FLOAT DEFAULT 0,
                                    CreatedDate DATE DEFAULT (curdate()),
                                    CategoryId INT not null,
                                    INDEX idx_created_date (CreatedDate)
);
CREATE TABLE IF NOT EXISTS Customer (
                                        Id INT PRIMARY KEY AUTO_INCREMENT, -- Khóa chính tự động tăng
                                        Name VARCHAR(150) NOT NULL, -- Không rỗng
                                        Email VARCHAR(150) NOT NULL UNIQUE CHECK ( Email REGEXP '^[A-Za-z0-9._%-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}$' ), -- Không rỗng, không trùng nhau, định dạng email
                                        Phone VARCHAR(50) NOT NULL UNIQUE, -- Không rỗng, không trùng nhau
                                        Address VARCHAR(255),
                                        CreatedDate DATE DEFAULT (curdate()), -- Mặc định ngày hiện tại
                                        Gender TINYINT NOT NULL CHECK (Gender IN (0, 1, 2)), -- Không rỗng, chỉ cho nhập 0 hoặc 1, hoặc 2
                                        BirthDay DATE NOT NULL -- Không rỗng
);

create table if not exists booking (
    id int primary key auto_increment ,
    customerId int not null ,
    status tinyint check ( status in (0,1,2)),
    bookingDate datetime default now()
);
CREATE TABLE IF NOT EXISTS bookingDetail
(
    bookingId INT      NOT NULL,
    roomId    INT      NOT NULL,
    price     FLOAT    NOT NULL,
    startDate DATETIME NOT NULL,
    endDate   DATETIME NOT NULL,
    CHECK (endDate > startDate),
    PRIMARY KEY (bookingId, roomId) -- Khóa chính từ 2 cột bookingId và roomId
);

-- Thêm khóa ngoại cho bảng Room
ALTER TABLE Room
    ADD CONSTRAINT FK_Room_Category
        FOREIGN KEY (CategoryId) REFERENCES Category(Id);

-- Thêm khóa ngoại cho bảng Booking
ALTER TABLE Booking
    ADD CONSTRAINT FK_Booking_Customer
        FOREIGN KEY (CustomerId) REFERENCES Customer(Id);

-- Thêm khóa ngoại cho bảng BookingDetail
ALTER TABLE BookingDetail
    ADD CONSTRAINT FK_BookingDetail_Booking
        FOREIGN KEY (BookingId) REFERENCES Booking(Id);

ALTER TABLE BookingDetail
    ADD CONSTRAINT FK_BookingDetail_Room
        FOREIGN KEY (RoomId) REFERENCES Room(Id);


#  de creadate cua bang customer luon >= ngay hien tai
DELIMITER //
CREATE TRIGGER check_date
    BEFORE INSERT ON Customer
    FOR EACH ROW
BEGIN
    IF NEW.CreatedDate < CURDATE() THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'CreatedDate phải lớn hơn hoặc bằng ngày hiện tại';
    END IF;
END;//
DELIMITER ;

# trigger o bang room so sanh SalePrice<=Price
delimiter //
create trigger check_price
    before insert on Room
    for each row
    begin
        if NEW.SalePrice > NEW.Price then
            SIGNAL SQLSTATE '45000'
                SET MESSAGE_TEXT = 'SalePrice ko duoc lon hon Price';
        end if ;
    end //;
delimiter ;

INSERT INTO Category (Name)
VALUES ('Category 1'),
       ('Category 2'),
       ('Category 3'),
       ('Category 4'),
       ('Category 5');

INSERT INTO Room (Name, Price, CategoryId)
VALUES ('Room 1', 200000, 1),
       ('Room 2', 300000, 1),
       ('Room 3', 400000, 1),
       ('Room 4', 500000, 2),
       ('Room 5', 600000, 2),
       ('Room 6', 700000, 2),
       ('Room 7', 800000, 3),
       ('Room 8', 900000, 3),
       ('Room 9', 1000000, 3),
       ('Room 10', 1100000, 4),
       ('Room 11', 1200000, 4),
       ('Room 12', 1300000, 4),
       ('Room 13', 1400000, 5),
       ('Room 14', 1500000, 5),
       ('Room 15', 1600000, 5);


INSERT INTO Customer (Name, Email, Phone, Address, Gender, BirthDay)
VALUES ('Customer 1', 'customer1@example.com', '1234567890', 'Address 1', 1, '1990-01-01'),
       ('Customer 2', 'customer2@example.com', '0987654321', 'Address 2', 0, '1991-01-01'),
       ('Customer 3', 'customer3@example.com', '1029384756', 'Address 3', 2, '1992-01-01');


INSERT INTO Booking (customerId, status)
VALUES (1, 1),
       (2, 1),
       (3, 1);

INSERT INTO BookingDetail (bookingId, roomId, price, startDate, endDate)
VALUES (1, 1, 200000, '2024-05-01 00:00:00', '2024-05-02 00:00:00'),
       (1, 2, 300000, '2024-05-02 00:00:00', '2024-05-03 00:00:00'),
       (2, 3, 400000, '2024-05-03 00:00:00', '2024-05-04 00:00:00'),
       (2, 4, 500000, '2024-05-04 00:00:00', '2024-05-05 00:00:00'),
       (3, 5, 600000, '2024-05-05 00:00:00', '2024-05-06 00:00:00'),
       (3, 6, 700000, '2024-05-06 00:00:00', '2024-05-07 00:00:00');
select r.id, r.name, r.price, r.saleprice, r.status, t.name as categoryname, r.createddate
from room r
         join category t on r.categoryid = t.id
order by r.price desc;

select c.id, c.name, count(r.id) as totalroom,
       case
           when c.status = 0 then 'ẩn'
           when c.status = 1 then 'hiển thị'
           end as status
from category c
         left join room r on c.id = r.categoryid
group by c.id, c.name, c.status
order by c.id;

select id, name, email, phone, address, createddate, birthday,
       case
           when gender = 0 then 'nam'
           when gender = 1 then 'nữ'
           else 'khác'
           end as gender,
       year(curdate()) - year(birthday) as age
from customer;

# 4.	Truy vấn xóa các sản phẩm chưa được bán
delete from room
where id not in (select distinct roomId from bookingDetail);

# 5.	Cập nhật Cột SalePrice tăng thêm 10% cho tất cả các phòng có Price >= 250000
update room
set SalePrice = SalePrice * 1.1
where Price >= 250000;

#  view
create view v_getRoominfo as select * from room
order by Price desc
limit 10;

create view v_getBookingList as
    select b.id, b.bookingDate,
           case
               when b.status = 0 then 'Chưa duyệt'
               when b.status = 1 then 'Đã duyệt'
               when b.status = 2 then 'Đã thanh toán'
               when b.status = 3 then 'Đã hủy'
               end as status,
           c.name as CusName, c.email, c.phone,
           (select sum(price) from bookingDetail where bookingId = b.id) as TotalAmount from booking b
join customer c on b.customerId = c.Id;

# Procedure
# 1.	Thủ tục addRoomInfo thực hiện thêm mới Room,
# khi gọi thủ tục truyền đầy đủ các giá trị của bảng Room ( Trừ cột tự động tăng )
delimiter //
create procedure addRoomInfo(
    Name_in VARCHAR(150),
    Status_in TINYINT,
    Price_in FLOAT,
    SalePrice_in FLOAT,
    CreatedDate_in DATE,
    CategoryId_in INT)
begin
    insert into room(name, status, price, saleprice, createddate, categoryid)
        value (Name_in,Status_in,Price_in,SalePrice_in,CreatedDate_in,CategoryId_in);
end;
delimiter //

call addRoomInfo( 'Room 17',1, 2000000, 300000,'2024-04-25', 5);

# 2.	Thủ tục getBookingByCustomerId hiển thị danh sách phieu đặt phòng của khách hàng theo Id khách hàng gồm:
# Id, BookingDate, Status, TotalAmount (Trong đó cột Status nếu = 0 Chưa duyệt, = 1  Đã duyệt,, = 2 Đã thanh toán, = 3 Đã hủy),
# Khi gọi thủ tục truyền vào id của khách hàng
delimiter //
create procedure getBookingByCustomerId (  booking_in int )
begin
    select b.Id, BookingDate, case
        when b.status =0 then 'chưa duyệt'
        when b.status =1 then 'đã duyệt'
        when b.status = 2 then 'đã thanh toán'
        when b.status = 3 then 'đã hủy'
        else 'Không xác định'
            end as status
        ,(select sum(bd.price) from bookingDetail bd where bd.bookingId =  b.id) as TotalAmount from booking b
    where b.customerId = booking_in;
end ;
delimiter //;
call getBookingByCustomerId(1);

# 3.	Thủ tục getRoomPaginate lấy ra danh sách phòng có phân trang gồm:
# Id, Name, Price, SalePrice, Khi gọi thủ tuc truyền vào limit và page
delimiter //
create procedure getRoomPaginate (page int , size int)
begin
    declare off_set int ;
    set off_set= page*size;
    select Id, Name, Price, SalePrice from room limit off_set,size;
end //
delimiter //
call getRoomPaginate(0,2);


# Trigger
# 1.Tạo trigger tr_Check_Price_Value sao cho khi thêm
# hoặc sửa phòng Room nếu nếu giá trị của cột Price > 5000000
# thì tự động chuyển về 5000000 và in ra thông báo ‘Giá phòng lớn nhất 5 triệu’
delimiter //
create trigger tr_Check_Price_Value_before_insert
    before insert
    on room
    for each row
    begin
        if new.Price > 5000000 then
            set new.Price=500000;
        end if ;
    end ;
delimiter //
INSERT INTO Room(Name, Status, Price, SalePrice, CategoryId)
VALUES (' Room 19', 1, 6000000, 0, 1);


DELIMITER //
CREATE TRIGGER tr_Check_Price_Value_Update
    BEFORE UPDATE ON Room
    FOR EACH ROW
BEGIN
    IF NEW.Price > 5000000 THEN
        SET NEW.Price = 5000000;
    END IF;
END;//
DELIMITER ;

UPDATE Room
SET Price = 7000000
WHERE Id = 1;
