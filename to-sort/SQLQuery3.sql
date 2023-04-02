use master
go 
SELECT 'DROP TABLE [' + SCHEMA_NAME(schema_id) + '].[' + name + '];'
FROM sys.tables;
