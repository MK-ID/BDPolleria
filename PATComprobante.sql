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
IF OBJECT_ID('spListarComprobante')is not null
    DROP PROCEDURE spListarComprobante
GO
CREATE PROCEDURE spListarComprobante
AS
BEGIN
    BEGIN TRANSACTION TransListar
    BEGIN TRY
        SELECT CodComprobante,CodPedidoComanda,Fecha,direccion, CostoTotalaIGV FROM TComprobante
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
-- prueba de procedimieneto almacenado listar
EXECUTE spListarComprobante
Go
-- fin de procedimiento almacenado listar  comprobante
-----------------------------------------------------------------

--procedimiento almacenado de agregar comprobante
IF OBJECT_ID('spAgregarComprobante')is not null
    DROP PROCEDURE spAgregarComprobante
GO
CREATE PROCEDURE spAgregarComprobante
@CodComprobante varchar(4),@CodPedidoComanda varchar(4),@Fecha date,@direccion varchar(50),@CostoTotalaIGV float
AS
BEGIN
    IF NOT EXISTS(SELECT CodComprobante FROM TComprobante WHERE CodComprobante=@CodComprobante)
        IF EXISTS(SELECT CodPedidoComanda FROM TPedidoComanda WHERE CodPedidoComanda=@CodPedidoComanda)
        BEGIN
        BEGIN TRANSACTION TransAgregar
        BEGIN TRY
            INSERT INTO TComprobante VALUES(@CodComprobante,@CodPedidoComanda, @Fecha,@direccion,@CostoTotalaIGV)
        COMMIT TRANSACTION TransAgregar
            SELECT CodError = 0, Mensaje = 'Transacción ejecutada correctamente'
        END TRY
        BEGIN CATCH
            ROLLBACK TRANSACTION TransAgregar
            SELECT CodError = 1, Mensaje = 'Error, la transacción no se ejecutó'
        END CATCH
        END
        ELSE SELECT CodError = 1, Mensaje = 'Error, código de pedido comanda no existe'
    ELSE SELECT CodError = 1, Mensaje = 'Error, código de comprobante existe'
END
GO
--FIN DE PROCEDIMIENTO ALMACENADO AGREGAR COMPROBANTE
--PRUEBA DE PROCEDIMIENTO ALMACEANDO AGREGAR COMPROBANTE
EXECUTE spAgregarComprobante 'CC04','PC02','2020-01-01','Urb.San Miguel LTE-2','165.00'
go
EXECUTE spListarComprobante
GO
-- fin de prueba de procedimiento almacenado
--------------------------------------------------------------------------------------------------------------

--procedimiento almacenado actualizar comprobante
IF OBJECT_ID('spActualizarComprobante') is NOT NULL
    DROP PROCEDURE spActualizarComprobante
GO
CREATE PROCEDURE spActualizarComprobante
@CodComprobante varchar(4),@CodPedidoComanda varchar(4),@Fecha date,@direccion varchar(50),@CostoTotalaIGV float
AS
BEGIN
    IF EXISTS(SELECT CodComprobante FROM TComprobante WHERE CodComprobante=@CodComprobante)
        IF EXISTS(SELECT CodPedidoComanda FROM TPedidoComanda WHERE CodPedidoComanda=@CodPedidoComanda)
            BEGIN
            BEGIN TRANSACTION TransActualizar
            BEGIN TRY
                UPDATE TComprobante SET CodPedidoComanda=@CodPedidoComanda,Fecha=@Fecha,direccion=@direccion,CostoTotalaIGV=@CostoTotalaIGV WHERE CodPedidoComanda=@CodPedidoComanda
            COMMIT TRANSACTION TransActualizar
                SELECT CodError = 0, Mensaje = 'Transacción ejecutada correctamente'
            END TRY
            BEGIN CATCH
                ROLLBACK TRANSACTION TransActualizar
                SELECT CodError = 1, Mensaje = 'Error, la transacción no se ejecutó'
            END CATCH
            END
        ELSE SELECT CodError=1,Mensaje='Error: código de pedido comanda no existe'
    ELSE SELECT CodError=1,Mensaje='Error: codigo de comprobante comanda no existe'
END
GO
--fin de procedimiento almacenado actualziar comprobante
--prueba de procedimiento almacenado
EXECUTE spActualizarComprobante 'CC02','PC02','2019-01-01','Urb.San Miguel LTE-2','165.00'
go
EXECUTE spListarComprobante
GO
--fin deprueba de procedimieneto almacenado
-----------------------------------------------------------------------------

--procedimiento almaceando eliminar comprobante
IF OBJECT_ID('spEliminarComprobante') is not null
    DROP PROCEDURE spEliminarComprobante
GO
CREATE PROCEDURE spEliminarComprobante
@CodComprobante varchar(4)
AS
BEGIN
    IF EXISTS(SELECT CodComprobante FROM TComprobante WHERE CodComprobante=@CodComprobante)
    BEGIN
    BEGIN TRANSACTION TransEliminar
        BEGIN TRY
            DELETE FROM TComprobante WHERE CodComprobante=@CodComprobante
        COMMIT TRANSACTION TransEliminar
            SELECT CodError = 0, Mensaje = 'Proceso de eliminar se ejecutó correctamente'
        END TRY
        BEGIN CATCH
            ROLLBACK TRANSACTION TransEliminar
            SELECT CodError= 1, Mensaje = 'Error, la transacción no se ejecutó'
        END CATCH
    END
    ELSE SELECT CodError=1,Mensaje='Error: codigo de cocina no existe'
END
GO
--fin de procedimiento almacenado elimianr comprobante
--prueba de procedimiento almacenado eliminar
EXECUTE spEliminarComprobante 'CC04'
go
EXECUTE spListarComprobante
GO
-- fin de prueba deprocedimiento almacenado elimianr comprobante
------------------------------------------------------------------------------------

--procedimiento almacenado buscar comprobante
IF OBJECT_ID('spBuscarComprobante') IS NOT NULL
    DROP PROCEDURE spBuscarComprobante
GO
CREATE PROCEDURE spBuscarComprobante  
@Texto varchar(50), @Criterio varchar(20)
AS
BEGIN
    if(@Criterio = 'CodComprobante') --Busqueda exacta
        SELECT CodComprobante,CodPedidoComanda,Fecha,direccion,CostoTotalaIGV from TComprobante where CodComprobante = @Texto
    else if (@Criterio = 'Fecha') --Busqueda sensitiva
        SELECT Fecha,CodComprobante,CodPedidoComanda,direccion,CostoTotalaIGV from TComprobante where Fecha like @Texto + '%' 
END
GO
--fin de procedimiento almaceando buscar
--prueba de procedimiento almacenado bucsar
EXECUTE spBuscarComprobante 'cc02','CodComprobante'
go
EXECUTE spBuscarComprobante '202','Fecha'
go
--fin de prueba de procedimiento almacenao buscar