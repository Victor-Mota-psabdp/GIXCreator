SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



CREATE function fFaturaPG(
			@fatcod varchar (17)

		) RETURNS int

AS

BEGIN
	Return
		(
		  SELECT Case left (@fatcod,2)
			WHEN 'IA' THEN (
				
					Isnull((SELECT count(itf.cd_tp_Tx) from Item_Fat  ITF
					Left Join Caixa_Hou_Imp_AER CXA on num_proc=Num_proc_hia and itf.cd_tp_tx=cxa.cd_tp_tx
					where 
						fatcod=@fatcod and cxa.num_lcto is null),0)

					)
		  	WHEN 'EA' THEN (
				
					Isnull((SELECT count(itf.cd_tp_Tx) from Item_Fat  ITF
					Left Join Caixa_Hou_exp_AER CXA on num_proc=Num_proc_hea and itf.cd_tp_tx=cxa.cd_tp_tx
					where 
						fatcod=@fatcod and cxa.num_lcto is null),0)

					)

		  	WHEN 'EM' THEN (
				

					Isnull((SELECT count(itf.cd_tp_Tx) from Item_Fat  ITF
					Left Join Caixa_Hou_exp_maR CXA on num_proc=Num_proc_hem and itf.cd_tp_tx=cxa.cd_tp_tx
					where 
						fatcod=@fatcod and cxa.num_lcto is null),0)

					)
		  	WHEN 'IM' THEN (
				

					Isnull((SELECT count(itf.cd_tp_Tx) from Item_Fat  ITF
					Left Join Caixa_Hou_imp_maR CXA on num_proc=Num_proc_him and itf.cd_tp_tx=cxa.cd_tp_tx
					where 
						fatcod=@fatcod and cxa.num_lcto is null),0)

					)

		END


		)
END






GO
