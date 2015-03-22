---------------------------------------------------------------------
--
-- Update Person Activity
--
-- Version 1.1, 1/2/2014 - Daniel Hazelbaker @ High Desert Church
-- Updated SQL Sproc to only work with people records that have existed
-- for at-least 14 days, makes merging new records much easier.
--
-- Version 1.0, 12/13/2013 - Daniel Hazelbaker @ High Desert Church
--
---------------------------------------------------------------------

DECLARE @AdminPersonID INT

SET @AdminPersonID = 1 -- Change this is your Admin user is not person_id 1



--
-- Create the Attendance Overview attribute group
--
IF NOT EXISTS (SELECT * FROM core_attribute_group WHERE [guid] = '15736785-0471-41DA-A805-B30B1D8942C4')
BEGIN
	INSERT INTO core_attribute_group
		([guid]
		,date_created
		,date_modified
		,created_by
		,modified_by
		,organization_id
		,system_flag
		,group_name
		,group_order
		,display_location
		)
		VALUES
		('15736785-0471-41DA-A805-B30B1D8942C4'
		,GETDATE()
		,GETDATE()
		,'Installer'
		,'Installer'
		,1
		,0
		,'Attendance Overview'
		,-1
		,7
		)

	INSERT INTO list_available_attribute_group
		([group_name]
		,[attribute_group_id]
		,[report_type_id]
		,[organization_id]
		)
		VALUES
		('Attendance Overview'
		,(SELECT attribute_group_id FROM core_attribute_group WHERE [guid] = '15736785-0471-41DA-A805-B30B1D8942C4')
		,1
		,1
		)

	INSERT INTO secu_permission
		([date_created], [date_modified], [created_by], [modified_by]
		,[object_type], [object_key]
		,[subject_type], [subject_key], [operation_type], [template_id], [organization_id]
		)
		VALUES
		(GETDATE(), GETDATE(), 'Installer', 'Installer'
		,5, (SELECT attribute_group_id FROM core_attribute_group WHERE [guid] = '15736785-0471-41DA-A805-B30B1D8942C4')
		,1, @AdminPersonID, 0, NULL, 1
		)
	INSERT INTO secu_permission
		([date_created], [date_modified], [created_by], [modified_by]
		,[object_type], [object_key]
		,[subject_type], [subject_key], [operation_type], [template_id], [organization_id]
		)
		VALUES
		(GETDATE(), GETDATE(), 'Installer', 'Installer'
		,5, (SELECT attribute_group_id FROM core_attribute_group WHERE [guid] = '15736785-0471-41DA-A805-B30B1D8942C4')
		,1, @AdminPersonID, 1, NULL, 1
		)
	INSERT INTO secu_permission
		([date_created], [date_modified], [created_by], [modified_by]
		,[object_type], [object_key]
		,[subject_type], [subject_key], [operation_type], [template_id], [organization_id]
		)
		VALUES
		(GETDATE(), GETDATE(), 'Installer', 'Installer'
		,5, (SELECT attribute_group_id FROM core_attribute_group WHERE [guid] = '15736785-0471-41DA-A805-B30B1D8942C4')
		,1, @AdminPersonID, 2, NULL, 1
		)
		
END


--
-- Create the Last Attendance attribute
--
IF NOT EXISTS (SELECT * FROM core_attribute WHERE [guid] = '4358D763-8794-4E8F-80B0-7AC7C51224F4')
BEGIN
	INSERT INTO core_attribute
		([guid]
		,[date_created]
		,[date_modified]
		,[created_by]
		,[modified_by]
		,[attribute_group_id]
		,[attribute_name]
		,[attribute_type]
		,[attribute_order]
		,[visible]
		,[required]
		,[type_qualifier]
		,[readonly]
		,[system_flag]
		,[history_enabled]
		,[max_history_entries]
		,[organization_id]
		)
		VALUES
		('4358D763-8794-4E8F-80B0-7AC7C51224F4'
		,GETDATE()
		,GETDATE()
		,'Installer'
		,'Installer'
		,(SELECT attribute_group_id FROM core_attribute_group WHERE [guid] = '15736785-0471-41DA-A805-B30B1D8942C4')
		,'Last Attended'
		,2
		,0
		,1
		,0
		,''
		,1
		,0
		,0
		,0
		,1
		)

	INSERT INTO list_available_attribute
		([attribute_name]
		,[attribute_id]
		,[attribute_group_id]
		,[report_type_id]
		,[organization_id]
		)
		VALUES
		('Last Attended'
		,(SELECT attribute_id FROM core_attribute WHERE [guid] = '4358D763-8794-4E8F-80B0-7AC7C51224F4')
		,(SELECT attribute_group_id FROM core_attribute_group WHERE [guid] = '15736785-0471-41DA-A805-B30B1D8942C4')
		,1
		,1
		)

	INSERT INTO secu_permission
		([date_created], [date_modified], [created_by], [modified_by]
		,[object_type], [object_key]
		,[subject_type], [subject_key], [operation_type], [template_id], [organization_id]
		)
		VALUES
		(GETDATE(), GETDATE(), 'Installer', 'Installer'
		,4, (SELECT attribute_id FROM core_attribute WHERE [guid] = '4358D763-8794-4E8F-80B0-7AC7C51224F4')
		,1, @AdminPersonID, 0, NULL, 1
		)
	INSERT INTO secu_permission
		([date_created], [date_modified], [created_by], [modified_by]
		,[object_type], [object_key]
		,[subject_type], [subject_key], [operation_type], [template_id], [organization_id]
		)
		VALUES
		(GETDATE(), GETDATE(), 'Installer', 'Installer'
		,4, (SELECT attribute_id FROM core_attribute WHERE [guid] = '4358D763-8794-4E8F-80B0-7AC7C51224F4')
		,1, @AdminPersonID, 1, NULL, 1
		)
	INSERT INTO secu_permission
		([date_created], [date_modified], [created_by], [modified_by]
		,[object_type], [object_key]
		,[subject_type], [subject_key], [operation_type], [template_id], [organization_id]
		)
		VALUES
		(GETDATE(), GETDATE(), 'Installer', 'Installer'
		,4, (SELECT attribute_id FROM core_attribute WHERE [guid] = '4358D763-8794-4E8F-80B0-7AC7C51224F4')
		,1, @AdminPersonID, 2, NULL, 1
		)
END


--
-- Create the Last Contribution attribute
--
IF NOT EXISTS (SELECT * FROM core_attribute WHERE [guid] = 'E18C2034-7590-4559-ADD8-B7CCFAB3FA57')
BEGIN
	INSERT INTO core_attribute
		([guid]
		,[date_created]
		,[date_modified]
		,[created_by]
		,[modified_by]
		,[attribute_group_id]
		,[attribute_name]
		,[attribute_type]
		,[attribute_order]
		,[visible]
		,[required]
		,[type_qualifier]
		,[readonly]
		,[system_flag]
		,[history_enabled]
		,[max_history_entries]
		,[organization_id]
		)
		VALUES
		('E18C2034-7590-4559-ADD8-B7CCFAB3FA57'
		,GETDATE()
		,GETDATE()
		,'Installer'
		,'Installer'
		,(SELECT attribute_group_id FROM core_attribute_group WHERE [guid] = '15736785-0471-41DA-A805-B30B1D8942C4')
		,'Last Contribution'
		,2
		,1
		,1
		,0
		,''
		,1
		,0
		,0
		,0
		,1
		)

	INSERT INTO list_available_attribute
		([attribute_name]
		,[attribute_id]
		,[attribute_group_id]
		,[report_type_id]
		,[organization_id]
		)
		VALUES
		('Last Contribution'
		,(SELECT attribute_id FROM core_attribute WHERE [guid] = 'E18C2034-7590-4559-ADD8-B7CCFAB3FA57')
		,(SELECT attribute_group_id FROM core_attribute_group WHERE [guid] = '15736785-0471-41DA-A805-B30B1D8942C4')
		,1
		,1
		)

	INSERT INTO secu_permission
		([date_created], [date_modified], [created_by], [modified_by]
		,[object_type], [object_key]
		,[subject_type], [subject_key], [operation_type], [template_id], [organization_id]
		)
		VALUES
		(GETDATE(), GETDATE(), 'Installer', 'Installer'
		,4, (SELECT attribute_id FROM core_attribute WHERE [guid] = 'E18C2034-7590-4559-ADD8-B7CCFAB3FA57')
		,1, @AdminPersonID, 0, NULL, 1
		)
	INSERT INTO secu_permission
		([date_created], [date_modified], [created_by], [modified_by]
		,[object_type], [object_key]
		,[subject_type], [subject_key], [operation_type], [template_id], [organization_id]
		)
		VALUES
		(GETDATE(), GETDATE(), 'Installer', 'Installer'
		,4, (SELECT attribute_id FROM core_attribute WHERE [guid] = 'E18C2034-7590-4559-ADD8-B7CCFAB3FA57')
		,1, @AdminPersonID, 1, NULL, 1
		)
	INSERT INTO secu_permission
		([date_created], [date_modified], [created_by], [modified_by]
		,[object_type], [object_key]
		,[subject_type], [subject_key], [operation_type], [template_id], [organization_id]
		)
		VALUES
		(GETDATE(), GETDATE(), 'Installer', 'Installer'
		,4, (SELECT attribute_id FROM core_attribute WHERE [guid] = 'E18C2034-7590-4559-ADD8-B7CCFAB3FA57')
		,1, @AdminPersonID, 2, NULL, 1
		)
END


--
-- Create the Attendance Last 3 Months attribute
--
IF NOT EXISTS (SELECT * FROM core_attribute WHERE [guid] = 'F70AFD2D-2F09-450C-9082-D514088730AE')
BEGIN
	INSERT INTO core_attribute
		([guid]
		,[date_created]
		,[date_modified]
		,[created_by]
		,[modified_by]
		,[attribute_group_id]
		,[attribute_name]
		,[attribute_type]
		,[attribute_order]
		,[visible]
		,[required]
		,[type_qualifier]
		,[readonly]
		,[system_flag]
		,[history_enabled]
		,[max_history_entries]
		,[organization_id]
		)
		VALUES
		('F70AFD2D-2F09-450C-9082-D514088730AE'
		,GETDATE()
		,GETDATE()
		,'Installer'
		,'Installer'
		,(SELECT attribute_group_id FROM core_attribute_group WHERE [guid] = '15736785-0471-41DA-A805-B30B1D8942C4')
		,'Attendance Last 3 Months'
		,0
		,2
		,1
		,0
		,''
		,1
		,0
		,0
		,0
		,1
		)

	INSERT INTO list_available_attribute
		([attribute_name]
		,[attribute_id]
		,[attribute_group_id]
		,[report_type_id]
		,[organization_id]
		)
		VALUES
		('Attendance Last 3 Months'
		,(SELECT attribute_id FROM core_attribute WHERE [guid] = 'F70AFD2D-2F09-450C-9082-D514088730AE')
		,(SELECT attribute_group_id FROM core_attribute_group WHERE [guid] = '15736785-0471-41DA-A805-B30B1D8942C4')
		,1
		,1
		)

	INSERT INTO secu_permission
		([date_created], [date_modified], [created_by], [modified_by]
		,[object_type], [object_key]
		,[subject_type], [subject_key], [operation_type], [template_id], [organization_id]
		)
		VALUES
		(GETDATE(), GETDATE(), 'Installer', 'Installer'
		,4, (SELECT attribute_id FROM core_attribute WHERE [guid] = 'F70AFD2D-2F09-450C-9082-D514088730AE')
		,1, @AdminPersonID, 0, NULL, 1
		)
	INSERT INTO secu_permission
		([date_created], [date_modified], [created_by], [modified_by]
		,[object_type], [object_key]
		,[subject_type], [subject_key], [operation_type], [template_id], [organization_id]
		)
		VALUES
		(GETDATE(), GETDATE(), 'Installer', 'Installer'
		,4, (SELECT attribute_id FROM core_attribute WHERE [guid] = 'F70AFD2D-2F09-450C-9082-D514088730AE')
		,1, @AdminPersonID, 1, NULL, 1
		)
	INSERT INTO secu_permission
		([date_created], [date_modified], [created_by], [modified_by]
		,[object_type], [object_key]
		,[subject_type], [subject_key], [operation_type], [template_id], [organization_id]
		)
		VALUES
		(GETDATE(), GETDATE(), 'Installer', 'Installer'
		,4, (SELECT attribute_id FROM core_attribute WHERE [guid] = 'F70AFD2D-2F09-450C-9082-D514088730AE')
		,1, @AdminPersonID, 2, NULL, 1
		)
END


--
-- Create the Attendance Last 6 Months attribute
--
IF NOT EXISTS (SELECT * FROM core_attribute WHERE [guid] = '1D5CCB7F-D346-439B-9DB7-7F2E84E117CF')
BEGIN
	INSERT INTO core_attribute
		([guid]
		,[date_created]
		,[date_modified]
		,[created_by]
		,[modified_by]
		,[attribute_group_id]
		,[attribute_name]
		,[attribute_type]
		,[attribute_order]
		,[visible]
		,[required]
		,[type_qualifier]
		,[readonly]
		,[system_flag]
		,[history_enabled]
		,[max_history_entries]
		,[organization_id]
		)
		VALUES
		('1D5CCB7F-D346-439B-9DB7-7F2E84E117CF'
		,GETDATE()
		,GETDATE()
		,'Installer'
		,'Installer'
		,(SELECT attribute_group_id FROM core_attribute_group WHERE [guid] = '15736785-0471-41DA-A805-B30B1D8942C4')
		,'Attendance Last 6 Months'
		,0
		,3
		,1
		,0
		,''
		,1
		,0
		,0
		,0
		,1
		)

	INSERT INTO list_available_attribute
		([attribute_name]
		,[attribute_id]
		,[attribute_group_id]
		,[report_type_id]
		,[organization_id]
		)
		VALUES
		('Attendance Last 6 Months'
		,(SELECT attribute_id FROM core_attribute WHERE [guid] = '1D5CCB7F-D346-439B-9DB7-7F2E84E117CF')
		,(SELECT attribute_group_id FROM core_attribute_group WHERE [guid] = '15736785-0471-41DA-A805-B30B1D8942C4')
		,1
		,1
		)

	INSERT INTO secu_permission
		([date_created], [date_modified], [created_by], [modified_by]
		,[object_type], [object_key]
		,[subject_type], [subject_key], [operation_type], [template_id], [organization_id]
		)
		VALUES
		(GETDATE(), GETDATE(), 'Installer', 'Installer'
		,4, (SELECT attribute_id FROM core_attribute WHERE [guid] = '1D5CCB7F-D346-439B-9DB7-7F2E84E117CF')
		,1, @AdminPersonID, 0, NULL, 1
		)
	INSERT INTO secu_permission
		([date_created], [date_modified], [created_by], [modified_by]
		,[object_type], [object_key]
		,[subject_type], [subject_key], [operation_type], [template_id], [organization_id]
		)
		VALUES
		(GETDATE(), GETDATE(), 'Installer', 'Installer'
		,4, (SELECT attribute_id FROM core_attribute WHERE [guid] = '1D5CCB7F-D346-439B-9DB7-7F2E84E117CF')
		,1, @AdminPersonID, 1, NULL, 1
		)
	INSERT INTO secu_permission
		([date_created], [date_modified], [created_by], [modified_by]
		,[object_type], [object_key]
		,[subject_type], [subject_key], [operation_type], [template_id], [organization_id]
		)
		VALUES
		(GETDATE(), GETDATE(), 'Installer', 'Installer'
		,4, (SELECT attribute_id FROM core_attribute WHERE [guid] = '1D5CCB7F-D346-439B-9DB7-7F2E84E117CF')
		,1, @AdminPersonID, 2, NULL, 1
		)
