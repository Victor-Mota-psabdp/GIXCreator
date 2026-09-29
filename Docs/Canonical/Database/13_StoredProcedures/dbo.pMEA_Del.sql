SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO


CREATE PROCEDURE pMEA_Del 
(
@Num_Proc_MEA		varchar(14)
)
AS
-- Parâmetros de Retorno 
-- (-2)  Erro no processo de Inserção 
	If Exists(Select Num_Proc_MEA From Master_Exp_Aer Where Num_Proc_MEA = @Num_Proc_MEA)
		Begin 
			Delete
				Master_Exp_Aer
			Where
				Num_Proc_MEA = @Num_Proc_MEA
			Return 1 
		End 
	Else
		Return -1



GO
