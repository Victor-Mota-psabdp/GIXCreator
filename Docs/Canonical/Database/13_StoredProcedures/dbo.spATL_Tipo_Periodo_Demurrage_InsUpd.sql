SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[spATL_Tipo_Periodo_Demurrage_InsUpd]
(
	@Cd_Periodo int,
	@Ds_Periodo varchar(50)
)
AS

Begin Transaction

	If  exists (select Cd_Periodo from Tipo_Periodo_Demurrage where Cd_Periodo=@Cd_Periodo)
	Begin
		Update
			Tipo_Periodo_Demurrage
		Set
			Ds_Periodo=@Ds_Periodo
		Where
			Cd_Periodo=@Cd_Periodo
	End
	Else
		Insert
			Tipo_Periodo_Demurrage(Cd_Periodo,Ds_Periodo)
		Values
			(@Cd_Periodo,@Ds_Periodo)
	

Commit Transaction





GO
