SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE Procedure spCaixa_Del
	(
		@Num_Lcto varchar(12)
	)
AS

	Delete caixa_hou_imp_aer where num_lcto=@num_lcto

	Delete caixa_hou_exp_aer where num_lcto=@num_lcto
	
	Delete caixa_hou_imp_out where num_lcto=@num_lcto

	Delete caixa_hou_exp_out where num_lcto=@num_lcto

	Delete caixa_hou_imp_mar where num_lcto=@num_lcto

	Delete caixa_hou_exp_mar where num_lcto=@num_lcto



GO
