SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--sp_help Tipo_Lancamento_RF
CREATE procedure [dbo].[spATL_Tipo_Lancamento_RF_Del]
(
	@Cd_Tipo_Lanc				varchar(1)
)
as
	if exists(select Cd_Tipo_Lanc from Tipo_Lancamento_RF where Cd_Tipo_Lanc= @Cd_Tipo_Lanc) 
	begin
		UPDATE Tipo_Lancamento_RF SET Ativo = 'N' where Cd_Tipo_Lanc= @Cd_Tipo_Lanc
	end

GO
