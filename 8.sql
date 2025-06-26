-- Лр8
use master
go
if exists(select * from sys.databases where name = 'dbcar_hire')
begin
    alter database dbcar_hire set single_user with rollback immediate
    drop database dbcar_hire
end
create database dbcar_hire
go
use dbcar_hire
go

-- Удаление таблиц в порядке зависимостей
if exists (select * from sysobjects where name = 'tblRentalDetails') drop table tblRentalDetails
if exists (select * from sysobjects where name = 'tblContract') drop table tblContract
if exists (select * from sysobjects where name = 'tblVehicle') drop table tblVehicle
if exists (select * from sysobjects where name = 'tblRental') drop table tblRental
if exists (select * from sysobjects where name = 'tblCustomer') drop table tblCustomer
if exists (select * from sysobjects where name = 'tblCity') drop table tblCity
if exists (select * from sysobjects where name = 'tblLocation') drop table tblLocation
go

-- Таблица пунктов проката
create table tblLocation (
    pk_idLocation int not null identity(1,1),
    nameLocation varchar(50) not null,
    typeOfLocation varchar(30) not null
)
alter table tblLocation
    add constraint PK_tblLocation primary key (pk_idLocation)
alter table tblLocation
    add constraint UQ_tblLocation_nameLocation unique (nameLocation)
go

-- Таблица городов
create table tblCity (
    pk_idCity int not null identity(1,1),
    nameCity varchar(30) not null
)
alter table tblCity
    add constraint PK_tblCity primary key (pk_idCity)
go

-- Таблица клиентов
create table tblCustomer (
    pk_idCustomer int not null identity(1,1),
    fullName varchar(50) not null,
    phone nvarchar(20) not null,
    fk_idCity int not null
)
alter table tblCustomer
    add constraint PK_tblCustomer primary key (pk_idCustomer)
alter table tblCustomer
    add constraint UQ_tblCustomer_fullName unique (fullName)
alter table tblCustomer
    add constraint UQ_tblCustomer_phone unique (phone)
alter table tblCustomer
    add constraint FK_tblCustomer_City foreign key (fk_idCity) references tblCity(pk_idCity)
go

-- Таблица аренды
create table tblRental (
    pk_idRental int not null identity(1,1),
    rentalCode varchar(20) not null,
    rentalDurationDays int not null,
    totalCost decimal(10,2) not null,
    fk_idLocation int not null
)
alter table tblRental
    add constraint PK_tblRental primary key (pk_idRental)
alter table tblRental
    add constraint UQ_tblRental_rentalCode unique (rentalCode)
alter table tblRental
    add constraint DF_tblRental_rentalDuration default 1 for rentalDurationDays
alter table tblRental
    add constraint CK_tblRental_totalCost check (totalCost > 500)
alter table tblRental
    add constraint FK_tblRental_Location foreign key (fk_idLocation) references tblLocation(pk_idLocation)
go

-- Таблица автомобилей
create table tblVehicle (
    pk_idVehicle int not null identity(1,1),
    modelName varchar(30) not null,
    dailyRate decimal(10,2) not null,
    registrationExpiry date not null
)
alter table tblVehicle
    add constraint PK_tblVehicle primary key (pk_idVehicle)
alter table tblVehicle
    add constraint UQ_tblVehicle_modelName unique (modelName)
alter table tblVehicle
    add constraint CK_tblVehicle_dailyRate check (dailyRate > 10)
go

-- Таблица договоров аренды
create table tblContract (
    pk_idContract int not null identity(1,1),
    contractCode varchar(25) not null,
    fk_idCustomer int not null,
    fk_idRental int not null
)
alter table tblContract
    add constraint PK_tblContract primary key (pk_idContract)
alter table tblContract
    add constraint UQ_tblContract_contractCode unique (contractCode)
alter table tblContract
    add constraint FK_tblContract_Customer foreign key (fk_idCustomer) references tblCustomer(pk_idCustomer)
alter table tblContract
    add constraint FK_tblContract_Rental foreign key (fk_idRental) references tblRental(pk_idRental)
go

-- Таблица деталей аренды (автомобили по позициям)
create table tblRentalDetails (
    pk_idRentalDetail int not null identity(1,1),
    carPosition int not null,
    fk_idVehicle int not null,
    fk_idRental int not null,
    calculation as (pk_idRentalDetail + carPosition)
)
alter table tblRentalDetails
    add constraint PK_tblRentalDetails primary key (pk_idRentalDetail)
alter table tblRentalDetails
    add constraint DF_tblRentalDetails_carPosition default 1 for carPosition
alter table tblRentalDetails
    add constraint CK_tblRentalDetails_carPosition check (carPosition < 300)
alter table tblRentalDetails
    add constraint FK_tblRentalDetails_Vehicle foreign key (fk_idVehicle) references tblVehicle(pk_idVehicle)
alter table tblRentalDetails
    add constraint FK_tblRentalDetails_Rental foreign key (fk_idRental) references tblRental(pk_idRental)
go
