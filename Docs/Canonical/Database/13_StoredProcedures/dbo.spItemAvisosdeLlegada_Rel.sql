SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--select * from cta_cte_hou_imp_mar where num_proc_him like 'IMFLT201110010AR%'
--spItemAvisosdeLlegada_Rel 'IMFLT201201022AR','EUR'
--spItemAvisosdeLlegada_Rel 'IMFLT201201022AR','USD'
--select * from cta_cte_hou_imp_mar where num_proc_him ='IMFLT201111020AR'
--select * from house_imp_mar where num_proc_him ='IMFLT201111020AR'
--spItemAvisosdeLlegada_Rel 'IMSLT20110100501'
--select * from cta_cte_hou_imp_mar where Num_Proc_Him = 'IMFLT201105003AR'

--incluido 18-11 -  as taxas que devem aparecer é “Taxas a credito” contra o Consignee. 

CREATE Procedure [dbo].[spItemAvisosdeLlegada_Rel]--'IMATL201307038BR'
	@JOB VarChar(16)
as	

select
	Upper(TT.Nome_Tp_Tx)			Nome_Taxa,
	CC.cd_tp_moeda					moeda,
	CC.Vlr_Org_Him					Valor,
	sum(CC.Vlr_Org_Him	 * 0.21)	Valor_Iva,
	cpmf_him						iva
FROM 
	cta_cte_hou_imp_mar CC
	Join Tipo_Taxa	TT on TT.Cd_Tp_Tx=CC.Cd_Tp_Tx
	join house_imp_mar HOU on HOU.num_proc_him = CC.Num_Proc_Him and CC.cd_cred_dev_him = hou.cd_consig_him
where
	CC.Num_Proc_Him=@JOB
	and CC.dc_him = 'C'
	and cc.cd_tp_tx <> 'IVA'
	and CC.desp_org_him = 'N' 
	and NOT( HOU.tp_frete_him = 'P' and CC.cd_tp_tx = 'FRT')
	and num_dcn_him is null
group by
	TT.Nome_Tp_Tx,CC.Vlr_Org_Him,cc.cd_tp_moeda,cpmf_him	
order by
	5


GO
