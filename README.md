# .NET Project Template Generators

A collection of Windows Batch scripts (`.bat`) designed to automate the scaffolding and initialization of .NET solutions and projects following Clean Architecture, Onion Architecture, and Modular Single-Project patterns.

---

## 📋 Features

- **Automated Scaffolding**: Automatically creates `.sln` files, project folders, class libraries, Web APIs, and testing suites.
- **Dependency Management**: Links project references (`.csproj` interdependencies) automatically.
- **Pre-configured Packages**: Automatically installs commonly used NuGet packages (AutoMapper, Entity Framework Core, MongoDB Driver, Moq, Swashbuckle, etc.).
- **Directory Structuring**: Sets up standard architecture directories (`Entities`, `Repositories`, `Controllers`, `Interfaces`, `Middlewares`, `UnitOfWork`, etc.) with `.gitkeep` files where needed.
- **Custom Template Boilerplate Copying**: Automatically imports base/generic files from standard directory structures into newly created projects.

---

## 🛠️ Requirements

To run these scripts, you only need to have the **.NET SDK** installed on your system.

* **.NET SDK** (Version 8.0, 9.0, or compatible depending on script target).
  * You can check your installed SDK version by running:
    ```cmd
    dotnet --version
    ```
  * Download the latest version from [dotnet.microsoft.com](https://dotnet.microsoft.com/download).

> **Note:** These scripts are Batch files (`.bat`) designed to run natively in **Windows Command Prompt (CMD)** or **PowerShell**.

---

## 📂 Included Scripts & Architectures

### 1. Clean Architecture (.NET 9) — `setup_clean_architecture.bat`
Creates an explicit **Clean Architecture** structure with strict layering:
* **`Domain`**: Pure enterprise logic and models.
* **`Application`**: Application logic and interfaces.
* **`Infrastructure`**: External concerns and data access.
* **`Web.Api`**: REST API presentation layer.
* **`UnitTests`**: xUnit testing project.

**Project References Built:**
* `Application` ➔ `Domain`
* `Infrastructure` ➔ `Application` (and transitively `Domain`)
* `Web.Api` ➔ `Application` & `Infrastructure`
* `UnitTests` ➔ `Application`

---

### 2. Onion Architecture (MongoDB Stack) — `setup_onion_mongodb.bat`
Scaffolds a project structure tailored for **MongoDB** backends:
* **`Core`**: Contains `Entities`, `Interfaces`, `Services`, and installs `Newtonsoft.Json`.
* **`Infrastructure`**: Contains `Repositories`, `UnitOfWork`, and installs `MongoDB.Driver`, `MongoDB.Bson`, `Microsoft.Extensions.Configuration`.
* **`API`**: Web API setup with `AutoMapper`, `JwtBearer`, `OpenApi`, and `Swashbuckle`.
* **`Tests`**: Includes `Moq`, `xUnit`, and `Microsoft.AspNetCore.Mvc.Testing` for integration testing.

---

### 3. Onion Architecture (EF Core / SQL Server Stack) — `setup_onion_efcore.bat`
Scaffolds an **Entity Framework Core (SQL Server)** project structure:
* **`Core`**: Entities, Interfaces, Services.
* **`Infrastructure`**: `Data`, `Repositories`, `UnitOfWork`, pre-loaded with `Microsoft.EntityFrameworkCore.SqlServer`, `Design`, and `Tools`.
* **`API`**: Pre-configured with `AutoMapper`, `EF Core Design`, and Swagger UI (`Swashbuckle`).
* **`Tests`**: Complete testing environment setup with xUnit, Moq, and integration test setup.

---

### 4. Lightweight Single-Project Web API — `setup_lightweight_api.bat`
Scaffolds a streamlined, single-project Web API structure directly in the current working folder:
* Generates Web API and `.sln` in the root folder named after the current directory.
* Cleans default template bloat (removes default `WeatherForecast` controller and model).
* Automatically creates architectural sub-directories (`Data/`, `Interfaces/`, `Middlewares/`, `Models/`, `Repositories/`) with `.gitkeep` files.

---

## 🚀 How to Run

1. Open **Command Prompt** or **PowerShell**.
2. Navigate to your target directory where you want the project created:
   ```cmd
   cd C:\path\to\your\projects
   ```
3. Run the target script (e.g., inside an empty directory created for your new project):
   ```cmd
   path\to\script\setup_clean_architecture.bat
   ```
4. The script will generate all projects, apply project references, restore NuGet packages, and build the solution automatically.

---

## ⚙️ Customization

- **Generic File Imports**: Scripts using `xcopy` expect standard base template folders located at `C:\proyectos\.NET Core\<PROJECT_NAME>\Generic.*`. Adjust the `BASE_DIR` variable inside the script to match your local setup if you utilize generic base files.
- **Target Framework**: You can change `-f net9.0` to `-f net8.0` inside any script to target a different .NET version.