END


--
-- Create the Attendance Last 12 Months attribute
--
IF NOT EXISTS (SELECT * FROM core_attribute WHERE [guid] = '209811F7-44F2-4A9D-977E-FF96A700C928')
BEGIN
	INSERT INTO core_attribute
		([guid]
		,[date_created]
		,[date_modified]
		,[created_by]
		,[modified_by]
		,[attribute_group_id]
		,[attribute_name]
		,[attribute_type]
		,[attribute_order]
		,[visible]
		,[required]
		,[type_qualifier]
		,[readonly]
		,[system_flag]
		,[history_enabled]
		,[max_history_entries]
		,[organization_id]
		)
		VALUES
		('209811F7-44F2-4A9D-977E-FF96A700C928'
		,GETDATE()
		,GETDATE()
		,'Installer'
		,'Installer'
		,(SELECT attribute_group_id FROM core_attribute_group WHERE [guid] = '15736785-0471-41DA-A805-B30B1D8942C4')
		,'Attendance Last 12 Months'
		,0
		,4
		,1
		,0
		,''
		,1
		,0
		,0
		,0
		,1
		)

	INSERT INTO list_available_attribute
		([attribute_name]
		,[attribute_id]
		,[attribute_group_id]
		,[report_type_id]
		,[organization_id]
		)
		VALUES
		('Attendance Last 12 Months'
		,(SELECT attribute_id FROM core_attribute WHERE [guid] = '209811F7-44F2-4A9D-977E-FF96A700C928')
		,(SELECT attribute_group_id FROM core_attribute_group WHERE [guid] = '15736785-0471-41DA-A805-B30B1D8942C4')
		,1
		,1
		)

	INSERT INTO secu_permission
		([date_created], [date_modified], [created_by], [modified_by]
		,[object_type], [object_key]
		,[subject_type], [subject_key], [operation_type], [template_id], [organization_id]
		)
		VALUES
		(GETDATE(), GETDATE(), 'Installer', 'Installer'
		,4, (SELECT attribute_id FROM core_attribute WHERE [guid] = '209811F7-44F2-4A9D-977E-FF96A700C928')
		,1, @AdminPersonID, 0, NULL, 1
		)
	INSERT INTO secu_permission
		([date_created], [date_modified], [created_by], [modified_by]
		,[object_type], [object_key]
		,[subject_type], [subject_key], [operation_type], [template_id], [organization_id]
		)
		VALUES
		(GETDATE(), GETDATE(), 'Installer', 'Installer'
		,4, (SELECT attribute_id FROM core_attribute WHERE [guid] = '209811F7-44F2-4A9D-977E-FF96A700C928')
		,1, @AdminPersonID, 1, NULL, 1
		)
	INSERT INTO secu_permission
		([date_created], [date_modified], [created_by], [modified_by]
		,[object_type], [object_key]
		,[subject_type], [subject_key], [operation_type], [template_id], [organization_id]
		)
		VALUES
		(GETDATE(), GETDATE(), 'Installer', 'Installer'
		,4, (SELECT attribute_id FROM core_attribute WHERE [guid] = '209811F7-44F2-4A9D-977E-FF96A700C928')
		,1, @AdminPersonID, 2, NULL, 1
		)
END


--
-- Create the Contributions Last 3 Months attribute
--
IF NOT EXISTS (SELECT * FROM core_attribute WHERE [guid] = '3B16D6E8-45B2-4210-B22B-9F2FCDA8B44C')
BEGIN
	INSERT INTO core_attribute
		([guid]
		,[date_created]
		,[date_modified]
		,[created_by]
		,[modified_by]
		,[attribute_group_id]
		,[attribute_name]
		,[attribute_type]
		,[attribute_order]
		,[visible]
		,[required]
		,[type_qualifier]
		,[readonly]
		,[system_flag]
		,[history_enabled]
		,[max_history_entries]
		,[organization_id]
		)
		VALUES
		('3B16D6E8-45B2-4210-B22B-9F2FCDA8B44C'
		,GETDATE()
		,GETDATE()
		,'Installer'
		,'Installer'
		,(SELECT attribute_group_id FROM core_attribute_group WHERE [guid] = '15736785-0471-41DA-A805-B30B1D8942C4')
		,'Contributions Last 3 Months'
		,0
		,5
		,1
		,0
		,''
		,1
		,0
		,0
		,0
		,1
		)

	INSERT INTO list_available_attribute
		([attribute_name]
		,[attribute_id]
		,[attribute_group_id]
		,[report_type_id]
		,[organization_id]
		)
		VALUES
		('Contributions Last 3 Months'
		,(SELECT attribute_id FROM core_attribute WHERE [guid] = '3B16D6E8-45B2-4210-B22B-9F2FCDA8B44C')
		,(SELECT attribute_group_id FROM core_attribute_group WHERE [guid] = '15736785-0471-41DA-A805-B30B1D8942C4')
		,1
		,1
		)

	INSERT INTO secu_permission
		([date_created], [date_modified], [created_by], [modified_by]
		,[object_type], [object_key]
		,[subject_type], [subject_key], [operation_type], [template_id], [organization_id]
		)
		VALUES
		(GETDATE(), GETDATE(), 'Installer', 'Installer'
		,4, (SELECT attribute_id FROM core_attribute WHERE [guid] = '3B16D6E8-45B2-4210-B22B-9F2FCDA8B44C')
		,1, @AdminPersonID, 0, NULL, 1
		)
	INSERT INTO secu_permission
		([date_created], [date_modified], [created_by], [modified_by]
		,[object_type], [object_key]
		,[subject_type], [subject_key], [operation_type], [template_id], [organization_id]
		)
		VALUES
		(GETDATE(), GETDATE(), 'Installer', 'Installer'
		,4, (SELECT attribute_id FROM core_attribute WHERE [guid] = '3B16D6E8-45B2-4210-B22B-9F2FCDA8B44C')
		,1, @AdminPersonID, 1, NULL, 1
		)
	INSERT INTO secu_permission
		([date_created], [date_modified], [created_by], [modified_by]
		,[object_type], [object_key]
		,[subject_type], [subject_key], [operation_type], [template_id], [organization_id]
		)
		VALUES
		(GETDATE(), GETDATE(), 'Installer', 'Installer'
		,4, (SELECT attribute_id FROM core_attribute WHERE [guid] = '3B16D6E8-45B2-4210-B22B-9F2FCDA8B44C')
		,1, @AdminPersonID, 2, NULL, 1
		)
END


--
-- Create the Contributions Last 6 Months attribute
--
IF NOT EXISTS (SELECT * FROM core_attribute WHERE [guid] = 'CA8DCB9B-07EC-4E40-A915-834C2D648419')
BEGIN
	INSERT INTO core_attribute
		([guid]
		,[date_created]
		,[date_modified]
		,[created_by]
		,[modified_by]
		,[attribute_group_id]
		,[attribute_name]
		,[attribute_type]
		,[attribute_order]
		,[visible]
		,[required]
		,[type_qualifier]
		,[readonly]
		,[system_flag]
		,[history_enabled]
		,[max_history_entries]
		,[organization_id]
		)
		VALUES
		('CA8DCB9B-07EC-4E40-A915-834C2D648419'
		,GETDATE()
		,GETDATE()
		,'Installer'
		,'Installer'
		,(SELECT attribute_group_id FROM core_attribute_group WHERE [guid] = '15736785-0471-41DA-A805-B30B1D8942C4')
		,'Contributions Last 6 Months'
		,0
		,6
		,1
		,0
		,''
		,1
		,0
		,0
		,0
		,1
		)

	INSERT INTO list_available_attribute
		([attribute_name]
		,[attribute_id]
		,[attribute_group_id]
		,[report_type_id]
		,[organization_id]
		)
		VALUES
		('Contributions Last 6 Months'
		,(SELECT attribute_id FROM core_attribute WHERE [guid] = 'CA8DCB9B-07EC-4E40-A915-834C2D648419')
		,(SELECT attribute_group_id FROM core_attribute_group WHERE [guid] = '15736785-0471-41DA-A805-B30B1D8942C4')
		,1
		,1
		)

	INSERT INTO secu_permission
		([date_created], [date_modified], [created_by], [modified_by]
		,[object_type], [object_key]
		,[subject_type], [subject_key], [operation_type], [template_id], [organization_id]
		)
		VALUES
		(GETDATE(), GETDATE(), 'Installer', 'Installer'
		,4, (SELECT attribute_id FROM core_attribute WHERE [guid] = 'CA8DCB9B-07EC-4E40-A915-834C2D648419')
		,1, @AdminPersonID, 0, NULL, 1
		)
	INSERT INTO secu_permission
		([date_created], [date_modified], [created_by], [modified_by]
		,[object_type], [object_key]
		,[subject_type], [subject_key], [operation_type], [template_id], [organization_id]
		)
		VALUES
		(GETDATE(), GETDATE(), 'Installer', 'Installer'
		,4, (SELECT attribute_id FROM core_attribute WHERE [guid] = 'CA8DCB9B-07EC-4E40-A915-834C2D648419')
		,1, @AdminPersonID, 1, NULL, 1
		)
	INSERT INTO secu_permission
		([date_created], [date_modified], [created_by], [modified_by]
		,[object_type], [object_key]
		,[subject_type], [subject_key], [operation_type], [template_id], [organization_id]
		)
		VALUES
		(GETDATE(), GETDATE(), 'Installer', 'Installer'
		,4, (SELECT attribute_id FROM core_attribute WHERE [guid] = 'CA8DCB9B-07EC-4E40-A915-834C2D648419')
		,1, @AdminPersonID, 2, NULL, 1
		)
END


--
-- Create the Contributions Last 12 Months attribute
--
IF NOT EXISTS (SELECT * FROM core_attribute WHERE [guid] = '9100CC24-DF6F-4F25-9E15-22270504E395')
BEGIN
	INSERT INTO core_attribute
		([guid]
		,[date_created]
		,[date_modified]
		,[created_by]
		,[modified_by]
		,[attribute_group_id]
		,[attribute_name]
		,[attribute_type]
		,[attribute_order]
		,[visible]
		,[required]
		,[type_qualifier]
		,[readonly]
		,[system_flag]
		,[history_enabled]
		,[max_history_entries]
		,[organization_id]
		)
		VALUES
		('9100CC24-DF6F-4F25-9E15-22270504E395'
		,GETDATE()
		,GETDATE()
		,'Installer'
		,'Installer'
		,(SELECT attribute_group_id FROM core_attribute_group WHERE [guid] = '15736785-0471-41DA-A805-B30B1D8942C4')
		,'Contributions Last 12 Months'
		,0
		,7
		,1
		,0
		,''
		,1
		,0
		,0
		,0
		,1
		)

	INSERT INTO list_available_attribute
		([attribute_name]
		,[attribute_id]
		,[attribute_group_id]
		,[report_type_id]
		,[organization_id]
		)
		VALUES
		('Contributions Last 12 Months'
		,(SELECT attribute_id FROM core_attribute WHERE [guid] = '9100CC24-DF6F-4F25-9E15-22270504E395')
		,(SELECT attribute_group_id FROM core_attribute_group WHERE [guid] = '15736785-0471-41DA-A805-B30B1D8942C4')
		,1
		,1
		)

	INSERT INTO secu_permission
		([date_created], [date_modified], [created_by], [modified_by]
		,[object_type], [object_key]
		,[subject_type], [subject_key], [operation_type], [template_id], [organization_id]
		)
		VALUES
		(GETDATE(), GETDATE(), 'Installer', 'Installer'
		,4, (SELECT attribute_id FROM core_attribute WHERE [guid] = '9100CC24-DF6F-4F25-9E15-22270504E395')
		,1, @AdminPersonID, 0, NULL, 1
		)
	INSERT INTO secu_permission
		([date_created], [date_modified], [created_by], [modified_by]
		,[object_type], [object_key]
		,[subject_type], [subject_key], [operation_type], [template_id], [organization_id]
		)
		VALUES
		(GETDATE(), GETDATE(), 'Installer', 'Installer'
		,4, (SELECT attribute_id FROM core_attribute WHERE [guid] = '9100CC24-DF6F-4F25-9E15-22270504E395')
		,1, @AdminPersonID, 1, NULL, 1
		)
	INSERT INTO secu_permission
		([date_created], [date_modified], [created_by], [modified_by]
		,[object_type], [object_key]
		,[subject_type], [subject_key], [operation_type], [template_id], [organization_id]
		)
		VALUES
		(GETDATE(), GETDATE(), 'Installer', 'Installer'
		,4, (SELECT attribute_id FROM core_attribute WHERE [guid] = '9100CC24-DF6F-4F25-9E15-22270504E395')
		,1, @AdminPersonID, 2, NULL, 1
		)
END


