use master
go
use BDPollito
go
--iniciamos con los procedimientos almacenados
-- autor:Luis Mikhail Palomino Paucar
-- fecha: 04/12/19
--TODO: si se realiza la edición de algun procedimiento almacenado comunicar al SCRUM MASTER
--procedimiento almacenado para listar comprobante
--procedimiento almacenado para listar comprobante
IF OBJECT_ID('spListarDetalleComprobante')is not null
    DROP PROCEDURE spListarDetalleComprobante
GO
CREATE PROCEDURE spListarDetalleComprobante
AS
BEGIN
    BEGIN TRANSACTION TransListar
    BEGIN TRY
        SELECT CodDetalleComprobante,CodComprobante,Cantidad,CodPlatillo FROM TDetalleComprobante
    COMMIT TRANSACTION TransListar
        SELECT CodError = 0, Mensaje = 'Proceso de listado correcto'
    END TRY

    BEGIN CATCH
        ROLLBACK TRANSACTION TransListar
        SELECT CodError = 1, Mensaje = 'Error, la transacción no se ejecutó'
    END CATCH
END
GO
--fin de procedimiento almacenado listar
--prueba de procedimiento almaenado listar
EXECUTE spListarDetalleComprobante
go
--fin de prueba
--------------------------------------------------------------

--procedimiento para agregar
IF OBJECT_ID('spAgregarDetalleComprobante') is not null
    DROP PROCEDURE spAgregarDetalleComprobante
go
CREATE PROCEDURE spAgregarDetalleComprobante
@CodDetalleComprobante varchar(4),@CodComprobante varchar(4),@Cantidad int, @CodPlatillo Varchar(4)
AS
BEGIN
    IF not EXISTS(SELECT CodDetalleComprobante FROM TDetalleComprobante WHERE CodDetalleComprobante=@CodDetalleComprobante)
        IF EXISTS(SELECT CodComprobante FROM TComprobante where CodComprobante=@CodComprobante)
            IF EXISTS(SELECT CodPlatillo FROM TPlatillo where CodPlatillo=@CodPlatillo)
            BEGIN
            BEGIN TRANSACTION TransAgregar
            BEGIN TRY
                INSERT INTO TDetalleComprobante VALUES(@CodDetalleComprobante,@CodComprobante, @Cantidad,@CodPlatillo)
            COMMIT TRANSACTION TransAgregar
                SELECT CodError = 0, Mensaje = 'Transacción ejecutada correctamente'
            END TRY

            BEGIN CATCH
                ROLLBACK TRANSACTION TransAgregar
                SELECT CodError = 1, Mensaje = 'Error, la transacción no se ejecutó'
            END CATCH
            END
            ELSE SELECT CodError=1,Mensaje='Error, Código de platillo no existe'
        ELSE SELECT CodError=1,Mensaje='Error, Código de comprobante no existe'
    ELSE SELECT CodError=1,Mensaje='Error, Código de detalle comanda existe'
END
go
--fin de procedimiento almacenado
--prueba de procedimiento amlmacenado agregar detallecomproabnte
EXECUTE spAgregarDetalleComprobante 'DC04','CC02','1','P02'
go
EXECUTE spListarDetalleComprobante
go
--fin de prueba de procedimiento almaceando

--proecedimiento almacenado para actualizar
IF OBJECT_ID('spActualizarDetalleComprobante') is not null
    DROP PROCEDURE spActualizarDetalleComprobante
go
CREATE PROCEDURE spActualizarDetalleComprobante
@CodDetalleComprobante varchar(4),@CodComprobante varchar(4),@Cantidad int, @CodPlatillo Varchar(4)
AS
BEGIN
    IF EXISTS(SELECT CodDetalleComprobante FROM TDetalleComprobante WHERE CodDetalleComprobante=@CodDetalleComprobante)
        IF EXISTS(SELECT CodComprobante FROM TComprobante where CodComprobante=@CodComprobante)
            IF EXISTS(SELECT CodPlatillo FROM TPlatillo where CodPlatillo=@CodPlatillo)
            BEGIN
            BEGIN TRANSACTION TransActualizar
            BEGIN TRY
                UPDATE TDetalleComprobante SET CodComprobante=@CodComprobante,Cantidad=@Cantidad, CodPlatillo=@CodPlatillo
                WHERE CodDetalleComprobante=@CodDetalleComprobante
            COMMIT TRANSACTION TransActualizar
                SELECT CodError = 0, Mensaje = 'Transacción ejecutada correctamente'
            END TRY

            BEGIN CATCH
                ROLLBACK TRANSACTION TransActualizar
                SELECT CodError = 1, Mensaje = 'Error, la transacción no se ejecutó'
            END CATCH
            END
            ELSE SELECT CodError=1,Mensaje='Error, Código de platillo no existe'
        ELSE SELECT CodError=1,Mensaje='Error, Código de comprobante no existe'
    ELSE SELECT CodError=1,Mensaje='Error, Código de detalle comanda no existe'
END
go
--fin de procedimiento almaceando
--prueba de procedimiento almaceando actualizar
EXECUTE spActualizarDetalleComprobante 'DC03','CC01','4','P06'
Go
EXECUTE spListarDetalleComprobante
go
--fin de prueba de procedimiento almacenado actualziar detalle comprobante
---------------------------------------------------------------------------------

--procedimiento almaceando para eliminar
IF OBJECT_ID('spEliminarDetalleComprobante') IS NOT NULL
    DROP PROCEDURE spEliminarDetalleComprobante
GO
CREATE PROCEDURE spEliminarDetalleComprobante
@CodDetalleComprobante varchar(4)
AS
BEGIN
    IF EXISTS(SELECT CodDetalleComprobante FROM TDetalleComprobante WHERE CodDetalleComprobante=@CodDetalleComprobante)
        BEGIN
            BEGIN TRANSACTION TransEliminar
            BEGIN TRY
                DELETE FROM TDetalleComprobante WHERE CodDetalleComprobante=@CodDetalleComprobante
            COMMIT TRANSACTION TransEliminar
                SELECT CodError = 0, Mensaje = 'Proceso de eliminar se ejecutó correctamente'
            END TRY
            BEGIN CATCH
                ROLLBACK TRANSACTION TransEliminar
                SELECT CodError= 1, Mensaje = 'Error, la transacción no se ejecutó'
            END CATCH
        END
    ELSE SELECT CodError = 0, Mensaje = 'Error, código de platillo no existe'
END
GO
--fin de procedimiento almacenado eliminar
--prueba de procedimiento almacenado elimianr
EXECUTE spEliminarDetalleComprobante 'DC04'
GO
EXECUTE spListarDetalleComprobante
GO
-- FIN DE PRUEBA DE PROCEDIMIENTO ALMAEANDO DE LISTAR
-------------------------------------------------------------------------------

--procedimiento almaceando para buscar
IF OBJECT_ID('spBuscarDetalleComprobante') IS NOT NULL
    DROP PROCEDURE spBuscarDetalleComprobante
GO
CREATE PROCEDURE spBuscarDetalleComprobante
@Texto varchar(50), @Criterio varchar(50)
AS
BEGIN
    if(@Criterio = 'CodDetalleComprobante') --Busqueda exacta
        SELECT CodDetalleComprobante,CodComprobante,Cantidad,CodPlatillo from TDetalleComprobante where CodDetalleComprobante = @Texto 
END
GO
--fin de procedimiento almcaenado
EXECUTE spBuscarDetalleComprobante 'DC03','CodDetalleComprobante'
go
--fin de prueba