SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE pHistoricoGer_Sel 
(
@Refer_Hist		VarChar(16)
)
AS
	Select 
		*
	From 
		Historico_Geral as HG Join Tipo_Ocorrencia as Toc on HG.Cd_Tp_Ocor = Toc.Cd_Tp_Ocor 
		Join Usuario as Usr on HG.Cd_Usuario = Usr.Cd_Usuario 
	Where
		Refer_Hist = @Refer_Hist
	Order by 
		Dt_Hist Desc

GO
