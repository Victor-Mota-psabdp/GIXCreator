SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[spATLAXDailyChecking_Rel] --[dbo].[spATLAXDailyChecking_Rel]  '10-01-2013','10-31-2013'

@DataInicial Datetime,
@DataFinal	Datetime

		
AS



Select I.Num_Proc [Job Number],Cd_AX, min(fatdtemissao) [Dt Document],sum(dbo.valor(vlr_pgto_nf_hia,dc)),0,sum(dbo.valor(vlr_pgto_nf_hia,dc)),((porcentagem+IRRF)/100)*sum(dbo.valor(vlr_pgto_nf_hia,dc))   from fatura FAT with(nolock)
Join item_Fat I with(nolock) on I.fatcod=fat.fatcod
Join vwcta_Cte cta with(nolock) on cta.num_proc_hia=I.num_proc and cta.cd_Tp_tx=I.cd_Tp_TX and Cta.dc_hia=I.dc
Join Base_Nota_Fiscal NF with(nolock) on NF.ref_Acesso=ref_acesso_nf_hia and nota_fiscal=num_nf_hia
Join vwcliente C with(nolock) on c.num_proc=cta.num_proc_hia
Join Pessoa_ATL_AX P with(nolock) on P.cd_pes=cd_cliente and P.tipo='C'
Join dbo.Base_Nota_Fiscal_AX_TAX_GROUP B with(nolock) on B.nota_fiscal=NF.nota_Fiscal and B.ref_Acesso=NF.ref_Acesso
join dbo.Tipo_Tax_AX TA with(nolock) on TA.cd_tax_ax=B.Tax_Group
Where  convert(datetime,convert(varchar(10),fatdtemissao,105),105) between @DataInicial and @DataFinal
AND  len(fat.fatcod)=17 	and (fatstatus <> 0 and dt_canc is null or dt_canc >@DataFinal and fatstatus =0)
group by I.Num_Proc,Cd_AX,porcentagem,irrf

union all

Select RI.Num_Proc [Job Number],Cd_AX, min(convert(datetime,dt_ins_hia,105)) [Dt Document],0,sum(dbo.valor(vlr_org_hia* ISNULL(PAR.Par_Moeda,1) ,dc)),sum(dbo.valor(vlr_org_hia* ISNULL(PAR.Par_Moeda,1) ,dc)) , 0 From registro_Financeiro_item RI with(nolock)
Join vwcliente C with(nolock)  on c.num_proc=RI.num_proc
Join Pessoa_ATL_AX P with(nolock) on P.cd_pes=cd_cliente and P.tipo='C'
Join REgistro_Financeiro RF with(nolock) on RF.mes=RI.mes and RF.ano=RI.ano and RF.num_registro=RI.num_registro
Join vwctA_cte CTA with(nolock) on CTA.num_proc_hia=ri.num_proc and rI.dc=cta.dc_hia and rI.cd_Tp_tx=cta.cd_tp_tx
Left Join Paridade PAR with(nolock) on PAR.Cd_Tp_Moeda = cta.Cd_Tp_Moeda and Cd_Tp_Par = 'OFC' and Dt_Par = dt_ins_hia


where 
convert(Datetime,dt_ins_hia,105) between @DataInicial and @DataFinal
and ativo=1
group by rI.Num_Proc,Cd_AX


Union all

Select Num_Proc [Job Number],cd_Pessoa_Ax,dt_canc [Dt_Document],dbo.valor(valor*paridade,dc)*-1,0,dbo.valor(valor*paridade,dc)*-1,0 from ax_doc AX
Join Ax_doc_Item AXI on AXI.id_ax=AX.id_Ax

Where
	dt_canc between @DataInicial and @DataFinal
	and 	month(Dt_Canc) <> month(dt_ins) and right(cd_Tp_tx,1)='2'
GO
