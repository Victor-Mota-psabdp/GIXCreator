SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[spATL_InvoiceList_Rel] -- [dbo].[spATL_InvoiceList_Rel] '2013-06-30'
	@Data datetime
	
as
/*
select 
	distinct 
	left(fat.fatcod,16) [BDP REF.],
	dbo.fBusca_TipoDocCliente('N',left(fat.fatcod,16) ,1) [Customer Reference],
	FAT.FAtCod [BDP Invoice],
	FAT.cd_pes [Customer Code],
	Nome_Raz_Soc [Customer-Agent-BDP Office],
	fatdtemissao [Invoice Dt],
	fatdtvenc [Due Date],
	(
		Case ITem.cd_tp_moeda
			When 'REL' then 'BRL'
			else item.cd_tp_moeda
			
		End
	)
	[Currency],
	sum(abs(ITem.vlr_org)) [Value],
	sum(abs(Isnull(Vlr_pgto_Rcto_hia,vlr_org*isnull(Par_Moeda,1)))) [Value],
	max(Convert(Datetime,dt_pgto_rcto_hia,105)) PaymentDt
	
 from fatura fat with(nolock)
Join item_Fat item with(nolock) on fat.fatcod=item.fatcod
left join vwcxas cxa with(nolock) on left(item.fatcod,16)=num_proc_hia and item.cd_tp_Tx=cxa.cd_tp_tx and dc=dc_hia
Join Pessoa PP with(nolock) on pp.cd_pes=fat.cd_pes
Left Join PO_Him PO with(nolock) on PO.num_proc_him=left(fat.fatcod,16) and id_dc=1
Left Join Paridade PAR on PAr.cd_tp_moeda=Item.cd_tp_moeda and PAr.cd_tp_par='OFC' and dt_par =convert(varchar(10),getdate(),103)
where fatdtemissao >='03-01-2013'
and fatstatus <>0
AND ITEM.DC='C' and left(fat.fatcod,2) =('EA')
group by fat.fatcod,fat.cd_pes,nome_raz_soc,fatdtemissao,fatdtvenc,item.cd_tp_moeda,paridade


Union all
*/
select 
	distinct 
	left(fat.fatcod,16) [BDP REF.],
	dbo.fBusca_TipoDocCliente('N',left(fat.fatcod,16) ,1) [Customer Reference],
	FAT.FAtCod [BDP Invoice],
	FAT.cd_pes [Customer Code],
	Nome_Raz_Soc [Customer/Agent/BDP Office],
	convert(varchar(10),fatdtemissao,105) [Invoice Dt],
	convert(Datetime,fatdtvenc,105) [Due Date],
	(
		Case ITem.cd_tp_moeda
			When 'REL' then 'BRL'
			else item.cd_tp_moeda
			
		End
	)
	[Currency],
	sum((dbo.valor(abs(ITem.vlr_org),dc))) [Value],
	cast(sum(dbo.valor(abs(ITem.vlr_org),dc)*isnull(Par_Moeda,1)) as decimal(10,2)) [Value],
	max(Convert(Datetime,dt_pgto_rcto_hia,105)) PaymentDt,
	AX.cd_ax						[cd_ax]
 from fatura fat with(nolock)
Join item_Fat item with(nolock) on fat.fatcod=item.fatcod
left join vwcxas cxa with(nolock) on left(item.fatcod,16)=num_proc_hia and item.cd_tp_Tx=cxa.cd_tp_tx and dc=dc_hia
Join Pessoa PP with(nolock) on pp.cd_pes=fat.cd_pes
---Left Join PO_Him PO with(nolock) on PO.num_proc_him=left(fat.fatcod,16) and id_dc=1
Left Join Paridade PAR on PAr.cd_tp_moeda=Item.cd_tp_moeda and PAr.cd_tp_par='OFC' and convert(datetime,dt_par,105) =convert(varchar(10),fatdtemissao,101)
Join Tipo_Taxa TT with(nolock) on TT.cd_tp_Tx=Item.cd_tp_tx
Left Join Pessoa_ATL_AX AX on (PP.cd_tp_ativ <> 'AGT' and AX.Cd_Pes = PP.Cd_Pes or PP.cd_tp_Ativ='AGT' and left(ax.cd_pes,len(ax.cd_pes)-1)=PP.cd_pes) and AX.Tipo='C'
--where fatdtemissao >='05-01-2013'
where fatdtemissao between '01-01-2013' and @Data
and fatstatus <>0
---AND ITEM.DC='C' ---and left(fat.fatcod,2)='IM'
group by fat.fatcod,fat.cd_pes,nome_raz_soc,fatdtemissao,fatdtvenc,item.cd_tp_moeda,paridade,AX.cd_ax
having sum((dbo.valor(abs(ITem.vlr_org),dc))) <>0
--union all

