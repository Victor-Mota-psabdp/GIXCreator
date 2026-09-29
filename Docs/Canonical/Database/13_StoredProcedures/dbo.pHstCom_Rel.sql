SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

CREATE PROCEDURE pHstCom_Rel 
(
@Num_Proc	VarChar(16)
)
AS
	Select 
		HG.* , TOc.Nome_Tp_Ocor as Tipo_Ocor, US.Nome_Usuario as Usuario, Cli.Apelido as Cliente
	From 
		Hst_Com as HG 
		Join Tipo_Ocorrencia as TOc on TOc.Cd_Tp_Ocor = HG.Cd_Tp_Ocor 
		Join Usuario as US on US.Cd_Usuario = HG.Cd_Usuario
		Join Pessoa as Cli on Cli.Cd_Pes = HG.Cd_Pes
	Where 
		Refer_Hist = @Num_Proc or Refer_Hist = @Num_Proc

GO
