use master
use BDPollito
GO
--iniciamos con los procedimientos almacenados
-- autor:Luis Mikhail Palomino Paucar
-- fecha: 04/12/19
--TODO: si se realiza la edición de algun procedimiento almacenado comunicar al SCRUM MASTER
--procedimiento almacenado para listar personas
IF OBJECT_ID('spListarPersonas') IS NOT NULL
    DROP PROCEDURE spListarPersonas
GO
CREATE PROCEDURE spListarPersonas
AS
BEGIN
    BEGIN TRANSACTION TransListar
    BEGIN TRY
        SELECT DniPersona,Nombre,ApePaterno,ApeMaterno,Direccion,Celular,NombreUsuario FROM TPersona
    COMMIT TRANSACTION TransListar
        SELECT CodError = 0, Mensaje = 'Proceso de listado correcto'
    END TRY

    BEGIN CATCH
        ROLLBACK TRANSACTION TransListar
        SELECT CodError = 1, Mensaje = 'Error, la transacción no se ejecutó'
    END CATCH
END
GO
--fin de procedimiento almacenado listar personas
--probando procedimiento almacenado listar
EXECUTE spListarPersonas
GO
--fin de prueba
-------------------------------------------------------------

--procedimiento almacenado agregar personas
IF OBJECT_ID('spAgregarPersonas') IS NOT NULL
    DROP PROCEDURE spAgregarPersonas
GO
CREATE PROCEDURE spAgregarPersonas
@DniPersona VARCHAR(8),@Nombre VARCHAR(50),@ApePaterno VARCHAR(50),@ApeMaterno VARCHAR(50),@Direccion VARCHAR(50),
@Celular INT,@NombreUsuario VARCHAR(50), @Contrasena VARCHAR(MAX),@TipoUsuario int
AS
BEGIN
    IF NOT EXISTS (SELECT DniPersona FROM TPersona WHERE DniPersona=@DniPersona)
        IF NOT EXISTS(SELECT NombreUsuario FROM TPersona WHERE NombreUsuario=@NombreUsuario)
        BEGIN
            BEGIN TRANSACTION TransAgregar
            BEGIN TRY
                INSERT INTO TPersona VALUES (@DniPersona,@Nombre,@ApePaterno,@ApeMaterno,@Direccion,
                @Celular,@NombreUsuario,ENCRYPTBYPASSPHRASE('Password',@Contrasena),@TipoUsuario)
            COMMIT TRANSACTION TransAgregar
                SELECT CodError = 0, Mensaje = 'Proceso de agregado correcto'
            END TRY
            BEGIN CATCH
                ROLLBACK TRANSACTION TransAgregar
                SELECT CodError = 1, Mensaje = 'Error, la transancción no se ejecutó'
            END CATCH
        END
        ELSE SELECT CodError = 1, Mensaje = 'Error, Email duplicado'
    ELSE SELECT CodError = 1, Mensaje = 'Error, DNI duplicado'
END
GO
--fin de procedimiento almacenado listar personas
--probando procedimiento almacenado agregar
EXECUTE spAgregarPersonas '47346578','Chuchin','Diaz','Chavez','Urb.Chuchin','987675643','chuchin@gmail.com','qwerty','1'
GO
EXECUTE spAgregarPersonas '32124345','Daryl','Laguna','Utrilla',
'av.la cultura S/N', '987654321', 'daryllagunar@gmail.com','123123','1'
GO
SELECT * from TPersona
--fin de prueba
----------------------------------------------------------------

--procedimiento almacenado actualizar personas
IF OBJECT_ID('spActualizarDataPersonas') IS NOT NULL
    DROP PROCEDURE spActualizarDataPersonas
GO
CREATE PROCEDURE spActualizarDataPersonas
@DniPersona VARCHAR(8),@Nombre VARCHAR(50),@ApePaterno VARCHAR(50),@ApeMaterno VARCHAR(50),@Direccion VARCHAR(50),
@Celular INT,@NombreUsuario VARCHAR(50)
AS
BEGIN
    IF EXISTS (SELECT DniPersona FROM TPersona WHERE DniPersona=@DniPersona)
        IF EXISTS(SELECT NombreUsuario FROM TPersona WHERE NombreUsuario=@NombreUsuario)
        BEGIN
            BEGIN TRANSACTION TransAgregar
            BEGIN TRY
                UPDATE TPersona SET Nombre=@Nombre,ApePaterno=@ApePaterno,ApeMaterno=@ApeMaterno,
                Direccion=@Direccion,Celular=@Celular WHERE DniPersona=@DniPersona and NombreUsuario=@NombreUsuario
            COMMIT TRANSACTION TransAgregar
                SELECT CodError = 0, Mensaje = 'Proceso de actualizado correcto'
            END TRY
            BEGIN CATCH
                ROLLBACK TRANSACTION TransAgregar
                SELECT CodError = 1, Mensaje = 'Error, la transancción no se ejecutó'
            END CATCH
        END
        ELSE SELECT CodError = 1, Mensaje = 'Error, Email no existe'
    ELSE SELECT CodError = 1, Mensaje = 'Error, Usuario no existe '
