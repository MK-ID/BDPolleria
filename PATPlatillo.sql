-- procedimientos almacenados para la tabla platillo de BDPollito
use BDPollito
GO
--inciamos con los procedimientos almacenados
-- autor:Luis Mikhail Palomino Paucar
-- fecha: 04/12/19
--TODO: si se realiza la edición de algun procedimiento almacenado comunicar al SCRUM MASTER
--procedimiento almacenado para listar platillos
IF OBJECT_ID('spListarPlatillos') IS NOT NULL
    DROP PROCEDURE spListarPlatillos
GO
CREATE PROCEDURE spListarPlatillos
AS
BEGIN
    BEGIN TRANSACTION TransListar
    BEGIN TRY
        SELECT CodPlatillo,NombrePlatillo,PrecioUnitario,Categoria,Imagen,Disponibilidad FROM TPlatillo
    COMMIT TRANSACTION TransListar
        SELECT CodError = 0, Mensaje = 'Proceso de listado correcto'
    END TRY

    BEGIN CATCH
        ROLLBACK TRANSACTION TransListar
        SELECT CodError = 1, Mensaje = 'Error, la transacción no se ejecutó'
    END CATCH
END
GO
--fin de procedimiento listar
--probando procedimiento almacenado
EXECUTE spListarPlatillos
GO
--fin de prueba
--------------------------------------------------

--procedimiento almacenado agregar platillos
IF OBJECT_ID('spAgregarPlatillos') is not NULL
    drop PROCEDURE spAgregarPlatillos
GO
CREATE PROCEDURE spAgregarPlatillos
@CodPlatillo VARCHAR(4),@NombrePlatillo VARCHAR(50), @PrecioUnitario FLOAT, @Categoria INT, @Imagen VARCHAR(MAX),@Disponibilidad BIT
AS
BEGIN
    IF not EXISTS(SELECT CodPlatillo FROM TPlatillo WHERE CodPlatillo=@CodPlatillo)
    BEGIN
        BEGIN TRANSACTION TransAgregar
        BEGIN TRY
            INSERT INTO TPlatillo VALUES (@CodPlatillo,@NombrePlatillo,@PrecioUnitario,@Categoria,@Imagen,@Disponibilidad)
        COMMIT TRANSACTION TransAgregar
            SELECT CodError = 0, Mensaje = 'Proceso de agregar se ejecutó correctamente'
        END TRY

        BEGIN CATCH
            ROLLBACK TRANSACTION TransAgregar
            SELECT CodError = 1, Mensaje = 'Error, la transacción no se ejecutó'
        END CATCH
    END
    ELSE SELECT CodError = 1, Mensaje = 'Error, código de platillo existe'
END
GO
--fin de procedimiento almacenado agregar
--probando procedimiento almacenado spAgregarPlatillo
EXECUTE spAgregarPlatillos 'P02','1/4', '10.00','1','3423','1'
GO
EXECUTE spListarPlatillos
GO
--fin de prueba
----------------------------------------------------

--procedimiento almacenado actualizar platillos
IF OBJECT_ID('spActualizarPlatillos') IS NOT NULL
    DROP PROCEDURE spActualizarPlatillos
GO
CREATE PROCEDURE spActualizarPlatillos
@CodPlatillo VARCHAR(50), @NombrePlatillo VARCHAR(50), @PrecioUnitario FLOAT, @Categoria INT, 
@Imagen VARCHAR(MAX),@Disponibilidad BIT
AS
BEGIN
    IF EXISTS(SELECT CodPlatillo FROM TPlatillo WHERE CodPlatillo=@CodPlatillo)
    BEGIN
        BEGIN TRANSACTION TransActualizar
        BEGIN TRY
            UPDATE TPlatillo SET NombrePlatillo=@NombrePlatillo,PrecioUnitario=@PrecioUnitario,Categoria=@Categoria,
            Imagen=@Imagen,Disponibilidad=@Disponibilidad WHERE CodPlatillo=@CodPlatillo
        COMMIT TRANSACTION TransActualizar
            SELECT CodError = 0, Mensaje = 'Proceso de actualizar se ejecutó correctamente'
        END TRY
        BEGIN CATCH
            ROLLBACK TRANSACTION TransActualizar
            SELECT CodError = 1, Mensaje = 'Error, la transacción no se ejecutó'
        END CATCH
    END
    ELSE SELECT CodError = 0, Mensaje = 'Error, código de platillo no existe'
END
GO
--fin de procedimiento almacenado actualizar
--probando procedimiento almacenado spActualizarPlatillo
EXECUTE spActualizarPlatillos 'P03','Salchipapa','7.5','1','3424','2'
GO
EXECUTE spListarPlatillos
GO
-- fin de prueba
-----------------------------------------------------

--procedimiento almacenado eliminar platillos
IF OBJECT_ID('spEliminarPlatillos') IS NOT NULL
    DROP PROCEDURE spEliminarPlatillos
GO
CREATE PROCEDURE spEliminarPlatillos
@CodPlatillo VARCHAR(50)
AS
BEGIN
    IF EXISTS(SELECT CodPlatillo FROM TPlatillo WHERE CodPlatillo=@CodPlatillo)
        BEGIN
            BEGIN TRANSACTION TransEliminar
            BEGIN TRY
                DELETE FROM TPlatillo WHERE CodPlatillo=@CodPlatillo
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
--probando procedimiento almacenado spEliminarPlatillo
EXECUTE spEliminarPlatillos 'P07'
GO
EXECUTE spListarPlatillos
GO
--fin de prueba
-----------------------------------------------------

--procedimiento almacenado de buscar alumno
IF OBJECT_ID('spBuscarPlatillos') IS NOT NULL
    DROP PROCEDURE spBuscarPlatillos
GO
CREATE PROCEDURE spBuscarPlatillos
@Texto varchar(50), @Criterio varchar(20)
AS
BEGIN
    if(@Criterio = 'CodPlatillo') --Busqueda exacta
        select CodPlatillo, NombrePlatillo, PrecioUnitario, Categoria, Imagen, Disponibilidad from TPlatillo where CodPlatillo = @Texto 
    else if (@Criterio = 'NombrePlatillo') --Busqueda sensitiva
        select NombrePlatillo, PrecioUnitario, Categoria, Imagen, Disponibilidad from TPlatillo where NombrePlatillo like @Texto + '%'
    else if (@Criterio = 'Precio') --Busqueda sensitiva
        select PrecioUnitario, CodPlatillo, NombrePlatillo, Imagen, Disponibilidad from TPlatillo where PrecioUnitario like @Texto + '%'
END
GO
--fin de procedimiento almacenado buscar
-------------------------------------------------------

EXECUTE spBuscarPlatillos 'P03','CodPlatillo'
GO
EXECUTE spBuscarPlatillos '1','NombrePlatillo'
GO