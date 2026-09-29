SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--spATL_ACAS_Trigger_Sel 'EACSR201805006BR'
CREATE procedure  [dbo].[spATL_ACAS_Trigger_Sel]--'EAURU201904001AR'
(
	@Num_Proc varchar(16)
)
as
--Declare @Num_Proc varchar(16)
--Set @Num_Proc = 'EAATL201806002BR'
if exists(select Num_proc from Pedido_Ship where Num_Proc = @Num_Proc)
	Begin

		select  
			ISNULL(replace(ltrim(rtrim(Produto_descr )),char(160),''),'Not Informed') [Cargo Description],
			--ISNULL(cast(cast(PS.Qty as decimal(18,3)) as varchar(200)),'Not Informed') [Number of Pieces],  
			ISNULL(cast(cast(PS.Qty as int) as varchar(200)),'Not Informed') [Number of Pieces],  
			ISNULL(cast(cast(PD.peso_bruto_tot as decimal(18,3)) as varchar(200)),'Not Informed') [Gross Weight] ,
			ISNULL(cast(cast(PD.peso_liquido_tot as decimal(18,3)) as varchar(200)),'Not Informed') [Net Weight],
			--isnull([dbo].[fBusca_Volumes](HOU.NUM_PROC),'Not Informed') [Volume],
			'Name: ' + SHP.Nome_Raz_Soc + CHAR(10)+CHAR(13) +
			'Street Address: ' + Isnull(EndSHP.Rua,'')+ ' ' + Isnull(EndSHP.numero,'') + ' ' + Isnull(EndSHP.Compl_end,'') + CHAR(13)+CHAR(10) +
			'City: ' + isnull(EndSHP.Cidade,'') +  CHAR(13)+CHAR(10) +
			--'State or Province: ' + isnull(EndSHP.uf,'') +  CHAR(13)+CHAR(10) +
			'Country Code: ' + isnull(EndSHP.Cd_Pais,'') +  CHAR(13)+CHAR(10) +
			--'Postal Code: ' + isnull(EndSHP.cep,'') +  CHAR(13)+CHAR(10) +
			'Telephone Number: ' + isnull((Isnull(ComSHP.Prefixo,'') + '-' + Isnull(ComSHP.Num_Fone,'')),'') [Shipper],
			
			'Name: ' +  CSN.Nome_Raz_Soc +  CHAR(13)+CHAR(10) +
			'Street Address: ' + Isnull(EndCSN.Rua,'')+ ' ' + Isnull(EndCSN.numero,'') + ' ' + Isnull(EndCSN.Compl_end,'') +  CHAR(13)+CHAR(10) +
			'City: ' + isnull(EndCSN.Cidade,'') +  CHAR(13)+CHAR(10) +
			--'State or Province: ' + isnull(EndCSN.uf,'') +  CHAR(13)+CHAR(10) +
			'Country Code: ' + isnull(EndCSN.Cd_Pais,'') 
			--'Postal Code: ' + isnull(EndCSN.cep,'') +  CHAR(13)+CHAR(10) +
			--'Telephone Number: ' + isnull((Isnull(ComCSN.Prefixo,'') + '-' + Isnull(ComCSN.Num_Fone,'')),'') 
			[Consignee],
			
			'Name: ' +  NFY.Nome_Raz_Soc +  CHAR(13)+CHAR(10) +
			'Street Address: ' + Isnull(EndNFY.Rua,'')+ ' ' + Isnull(EndNFY.numero,'') + ' ' + Isnull(EndNFY.Compl_end,'') +  CHAR(13)+CHAR(10) +
			'City: ' + isnull(EndNFY.Cidade,'') +  CHAR(13)+CHAR(10) +
			--'State or Province: ' + isnull(EndNFY.uf,'') +  CHAR(13)+CHAR(10) +
			'Country Code: ' + isnull(EndNFY.Cd_Pais,'')
			--'Postal Code: ' + isnull(EndNFY.cep,'') +  CHAR(13)+CHAR(10) +
			--'Telephone Number: ' + isnull((Isnull(ComNFY.Prefixo,'') + '-' + Isnull(ComNFY.Num_Fone,'')),'') 
			[Notify]
			
		from vwHouse_Exp HOU With(Nolock)
		left join Localidade DST on DST.Cd_Local = HOU.Cd_Dst
		left join pedido_ship PS on PS.Num_Proc = HOU.NUM_PROC
		left Join Produto_Cliente PC With(Nolock) on PC.cd_prod=cd_produto
		left Join Pedido_DET PD With(Nolock) on PS.cd_produto=PD.cd_produto and PS.cd_pedido=PD.cd_pedido
		left Join Pedido  PED With(Nolock) on PED.cd_pedido=PS.cd_pedido
		Left Join De_Para TIPO With(Nolock) on TIPO.cd_org=UOM and Tipo.cd_tipo=3
		left Join TErmo_PAgamento TP With(Nolock) on cast(TP.cd_termo as varchar(30))=PED.payment
		left Join Nature_Goods NG on NG.Num_Proc = HOU.Num_Proc
		left Join Pessoa SHP on HOU.Cd_Export = SHP.Cd_Pes
		left Join Endereco EndSHP on HOU.Cd_Export = EndSHP.Cd_Pes and EndSHP.cd_Tp_end='COM'
		Left Join Comunicacao ComSHP with(nolock) on EndSHP.cd_pes=ComSHP.cd_pes AND ComSHP.CD_TP_COM='TC1'
		left Join Pessoa CSN on HOU.cd_consig = CSN.Cd_Pes
		left Join Endereco EndCSN on HOU.cd_consig = EndCSN.Cd_Pes and EndCSN.Cd_Tp_End ='COM'
		Left Join Comunicacao ComCSN with(nolock) on CSN.cd_pes=ComCSN.cd_pes AND ComCSN.CD_TP_COM='TC1'
		left Join Pessoa NFY on HOU.Cd_Notify = NFY.Cd_Pes
		left Join Endereco EndNFY on HOU.Cd_Notify = EndNFY.Cd_Pes and EndNFY.Cd_Tp_End ='COM'
		Left Join Comunicacao ComNFY with(nolock) on NFY.cd_pes=ComNFY.cd_pes AND ComNFY.CD_TP_COM='TC1'
		--left join volume PS on PS.Num_Proc = HOU.NUM_PROC
		WHERE
			HOU.NUM_PROC=@NUM_PROC  and DST.Cd_Pais = 'US'
		group by
			SHP.Nome_Raz_Soc,EndSHP.Rua,EndSHP.numero,EndSHP.Compl_end,EndSHP.Cidade,EndSHP.uf,EndSHP.Cd_Pais,
			EndSHP.cep,ComSHP.Prefixo,ComSHP.Num_Fone,CSN.Nome_Raz_Soc,EndCSN.Rua,EndCSN.numero,EndCSN.Compl_end,
			EndCSN.Cidade,EndCSN.uf,EndCSN.Cd_Pais,EndCSN.cep,ComCSN.Prefixo,ComCSN.Num_Fone,NFY.Nome_Raz_Soc,
			EndNFY.Rua,EndNFY.numero,EndNFY.Compl_end,EndNFY.Cidade,EndNFY.uf,EndNFY.Cd_Pais,EndNFY.cep,
			ComNFY.Prefixo,ComNFY.Num_Fone,PS.Qty,PD.peso_bruto_tot,PD.peso_liquido_tot,replace(ltrim(rtrim(Produto_descr )),char(160),''),
			HOU.NUM_PROC
	END
