SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

CREATE PROCEDURE pRemessaAer_Sel
(
@Num_Ref_RA		VarChar(12) 
)
AS
	Select 
		Ra.*, BCo.Nome_Banco as Banco, Age.Nome_Agencia as Agencia, PS.Apelido as Agente, 
		TMC.Nome_Tp_Moeda as Moeda_Conversao, TMF.Nome_Tp_Moeda as Moeda_Fechamento
	From 
		Remessa_Aer as RA Left Outer Join Banco as Bco on (RA.Cd_Banco = Bco.Cd_Banco)
		Left Outer Join Agencia as AGE on (RA.Cd_Banco = Age.Cd_Banco and RA.Cd_Agencia = Age.Cd_Agencia) 
		Left Outer Join Pessoa as PS on RA.Cd_Pes = PS.Cd_Pes 
		Left Outer Join Tipo_Moeda as TMC on RA.Cd_Tp_Moeda_C_RA = TMC.Cd_Tp_Moeda 
		Left Outer Join Tipo_Moeda as TMF on RA.Cd_Tp_Moeda_F_RA = TMF.Cd_Tp_Moeda 
	Where 
		Num_Ref_RA = @Num_Ref_RA

GO
