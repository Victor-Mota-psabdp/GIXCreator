SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO


CREATE PROCEDURE pProcessosSVia_Sel 
(
@ID_Viagem	Int,
@ID_Machine	VarChar(30)
)
AS
	Select 
		Num_Proc_MIM as Processo 
	From 
		Master_Imp_Mar as MIM 
	Where 
		MIM.ID_Viagem = @ID_Viagem and 
		MIM.Num_Proc_MIM Not In 
		(Select Num_Proc From Eventos_Master as EM Join Eventos as EV on EM.Arquivo_Eve = EV.Arquivo_Eve Where Status_Eve = 'A' OR Status_Eve = 'E') and 
		MIM.Num_Proc_MIM Not In 
		(Select Tmp_Processo From Tmp_Manifesto Where Tmp_ID_Machine = @ID_Machine)
	Union 
	Select 
		Num_Proc_MEM as Processo 
	From 
		Master_Exp_Mar as MEM 
	Where 
		MEM.ID_Viagem = @ID_Viagem and 
		MEM.Num_Proc_MEM Not In 
		(Select Num_Proc From Eventos_Master as EM Join Eventos as EV on EM.Arquivo_Eve = EV.Arquivo_Eve Where Status_Eve = 'A' or Status_Eve = 'E') and
		MEM.Num_Proc_MEM Not In 
		(Select Tmp_Processo From Tmp_Manifesto Where Tmp_ID_Machine = @ID_Machine)
	Order by 
		Processo



GO
