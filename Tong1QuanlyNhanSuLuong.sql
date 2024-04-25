create  database QuanLyNhanSuTienLuong;
create table department (
    Id int primary key auto_increment,
    Name varchar(100) not null unique check ( length(Name)>=6 )
);

create table Levels(
    Id int primary key auto_increment,
    Name varchar(100) not null unique ,
    basicSalary float not null check ( basicSalary>=3500000 ),
    allowancesalary float default 500000
);

create table employee(
    Id int auto_increment primary key ,
    Name varchar(150) not null ,
    Email varchar(150) not null unique ,
    Phone varchar(50) not null unique ,
    address varchar(255),
    gender tinyint not null check ( gender in (0,1,2)),
    BirthDay date not null ,
    LevelId int not null ,
    DepartmentId int not null ,
    foreign key (LevelId) references Levels(Id),
    foreign key (DepartmentId) references department(id)
);

create table Timesheets(
    id int auto_increment primary key ,
    attendanceDate datetime not null default now(),
    EmployeeId int not null ,
    Value float not null default 1 check ( Value in (0, 0.5, 1)),
    foreign key (EmployeeId) references employee(id)
);

create table Salary(
                       Id int auto_increment primary key ,
                       EmployeeId int not null ,
                       bonusSalary float default 0,
                       Insurrance float,
                       FOREIGN KEY (EmployeeId) references employee(id)
);

CREATE TRIGGER update_insurrance
    BEFORE INSERT
    ON Salary
    FOR EACH ROW
BEGIN
    SET NEW.Insurrance = (SELECT Levels.BasicSalary * 0.1
                          FROM Employee
                                   JOIN Levels ON Employee.LevelId = Levels.Id
                          WHERE Employee.Id = NEW.EmployeeId);
END;


# thêm dữ liệu
INSERT INTO department (Name)
VALUES ('Nhân sự'),
       ('Tiếp thị'),
       ('Tài chính');

INSERT INTO Levels (Name, basicSalary, allowancesalary)
VALUES ('Level 1', 4000000, 500000),
       ('Level 2', 4500000, 600000),
       ('Level 3', 5000000, 700000);

INSERT INTO employee (Name, Email, Phone, address, gender, BirthDay, LevelId, DepartmentId)
VALUES ('Employee 1', 'employee1@example.com', '1234567890', 'Address 1', 1, '1980-01-01', 1, 1),
       ('Employee 2', 'employee2@example.com', '1234567891', 'Address 2', 0, '1981-02-02', 2, 2),
       ('Employee 3', 'employee3@example.com', '1234567892', 'Address 3', 2, '1982-03-03', 3, 3),
       ('Employee 4', 'employee4@example.com', '1234567893', 'Address 4', 2, '1982-03-03', 1, 1),
       ('Employee 5', 'employee5@example.com', '1234567894', 'Address 5', 1, '1982-03-03', 2, 2),
       ('Employee 6', 'employee6@example.com', '1234567895', 'Address 1', 1, '1982-03-03', 3, 3),
       ('Employee 7', 'employee7@example.com', '1234567896', 'Address 2', 1, '1982-03-03', 1, 1),
       ('Employee 8', 'employee8@example.com', '1234567897', 'Address 3', 2, '1982-03-03', 2, 1),
       ('Employee 9', 'employee9@example.com', '1234567898', 'Address 4', 2, '1982-03-03', 3, 1),
       ('Employee 10', 'employee10@example.com', '1234567899', 'Address 5', 2, '1982-03-03', 1, 2),
       ('Employee 11', 'employee11@example.com', '1234567880', 'Address 1', 0, '1982-03-03', 2, 2),
       ('Employee 12', 'employee12@example.com', '1234567881', 'Address 2', 0, '1982-03-03', 3, 2),
       ('Employee 13', 'employee13@example.com', '1234567882', 'Address 3', 1, '1982-03-03', 1, 3),
       ('Employee 14', 'employee14@example.com', '1234567883', 'Address 4', 2, '1982-03-03', 2, 3),
       ('Employee 15', 'employee15@example.com', '1234567884', 'Address 5', 0, '1982-03-03', 3, 3);

