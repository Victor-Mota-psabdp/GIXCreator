SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


--exec [dbo].[spATL_AXXMLITEMImpostos2Oracle_Sel]'1784029','1'
--exec [dbo].[spATL_AXXMLITEMImpostos2Oracle_Sel]'1784029','2'
--exec [dbo].[spATL_AXXMLITEMImpostos2Oracle_Sel]'1784029','3'
--exec [dbo].[spATL_AXXMLITEMImpostos2Oracle_Sel]'1805307','3'
--select Valor,* from AX_Doc_Item where id_ax = 1784029 
CREATE Procedure [dbo].[spATL_AXXMLITEMImpostos2Oracle_Sel]
(
	@ID_AX		int,
	@ID_Item	int
	
)
	
as


Declare @Item_lei as varchar(5)
select top 1 @Item_lei= Item_lei
	from AX_Doc_Item I with(nolock)
	join Tipo_NF_Doc_Register TT with(nolock) on TT.cd_servico = isnull(I.citCityHallServiceCode,'')
where 
	id_ax = @ID_AX and ID_Item =@ID_Item

print @Item_lei


--Declare @Item_lei as varchar(5)
Declare @ref_acesso_nf_hia as varchar(5)
select 
--@Item_lei = TT.Item_lei,
	@ref_acesso_nf_hia= cta.ref_acesso_nf_hia 
	from AX_Doc_Item I with(nolock)
	Join vwcta_cte cta on cta.num_proc_hia=I.num_proc and cta.dc_hia=I.dc and cta.cd_tp_tx=I.cd_tp_Tx_ATL
	--join Tipo_TaxaXTipo_NF_Doc_Register TT on TT.Cd_Tp_Tx = I.cd_tp_Tx_ATL and TT.cd_servico = I.citCityHallServiceCode --and TT.cd_site = cta.Ref_Acesso_NF_HIA
	--Join Tipo_CAMPO_Impostos TI With(nolock) on TI.Cd_Site = cta.ref_acesso_nf_hia and TI.Descr_Imposto  in ('IRRF')
where 
	id_ax = @ID_AX and ID_Item = @ID_Item

print @ref_acesso_nf_hia


if @ref_acesso_nf_hia is null--@Item_lei is null and
BEGIN
	select --@Item_lei = SOL.Item_lei,
	@ref_acesso_nf_hia= SOL.ref_acesso from AX_Doc I with(nolock)
	join Sol_Pgto_Cta_Cte SOL with(nolock) on Convert(varchar(30),SOL.ID) = I.numero_documento
	where I.id_ax =@ID_AX	
END

print @ref_acesso_nf_hia
--print @Item_lei
--print @ref_acesso_nf_hia

--select @Item_lei = left(citCityHallServiceDesc,5) from AX_DOC_Item with(nolock) where id_ax = '1784029' and ID_Item = 1 
----id_ax = @ID_AX and ID_Item = @ID_Item
--select * from AX_DOC_Item with(nolock) where id_ax = '1784029' and ID_Item = 1 
--select * from vwcta_cte with(nolock) where Num_Proc_HIA = 'IMTAM202504014BR' and ID_Item = 1 
--select * from Tipo_TaxaXTipo_NF_Doc_Register with(nolock) where Cd_Tp_Tx = 'SUB' 
--print @Item_lei

--10.06 - IRR
--10.05 - Sem retenção
--33.01 - PCC e IRR

