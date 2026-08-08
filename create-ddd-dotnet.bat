@echo off
:: Capturar el nombre de la carpeta actual donde se ejecuta el script
for %%f in ("%CD%") do set PROJECT_NAME=%%~nxf

:: 1. Crear la solución
call dotnet new sln -n %PROJECT_NAME%

:: 2. Crear carpetas físicas
mkdir src
mkdir tests

:: 3. Crear proyectos dentro de sus carpetas definitivas
:: Es mejor crearlos directamente en su ruta para evitar problemas de movimiento de archivos
call dotnet new classlib -n Domain -f net9.0 -o src/Domain
call dotnet new classlib -n Application -f net9.0 -o src/Application
call dotnet new classlib -n Infrastructure -f net9.0 -o src/Infrastructure
call dotnet new webapi -n Web.Api -f net9.0 -o src/Web.Api
call dotnet new xunit -n UnitTests -f net9.0 -o tests/UnitTests

:: 4. Agregar proyectos a la solución
call dotnet sln add src/Domain/Domain.csproj
call dotnet sln add src/Application/Application.csproj
call dotnet sln add src/Infrastructure/Infrastructure.csproj
call dotnet sln add src/Web.Api/Web.Api.csproj
call dotnet sln add tests/UnitTests/UnitTests.csproj

:: 5. Establecer referencias entre proyectos
:: Application solo conoce a Domain
call dotnet add src/Application/Application.csproj reference src/Domain/Domain.csproj

:: Infrastructure conoce a Application (y por transatividad a Domain)
call dotnet add src/Infrastructure/Infrastructure.csproj reference src/Application/Application.csproj

:: Web.Api conoce a Application e Infrastructure para la Inyección de Dependencias
call dotnet add src/Web.Api/Web.Api.csproj reference src/Application/Application.csproj
call dotnet add src/Web.Api/Web.Api.csproj reference src/Infrastructure/Infrastructure.csproj

:: Tests referencia a lo que necesites probar (usualmente Application o Domain)
call dotnet add tests/UnitTests/UnitTests.csproj reference src/Application/Application.csproj

echo Estructura de %PROJECT_NAME% creada con éxito.
pause