END
GO
--FIN DE PROCEDIMIENTO ALMACENADO DE ACTUALIZAR PERSONAN
--PROBANDO PROCEDIMIENTO ALMACENADO SPACTUALIZARDATAPERSONAS
EXECUTE spActualizarDataPersonas '47346578','Maricarmen','Diaz','Chavez','Urb.Nogales','987675643','chuchin@gmail.com'
GO
EXECUTE spListarPersonas
GO
--fin de prueba
----------------------------------------------------------------------

--procedimiento almacenado de actualizar correo para usuario admin
IF OBJECT_ID('spActualizarEmailPersonasAdmin') IS NOT NULL
    DROP PROCEDURE spActualizarEmailPersonasAdmin
GO
CREATE PROCEDURE spActualizarEmailPersonasAdmin
@DniPersona VARCHAR(8), @NombreUsuario VARCHAR(50)
AS
BEGIN
    IF EXISTS (SELECT DniPersona FROM TPersona WHERE DniPersona=@DniPersona)
        IF NOT EXISTS(SELECT NombreUsuario FROM TPersona WHERE NombreUsuario=@NombreUsuario)
        BEGIN
            BEGIN TRANSACTION TransActualizar
            BEGIN TRY
                UPDATE TPersona SET NombreUsuario=@NombreUsuario WHERE DniPersona=@DniPersona
            COMMIT TRANSACTION TransActualizar
                SELECT CodError = 0, Mensaje = 'Proceso de actualizado correcto'
            END TRY
            BEGIN CATCH
                ROLLBACK TRANSACTION TransActualizar
                SELECT CodError = 1, Mensaje = 'Error, la transancción no se ejecutó'
            END CATCH
        END
        ELSE SELECT CodError = 1, Mensaje = 'Error, Email existe'
    ELSE SELECT CodError = 1, Mensaje = 'Error, DNI no existe '
END
GO
--fin de procedimiento almacenado de actualziar correo para usuario administrador
--prueba procedimiento almacenado spactualizardatapersonasadmin
EXECUTE spActualizarEmailPersonasAdmin '47346578','diazchavez@gmail.com'
GO
EXECUTE spListarPersonas
GO
--fin de prueba
--------------------------------------------------------------------------

--procedimiento almacenado de actualizar dni para usuario admin
IF OBJECT_ID('spActualizarDniPersonasAdmin') IS NOT NULL
    DROP PROCEDURE spActualizarDniPersonasAdmin
GO
CREATE PROCEDURE spActualizarDniPersonasAdmin
@NombreUsuario VARCHAR(50), @DniPersona VARCHAR(8)
AS
BEGIN
    --VALIDAMOS QUE EL USUARIO EXISTA
    IF EXISTS (SELECT NombreUsuario FROM TPersona WHERE NombreUsuario=@NombreUsuario)
        --VALIDAMOS QUE EL DNI NO EXISTA
        IF NOT EXISTS(SELECT DniPersona FROM TPersona WHERE DniPersona=@DniPersona)
        BEGIN
            BEGIN TRANSACTION TransActualizar
            BEGIN TRY
                UPDATE TPersona SET DniPersona=@DniPersona WHERE NombreUsuario=@NombreUsuario
            COMMIT TRANSACTION TransActualizar
                SELECT CodError = 0, Mensaje = 'Proceso de actualizado correcto'
            END TRY
            BEGIN CATCH
                ROLLBACK TRANSACTION TransActualizar
                SELECT CodError = 1, Mensaje = 'Error, la transancción no se ejecutó'
            END CATCH
        END
        ELSE SELECT CodError = 1, Mensaje = 'Error, DNI existe'
    ELSE SELECT CodError = 1, Mensaje = 'Error, Usuario no existe '
