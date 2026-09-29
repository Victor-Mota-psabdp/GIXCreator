SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[spCentroCusto_InsUpd]

	@Cd_Centro_Custo char(5),
	@Nome_Centro_Custo varchar(30)

AS

Begin Transaction

	If  exists (select Cd_Centro_Custo from Centro_Custo where Cd_Centro_Custo=@Cd_Centro_Custo)
		Begin
			Update
				Centro_Custo
			Set
				Nome_Centro_Custo=@Nome_Centro_Custo
			Where
				Cd_Centro_Custo=@Cd_Centro_Custo
		End
	Else
		Begin
			Insert Centro_Custo
					(
					Cd_Centro_Custo,
					Nome_Centro_Custo
					)
			Values
					(
					@Cd_Centro_Custo,	
					@Nome_Centro_Custo
					)
		End

	IF @@Error <> 0
		BEGIN
			ROLLBACK TRANSACTION
			RETURN -1
		END

Commit Transaction





GO
