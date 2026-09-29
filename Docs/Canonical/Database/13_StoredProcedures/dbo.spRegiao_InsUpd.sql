SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




CREATE     procedure [dbo].[spRegiao_InsUpd]

@Codigo varchar (3),
@Nome_reg varchar (30)

AS

Begin Transaction

	If Not exists(select cd_regiao from regiao where cd_regiao = @codigo)
		Begin
			Insert
					regiao
						(
							cd_regiao,
							nome_regiao
						)
			Values
				(	
					@codigo,
					@Nome_Reg
				)
		End
	Else
		
		Begin

			Update
				regiao
			set
				
				cd_regiao=@codigo,
				nome_regiao=@nome_reg
			Where
				cd_regiao = @codigo
		End
	
Commit Transaction






GO
