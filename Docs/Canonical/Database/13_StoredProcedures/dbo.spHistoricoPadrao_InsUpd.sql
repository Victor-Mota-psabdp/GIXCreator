SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create PROCEDURE [dbo].[spHistoricoPadrao_InsUpd]

	@Cd_Hist_Pdr char(5),
	@Nome_Hist_Pdr varchar(30)

AS

Begin Transaction

	If  exists (select Cd_Hist_Pdr from Historico_Padrao where Cd_Hist_Pdr=@Cd_Hist_Pdr)
		Begin
			Update
				Historico_Padrao
			Set
				Nome_Hist_Pdr=@Nome_Hist_Pdr
			Where
				Cd_Hist_Pdr=@Cd_Hist_Pdr
		End
	Else
		Begin
			Insert Historico_Padrao
					(
					Cd_Hist_Pdr,
					Nome_Hist_Pdr
					)
			Values
					(
					@Cd_Hist_Pdr,	
					@Nome_Hist_Pdr
					)
		End

	IF @@Error <> 0
		BEGIN
			ROLLBACK TRANSACTION
			RETURN -1
		END

Commit Transaction


GO
