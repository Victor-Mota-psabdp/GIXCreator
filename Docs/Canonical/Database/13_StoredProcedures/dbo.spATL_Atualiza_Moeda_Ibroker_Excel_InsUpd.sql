SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[spATL_Atualiza_Moeda_Ibroker_Excel_InsUpd]
(
	@num_proc as varchar(16),
	@SIGLAMOEDA as varchar(3),
	@Tipo as varchar(30)
)
as

Declare @cd_moeda varchar(3)
set @cd_moeda = (select top 1 Cd_Tp_Moeda Cd_Tp_Moeda from Tipo_Moeda with(nolock) where Cod_Nac_Moeda=@SIGLAMOEDA )

if @cd_moeda is not null
	BEGIN
		EXEC spATL_CamposAdicionais_InsUpd @Num_Proc, @Tipo,@cd_moeda, 'ATL'
	END
	

	
GO