Else
	Begin
	
			select 
			ISNULL(left(dbo.FRemoveCaracteresEspeciais(NG.Descr),255),'Not Informed') [Cargo Description],
			--ISNULL(cast(cast(HOU.Qtd_Vol  as decimal(18,3)) as varchar(200)),'Not Informed') [Number of Pieces],
			ISNULL(cast(cast(HOU.Qtd_Vol  as int) as varchar(200)),'Not Informed') [Number of Pieces],
			ISNULL(cast(cast(HOU.Peso_Bruto as decimal(18,3)) as varchar(200)),'Not Informed') [Gross Weight] ,
			ISNULL(cast(cast(HOU.Peso_Liquido as decimal(18,3)) as varchar(200)),'Not Informed') [Net Weight], 
			--isnull([dbo].[fBusca_Volumes](HOU.NUM_PROC),'Not Informed') [Volume],
						'Name: ' + SHP.Nome_Raz_Soc + CHAR(10)+CHAR(13) +
			'Street Address: ' + Isnull(EndSHP.Rua,'')+ ' ' + Isnull(EndSHP.numero,'') + ' ' + Isnull(EndSHP.Compl_end,'') + CHAR(13)+CHAR(10) +
			'City: ' + isnull(EndSHP.Cidade,'') +  CHAR(13)+CHAR(10) +
			--'State or Province: ' + isnull(EndSHP.uf,'') +  CHAR(13)+CHAR(10) +
			'Country Code: ' + isnull(EndSHP.Cd_Pais,'') +  CHAR(13)+CHAR(10) +
			--'Postal Code: ' + isnull(EndSHP.cep,'') +  CHAR(13)+CHAR(10) +
			'Telephone Number: ' + isnull((Isnull(ComSHP.Prefixo,'') + '-' + Isnull(ComSHP.Num_Fone,'')),'') [Shipper],
			
			'Name: ' +  CSN.Nome_Raz_Soc +  CHAR(13)+CHAR(10) +
			'Street Address: ' + Isnull(EndCSN.Rua,'')+ ' ' + Isnull(EndCSN.numero,'') + ' ' + Isnull(EndCSN.Compl_end,'') +  CHAR(13)+CHAR(10) +
			'City: ' + isnull(EndCSN.Cidade,'') +  CHAR(13)+CHAR(10) +
			--'State or Province: ' + isnull(EndCSN.uf,'') +  CHAR(13)+CHAR(10) +
			'Country Code: ' + isnull(EndCSN.Cd_Pais,'') 
			--'Postal Code: ' + isnull(EndCSN.cep,'') +  CHAR(13)+CHAR(10) +
			--'Telephone Number: ' + isnull((Isnull(ComCSN.Prefixo,'') + '-' + Isnull(ComCSN.Num_Fone,'')),'') 
			[Consignee],
			
			'Name: ' +  NFY.Nome_Raz_Soc +  CHAR(13)+CHAR(10) +
			'Street Address: ' + Isnull(EndNFY.Rua,'')+ ' ' + Isnull(EndNFY.numero,'') + ' ' + Isnull(EndNFY.Compl_end,'') +  CHAR(13)+CHAR(10) +
			'City: ' + isnull(EndNFY.Cidade,'') +  CHAR(13)+CHAR(10) +
			--'State or Province: ' + isnull(EndNFY.uf,'') +  CHAR(13)+CHAR(10) +
			'Country Code: ' + isnull(EndNFY.Cd_Pais,'')
			--'Postal Code: ' + isnull(EndNFY.cep,'') +  CHAR(13)+CHAR(10) +
			--'Telephone Number: ' + isnull((Isnull(ComNFY.Prefixo,'') + '-' + Isnull(ComNFY.Num_Fone,'')),'') 
			[Notify]

			
		from vwHouse_Exp HOU With(Nolock)
		left join Localidade DST on DST.Cd_Local = HOU.Cd_Dst
		left Join Nature_Goods NG on NG.Num_Proc = HOU.Num_Proc
		left Join Pessoa SHP on HOU.Cd_Export = SHP.Cd_Pes
		left Join Endereco EndSHP on HOU.Cd_Export = EndSHP.Cd_Pes and EndSHP.cd_Tp_end='COM'
		Left Join Comunicacao ComSHP with(nolock) on EndSHP.cd_pes=ComSHP.cd_pes AND ComSHP.CD_TP_COM='TC1'
		left Join Pessoa CSN on HOU.cd_consig = CSN.Cd_Pes
		left Join Endereco EndCSN on HOU.cd_consig = EndCSN.Cd_Pes and EndCSN.Cd_Tp_End ='COM'
		Left Join Comunicacao ComCSN with(nolock) on CSN.cd_pes=ComCSN.cd_pes AND ComCSN.CD_TP_COM='TC1'
		left Join Pessoa NFY on HOU.Cd_Notify = NFY.Cd_Pes
		left Join Endereco EndNFY on HOU.Cd_Notify = EndNFY.Cd_Pes and EndNFY.Cd_Tp_End ='COM'
		Left Join Comunicacao ComNFY with(nolock) on NFY.cd_pes=ComNFY.cd_pes AND ComNFY.CD_TP_COM='TC1'
		WHERE
			HOU.NUM_PROC=@NUM_PROC  and DST.Cd_Pais = 'US'
		group by
			SHP.Nome_Raz_Soc,
			EndSHP.Rua,EndSHP.numero,EndSHP.Compl_end,
			EndSHP.Cidade,
			EndSHP.uf,
			EndSHP.Cd_Pais,
			EndSHP.cep,
			ComSHP.Prefixo,ComSHP.Num_Fone,
			CSN.Nome_Raz_Soc,
			EndCSN.Rua,EndCSN.numero,EndCSN.Compl_end,
			EndCSN.Cidade,
			EndCSN.uf,
			EndCSN.Cd_Pais,
			EndCSN.cep,
			ComCSN.Prefixo,ComCSN.Num_Fone,
			NFY.Nome_Raz_Soc,
			EndNFY.Rua,EndNFY.numero,EndNFY.Compl_end,
			EndNFY.Cidade,
			EndNFY.uf,
			EndNFY.Cd_Pais,
			EndNFY.cep,
			ComNFY.Prefixo,ComNFY.Num_Fone,
			HOU.Qtd_Vol,
			HOU.Peso_Bruto,
			HOU.Peso_Liquido,
			dbo.FRemoveCaracteresEspeciais(NG.Descr),
			HOU.NUM_PROC
	
	End