--
-- Create the Family Last Attended attribute
--
IF NOT EXISTS (SELECT * FROM core_attribute WHERE [guid] = 'B217F574-1059-445B-B394-D4A72AA2730A')
BEGIN
	INSERT INTO core_attribute
		([guid]
		,[date_created]
		,[date_modified]
		,[created_by]
		,[modified_by]
		,[attribute_group_id]
		,[attribute_name]
		,[attribute_type]
		,[attribute_order]
		,[visible]
		,[required]
		,[type_qualifier]
		,[readonly]
		,[system_flag]
		,[history_enabled]
		,[max_history_entries]
		,[organization_id]
		)
		VALUES
		('B217F574-1059-445B-B394-D4A72AA2730A'
		,GETDATE()
		,GETDATE()
		,'Installer'
		,'Installer'
		,(SELECT attribute_group_id FROM core_attribute_group WHERE [guid] = '15736785-0471-41DA-A805-B30B1D8942C4')
		,'Family Last Attended'
		,2
		,8
		,1
		,0
		,''
		,1
		,0
		,0
		,0
		,1
		)

	INSERT INTO list_available_attribute
		([attribute_name]
		,[attribute_id]
		,[attribute_group_id]
		,[report_type_id]
		,[organization_id]
		)
		VALUES
		('Family Last Attended'
		,(SELECT attribute_id FROM core_attribute WHERE [guid] = 'B217F574-1059-445B-B394-D4A72AA2730A')
		,(SELECT attribute_group_id FROM core_attribute_group WHERE [guid] = '15736785-0471-41DA-A805-B30B1D8942C4')
		,1
		,1
		)

	INSERT INTO secu_permission
		([date_created], [date_modified], [created_by], [modified_by]
		,[object_type], [object_key]
		,[subject_type], [subject_key], [operation_type], [template_id], [organization_id]
		)
		VALUES
		(GETDATE(), GETDATE(), 'Installer', 'Installer'
		,4, (SELECT attribute_id FROM core_attribute WHERE [guid] = 'B217F574-1059-445B-B394-D4A72AA2730A')
		,1, @AdminPersonID, 0, NULL, 1
		)
	INSERT INTO secu_permission
		([date_created], [date_modified], [created_by], [modified_by]
		,[object_type], [object_key]
		,[subject_type], [subject_key], [operation_type], [template_id], [organization_id]
		)
		VALUES
		(GETDATE(), GETDATE(), 'Installer', 'Installer'
		,4, (SELECT attribute_id FROM core_attribute WHERE [guid] = 'B217F574-1059-445B-B394-D4A72AA2730A')
		,1, @AdminPersonID, 1, NULL, 1
		)
	INSERT INTO secu_permission
		([date_created], [date_modified], [created_by], [modified_by]
		,[object_type], [object_key]
		,[subject_type], [subject_key], [operation_type], [template_id], [organization_id]
		)
		VALUES
		(GETDATE(), GETDATE(), 'Installer', 'Installer'
		,4, (SELECT attribute_id FROM core_attribute WHERE [guid] = 'B217F574-1059-445B-B394-D4A72AA2730A')
		,1, @AdminPersonID, 2, NULL, 1
		)
END


--
-- Create the Family Last Contribution attribute
--
IF NOT EXISTS (SELECT * FROM core_attribute WHERE [guid] = '1A5BF310-E810-4E75-AD46-44DD58850E19')
BEGIN
	INSERT INTO core_attribute
		([guid]
		,[date_created]
		,[date_modified]
		,[created_by]
		,[modified_by]
		,[attribute_group_id]
		,[attribute_name]
		,[attribute_type]
		,[attribute_order]
		,[visible]
		,[required]
		,[type_qualifier]
		,[readonly]
		,[system_flag]
		,[history_enabled]
		,[max_history_entries]
		,[organization_id]
		)
		VALUES
		('1A5BF310-E810-4E75-AD46-44DD58850E19'
		,GETDATE()
		,GETDATE()
		,'Installer'
		,'Installer'
		,(SELECT attribute_group_id FROM core_attribute_group WHERE [guid] = '15736785-0471-41DA-A805-B30B1D8942C4')
		,'Family Last Contribution'
		,2
		,9
		,1
		,0
		,''
		,1
		,0
		,0
		,0
		,1
		)

	INSERT INTO list_available_attribute
		([attribute_name]
		,[attribute_id]
		,[attribute_group_id]
		,[report_type_id]
		,[organization_id]
		)
		VALUES
		('Family Last Contribution'
		,(SELECT attribute_id FROM core_attribute WHERE [guid] = '1A5BF310-E810-4E75-AD46-44DD58850E19')
		,(SELECT attribute_group_id FROM core_attribute_group WHERE [guid] = '15736785-0471-41DA-A805-B30B1D8942C4')
		,1
		,1
		)

	INSERT INTO secu_permission
		([date_created], [date_modified], [created_by], [modified_by]
		,[object_type], [object_key]
		,[subject_type], [subject_key], [operation_type], [template_id], [organization_id]
		)
		VALUES
		(GETDATE(), GETDATE(), 'Installer', 'Installer'
		,4, (SELECT attribute_id FROM core_attribute WHERE [guid] = '1A5BF310-E810-4E75-AD46-44DD58850E19')
		,1, @AdminPersonID, 0, NULL, 1
		)
	INSERT INTO secu_permission
		([date_created], [date_modified], [created_by], [modified_by]
		,[object_type], [object_key]
		,[subject_type], [subject_key], [operation_type], [template_id], [organization_id]
		)
		VALUES
		(GETDATE(), GETDATE(), 'Installer', 'Installer'
		,4, (SELECT attribute_id FROM core_attribute WHERE [guid] = '1A5BF310-E810-4E75-AD46-44DD58850E19')
		,1, @AdminPersonID, 1, NULL, 1
		)
	INSERT INTO secu_permission
		([date_created], [date_modified], [created_by], [modified_by]
		,[object_type], [object_key]
		,[subject_type], [subject_key], [operation_type], [template_id], [organization_id]
		)
		VALUES
		(GETDATE(), GETDATE(), 'Installer', 'Installer'
		,4, (SELECT attribute_id FROM core_attribute WHERE [guid] = '1A5BF310-E810-4E75-AD46-44DD58850E19')
		,1, @AdminPersonID, 2, NULL, 1
		)
END


--
-- Create the Family Attendance Last 3 Months attribute
--
IF NOT EXISTS (SELECT * FROM core_attribute WHERE [guid] = '59C7C09E-EACE-4F62-B599-FDD4A014863F')
BEGIN
	INSERT INTO core_attribute
		([guid]
		,[date_created]
		,[date_modified]
		,[created_by]
		,[modified_by]
		,[attribute_group_id]
		,[attribute_name]
		,[attribute_type]
		,[attribute_order]
		,[visible]
		,[required]
		,[type_qualifier]
		,[readonly]
		,[system_flag]
		,[history_enabled]
		,[max_history_entries]
		,[organization_id]
		)
		VALUES
		('59C7C09E-EACE-4F62-B599-FDD4A014863F'
		,GETDATE()
		,GETDATE()
		,'Installer'
		,'Installer'
		,(SELECT attribute_group_id FROM core_attribute_group WHERE [guid] = '15736785-0471-41DA-A805-B30B1D8942C4')
		,'Family Attendance Last 3 Months'
		,0
		,10
		,1
		,0
		,''
		,1
		,0
		,0
		,0
		,1
		)

	INSERT INTO list_available_attribute
		([attribute_name]
		,[attribute_id]
		,[attribute_group_id]
		,[report_type_id]
		,[organization_id]
		)
		VALUES
		('Family Attendance Last 3 Months'
		,(SELECT attribute_id FROM core_attribute WHERE [guid] = '59C7C09E-EACE-4F62-B599-FDD4A014863F')
		,(SELECT attribute_group_id FROM core_attribute_group WHERE [guid] = '15736785-0471-41DA-A805-B30B1D8942C4')
		,1
		,1
		)

	INSERT INTO secu_permission
		([date_created], [date_modified], [created_by], [modified_by]
		,[object_type], [object_key]
		,[subject_type], [subject_key], [operation_type], [template_id], [organization_id]
		)
		VALUES
		(GETDATE(), GETDATE(), 'Installer', 'Installer'
		,4, (SELECT attribute_id FROM core_attribute WHERE [guid] = '59C7C09E-EACE-4F62-B599-FDD4A014863F')
		,1, @AdminPersonID, 0, NULL, 1
		)
	INSERT INTO secu_permission
		([date_created], [date_modified], [created_by], [modified_by]
		,[object_type], [object_key]
		,[subject_type], [subject_key], [operation_type], [template_id], [organization_id]
		)
		VALUES
		(GETDATE(), GETDATE(), 'Installer', 'Installer'
		,4, (SELECT attribute_id FROM core_attribute WHERE [guid] = '59C7C09E-EACE-4F62-B599-FDD4A014863F')
		,1, @AdminPersonID, 1, NULL, 1
		)
	INSERT INTO secu_permission
		([date_created], [date_modified], [created_by], [modified_by]
		,[object_type], [object_key]
		,[subject_type], [subject_key], [operation_type], [template_id], [organization_id]
		)
		VALUES
		(GETDATE(), GETDATE(), 'Installer', 'Installer'
		,4, (SELECT attribute_id FROM core_attribute WHERE [guid] = '59C7C09E-EACE-4F62-B599-FDD4A014863F')
		,1, @AdminPersonID, 2, NULL, 1
		)
END


--
-- Create the Family Attendance Last 6 Months attribute
--
IF NOT EXISTS (SELECT * FROM core_attribute WHERE [guid] = '24F11773-295E-4F92-931C-5CACDA6415FA')
BEGIN
	INSERT INTO core_attribute
		([guid]
		,[date_created]
		,[date_modified]
		,[created_by]
		,[modified_by]
		,[attribute_group_id]
		,[attribute_name]
		,[attribute_type]
		,[attribute_order]
		,[visible]
		,[required]
		,[type_qualifier]
		,[readonly]
		,[system_flag]
		,[history_enabled]
		,[max_history_entries]
		,[organization_id]
		)
		VALUES
		('24F11773-295E-4F92-931C-5CACDA6415FA'
		,GETDATE()
		,GETDATE()
		,'Installer'
		,'Installer'
		,(SELECT attribute_group_id FROM core_attribute_group WHERE [guid] = '15736785-0471-41DA-A805-B30B1D8942C4')
		,'Family Attendance Last 6 Months'
		,0
		,11
		,1
		,0
		,''
		,1
		,0
		,0
		,0
		,1
		)

	INSERT INTO list_available_attribute
		([attribute_name]
		,[attribute_id]
		,[attribute_group_id]
		,[report_type_id]
		,[organization_id]
		)
		VALUES
		('Family Attendance Last 6 Months'
		,(SELECT attribute_id FROM core_attribute WHERE [guid] = '24F11773-295E-4F92-931C-5CACDA6415FA')
		,(SELECT attribute_group_id FROM core_attribute_group WHERE [guid] = '15736785-0471-41DA-A805-B30B1D8942C4')
		,1
		,1
		)

	INSERT INTO secu_permission
		([date_created], [date_modified], [created_by], [modified_by]
		,[object_type], [object_key]
		,[subject_type], [subject_key], [operation_type], [template_id], [organization_id]
		)
		VALUES
		(GETDATE(), GETDATE(), 'Installer', 'Installer'
		,4, (SELECT attribute_id FROM core_attribute WHERE [guid] = '24F11773-295E-4F92-931C-5CACDA6415FA')
		,1, @AdminPersonID, 0, NULL, 1
		)
	INSERT INTO secu_permission
		([date_created], [date_modified], [created_by], [modified_by]
		,[object_type], [object_key]
		,[subject_type], [subject_key], [operation_type], [template_id], [organization_id]
		)
		VALUES
		(GETDATE(), GETDATE(), 'Installer', 'Installer'
		,4, (SELECT attribute_id FROM core_attribute WHERE [guid] = '24F11773-295E-4F92-931C-5CACDA6415FA')
		,1, @AdminPersonID, 1, NULL, 1
		)
	INSERT INTO secu_permission
		([date_created], [date_modified], [created_by], [modified_by]
		,[object_type], [object_key]
		,[subject_type], [subject_key], [operation_type], [template_id], [organization_id]
		)
		VALUES
		(GETDATE(), GETDATE(), 'Installer', 'Installer'
		,4, (SELECT attribute_id FROM core_attribute WHERE [guid] = '24F11773-295E-4F92-931C-5CACDA6415FA')
		,1, @AdminPersonID, 2, NULL, 1
		)
END


--
-- Create the Family Attendance Last 12 Months attribute
--
IF NOT EXISTS (SELECT * FROM core_attribute WHERE [guid] = 'DB9EDD5A-ADEB-41B9-B9DB-0387AC56222E')
BEGIN
	INSERT INTO core_attribute
		([guid]
		,[date_created]
		,[date_modified]
		,[created_by]
		,[modified_by]
		,[attribute_group_id]
		,[attribute_name]
		,[attribute_type]
		,[attribute_order]
		,[visible]
		,[required]
		,[type_qualifier]
		,[readonly]
		,[system_flag]
		,[history_enabled]
		,[max_history_entries]
		,[organization_id]
		)
		VALUES
		('DB9EDD5A-ADEB-41B9-B9DB-0387AC56222E'
		,GETDATE()
		,GETDATE()
		,'Installer'
		,'Installer'
		,(SELECT attribute_group_id FROM core_attribute_group WHERE [guid] = '15736785-0471-41DA-A805-B30B1D8942C4')
		,'Family Attendance Last 12 Months'
		,0
		,12
		,1
		,0
		,''
		,1
		,0
		,0
		,0
		,1
		)

	INSERT INTO list_available_attribute
		([attribute_name]
		,[attribute_id]
		,[attribute_group_id]
		,[report_type_id]
		,[organization_id]
		)
		VALUES
		('Family Attendance Last 12 Months'
		,(SELECT attribute_id FROM core_attribute WHERE [guid] = 'DB9EDD5A-ADEB-41B9-B9DB-0387AC56222E')
		,(SELECT attribute_group_id FROM core_attribute_group WHERE [guid] = '15736785-0471-41DA-A805-B30B1D8942C4')
		,1
		,1
		)

	INSERT INTO secu_permission
		([date_created], [date_modified], [created_by], [modified_by]
		,[object_type], [object_key]
		,[subject_type], [subject_key], [operation_type], [template_id], [organization_id]
		)
		VALUES
		(GETDATE(), GETDATE(), 'Installer', 'Installer'
		,4, (SELECT attribute_id FROM core_attribute WHERE [guid] = 'DB9EDD5A-ADEB-41B9-B9DB-0387AC56222E')
		,1, @AdminPersonID, 0, NULL, 1
		)
	INSERT INTO secu_permission
		([date_created], [date_modified], [created_by], [modified_by]
		,[object_type], [object_key]
		,[subject_type], [subject_key], [operation_type], [template_id], [organization_id]
		)
		VALUES
		(GETDATE(), GETDATE(), 'Installer', 'Installer'
		,4, (SELECT attribute_id FROM core_attribute WHERE [guid] = 'DB9EDD5A-ADEB-41B9-B9DB-0387AC56222E')
		,1, @AdminPersonID, 1, NULL, 1
		)
	INSERT INTO secu_permission
		([date_created], [date_modified], [created_by], [modified_by]
		,[object_type], [object_key]
		,[subject_type], [subject_key], [operation_type], [template_id], [organization_id]
		)
		VALUES
		(GETDATE(), GETDATE(), 'Installer', 'Installer'
		,4, (SELECT attribute_id FROM core_attribute WHERE [guid] = 'DB9EDD5A-ADEB-41B9-B9DB-0387AC56222E')
		,1, @AdminPersonID, 2, NULL, 1
		)
