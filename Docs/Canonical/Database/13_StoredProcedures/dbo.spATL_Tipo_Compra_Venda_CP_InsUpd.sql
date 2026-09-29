SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--sp_help Tipo_Compra_Venda_CP
CREATE PROCEDURE [dbo].[spATL_Tipo_Compra_Venda_CP_InsUpd]
(
	@Cd_CV		char(1),
	@Descricao_CV	varchar(30))

AS

Begin Transaction

	If  exists (select Cd_CV from Tipo_Compra_Venda_CP where Cd_CV=@Cd_CV)
		Begin
			Update
				Tipo_Compra_Venda_CP
			Set
				Descricao_CV=@Descricao_CV
			Where
				Cd_CV=@Cd_CV
		End
	Else
		Begin
			Insert Tipo_Compra_Venda_CP
				(Cd_CV,Descricao_CV)
			Values
				(@Cd_CV,@Descricao_CV)
		End

Commit Transaction

GO
