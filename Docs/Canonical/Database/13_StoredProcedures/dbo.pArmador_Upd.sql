SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[pArmador_Upd]
(
@Codigo 	Char(3)='', 
@Armador 	VarChar(30)='',
@Cd_Arm_Ofc	VarChar(4)=Null
)
AS
	If Exists(Select * From Armador Where Cd_Armador = @Codigo)
		Update
			 Armador 
		Set 
			Nome_Armador = @Armador,  
			Cd_Arm_Ofc = @Cd_Arm_Ofc
		Where 
			Cd_Armador = @Codigo 
	Else
		Return -1



GO
