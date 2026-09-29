SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[pArmador_Ins] 
(
@Codigo 	Char(3)='', 
@Armador 	VarChar(30)='',
@Cd_Arm_Ofc	Varchar(4)=Null
)
AS
	If Not Exists(Select * From Armador Where Cd_Armador = @Codigo)
		Insert Into Armador 
			(Cd_Armador, Nome_Armador, Cd_Arm_Ofc) 
		Values 
			(@Codigo, @Armador, @Cd_Arm_Ofc) 
	Else 
		Return -1



GO
