use master
GO
use BDPollito
GO
--iniciamos con los procedimientos almacenados
-- autor:Luis Mikhail Palomino Paucar
-- fecha: 04/12/19
--TODO: si se realiza la edición de algun procedimiento almacenado comunicar al SCRUM MASTER
--procedimiento almacenado para listar detalle comanda
IF OBJECT_ID('spListarDetalleComanda') IS NOT NULL
    DROP PROCEDURE spListarDetalleComanda
GO
CREATE PROCEDURE spListarDetalleComanda
AS
BEGIN
    BEGIN TRANSACTION TransListar
    BEGIN TRY
        SELECT CodDetalleComanda,CodPlatillo,Cantidad,Precio FROM TDetalleComanda
    COMMIT TRANSACTION TransListar
        SELECT CodError = 0, Mensaje = 'Proceso de listado correcto'
    END TRY

    BEGIN CATCH
        ROLLBACK TRANSACTION TransListar
        SELECT CodError = 1, Mensaje = 'Error, la transacción no se ejecutó'
    END CATCH
END
GO
--fin de procedimiento almacenado
--prueba de procedimiento almacenado
EXECUTE spListarDetalleComanda
GO
--fin de prueba
--------------------------------------------------------------------

--procedimiento almacenado para agregar a detalle comanda
IF OBJECT_ID('spAgregarDetalleComanda') IS NOT NULL
    DROP PROCEDURE spAgregarDetalleComanda
GO
CREATE PROCEDURE spAgregarDetalleComanda
@CodDetalleComanda VARCHAR(4), @CodPlatillo VARCHAR(4), @Cantidad int, @Precio float 
AS
BEGIN
    IF not EXISTS(SELECT CodDetalleComanda FROM TDetalleComanda WHERE CodDetalleComanda=@CodDetalleComanda)
        IF EXISTS(SELECT CodPlatillo FROM TPlatillo WHERE CodPlatillo=@CodPlatillo)
        BEGIN
            BEGIN TRANSACTION TransListar
            BEGIN TRY
                INSERT INTO TDetalleComanda VALUES(@CodDetalleComanda,@CodPlatillo, @Cantidad,@Precio)
            COMMIT TRANSACTION TransListar
                SELECT CodError = 0, Mensaje = 'Transacción ejecutada correctamente'
            END TRY

            BEGIN CATCH
                ROLLBACK TRANSACTION TransListar
                SELECT CodError = 1, Mensaje = 'Error, la transacción no se ejecutó'
            END CATCH
        END
        ELSE SELECT CodError = 1, Mensaje = 'Error, código de detalle comanda existe'
    ELSE SELECT CodError = 1, Mensaje = 'Error, código de detalle comanda existe'
END
GO
--fin de procedimiento almacenado
--prueba de procedimiento almacenado agregar a detalle comanda
EXECUTE spAgregarDetalleComanda 'C004','P02','10','15.00'
GO
EXECUTE spListarDetalleComanda
GO
--fin de prueba de procedimiento almacenado
--------------------------------------------------------------------

--procedimiento almacenado para actualizar platillo
--procedimiento almacenado actualizar platillos
IF OBJECT_ID('spActualizarDetalleComanda') IS NOT NULL
    DROP PROCEDURE spActualizarDetalleComanda
GO
CREATE PROCEDURE spActualizarDetalleComanda
@CodDetalleComanda VARCHAR(4), @CodPlatillo VARCHAR(4), @Cantidad int, @Precio float 
AS
BEGIN
    IF EXISTS(SELECT CodDetalleComanda FROM TDetalleComanda WHERE CodDetalleComanda=@CodDetalleComanda)
        IF EXISTS(SELECT CodPlatillo FROM TPlatillo WHERE CodPlatillo=@CodPlatillo)
        BEGIN
            BEGIN TRANSACTION TransActualizar
            BEGIN TRY
                UPDATE TDetalleComanda SET CodDetalleComanda=@CodDetalleComanda,CodPlatillo=@CodPlatillo,Cantidad=@Cantidad,
                Precio=@Precio WHERE CodDetalleComanda=@CodDetalleComanda
            COMMIT TRANSACTION TransActualizar
                SELECT CodError = 0, Mensaje = 'Transacción ejecutada correctamente'
            END TRY
            BEGIN CATCH
                ROLLBACK TRANSACTION TransActualizar
                SELECT CodError = 1, Mensaje = 'Error, la transacción no se ejecutó'
            END CATCH
        END
        ELSE SELECT CodError = 0, Mensaje = 'Error, código de platillo no existe'
    ELSE SELECT CodError = 0, Mensaje = 'Error, código de detalle comanda no existe'
END
GO
--fin de procedimiento almacenado actualizar
--prueba de procedimiento almacenado
EXECUTE spActualizarDetalleComanda 'C003','P04','10','14.00'
GO
EXECUTE spListarDetalleComanda
GO
--fin de prueba de procedimiento almacenado
-------------------------------------------------------------------

--procedimiento almecenado para eliminar platillos
IF OBJECT_ID('spEliminarDetalleComanda') IS NOT NULL
    DROP PROCEDURE spEliminarDetalleComanda
GO
CREATE PROCEDURE spEliminarDetalleComanda
@CodDetalleComanda VARCHAR(4)
AS
BEGIN
    IF EXISTS(SELECT CodDetalleComanda FROM TDetalleComanda WHERE CodDetalleComanda=@CodDetalleComanda)
        BEGIN
            BEGIN TRANSACTION TransEliminar
            BEGIN TRY
                DELETE FROM TDetalleComanda WHERE CodDetalleComanda=@CodDetalleComanda
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
--fin de procedimiento almacenado
--prueba de procedimiento almacenado
EXECUTE spEliminarDetalleComanda 'C005'
GO
EXECUTE spListarDetalleComanda
GO
--fin de prueba de procedimiento almacenado
---------------------------------------------------------------------

--procedimiento almacenado para buscar detalle comanda
IF OBJECT_ID('spBuscarDetalleComanda') IS NOT NULL
    DROP PROCEDURE spBuscarDetalleComanda
GO
CREATE PROCEDURE spBuscarDetalleComanda
@Texto varchar(50), @Criterio varchar(20)
AS
BEGIN
    if(@Criterio = 'CodDetalleComanda') --Busqueda exacta
        SELECT CodDetalleComanda, CodPlatillo,Cantidad,Precio from TDetalleComanda where CodDetalleComanda = @Texto
    else if (@Criterio = 'CodPlatillo') --Busqueda sensitiva
        select CodPlatillo,CodDetalleComanda,Cantidad,Precio from TDetalleComanda where CodPlatillo like @Texto + '%' 
END
GO
--fin de procedimiento almacenado
--prueba de procedimiento almacenado
EXECUTE spBuscarDetalleComanda 'P01','CodPlatillo'
GO 
--fin de prueba de procedimiento almacenado buscar
------------------------------------------------------------------------