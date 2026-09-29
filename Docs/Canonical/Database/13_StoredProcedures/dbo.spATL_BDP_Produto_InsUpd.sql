SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--sp_help BDP_Produto
CREATE PROCEDURE [dbo].[spATL_BDP_Produto_InsUpd]
(
	@ID_PD					Int,
	@Nome_BDP_Produto		varchar(50)
)
				

AS

Begin Transaction

	If  exists (select ID_PD from BDP_Produto where ID_PD=@ID_PD)
		Begin
			Update
				BDP_Produto
			Set
				Nome_BDP_Produto=@Nome_BDP_Produto
			Where
				ID_PD=@ID_PD
		End
	Else
		Begin
			Insert BDP_Produto
				(ID_PD,Nome_BDP_Produto)
			Values
				(@ID_PD,@Nome_BDP_Produto)
		End

Commit Transaction

GO