/*
			select  
		
			ISNULL(ISNULL(PS.Qty,HOU.Qtd_Vol),'Not Informed') Pieces,  
			ISNULL(isnull(PD.peso_bruto_tot,HOU.Peso_Bruto),'Not Informed') [Peso Bruto] ,
			ISNULL(ISNULL(PD.peso_liquido_tot, HOU.Peso_Liquido),'Not Informed') [Peso Liquido],
			ISNULL(replace(ltrim(rtrim(Produto_descr )),char(160),''),left(dbo.FRemoveCaracteresEspeciais(NG.Descr),255)),
		
			Peso_Uom, 
			Isnull(LEFT(NCM,6),'')+'00' NCM_CODE,
			TIPO.cd_dst,
			Descr_org,UOM,
			cd_tp_moeda,
			cd_proc_cliente GMID,
			replace(ltrim(rtrim(Produto_descr )),char(160),'') BrandName,
			
			NCM,Natop,
			UOM Tipo_Unid,
			UOM_PRC, 
			Case 
				When Vlr_Item > 10000 then Vlr_Item/100000
				else Vlr_Item
			End
				
			preco_unit
			,PED.cd_tp_moeda,
			peso_item Peso_bruto,
			peso_invoice,
			peso_bruto_tot,
			peso_liquido_tot,
			ps.lote,
			Isnull(Descricao_Termo,'60 Days of Invoice Date') Termo,
			Isnull(TP.Cd_Termo,'281') cd_Termo,
			'PedidoD' 
		from vwHouse_Exp HOU With(Nolock)
		left join pedido_ship PS on PS.Num_Proc = HOU.NUM_PROC
		left Join Produto_Cliente PC With(Nolock) on PC.cd_prod=cd_produto
		left Join Pedido_DET PD With(Nolock) on PS.cd_produto=PD.cd_produto and PS.cd_pedido=PD.cd_pedido
		left Join Pedido  PED With(Nolock) on PED.cd_pedido=PS.cd_pedido
		Left Join De_Para TIPO With(Nolock) on TIPO.cd_org=UOM and Tipo.cd_tipo=3
		left Join TErmo_PAgamento TP With(Nolock) on cast(TP.cd_termo as varchar(30))=PED.payment
		left Join Nature_Goods NG on NG.Num_Proc = HOU.Num_Proc
		left Join Pessoa SHP on HOU.Cd_Export = SHP.Apelido
		WHERE
			HOU.NUM_PROC=@NUM_PROC 
		group by

		UOM,cd_tp_moeda,cd_proc_cliente ,Produto_descr ,PS.Qty ,NCM,Natop,UOM ,UOM_PRC,Vlr_Item ,PED.cd_tp_moeda,peso_item,
		TIPO.cd_dst,Descr_org,UOM,cd_tp_moeda,peso_invoice,peso_liquido_tot,peso_bruto_tot,LEFT(NCM,6),PS.lote ,
		Peso_Uom,Descricao_Termo,TP.cd_Termo,HOU.Qtd_Vol,HOU.Peso_Bruto,HOU.Peso_Liquido,NG.Descr
*/
--select * from ATL_INT.dbo.Smart_XML
--where Num_Proc = 'EAATL201806002BR'


