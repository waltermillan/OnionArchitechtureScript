@echo off
:: Capturar el nombre de la carpeta actual
for %%f in ("%CD%") do set PROJECT_NAME=%%~nxf
echo Creando proyecto: %PROJECT_NAME%

:: El directorio base es la carpeta actual donde corre el script (ej: D:\Xarasa)
set BASE_DIR=%CD%

:: 1. Crear la solución
call dotnet new sln -n "%PROJECT_NAME%" --force

:: 2. Crear los proyectos
call dotnet new webapi -o API --force
call dotnet new classlib -o Core --force
call dotnet new classlib -o Infrastructure --force
call dotnet new xunit -n Tests -o Tests --force

:: 3. Agregar proyectos a la solución
call dotnet sln add API/API.csproj
call dotnet sln add Core/Core.csproj
call dotnet sln add Infrastructure/Infrastructure.csproj
call dotnet sln add Tests/Tests.csproj

:: 4. Añadir referencias entre proyectos
call dotnet add Infrastructure/Infrastructure.csproj reference Core/Core.csproj
call dotnet add API/API.csproj reference Infrastructure/Infrastructure.csproj
call dotnet add API/API.csproj reference Core/Core.csproj
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
if exist "Tests\UnitTest1.cs" del /F /Q "Tests\UnitTest1.cs"

:: 6. Configurar Core
cd Core
if not exist "Entities" mkdir Entities
if not exist "Interfases" mkdir Interfases
if not exist "Services" mkdir Services
cd ..
if exist "Core\Class1.cs" del /F /Q "Core\Class1.cs"

if exist "%BASE_DIR%\Generic.Core" (
    xcopy /E /I /H /Y "%BASE_DIR%\Generic.Core\*" "%BASE_DIR%\Core\"
)

:: 7. Configurar Infrastructure
cd Infrastructure
if not exist "Data" mkdir Data
if not exist "Repositories" mkdir Repositories
if not exist "UnitOfWork" mkdir UnitOfWork
call dotnet add package Microsoft.EntityFrameworkCore --no-restore
call dotnet add package Microsoft.EntityFrameworkCore.Design --no-restore
call dotnet add package Microsoft.EntityFrameworkCore.SqlServer --no-restore
call dotnet add package Microsoft.EntityFrameworkCore.Tools --no-restore
call dotnet restore
cd ..
if exist "Infrastructure\Class1.cs" del /F /Q "Infrastructure\Class1.cs"

if exist "%BASE_DIR%\Generic.Infrastructure" (
    xcopy /E /I /H /Y "%BASE_DIR%\Generic.Infrastructure\*" "%BASE_DIR%\Infrastructure\"
)

:: 8. Configurar API
cd API
if not exist "Controllers" mkdir Controllers
if not exist "Extensions" mkdir Extensions
if not exist "Helpers" mkdir Helpers

:: Removemos el paquete nativo que genera el conflicto con Swashbuckle en .NET 9/10
call dotnet remove package Microsoft.AspNetCore.OpenApi

:: Agregamos tus paquetes de siempre (con Swashbuckle intacto)
call dotnet add package Microsoft.OpenApi --no-restore
call dotnet add package AutoMapper --no-restore
call dotnet add package Microsoft.EntityFrameworkCore.Design --no-restore
call dotnet add package Swashbuckle.AspNetCore --no-restore
call dotnet restore
cd ..

:: Copia desde la raíz hacia la carpeta API recién generada
if exist "%BASE_DIR%\Generic.API" (
    xcopy /E /I /H /Y "%BASE_DIR%\Generic.API\*" "%BASE_DIR%\API\"
)

:: 9. Compilar la solución
call dotnet build "%PROJECT_NAME%.sln"

echo === Proceso finalizado con exito ===
pause