use master
GO
USE BDPollito
GO
--iniciamos con los procedimientos almacenados
-- autor:Luis Mikhail Palomino Paucar
-- fecha: 04/12/19
--TODO: si se realiza la edición de algun procedimiento almacenado comunicar al SCRUM MASTER
--procedimiento almacenado para listar pedido
IF OBJECT_ID('spListarPedidoComanda') is NOT NULL
    DROP PROCEDURE spListarPedidoComanda
GO
CREATE PROCEDURE spListarPedidoComanda
AS
BEGIN
    BEGIN TRANSACTION TransListar
    BEGIN TRY
        SELECT CodPedidoComanda,CodDetalleComanda,Mesa,DniPersona,TotalProducto FROM TPedidoComanda
    COMMIT TRANSACTION TransListar
        SELECT CodError = 0, Mensaje = 'Proceso de listado correcto'
    END TRY

    BEGIN CATCH
        ROLLBACK TRANSACTION TransListar
        SELECT CodError = 1, Mensaje = 'Error, la transacción no se ejecutó'
    END CATCH
END
go
--fin de procedimiento almacenaod de lsitar pedido
--prueba de procedimiento almacenado
EXECUTE spListarPedidoComanda
go
--fin de prueba de procedimiento almacenado listar pedido comanda
-------------------------------------------------------------------

IF OBJECT_ID('spAgregarPedidoComanda') is NOT NULL
    DROP PROCEDURE spAgregarPedidoComanda
GO
CREATE PROCEDURE spAgregarPedidoComanda
@CodPedidoComanda varchar(4), @CodDetalleComanda varchar(4),@Mesa int,@DniPersona varchar(8),@TotalProducto float
AS
BEGIN
    IF not EXISTS(SELECT CodPedidoComanda FROM TPedidoComanda WHERE CodPedidoComanda=@CodPedidoComanda)
        IF EXISTS(SELECT CodDetalleComanda FROM TDetalleComanda WHERE CodDetalleComanda=@CodDetalleComanda)
            IF EXISTS(SELECT DniPersona FROM TPersona WHERE DniPersona=@DniPersona)
            BEGIN
                BEGIN TRANSACTION TransAgregar
                BEGIN TRY
                    INSERT INTO TPedidoComanda VALUES(@CodPedidoComanda,@CodDetalleComanda, @Mesa,@DniPersona,@TotalProducto)
                COMMIT TRANSACTION TransAgregar
                    SELECT CodError = 0, Mensaje = 'Transacción ejecutada correctamente'
                END TRY
                BEGIN CATCH
                    ROLLBACK TRANSACTION TransAgregar
                    SELECT CodError = 1, Mensaje = 'Error, la transacción no se ejecutó'
                END CATCH
            END
            ELSE SELECT CodError=1,Mensaje = 'Error, DNI de la persona no existe'
        ELSE SELECT CodError = 1, Mensaje = 'Error, código de detalle comanda existe'
    ELSE SELECT CodError = 1, Mensaje = 'Error, código de pedido comanda existe'
END
GO
--fin de procedimiento almacenado agregar pedido comanda
--prueba de procedimiento almacenado
EXECUTE spAgregarPedidoComanda 'PC03','C002','1','47346578','140.00'
GO
EXECUTE spListarPedidoComanda
GO
--fin de prueba de lsitar pedido caomanda

--proedimiento almacenado actualizar pedido comanda
IF OBJECT_ID('spActualizarPedidoComanda') is NOT NULL
    DROP PROCEDURE spActualizarPedidoComanda
