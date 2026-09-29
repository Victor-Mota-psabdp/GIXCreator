SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



CREATE function [dbo].[FDemurrage_Fat](
				@Processo varchar(16)--,
--				@Data	Datetime
)
RETURNS float
BEGIN
		Declare @Real Float
		Declare @Resultado Float
		Declare @Outras Float

		Set @Real=Isnull((select sum(Isnull(vlr_org_him,0)) from cta_cte_hou_imp_mar where num_proc_him=@processo and cd_tp_tx in (select cd_tp_tx from tipo_taxa where cd_tp_tx_ofc='DEM')  and dc_him='C' and cd_tp_moeda='REL' and desp_org_him='N'),0)
		
		Set @Outras=Isnull((select sum(Isnull(vlr_org_him,0)) from cta_cte_hou_imp_mar CTA Left Join Paridade PAR on CTA.cd_tp_moeda=PAR.cd_tp_moeda and PAR.cd_tp_par='OFC' and convert(datetime, PAR.dt_par,105)=getdate() where num_proc_him=@processo and cd_tp_tx in (select cd_tp_tx from tipo_taxa where cd_tp_tx_ofc='DEM') and dc_him='C' and cta.cd_tp_moeda<>'REL' and desp_org_him='N'),0)
		Set @Resultado=@Real+@Outras
RETURN @resultado

END





GO
