use master
go
------------------------------------------------------------------------------------------------------------
if exists(select name from sysdatabases where name in('BDPollito'))
	drop database BDPollito
go
------------------------------------------------------------------------------------------------------------
create database BDPollito
go
------------------------------------------------------------------------------------------------------------
use BDPollito
go
--CREACI�N DE TABLAS PARA BDPollito
--creacion de tabla TPersona
create table TPersona(
DniPersona varchar(8) not null primary key,
Nombre varchar(50) not null,
ApePaterno varchar(50) not null,
ApeMaterno varchar(50) not null,
Direccion varchar(50) not null,
Celular int not null,
NombreUsuario varchar(50) not null unique,
Contrasena varbinary(max) not null,
TipoUsuario int not null
)
go
create table TPlatillo(
CodPlatillo varchar(4) PRIMARY KEY,
NombrePlatillo varchar(50) not null,
PrecioUnitario float not null,
Categoria int not null,
Imagen varchar(max) not null,
Disponibilidad bit not null
)
create table TDetalleComanda(
CodDetalleComanda varchar(4) PRIMARY KEY,
CodPlatillo VARCHAR(4) Foreign key (CodPlatillo) references TPlatillo,
Cantidad int not null,
Precio float not null,
)
go
create table TPedidoComanda(
CodPedidoComanda varchar(4) primary key,
CodDetalleComanda varchar(4) foreign key (CodDetalleComanda) references TDetalleComanda,
Mesa int not null,
DniPersona varchar(8) foreign key (DniPersona) references TPersona,
TotalProducto float not null,
)
go
--creaci�n de tabla TCocina
create table TCocina(
CodCocina varchar(1) not null primary key,
CodPedidoComanda varchar(4) foreign key (CodPedidoComanda) references TPedidoComanda,
EstadoEntrega bit not null
)
go

create table TComprobante(
CodComprobante varchar(4) not null primary key,
CodPedidoComanda varchar(4) foreign key (CodPedidoComanda) references TPedidoComanda,
Fecha date not null,
direccion varchar(50) not null,
CostoTotalaIGV float not null,
)
go
create table TDetalleComprobante(
CodDetalleComprobante varchar(4) primary key,
CodComprobante varchar(4) foreign key (CodComprobante) references TComprobante,
Cantidad int,
CodPlatillo Varchar(4) foreign key (CodPlatillo) references TPlatillo
)
go
--inserci�n en Tpersona
insert into TPersona values ('32124345','Daryl','Laguna','Utrilla',
'av.la cultura S/N', '987654321', 'daryllagunar@gmail.com','123123','1')
insert into TPersona values ('72663013','Luis','Palomino','Paucar',
'av.la cultura S/N', '987654321', 'luispalomino@gmail.com','123123','1')
select * from TPersona
--inserci�n en Tplatillo
insert into TPlatillo values('P01','1/8 pollo','10.00','1','23423','true')
insert into TPlatillo values('P02','1/4 pollo','14.00','1','3324234','true')
select * from TPlatillo
--insercion en Tpedidocomanda
insert into TPedidoComanda(CodPedidoComanda,CodDetalleComanda,
DniPersona,Mesa,TotalProducto)values
('PC01','C001','72663013','1','10.00');
go
insert into TPedidoComanda(CodPedidoComanda,CodDetalleComanda,
DniPersona,Mesa,TotalProducto)values
('PC02','C002','32124345','1','10.00');
go
select * from TPedidoComanda
--insercij�n en tDetalle comanda
insert into TDetalleComanda values ('C001','1','2','10.00')
insert into TDetalleComanda values ('C002','1','4','14.00')
select * from TDetalleComanda


--INSERCI�N EN tCOCINA
insert into TCocina values ('1','PC01','true')
insert into TCocina values ('3','PC02','false')
select * from TCocina

--isnercion en tcomprobante
insert into TComprobante(CodComprobante,CodPedidoComanda,Fecha,direccion,CostoTotalaIGV)values
('CC01','PC01','2020-01-01','siempre puto','10.00');
go
insert into TComprobante(CodComprobante,CodPedidoComanda,Fecha,direccion,CostoTotalaIGV)values
('CC02','PC02','2020-01-02','siempre puto','11.00');
go
select * from TComprobante

--insercion en tdetallecomprobante
insert into TDetalleComprobante(CodDetalleComprobante,CodComprobante,
CodPlatillo,Cantidad)values
('DC01','CC01','1','10');
go
insert into TDetalleComprobante(CodDetalleComprobante,CodComprobante,
CodPlatillo,Cantidad)values
('DC02','CC02','2','10');
go
select * from TDetalleComprobante



select * from TPersona
select * from TCocina
select * from TComprobante
select * from TDetalleComprobante
select * from TPedidoComanda
select * from TDetalleComanda
select * from TPlatillo