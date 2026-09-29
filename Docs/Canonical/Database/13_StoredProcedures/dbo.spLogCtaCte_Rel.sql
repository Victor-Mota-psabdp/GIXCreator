SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
 --spLogCtaCte_Rel 'IMUPL201509016BR'
CREATE Procedure [dbo].[spLogCtaCte_Rel]
		@Num_Proc	Varchar(16)
		
as

Select 
	Data_CC [Date],Nome_Usuario [UserName],TP_Oper_CC [I/A/E],Nome_tp_Tx,DC_CC [DC],Dt_Ins [Register Dt], 
	Nome_Tp_Moeda [Currency],Vlr_Org [Value],dt_prev_pgto [Due Dt], Desp_org_dst [Orig/Dest], PP.Apelido [Creditor/Debitor]	
	
From Log_cta_Cte L with(nolock)
	Join Usuario US with(nolock) on US.cd_usuario=L.cd_usuario
	Join Tipo_Taxa TT with(nolock) on TT.cd_tp_Tx=L.cd_tp_Tx
	Join Tipo_Moeda TM with(nolock) on TM.cd_tp_moeda=L.cd_tp_Moeda
	Join Pessoa PP with(nolock) on CD_pes=cd_cred_Dev
Where
	Num_Proc_CC=@Num_Proc
	order by Data_CC
Option (hash join)
	
	
	
GO
