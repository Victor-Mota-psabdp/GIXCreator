SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE  function [dbo].[FBusca_ADTOTX1](
	@Num_Proc	varchar(16),	
	@nome_tp_tx	varchar(50),
	@Conta			Varchar(1)
)
RETURNS Float

BEGIN
	Declare @Resultado Float

	SET @Resultado=Isnull((
				SELECT sum(valor*paridade) Valor from adiantamento_cliente AC with (nolock)
				Join adiantamento_cliente_Det ACD with(nolock) on ACD.id=AC.id
				Join Tipo_taxa TT with (nolock) on tt.cd_tp_tx=ACD.cd_tp_Tx
				Where
					num_proc=@Num_PRoc
					And Nome_tp_Tx like @Nome_tp_Tx					
					and conta like @conta
				),0)

	RETURN @Resultado

END



GO
