SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE	PROCEDURE [dbo].[spAdiantamentoClienteDet_Sel] --'EMARG20080600101'

	@Processo 	varchar(16),
	@ID			int

AS
	SELECT
		TT.Nome_tp_tx Taxa, TM.Nome_Tp_Moeda Moeda, Valor, ACD.Paridade, ACD.Conta
	FROM
		Adiantamento_Cliente AC
		Join Adiantamento_Cliente_Det ACD on ACD.ID = AC.ID
		Join Tipo_Taxa TT	on ACD.cd_tp_tx = TT.cd_tp_tx
		Join Tipo_moeda TM on ACD.cd_tp_moeda = TM.cd_tp_moeda
	WHERE
		AC.Num_Proc = @Processo and AC.ID = @ID

GO
