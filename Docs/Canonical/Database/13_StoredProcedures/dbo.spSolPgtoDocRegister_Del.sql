SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE procedure [dbo].[spSolPgtoDocRegister_Del]

	@ID				BigInt,
	@Ano			int,
	@Mes			int	

as

	Declare @Num_Register	varchar(6)	
	set @Num_Register = (Select Num_Registro from Sol_Pgto_Cta_Cte where ID=@ID)

	update 
		Registro_Financeiro
	set	
		ativo = 0		
	where 
		num_registro = @Num_Register 
		and Mes = @Mes 
		and Ano = @Ano
			
	
		

	
	

GO