--ALTER procedure  [dbo].[spATL_ACAS_Trigger_Sel](
--	@Num_Proc varchar(16)
--)
--as
----Declare @Num_Proc varchar(16)
----Set @Num_Proc = 'EAATL201806002BR'

--if exists(select Num_proc from Pedido_Ship where Num_Proc = @Num_Proc)
--	Begin

--			select  
--			ISNULL(replace(ltrim(rtrim(Produto_descr )),char(160),''),'Not Infomated') [Cargo Description],
--			ISNULL(cast(cast(PS.Qty as decimal(18,3)) as varchar(200)),'Not Infomated') [Number of Pieces],  
--			ISNULL(cast(cast(PD.peso_bruto_tot as decimal(18,3)) as varchar(200)),'Not Infomated') [Gross Weight] ,
--			ISNULL(cast(cast(PD.peso_liquido_tot as decimal(18,3)) as varchar(200)),'Not Infomated') [Net Weight],
--			'Name: ' + SHP.Nome_Raz_Soc + CHAR(10)+CHAR(13) +
--			'Street Address: ' + Isnull(EndSHP.Rua,'')+ ' ' + Isnull(EndSHP.numero,'') + ' ' + Isnull(EndSHP.Compl_end,'') + CHAR(13)+CHAR(10) +
--			'City: ' + isnull(EndSHP.Cidade,'') +  CHAR(13)+CHAR(10) +
--			--'State or Province: ' + isnull(EndSHP.uf,'') +  CHAR(13)+CHAR(10) +
--			'Country Code: ' + isnull(EndSHP.Cd_Pais,'') +  CHAR(13)+CHAR(10) +
--			--'Postal Code: ' + isnull(EndSHP.cep,'') +  CHAR(13)+CHAR(10) +
--			'Telephone Number: ' + isnull((Isnull(ComSHP.Prefixo,'') + '-' + Isnull(ComSHP.Num_Fone,'')),'') [Shipper],
			
