use master
GO
USE BDPollito
GO
--iniciamos con los procedimientos almacenados
-- autor:Luis Mikhail Palomino Paucar
-- fecha: 04/12/19
--TODO: si se realiza la edición de algun procedimiento almacenado comunicar al SCRUM MASTER
--procedimiento almacenado para listar cocina
IF OBJECT_ID('spListarCocina') is not null
    drop PROCEDURE spListarCocina
GO
CREATE PROCEDURE spListarCocina
AS
BEGIN
    BEGIN TRANSACTION TransListar
    BEGIN TRY
        SELECT CodCocina,CodPedidoComanda,EstadoEntrega FROM TCocina
    COMMIT TRANSACTION TransListar
        SELECT CodError = 0, Mensaje = 'Proceso de listado correcto'
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION TransListar
        SELECT CodError = 1, Mensaje = 'Error, la transacción no se ejecutó'
    END CATCH
END
go
--fin de procedimiento almacenado listar cocina
--prueba de procedimiento almacenado listar cocina
EXECUTE spListarCocina
GO
--fin de prueba de lsitar cocina
-------------------------------------------------------------------

--procediemiento almaceando agregar cocina
IF OBJECT_ID('spAgregarCocina')is not null
    DROP PROCEDURE spAgregarCocina
GO
CREATE PROCEDURE spAgregarCocina
@CodCocina int, @CodPedidoComanda varchar(4),@EstadoEntrega BIT
AS
BEGIN
    IF NOT EXISTS(SELECT CodCocina FROM TCocina where CodCocina=@CodCocina)
        IF EXISTS(SELECT CodPedidoComanda FROM TPedidoComanda WHERE CodPedidoComanda=@CodPedidoComanda)
        BEGIN
        BEGIN TRANSACTION TransAgregar
                BEGIN TRY
                    INSERT INTO TCocina VALUES(@CodCocina,@CodPedidoComanda, @EstadoEntrega)
                COMMIT TRANSACTION TransAgregar
                    SELECT CodError = 0, Mensaje = 'Transacción ejecutada correctamente'
                END TRY
                BEGIN CATCH
                    ROLLBACK TRANSACTION TransAgregar
                    SELECT CodError = 1, Mensaje = 'Error, la transacción no se ejecutó'
                END CATCH
        END
        ELSE SELECT CodError=1, Mensaje='Código de pedido comanda no existe'
    ELSE SELECT CodError=1, Mensaje='Código de cocina existe'
END
GO
--fin de proecdimiento almacenado agregar cocina
--prueba de procedimiento almaceando agregar
EXECUTE spAgregarCocina '4','PC02','False'
GO
EXECUTE spListarCocina
go
--fin de prueba de procedimiento almacenado
-----------------------------------------------------------------------

--procedimiento almacenado actualizar cocina
IF OBJECT_ID('spActualizarCocina') is not NULL
    DROP PROCEDURE spActualizarCocina
GO
CREATE PROCEDURE spActualizarCocina
@CodCocina int, @CodPedidoComanda varchar(4),@EstadoEntrega BIT
AS
BEGIN
    IF EXISTS(SELECT CodCocina FROM TCocina where CodCocina=@CodCocina)
        BEGIN
        BEGIN TRANSACTION TransActualizar
                BEGIN TRY
                    UPDATE TCocina SET CodPedidoComanda=@CodPedidoComanda,EstadoEntrega=@EstadoEntrega where CodCocina=@CodCocina
                COMMIT TRANSACTION TransActualizar
                    SELECT CodError = 0, Mensaje = 'Transacción ejecutada correctamente'
                END TRY
                BEGIN CATCH
                    ROLLBACK TRANSACTION TransActualizar
                    SELECT CodError = 1, Mensaje = 'Error, la transacción no se ejecutó'
                END CATCH
        END
    ELSE SELECT CodError=1,Mensaje='Código de cocina no existe'
END
GO
--fin de procedimiento almacenado
--prueba de procedimiento almacenado
EXECUTE spActualizarCocina '4','PC02','1'
go
EXECUTE spListarCocina
GO
--fin de prueba
------------------------------------------------------------------------------

-- procedimiento almacenado elimianr cocina
IF OBJECT_ID('spEliminarCocina') is not null
    DROP PROCEDURE spEliminarCocina
GO
CREATE PROCEDURE spEliminarCocina
@CodCocina int
AS
BEGIN
    IF EXISTS(SELECT CodCocina FROM TCocina WHERE CodCocina=@CodCocina)
    BEGIN
    BEGIN TRANSACTION TransEliminar
        BEGIN TRY
            DELETE FROM TCocina WHERE CodCocina=@CodCocina
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
--fin de procedimiento almacenado eliminar cocina
--prueba de procedimiento almaceando
EXECUTE spEliminarCocina '4'
GO
EXECUTE spListarCocina
GO
--fin de prueba de procedimiento almacenado
-------------------------------------------------------------------------------

--procedimieneto almacenado para buscar cocina
IF OBJECT_ID('spBuscarCocina') IS NOT NULL
    DROP PROCEDURE spBuscarCocina
GO
CREATE PROCEDURE spBuscarCocina  
@Texto varchar(50), @Criterio varchar(20)
AS
BEGIN
    if(@Criterio = 'CodCocina') --Busqueda exacta
        SELECT CodCocina,CodPedidoComanda,EstadoEntrega from TCocina where CodCocina = @Texto
    else if (@Criterio = 'EstadoEntrega') --Busqueda sensitiva
        select EstadoEntrega,CodCocina,CodPedidoComanda from TCocina where EstadoEntrega = @Texto
END
GO
--fin de procedimiento almaceando
--prueba de procedimiento almacenado buscar
EXECUTE spBuscarCocina '1','CodCocina'
go
EXECUTE spBuscarCocina '1','EstadoEntrega'
go
--fin de prueba de procedimiento almacenado
