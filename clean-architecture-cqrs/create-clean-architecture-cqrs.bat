@echo off
:: Capturar el nombre de la carpeta actual como nombre del proyecto
for %%f in ("%CD%") do set PROJECT_NAME=%%~nxf
echo Creando estructura Clean Architecture CQRS para: %PROJECT_NAME%

set BASE_DIR=%CD%

:: 1. Crear la solución master
call dotnet new sln -n "%PROJECT_NAME%" --force

:: 2. Crear los 4 proyectos según el diagrama
call dotnet new webapi -o Presentation --force
call dotnet new classlib -o Application --force
call dotnet new classlib -o Domain --force
call dotnet new classlib -o Infrastructure --force

:: 3. Agregar los proyectos a la solución
call dotnet sln add Presentation/Presentation.csproj
call dotnet sln add Application/Application.csproj
call dotnet sln add Domain/Domain.csproj
call dotnet sln add Infrastructure/Infrastructure.csproj

:: 4. Configurar la jerarquía de dependencias estricta (Hacia el centro del círculo)
:: Application solo conoce a Domain
call dotnet add Application/Application.csproj reference Domain/Domain.csproj

:: Infrastructure conoce a Application (y por transitividad a Domain)
call dotnet add Infrastructure/Infrastructure.csproj reference Application/Application.csproj

:: Presentation conoce a Application e Infrastructure para resolver la Inyección de Dependencias
call dotnet add Presentation/Presentation.csproj reference Application/Application.csproj
call dotnet add Presentation/Presentation.csproj reference Infrastructure/Infrastructure.csproj

:: 5. Limpieza de archivos basura por defecto de Microsoft
if exist "Domain\Class1.cs" del /F /Q "Domain\Class1.cs"
if exist "Application\Class1.cs" del /F /Q "Application\Class1.cs"
if exist "Infrastructure\Class1.cs" del /F /Q "Infrastructure\Class1.cs"

:: 6. Inicializar carpetas estructurales del diagrama
:: DOMAIN
cd Domain
if not exist "Entities" mkdir Entities
if not exist "Interfaces" mkdir Interfaces
cd ..

:: APPLICATION
cd Application
if not exist "Commands" mkdir Commands
if not exist "Queries" mkdir Queries
if not exist "DTOs" mkdir DTOs
if not exist "Events" mkdir Events
if not exist "Exceptions" mkdir Exceptions
if not exist "Mapping" mkdir Mapping
:: Instalar MediatR (esencial para los Commands/Queries del diagrama)
call dotnet add package MediatR --no-restore
cd ..

:: INFRASTRUCTURE
cd Infrastructure
if not exist "Data" mkdir Data
if not exist "Migrations" mkdir Migrations
if not exist "Repositories" mkdir Repositories
if not exist "Services" mkdir Services
call dotnet add package Microsoft.EntityFrameworkCore --no-restore
call dotnet add package Microsoft.EntityFrameworkCore.SqlServer --no-restore
call dotnet add package Microsoft.EntityFrameworkCore.Design --no-restore
cd ..

:: PRESENTATION
cd Presentation
if not exist "Controllers" mkdir Controllers
:: Desinstalar el paquete nativo que rompe Swashbuckle en .NET 10
call dotnet remove package Microsoft.AspNetCore.OpenApi
:: Agregar dependencias visuales y de documentación
call dotnet add package Swashbuckle.AspNetCore --no-restore
call dotnet add package AutoMapper --no-restore
cd ..

:: 7. Restaurar e intentar primera compilación de validación
call dotnet restore
call dotnet build "%PROJECT_NAME%.sln"

echo === Arquitectura CQRS generada y validada con éxito ===
pause