END
GO
--fin de procedimiento almacenado de actualziar dni para usuario administrador
--prueba procedimiento almacenado spactualizardnipersonasadmin
EXECUTE spActualizarDniPersonasAdmin 'diazchavez@gmail.com','78091987'
GO
EXECUTE spListarPersonas
GO
--fin de prueba
--------------------------------------------------------------------------


--PROCEDIMIENTO ALMACENADO ELIMINAR PERSONA usuario:admin
IF OBJECT_ID('spEliminarPersonas') IS NOT NULL
    DROP PROCEDURE spEliminarPersonas
GO
CREATE PROCEDURE spEliminarPersonas
@DniPersona VARCHAR(8), @NombreUsuario VARCHAR(50)
AS
BEGIN
    --validamos que el usuario exista
    IF EXISTS (SELECT DniPersona FROM TPersona WHERE DniPersona=@DniPersona)
        --VALIDAMOS QUE EL DNI NO EXISTA
        IF EXISTS(SELECT NombreUsuario FROM TPersona WHERE NombreUsuario=@NombreUsuario)
        BEGIN
            BEGIN TRANSACTION TransEliminar
            BEGIN TRY
                DELETE FROM TPersona WHERE DniPersona=@DniPersona AND NombreUsuario=@NombreUsuario
            COMMIT TRANSACTION TransEliminar
                SELECT CodError = 0, Mensaje = 'Proceso de eliminación correcto'
            END TRY
            BEGIN CATCH
                ROLLBACK TRANSACTION TransEliminar
                SELECT CodError = 1, Mensaje = 'Error, la transancción no se ejecutó'
            END CATCH
        END
        ELSE SELECT CodError = 1, Mensaje = 'Error, Usuario no existe'
    ELSE SELECT CodError = 1, Mensaje = 'Error, DNI no existe '
END
GO
--fin de procedimiento almacenado
--prueba de procedimientoalmacenado eliminar personas
EXECUTE spEliminarPersonas '47346578','chuchin@gmail.com'
GO
EXECUTE spListarPersonas
GO
--fin de prueba
--------------------------------------------------------------------------

--procedimiento almacenado para buscar personas
IF OBJECT_ID('spBuscarPersonas') IS NOT NULL
    DROP PROCEDURE spBuscarPersonas
GO
CREATE PROCEDURE spBuscarPersonas
@Texto varchar(50), @Criterio varchar(20)
AS
BEGIN
    if(@Criterio = 'DniPersona') --Busqueda exacta
        SELECT DniPersona,NombreUsuario,Nombre,ApePaterno,ApeMaterno,Direccion,Celular from TPersona where DniPersona = @Texto
    else if (@Criterio = 'NombreUsuario') --Busqueda sensitiva
        select NombreUsuario,DniPersona,Nombre,ApePaterno,ApeMaterno,Direccion,Celular from TPersona where NombreUsuario like @Texto + '%' 
    else if (@Criterio = 'Nombre') --Busqueda sensitiva
        select Nombre,ApePaterno,ApeMaterno,DniPersona,NombreUsuario,Direccion,Celular from TPersona where Nombre like @Texto + '%'
    else if (@Criterio = 'ApePaterno') --Busqueda sensitiva
        select ApePaterno,ApeMaterno,Nombre,DniPersona,Direccion,Celular,NombreUsuario from TPersona where ApePaterno like @Texto + '%'
    else if (@Criterio = 'Celular') --Busqueda sensitiva
        select Celular,DniPersona,NombreUsuario,ApePaterno,ApeMaterno,Nombre,Direccion from TPersona where Celular like @Texto + '%'
END
GO
--fin de procedimiento almacenado buscar
--prueba de procedimiento almacenado buscar personas
EXECUTE spBuscarPersonas '72663013','DniPersona'
GO
EXECUTE spBuscarPersonas 'luispalomino@gmail.com','NombreUsuario'
GO
--------------------------------------------------------------------------

-- TODO: falta implementar los procedimiento almcacenados de inicio de sesión encriptado, cambiar contraseña encriptada,
-- TODO: alterar spAgregar, actualizar persona con encriptación
--PROCEDIMIENTO ALMACENADO DE LOGIN
IF OBJECT_ID('spLogin') IS NOT NULL
    DROP PROCEDURE spLogin