END


--
-- Create the Family Contributions Last 3 Months attribute
--
IF NOT EXISTS (SELECT * FROM core_attribute WHERE [guid] = '0A6732E9-1110-460C-9F15-25566E314449')
BEGIN
	INSERT INTO core_attribute
		([guid]
		,[date_created]
		,[date_modified]
		,[created_by]
		,[modified_by]
		,[attribute_group_id]
		,[attribute_name]
		,[attribute_type]
		,[attribute_order]
		,[visible]
		,[required]
		,[type_qualifier]
		,[readonly]
		,[system_flag]
		,[history_enabled]
		,[max_history_entries]
		,[organization_id]
		)
		VALUES
		('0A6732E9-1110-460C-9F15-25566E314449'
		,GETDATE()
		,GETDATE()
		,'Installer'
		,'Installer'
		,(SELECT attribute_group_id FROM core_attribute_group WHERE [guid] = '15736785-0471-41DA-A805-B30B1D8942C4')
		,'Family Contributions Last 3 Months'
		,0
		,13
		,1
		,0
		,''
		,1
		,0
		,0
		,0
		,1
		)

	INSERT INTO list_available_attribute
		([attribute_name]
		,[attribute_id]
		,[attribute_group_id]
		,[report_type_id]
		,[organization_id]
		)
		VALUES
		('Family Contributions Last 3 Months'
		,(SELECT attribute_id FROM core_attribute WHERE [guid] = '0A6732E9-1110-460C-9F15-25566E314449')
		,(SELECT attribute_group_id FROM core_attribute_group WHERE [guid] = '15736785-0471-41DA-A805-B30B1D8942C4')
		,1
		,1
		)

	INSERT INTO secu_permission
		([date_created], [date_modified], [created_by], [modified_by]
		,[object_type], [object_key]
		,[subject_type], [subject_key], [operation_type], [template_id], [organization_id]
		)
		VALUES
		(GETDATE(), GETDATE(), 'Installer', 'Installer'
		,4, (SELECT attribute_id FROM core_attribute WHERE [guid] = '0A6732E9-1110-460C-9F15-25566E314449')
		,1, @AdminPersonID, 0, NULL, 1
		)
	INSERT INTO secu_permission
		([date_created], [date_modified], [created_by], [modified_by]
		,[object_type], [object_key]
		,[subject_type], [subject_key], [operation_type], [template_id], [organization_id]
		)
		VALUES
		(GETDATE(), GETDATE(), 'Installer', 'Installer'
		,4, (SELECT attribute_id FROM core_attribute WHERE [guid] = '0A6732E9-1110-460C-9F15-25566E314449')
		,1, @AdminPersonID, 1, NULL, 1
		)
	INSERT INTO secu_permission
		([date_created], [date_modified], [created_by], [modified_by]
		,[object_type], [object_key]
		,[subject_type], [subject_key], [operation_type], [template_id], [organization_id]
		)
		VALUES
		(GETDATE(), GETDATE(), 'Installer', 'Installer'
		,4, (SELECT attribute_id FROM core_attribute WHERE [guid] = '0A6732E9-1110-460C-9F15-25566E314449')
		,1, @AdminPersonID, 2, NULL, 1
		)
END


--
-- Create the Family Contributions Last 6 Months attribute
--
IF NOT EXISTS (SELECT * FROM core_attribute WHERE [guid] = 'DE4AB314-E618-45C0-8B37-0FD040D825C7')
BEGIN
	INSERT INTO core_attribute
		([guid]
		,[date_created]
		,[date_modified]
		,[created_by]
		,[modified_by]
		,[attribute_group_id]
		,[attribute_name]
		,[attribute_type]
		,[attribute_order]
		,[visible]
		,[required]
		,[type_qualifier]
		,[readonly]
		,[system_flag]
		,[history_enabled]
		,[max_history_entries]
		,[organization_id]
		)
		VALUES
		('DE4AB314-E618-45C0-8B37-0FD040D825C7'
		,GETDATE()
		,GETDATE()
		,'Installer'
		,'Installer'
		,(SELECT attribute_group_id FROM core_attribute_group WHERE [guid] = '15736785-0471-41DA-A805-B30B1D8942C4')
		,'Family Contributions Last 6 Months'
		,0
		,14
		,1
		,0
		,''
		,1
		,0
		,0
		,0
		,1
		)

	INSERT INTO list_available_attribute
		([attribute_name]
		,[attribute_id]
		,[attribute_group_id]
		,[report_type_id]
		,[organization_id]
		)
		VALUES
		('Family Contributions Last 6 Months'
		,(SELECT attribute_id FROM core_attribute WHERE [guid] = 'DE4AB314-E618-45C0-8B37-0FD040D825C7')
		,(SELECT attribute_group_id FROM core_attribute_group WHERE [guid] = '15736785-0471-41DA-A805-B30B1D8942C4')
		,1
		,1
		)

	INSERT INTO secu_permission
		([date_created], [date_modified], [created_by], [modified_by]
		,[object_type], [object_key]
		,[subject_type], [subject_key], [operation_type], [template_id], [organization_id]
		)
		VALUES
		(GETDATE(), GETDATE(), 'Installer', 'Installer'
		,4, (SELECT attribute_id FROM core_attribute WHERE [guid] = 'DE4AB314-E618-45C0-8B37-0FD040D825C7')
		,1, @AdminPersonID, 0, NULL, 1
		)
	INSERT INTO secu_permission
		([date_created], [date_modified], [created_by], [modified_by]
		,[object_type], [object_key]
		,[subject_type], [subject_key], [operation_type], [template_id], [organization_id]
		)
		VALUES
		(GETDATE(), GETDATE(), 'Installer', 'Installer'
		,4, (SELECT attribute_id FROM core_attribute WHERE [guid] = 'DE4AB314-E618-45C0-8B37-0FD040D825C7')
		,1, @AdminPersonID, 1, NULL, 1
		)
	INSERT INTO secu_permission
		([date_created], [date_modified], [created_by], [modified_by]
		,[object_type], [object_key]
		,[subject_type], [subject_key], [operation_type], [template_id], [organization_id]
		)
		VALUES
		(GETDATE(), GETDATE(), 'Installer', 'Installer'
		,4, (SELECT attribute_id FROM core_attribute WHERE [guid] = 'DE4AB314-E618-45C0-8B37-0FD040D825C7')
		,1, @AdminPersonID, 2, NULL, 1
		)
END


--
-- Create the Family Contributions Last 12 Months attribute
--
IF NOT EXISTS (SELECT * FROM core_attribute WHERE [guid] = '487121F7-FFAC-43D9-9149-D0A6BFAB3783')
BEGIN
	INSERT INTO core_attribute
		([guid]
		,[date_created]
		,[date_modified]
		,[created_by]
		,[modified_by]
		,[attribute_group_id]
		,[attribute_name]
		,[attribute_type]
		,[attribute_order]
		,[visible]
		,[required]
		,[type_qualifier]
		,[readonly]
		,[system_flag]
		,[history_enabled]
		,[max_history_entries]
		,[organization_id]
		)
		VALUES
		('487121F7-FFAC-43D9-9149-D0A6BFAB3783'
		,GETDATE()
		,GETDATE()
		,'Installer'
		,'Installer'
		,(SELECT attribute_group_id FROM core_attribute_group WHERE [guid] = '15736785-0471-41DA-A805-B30B1D8942C4')
		,'Family Contributions Last 12 Months'
		,0
		,15
		,1
		,0
		,''
		,1
		,0
		,0
		,0
		,1
		)

	INSERT INTO list_available_attribute
		([attribute_name]
		,[attribute_id]
		,[attribute_group_id]
		,[report_type_id]
		,[organization_id]
		)
		VALUES
		('Family Contributions Last 12 Months'
		,(SELECT attribute_id FROM core_attribute WHERE [guid] = '487121F7-FFAC-43D9-9149-D0A6BFAB3783')
		,(SELECT attribute_group_id FROM core_attribute_group WHERE [guid] = '15736785-0471-41DA-A805-B30B1D8942C4')
		,1
		,1
		)

	INSERT INTO secu_permission
		([date_created], [date_modified], [created_by], [modified_by]
		,[object_type], [object_key]
		,[subject_type], [subject_key], [operation_type], [template_id], [organization_id]
		)
		VALUES
		(GETDATE(), GETDATE(), 'Installer', 'Installer'
		,4, (SELECT attribute_id FROM core_attribute WHERE [guid] = '487121F7-FFAC-43D9-9149-D0A6BFAB3783')
		,1, @AdminPersonID, 0, NULL, 1
		)
	INSERT INTO secu_permission
		([date_created], [date_modified], [created_by], [modified_by]
		,[object_type], [object_key]
		,[subject_type], [subject_key], [operation_type], [template_id], [organization_id]
		)
		VALUES
		(GETDATE(), GETDATE(), 'Installer', 'Installer'
		,4, (SELECT attribute_id FROM core_attribute WHERE [guid] = '487121F7-FFAC-43D9-9149-D0A6BFAB3783')
		,1, @AdminPersonID, 1, NULL, 1
		)
	INSERT INTO secu_permission
		([date_created], [date_modified], [created_by], [modified_by]
		,[object_type], [object_key]
		,[subject_type], [subject_key], [operation_type], [template_id], [organization_id]
		)
		VALUES
		(GETDATE(), GETDATE(), 'Installer', 'Installer'
		,4, (SELECT attribute_id FROM core_attribute WHERE [guid] = '487121F7-FFAC-43D9-9149-D0A6BFAB3783')
		,1, @AdminPersonID, 2, NULL, 1
		)
END


--
-- Create the List Table
--
IF NOT EXISTS (SELECT * FROM list_tables WHERE [table_guid] = 'C0ECE497-16D0-43A8-B7B5-C0CB03D1EC1E')
BEGIN
	INSERT INTO list_tables
		([table_guid]
		,[report_type_id]
		,[table_Name]
		,[main_table_in_report]
		,[table_prefix]
		,[required_join_table_guid]
		,[table_join_order]
		,[join_type]
		,[join_string]
		,[organization_id]
		)
		VALUES
		('C0ECE497-16D0-43A8-B7B5-C0CB03D1EC1E'
		,1
		,'cust_hdc_v_person_activity'
		,0
		,'P_ACTIVITY'
		,'52EBC562-F055-4071-A87F-0BEB1864CA35'
		,(SELECT MAX(table_join_order) FROM list_tables WHERE report_type_id = 1)
		,'LEFT OUTER'
		,'P_ACTIVITY.person_id = P.person_id'
		,1
		)
END


--
-- Create the List Criteria
--
IF NOT EXISTS (SELECT * FROM list_criteria WHERE [criteria_guid] = '3CD077BA-0F4D-4CFC-B435-D484B2F63EC6')
BEGIN
	INSERT INTO list_criteria
		([criteria_guid]
		,[criteria_name]
		,[criteria_description]
		,[organization_id]
		)
		VALUES
		('3CD077BA-0F4D-4CFC-B435-D484B2F63EC6'
		,'Activity'
		,'Person''s Activity'
		,1
		)
END


--
-- Create the Last Attended control
--
IF NOT EXISTS (SELECT * FROM list_criteria_controls WHERE [control_guid] = '9536EC06-ED4B-40E0-BECE-BC9B1B36E294')
BEGIN
	INSERT INTO list_criteria_controls
		([control_guid]
		,[criteria_guid]
		,[control_display_text]
		,[control_field_name]
		,[table_guid]
		,[control_type]
		,[function_query_lookup_value]
		,[function_query_lookup_guid]
		,[const_lookup_value]
		,[const_lookup_guid]
		,[const_function_value]
		,[control_order]
		,[control_display]
		,[control_notes]
		,[person_security_field_id]
		,[include_null_control]
		,[lookup_active_only]
		,[scope_lookups_to_selected_tags_only]
		,[scope_lookups_to_selected_groups_only]
		,[organization_id]
		)
		VALUES
		('9536EC06-ED4B-40E0-BECE-BC9B1B36E294'
		,'3CD077BA-0F4D-4CFC-B435-D484B2F63EC6'
		,'Last Attended'
		,'last_attended'
		,'C0ECE497-16D0-43A8-B7B5-C0CB03D1EC1E'
		,2
		,0
		,NULL
		,0
		,NULL
		,''
		,0
		,1
		,''
		,NULL
		,0
		,0
		,0
		,0
		,1
		)
END


--
-- Create the Last Contribution control
--
IF NOT EXISTS (SELECT * FROM list_criteria_controls WHERE [control_guid] = '494CDDA0-2BDD-4892-8CE3-A354474ACB72')
BEGIN
	INSERT INTO list_criteria_controls
		([control_guid]
		,[criteria_guid]
		,[control_display_text]
		,[control_field_name]
		,[table_guid]
		,[control_type]
		,[function_query_lookup_value]
		,[function_query_lookup_guid]
		,[const_lookup_value]
		,[const_lookup_guid]
		,[const_function_value]
		,[control_order]
		,[control_display]
		,[control_notes]
		,[person_security_field_id]
		,[include_null_control]
		,[lookup_active_only]
		,[scope_lookups_to_selected_tags_only]
		,[scope_lookups_to_selected_groups_only]
		,[organization_id]
		)
		VALUES
		('494CDDA0-2BDD-4892-8CE3-A354474ACB72'
		,'3CD077BA-0F4D-4CFC-B435-D484B2F63EC6'
		,'Last Contribution'
		,'last_contribution'
		,'C0ECE497-16D0-43A8-B7B5-C0CB03D1EC1E'
		,2
		,0
		,NULL
		,0
		,NULL
		,''
		,1
		,1
		,''
		,NULL
		,0
		,0
		,0
		,0
		,1
		)
