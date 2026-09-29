SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO


CREATE PROCEDURE pVg_Proc_Via_Sel
(
@Id_Viagem	Int,
@Modal	Char(1) 
)
AS
	If @Modal = 'I'
		Select 
			Num_Proc_HIM 
		From 
			House_Imp_Mar 
		Where 
			ID_Viagem = @ID_Viagem and 
			Num_Proc_HIM Not In 
			(Select Num_Proc From Eventos_Master as EM Join Eventos as EV on EM.Arquivo_Eve = EV.Arquivo_Eve Where Status_Eve = 'A' OR Status_Eve = 'E') 
	Else 
		Select 
			Num_Proc_HEM 
		From 
			House_Exp_Mar 
		Where 
			ID_Viagem = @ID_Viagem and 
			Num_Proc_HEM Not In 
			(Select Num_Proc From Eventos_Master as EM Join Eventos as EV on EM.Arquivo_Eve = EV.Arquivo_Eve Where Status_Eve = 'A' OR Status_Eve = 'E') 



GO