GO
CREATE PROCEDURE spLogin
@NombreUsuario VARCHAR(50), @Contrasena VARCHAR(MAX)
AS
BEGIN
    if exists(select NombreUsuario from TPersona where NombreUsuario = @NombreUsuario)
    BEGIN
        BEGIN TRANSACTION TransLogin
        BEGIN TRY
            declare @ContrasenaD varchar(50)
            DECLARE @TipoUser INT
            set @ContrasenaD = (select CAST(DecryptByPassPhrase('Password',Contrasena) As varchar(50)) from TPersona where NombreUsuario = @NombreUsuario)		
            set @TipoUser = (SELECT TipoUsuario FROM TPersona where NombreUsuario =@NombreUsuario)
            if(@Contrasena=@ContrasenaD)
                begin			
                    select CodError = 0, Mensaje = @NombreUsuario,TipodeUsuario = @TipoUser
                end
            ELSE SELECT CodError = 1, Mensaje = 'Error: Usuario y/o Contrasena incorrectas'
        COMMIT TRANSACTION TransLogin
            SELECT CodError = 0, Mensaje = 'Proceso de login ejecutada'
        END TRY
        BEGIN CATCH
            ROLLBACK TRANSACTION TransLogin
            SELECT CodError = 1, Mensaje = 'Error, la transancción no se ejecutó'
        END CATCH
    END
	else select CodError = 1, Mensaje = 'Error: Usuario y/o Contraseña Incorrectas'	
END
GO
--fin de prcedimiento almacenado splogin
--prueba de procedimiento splogin
EXECUTE spLogin 'chuchin@gmail.com','123123'
GO
EXECUTE spLogin 'daryllagunar@gmail.com','123456'
GO
SELECT * from TPersona
--fin de prueba login
--------------------------------------------------------------------

-- procedimiento almacenado actualizar contraseña para tpersona usuario:trabajador etc
IF OBJECT_ID('spActualizarPassword') IS NOT NULL
    DROP PROCEDURE spActualizarPassword
GO
CREATE PROCEDURE spActualizarPassword
@NombreUsuario VARCHAR(50), @Contrasena VARCHAR(max), @NuevaContrasena VARCHAR(MAX),@RepeatNuevaContrasena VARCHAR(MAx)
AS
BEGIN
    -- validamos que el usuario exista en la base de datos
    if exists(select NombreUsuario from TPersona where NombreUsuario = @NombreUsuario)
        BEGIN
            BEGIN TRANSACTION TransActualizarPass
            BEGIN TRY
            DECLARE @ContrasenaD VARCHAR(50)
            set @ContrasenaD = (select CAST(DecryptByPassPhrase('Password',Contrasena) As varchar(50)) from TPersona where NombreUsuario = @NombreUsuario)
            -- validacion que la contraseña ingresada sea igual a la contraseña desencriptada
            if(@Contrasena=@ContrasenaD)
                begin			
                    --validación que la nueva contraseña y la repetida coincidan
                    IF(@NuevaContrasena=@RepeatNuevaContrasena)
                        BEGIN
                            IF(@Contrasena<>@NuevaContrasena)
                            BEGIN
                                UPDATE TPersona SET Contrasena=(ENCRYPTBYPASSPHRASE('Password',@NuevaContrasena)) where NombreUsuario = @NombreUsuario 
                                SELECT CodError=0,Mensaje='Cambio de contraseña exitoso'
                            END
                            ELSE SELECT CodError=1,Mensaje='Error: La nueva contraseña no puede coincidir con la antigua contreseña'
                        END
                    ELSE SELECT CodError=1, Mensaje='Error: Las contraseñas nuevas no coinciden'
                end
            ELSE SELECT CodError = 1, Mensaje = 'Error: Contrasena incorrectas'
            COMMIT TRANSACTION TransActualizarPass
                SELECT CodError = 0, Mensaje = 'Transacción ejecutada'
            END TRY
            BEGIN CATCH
                ROLLBACK TRANSACTION TransActualizarPass
                SELECT CodError = 1, Mensaje = 'Error, la transancción no se ejecutó'
            END CATCH
        END
    ELSE SELECT CodError=1, Mensaje='Error: Usuario y/o Contraseña Incorrectas'
END
GO
-- fin de procedimiento almacenado
--prueba de procedimiento almacenado actualizar password
EXECUTE spActualizarPassword 'daryllagunar@gmail.com','12345','123456','123456'
GO
--fin de prueba de procedimiento almacenado actualizar contrasena
