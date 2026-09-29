SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO


/****** Object:  Stored Procedure dbo.pQtdHouMas_Sel    Script Date: 17/10/2002 07:32:51 ******/
CREATE PROCEDURE pQtdHouMas_Sel
(
@Processo	VarChar(16), 
@Tipo		Char(2) 
)
 AS
	If @Tipo = 'EM'
		Select  
			Count (*) As Houses 
		From 
			House_Exp_Mar 
		Where 
			Num_Proc_MEM = @Processo
	If @Tipo = 'IM'
		Select 
			Count (*) as Houses
		From 
			House_Imp_Mar
		Where
			Num_Proc_MIM = @Processo
	If @Tipo = 'IA'
		Select 
			Count (*) as Houses
		From 
			House_Imp_Aer
		Where
			Num_Proc_MIA = @Processo
	If @Tipo = 'EA'
		Select 
			Count (*) as Houses
		From 
			House_Exp_Aer
		Where
			Num_Proc_MEA = @Processo



GO
