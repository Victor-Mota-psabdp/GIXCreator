SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--sp_help Tipo_Regime_LI
CREATE PROCEDURE [dbo].[spATL_Tipo_Regime_LI_InsUpd]
(
	@ID_Regime_LI			int,
	@Regime_LI_Descricao	varchar(50)
)

AS

Begin Transaction

	If  exists (select ID_Regime_LI from Tipo_Regime_LI where ID_Regime_LI=@ID_Regime_LI)
		Begin
			Update
				Tipo_Regime_LI
			Set
				Regime_LI_Descricao=@Regime_LI_Descricao
			Where
				ID_Regime_LI=@ID_Regime_LI
		End
	Else
		Begin
			Insert Tipo_Regime_LI
				(ID_Regime_LI,Regime_LI_Descricao)
			Values
				(@ID_Regime_LI,@Regime_LI_Descricao)
		End

Commit Transaction

GO
