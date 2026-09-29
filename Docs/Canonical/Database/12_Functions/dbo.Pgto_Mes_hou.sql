SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE function Pgto_Mes_hou		(
		@Processo	varchar(16),
		@Taxa		varchar(3),
		@DC		varchar(1)
		)
	Returns
		Varchar(10)
	Begin
		Return
			(
			   select case left(@processo,2)
				When 'IA' then (select dt_pgto_rcto_hia from caixa_hou_imp_aer where num_proc_hia=@processo and cd_tp_tx=@Taxa and dc_hia=@DC and num_lcto <> 'PROVISÓRIO')
				When 'IM' then (select dt_pgto_rcto_him from caixa_hou_imp_mar where num_proc_him=@processo and cd_tp_tx=@Taxa and dc_him=@DC AND NUM_LCTO <> 'PROVISÓRIO')
				When 'EA' then (select dt_pgto_rcto_hea from caixa_hou_exp_aer where num_proc_hea=@processo and cd_tp_tx=@Taxa and dc_hea=@DC AND NUM_LCTO <> 'PROVISÓRIO')		
				When 'EM' then (select dt_pgto_rcto_hem from caixa_hou_exp_mar where num_proc_hem=@processo and cd_tp_tx=@Taxa and dc_hem=@DC AND NUM_LCTO <> 'PROVISÓRIO')
			   End
			)
		END


GO
