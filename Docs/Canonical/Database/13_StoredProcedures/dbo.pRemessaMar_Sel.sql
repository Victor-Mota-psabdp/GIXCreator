SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

CREATE PROCEDURE pRemessaMar_Sel
(
@Num_Ref_RM		VarChar(12) 
)
AS
	Select 
		Rm.*, BCo.Nome_Banco as Banco, Age.Nome_Agencia as Agencia, PS.Apelido as Agente, 
		TMC.Nome_Tp_Moeda as Moeda_Conversao, TMF.Nome_Tp_Moeda as Moeda_Fechamento
	From 
		Remessa_Mar as Rm Left Outer Join Banco as Bco on (Rm.Cd_Banco = Bco.Cd_Banco)
		Left Outer Join Agencia as AGE on (Rm.Cd_Banco = Age.Cd_Banco and Rm.Cd_Agencia = Age.Cd_Agencia) 
		Left Outer Join Pessoa as PS on Rm.Cd_Pes = PS.Cd_Pes 
		Left Outer Join Tipo_Moeda as TMC on Rm.Cd_Tp_Moeda_C_RM = TMC.Cd_Tp_Moeda 
		Left Outer Join Tipo_Moeda as TMF on Rm.Cd_Tp_Moeda_F_RM = TMF.Cd_Tp_Moeda 
	Where 
		Num_Ref_RM = @Num_Ref_RM

GO
