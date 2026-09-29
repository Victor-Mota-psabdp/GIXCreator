SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

CREATE PROCEDURE [dbo].[pRemessaAerCapaNew_Sel]
(
@Num_Ref_RA		VarChar(12),
@StrMachine		Varchar(20)
)
AS
	Select 
		Ra.Num_Ref_RA, Dt_Oper_RA, Tx_Fchto_RA, Vlr_tOT_Fchto_RA, BCo.Nome_Banco as Banco, Age.Nome_Agencia as Agencia, PS.Apelido as Agente, 
		TMC.Nome_Tp_Moeda as Moeda_Conversao, TMF.Nome_Tp_Moeda as Moeda_Fechamento, Cd_Tp_Moeda_C_RA, sum(remitance_moeda) total_moeda
	From 
		Remessa_Aer as RA Left Outer Join Banco as Bco on (RA.Cd_Banco = Bco.Cd_Banco)
		Left Outer Join Agencia as AGE on (RA.Cd_Banco = Age.Cd_Banco and RA.Cd_Agencia = Age.Cd_Agencia) 
		Left Outer Join Pessoa as PS on RA.Cd_Pes = PS.Cd_Pes 
		Left Outer Join Tipo_Moeda as TMC on RA.Cd_Tp_Moeda_C_RA = TMC.Cd_Tp_Moeda 
		Left Outer Join Tipo_Moeda as TMF on RA.Cd_Tp_Moeda_F_RA = TMF.Cd_Tp_Moeda 
		Left Join Tmp_Plan_Rem_New TPR on StrMachine = @StrMachine
	Where 
		Num_Ref_RA = @Num_Ref_RA
	group by 
		Ra.Num_Ref_RA, Dt_Oper_RA, Tx_Fchto_RA, Vlr_Tot_Fchto_RA, BCo.Nome_Banco, Age.Nome_Agencia, PS.Apelido, 
		TMC.Nome_Tp_Moeda, TMF.Nome_Tp_Moeda, Cd_Tp_Moeda_C_RA		


GO
