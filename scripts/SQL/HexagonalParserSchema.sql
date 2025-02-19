-- Complete SQL script for HexagonalParser (Table Definitions)

-- Table: Configurations
CREATE TABLE TBP_OMKParameters (
                                   Id UNIQUEIDENTIFIER PRIMARY KEY, -- Unique identifier
                                   [Key] NVARCHAR(100) NOT NULL UNIQUE, -- Configuration key must be unique across all configurations -- Configuration key (e.g., MaxFileSize, EnableLogging)
                                   Value NVARCHAR(MAX), -- Value associated with the configuration, used only if ConfigType = 'System'
                                   Description NVARCHAR(MAX), -- Description of the configuration
                                   IsActive BIT DEFAULT 1 NOT NULL, -- Indicates if the configuration is active
                                   ConfigType NVARCHAR(50) NOT NULL CHECK (ConfigType IN ('System', 'User', 'Application')), -- Type of configuration
                                   LastUpdated DATETIME DEFAULT GETDATE(), -- Last update date
                                   UserIp NVARCHAR(50) NOT NULL , -- User's IP address
                                   UserName NVARCHAR(255) NOT NULL  -- Name of the user who modified it
);

-- Table: File Configurations
CREATE TABLE TBP_OMKFileConfigurations (
                                   Id UNIQUEIDENTIFIER PRIMARY KEY, -- Unique identifier
                                   ProductName NVARCHAR(255) NOT NULL, -- Product name
                                   Description NVARCHAR(MAX), -- Configuration description
                                   InputFileExtension NVARCHAR(5) NOT NULL CHECK (InputFileExtension IN ('json', 'xml', 'csv', 'txt')), -- Input file type
                                   OutputFileExtension NVARCHAR(5) NOT NULL CHECK (OutputFileExtension IN ('json', 'xml', 'csv', 'txt')), -- Output file type
                                   OutputStructure NVARCHAR(MAX) NOT NULL , -- Expected output structure
                                   RecordFormat NVARCHAR(255), -- Record format (e.g., Fixed Width, Delimited)
                                   IsActive BIT DEFAULT 1 NOT NULL, -- Active or not
                                   LastUpdated DATETIME DEFAULT GETDATE(), -- Last update date
                                   UserIp NVARCHAR(50), -- User's IP address
                                   UserName NVARCHAR(255) -- User's name
);

-- Table: Rules
CREATE TABLE TBP_OMKRules (
                                   Id UNIQUEIDENTIFIER PRIMARY KEY, -- Unique identifier
                                   Name NVARCHAR(255) NOT NULL UNIQUE, -- Rule name
                                   Condition NVARCHAR(MAX) NOT NULL, -- Condition to evaluate (e.g., Length(InputField) = 22)
                                   Action NVARCHAR(MAX) NOT NULL, -- Action to execute (e.g., Mark as Invalid)
                                   IsActive BIT DEFAULT 1 NOT NULL, -- Active or not
                                   ExecutionOrder INT DEFAULT 0, -- Execution order
                                   LastUpdated DATETIME DEFAULT GETDATE(), -- Last update date
                                   UserIp NVARCHAR(50), -- User's IP address
                                   UserName NVARCHAR(255), -- User's name
    -- Examples of conditions:
    -- 1. Check if the field length is 22: Length(InputField) = 22
    -- 2. Check if the amount exceeds a value: Amount > 1000
    -- 3. Validate an IBAN: RegexMatch(InputField, '^([A-Z]{2}[0-9]{2})')
    -- 4. Check if two fields are equal: InputField1 = InputField2
    -- 5. Verify a date format: RegexMatch(InputField, '^\d{4}-\d{2}-\d{2}$')
    -- Examples of actions:
    -- 1. Transform a value: OutputField = CONCAT(InputField1, '-', InputField2)
    -- 2. Mark an entry as invalid: Mark as Invalid
    -- 3. Copy a field with transformation: OutputField = UPPER(InputField)
    -- Complex examples:
    -- Condition: Check if InputField contains '@': CONTAINS(InputField, '@')
    -- Action: Extract domain from email: OutputField = SUBSTRING(InputField, CHARINDEX('@', InputField) + 1)
);

-- Table: Mappings
CREATE TABLE TBP_OMKMappings (
                                   Id UNIQUEIDENTIFIER PRIMARY KEY, -- Unique identifier
                                   InputField NVARCHAR(255) NOT NULL, -- Input field
                                   OutputField NVARCHAR(255) NOT NULL, -- Output field
                                   Transformation NVARCHAR(MAX), -- Transformation (e.g., Concat, Split)
                                   Description NVARCHAR(MAX), -- Mapping description
                                   MappingType NVARCHAR(50) NOT NULL CHECK (MappingType IN ('Transformation', 'Validation')), -- Mapping category
                                   FileId UNIQUEIDENTIFIER NOT NULL, -- Reference to a processed file
                                   FieldOrder INT CHECK (FieldOrder >= 0), -- Field order in the output
                                   IsActive BIT DEFAULT 1 NOT NULL, -- Active or not
                                   LastUpdated DATETIME DEFAULT GETDATE(), -- Last update date
                                   UserIp NVARCHAR(50), -- User's IP address
                                   UserName NVARCHAR(255), -- User's name
    -- Examples of MappingType:
    -- Transformation: Concatenation of "FirstName" and "LastName"
    -- Validation: Check if the "Amount" field is positive
    -- Complex Transformation: Compute a total field from other fields
                                   FOREIGN KEY (FileId) REFERENCES TBP_OMKFileConfigurations(Id) ON DELETE CASCADE
);