--			'Name: ' +  CSN.Nome_Raz_Soc +  CHAR(13)+CHAR(10) +
--			'Street Address: ' + Isnull(EndCSN.Rua,'')+ ' ' + Isnull(EndCSN.numero,'') + ' ' + Isnull(EndCSN.Compl_end,'') +  CHAR(13)+CHAR(10) +
--			'City: ' + isnull(EndCSN.Cidade,'') +  CHAR(13)+CHAR(10) +
--			--'State or Province: ' + isnull(EndCSN.uf,'') +  CHAR(13)+CHAR(10) +
--			'Country Code: ' + isnull(EndCSN.Cd_Pais,'') 
--			--'Postal Code: ' + isnull(EndCSN.cep,'') +  CHAR(13)+CHAR(10) +
--			--'Telephone Number: ' + isnull((Isnull(ComCSN.Prefixo,'') + '-' + Isnull(ComCSN.Num_Fone,'')),'') 
--			[Consignee],
			
--			'Name: ' +  NFY.Nome_Raz_Soc +  CHAR(13)+CHAR(10) +
--			'Street Address: ' + Isnull(EndNFY.Rua,'')+ ' ' + Isnull(EndNFY.numero,'') + ' ' + Isnull(EndNFY.Compl_end,'') +  CHAR(13)+CHAR(10) +
--			'City: ' + isnull(EndNFY.Cidade,'') +  CHAR(13)+CHAR(10) +
--			--'State or Province: ' + isnull(EndNFY.uf,'') +  CHAR(13)+CHAR(10) +
--			'Country Code: ' + isnull(EndNFY.Cd_Pais,'')
--			--'Postal Code: ' + isnull(EndNFY.cep,'') +  CHAR(13)+CHAR(10) +
--			--'Telephone Number: ' + isnull((Isnull(ComNFY.Prefixo,'') + '-' + Isnull(ComNFY.Num_Fone,'')),'') 
--			[Notify]
			
