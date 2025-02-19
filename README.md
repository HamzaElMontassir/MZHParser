# HexagonalParser

HexagonalParser is a modular and configurable application developed in VB.NET following the hexagonal architecture. It automates file processing through a Worker service, a REST API interface, and a Web console application for management and configuration. The project incorporates best practices like SOLID principles, design patterns, and dynamic rule-based processing.

## **Main Features**

1. **File Processing**
    - Load and validate input files from predefined directories.
    - Apply dynamic mappings with a rule engine to transform data.
    - Manage errors with detailed logging and quarantining of invalid files.

2. **Management and Configuration**
    - Configure mappings and business rules dynamically via a console interface or API.
    - Support for various file types (CSV, JSON, XML, flat files).
    - Store configurations and mappings in a database for easy updates.

3. **Interoperability**
    - Communicate with external APIs to validate or enrich data.
    - Support multithreading and batching for efficient file processing.
    - Enable output file validation via external web services.

4. **Logging and Traceability**
    - Integration with Serilog for structured and detailed logs.
    - Comprehensive traceability for each file through unique correlation IDs.

5. **Extensibility**
    - Easy addition of new file types, transformation rules, and validation mechanisms.
    - Modular design ensures adaptability to future requirements.

---

## **Project Structure**

### **Projects**
- **`HexagonalParser.Application`**:
    - Contains use cases, DTOs, and interfaces for orchestrating business logic.

- **`HexagonalParser.Domain`**:
    - Defines domain entities, pure business services, and value objects.

- **`HexagonalParser.Infrastructure`**:
    - Implements adapters for persistence, logging, caching, and external services.

- **`HexagonalParser.Web`**:
    - Console application for configuring and managing processing tasks.

- **`HexagonalParser.WorkerService`**:
    - Windows service for background file processing with support for batching and multithreading.

- **`HexagonalParser.API`**:
    - REST API for integration with external systems and exposing core functionalities.

### **Shared Directories**
- **`Shared`**:
    - Contains utilities, constants, and common extensions for reusability.

- **`Adapters`**:
    - Manages incoming adapters (API, CLI) and outgoing adapters (database, external services).

---

## **Prerequisites**

1. **.NET 9.0 SDK**
2. **SQL Server Database**
3. **IIS (Internet Information Services)** for deployment.
4. **Serilog** for logging.

---

## **Installation and Configuration**

1. **Clone the Repository**:
   ```bash
   git clone https://github.com/your-repository/HexagonalParser.git
   cd HexagonalParser
   ```

2. **Create Solution and Projects**:
   Use the PowerShell script to generate the complete structure:
   ```bash
   ./CreateHexagonalParserStructure.ps1
   ```

3. **Configure the Database**:
    - Update connection strings in `appsettings.json` and environment-specific files.
    - Apply SQL scripts to create necessary tables, including rules, mappings, and logs.

4. **Run Tests**:
   ```bash
   dotnet test
   ```

5. **Run the Application**:
    - Start the Worker service:
      ```bash
      cd src/HexagonalParser.WorkerService
      dotnet run
      ```
    - Start the API:
      ```bash
      cd src/HexagonalParser.API
      dotnet run
      ```

---

## **Deployment**

1. **Publish the Application**:
   ```bash
   dotnet publish -c Release -o "C:\Sites\HexagonalParser"
   ```

2. **Configure IIS**:
    - Add a new website pointing to the published directory.
    - Set the environment variable `ASPNETCORE_ENVIRONMENT` (Development, Staging, Production).

3. **Monitor Logs**:
    - Logs are available in the `logs/application.log` file.

---

## **Advanced Features**

### **Dynamic Rule Engine**
- Apply transformation and validation rules stored in the database.
- Support for various operations:
    - Field transformations (e.g., replace values, substring extraction).
    - Conditional rules for advanced processing.
    - Validation rules (e.g., regex validation, mandatory fields).

### **Batch Processing and Multithreading**
- Process multiple files concurrently using a thread pool.
- Optimize file handling for large datasets with batch size configurations.

### **External Web Service Validation**
- Validate output files by sending them to an external web service before marking the process as complete.

---

## **Roadmap**

- Add a graphical interface for managing mappings and configurations.
- Integrate a monitoring system with real-time alerts and dashboards.
- Extend support for additional standards such as ISO 20022.
- Explore machine learning for automatic anomaly detection and rule suggestions.

---

## **Contributions**

Contributions are welcome! Please submit a Pull Request or open an issue to discuss your ideas.

---

## **License**

This project is licensed under the MIT License. See the `LICENSE` file for more details.
