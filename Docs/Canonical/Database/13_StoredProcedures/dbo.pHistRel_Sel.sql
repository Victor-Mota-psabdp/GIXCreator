SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

CREATE PROCEDURE pHistRel_Sel 
(
@Num_Proc	VarChar(16)
)
AS
		Select 
			HG.* , TOc.Nome_Tp_Ocor as Tipo_Ocor, US.Nome_Usuario as Usuario 
		From 
			Hist_Geral as HG 
			Join Tipo_Ocorrencia as TOc on TOc.Cd_Tp_Ocor = HG.Cd_Tp_Ocor 
			Join Usuario as US on US.Cd_Usuario = HG.Cd_Usuario
		Where 
			HSGProcesso = @Num_Proc
GO