--		from vwHouse_Exp HOU With(Nolock)
--		left join pedido_ship PS on PS.Num_Proc = HOU.NUM_PROC
--		left Join Produto_Cliente PC With(Nolock) on PC.cd_prod=cd_produto
--		left Join Pedido_DET PD With(Nolock) on PS.cd_produto=PD.cd_produto and PS.cd_pedido=PD.cd_pedido
--		left Join Pedido  PED With(Nolock) on PED.cd_pedido=PS.cd_pedido
--		Left Join De_Para TIPO With(Nolock) on TIPO.cd_org=UOM and Tipo.cd_tipo=3
--		left Join TErmo_PAgamento TP With(Nolock) on cast(TP.cd_termo as varchar(30))=PED.payment
--		left Join Nature_Goods NG on NG.Num_Proc = HOU.Num_Proc
--		left Join Pessoa SHP on HOU.Cd_Export = SHP.Cd_Pes
--		left Join Endereco EndSHP on HOU.Cd_Export = EndSHP.Cd_Pes and EndSHP.cd_Tp_end='COM'
--		Left Join Comunicacao ComSHP with(nolock) on EndSHP.cd_pes=ComSHP.cd_pes AND ComSHP.CD_TP_COM='TC1'
--		left Join Pessoa CSN on HOU.cd_consig = CSN.Cd_Pes
--		left Join Endereco EndCSN on HOU.cd_consig = EndCSN.Cd_Pes and EndCSN.Cd_Tp_End ='COM'
--		Left Join Comunicacao ComCSN with(nolock) on CSN.cd_pes=ComCSN.cd_pes AND ComCSN.CD_TP_COM='TC1'
--		left Join Pessoa NFY on HOU.Cd_Notify = NFY.Cd_Pes
--		left Join Endereco EndNFY on HOU.Cd_Notify = EndNFY.Cd_Pes and EndNFY.Cd_Tp_End ='COM'
--		Left Join Comunicacao ComNFY with(nolock) on NFY.cd_pes=ComNFY.cd_pes AND ComNFY.CD_TP_COM='TC1'
--		WHERE
--			HOU.NUM_PROC=@NUM_PROC 
--		group by
--			SHP.Nome_Raz_Soc,
--			EndSHP.Rua,EndSHP.numero,EndSHP.Compl_end,
--			EndSHP.Cidade,
--			EndSHP.uf,
--			EndSHP.Cd_Pais,
--			EndSHP.cep,
--			ComSHP.Prefixo,ComSHP.Num_Fone,
--			CSN.Nome_Raz_Soc,
--			EndCSN.Rua,EndCSN.numero,EndCSN.Compl_end,
--			EndCSN.Cidade,
--			EndCSN.uf,
--			EndCSN.Cd_Pais,
--			EndCSN.cep,
--			ComCSN.Prefixo,ComCSN.Num_Fone,
--			NFY.Nome_Raz_Soc,
--			EndNFY.Rua,EndNFY.numero,EndNFY.Compl_end,
--			EndNFY.Cidade,
--			EndNFY.uf,
--			EndNFY.Cd_Pais,
--			EndNFY.cep,
--			ComNFY.Prefixo,ComNFY.Num_Fone,
--			PS.Qty,
--			PD.peso_bruto_tot,
--			PD.peso_liquido_tot,
--			replace(ltrim(rtrim(Produto_descr )),char(160),'')
--	END
--Else
--	Begin
	
--			select 
--			ISNULL(left(dbo.FRemoveCaracteresEspeciais(NG.Descr),255),'Not Infomated') [Cargo Description],
--			ISNULL(cast(cast(HOU.Qtd_Vol  as decimal(18,3)) as varchar(200)),'Not Infomated') [Number of Pieces],
--			ISNULL(cast(cast(HOU.Peso_Bruto as decimal(18,3)) as varchar(200)),'Not Infomated') [Gross Weight] ,
--			ISNULL(cast(cast(HOU.Peso_Liquido as decimal(18,3)) as varchar(200)),'Not Infomated') [Net Weight], 
--						'Name: ' + SHP.Nome_Raz_Soc + CHAR(10)+CHAR(13) +
--			'Street Address: ' + Isnull(EndSHP.Rua,'')+ ' ' + Isnull(EndSHP.numero,'') + ' ' + Isnull(EndSHP.Compl_end,'') + CHAR(13)+CHAR(10) +
--			'City: ' + isnull(EndSHP.Cidade,'') +  CHAR(13)+CHAR(10) +
--			--'State or Province: ' + isnull(EndSHP.uf,'') +  CHAR(13)+CHAR(10) +
--			'Country Code: ' + isnull(EndSHP.Cd_Pais,'') +  CHAR(13)+CHAR(10) +
--			--'Postal Code: ' + isnull(EndSHP.cep,'') +  CHAR(13)+CHAR(10) +
--			'Telephone Number: ' + isnull((Isnull(ComSHP.Prefixo,'') + '-' + Isnull(ComSHP.Num_Fone,'')),'') [Shipper],
			