--select 
--	distinct 
--	left(fat.fatcod,16) [BDP REF.],
--	dbo.fBusca_TipoDocCliente('N',left(fat.fatcod,16) ,1) [Customer Reference],
--	FAT.FAtCod [BDP Invoice],
--	FAT.cd_pes [Customer Code],
--	Nome_Raz_Soc [Customer/Agent/BDP Office],
--	fatdtemissao [Invoice Dt],
--	fatdtvenc [Due Date],
--	(
--		Case ITem.cd_tp_moeda
--			When 'REL' then 'BRL'
--			else item.cd_tp_moeda
			
--		End
--	)
--	[Currency],
--	sum(abs(ITem.vlr_org)) [Value],
--	sum(abs(Isnull(Vlr_pgto_Rcto_hia,vlr_org*isnull(Par_Moeda,1)))) [Value],
--	max(Convert(Datetime,dt_pgto_rcto_hia,105)) PaymentDt
	
-- from fatura fat with(nolock)
--Join item_Fat item with(nolock) on fat.fatcod=item.fatcod
--left join vwcxas cxa with(nolock) on left(item.fatcod,16)=num_proc_hia and item.cd_tp_Tx=cxa.cd_tp_tx and dc=dc_hia
--Join Pessoa PP with(nolock) on pp.cd_pes=fat.cd_pes
-----Left Join PO_Hem PO with(nolock) on PO.num_proc_hem=left(fat.fatcod,16) and id_dc=1
--Left Join Paridade PAR on PAr.cd_tp_moeda=Item.cd_tp_moeda and PAr.cd_tp_par='OFC' and dt_par =convert(varchar(10),getdate(),103)
--where fatdtemissao >='03-01-2013'
--and fatstatus <>0
--AND ITEM.DC='C' and left(fat.fatcod,2)='EM'
--group by fat.fatcod,fat.cd_pes,nome_raz_soc,fatdtemissao,fatdtvenc,item.cd_tp_moeda,paridade

--union all


--select 
--	distinct 
--	left(fat.fatcod,16) [BDP REF.],
--	dbo.fBusca_TipoDocCliente('N',left(fat.fatcod,16) ,1) [Customer Reference],
--	FAT.FAtCod [BDP Invoice],
--	FAT.cd_pes [Customer Code],
--	Nome_Raz_Soc [Customer/Agent/BDP Office],
--	fatdtemissao [Invoice Dt],
--	fatdtvenc [Due Date],
--	(
--		Case ITem.cd_tp_moeda
--			When 'REL' then 'BRL'
--			else item.cd_tp_moeda
			
--		End
--	)
--	[Currency],
--	sum(abs(ITem.vlr_org)) [Value],
--	sum(abs(Isnull(Vlr_pgto_Rcto_hia,vlr_org*isnull(Par_Moeda,1)))) [Value],
--	max(Convert(Datetime,dt_pgto_rcto_hia,105)) PaymentDt
	
-- from fatura fat with(nolock)
--Join item_Fat item with(nolock) on fat.fatcod=item.fatcod
--left join vwcxas cxa with(nolock) on left(item.fatcod,16)=num_proc_hia and item.cd_tp_Tx=cxa.cd_tp_tx and dc=dc_hia
--Join Pessoa PP with(nolock) on pp.cd_pes=fat.cd_pes
-----Left Join PO_Hia PO with(nolock) on PO.num_proc_hia=left(fat.fatcod,16) and id_dc=1
--Left Join Paridade PAR on PAr.cd_tp_moeda=Item.cd_tp_moeda and PAr.cd_tp_par='OFC' and dt_par =convert(varchar(10),getdate(),103)
--where fatdtemissao >='03-01-2013'
--and fatstatus <>0
--AND ITEM.DC='C' and left(fat.fatcod,2)='IA'
--group by fat.fatcod,fat.cd_pes,nome_raz_soc,fatdtemissao,fatdtvenc,item.cd_tp_moeda,paridade

--Union All


--select 
--	distinct 
--	left(fat.fatcod,16) [BDP REF.],
--	dbo.fBusca_TipoDocCliente('N',left(fat.fatcod,16) ,1) [Customer Reference],
--	FAT.FAtCod [BDP Invoice],
--	FAT.cd_pes [Customer Code],
--	Nome_Raz_Soc [Customer/Agent/BDP Office],
--	fatdtemissao [Invoice Dt],
--	fatdtvenc [Due Date],
--	(
--		Case ITem.cd_tp_moeda
--			When 'REL' then 'BRL'
--			else item.cd_tp_moeda
			
--		End
--	)
--	[Currency],
--	sum(abs(ITem.vlr_org)) [Value],
--	sum(abs(Isnull(Vlr_pgto_Rcto_hia,vlr_org*isnull(Par_Moeda,1)))) [Value],
--	max(Convert(Datetime,dt_pgto_rcto_hia,105)) PaymentDt
	
