@echo off
::set PROJECT_NAME=Prueba
for %%f in ("%CD%") do set PROJECT_NAME=%%~nxf
echo %PROJECT_NAME%

:: Definir la ruta del proyecto
set BASE_DIR=C:\proyectos\.NET Core\%PROJECT_NAME%

:: Crea la solución sin prefijo en los nombres de los proyectos
dotnet new solution -n %PROJECT_NAME%

:: Crea los proyectos sin el prefijo en sus nombres
dotnet new webapi -o API
dotnet new classlib -o Core
dotnet new classlib -o Infrastructure
dotnet new xunit -n Tests

:: Agrega proyectos a la solución
dotnet sln %PROJECT_NAME%.sln add API/API.csproj
dotnet sln %PROJECT_NAME%.sln add Core/Core.csproj
dotnet sln %PROJECT_NAME%.sln add Infrastructure/Infrastructure.csproj
dotnet sln %PROJECT_NAME%.sln add Tests/Tests.csproj
::dotnet sln add SpainCities.Tests/SpainCities.Tests.csproj

:: Añade las referencias entre proyectos (sin Services)
dotnet add API/API.csproj reference Core/Core.csproj
dotnet add Infrastructure/Infrastructure.csproj reference Core/Core.csproj
dotnet add API/API.csproj reference Infrastructure/Infrastructure.csproj

dotnet add Tests/Tests.csproj reference Core/Core.csproj
dotnet add Tests/Tests.csproj reference Infrastructure/Infrastructure.csproj
dotnet add Tests/Tests.csproj reference API/API.csproj

cd Tests

mkdir UnitTests

dotnet add package xUnit
dotnet add package Moq
dotnet add package Microsoft.NET.Test.Sdk
dotnet add package xunit.runner.visualstudio
::6° Instalar Microsoft.AspNetCore.Mvc.Testing (para realizar pruebas de integración de la API):
dotnet add package Microsoft.AspNetCore.Mvc.Testing

cd ../Core

mkdir Entities
mkdir Interfases
mkdir Services

::No independencies

xcopy /E /I /H /Y "%BASE_DIR%\Generic.Core\*" "%BASE_DIR%\Core\"

cd ../Infrastructure

mkdir Data
mkdir Repositories
mkdir UnitOfWork

dotnet add package Microsoft.EntityFrameworkCore
dotnet add package Microsoft.EntityFrameworkCore.Design
dotnet add package Microsoft.EntityFrameworkCore.SqlServer
dotnet add package Microsoft.EntityFrameworkCore.Tools

xcopy /E /I /H /Y "%BASE_DIR%\Generic.Infrastructure\*" "%BASE_DIR%\Infrastructure\"

cd ../API

mkdir Controllers
mkdir Extensions
mkdir Helpers

dotnet add package AutoMapper
dotnet add package Microsoft.AspNetCore.OpenApi
dotnet add package Microsoft.EntityFrameworkCore.Design
dotnet add package Swashbuckle.AspNetCore

xcopy /E /I /H /Y "%BASE_DIR%\Generic.API\*" "%BASE_DIR%\API\"

:: Compila el proyecto [Probablemente nos dé errores]
dotnet build

:: Dejamos en pausa para ver lo realizado
pause