if @Item_lei is not null and @ref_acesso_nf_hia is not null
BEGIN
	if @Item_lei = '33.01'	
		BEGIN
			select distinct
				1														orderby,
				'WH_Tax'												Tax_Header,
				'WHT'													Tax_Name,
				I.Valor													Tax_TaxableAmount,
				convert(decimal(18,2),(I.Valor*TI.Aliq)/100) *-1		Tax_Amount,
				TI.Aliq * -1		Tax_Rate,
				TI.Descr_Imposto	Tax_Code
				--,TT.Item_lei
				,@ref_acesso_nf_hia Ref_Acesso_NF_HIA
				from AX_Doc_Item I with(nolock)
				Join vwcta_cte cta on cta.num_proc_hia=I.num_proc and cta.dc_hia=I.dc and cta.cd_tp_tx=I.cd_tp_Tx_ATL
				--join Tipo_TaxaXTipo_NF_Doc_Register TT on TT.Cd_Tp_Tx = I.cd_tp_Tx_ATL and TT.cd_servico = I.citCityHallServiceCode --and TT.cd_site =  @ref_acesso_nf_hia
				Join Tipo_CAMPO_Impostos TI With(nolock) on TI.Cd_Site = @ref_acesso_nf_hia --and TI.Descr_Imposto  in ('IRRF')
			where 
				id_ax = @ID_AX and ID_Item = @ID_Item			

			--union all

			--	select  distinct
			--	2														orderby,
			--	'VAT'													Tax_Header,
			--	'VAT'													Tax_Name,
			--	I.Valor													Tax_TaxableAmount,
			--	convert(decimal(18,2),(I.Valor*TI.Aliq)/100)			Tax_Amount,
			--	TI.Aliq 												Tax_Rate,
			--	TI.Descr_Imposto										Tax_Code
			--	--,TT.Item_lei
			--	,@ref_acesso_nf_hia Ref_Acesso_NF_HIA
			--	from AX_Doc_Item I with(nolock)
			--	Join vwcta_cte cta on cta.num_proc_hia=I.num_proc and cta.dc_hia=I.dc and cta.cd_tp_tx=I.cd_tp_Tx_ATL
			--	--join Tipo_TaxaXTipo_NF_Doc_Register TT on TT.Cd_Tp_Tx = I.cd_tp_Tx_ATL and TT.cd_servico = I.citCityHallServiceCode --and TT.cd_site = @ref_acesso_nf_hia
			--	Join Tipo_CAMPO_Impostos TI With(nolock) on TI.Cd_Site = @ref_acesso_nf_hia and TI.Descr_Imposto not in ('IRRF')
			--where 
			--	id_ax = @ID_AX and ID_Item = @ID_Item
	
			Order by 1
		END

	else if	@Item_lei = '10.06'	
		BEGIN
			select distinct
				1														orderby,
				'WH_Tax'												Tax_Header,
				'WHT'													Tax_Name,
				I.Valor													Tax_TaxableAmount,
				convert(decimal(18,2),(I.Valor*TI.Aliq)/100) *-1		Tax_Amount,
				TI.Aliq * -1		Tax_Rate,
				TI.Descr_Imposto	Tax_Code
				--,TT.Item_lei
				,@ref_acesso_nf_hia Ref_Acesso_NF_HIA
				from AX_Doc_Item I with(nolock)
				Join vwcta_cte cta on cta.num_proc_hia=I.num_proc and cta.dc_hia=I.dc and cta.cd_tp_tx=I.cd_tp_Tx_ATL
				--join Tipo_TaxaXTipo_NF_Doc_Register TT on TT.Cd_Tp_Tx = I.cd_tp_Tx_ATL and TT.cd_servico = I.citCityHallServiceCode --and TT.cd_site = @ref_acesso_nf_hia
				Join Tipo_CAMPO_Impostos TI With(nolock) on TI.Cd_Site = @ref_acesso_nf_hia and TI.Descr_Imposto  in ('IRRF')
			where 
				id_ax = @ID_AX and ID_Item =@ID_Item

			Order by 1
		END