END


--
-- Create the Attendance Last 3 Months control
--
IF NOT EXISTS (SELECT * FROM list_criteria_controls WHERE [control_guid] = '5885830B-34C6-4828-8F91-A96B2889EDED')
BEGIN
	INSERT INTO list_criteria_controls
		([control_guid]
		,[criteria_guid]
		,[control_display_text]
		,[control_field_name]
		,[table_guid]
		,[control_type]
		,[function_query_lookup_value]
		,[function_query_lookup_guid]
		,[const_lookup_value]
		,[const_lookup_guid]
		,[const_function_value]
		,[control_order]
		,[control_display]
		,[control_notes]
		,[person_security_field_id]
		,[include_null_control]
		,[lookup_active_only]
		,[scope_lookups_to_selected_tags_only]
		,[scope_lookups_to_selected_groups_only]
		,[organization_id]
		)
		VALUES
		('5885830B-34C6-4828-8F91-A96B2889EDED'
		,'3CD077BA-0F4D-4CFC-B435-D484B2F63EC6'
		,'Attendance Last 3 Months'
		,'attendance_last_3_months'
		,'C0ECE497-16D0-43A8-B7B5-C0CB03D1EC1E'
		,0
		,0
		,NULL
		,0
		,NULL
		,''
		,2
		,1
		,''
		,NULL
		,0
		,0
		,0
		,0
		,1
		)
END


--
-- Create the Attendance Last 6 Months control
--
IF NOT EXISTS (SELECT * FROM list_criteria_controls WHERE [control_guid] = 'A48FF939-861E-4AB8-9C93-168DBEF3A943')
BEGIN
	INSERT INTO list_criteria_controls
		([control_guid]
		,[criteria_guid]
		,[control_display_text]
		,[control_field_name]
		,[table_guid]
		,[control_type]
		,[function_query_lookup_value]
		,[function_query_lookup_guid]
		,[const_lookup_value]
		,[const_lookup_guid]
		,[const_function_value]
		,[control_order]
		,[control_display]
		,[control_notes]
		,[person_security_field_id]
		,[include_null_control]
		,[lookup_active_only]
		,[scope_lookups_to_selected_tags_only]
		,[scope_lookups_to_selected_groups_only]
		,[organization_id]
		)
		VALUES
		('A48FF939-861E-4AB8-9C93-168DBEF3A943'
		,'3CD077BA-0F4D-4CFC-B435-D484B2F63EC6'
		,'Attendance Last 6 Months'
		,'attendance_last_6_months'
		,'C0ECE497-16D0-43A8-B7B5-C0CB03D1EC1E'
		,0
		,0
		,NULL
		,0
		,NULL
		,''
		,3
		,1
		,''
		,NULL
		,0
		,0
		,0
		,0
		,1
		)
END


--
-- Create the Attendance Last 12 Months control
--
IF NOT EXISTS (SELECT * FROM list_criteria_controls WHERE [control_guid] = '33A6B060-20ED-47E5-900A-D2FD09DB9BE2')
BEGIN
	INSERT INTO list_criteria_controls
		([control_guid]
		,[criteria_guid]
		,[control_display_text]
		,[control_field_name]
		,[table_guid]
		,[control_type]
		,[function_query_lookup_value]
		,[function_query_lookup_guid]
		,[const_lookup_value]
		,[const_lookup_guid]
		,[const_function_value]
		,[control_order]
		,[control_display]
		,[control_notes]
		,[person_security_field_id]
		,[include_null_control]
		,[lookup_active_only]
		,[scope_lookups_to_selected_tags_only]
		,[scope_lookups_to_selected_groups_only]
		,[organization_id]
		)
		VALUES
		('33A6B060-20ED-47E5-900A-D2FD09DB9BE2'
		,'3CD077BA-0F4D-4CFC-B435-D484B2F63EC6'
		,'Attendance Last 12 Months'
		,'attendance_last_12_months'
		,'C0ECE497-16D0-43A8-B7B5-C0CB03D1EC1E'
		,0
		,0
		,NULL
		,0
		,NULL
		,''
		,4
		,1
		,''
		,NULL
		,0
		,0
		,0
		,0
		,1
		)
END


--
-- Create the Contributions Last 3 Months control
--
IF NOT EXISTS (SELECT * FROM list_criteria_controls WHERE [control_guid] = 'FEEB7C74-2D1C-46FD-9E85-459724D16A15')
BEGIN
	INSERT INTO list_criteria_controls
		([control_guid]
		,[criteria_guid]
		,[control_display_text]
		,[control_field_name]
		,[table_guid]
		,[control_type]
		,[function_query_lookup_value]
		,[function_query_lookup_guid]
		,[const_lookup_value]
		,[const_lookup_guid]
		,[const_function_value]
		,[control_order]
		,[control_display]
		,[control_notes]
		,[person_security_field_id]
		,[include_null_control]
		,[lookup_active_only]
		,[scope_lookups_to_selected_tags_only]
		,[scope_lookups_to_selected_groups_only]
		,[organization_id]
		)
		VALUES
		('FEEB7C74-2D1C-46FD-9E85-459724D16A15'
		,'3CD077BA-0F4D-4CFC-B435-D484B2F63EC6'
		,'Contributions Last 3 Months'
		,'contributions_last_3_months'
		,'C0ECE497-16D0-43A8-B7B5-C0CB03D1EC1E'
		,0
		,0
		,NULL
		,0
		,NULL
		,''
		,5
		,1
		,''
		,NULL
		,0
		,0
		,0
		,0
		,1
		)
END


--
-- Create the Contributions Last 6 Months control
--
IF NOT EXISTS (SELECT * FROM list_criteria_controls WHERE [control_guid] = '4DCFFCB2-0BCB-42BA-B2AD-EF42B60733FD')
BEGIN
	INSERT INTO list_criteria_controls
		([control_guid]
		,[criteria_guid]
		,[control_display_text]
		,[control_field_name]
		,[table_guid]
		,[control_type]
		,[function_query_lookup_value]
		,[function_query_lookup_guid]
		,[const_lookup_value]
		,[const_lookup_guid]
		,[const_function_value]
		,[control_order]
		,[control_display]
		,[control_notes]
		,[person_security_field_id]
		,[include_null_control]
		,[lookup_active_only]
		,[scope_lookups_to_selected_tags_only]
		,[scope_lookups_to_selected_groups_only]
		,[organization_id]
		)
		VALUES
		('4DCFFCB2-0BCB-42BA-B2AD-EF42B60733FD'
		,'3CD077BA-0F4D-4CFC-B435-D484B2F63EC6'
		,'Contributions Last 6 Months'
		,'contributions_last_6_months'
		,'C0ECE497-16D0-43A8-B7B5-C0CB03D1EC1E'
		,0
		,0
		,NULL
		,0
		,NULL
		,''
		,6
		,1
		,''
		,NULL
		,0
		,0
		,0
		,0
		,1
		)
END


--
-- Create the Contributions Last 12 Months control
--
IF NOT EXISTS (SELECT * FROM list_criteria_controls WHERE [control_guid] = '3803B8AE-2066-4C3C-A5D1-72ADE66E6D16')
BEGIN
	INSERT INTO list_criteria_controls
		([control_guid]
		,[criteria_guid]
		,[control_display_text]
		,[control_field_name]
		,[table_guid]
		,[control_type]
		,[function_query_lookup_value]
		,[function_query_lookup_guid]
		,[const_lookup_value]
		,[const_lookup_guid]
		,[const_function_value]
		,[control_order]
		,[control_display]
		,[control_notes]
		,[person_security_field_id]
		,[include_null_control]
		,[lookup_active_only]
		,[scope_lookups_to_selected_tags_only]
		,[scope_lookups_to_selected_groups_only]
		,[organization_id]
		)
		VALUES
		('3803B8AE-2066-4C3C-A5D1-72ADE66E6D16'
		,'3CD077BA-0F4D-4CFC-B435-D484B2F63EC6'
		,'Contributions Last 12 Months'
		,'contributions_last_12_months'
		,'C0ECE497-16D0-43A8-B7B5-C0CB03D1EC1E'
		,0
		,0
		,NULL
		,0
		,NULL
		,''
		,7
		,1
		,''
		,NULL
		,0
		,0
		,0
		,0
		,1
		)
END


--
-- Create the Family Last Attended control
--
IF NOT EXISTS (SELECT * FROM list_criteria_controls WHERE [control_guid] = '913C58E6-4B70-4C4E-81CD-0311772044A5')
BEGIN
	INSERT INTO list_criteria_controls
		([control_guid]
		,[criteria_guid]
		,[control_display_text]
		,[control_field_name]
		,[table_guid]
		,[control_type]
		,[function_query_lookup_value]
		,[function_query_lookup_guid]
		,[const_lookup_value]
		,[const_lookup_guid]
		,[const_function_value]
		,[control_order]
		,[control_display]
		,[control_notes]
		,[person_security_field_id]
		,[include_null_control]
		,[lookup_active_only]
		,[scope_lookups_to_selected_tags_only]
		,[scope_lookups_to_selected_groups_only]
		,[organization_id]
		)
		VALUES
		('913C58E6-4B70-4C4E-81CD-0311772044A5'
		,'3CD077BA-0F4D-4CFC-B435-D484B2F63EC6'
		,'Family Last Attended'
		,'family_last_attended'
		,'C0ECE497-16D0-43A8-B7B5-C0CB03D1EC1E'
		,2
		,0
		,NULL
		,0
		,NULL
		,''
		,8
		,1
		,''
		,NULL
		,0
		,0
		,0
		,0
		,1
		)
END


--
-- Create the Family Last Contribution control
--
IF NOT EXISTS (SELECT * FROM list_criteria_controls WHERE [control_guid] = '64869A01-349C-475B-8EC1-0F93C644E606')
BEGIN
	INSERT INTO list_criteria_controls
		([control_guid]
		,[criteria_guid]
		,[control_display_text]
		,[control_field_name]
		,[table_guid]
		,[control_type]
		,[function_query_lookup_value]
		,[function_query_lookup_guid]
		,[const_lookup_value]
		,[const_lookup_guid]
		,[const_function_value]
		,[control_order]
		,[control_display]
		,[control_notes]
		,[person_security_field_id]
		,[include_null_control]
		,[lookup_active_only]
		,[scope_lookups_to_selected_tags_only]
		,[scope_lookups_to_selected_groups_only]
		,[organization_id]
		)
		VALUES
		('64869A01-349C-475B-8EC1-0F93C644E606'
		,'3CD077BA-0F4D-4CFC-B435-D484B2F63EC6'
		,'Family Last Contribution'
		,'family_last_contribution'
		,'C0ECE497-16D0-43A8-B7B5-C0CB03D1EC1E'
		,2
		,0
		,NULL
		,0
		,NULL
		,''
		,9
		,1
		,''
		,NULL
		,0
		,0
		,0
		,0
		,1
		)
END


--
-- Create the Family Attendance Last 3 Months control
--
IF NOT EXISTS (SELECT * FROM list_criteria_controls WHERE [control_guid] = '911AE35A-812D-4F62-B6B0-7100BEDDDFD0')
BEGIN
	INSERT INTO list_criteria_controls
		([control_guid]
		,[criteria_guid]
		,[control_display_text]
		,[control_field_name]
		,[table_guid]
		,[control_type]
		,[function_query_lookup_value]
		,[function_query_lookup_guid]
		,[const_lookup_value]
		,[const_lookup_guid]
		,[const_function_value]
		,[control_order]
		,[control_display]
		,[control_notes]
		,[person_security_field_id]
		,[include_null_control]
		,[lookup_active_only]
		,[scope_lookups_to_selected_tags_only]
		,[scope_lookups_to_selected_groups_only]
		,[organization_id]
		)
		VALUES
		('911AE35A-812D-4F62-B6B0-7100BEDDDFD0'
		,'3CD077BA-0F4D-4CFC-B435-D484B2F63EC6'
		,'Family Attendance Last 3 Months'
		,'family_attendance_last_3_months'
		,'C0ECE497-16D0-43A8-B7B5-C0CB03D1EC1E'
		,0
		,0
		,NULL
		,0
		,NULL
		,''
		,10
		,1
		,''
		,NULL
		,0
		,0
		,0
		,0
		,1
		)
END


--
-- Create the Family Attendance Last 6 Months control
--
IF NOT EXISTS (SELECT * FROM list_criteria_controls WHERE [control_guid] = '0C6A6826-B0ED-43DC-8D2C-01AB6056EAB3')
BEGIN
	INSERT INTO list_criteria_controls
		([control_guid]
		,[criteria_guid]
		,[control_display_text]
		,[control_field_name]
		,[table_guid]
		,[control_type]
		,[function_query_lookup_value]
		,[function_query_lookup_guid]
		,[const_lookup_value]
		,[const_lookup_guid]
		,[const_function_value]
		,[control_order]
		,[control_display]
		,[control_notes]
		,[person_security_field_id]
		,[include_null_control]
		,[lookup_active_only]
		,[scope_lookups_to_selected_tags_only]
		,[scope_lookups_to_selected_groups_only]
		,[organization_id]
		)
		VALUES
		('0C6A6826-B0ED-43DC-8D2C-01AB6056EAB3'
		,'3CD077BA-0F4D-4CFC-B435-D484B2F63EC6'
		,'Family Attendance Last 6 Months'
		,'family_attendance_last_6_months'
		,'C0ECE497-16D0-43A8-B7B5-C0CB03D1EC1E'
		,0
		,0
		,NULL
		,0
		,NULL
		,''
		,11
		,1
		,''
		,NULL
		,0
		,0
		,0
		,0
		,1
		)
END


