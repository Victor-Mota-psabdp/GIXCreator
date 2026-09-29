SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[spATL_AjusteTemp_Sel] 

AS

select 
	--CTA.Num_Proc_HIA num_proc_hia ,
	CTA.Num_Proc_HIA num_proc_hia ,
	--CTA.Num_Proc_HIO num_proc_hia ,
	
	CTA.Cd_Tp_Tx, 
	
	--CTA.Vlr_Org_HIA vlr_pgto_Rcto_hia
	CTA.Vlr_Org_HIA vlr_pgto_Rcto_hia
	--CTA.Vlr_Org_HIO vlr_pgto_Rcto_hia
	
 --from Cta_Cte_Hou_Imp_Aer CTA
 from vwcta_cte CTA
  --from Cta_Cte_Hou_Imp_Out CTA
  --join custo_dow_temp CDT on CTA.Num_Proc_HIA = CDT.Num_proc
	--left join Custo_Cliente CC on CC.Num_Proc = CTA.Num_Proc_HIA and CC.Cd_Tp_Tx = CTA.Cd_Tp_Tx
	left join Custo_Cliente CC on CC.Num_Proc = CTA.Num_Proc_HIA and CC.Cd_Tp_Tx = CTA.Cd_Tp_Tx
	--left join Custo_Cliente CC on CC.Num_Proc = CTA.Num_Proc_HIO and CC.Cd_Tp_Tx = CTA.Cd_Tp_Tx
	
 where CTA.Num_Proc_HIA in ('IMCSR201408229BR') and
	CTA.Cd_Tp_Tx in ('218','B35','B36','BZ0','BZ3','S1R','SR1','SR2','srv','B35','B34') 
	and CC.Cd_Pedido is null 
	--and DC_HIA = 'C' 
	--and Num_Proc_HIA in 
	--and DC_HIA = 'C' 
	--and DC_HIO = 'C' and Num_Proc_HIO in
--select * from custo_dow_temp
--select * from custo_cliente  where cd_tp_tx = 'srv' and Num_Proc in
--select * from usuario where nome_usuario like 'cesar%'
--select * from Tipo_Taxa
--where Nome_Tp_Tx like 'serviços de despacho%'
--where Cd_Tp_Tx in ('BRO','SR2','srv','sr1')





GO