# v4.	Bảng Timesheets ít nhất 30 bản ghi dữ liệu phù hợp
INSERT INTO Timesheets (EmployeeId, attendanceDate, Value)
VALUES
    (1, '2024-01-01', 1),
    (2, '2024-02-02', 0.5),
    (3, '2024-03-03', 1),
    (4, '2024-04-04', 0.5),
    (5, '2024-05-05', 1),
    (6, '2024-06-06', 0.5),
    (7, '2024-07-07', 1),
    (8, '2024-08-08', 0.5),
    (9, '2024-09-09', 1),
    (10, '2024-10-10', 0.5),
    (11, '2024-11-11', 1),
    (12, '2024-12-12', 0.5),
    (13, '2024-01-13', 1),
    (14, '2024-02-14', 0.5),
    (15, '2024-03-15', 1),
    (1, '2024-04-16', 0.5),
    (2, '2024-05-17', 1),
    (3, '2024-06-18', 0.5),
    (4, '2024-07-19', 1),
    (5, '2024-08-20', 0.5),
    (6, '2024-09-21', 1),
    (7, '2024-10-22', 0.5),
    (8, '2024-11-23', 1),
    (9, '2024-12-24', 0.5),
    (10, '2024-01-25', 1),
    (11, '2024-02-26', 0.5),
    (12, '2024-03-27', 1),
    (13, '2024-04-28', 0.5),
    (14, '2024-05-29', 1),
    (15, '2024-06-30', 0.5);
-- Thêm dữ liệu giả cho nhân viên có ID là 1 trong tháng 10 năm 2024
INSERT INTO Timesheets (EmployeeId, attendanceDate, Value)
VALUES
    (1, '2024-10-01', 1),
    (1, '2024-10-02', 1),
    (1, '2024-10-03', 1),
    (1, '2024-10-04', 1),
    (1, '2024-10-05', 1),
    (1, '2024-10-06', 1),
    (1, '2024-10-07', 1),
    (1, '2024-10-08', 1),
    (1, '2024-10-09', 1),
    (1, '2024-10-10', 1),
    (1, '2024-10-11', 1),
    (1, '2024-10-12', 1),
    (1, '2024-10-13', 1),
    (1, '2024-10-14', 1),
    (1, '2024-10-15', 1),
    (1, '2024-10-16', 1),
    (1, '2024-10-17', 1),
    (1, '2024-10-18', 1),
    (1, '2024-10-19', 1),
    (1, '2024-10-20', 1);

INSERT INTO Salary (EmployeeId, bonusSalary)
VALUES (1, 500000),
       (2, 600000),
       (3, 700000);
# 1.
SELECT e.Id,e.Name,e.Email,e.Phone,e.address,e.gender,e.BirthDay,timestampdiff(year ,e.BirthDay,curdate()) as Age, d.Name as DepartmentName , l.Name as LevelName from employee e
join department d on d.Id = e.DepartmentId
join Levels L on L.Id = e.LevelId
order by e.Name asc ;
# 2.
select s.Id,e.Name as EmployeeName , e.Email , l.basicSalary,l.allowancesalary , s.bonusSalary,s.Insurrance,(l.basicSalary+l.allowancesalary+s.bonusSalary-s.Insurrance) as TotalSalary  from salary s
join employee e on s.EmployeeId = e.Id
join Levels L on L.Id = e.LevelId;
#.3
select d.Id, d.Name, count(e.Id) as TotalEmployee
from department d
         join employee e on d.Id = e.DepartmentId
group by d.Id, d.Name;

# 4.
UPDATE Salary
SET bonusSalary = (SELECT Levels.basicSalary * 0.1
                   FROM Employee
                            JOIN Levels ON Employee.LevelId = Levels.Id
                   WHERE Employee.Id = Salary.EmployeeId)
WHERE EmployeeId IN (
    SELECT EmployeeId
    FROM Timesheets
    WHERE MONTH(attendanceDate) = 10 AND YEAR(attendanceDate) = 2024
    GROUP BY EmployeeId
    HAVING COUNT(*) >= 20
);

SELECT EmployeeId, bonusSalary
FROM Salary
WHERE EmployeeId IN (
    SELECT EmployeeId
    FROM Timesheets
    WHERE MONTH(attendanceDate) = 10 AND YEAR(attendanceDate) = 2024
    GROUP BY EmployeeId
    HAVING COUNT(*) >=10
);

