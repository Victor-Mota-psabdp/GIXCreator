SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[spATL_SincoServ_Rel]	--'2014-04-01','2014-04-30'
	@DtInicial datetime,
	@DtFinal datetime
as

select 
	Pais_local					[COUNTRY],
	P02.Numero_PO_HIM			[INVOICE],
	HAWB_HIM					[HAWB/BL NUMBER],
	HOU.num_proc_him			[JOB NUMBER],
	ETD_LIM						[DATE HBL],
	data_po_him					[DATE INVOICE],
	HOU.cd_tp_moeda				[ORIGINAL CURRENCY],
	vlr_frete_efet_him			[VALOR TOTAL DO HBL],
	vlr_frete_efet_him - vlr_org_him [VALOR TOTAL DA INVOICE],
	vlr_frete_efet_him - vlr_org_him [VALOR REMETIDO e ou RECEBIDO ORIGEM OU DESTINO],
	vlr_org_him					[VALOR - PROFIT/LOSS],
	Vlr_Pgto_NF_him				[VALOR EM R$ DO PROFIT (NFS)],
	B.RPS_NFE					[NUMERO DA NF ( PREFEITURA)],
	Num_Rcb_HIM					[Wire Number],
	DT_Pgto_Rcto_HIM			[Wire Date]	
from house_imp_mar HOU
	join llp_imp_mar LLP on LLP.num_proc_lim = num_proc_him	
	join Localidade Org on Org.cd_local = HOU.cd_org_him
	left join cta_cte_hou_imp_mar CTA on Cta.num_proc_him = Hou.num_proc_him
	join tipo_taxa TT on TT.cd_tp_tx = CTA.cd_tp_tx
	left join caixa_hou_imp_mar CXA on CXA.num_proc_him = CTA.num_proc_him and CXA.cd_tp_tx = CTA.cd_tp_tx and CXA.dc_him = CTA.dc_him	
	left join PO_HIM P02 on P02.num_proc_him = HOU.Num_proc_him and P02.id_dc = 2
	left join base_nota_fiscal B on B.nota_fiscal = CTA.num_nf_him and B.Ref_acesso = CTA.Ref_Acesso_NF_him	
where 
	--HOU.num_proc_him = 'IMJOH201304005BR'	and 
	pft_aer = 'S'	
	and convert(datetime,dt_emis_him, 103) between @DtInicial and @DtFinal 
	





/*	
select * from house_imp_mar where num_proc_him = 'IMCSR201408001BR'
left join pais
select * from localidade where cd_local = 'BCN'
select * from pais where cd_pais = 'ES'
select * from po_him where num_proc_him = 'IMCSR201408001BR'
select * from cta_cte_hou_imp_mar where num_proc_him = 'IMCSR201407001BR'
select VlR_Pgto_Rcto_Him from caixa_hou_imp_mar where num_proc_him = 'IMCSR201407001BR'
select * from tipo_taxa where nome_tp_tx like 'Divisão%'

[dbo].[fBusca_CaixaTaxaVlr](HOU.num_proc_him,'Divisão de Lucros%','D') [VALOR - PROFIT/LOSS],
Divisão de Lucros - Loss PSB
select * from vwcta_cte where cd_tp_tx = 'PSB'
select * from remessa_mar where num_ref_rm like 'rm2014%'
RM2014020008
select * from caixa_hou_imp_mar where num_rcb_him = 'RM2014010001'
*/
GO
