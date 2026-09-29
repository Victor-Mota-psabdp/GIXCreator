SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



CREATE Procedure [dbo].[spCustomerClienteItem_Rel] --18
--	@cliente varchar(50),
--	@org varchar(50),
--	@dst varchar(50)
	@id_cp int
as

--	Declare @cd_cliente		varchar(10)
--	Declare @cd_org			varchar(3)
--	Declare @cd_dst			varchar(3)	
--
--	set @cd_cliente = (select cd_pes from pessoa where apelido = @cliente)
--	
--	if @org <> ''
--		set @cd_org = (select cd_local from localidade where nome_local=@org)
--	else
--		set @cd_org = 'ALL'	
--	
--	if @dst <> ''
--		set @cd_dst = (select cd_local from localidade where nome_local=@dst)
--	else
--		set @cd_dst = 'ALL'

select Tx.nome_tp_tx taxa, Sa.apelido fornecedor, TC.descricao_cv tipo_compra, cd_tp_moeda_compra, TRC.range_descricao range_compra, vlr_compra, vlr_min_compra, TV.descricao_cv tipo_venda, cd_tp_moeda_venda, TRV.range_descricao range_venda, vlr_venda, vlr_min_venda, campo_obs_taxas from customer_profile_taxas CT
	join tipo_taxa TX on TX.cd_tp_tx=CT.cd_tp_tx
	left join pessoa SA on SA.cd_pes=CT.cd_fornecedor
	left join tipo_compra_venda_cp TC on TC.cd_cv=CT.cd_tipo_compra
	left join tipo_range_cp TRC on TRC.cd_range=CT.cd_range_compra
	left join tipo_compra_venda_cp TV on TV.cd_cv=CT.cd_tipo_venda
	left join tipo_moeda TMV on TMV.cd_tp_moeda=CT.cd_tp_moeda_venda
	left join tipo_range_cp TRV on TRV.cd_range=CT.cd_range_venda

where
	id_cP = @id_cp



GO