--
-- Create the Family Attendance Last 12 Months control
--
IF NOT EXISTS (SELECT * FROM list_criteria_controls WHERE [control_guid] = '91EFCFFD-28EB-4294-988C-E4448A096D5A')
BEGIN
	INSERT INTO list_criteria_controls
		([control_guid]
		,[criteria_guid]
		,[control_display_text]
		,[control_field_name]
		,[table_guid]
		,[control_type]
		,[function_query_lookup_value]
		,[function_query_lookup_guid]
		,[const_lookup_value]
		,[const_lookup_guid]
		,[const_function_value]
		,[control_order]
		,[control_display]
		,[control_notes]
		,[person_security_field_id]
		,[include_null_control]
		,[lookup_active_only]
		,[scope_lookups_to_selected_tags_only]
		,[scope_lookups_to_selected_groups_only]
		,[organization_id]
		)
		VALUES
		('91EFCFFD-28EB-4294-988C-E4448A096D5A'
		,'3CD077BA-0F4D-4CFC-B435-D484B2F63EC6'
		,'Family Attendance Last 12 Months'
		,'family_attendance_last_12_months'
		,'C0ECE497-16D0-43A8-B7B5-C0CB03D1EC1E'
		,0
		,0
		,NULL
		,0
		,NULL
		,''
		,12
		,1
		,''
		,NULL
		,0
		,0
		,0
		,0
		,1
		)
END


--
-- Create the Family Contributions Last 3 Months control
--
IF NOT EXISTS (SELECT * FROM list_criteria_controls WHERE [control_guid] = 'C714F1AA-DEB3-408E-A5A7-0D9460FEA17D')
BEGIN
	INSERT INTO list_criteria_controls
		([control_guid]
		,[criteria_guid]
		,[control_display_text]
		,[control_field_name]
		,[table_guid]
		,[control_type]
		,[function_query_lookup_value]
		,[function_query_lookup_guid]
		,[const_lookup_value]
		,[const_lookup_guid]
		,[const_function_value]
		,[control_order]
		,[control_display]
		,[control_notes]
		,[person_security_field_id]
		,[include_null_control]
		,[lookup_active_only]
		,[scope_lookups_to_selected_tags_only]
		,[scope_lookups_to_selected_groups_only]
		,[organization_id]
		)
		VALUES
		('C714F1AA-DEB3-408E-A5A7-0D9460FEA17D'
		,'3CD077BA-0F4D-4CFC-B435-D484B2F63EC6'
		,'Family Contributions Last 3 Months'
		,'family_contributions_last_3_months'
		,'C0ECE497-16D0-43A8-B7B5-C0CB03D1EC1E'
		,0
		,0
		,NULL
		,0
		,NULL
		,''
		,13
		,1
		,''
		,NULL
		,0
		,0
		,0
		,0
		,1
		)
END


--
-- Create the Family Contributions Last 6 Months control
--
IF NOT EXISTS (SELECT * FROM list_criteria_controls WHERE [control_guid] = 'CF519B8E-D578-4EB0-9B30-869F81371646')
BEGIN
	INSERT INTO list_criteria_controls
		([control_guid]
		,[criteria_guid]
		,[control_display_text]
		,[control_field_name]
		,[table_guid]
		,[control_type]
		,[function_query_lookup_value]
		,[function_query_lookup_guid]
		,[const_lookup_value]
		,[const_lookup_guid]
		,[const_function_value]
		,[control_order]
		,[control_display]
		,[control_notes]
		,[person_security_field_id]
		,[include_null_control]
		,[lookup_active_only]
		,[scope_lookups_to_selected_tags_only]
		,[scope_lookups_to_selected_groups_only]
		,[organization_id]
		)
		VALUES
		('CF519B8E-D578-4EB0-9B30-869F81371646'
		,'3CD077BA-0F4D-4CFC-B435-D484B2F63EC6'
		,'Family Contributions Last 6 Months'
		,'family_contributions_last_6_months'
		,'C0ECE497-16D0-43A8-B7B5-C0CB03D1EC1E'
		,0
		,0
		,NULL
		,0
		,NULL
		,''
		,14
		,1
		,''
		,NULL
		,0
		,0
		,0
		,0
		,1
		)
END


--
-- Create the Family Contributions Last 12 Months control
--
IF NOT EXISTS (SELECT * FROM list_criteria_controls WHERE [control_guid] = 'C7DF60CC-A0DD-4F04-9746-E20E0566DA1A')
BEGIN
	INSERT INTO list_criteria_controls
		([control_guid]
		,[criteria_guid]
		,[control_display_text]
		,[control_field_name]
		,[table_guid]
		,[control_type]
		,[function_query_lookup_value]
		,[function_query_lookup_guid]
		,[const_lookup_value]
		,[const_lookup_guid]
		,[const_function_value]
		,[control_order]
		,[control_display]
		,[control_notes]
		,[person_security_field_id]
		,[include_null_control]
		,[lookup_active_only]
		,[scope_lookups_to_selected_tags_only]
		,[scope_lookups_to_selected_groups_only]
		,[organization_id]
		)
		VALUES
		('C7DF60CC-A0DD-4F04-9746-E20E0566DA1A'
		,'3CD077BA-0F4D-4CFC-B435-D484B2F63EC6'
		,'Family Contributions Last 12 Months'
		,'family_contributions_last_12_months'
		,'C0ECE497-16D0-43A8-B7B5-C0CB03D1EC1E'
		,0
		,0
		,NULL
		,0
		,NULL
		,''
		,15
		,1
		,''
		,NULL
		,0
		,0
		,0
		,0
		,1
		)
END




GO

--
-- Create the cust_hdc_v_person_activity view
--
IF EXISTS (SELECT * FROM sys.views where name = 'cust_hdc_v_person_activity')
BEGIN
	DROP VIEW cust_hdc_v_person_activity
END
GO
CREATE VIEW cust_hdc_v_person_activity
AS
	SELECT
		 cp.person_id
		,cpa_la.datetime_value AS 'last_attended'
		,cpa_lc.datetime_value AS 'last_contribution'
		,cpa_la3.int_value AS 'attendance_last_3_months'
		,cpa_la6.int_value AS 'attendance_last_6_months'
		,cpa_la12.int_value AS 'attendance_last_12_months'
		,cpa_lc3.int_value AS 'contributions_last_3_months'
		,cpa_lc6.int_value AS 'contributions_last_6_months'
		,cpa_lc12.int_value AS 'contributions_last_12_months'
		,cpa_fla.datetime_value AS 'family_last_attended'
		,cpa_flc.datetime_value AS 'family_last_contribution'
		,cpa_fla3.int_value AS 'family_attendance_last_3_months'
		,cpa_fla6.int_value AS 'family_attendance_last_6_months'
		,cpa_fla12.int_value AS 'family_attendance_last_12_months'
		,cpa_flc3.int_value AS 'family_contributions_last_3_months'
		,cpa_flc6.int_value AS 'family_contributions_last_6_months'
		,cpa_flc12.int_value AS 'family_contributions_last_12_months'
		FROM core_person AS cp
		LEFT JOIN core_person_attribute AS cpa_la ON cpa_la.person_id = cp.person_id
			  AND cpa_la.attribute_id = (SELECT attribute_id FROM core_attribute WHERE [guid] = '4358D763-8794-4E8F-80B0-7AC7C51224F4')
		LEFT JOIN core_person_attribute AS cpa_lc ON cpa_lc.person_id = cp.person_id
			  AND cpa_lc.attribute_id = (SELECT attribute_id FROM core_attribute WHERE [guid] = 'E18C2034-7590-4559-ADD8-B7CCFAB3FA57')
		LEFT JOIN core_person_attribute AS cpa_la3 ON cpa_la3.person_id = cp.person_id
			  AND cpa_la3.attribute_id = (SELECT attribute_id FROM core_attribute WHERE [guid] = 'F70AFD2D-2F09-450C-9082-D514088730AE')
		LEFT JOIN core_person_attribute AS cpa_la6 ON cpa_la6.person_id = cp.person_id
			  AND cpa_la6.attribute_id = (SELECT attribute_id FROM core_attribute WHERE [guid] = '1D5CCB7F-D346-439B-9DB7-7F2E84E117CF')
		LEFT JOIN core_person_attribute AS cpa_la12 ON cpa_la12.person_id = cp.person_id
			  AND cpa_la12.attribute_id = (SELECT attribute_id FROM core_attribute WHERE [guid] = '209811F7-44F2-4A9D-977E-FF96A700C928')
		LEFT JOIN core_person_attribute AS cpa_lc3 ON cpa_lc3.person_id = cp.person_id
			  AND cpa_lc3.attribute_id = (SELECT attribute_id FROM core_attribute WHERE [guid] = '3B16D6E8-45B2-4210-B22B-9F2FCDA8B44C')
		LEFT JOIN core_person_attribute AS cpa_lc6 ON cpa_lc6.person_id = cp.person_id
			  AND cpa_lc6.attribute_id = (SELECT attribute_id FROM core_attribute WHERE [guid] = 'CA8DCB9B-07EC-4E40-A915-834C2D648419')
		LEFT JOIN core_person_attribute AS cpa_lc12 ON cpa_lc12.person_id = cp.person_id
			  AND cpa_lc12.attribute_id = (SELECT attribute_id FROM core_attribute WHERE [guid] = '9100CC24-DF6F-4F25-9E15-22270504E395')
		LEFT JOIN core_person_attribute AS cpa_fla ON cpa_fla.person_id = cp.person_id
			  AND cpa_fla.attribute_id = (SELECT attribute_id FROM core_attribute WHERE [guid] = 'B217F574-1059-445B-B394-D4A72AA2730A')
		LEFT JOIN core_person_attribute AS cpa_flc ON cpa_flc.person_id = cp.person_id
			  AND cpa_flc.attribute_id = (SELECT attribute_id FROM core_attribute WHERE [guid] = '1A5BF310-E810-4E75-AD46-44DD58850E19')
		LEFT JOIN core_person_attribute AS cpa_fla3 ON cpa_fla3.person_id = cp.person_id
			  AND cpa_fla3.attribute_id = (SELECT attribute_id FROM core_attribute WHERE [guid] = '59C7C09E-EACE-4F62-B599-FDD4A014863F')
		LEFT JOIN core_person_attribute AS cpa_fla6 ON cpa_fla6.person_id = cp.person_id
			  AND cpa_fla6.attribute_id = (SELECT attribute_id FROM core_attribute WHERE [guid] = '24F11773-295E-4F92-931C-5CACDA6415FA')
		LEFT JOIN core_person_attribute AS cpa_fla12 ON cpa_fla12.person_id = cp.person_id
			  AND cpa_fla12.attribute_id = (SELECT attribute_id FROM core_attribute WHERE [guid] = 'DB9EDD5A-ADEB-41B9-B9DB-0387AC56222E')
		LEFT JOIN core_person_attribute AS cpa_flc3 ON cpa_flc3.person_id = cp.person_id
			  AND cpa_flc3.attribute_id = (SELECT attribute_id FROM core_attribute WHERE [guid] = '0A6732E9-1110-460C-9F15-25566E314449')
		LEFT JOIN core_person_attribute AS cpa_flc6 ON cpa_flc6.person_id = cp.person_id
			  AND cpa_flc6.attribute_id = (SELECT attribute_id FROM core_attribute WHERE [guid] = 'DE4AB314-E618-45C0-8B37-0FD040D825C7')
		LEFT JOIN core_person_attribute AS cpa_flc12 ON cpa_flc12.person_id = cp.person_id
			  AND cpa_flc12.attribute_id = (SELECT attribute_id FROM core_attribute WHERE [guid] = '487121F7-FFAC-43D9-9149-D0A6BFAB3783')
GO


--
-- Create the stored procedure
--
IF OBJECT_ID('cust_hdc_sp_update_person_activity', 'P') IS NOT NULL
BEGIN
	DROP PROC cust_hdc_sp_update_person_activity
END
GO
CREATE PROCEDURE [dbo].[cust_hdc_sp_update_person_activity]
AS
BEGIN
DECLARE @LastAttendedID INT
DECLARE @LastContributionID INT
DECLARE @Attendance3MonthID INT
DECLARE @Attendance6MonthID INT
DECLARE @Attendance12MonthID INT
DECLARE @Contributions3MonthID INT
DECLARE @Contributions6MonthID INT
DECLARE @Contributions12MonthID INT
DECLARE @FamilyLastAttendedID INT
DECLARE @FamilyLastContributionID INT
DECLARE @FamilyAttendance3MonthID INT
DECLARE @FamilyAttendance6MonthID INT
DECLARE @FamilyAttendance12MonthID INT
DECLARE @FamilyContributions3MonthID INT
DECLARE @FamilyContributions6MonthID INT
DECLARE @FamilyContributions12MonthID INT
DECLARE @MinimumRecordExistence INT

DECLARE @PeopleDate TABLE (person_id INT, last_date DATETIME, organization_id INT)
DECLARE @PeopleCount TABLE (person_id INT, number INT, organization_id INT)
DECLARE @PersonID INT
DECLARE @Date DATETIME
DECLARE @Count INT
DECLARE @OrgID INT

--
-- Set the appropriate ID numbers
--
SELECT @LastAttendedID = ISNULL(attribute_id, -1) FROM core_attribute WHERE [guid] = '4358D763-8794-4E8F-80B0-7AC7C51224F4'
SELECT @LastContributionID = ISNULL(attribute_id, -1) FROM core_attribute WHERE [guid] = 'E18C2034-7590-4559-ADD8-B7CCFAB3FA57'
SELECT @Attendance3MonthID = ISNULL(attribute_id, -1) FROM core_attribute WHERE [guid] = 'F70AFD2D-2F09-450C-9082-D514088730AE'
SELECT @Attendance6MonthID = ISNULL(attribute_id, -1) FROM core_attribute WHERE [guid] = '1D5CCB7F-D346-439B-9DB7-7F2E84E117CF'
SELECT @Attendance12MonthID = ISNULL(attribute_id, -1) FROM core_attribute WHERE [guid] = '209811F7-44F2-4A9D-977E-FF96A700C928'
SELECT @Contributions3MonthID = ISNULL(attribute_id, -1) FROM core_attribute WHERE [guid] = '3B16D6E8-45B2-4210-B22B-9F2FCDA8B44C'
SELECT @Contributions6MonthID = ISNULL(attribute_id, -1) FROM core_attribute WHERE [guid] = 'CA8DCB9B-07EC-4E40-A915-834C2D648419'
SELECT @Contributions12MonthID = ISNULL(attribute_id, -1) FROM core_attribute WHERE [guid] = '9100CC24-DF6F-4F25-9E15-22270504E395'
SELECT @FamilyLastAttendedID = ISNULL(attribute_id, -1) FROM core_attribute WHERE [guid] = 'B217F574-1059-445B-B394-D4A72AA2730A'
SELECT @FamilyLastContributionID = ISNULL(attribute_id, -1) FROM core_attribute WHERE [guid] = '1A5BF310-E810-4E75-AD46-44DD58850E19'
SELECT @FamilyAttendance3MonthID = ISNULL(attribute_id, -1) FROM core_attribute WHERE [guid] = '59C7C09E-EACE-4F62-B599-FDD4A014863F'
SELECT @FamilyAttendance6MonthID = ISNULL(attribute_id, -1) FROM core_attribute WHERE [guid] = '24F11773-295E-4F92-931C-5CACDA6415FA'
SELECT @FamilyAttendance12MonthID = ISNULL(attribute_id, -1) FROM core_attribute WHERE [guid] = 'DB9EDD5A-ADEB-41B9-B9DB-0387AC56222E'
SELECT @FamilyContributions3MonthID = ISNULL(attribute_id, -1) FROM core_attribute WHERE [guid] = '0A6732E9-1110-460C-9F15-25566E314449'
SELECT @FamilyContributions6MonthID = ISNULL(attribute_id, -1) FROM core_attribute WHERE [guid] = 'DE4AB314-E618-45C0-8B37-0FD040D825C7'
SELECT @FamilyContributions12MonthID = ISNULL(attribute_id, -1) FROM core_attribute WHERE [guid] = '487121F7-FFAC-43D9-9149-D0A6BFAB3783'
SET @MinimumRecordExistence = 14