GO
CREATE PROCEDURE spActualizarPedidoComanda
@CodPedidoComanda varchar(4), @CodDetalleComanda varchar(4),@Mesa int,@DniPersona varchar(8),@TotalProducto float
AS
BEGIN
    IF EXISTS(SELECT CodPedidoComanda FROM TPedidoComanda WHERE CodPedidoComanda=@CodPedidoComanda)
        IF EXISTS(SELECT CodDetalleComanda FROM TDetalleComanda WHERE CodDetalleComanda=@CodDetalleComanda)
            IF EXISTS(SELECT DniPersona FROM TPersona WHERE DniPersona=@DniPersona)
            BEGIN
            BEGIN TRANSACTION TransActualizar
            BEGIN TRY
                UPDATE TPedidoComanda SET CodDetalleComanda=@CodDetalleComanda,Mesa=@Mesa,DniPersona=@DniPersona,
                TotalProducto=@TotalProducto WHERE CodPedidoComanda=@CodPedidoComanda
            COMMIT TRANSACTION TransActualizar
                SELECT CodError = 0, Mensaje = 'Transacción ejecutada correctamente'
            END TRY
            BEGIN CATCH
                ROLLBACK TRANSACTION TransActualizar
                SELECT CodError = 1, Mensaje = 'Error, la transacción no se ejecutó'
            END CATCH
            END
            ELSE SELECT CodError=1,Mensaje = 'Error, DNI de la persona no existe'
        ELSE SELECT CodError=1,Mensaje='Error: código de pedido comanda no existe'
    ELSE SELECT CodError=1,Mensaje='Error: codigo de pedido comanda no existe'
END
GO
--fin de procedimiento almacenado actualizar pedido comanda
--prueba de procedimiento almacenado spactualiaar pedido comanda
EXECUTE spActualizarPedidoComanda 'PC02','C002','1','47346578','140.00'
GO
EXECUTE spListarPedidoComanda
GO
--fin de prueba de procedimiento almacenado actualizar pedido comanda
---------------------------------------------------------------------------------

--procedimiento almacenado para eliminar pedido comanda
IF OBJECT_ID('spEliminarPedidoComanda') is NOT NULL
    DROP PROCEDURE spEliminarPedidoComanda
GO
CREATE PROCEDURE spEliminarPedidoComanda
@CodPedidoComanda VARCHAR(4)
AS
BEGIN
    IF EXISTS(SELECT CodPedidoComanda FROM TPedidoComanda WHERE CodPedidoComanda=@CodPedidoComanda)
        BEGIN
        BEGIN TRANSACTION TransEliminar
        BEGIN TRY
            DELETE FROM TPedidoComanda WHERE CodPedidoComanda=@CodPedidoComanda
        COMMIT TRANSACTION TransEliminar
            SELECT CodError = 0, Mensaje = 'Proceso de eliminar se ejecutó correctamente'
        END TRY
        BEGIN CATCH
            ROLLBACK TRANSACTION TransEliminar
            SELECT CodError= 1, Mensaje = 'Error, la transacción no se ejecutó'
        END CATCH
        END
    ELSE SELECT CodError=1,Mensaje='Error: codigo de pedido comanda no existe'
END
GO
--fin de procedimiento almacenado de eliminar producto
--prueba de procedimiento almacenado eliminar pedido comanda
EXECUTE spEliminarPedidoComanda 'PC03'
go
EXECUTE spListarPedidoComanda
GO
--fin de prueba de procedimiento almacenado
--------------------------------------------------------------------------------

--procedimiento almacenado para buscar pedido comanda
IF OBJECT_ID('spBuscarPedidoComanda') IS NOT NULL
    DROP PROCEDURE spBuscarPedidoComanda
GO
CREATE PROCEDURE spBuscarPedidoComanda  
@Texto varchar(50), @Criterio varchar(20)
AS
BEGIN
    if(@Criterio = 'CodDetalleComanda') --Busqueda exacta
        SELECT CodPedidoComanda,CodDetalleComanda,Mesa,DniPersona,TotalProducto from TPedidoComanda where CodDetalleComanda = @Texto
    else if (@Criterio = 'DniPersona') --Busqueda sensitiva
        select DniPersona,CodPedidoComanda,CodDetalleComanda,Mesa,TotalProducto from TPedidoComanda where DniPersona like @Texto + '%' 
END
GO
--fin de procedimiento almacenado buscar pedido comanda
--prueba de procedimiento almacenado buscar pedido comanda