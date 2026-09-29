SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--1000
--select * from ATL_int.dbo.Layout_UserFieldDefinition where coduser ='ce'
--select * from  ATL_INT.dbo.LayoutField_Template Field where id not in 
--(select FK_IdField from ATL_int.dbo.Layout_UserFieldDefinition where coduser ='ce')

--insert into ATL_int.dbo.Layout_UserFieldDefinition
--select coduser,336 from ATL_int.dbo.Layout_UserFieldDefinition where coduser ='ce' and id = 1814

--336

CREATE Procedure [dbo].[ATL_INT_GridTemplateField_User_Sel]--'ras'
(
	@Coduser varchar(50)
)
 
AS
BEGIN
 
Select  (case when U.Coduser is null then 0 else 1 end) CheckBox, 
	Field.ID,   Field.PK_Code, Field.Name,Field.TypeField,Field.Path --,Field.CheckBox
From  
	ATL_INT.dbo.LayoutField_Template Field
left join ATL_int.dbo.Layout_UserFieldDefinition U on U.FK_IdField = Field.Id and U.Coduser = @Coduser
order by Field.PK_Code
END



--ALTER Procedure [dbo].[ATL_INT_GridTemplateField_Sel]
 
--AS
--BEGIN
 
--Select Field.ID,   Field.PK_Code, Field.Name,Field.TypeField,Field.Path,Field.CheckBox
--From  ATL_INT.dbo.LayoutField_Template Field
--order by 2
--END

GO
