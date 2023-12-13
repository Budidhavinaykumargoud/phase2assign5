--create database
create database Assignment5Db
use Assignment5Db

-- Create schema
create schema bank
go

-- Create Customer table
create table bank.Customer
(
    CId nvarchar(50) primary key,
    CName nvarchar(50) not null,
    CEmail nvarchar(50) unique not null,
    Contact nvarchar(50) unique not null,
    CPwd as (right(CName, 2)) + CId + (left(Contact, 2)) persisted
)

-- Create MailInfo table
create table bank.MailInfo
(
    CId nvarchar(50) primary key,
    CName nvarchar(50) not null,
    CEmail nvarchar(50) unique not null,
    Contact nvarchar(50) unique not null,
    CPwd as (right(CName, 2)) + CId + (left(Contact, 2)) persisted,
    MailTo as CEmail persisted,
    MailDate date,
    MaiMessage nvarchar(100)
)

-- Create trigger
create trigger afterInsTrg
on bank.Customer
after insert 
as
begin
    declare @id nvarchar(50)
    declare @name nvarchar(50)
    declare @mail nvarchar(50)
    declare @contact nvarchar(50)
    declare @pwd nvarchar(50)
    declare @mailto nvarchar(50)
    declare @maildate date
    declare @message nvarchar(100)

    select @id = CId, @name = CName, @mail = CEmail, @contact = Contact from inserted

    insert into bank.MailInfo (CId, CName, CEmail, Contact, MailDate, MaiMessage)
    values (@id, @name, @mail, @contact, GETDATE(), 'Your net banking password is CPwd is valid up to 2 days only. Update it.')

    print 'Record inserted & values captured'
end

-- Test the schema and tables
select * from bank.Customer
select * from bank.MailInfo

-- Insert test data
insert into bank.Customer (CId, CName, CEmail, Contact) values ('1', 'Sam', 'sam@yahoo.com', '987654321')
insert into bank.Customer (CId, CName, CEmail, Contact) values ('2', 'Arsh', 'arsh@yahoo.com', '89674312')
insert into bank.Customer (CId, CName, CEmail, Contact) values ('5', 'Deep', 'deep@yahoo.com', '97458231')