--			'Name: ' +  CSN.Nome_Raz_Soc +  CHAR(13)+CHAR(10) +
--			'Street Address: ' + Isnull(EndCSN.Rua,'')+ ' ' + Isnull(EndCSN.numero,'') + ' ' + Isnull(EndCSN.Compl_end,'') +  CHAR(13)+CHAR(10) +
--			'City: ' + isnull(EndCSN.Cidade,'') +  CHAR(13)+CHAR(10) +
--			--'State or Province: ' + isnull(EndCSN.uf,'') +  CHAR(13)+CHAR(10) +
--			'Country Code: ' + isnull(EndCSN.Cd_Pais,'') 
--			--'Postal Code: ' + isnull(EndCSN.cep,'') +  CHAR(13)+CHAR(10) +
--			--'Telephone Number: ' + isnull((Isnull(ComCSN.Prefixo,'') + '-' + Isnull(ComCSN.Num_Fone,'')),'') 
--			[Consignee],
			
--			'Name: ' +  NFY.Nome_Raz_Soc +  CHAR(13)+CHAR(10) +
--			'Street Address: ' + Isnull(EndNFY.Rua,'')+ ' ' + Isnull(EndNFY.numero,'') + ' ' + Isnull(EndNFY.Compl_end,'') +  CHAR(13)+CHAR(10) +
--			'City: ' + isnull(EndNFY.Cidade,'') +  CHAR(13)+CHAR(10) +
--			--'State or Province: ' + isnull(EndNFY.uf,'') +  CHAR(13)+CHAR(10) +
--			'Country Code: ' + isnull(EndNFY.Cd_Pais,'')
--			--'Postal Code: ' + isnull(EndNFY.cep,'') +  CHAR(13)+CHAR(10) +
--			--'Telephone Number: ' + isnull((Isnull(ComNFY.Prefixo,'') + '-' + Isnull(ComNFY.Num_Fone,'')),'') 
--			[Notify]

			
--		from vwHouse_Exp HOU With(Nolock)
--		left Join Nature_Goods NG on NG.Num_Proc = HOU.Num_Proc
--		left Join Pessoa SHP on HOU.Cd_Export = SHP.Cd_Pes
--		left Join Endereco EndSHP on HOU.Cd_Export = EndSHP.Cd_Pes and EndSHP.cd_Tp_end='COM'
--		Left Join Comunicacao ComSHP with(nolock) on EndSHP.cd_pes=ComSHP.cd_pes AND ComSHP.CD_TP_COM='TC1'
--		left Join Pessoa CSN on HOU.cd_consig = CSN.Cd_Pes
--		left Join Endereco EndCSN on HOU.cd_consig = EndCSN.Cd_Pes and EndCSN.Cd_Tp_End ='COM'
--		Left Join Comunicacao ComCSN with(nolock) on CSN.cd_pes=ComCSN.cd_pes AND ComCSN.CD_TP_COM='TC1'
--		left Join Pessoa NFY on HOU.Cd_Notify = NFY.Cd_Pes
--		left Join Endereco EndNFY on HOU.Cd_Notify = EndNFY.Cd_Pes and EndNFY.Cd_Tp_End ='COM'
--		Left Join Comunicacao ComNFY with(nolock) on NFY.cd_pes=ComNFY.cd_pes AND ComNFY.CD_TP_COM='TC1'
--		WHERE
--			HOU.NUM_PROC=@NUM_PROC 
--		group by
--			SHP.Nome_Raz_Soc,
--			EndSHP.Rua,EndSHP.numero,EndSHP.Compl_end,
--			EndSHP.Cidade,
--			EndSHP.uf,
--			EndSHP.Cd_Pais,
--			EndSHP.cep,
--			ComSHP.Prefixo,ComSHP.Num_Fone,
--			CSN.Nome_Raz_Soc,
--			EndCSN.Rua,EndCSN.numero,EndCSN.Compl_end,
--			EndCSN.Cidade,
--			EndCSN.uf,
--			EndCSN.Cd_Pais,
--			EndCSN.cep,
--			ComCSN.Prefixo,ComCSN.Num_Fone,
--			NFY.Nome_Raz_Soc,
--			EndNFY.Rua,EndNFY.numero,EndNFY.Compl_end,
--			EndNFY.Cidade,
--			EndNFY.uf,
--			EndNFY.Cd_Pais,
--			EndNFY.cep,
--			ComNFY.Prefixo,ComNFY.Num_Fone,
--			HOU.Qtd_Vol,
--			HOU.Peso_Bruto,
--			HOU.Peso_Liquido,
--			dbo.FRemoveCaracteresEspeciais(NG.Descr)
	
