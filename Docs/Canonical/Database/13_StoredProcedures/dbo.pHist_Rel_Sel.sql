SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

CREATE PROCEDURE pHist_Rel_Sel 
(
@Num_Proc	VarChar(16)
)
AS
	Declare @Num_Proc_H 		VarChar(16)

	If Left(@Num_Proc, 2) = 'EA'
		Set @Num_Proc_H = IsNull((Select Num_Proc_HEA From House_Exp_Aer Where JOB_HEA = @Num_Proc ), @Num_Proc)

	If Left(@Num_Proc, 2) = 'EM'
		Set @Num_Proc_H = IsNull((Select Num_Proc_HEM From House_Exp_Mar Where JOB_HEM = @Num_Proc ), @Num_Proc)

	If Left(@Num_Proc, 2) = 'IA'
		Set @Num_Proc_H = IsNull((Select Num_Proc_HIA From House_Imp_Aer Where JOB_HIA = @Num_Proc ), @Num_Proc)

	If Left(@Num_Proc, 2) = 'IM'
		Set @Num_Proc_H = IsNull((Select Num_Proc_HIM From House_Imp_Mar Where JOB_HIM = @Num_Proc ), @Num_Proc)	

		Select 
			HG.* , TOc.Nome_Tp_Ocor as Tipo_Ocor, US.Nome_Usuario as Usuario 
		From 
			Historico_Geral as HG 
			Join Tipo_Ocorrencia as TOc on TOc.Cd_Tp_Ocor = HG.Cd_Tp_Ocor 
			Join Usuario as US on US.Cd_Usuario = HG.Cd_Usuario
		Where 
			Refer_Hist = @Num_Proc or Refer_Hist = @Num_Proc_H

GO
