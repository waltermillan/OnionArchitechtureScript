# 🏗️ Architecture Templates

Collection of automated boilerplate engines to instantly spin up .NET 10 solutions under different architectural styles and database configurations.

---

## 📅 Changelog

- **09/08/2026**: Fixed reference constraints and solution mapping bugs in the template engine generation loops.
- **09/08/2026**: Resolved metadata compilation errors by decoupling conflicting OpenAPI dependencies across modern web projects.
- **08/08/2026**: Initial release. Standardized core structure definitions for SQL, NoSQL, Hexagonal, and Monolithic templates.

---

## 🎯 Objective

Provide a central hub of automation templates to bootstrap ready-to-code environments. Each project isolates infrastructure requirements, enforces clean boundary separations, and standardizes data access patterns right out of the box.

Technologies:

- **.NET 10 (C#)**
- **SQL Server & MongoDB**
- **Architecture Design Patterns**
- **Docker Support**

---

## 🚀 Features

### 🔧 Available Projects

- **`clean-architecture-nosql`**: 
  - Onion Architecture structure decoupled from relational limits.
  - Pre-configured for document-oriented storages using native drivers.
  - Implements Repository patterns focused on high-throughput and eventual consistency.

- **`clean-architecture-sql`**:
  - Classic Onion Architecture design with strict domain isolation (`Core`, `Infrastructure`, `API`, `Tests`).
  - Powered by Entity Framework Core with automatic migration pipelines.
  - Full support for **Generic Repository** and **Unit of Work** transactional patterns.

- **`hexagonal-architecture`**:
  - Ports and Adapters pattern enforcing absolute decoupling from external actors.
  - Core application logic completely isolated from frameworks, databases, and delivery mechanisms.
  - Explicit port interfaces matching pluggable inbound/outbound infrastructure adapters.

- **`monolithic`**:
  - High-velocity structural configuration unified in a simplified domain-centric boundary.
  - Ideal for rapid prototyping, microservices, or low-complexity CRUD services.
  - Streamlined data layer integration without multi-project dependency mapping friction.

---

## 🧪 Installation

### ✅ Prerequisites

Ensure the following tools are installed on your environment:

- [.NET SDK 10.0.100+](https://dotnet.microsoft.com/)
- [Docker Desktop](https://www.docker.com/) (For SQL Server / Mongo container instances)

---

### 🔧 Setup Steps

1. Navigate to the specific architecture directory you want to spin up (e.g., `cd clean-architecture-sql`).
2. Run the internal execution engine to bootstrap the targeted setup:
    ```bash
    create-onion-sql.bat
    ```
3. The engine will instantly wire the project relationships, drop native boilerplates, and trigger a `dotnet build` verification check.

---

## 📄 License

This project is licensed under the [MIT License](LICENSE).