--	End
--/*
--			select  
		
--			ISNULL(ISNULL(PS.Qty,HOU.Qtd_Vol),'Not Infomated') Pieces,  
--			ISNULL(isnull(PD.peso_bruto_tot,HOU.Peso_Bruto),'Not Infomated') [Peso Bruto] ,
--			ISNULL(ISNULL(PD.peso_liquido_tot, HOU.Peso_Liquido),'Not Infomated') [Peso Liquido],
--			ISNULL(replace(ltrim(rtrim(Produto_descr )),char(160),''),left(dbo.FRemoveCaracteresEspeciais(NG.Descr),255)),
		
--			Peso_Uom, 
--			Isnull(LEFT(NCM,6),'')+'00' NCM_CODE,
--			TIPO.cd_dst,
--			Descr_org,UOM,
--			cd_tp_moeda,
--			cd_proc_cliente GMID,
--			replace(ltrim(rtrim(Produto_descr )),char(160),'') BrandName,
			
--			NCM,Natop,
--			UOM Tipo_Unid,
--			UOM_PRC, 
--			Case 
--				When Vlr_Item > 10000 then Vlr_Item/100000
--				else Vlr_Item
--			End
				
--			preco_unit
--			,PED.cd_tp_moeda,
--			peso_item Peso_bruto,
--			peso_invoice,
--			peso_bruto_tot,
--			peso_liquido_tot,
--			ps.lote,
--			Isnull(Descricao_Termo,'60 Days of Invoice Date') Termo,
--			Isnull(TP.Cd_Termo,'281') cd_Termo,
--			'PedidoD' 
--		from vwHouse_Exp HOU With(Nolock)
--		left join pedido_ship PS on PS.Num_Proc = HOU.NUM_PROC
--		left Join Produto_Cliente PC With(Nolock) on PC.cd_prod=cd_produto
--		left Join Pedido_DET PD With(Nolock) on PS.cd_produto=PD.cd_produto and PS.cd_pedido=PD.cd_pedido
--		left Join Pedido  PED With(Nolock) on PED.cd_pedido=PS.cd_pedido
--		Left Join De_Para TIPO With(Nolock) on TIPO.cd_org=UOM and Tipo.cd_tipo=3
--		left Join TErmo_PAgamento TP With(Nolock) on cast(TP.cd_termo as varchar(30))=PED.payment
--		left Join Nature_Goods NG on NG.Num_Proc = HOU.Num_Proc
--		left Join Pessoa SHP on HOU.Cd_Export = SHP.Apelido
--		WHERE
--			HOU.NUM_PROC=@NUM_PROC 
--		group by

--		UOM,cd_tp_moeda,cd_proc_cliente ,Produto_descr ,PS.Qty ,NCM,Natop,UOM ,UOM_PRC,Vlr_Item ,PED.cd_tp_moeda,peso_item,
--		TIPO.cd_dst,Descr_org,UOM,cd_tp_moeda,peso_invoice,peso_liquido_tot,peso_bruto_tot,LEFT(NCM,6),PS.lote ,
--		Peso_Uom,Descricao_Termo,TP.cd_Termo,HOU.Qtd_Vol,HOU.Peso_Bruto,HOU.Peso_Liquido,NG.Descr
--*/
----select * from ATL_INT.dbo.Smart_XML
----where Num_Proc = 'EAATL201806002BR'


GO
