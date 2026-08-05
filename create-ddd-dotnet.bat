@echo off
:: 1. Crear la solución
dotnet new sln -n InventoryManagement

:: 2. Crear carpetas físicas
mkdir src
mkdir tests

:: 3. Crear proyectos dentro de sus carpetas definitivas
:: Es mejor crearlos directamente en su ruta para evitar problemas de movimiento de archivos
dotnet new classlib -n Domain -f net9.0 -o src/Domain
dotnet new classlib -n Application -f net9.0 -o src/Application
dotnet new classlib -n Infrastructure -f net9.0 -o src/Infrastructure
dotnet new webapi -n Web.Api -f net9.0 -o src/Web.Api
dotnet new xunit -n UnitTests -f net9.0 -o tests/UnitTests

:: 4. Agregar proyectos a la solución
dotnet sln add src/Domain/Domain.csproj
dotnet sln add src/Application/Application.csproj
dotnet sln add src/Infrastructure/Infrastructure.csproj
dotnet sln add src/Web.Api/Web.Api.csproj
dotnet sln add tests/UnitTests/UnitTests.csproj

:: 5. Establecer referencias entre proyectos
:: Application solo conoce a Domain
dotnet add src/Application/Application.csproj reference src/Domain/Domain.csproj

:: Infrastructure conoce a Application (y por transatividad a Domain)
dotnet add src/Infrastructure/Infrastructure.csproj reference src/Application/Application.csproj

:: Web.Api conoce a Application e Infrastructure para la Inyección de Dependencias
dotnet add src/Web.Api/Web.Api.csproj reference src/Application/Application.csproj
dotnet add src/Web.Api/Web.Api.csproj reference src/Infrastructure/Infrastructure.csproj

:: Tests referencia a lo que necesites probar (usualmente Application o Domain)
dotnet add tests/UnitTests/UnitTests.csproj reference src/Application/Application.csproj

echo Estructura de InventoryManagement creada con éxito.