-- from fatura fat with(nolock)
--Join item_Fat item with(nolock) on fat.fatcod=item.fatcod
--left join vwcxas cxa with(nolock) on left(item.fatcod,16)=num_proc_hia and item.cd_tp_Tx=cxa.cd_tp_tx and dc=dc_hia
--Join Pessoa PP with(nolock) on pp.cd_pes=fat.cd_pes
-----Left Join PO_HEO PO with(nolock) on PO.num_proc_heo=left(fat.fatcod,16) and id_dc=1
--Left Join Paridade PAR on PAr.cd_tp_moeda=Item.cd_tp_moeda and PAr.cd_tp_par='OFC' and dt_par =convert(varchar(10),getdate(),103)
--where fatdtemissao >='03-01-2013'
--and fatstatus <>0
--AND ITEM.DC='C' and left(fat.fatcod,2)='EO'
--group by fat.fatcod,fat.cd_pes,nome_raz_soc,fatdtemissao,fatdtvenc,item.cd_tp_moeda,paridade

--Union all



--select 
--	distinct 
--	left(fat.fatcod,16) [BDP REF.],
--	dbo.fBusca_TipoDocCliente('N',left(fat.fatcod,16) ,1) [Customer Reference],
--	FAT.FAtCod [BDP Invoice],
--	FAT.cd_pes [Customer Code],
--	Nome_Raz_Soc [Customer/Agent/BDP Office],
--	fatdtemissao [Invoice Dt],
--	fatdtvenc [Due Date],
--	(
--		Case ITem.cd_tp_moeda
--			When 'REL' then 'BRL'
--			else item.cd_tp_moeda
			
--		End
--	)
--	[Currency],
--	sum(abs(ITem.vlr_org)) [Value],
--	sum(abs(Isnull(Vlr_pgto_Rcto_hia,vlr_org*isnull(Par_Moeda,1)))) [Value],
--	max(Convert(Datetime,dt_pgto_rcto_hia,105)) PaymentDt
	
-- from fatura fat with(nolock)
--Join item_Fat item with(nolock) on fat.fatcod=item.fatcod
--left join vwcxas cxa with(nolock) on left(item.fatcod,16)=num_proc_hia and item.cd_tp_Tx=cxa.cd_tp_tx and dc=dc_hia
--Join Pessoa PP with(nolock) on pp.cd_pes=fat.cd_pes
-----Left Join PO_HIO PO with(nolock) on PO.num_proc_hio=left(fat.fatcod,16) and id_dc=1
--Left Join Paridade PAR on PAr.cd_tp_moeda=Item.cd_tp_moeda and PAr.cd_tp_par='OFC' and dt_par =convert(varchar(10),getdate(),103)
--where fatdtemissao >='03-01-2013'
--and fatstatus <>0
--AND ITEM.DC='C' and left(fat.fatcod,2)='IO'
--group by fat.fatcod,fat.cd_pes,nome_raz_soc,fatdtemissao,fatdtvenc,item.cd_tp_moeda,paridade

--Union all


--select 
--	distinct 
--	left(fat.fatcod,16) [BDP REF.],
--	dbo.fBusca_TipoDocCliente('N',left(fat.fatcod,16) ,1) [Customer Reference],
--	FAT.FAtCod [BDP Invoice],
--	FAT.cd_pes [Customer Code],
--	Nome_Raz_Soc [Customer/Agent/BDP Office],
--	fatdtemissao [Invoice Dt],
--	fatdtvenc [Due Date],
--	(
--		Case ITem.cd_tp_moeda
--			When 'REL' then 'BRL'
--			else item.cd_tp_moeda
			
--		End
--	)
--	[Currency],
--	sum(abs(ITem.vlr_org)) [Value],
--	sum(abs(Isnull(Vlr_pgto_Rcto_hia,vlr_org*isnull(Par_Moeda,1)))) [Value],
--	max(Convert(Datetime,dt_pgto_rcto_hia,105)) PaymentDt
	
-- from fatura fat with(nolock)
--Join item_Fat item with(nolock) on fat.fatcod=item.fatcod
--left join vwcxas cxa with(nolock) on left(item.fatcod,16)=num_proc_hia and item.cd_tp_Tx=cxa.cd_tp_tx and dc=dc_hia
--Join Pessoa PP with(nolock) on pp.cd_pes=fat.cd_pes
-----Left Join PO_HEA PO with(nolock) on PO.num_proc_hea=left(fat.fatcod,16) and id_dc=1
--Left Join Paridade PAR on PAr.cd_tp_moeda=Item.cd_tp_moeda and PAr.cd_tp_par='OFC' and dt_par =convert(varchar(10),getdate(),103)
--where fatdtemissao >='03-01-2013'
--and fatstatus <>0
--AND ITEM.DC='C' and left(fat.fatcod,2)='EA'
--group by fat.fatcod,fat.cd_pes,nome_raz_soc,fatdtemissao,fatdtvenc,item.cd_tp_moeda,paridade


GO