END

	/*



	if @Item_lei is not null and @ref_acesso_nf_hia is not null
BEGIN
	if @Item_lei = '33.01'	
		BEGIN
			select distinct
				1														orderby,
				'WH_Tax'												Tax_Header,
				'WHT'													Tax_Name,
				I.Valor													Tax_TaxableAmount,
				convert(decimal(18,2),(I.Valor*TI.Aliq)/100) *-1		Tax_Amount,
				TI.Aliq * -1		Tax_Rate,
				TI.Descr_Imposto	Tax_Code
				--,TT.Item_lei
				,@ref_acesso_nf_hia Ref_Acesso_NF_HIA
				from AX_Doc_Item I with(nolock)
				Join vwcta_cte cta on cta.num_proc_hia=I.num_proc and cta.dc_hia=I.dc and cta.cd_tp_tx=I.cd_tp_Tx_ATL
				--join Tipo_TaxaXTipo_NF_Doc_Register TT on TT.Cd_Tp_Tx = I.cd_tp_Tx_ATL and TT.cd_servico = I.citCityHallServiceCode --and TT.cd_site =  @ref_acesso_nf_hia
				Join Tipo_CAMPO_Impostos TI With(nolock) on TI.Cd_Site = @ref_acesso_nf_hia and TI.Descr_Imposto  in ('IRRF')
			where 
				id_ax = @ID_AX and ID_Item = @ID_Item			

			union all

				select  distinct
				2														orderby,
				'VAT'													Tax_Header,
				'VAT'													Tax_Name,
				I.Valor													Tax_TaxableAmount,
				convert(decimal(18,2),(I.Valor*TI.Aliq)/100)			Tax_Amount,
				TI.Aliq 												Tax_Rate,
				TI.Descr_Imposto										Tax_Code
				--,TT.Item_lei
				,@ref_acesso_nf_hia Ref_Acesso_NF_HIA
				from AX_Doc_Item I with(nolock)
				Join vwcta_cte cta on cta.num_proc_hia=I.num_proc and cta.dc_hia=I.dc and cta.cd_tp_tx=I.cd_tp_Tx_ATL
				--join Tipo_TaxaXTipo_NF_Doc_Register TT on TT.Cd_Tp_Tx = I.cd_tp_Tx_ATL and TT.cd_servico = I.citCityHallServiceCode --and TT.cd_site = @ref_acesso_nf_hia
				Join Tipo_CAMPO_Impostos TI With(nolock) on TI.Cd_Site = @ref_acesso_nf_hia and TI.Descr_Imposto not in ('IRRF')
			where 
				id_ax = @ID_AX and ID_Item = @ID_Item
	
			Order by 1
		END

	else if	@Item_lei = '10.06'	
		BEGIN
			select distinct
				1														orderby,
				'WH_Tax'												Tax_Header,
				'WHT'													Tax_Name,
				I.Valor													Tax_TaxableAmount,
				convert(decimal(18,2),(I.Valor*TI.Aliq)/100) *-1		Tax_Amount,
				TI.Aliq * -1		Tax_Rate,
				TI.Descr_Imposto	Tax_Code
				--,TT.Item_lei
				,@ref_acesso_nf_hia Ref_Acesso_NF_HIA
				from AX_Doc_Item I with(nolock)
				Join vwcta_cte cta on cta.num_proc_hia=I.num_proc and cta.dc_hia=I.dc and cta.cd_tp_tx=I.cd_tp_Tx_ATL
				--join Tipo_TaxaXTipo_NF_Doc_Register TT on TT.Cd_Tp_Tx = I.cd_tp_Tx_ATL and TT.cd_servico = I.citCityHallServiceCode --and TT.cd_site = @ref_acesso_nf_hia
				Join Tipo_CAMPO_Impostos TI With(nolock) on TI.Cd_Site = @ref_acesso_nf_hia and TI.Descr_Imposto  in ('IRRF')
			where 
				id_ax = @ID_AX and ID_Item =@ID_Item

			Order by 1
		END

END


	
--else if	@Item_lei = '10.05'	
--BEGIN
--	select
--		1														orderby,
--		'WH_Tax'												Tax_Header,
--		'WHT'													Tax_Name,
--		I.Valor													Tax_TaxableAmount,
--		convert(decimal(18,2),(I.Valor*TI.Aliq)/100) *-1		Tax_Amount,
--		TI.Aliq * -1		Tax_Rate,
--		TI.Descr_Imposto	Tax_Code
--		,TT.Item_lei
--		,cta.Ref_Acesso_NF_HIA
--		from AX_Doc_Item I with(nolock)
--		Join vwcta_cte cta on cta.num_proc_hia=I.num_proc and cta.dc_hia=I.dc and cta.cd_tp_tx=I.cd_tp_Tx_ATL
--		join Tipo_TaxaXTipo_NF_Doc_Register TT on TT.Cd_Tp_Tx = I.cd_tp_Tx_ATL and TT.cd_servico = I.citCityHallServiceCode --and TT.cd_site = cta.Ref_Acesso_NF_HIA
--		Join Tipo_CAMPO_Impostos TI With(nolock) on TI.Cd_Site = cta.ref_acesso_nf_hia and TI.Descr_Imposto  in ('IRRF')
--	where 
--		id_ax = @ID_AX and ID_Item =@ID_Item

--	union all

--		select
--		2														orderby,
--		'VAT'													Tax_Header,
--		'VAT'													Tax_Name,
--		I.Valor													Tax_TaxableAmount,
--		convert(decimal(18,2),(I.Valor*TI.Aliq)/100)			Tax_Amount,
--		TI.Aliq 												Tax_Rate,
--		TI.Descr_Imposto										Tax_Code
--		,TT.Item_lei
--		,cta.Ref_Acesso_NF_HIA
--		from AX_Doc_Item I with(nolock)
--		Join vwcta_cte cta on cta.num_proc_hia=I.num_proc and cta.dc_hia=I.dc and cta.cd_tp_tx=I.cd_tp_Tx_ATL
--		join Tipo_TaxaXTipo_NF_Doc_Register TT on TT.Cd_Tp_Tx = I.cd_tp_Tx_ATL and TT.cd_servico = I.citCityHallServiceCode --and TT.cd_site = cta.Ref_Acesso_NF_HIA
--		Join Tipo_CAMPO_Impostos TI With(nolock) on TI.Cd_Site = cta.ref_acesso_nf_hia and TI.Descr_Imposto not in ('IRRF')
--	where 
--		id_ax = @ID_AX and ID_Item = @ID_Item
--	Order by 1
--END
select * from AX_Doc with(nolock) where id_ax = '1784029' and ID_Item = 1
select * from Campo_Impostos where nota_fiscal = '175408'
select * from Tipo_CAMPO_Impostos where cd_site = 'I'

Select distinct 
	1					orderby,
	'WH_Tax'			Tax_Header,
	CI.Base				Tax_TaxableAmount,
	CI.Valor * -1		Tax_Amount,
	TI.Aliq * -1		Tax_Rate,
	TI.Descr_Imposto	Tax_Code
 From Item_Fat I
	Join Fatura F on F.FatCod = I.FatCod 
	Join AX_DOC AX on AX.Invoice_Number = I.FatCod 
	Join House_imp_mar Hou on hou.num_proc_him=I.num_proc
	Left Join vwcta_cte cta on cta.num_proc_hia=I.num_proc and cta.dc_hia=I.dc and cta.cd_tp_tx=I.cd_tp_Tx
	--Left Join Base_Nota_Fiscal NF on nota_fiscal=num_nf_hia and NF.ref_acesso=ref_acesso_nf_hia and emissao <= FatDtEmissao
	Left Join Campo_Impostos CI With(nolock) on CI.Nota_Fiscal=cta.num_nf_hia and CI.Cd_Site=cta.ref_acesso_nf_hia
	Left Join Tipo_CAMPO_Impostos TI With(nolock) on TI.Cd_Site = CI.Cd_Site and CI.Id_Imposto = TI.Id_Imposto 
Where
	 id_ax = @ID_AX
	 and TI.Descr_Imposto = 'IRRF' 

union all

	Select distinct
	2					orderby,
	'WH_Tax'			Tax_Header,
	CI.Base				Tax_TaxableAmount,
	CI.Valor * -1		Tax_Amount,
	TI.Aliq * -1		Tax_Rate,
	TI.Descr_Imposto	Tax_Code
 From Item_Fat I
	Join Fatura F on F.FatCod = I.FatCod 
	Join AX_DOC AX on AX.Invoice_Number = I.FatCod 
	Join House_imp_mar Hou on hou.num_proc_him=I.num_proc
	Left Join vwcta_cte cta on cta.num_proc_hia=I.num_proc and cta.dc_hia=I.dc and cta.cd_tp_tx=I.cd_tp_Tx
	--Left Join Base_Nota_Fiscal NF on nota_fiscal=num_nf_hia and NF.ref_acesso=ref_acesso_nf_hia and emissao <= FatDtEmissao
	Left Join Campo_Impostos CI With(nolock) on CI.Nota_Fiscal=cta.num_nf_hia and CI.Cd_Site=cta.ref_acesso_nf_hia
	Left Join Tipo_CAMPO_Impostos TI With(nolock) on TI.Cd_Site = CI.Cd_Site and CI.Id_Imposto = TI.Id_Imposto 
Where
	 id_ax = @ID_AX--'1784029'
	  and TI.Descr_Imposto not in ('IRRF')

Order by 1

*/



