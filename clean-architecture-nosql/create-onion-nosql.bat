@echo off
:: Capturar el nombre de la carpeta actual
for %%f in ("%CD%") do set PROJECT_NAME=%%~nxf
echo Creando proyecto NoSQL: %PROJECT_NAME%

:: Ruta dinámica basada en la ubicación real del script
set BASE_DIR=%CD%

:: 1. Crear la solución
call dotnet new sln -n "%PROJECT_NAME%" --force

:: 2. Crear los proyectos (--force evita que se detenga si ya existen carpetas)
call dotnet new webapi -o API --force
call dotnet new classlib -o Core --force
call dotnet new classlib -o Infrastructure --force
call dotnet new xunit -n Tests -o Tests --force

:: 3. Agregar proyectos a la solución
call dotnet sln add API/API.csproj
call dotnet sln add Core/Core.csproj
call dotnet sln add Infrastructure/Infrastructure.csproj
call dotnet sln add Tests/Tests.csproj

:: 4. Añadir referencias entre proyectos (CORREGIDO: Eliminado --no-restore por incompatibilidad del CLI)
call dotnet add API/API.csproj reference Core/Core.csproj
call dotnet add Infrastructure/Infrastructure.csproj reference Core/Core.csproj
call dotnet add API/API.csproj reference Infrastructure/Infrastructure.csproj

call dotnet add Tests/Tests.csproj reference Core/Core.csproj
call dotnet add Tests/Tests.csproj reference Infrastructure/Infrastructure.csproj
call dotnet add Tests/Tests.csproj reference API/API.csproj

:: 5. Configurar Tests
cd Tests
if not exist "UnitTests" mkdir UnitTests

call dotnet add package xUnit --no-restore
call dotnet add package Moq --no-restore
call dotnet add package Microsoft.NET.Test.Sdk --no-restore
call dotnet add package xunit.runner.visualstudio --no-restore
call dotnet add package Microsoft.AspNetCore.Mvc.Testing --no-restore
call dotnet restore
cd ..

:: BORRADO: Eliminar plantilla por defecto de Tests
if exist "Tests\UnitTest1.cs" del /F /Q "Tests\UnitTest1.cs"

:: 6. Configurar Core (NoSQL)
cd Core
if not exist "Entities" mkdir Entities
if not exist "Interfases" mkdir Interfases
if not exist "Services" mkdir Services

call dotnet add package Newtonsoft.Json --no-restore
call dotnet add package MongoDB.Bson --no-restore

call dotnet restore
cd ..

:: BORRADO: Eliminar plantilla por defecto de Core
if exist "Core\Class1.cs" del /F /Q "Core\Class1.cs"

:: COPIA: Mover los archivos de Core Genérico
if exist "%BASE_DIR%\Generic.Core" (
    xcopy /E /I /H /Y "%BASE_DIR%\Generic.Core\*" "%BASE_DIR%\Core\"
)

:: 7. Configurar Infrastructure (MongoDB + Serilog)
cd Infrastructure
if not exist "Repositories" mkdir Repositories
if not exist "UnitOfWork" mkdir UnitOfWork

call dotnet add package Microsoft.Extensions.Configuration --no-restore
call dotnet add package MongoDB.Driver --no-restore

:: Paquetes de Serilog
call dotnet add package Serilog --no-restore
call dotnet add package Serilog.Extensions.Logging --no-restore
call dotnet add package Serilog.Sinks.File --no-restore

call dotnet restore
cd ..

:: BORRADO: Eliminar plantilla por defecto de Infrastructure
if exist "Infrastructure\Class1.cs" del /F /Q "Infrastructure\Class1.cs"

:: COPIA: Mover los archivos de Infrastructure Genérico
if exist "%BASE_DIR%\Generic.Infrastructure" (
    xcopy /E /I /H /Y "%BASE_DIR%\Generic.Infrastructure\*" "%BASE_DIR%\Infrastructure\"
)

:: 8. Configurar API
cd API
if not exist "Controllers" mkdir Controllers
if not exist "Extensions" mkdir Extensions
if not exist "Helpers" mkdir Helpers
if not exist "Profiles" mkdir Profiles

call dotnet add package Automapper --no-restore
call dotnet add package Microsoft.AspNetCore.Authentication.JwtBearer --no-restore
call dotnet add package Microsoft.AspNetCore.OpenApi --no-restore
call dotnet add package Swashbuckle.AspNetCore --no-restore
call dotnet restore
cd ..

:: COPIA: Mover los archivos de API Genérico
if exist "%BASE_DIR%\Generic.API" (
    xcopy /E /I /H /Y "%BASE_DIR%\Generic.API\*" "%BASE_DIR%\API\"
)

:: 9. Compilación Final (CORREGIDO: Uso de comillas para evitar errores de ruta/nombre de archivo en MSBuild)
call dotnet build "%PROJECT_NAME%.sln"

echo === Proceso NoSQL finalizado con éxito ===
pause