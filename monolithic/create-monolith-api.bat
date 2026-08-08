@echo off
setlocal enabledelayedexpansion

:: 1. Capturar nombre de la carpeta
for %%I in (.) do set ProjectName=%%~nxI

echo === Creando Web API en la carpeta raiz ===
dotnet new webapi -n %ProjectName% -o . --force --no-openapi

echo === Creando Solucion ===
dotnet new sln -n %ProjectName% --force

echo === Vinculando Proyecto a Solucion ===
:: Buscamos cualquier archivo .sln o .slnx y cualquier .csproj para unirlos
for %%s in (*.sln *.slnx) do (
    for %%p in (*.csproj) do (
        dotnet sln "%%s" add "%%p"
    )
)

echo === Creando carpetas de arquitectura ===
if not exist "Data" mkdir Data
if not exist "Interfaces" mkdir Interfaces
if not exist "Middlewares" mkdir Middlewares
if not exist "Models" mkdir Models
if not exist "Repositories" mkdir Repositories

:: Crear un archivo vacío en cada carpeta para forzar su aparición
echo. > Data\.gitkeep
echo. > Interfaces\.gitkeep
echo. > Middlewares\.gitkeep
echo. > Models\.gitkeep
echo. > Repositories\.gitkeep

echo === Limpieza final ===
if exist "WeatherForecast.cs" del "WeatherForecast.cs"
if exist "Controllers\WeatherForecastController.cs" del "Controllers\WeatherForecastController.cs"

echo === LISTO! Revisa tu Explorador de Soluciones ===
pause