/*


--exec [dbo].[spATL_AXXMLITEMImpostos2Oracle_Sel]'1784029','1'
--exec [dbo].[spATL_AXXMLITEMImpostos2Oracle_Sel]'1784029','2'
--exec [dbo].[spATL_AXXMLITEMImpostos2Oracle_Sel]'1784029','3'
--select Valor,* from AX_Doc_Item where id_ax = 1784029 
ALTER Procedure [dbo].[spATL_AXXMLITEMImpostos2Oracle_Sel]
(
	@ID_AX		int,
	@ID_Item	int
	
)
	
as

--Declare @Item_lei as varchar(5)
--select @Item_lei = left(citCityHallServiceDesc,5) from AX_DOC_Item with(nolock) where id_ax = '1784029' and ID_Item = 1 
----id_ax = @ID_AX and ID_Item = @ID_Item
--select * from AX_DOC_Item with(nolock) where id_ax = '1784029' and ID_Item = 1 
--select * from vwcta_cte with(nolock) where Num_Proc_HIA = 'IMTAM202504014BR' and ID_Item = 1 
--select * from Tipo_TaxaXTipo_NF_Doc_Register with(nolock) where Cd_Tp_Tx = 'SUB' 
--print @Item_lei

select
	1														orderby,
	'WH_Tax'												Tax_Header,
	'WHT'													Tax_Name,
	I.Valor													Tax_TaxableAmount,
	convert(decimal(18,2),(I.Valor*TI.Aliq)/100) *-1		Tax_Amount,
	TI.Aliq * -1		Tax_Rate,
	TI.Descr_Imposto	Tax_Code
	,TT.Item_lei
	,cta.Ref_Acesso_NF_HIA
	from AX_Doc_Item I with(nolock)
	Join vwcta_cte cta on cta.num_proc_hia=I.num_proc and cta.dc_hia=I.dc and cta.cd_tp_tx=I.cd_tp_Tx_ATL
	join Tipo_TaxaXTipo_NF_Doc_Register TT on TT.Cd_Tp_Tx = I.cd_tp_Tx_ATL and TT.cd_servico = I.citCityHallServiceCode --and TT.cd_site = cta.Ref_Acesso_NF_HIA
	Join Tipo_CAMPO_Impostos TI With(nolock) on TI.Cd_Site = cta.ref_acesso_nf_hia and TI.Descr_Imposto  in ('IRRF')
where 
	id_ax = @ID_AX and ID_Item = 1

union all

	select
	2														orderby,
	'VAT'													Tax_Header,
	'VAT'													Tax_Name,
	I.Valor													Tax_TaxableAmount,
	convert(decimal(18,2),(I.Valor*TI.Aliq)/100)			Tax_Amount,
	TI.Aliq 												Tax_Rate,
	TI.Descr_Imposto										Tax_Code
	,TT.Item_lei
	,cta.Ref_Acesso_NF_HIA
	from AX_Doc_Item I with(nolock)
	Join vwcta_cte cta on cta.num_proc_hia=I.num_proc and cta.dc_hia=I.dc and cta.cd_tp_tx=I.cd_tp_Tx_ATL
	join Tipo_TaxaXTipo_NF_Doc_Register TT on TT.Cd_Tp_Tx = I.cd_tp_Tx_ATL and TT.cd_servico = I.citCityHallServiceCode --and TT.cd_site = cta.Ref_Acesso_NF_HIA
	Join Tipo_CAMPO_Impostos TI With(nolock) on TI.Cd_Site = cta.ref_acesso_nf_hia and TI.Descr_Imposto not in ('IRRF')
where 
	id_ax = @ID_AX and ID_Item = @ID_Item

Order by 1

	/*
select * from AX_Doc with(nolock) where id_ax = '1784029' and ID_Item = 1
select * from Campo_Impostos where nota_fiscal = '175408'
select * from Tipo_CAMPO_Impostos where cd_site = 'I'

Select distinct 
	1					orderby,
	'WH_Tax'			Tax_Header,
	CI.Base				Tax_TaxableAmount,
	CI.Valor * -1		Tax_Amount,
	TI.Aliq * -1		Tax_Rate,
	TI.Descr_Imposto	Tax_Code
 From Item_Fat I
	Join Fatura F on F.FatCod = I.FatCod 
	Join AX_DOC AX on AX.Invoice_Number = I.FatCod 
	Join House_imp_mar Hou on hou.num_proc_him=I.num_proc
	Left Join vwcta_cte cta on cta.num_proc_hia=I.num_proc and cta.dc_hia=I.dc and cta.cd_tp_tx=I.cd_tp_Tx
	--Left Join Base_Nota_Fiscal NF on nota_fiscal=num_nf_hia and NF.ref_acesso=ref_acesso_nf_hia and emissao <= FatDtEmissao
	Left Join Campo_Impostos CI With(nolock) on CI.Nota_Fiscal=cta.num_nf_hia and CI.Cd_Site=cta.ref_acesso_nf_hia
	Left Join Tipo_CAMPO_Impostos TI With(nolock) on TI.Cd_Site = CI.Cd_Site and CI.Id_Imposto = TI.Id_Imposto 
Where
	 id_ax = @ID_AX
	 and TI.Descr_Imposto = 'IRRF' 

union all

	Select distinct
	2					orderby,
	'WH_Tax'			Tax_Header,
	CI.Base				Tax_TaxableAmount,
	CI.Valor * -1		Tax_Amount,
	TI.Aliq * -1		Tax_Rate,
	TI.Descr_Imposto	Tax_Code
 From Item_Fat I
	Join Fatura F on F.FatCod = I.FatCod 
	Join AX_DOC AX on AX.Invoice_Number = I.FatCod 
	Join House_imp_mar Hou on hou.num_proc_him=I.num_proc
	Left Join vwcta_cte cta on cta.num_proc_hia=I.num_proc and cta.dc_hia=I.dc and cta.cd_tp_tx=I.cd_tp_Tx
	--Left Join Base_Nota_Fiscal NF on nota_fiscal=num_nf_hia and NF.ref_acesso=ref_acesso_nf_hia and emissao <= FatDtEmissao
	Left Join Campo_Impostos CI With(nolock) on CI.Nota_Fiscal=cta.num_nf_hia and CI.Cd_Site=cta.ref_acesso_nf_hia
	Left Join Tipo_CAMPO_Impostos TI With(nolock) on TI.Cd_Site = CI.Cd_Site and CI.Id_Imposto = TI.Id_Imposto 
Where
	 id_ax = @ID_AX--'1784029'
	  and TI.Descr_Imposto not in ('IRRF')

Order by 1

*/

*/
GO
