# .NET Project Template Generators

A collection of Windows Batch scripts (`.bat`) designed to automate the scaffolding and initialization of .NET solutions and projects following Domain-Driven Design (DDD), Onion Architecture, and Monolithic patterns.

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

### 1. Domain-Driven Design (.NET 9) — `create-ddd-dotnet.bat`
Creates a **DDD / Clean Architecture** structure with strict layering:
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

### 2. Onion Architecture (NoSQL / MongoDB) — `create-onion-nosql.bat`
Scaffolds a project structure tailored for **MongoDB** backends:
* **`Core`**: Contains `Entities`, `Interfaces`, `Services`, and installs `Newtonsoft.Json`.
* **`Infrastructure`**: Contains `Repositories`, `UnitOfWork`, and installs `MongoDB.Driver`, `MongoDB.Bson`, `Microsoft.Extensions.Configuration`.
* **`API`**: Web API setup with `AutoMapper`, `JwtBearer`, `OpenApi`, and `Swashbuckle`.
* **`Tests`**: Includes `Moq`, `xUnit`, and `Microsoft.AspNetCore.Mvc.Testing` for integration testing.

---

### 3. Onion Architecture (SQL / EF Core) — `create-onion-sql.bat`
Scaffolds an **Entity Framework Core (SQL Server)** project structure:
* **`Core`**: Entities, Interfaces, Services.
* **`Infrastructure`**: `Data`, `Repositories`, `UnitOfWork`, pre-loaded with `Microsoft.EntityFrameworkCore.SqlServer`, `Design`, and `Tools`.
* **`API`**: Pre-configured with `AutoMapper`, `EF Core Design`, and Swagger UI (`Swashbuckle`).
* **`Tests`**: Complete testing environment setup with xUnit, Moq, and integration test setup.

---

### 4. Simple Monolithic Web API — `create-monolith-api.bat`
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
