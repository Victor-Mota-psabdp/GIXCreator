SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



CREATE  function fPgto(
			@proc varchar (16),
			@taxa varchar(3),
			@dc varchar(1)

		) RETURNS varchar(10)

AS

BEGIN
	Return
		(
		  SELECT Case left (@Proc,2)
			WHEN 'IA' THEN (SELECT dt_pgto_rcto_hia from caixa_hou_imp_aer where num_proc_hia=@proc and cd_tp_Tx=@taxa and dc_hia=@dc and num_lcto <> 'PROVISÓRIO')
			WHEN 'EA' THEN (SELECT dt_pgto_rcto_hea from caixa_hou_exp_aer where num_proc_hea=@proc and cd_tp_Tx=@taxa and dc_hea=@dc and num_lcto <> 'PROVISÓRIO')
			WHEN 'IM' THEN (SELECT dt_pgto_rcto_him from caixa_hou_imp_mar where num_proc_him=@proc and cd_tp_Tx=@taxa and dc_him=@dc and num_lcto <> 'PROVISÓRIO')
			WHEN 'EM' THEN (SELECT dt_pgto_rcto_hem from caixa_hou_exp_mar where num_proc_hem=@proc and cd_tp_Tx=@taxa and dc_hem=@dc and num_lcto <> 'PROVISÓRIO')
		  END
		)
END






GO
