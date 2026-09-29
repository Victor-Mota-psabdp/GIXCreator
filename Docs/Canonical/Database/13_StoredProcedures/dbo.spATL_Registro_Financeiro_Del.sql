SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--sp_help Registro_Financeiro
CREATE procedure [dbo].[spATL_Registro_Financeiro_Del]
(
	@Mes		varchar(2),
	@Ano		varchar(4),
	@Registro	varchar(6)
)
as
	if exists(select Num_Registro from Registro_Financeiro where Mes = @Mes and Ano = @Ano and Num_Registro= @Registro) 
		begin
			UPDATE Registro_Financeiro SET Ativo = 0 where Mes = @Mes and Ano = @Ano and Num_Registro= @Registro
		end

GO