-- Table: File-Configuration Relationship
CREATE TABLE TBP_OMKFileParameters (
                                   FileId UNIQUEIDENTIFIER, -- Reference to a file
                                   ParameterId UNIQUEIDENTIFIER, -- Reference to a configuration
                                   Value NVARCHAR(MAX) NOT NULL, -- Value associated with the configuration specific to the file
                                   LastUpdated DATETIME DEFAULT GETDATE(), -- Last update date
                                   UserIp NVARCHAR(50), -- User's IP address
                                   UserName NVARCHAR(255), -- User's name
                                   FOREIGN KEY (FileId) REFERENCES TB_OMKFileProcessing(Id) ON DELETE SET NULL,
                                   FOREIGN KEY (ParameterId) REFERENCES TBP_OMKParameters(Id) ON DELETE SET NULL,
                                   CONSTRAINT UQ_File_Parameter UNIQUE (FileId, ParameterId) -- Ensure uniqueness for each File-Parameter pair
);

-- Table: Mapping-Rule Relationship
CREATE TABLE TBP_OMKMappingsRules (
                                   RuleId UNIQUEIDENTIFIER, -- Reference to a file
                                   MappingId UNIQUEIDENTIFIER, -- Reference to a configuration
                                   LastUpdated DATETIME DEFAULT GETDATE(), -- Last update date
                                   UserIp NVARCHAR(50), -- User's IP address
                                   UserName NVARCHAR(255), -- User's name
                                   FOREIGN KEY (RuleId) REFERENCES TBP_OMKRules(Id) ON DELETE SET NULL,
                                   FOREIGN KEY (MappingId) REFERENCES TBP_OMKMappings(Id) ON DELETE SET NULL,
                                   CONSTRAINT UQ_Mapping_Rule UNIQUE (RuleId, MappingId) -- Ensure uniqueness for each File-Parameter pair
);

-- Table: Logs
CREATE TABLE TB_OMKLogs (
                                   Id UNIQUEIDENTIFIER PRIMARY KEY, -- Unique identifier
                                   Level NVARCHAR(50) NOT NULL, -- Log level (Info, Error, Debug)
                                   Category NVARCHAR(100) NOT NULL, -- Category (e.g., System, Application)
                                   Message NVARCHAR(MAX) NOT NULL, -- Log message
                                   CorrelationId UNIQUEIDENTIFIER  NOT NULL, -- Identifier for traceability
                                   LastUpdated DATETIME DEFAULT GETDATE(), -- Log timestamp
                                   UserIp NVARCHAR(50), -- User's IP address
                                   UserName NVARCHAR(255) -- User's name
    -- Examples of logs:
    -- Info: "File processing started for file ID: [ID]"
    -- Debug: "Mapping transformation applied for field: [FieldName]"
    -- Error: "Validation failed for rule: [RuleName], Condition: [ConditionDetails]"
);
CREATE INDEX idx_logs_timestamp ON TB_OMKLogs(LastUpdated);
CREATE INDEX idx_logs_correlation ON TB_OMKLogs(CorrelationId);

-- Table: Processed Files
CREATE TABLE TB_OMKFileProcessing (
                                   Id UNIQUEIDENTIFIER PRIMARY KEY, -- Unique identifier
                                   FileConfigurationId UNIQUEIDENTIFIER NOT NULL, -- Reference to file configuration
                                   InputFilePath NVARCHAR(MAX) NOT NULL, -- Full path of the input file
                                   OutputFilePath NVARCHAR(MAX) NOT NULL, -- Full path of the output file
                                   Status NVARCHAR(50) DEFAULT 'Pending', -- Processing status
                                   WorkFlowStatus NVARCHAR(100) NOT NULL, -- Reference to a standardized workflow status
                                   RecordCount INT CHECK (RecordCount >= 0), -- Number of records in the file
                                   FileSize BIGINT CHECK (FileSize >= 0), -- File size in bytes
                                   LastError NVARCHAR(MAX), -- Last encountered error
                                   CorrelationId UNIQUEIDENTIFIER NOT NULL, -- Identifier for traceability
                                   StartedAt DATETIME NOT NULL DEFAULT GETDATE(), -- Processing start date
                                   ProcessedAt DATETIME NULL, -- Processing end date
                                   LastUpdated DATETIME DEFAULT GETDATE(), -- Last update date
                                   UserIp NVARCHAR(50), -- User's IP address
                                   UserName NVARCHAR(255), -- User's name
                                   FOREIGN KEY (FileConfigurationId) REFERENCES TBP_OMKFileConfigurations(Id) ON DELETE CASCADE
);
CREATE INDEX idx_fileprocessing_status ON TB_OMKFileProcessing(Status);
CREATE INDEX idx_fileprocessing_workflowstatusid ON TB_OMKFileProcessing(WorkFlowStatus);