---------------------------------------------------------------------
--
-- Update LastAttendedID
--
---------------------------------------------------------------------
IF @LastAttendedID != -1
BEGIN
	DELETE FROM @PeopleDate
	INSERT INTO @PeopleDate
		SELECT
			 cp.person_id
			,att.last_date
			,cp.organization_id
			FROM core_person AS cp
			CROSS APPLY
			(
				SELECT MAX(co.occurrence_start_time) AS last_date
					FROM core_occurrence_attendance AS coa
					LEFT JOIN core_occurrence AS co ON co.occurrence_id = coa.occurrence_id
					WHERE coa.person_id = cp.person_id
			) att
			LEFT JOIN core_person_attribute AS cpa ON cpa.person_id = cp.person_id AND cpa.attribute_id = @LastAttendedID
			WHERE att.last_date IS NOT NULL
			  AND (cpa.datetime_value != att.last_date OR cpa.datetime_value IS NULL)
			  AND DATEADD(DAY, @MinimumRecordExistence, cp.date_created) < GETDATE()

	WHILE EXISTS (SELECT * FROM @PeopleDate)
	BEGIN
		SELECT
			TOP 1
			@PersonID = person_id
			,@Date = last_date
			,@OrgID = organization_id
			FROM @PeopleDate

		DELETE @PeopleDate WHERE person_id = @PersonID

		EXEC dbo.core_sp_save_person_attribute @PersonID = @PersonID, @AttributeID = @LastAttendedID, @IntValue = -1, @VarcharValue = '', @DateTimeValue = @Date, @DecimalValue = -1, @UserID = 'Update Attendance', @OrganizationId = @OrgID
	END
END


---------------------------------------------------------------------
--
-- Update LastContributionID
--
---------------------------------------------------------------------
IF @LastContributionID != -1
BEGIN
	DELETE FROM @PeopleDate
	INSERT INTO @PeopleDate
		SELECT
			 cp.person_id
			,att.last_date
			,cp.organization_id
			FROM core_person AS cp
			CROSS APPLY
			(
				SELECT MAX(cc.contribution_date) AS last_date
					FROM ctrb_contribution AS cc
					WHERE cc.person_id = cp.person_id
			) att
			LEFT JOIN core_person_attribute AS cpa ON cpa.person_id = cp.person_id AND cpa.attribute_id = @LastContributionID
			WHERE att.last_date IS NOT NULL
			  AND (cpa.datetime_value != att.last_date OR cpa.datetime_value IS NULL)
			  AND DATEADD(DAY, @MinimumRecordExistence, cp.date_created) < GETDATE()

	WHILE EXISTS (SELECT * FROM @PeopleDate)
	BEGIN
		SELECT
			TOP 1
			@PersonID = person_id
			,@Date = last_date
			,@OrgID = organization_id
			FROM @PeopleDate

		DELETE @PeopleDate WHERE person_id = @PersonID

		EXEC dbo.core_sp_save_person_attribute @PersonID = @PersonID, @AttributeID = @LastContributionID, @IntValue = -1, @VarcharValue = '', @DateTimeValue = @Date, @DecimalValue = -1, @UserID = 'Update Attendance', @OrganizationId = @OrgID
	END
END


---------------------------------------------------------------------
--
-- Update Attendance3MonthID
--
---------------------------------------------------------------------
IF @Attendance3MonthID != -1
BEGIN
	DELETE FROM @PeopleCount
	INSERT INTO @PeopleCount
		SELECT
			 cp.person_id
			,att.number
			,cp.organization_id
			FROM core_person AS cp
			CROSS APPLY
			(
				SELECT COUNT(DISTINCT co.occurrence_start_time) AS number
					FROM core_occurrence_attendance AS coa
					LEFT JOIN core_occurrence AS co ON coa.occurrence_id = co.occurrence_id
					WHERE coa.person_id = cp.person_id
					  AND co.occurrence_start_time > DATEADD(MONTH, -3, GETDATE())
			) att
			LEFT JOIN core_person_attribute AS cpa ON cpa.person_id = cp.person_id AND cpa.attribute_id = @Attendance3MonthID
			WHERE (cpa.int_value != att.number OR cpa.int_value IS NULL)
			  AND DATEADD(DAY, @MinimumRecordExistence, cp.date_created) < GETDATE()

	WHILE EXISTS (SELECT * FROM @PeopleCount)
	BEGIN
		SELECT
			TOP 1
			@PersonID = person_id
			,@Count = number
			,@OrgID = organization_id
			FROM @PeopleCount

		DELETE @PeopleCount WHERE person_id = @PersonID

		EXEC dbo.core_sp_save_person_attribute @PersonID = @PersonID, @AttributeID = @Attendance3MonthID, @IntValue = @Count, @VarcharValue = '', @DateTimeValue = '', @DecimalValue = -1, @UserID = 'Update Attendance', @OrganizationId = @OrgID
	END
END


---------------------------------------------------------------------
--
-- Update Attendance6MonthID
--
---------------------------------------------------------------------
IF @Attendance6MonthID != -1
BEGIN
	DELETE FROM @PeopleCount
	INSERT INTO @PeopleCount
		SELECT
			 cp.person_id
			,att.number
			,cp.organization_id
			FROM core_person AS cp
			CROSS APPLY
			(
				SELECT COUNT(DISTINCT co.occurrence_start_time) AS number
					FROM core_occurrence_attendance AS coa
					LEFT JOIN core_occurrence AS co ON coa.occurrence_id = co.occurrence_id
					WHERE coa.person_id = cp.person_id
					  AND co.occurrence_start_time > DATEADD(MONTH, -6, GETDATE())
			) att
			LEFT JOIN core_person_attribute AS cpa ON cpa.person_id = cp.person_id AND cpa.attribute_id = @Attendance6MonthID
			WHERE (cpa.int_value != att.number OR cpa.int_value IS NULL)
			  AND DATEADD(DAY, @MinimumRecordExistence, cp.date_created) < GETDATE()

	WHILE EXISTS (SELECT * FROM @PeopleCount)
	BEGIN
		SELECT
			TOP 1
			@PersonID = person_id
			,@Count = number
			,@OrgID = organization_id
			FROM @PeopleCount

		DELETE @PeopleCount WHERE person_id = @PersonID

		EXEC dbo.core_sp_save_person_attribute @PersonID = @PersonID, @AttributeID = @Attendance6MonthID, @IntValue = @Count, @VarcharValue = '', @DateTimeValue = '', @DecimalValue = -1, @UserID = 'Update Attendance', @OrganizationId = @OrgID
	END
END


---------------------------------------------------------------------
--
-- Update Attendance12MonthID
--
---------------------------------------------------------------------
IF @Attendance12MonthID != -1
BEGIN
	DELETE FROM @PeopleCount
	INSERT INTO @PeopleCount
		SELECT
			 cp.person_id
			,att.number
			,cp.organization_id
			FROM core_person AS cp
			CROSS APPLY
			(
				SELECT COUNT(DISTINCT co.occurrence_start_time) AS number
					FROM core_occurrence_attendance AS coa
					LEFT JOIN core_occurrence AS co ON coa.occurrence_id = co.occurrence_id
					WHERE coa.person_id = cp.person_id
					  AND co.occurrence_start_time > DATEADD(MONTH, -12, GETDATE())
			) att
			LEFT JOIN core_person_attribute AS cpa ON cpa.person_id = cp.person_id AND cpa.attribute_id = @Attendance12MonthID
			WHERE (cpa.int_value != att.number OR cpa.int_value IS NULL)
			  AND DATEADD(DAY, @MinimumRecordExistence, cp.date_created) < GETDATE()

	WHILE EXISTS (SELECT * FROM @PeopleCount)
	BEGIN
		SELECT
			TOP 1
			@PersonID = person_id
			,@Count = number
			,@OrgID = organization_id
			FROM @PeopleCount

		DELETE @PeopleCount WHERE person_id = @PersonID

		EXEC dbo.core_sp_save_person_attribute @PersonID = @PersonID, @AttributeID = @Attendance12MonthID, @IntValue = @Count, @VarcharValue = '', @DateTimeValue = '', @DecimalValue = -1, @UserID = 'Update Attendance', @OrganizationId = @OrgID
	END
END


---------------------------------------------------------------------
--
-- Update Contributions3MonthID
--
---------------------------------------------------------------------
IF @Contributions3MonthID != -1
BEGIN
	DELETE FROM @PeopleCount
	INSERT INTO @PeopleCount
		SELECT
			 cp.person_id
			,att.number
			,cp.organization_id
			FROM core_person AS cp
			CROSS APPLY
			(
				SELECT COUNT(DISTINCT cc.contribution_date) AS number
					FROM ctrb_contribution AS cc
					WHERE cc.person_id = cp.person_id
					  AND cc.contribution_date > DATEADD(MONTH, -3, GETDATE())
			) att
			LEFT JOIN core_person_attribute AS cpa ON cpa.person_id = cp.person_id AND cpa.attribute_id = @Contributions3MonthID
			WHERE (cpa.int_value != att.number OR cpa.int_value IS NULL)
			  AND DATEADD(DAY, @MinimumRecordExistence, cp.date_created) < GETDATE()

	WHILE EXISTS (SELECT * FROM @PeopleCount)
	BEGIN
		SELECT
			TOP 1
			@PersonID = person_id
			,@Count = number
			,@OrgID = organization_id
			FROM @PeopleCount

		DELETE @PeopleCount WHERE person_id = @PersonID

		EXEC dbo.core_sp_save_person_attribute @PersonID = @PersonID, @AttributeID = @Contributions3MonthID, @IntValue = @Count, @VarcharValue = '', @DateTimeValue = '', @DecimalValue = -1, @UserID = 'Update Attendance', @OrganizationId = @OrgID
	END
END


---------------------------------------------------------------------
--
-- Update Contributions6MonthID
--
---------------------------------------------------------------------
IF @Contributions6MonthID != -1
BEGIN
	DELETE FROM @PeopleCount
	INSERT INTO @PeopleCount
		SELECT
			 cp.person_id
			,att.number
			,cp.organization_id
			FROM core_person AS cp
			CROSS APPLY
			(
				SELECT COUNT(DISTINCT cc.contribution_date) AS number
					FROM ctrb_contribution AS cc
					WHERE cc.person_id = cp.person_id
					  AND cc.contribution_date > DATEADD(MONTH, -6, GETDATE())
			) att
			LEFT JOIN core_person_attribute AS cpa ON cpa.person_id = cp.person_id AND cpa.attribute_id = @Contributions6MonthID
			WHERE (cpa.int_value != att.number OR cpa.int_value IS NULL)
			  AND DATEADD(DAY, @MinimumRecordExistence, cp.date_created) < GETDATE()

	WHILE EXISTS (SELECT * FROM @PeopleCount)
	BEGIN
		SELECT
			TOP 1
			@PersonID = person_id
			,@Count = number
			,@OrgID = organization_id
			FROM @PeopleCount

		DELETE @PeopleCount WHERE person_id = @PersonID

		EXEC dbo.core_sp_save_person_attribute @PersonID = @PersonID, @AttributeID = @Contributions6MonthID, @IntValue = @Count, @VarcharValue = '', @DateTimeValue = '', @DecimalValue = -1, @UserID = 'Update Attendance', @OrganizationId = @OrgID
	END
END


---------------------------------------------------------------------
--
-- Update Contributions12MonthID
--
---------------------------------------------------------------------
IF @Contributions12MonthID != -1
BEGIN
	DELETE FROM @PeopleCount
	INSERT INTO @PeopleCount
		SELECT
			 cp.person_id
			,att.number
			,cp.organization_id
			FROM core_person AS cp
			CROSS APPLY
			(
				SELECT COUNT(DISTINCT cc.contribution_date) AS number
					FROM ctrb_contribution AS cc
					WHERE cc.person_id = cp.person_id
					  AND cc.contribution_date > DATEADD(MONTH, -12, GETDATE())
			) att
			LEFT JOIN core_person_attribute AS cpa ON cpa.person_id = cp.person_id AND cpa.attribute_id = @Contributions12MonthID
			WHERE (cpa.int_value != att.number OR cpa.int_value IS NULL)
			  AND DATEADD(DAY, @MinimumRecordExistence, cp.date_created) < GETDATE()

	WHILE EXISTS (SELECT * FROM @PeopleCount)
	BEGIN
		SELECT
			TOP 1
			@PersonID = person_id
			,@Count = number
			,@OrgID = organization_id
			FROM @PeopleCount

		DELETE @PeopleCount WHERE person_id = @PersonID

		EXEC dbo.core_sp_save_person_attribute @PersonID = @PersonID, @AttributeID = @Contributions12MonthID, @IntValue = @Count, @VarcharValue = '', @DateTimeValue = '', @DecimalValue = -1, @UserID = 'Update Attendance', @OrganizationId = @OrgID
	END
END


