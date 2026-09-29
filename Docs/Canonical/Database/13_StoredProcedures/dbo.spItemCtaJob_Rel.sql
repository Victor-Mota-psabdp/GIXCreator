SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE Procedure [dbo].[spItemCtaJob_Rel]--'ATL','IM','01-09-2011','01-09-2011'

		@grupo			varchar(3),
		@MODAL			CHAR(2),
		@DataInicial	varchar(10),
		@DataFinal		varchar(10)

AS

	IF @MODAL = 'IM'

		Begin

			select 
				Num_Proc_Lim Job,nome_tp_tx Taxa,cta.dc_him dc, convert(datetime,dt_prev_pgto_him,105) [Data Prev.],cta.Cd_Tp_Moeda, vlr_org_him [Valor Em Moeda],
				[dbo].[FConverterMoeda](cta.cd_tp_moeda,'REL')*vlr_org_him [Valor em Reais],ATA_LIM [ATA/ATD],isnull(num_lcto,'Em Aberto') Status
			 from llp_imp_mar
				Join cta_Cte_hou_imp_mar cta on cta.num_proc_him=num_proc_lim
				Join Tipo_Taxa TT on TT.cd_tp_tx=cta.cd_tp_TX
				join Pessoa P on P.cd_pes = CTA.cd_cred_dev_him	
				Left Join vwcxas CXA on cta.num_proc_him=cxa.num_proc_hia and cta.cd_tp_Tx=cxa.cd_tp_tx and cta.dc_him=cxa.dc_hia and num_lcto <> 'PROVISORIO'
			Where			
				ATA_LIM between convert(datetime,@DataInicial,105) and convert(datetime,@DataFinal,105)
				and right(left(num_proc_lim,5),3) = @grupo			
		
--		union all
--		
--			select 
--				Num_Proc_MASTER Job,nome_tp_tx Taxa,cta.dc_mim dc, convert(datetime,dt_prev_pgto_mim,105) [Data Prev.],cta.Cd_Tp_Moeda, vlr_org_mim [Valor Em Moeda],
--				[dbo].[FConverterMoeda](cta.cd_tp_moeda,'REL')*vlr_org_mim [Valor em Reais],ATA_Master [ATA/ATD],isnull(cxa.num_lcto,'Em Aberto') Status
--			from llp_MASTER
--				Join cta_Cte_mas_imp_mar cta on cta.num_proc_mim=num_proc_master
--				Join Tipo_Taxa TT on TT.cd_tp_tx=cta.cd_tp_TX
--				join Pessoa P on P.cd_pes = CTA.cd_cred_dev_mim	
--				Left Join caixa_mas_imp_mar CXA on cta.num_proc_mim=cxa.num_proc_mim and cta.cd_tp_Tx=cxa.cd_tp_tx and cta.dc_mim=cxa.dc_mim and cxa.num_lcto <> 'PROVISORIO'
--			Where			
--				ATA_master between convert(datetime,@DataInicial,105) and convert(datetime,@DataFinal,105)
--				and left(num_proc_master,2) = @modal			
		End
	Else
		Begin
			select 
				Num_Proc_Lem Job,nome_tp_tx Taxa,cta.dc_hem dc, convert(datetime,dt_prev_pgto_hem,105) [Data Prev.],cta.Cd_Tp_Moeda, vlr_org_hem [Valor Em Moeda],
				[dbo].[FConverterMoeda](cta.cd_tp_moeda,'REL')*vlr_org_hem [Valor em Reais],ATA_LeM [ATA/ATD],isnull(num_lcto,'Em Aberto') Status
			 from llp_exp_mar
				Join cta_Cte_hou_exp_mar cta on cta.num_proc_hem=num_proc_lem
				Join Tipo_Taxa TT on TT.cd_tp_tx=cta.cd_tp_TX
				join Pessoa P on P.cd_pes = CTA.cd_cred_dev_hem	
				Left Join vwcxas CXA on cta.num_proc_hem=cxa.num_proc_hia and cta.cd_tp_Tx=cxa.cd_tp_tx and cta.dc_hem=cxa.dc_hia and num_lcto <> 'PROVISORIO'
			Where
				ATA_LEM between convert(datetime,@DataInicial,105) and convert(datetime,@DataFinal,105)
				and right(left(num_proc_lem,5),3) = @grupo	

--	UNION ALL
--		
--			select 
--				Num_Proc_MASTER Job,nome_tp_tx Taxa,cta.dc_mem dc, convert(datetime,dt_prev_pgto_mem,105) [Data Prev.],cta.Cd_Tp_Moeda, vlr_org_mem [Valor Em Moeda],
--				[dbo].[FConverterMoeda](cta.cd_tp_moeda,'REL')*vlr_org_mem [Valor em Reais],ATA_Master [ATA/ATD],isnull(cxa.num_lcto,'Em Aberto') Status
--			from llp_MASTER
--				Join cta_Cte_mas_exp_mar cta on cta.num_proc_mem=num_proc_master
--				Join Tipo_Taxa TT on TT.cd_tp_tx=cta.cd_tp_TX
--				join Pessoa P on P.cd_pes = CTA.cd_cred_dev_mem	
--				Left Join caixa_mas_exp_mar CXA on cta.num_proc_mem=cxa.num_proc_mem and cta.cd_tp_Tx=cxa.cd_tp_tx and cta.dc_mem=cxa.dc_mem and cxa.num_lcto <> 'PROVISORIO'
--			Where			
--				ATA_master between convert(datetime,@DataInicial,105) and convert(datetime,@DataFinal,105)
--				and left(num_proc_master,2) = @Modal
		End

GO
