SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[Taxas_IMEX] --'EMAKZ20081100201'
(
@Num_Proc varchar(16)
)
AS
BEGIN
		if left(@Num_proc,1)='I' 
			Begin
				select
					TX.Nome_tp_tx,
					CTA.dc_him,
					CTA.vlr_org_him,
					CTA.cd_tp_moeda

				from house_imp_mar HOU
					left join cta_cte_hou_imp_mar		CTA on CTA.num_proc_him = HOU.Num_proc_him
					left join tipo_taxa					TX on TX.cd_tp_tx = CTA.cd_tp_tx
					left join pessoa					PP on PP.cd_pes = HOU.cd_export_him

				group by
					TX.Nome_tp_tx,
					CTA.dc_him,
					CTA.vlr_org_him,
					CTA.cd_tp_moeda
		End
	else
		if left(@Num_proc,1)='E'	
			begin
				select
					TX.Nome_tp_tx,
					CTA.dc_hem,
					CTA.vlr_org_hem,
					CTA.cd_tp_moeda

				from house_Exp_mar HOU
					left join cta_cte_hou_Exp_mar		CTA on CTA.num_proc_hem = HOU.Num_proc_hem
					left join tipo_taxa					TX on TX.cd_tp_tx = CTA.cd_tp_tx
					left join pessoa					PP on PP.cd_pes = HOU.cd_export_hem
				
				group by
					TX.Nome_tp_tx,
					CTA.dc_hem,
					CTA.vlr_org_hem,
					CTA.cd_tp_moeda

		end
END

GO