---------------------------------------------------------------------
--
-- Update FamilyLastAttendedID
--
---------------------------------------------------------------------
IF @FamilyLastAttendedID != -1
BEGIN
	DELETE FROM @PeopleDate
	INSERT INTO @PeopleDate
		SELECT
			 cp.person_id
			,att.last_date
			,cp.organization_id
			FROM core_person AS cp
			LEFT JOIN core_family_member AS cfm ON cfm.person_id = cp.person_id
			CROSS APPLY
			(
				SELECT MAX(co.occurrence_start_time) AS last_date
					FROM core_occurrence_attendance AS coa
					LEFT JOIN core_occurrence AS co ON co.occurrence_id = coa.occurrence_id
					LEFT JOIN core_family_member AS cfm2 ON cfm2.person_id = coa.person_id
					WHERE cfm.family_id = cfm2.family_id
			) att
			LEFT JOIN core_person_attribute AS cpa ON cpa.person_id = cp.person_id AND cpa.attribute_id = @FamilyLastAttendedID
			WHERE att.last_date IS NOT NULL
			  AND (cpa.datetime_value != att.last_date OR cpa.datetime_value IS NULL)
			  AND DATEADD(DAY, @MinimumRecordExistence, cp.date_created) < GETDATE()

	WHILE EXISTS (SELECT * FROM @PeopleDate)
	BEGIN
		SELECT
			TOP 1
			@PersonID = person_id
			,@Date = last_date
			,@OrgID = organization_id
			FROM @PeopleDate

		DELETE @PeopleDate WHERE person_id = @PersonID

		EXEC dbo.core_sp_save_person_attribute @PersonID = @PersonID, @AttributeID = @FamilyLastAttendedID, @IntValue = -1, @VarcharValue = '', @DateTimeValue = @Date, @DecimalValue = -1, @UserID = 'Update Attendance', @OrganizationId = @OrgID
	END
END


---------------------------------------------------------------------
--
-- Update FamilyLastContributionID
--
---------------------------------------------------------------------
IF @FamilyLastContributionID != -1
BEGIN
	DELETE FROM @PeopleDate
	INSERT INTO @PeopleDate
		SELECT
			 cp.person_id
			,att.last_date
			,cp.organization_id
			FROM core_person AS cp
			LEFT JOIN core_family_member AS cfm ON cfm.person_id = cp.person_id
			CROSS APPLY
			(
				SELECT MAX(cc.contribution_date) AS last_date
					FROM ctrb_contribution AS cc
					LEFT JOIN core_family_member AS cfm2 ON cfm2.person_id = cc.person_id
					WHERE cfm.family_id = cfm2.family_id
			) att
			LEFT JOIN core_person_attribute AS cpa ON cpa.person_id = cp.person_id AND cpa.attribute_id = @FamilyLastContributionID
			WHERE att.last_date IS NOT NULL
			  AND (cpa.datetime_value != att.last_date OR cpa.datetime_value IS NULL)
			  AND DATEADD(DAY, @MinimumRecordExistence, cp.date_created) < GETDATE()

	WHILE EXISTS (SELECT * FROM @PeopleDate)
	BEGIN
		SELECT
			TOP 1
			@PersonID = person_id
			,@Date = last_date
			,@OrgID = organization_id
			FROM @PeopleDate

		DELETE @PeopleDate WHERE person_id = @PersonID

		EXEC dbo.core_sp_save_person_attribute @PersonID = @PersonID, @AttributeID = @FamilyLastContributionID, @IntValue = -1, @VarcharValue = '', @DateTimeValue = @Date, @DecimalValue = -1, @UserID = 'Update Attendance', @OrganizationId = @OrgID
	END
END


---------------------------------------------------------------------
--
-- Update FamilyAttendance3MonthID
--
---------------------------------------------------------------------
IF @FamilyAttendance3MonthID != -1
BEGIN
	DELETE FROM @PeopleCount
	INSERT INTO @PeopleCount
		SELECT
			 cp.person_id
			,att.number
			,cp.organization_id
			FROM core_person AS cp
			LEFT JOIN core_family_member AS cfm ON cfm.person_id = cp.person_id
			CROSS APPLY
			(
				SELECT COUNT(DISTINCT co.occurrence_start_time) AS number
					FROM core_occurrence_attendance AS coa
					LEFT JOIN core_occurrence AS co ON coa.occurrence_id = co.occurrence_id
					LEFT JOIN core_family_member AS cfm2 ON coa.person_id = cfm2.person_id
					WHERE cfm2.family_id = cfm.family_id
					  AND co.occurrence_start_time > DATEADD(MONTH, -3, GETDATE())
			) att
			LEFT JOIN core_person_attribute AS cpa ON cpa.person_id = cp.person_id AND cpa.attribute_id = @FamilyAttendance3MonthID
			WHERE (cpa.int_value != att.number OR cpa.int_value IS NULL)
			  AND DATEADD(DAY, @MinimumRecordExistence, cp.date_created) < GETDATE()

	WHILE EXISTS (SELECT * FROM @PeopleCount)
	BEGIN
		SELECT
			TOP 1
			@PersonID = person_id
			,@Count = number
			,@OrgID = organization_id
			FROM @PeopleCount

		DELETE @PeopleCount WHERE person_id = @PersonID

		EXEC dbo.core_sp_save_person_attribute @PersonID = @PersonID, @AttributeID = @FamilyAttendance3MonthID, @IntValue = @Count, @VarcharValue = '', @DateTimeValue = '', @DecimalValue = -1, @UserID = 'Update Attendance', @OrganizationId = @OrgID
	END
END


---------------------------------------------------------------------
--
-- Update FamilyAttendance6MonthID
--
---------------------------------------------------------------------
IF @FamilyAttendance6MonthID != -1
BEGIN
	DELETE FROM @PeopleCount
	INSERT INTO @PeopleCount
		SELECT
			 cp.person_id
			,att.number
			,cp.organization_id
			FROM core_person AS cp
			LEFT JOIN core_family_member AS cfm ON cfm.person_id = cp.person_id
			CROSS APPLY
			(
				SELECT COUNT(DISTINCT co.occurrence_start_time) AS number
					FROM core_occurrence_attendance AS coa
					LEFT JOIN core_occurrence AS co ON coa.occurrence_id = co.occurrence_id
					LEFT JOIN core_family_member AS cfm2 ON coa.person_id = cfm2.person_id
					WHERE cfm2.family_id = cfm.family_id
					  AND co.occurrence_start_time > DATEADD(MONTH, -6, GETDATE())
			) att
			LEFT JOIN core_person_attribute AS cpa ON cpa.person_id = cp.person_id AND cpa.attribute_id = @FamilyAttendance6MonthID
			WHERE (cpa.int_value != att.number OR cpa.int_value IS NULL)
			  AND DATEADD(DAY, @MinimumRecordExistence, cp.date_created) < GETDATE()

	WHILE EXISTS (SELECT * FROM @PeopleCount)
	BEGIN
		SELECT
			TOP 1
			@PersonID = person_id
			,@Count = number
			,@OrgID = organization_id
			FROM @PeopleCount

		DELETE @PeopleCount WHERE person_id = @PersonID

		EXEC dbo.core_sp_save_person_attribute @PersonID = @PersonID, @AttributeID = @FamilyAttendance6MonthID, @IntValue = @Count, @VarcharValue = '', @DateTimeValue = '', @DecimalValue = -1, @UserID = 'Update Attendance', @OrganizationId = @OrgID
	END
END


---------------------------------------------------------------------
--
-- Update FamilyAttendance12MonthID
--
---------------------------------------------------------------------
IF @FamilyAttendance12MonthID != -1
BEGIN
	DELETE FROM @PeopleCount
	INSERT INTO @PeopleCount
		SELECT
			 cp.person_id
			,att.number
			,cp.organization_id
			FROM core_person AS cp
			LEFT JOIN core_family_member AS cfm ON cfm.person_id = cp.person_id
			CROSS APPLY
			(
				SELECT COUNT(DISTINCT co.occurrence_start_time) AS number
					FROM core_occurrence_attendance AS coa
					LEFT JOIN core_occurrence AS co ON coa.occurrence_id = co.occurrence_id
					LEFT JOIN core_family_member AS cfm2 ON coa.person_id = cfm2.person_id
					WHERE cfm2.family_id = cfm.family_id
					  AND co.occurrence_start_time > DATEADD(MONTH, -12, GETDATE())
			) att
			LEFT JOIN core_person_attribute AS cpa ON cpa.person_id = cp.person_id AND cpa.attribute_id = @FamilyAttendance12MonthID
			WHERE (cpa.int_value != att.number OR cpa.int_value IS NULL)
			  AND DATEADD(DAY, @MinimumRecordExistence, cp.date_created) < GETDATE()

	WHILE EXISTS (SELECT * FROM @PeopleCount)
	BEGIN
		SELECT
			TOP 1
			@PersonID = person_id
			,@Count = number
			,@OrgID = organization_id
			FROM @PeopleCount

		DELETE @PeopleCount WHERE person_id = @PersonID

		EXEC dbo.core_sp_save_person_attribute @PersonID = @PersonID, @AttributeID = @FamilyAttendance12MonthID, @IntValue = @Count, @VarcharValue = '', @DateTimeValue = '', @DecimalValue = -1, @UserID = 'Update Attendance', @OrganizationId = @OrgID
	END
END


---------------------------------------------------------------------
--
-- Update FamilyContributions3MonthID
--
---------------------------------------------------------------------
IF @FamilyContributions3MonthID != -1
BEGIN
	DELETE FROM @PeopleCount
	INSERT INTO @PeopleCount
		SELECT
			 cp.person_id
			,att.number
			,cp.organization_id
			FROM core_person AS cp
			LEFT JOIN core_family_member AS cfm ON cfm.person_id = cp.person_id
			CROSS APPLY
			(
				SELECT COUNT(DISTINCT cc.contribution_date) AS number
					FROM ctrb_contribution AS cc
					LEFT JOIN core_family_member AS cfm2 ON cfm2.person_id = cc.person_id
					WHERE cfm2.family_id = cfm.family_id
					  AND cc.contribution_date > DATEADD(MONTH, -3, GETDATE())
			) att
			LEFT JOIN core_person_attribute AS cpa ON cpa.person_id = cp.person_id AND cpa.attribute_id = @FamilyContributions3MonthID
			WHERE (cpa.int_value != att.number OR cpa.int_value IS NULL)
			  AND DATEADD(DAY, @MinimumRecordExistence, cp.date_created) < GETDATE()

	WHILE EXISTS (SELECT * FROM @PeopleCount)
	BEGIN
		SELECT
			TOP 1
			@PersonID = person_id
			,@Count = number
			,@OrgID = organization_id
			FROM @PeopleCount

		DELETE @PeopleCount WHERE person_id = @PersonID

		EXEC dbo.core_sp_save_person_attribute @PersonID = @PersonID, @AttributeID = @FamilyContributions3MonthID, @IntValue = @Count, @VarcharValue = '', @DateTimeValue = '', @DecimalValue = -1, @UserID = 'Update Attendance', @OrganizationId = @OrgID
	END
END


---------------------------------------------------------------------
--
-- Update FamilyContributions6MonthID
--
---------------------------------------------------------------------
IF @FamilyContributions6MonthID != -1
BEGIN
	DELETE FROM @PeopleCount
	INSERT INTO @PeopleCount
		SELECT
			 cp.person_id
			,att.number
			,cp.organization_id
			FROM core_person AS cp
			LEFT JOIN core_family_member AS cfm ON cfm.person_id = cp.person_id
			CROSS APPLY
			(
				SELECT COUNT(DISTINCT cc.contribution_date) AS number
					FROM ctrb_contribution AS cc
					LEFT JOIN core_family_member AS cfm2 ON cfm2.person_id = cc.person_id
					WHERE cfm2.family_id = cfm.family_id
					  AND cc.contribution_date > DATEADD(MONTH, -6, GETDATE())
			) att
			LEFT JOIN core_person_attribute AS cpa ON cpa.person_id = cp.person_id AND cpa.attribute_id = @FamilyContributions6MonthID
			WHERE (cpa.int_value != att.number OR cpa.int_value IS NULL)
			  AND DATEADD(DAY, @MinimumRecordExistence, cp.date_created) < GETDATE()

	WHILE EXISTS (SELECT * FROM @PeopleCount)
	BEGIN
		SELECT
			TOP 1
			@PersonID = person_id
			,@Count = number
			,@OrgID = organization_id
			FROM @PeopleCount

		DELETE @PeopleCount WHERE person_id = @PersonID

		EXEC dbo.core_sp_save_person_attribute @PersonID = @PersonID, @AttributeID = @FamilyContributions6MonthID, @IntValue = @Count, @VarcharValue = '', @DateTimeValue = '', @DecimalValue = -1, @UserID = 'Update Attendance', @OrganizationId = @OrgID
	END
END


---------------------------------------------------------------------
--
-- Update FamilyContributions12MonthID
--
---------------------------------------------------------------------
IF @FamilyContributions12MonthID != -1
BEGIN
	DELETE FROM @PeopleCount
	INSERT INTO @PeopleCount
		SELECT
			 cp.person_id
			,att.number
			,cp.organization_id
			FROM core_person AS cp
			LEFT JOIN core_family_member AS cfm ON cfm.person_id = cp.person_id
			CROSS APPLY
			(
				SELECT COUNT(DISTINCT cc.contribution_date) AS number
					FROM ctrb_contribution AS cc
					LEFT JOIN core_family_member AS cfm2 ON cfm2.person_id = cc.person_id
					WHERE cfm2.family_id = cfm.family_id
					  AND cc.contribution_date > DATEADD(MONTH, -12, GETDATE())
			) att
			LEFT JOIN core_person_attribute AS cpa ON cpa.person_id = cp.person_id AND cpa.attribute_id = @FamilyContributions12MonthID
			WHERE (cpa.int_value != att.number OR cpa.int_value IS NULL)
			  AND DATEADD(DAY, @MinimumRecordExistence, cp.date_created) < GETDATE()

	WHILE EXISTS (SELECT * FROM @PeopleCount)
	BEGIN
		SELECT
			TOP 1
			@PersonID = person_id
			,@Count = number
			,@OrgID = organization_id
			FROM @PeopleCount

		DELETE @PeopleCount WHERE person_id = @PersonID

		EXEC dbo.core_sp_save_person_attribute @PersonID = @PersonID, @AttributeID = @FamilyContributions12MonthID, @IntValue = @Count, @VarcharValue = '', @DateTimeValue = '', @DecimalValue = -1, @UserID = 'Update Attendance', @OrganizationId = @OrgID
	END
END

END
--
-- End stored procedure
--
