SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



CREATE Procedure [dbo].[spINTSmartVendedor_Sel]
			@Num_Proc	Varchar(16)

AS

Select 
	Nome_Usuario 
From 
	Job_Exp_Mar with(nolock)
	Join Usuario Us with(nolock) on US.cd_usuario=cd_Vendedor
Where
	Num_Proc_Hem=@Num_Proc


Union all


Select 
	Nome_Usuario 
From 
	Job_Exp_Aer with(nolock)
	Join Usuario Us  with(nolock) on US.cd_usuario=cd_Vendedor
Where
	Num_Proc_Hea=@Num_Proc


union all

Select 
	Nome_Usuario 
From 
	Job_Imp_Aer with(nolock)
	Join Usuario Us with(nolock) on US.cd_usuario=cd_Vendedor
Where
	Num_Proc_Hia=@Num_Proc


Union all

Select 
	Nome_Usuario 
From 
	Job_Imp_MAr with(nolock)
	Join Usuario Us with(nolock) on US.cd_usuario=cd_Vendedor
Where
	Num_Proc_Him=@Num_Proc

union all

Select 
	Nome_Usuario 
From 
	LLP_Imp_Out with(nolock)
	Join Usuario Us with(nolock) on US.cd_usuario=cd_Vendedor
Where
	Num_Proc_lio=@Num_Proc

union all

Select 
	Nome_Usuario 
From 
	LLP_Exp_Out with(nolock)
	Join Usuario Us with(nolock) on US.cd_usuario=cd_Vendedor
Where
	Num_Proc_leo=@Num_Proc


GO