# 5.
DELETE FROM department
WHERE NOT EXISTS (
    SELECT *
    FROM employee
    WHERE department.Id = employee.DepartmentId
);

# Tạo view
create view v_getEmployeeInfo as
select e.Id,e.Name,e.Email,e.Phone,e.address, case e.gender
when 0 then 'Nữ'
when 1 then 'Nam'
else 'Khac'
end as Gender,
    e.BirthDay,
    d.Name as DepartmentName,
    l.Name as LevelName
from employee e
join department d on d.Id = e.DepartmentId
join Levels L on L.Id = e.LevelId;

create view v_getEmployeeSalaryMax as
select e.Id,
       e.Name,
       e.Email,
       e.Phone,
       e.BirthDay,
       COUNT(t.id) AS TotalDay
from employee e
         join Timesheets T on e.Id = T.EmployeeId
where month(t.attendanceDate) = month(now())
  and year(t.attendanceDate) = year(now())
group by e.Id
HAVING TotalDay > 10;

# Stored Procedure
DELIMITER //
create procedure addEmployeeInfo(in p_Name varchar(150),  IN p_Email VARCHAR(150),
                                 IN  p_Phone VARCHAR(50),
                                 IN  p_address VARCHAR(255),
                                 IN p_gender TINYINT,
                                 IN p_BirthDay DATE,
                                 IN p_LevelId INT,
                                 IN p_DepartmentId INT)
begin insert into employee (Name, Email, Phone, address, gender, BirthDay, LevelId, DepartmentId)
    values (p_Name,p_Email,p_Phone,p_address,p_gender,p_BirthDay,p_LevelId,p_DepartmentId);
END //
DELIMITER //;
CALL addEmployeeInfo('Giang', 'giang@gmail.com', '0977414302', 'Van giang', 1, '2001-01-01', 1, 1);



DELIMITER //
create procedure getSalaryByEmployeeId(In p_EmployeeId int)
begin
    select e.Id,
           e.Name AS EmployeeName,
           e.Phone,
           e.Email,
           l.basicSalary,
           l.basicSalary,
           l.allowancesalary,
           s.bonusSalary,
           s.Insurrance,
           (SELECT COUNT(*)
            FROM Timesheets t
            WHERE t.EmployeeId = e.Id
              AND MONTH(t.attendanceDate) = MONTH(CURRENT_DATE)
              AND YEAR(t.attendanceDate) = YEAR(CURRENT_DATE)) AS TotalDay,
           (l.basicSalary + l.allowancesalary + s.bonusSalary - s.Insurrance) * (SELECT COUNT(*)
                                                                                 FROM Timesheets t
                                                                                 WHERE t.EmployeeId = e.Id
                                                                                   AND MONTH(t.attendanceDate) = MONTH(CURRENT_DATE)
                                                                                   AND YEAR(t.attendanceDate) = YEAR(CURRENT_DATE)) AS TotalSalary
    from employee e
             join Levels L on L.Id = e.LevelId
             join Salary S on e.Id = S.EmployeeId
    where e.Id = p_EmployeeId;
end//
DELIMITER //;
CALL getSalaryByEmployeeId(1);



DELIMITER //
create procedure getEmployeePaginate (in p_Limit int , in p_Page int)
begin declare p_offset int;
set p_offset = (p_Page-1)*p_Limit;
SELECT
    Id,
    Name,
    Email,
    Phone,
    address,
    gender,
    BirthDay
FROM
    employee
LIMIT p_Limit OFFSET p_Offset;
END //
DELIMITER //;
CALL getEmployeePaginate(2, 1);




DELIMITER //
CREATE TRIGGER tr_Check_Insurrance_value BEFORE INSERT ON Salary
    FOR EACH ROW
BEGIN
    DECLARE v_BasicSalary FLOAT;
    SELECT basicSalary INTO v_BasicSalary FROM Levels WHERE Id = NEW.LevelId;
    IF NEW.Insurrance != v_BasicSalary * 0.1 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Giá trị của Insurrance phải = 10% của BasicSalary';
    END IF;
END //
DELIMITER ;

DELIMITER //
CREATE TRIGGER tr_check_basic_salary BEFORE INSERT ON Levels
    FOR EACH ROW
BEGIN
    IF NEW.basicSalary > 10000000 THEN
        SET NEW.basicSalary = 10000000;
    END IF;
END //
DELIMITER ;
