SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO



CREATE PROCEDURE [dbo].[pAeKContCtaCteExc_Sel] 
(
@Ano		VarChar(4),
@Mes 		Char(2)
)
AS
	Select 
		Cte.*, TT.Nome_Tp_Tx Desc_Taxa, Cli.Nome_Raz_Soc Cred_Dev
	From 
		Log_Cta_Cte  Cte Join Tipo_Taxa TT on TT.Cd_tp_Tx = Cte.Cd_Tp_Tx 
		Join Pessoa Cli on Cli.Cd_Pes = Cte.Cd_Cred_Dev
	Where 
		DESP_ORG_DST = 'N' and Cte.Cd_Tp_Tx not in (Select Cd_Tp_Tx From Param_AekContabil_Taxas_Exc) and 
		month(convert(datetime, cte.data_cc, 105)) = @Mes and year(convert(datetime, cte.data_cc, 105)) = @Ano and 
		substring(cte.num_proc_cc, 3,3) <> 'JOB' and (Vlr_Contab is Not Null and Vlr_Contab  > 0) and left(cte.cd_tp_tx, 1) <> 'X'
GO
