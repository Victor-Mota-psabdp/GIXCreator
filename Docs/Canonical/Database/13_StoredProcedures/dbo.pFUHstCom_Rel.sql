SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

CREATE PROCEDURE pFUHstCom_Rel 

AS
	Select 
		HG.* , TOc.Nome_Tp_Ocor as Tipo_Ocor, US.Nome_Usuario as Usuario, Cli.Apelido as Cliente
	From 
		Hst_Com as HG 
		Join Tipo_Ocorrencia as TOc on TOc.Cd_Tp_Ocor = HG.Cd_Tp_Ocor 
		Join Usuario as US on US.Cd_Usuario = HG.Cd_Usuario
		Join Pessoa as Cli on Cli.Cd_Pes = HG.Cd_Pes
		Join Proposta_Imp_Mar as PIM on PIM.Num_Prop_IM = HG.Refer_Hist 
	Where 
		Left(Refer_Hist, 2) = 'IM' and 
		PIM.Dt_Fchto_PIM Is Null or PIM.Dt_Fchto_PIM = '' and PIM.Cancel_PIM = 'N'

	Union 

	Select 
		HG.* , TOc.Nome_Tp_Ocor as Tipo_Ocor, US.Nome_Usuario as Usuario, Cli.Apelido as Cliente
	From 
		Hst_Com as HG 
		Join Tipo_Ocorrencia as TOc on TOc.Cd_Tp_Ocor = HG.Cd_Tp_Ocor 
		Join Usuario as US on US.Cd_Usuario = HG.Cd_Usuario
		Join Pessoa as Cli on Cli.Cd_Pes = HG.Cd_Pes
		Join Proposta_Imp_Aer as PIA on PIA.Num_Prop_IA = HG.Refer_Hist 
	Where 
		Left(Refer_Hist, 2) = 'IA' and 
		PIA.Dt_Fchto_PIA Is Null or PIA.Dt_Fchto_PIA = '' and PIA.Cancel_PIA = 'N'

	Union 

	Select 
		HG.* , TOc.Nome_Tp_Ocor as Tipo_Ocor, US.Nome_Usuario as Usuario, Cli.Apelido as Cliente
	From 
		Hst_Com as HG 
		Join Tipo_Ocorrencia as TOc on TOc.Cd_Tp_Ocor = HG.Cd_Tp_Ocor 
		Join Usuario as US on US.Cd_Usuario = HG.Cd_Usuario
		Join Pessoa as Cli on Cli.Cd_Pes = HG.Cd_Pes
		Join Proposta_Exp_Mar as PEM on PEM.Num_Prop_EM = HG.Refer_Hist 
	Where 
		Left(Refer_Hist, 2) = 'EM' and 
		PEM.Dt_Fchto_PEM Is Null or PEM.Dt_Fchto_PEM = '' and PEM.Cancel_PEM = 'N'

	Union 

	Select 
		HG.* , TOc.Nome_Tp_Ocor as Tipo_Ocor, US.Nome_Usuario as Usuario, Cli.Apelido as Cliente
	From 
		Hst_Com as HG 
		Join Tipo_Ocorrencia as TOc on TOc.Cd_Tp_Ocor = HG.Cd_Tp_Ocor 
		Join Usuario as US on US.Cd_Usuario = HG.Cd_Usuario
		Join Pessoa as Cli on Cli.Cd_Pes = HG.Cd_Pes
		Join Proposta_Exp_Aer as PEA on PEA.Num_Prop_EA = HG.Refer_Hist 
	Where 
		Left(Refer_Hist, 2) = 'EA' and 
		PEA.Dt_Fchto_PEA Is Null or PEA.Dt_Fchto_PEA = '' and PEA.Cancel_PEA = 'N'

GO
