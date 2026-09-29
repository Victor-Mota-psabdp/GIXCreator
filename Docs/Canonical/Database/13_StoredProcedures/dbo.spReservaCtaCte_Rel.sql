SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO








CREATE	Procedure spReservaCtaCte_Rel 

		@Processo 	VarChar (16)

AS

		select 
			TT.Nome_Tp_Tx_Ing Nome_Taxa, 
			CC.Cd_Tp_Moeda, Vlr_Org_Hem  
		from 
			Cta_Cte_Hou_Exp_Mar CC

		Left Outer Join Tipo_Taxa TT on CC.Cd_Tp_Tx=TT.Cd_Tp_Tx
		Left Outer Join House_Exp_Mar HOU on @Processo = HOU.Num_Proc_Hem

		where 		
			CC.Num_Proc_Hem = @Processo and CC.Dc_Hem <> 'D' and HOU.Cd_Export_Hem = CC.Cd_Cred_Dev_Hem 







GO
