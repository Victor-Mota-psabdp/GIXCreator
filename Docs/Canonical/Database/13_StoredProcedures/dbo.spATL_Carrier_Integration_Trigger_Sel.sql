SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*
Estou tentando ver o q eh obrigatorio
 - Pedido Det Qty
 - Pedido Det Package
 - Container
 - Agente
*/

--select * from vwContainer where num_proc = 'EMCSR202101056BR'
CREATE procedure  [dbo].[spATL_Carrier_Integration_Trigger_Sel]
(
	@Num_Proc varchar(16)
)
as

select 
	(Case when PS.Qtde_Embal = 0 then 'Not Informed' else
		ISNULL(cast(cast(PS.Qtde_Embal as int) as varchar(200)),'Not Informed') end) [Package Type Qty], 
	ISNULL(replace(ltrim(rtrim(TE.Nome_tp_Embal)),char(160),''),'Not Informed') [Package Type],	
	ISNULL(replace(ltrim(rtrim(CC.Container)),char(160),''),'Not Informed') [Container],
	ISNULL(replace(ltrim(rtrim(Agente.Apelido)),char(160),''),'Not Informed') [Agent],
	ISNULL(replace(ltrim(rtrim(ED.Rua)),char(160),''),'Not Informed') [Agent Street],
	ISNULL(replace(ltrim(rtrim(ED.Cidade)),char(160),''),'Not Informed') [Agent City],
	ISNULL(replace(ltrim(rtrim(PSC.Num_Cont)),char(160),''),'Not Informed') [Container x PO]
from vwHouse_Exp HOU With(Nolock)
left join vwPedidoShipxPedido PS on PS.Num_Proc = HOU.NUM_PROC
left Join Produto_Cliente PC With(Nolock) on PS.cd_produto = PC.cd_prod and PS.cd_grupo = PC.cd_cliente
left join Pedido_Ship_Container PSC  With(nolock) on PS.Cd_pedido = PSC.Cd_Pedido and PS.cd_produto=PSC.cd_produto and PS.Item = PSC.Item and PS.Lote = PSC.Lote and PS.Num_Proc=PSC.Num_Proc		
--left Join Pedido_DET PD With(Nolock) on PS.cd_produto=PD.cd_produto and PS.cd_pedido=PD.cd_pedido and PS.Item = PD.Item and PS.Lote = PD.Lote	
--left Join Pedido  PED With(Nolock) on PED.cd_pedido=PS.cd_pedido	
left Join Pessoa Agente  With(Nolock) on HOU.cd_Agente = Agente.Cd_Pes
Left Join Endereco ED with(nolock) on HOU.cd_Agente=ED.cd_pes and ED.cd_Tp_end='COM'
left Join Tipo_Embalagem TE With(Nolock) on cast(TE.cd_tp_embal as varchar(30))=PS.cd_tp_embal
left join vwContainer CC With(Nolock) on CC.num_proc = HOU.num_proc and PSC.num_cont = CC.Container
WHERE
HOU.NUM_PROC=@Num_Proc


--Declare @Num_Proc varchar(16)
--Set @Num_Proc = 'EAATL201806002BR'
	--	select  
	--		(Case when PD.Qtde_Embal = 0 then 'Not Informed' else
	--			ISNULL(cast(cast(PD.Qtde_Embal as int) as varchar(200)),'Not Informed') end) [Package Type Qty], 
	--		ISNULL(replace(ltrim(rtrim(TE.Nome_tp_Embal)),char(160),''),'Not Informed') [Package Type],	
	--		ISNULL(replace(ltrim(rtrim(CC.Container)),char(160),''),'Not Informed') [Container],
	--		ISNULL(replace(ltrim(rtrim(Agente.Apelido)),char(160),''),'Not Informed') [Agente],
	--		ISNULL(replace(ltrim(rtrim(PSC.Num_Cont)),char(160),''),'Not Informed') [Container x PO]
			
			
	--		--ISNULL(replace(ltrim(rtrim(Produto_descr )),char(160),''),'Not Informed') [Cargo Description],
	--		----ISNULL(cast(cast(PS.Qty as decimal(18,3)) as varchar(200)),'Not Informed') [Number of Pieces],  
			 
	--		--ISNULL(cast(cast(PD.peso_bruto_tot as decimal(18,3)) as varchar(200)),'Not Informed') [Gross Weight] ,
	--		--ISNULL(cast(cast(PD.peso_liquido_tot as decimal(18,3)) as varchar(200)),'Not Informed') [Net Weight],
	--		----isnull([dbo].[fBusca_Volumes](HOU.NUM_PROC),'Not Informed') [Volume],
	--		--'Name: ' + SHP.Nome_Raz_Soc + CHAR(10)+CHAR(13) +
	--		--'Street Address: ' + Isnull(EndSHP.Rua,'')+ ' ' + Isnull(EndSHP.numero,'') + ' ' + Isnull(EndSHP.Compl_end,'') + CHAR(13)+CHAR(10) +
	--		--'City: ' + isnull(EndSHP.Cidade,'') +  CHAR(13)+CHAR(10) +
	--		----'State or Province: ' + isnull(EndSHP.uf,'') +  CHAR(13)+CHAR(10) +
	--		--'Country Code: ' + isnull(EndSHP.Cd_Pais,'') +  CHAR(13)+CHAR(10) +
	--		----'Postal Code: ' + isnull(EndSHP.cep,'') +  CHAR(13)+CHAR(10) +
	--		--'Telephone Number: ' + isnull((Isnull(ComSHP.Prefixo,'') + '-' + Isnull(ComSHP.Num_Fone,'')),'') [Shipper],
			
	--		--'Name: ' +  CSN.Nome_Raz_Soc +  CHAR(13)+CHAR(10) +
	--		--'Street Address: ' + Isnull(EndCSN.Rua,'')+ ' ' + Isnull(EndCSN.numero,'') + ' ' + Isnull(EndCSN.Compl_end,'') +  CHAR(13)+CHAR(10) +
	--		--'City: ' + isnull(EndCSN.Cidade,'') +  CHAR(13)+CHAR(10) +
	--		----'State or Province: ' + isnull(EndCSN.uf,'') +  CHAR(13)+CHAR(10) +
	--		--'Country Code: ' + isnull(EndCSN.Cd_Pais,'') 
	--		----'Postal Code: ' + isnull(EndCSN.cep,'') +  CHAR(13)+CHAR(10) +
	--		----'Telephone Number: ' + isnull((Isnull(ComCSN.Prefixo,'') + '-' + Isnull(ComCSN.Num_Fone,'')),'') 
	--		--[Consignee],
			
	--		--'Name: ' +  NFY.Nome_Raz_Soc +  CHAR(13)+CHAR(10) +
	--		--'Street Address: ' + Isnull(EndNFY.Rua,'')+ ' ' + Isnull(EndNFY.numero,'') + ' ' + Isnull(EndNFY.Compl_end,'') +  CHAR(13)+CHAR(10) +
	--		--'City: ' + isnull(EndNFY.Cidade,'') +  CHAR(13)+CHAR(10) +
	--		----'State or Province: ' + isnull(EndNFY.uf,'') +  CHAR(13)+CHAR(10) +
	--		--'Country Code: ' + isnull(EndNFY.Cd_Pais,'')
	--		----'Postal Code: ' + isnull(EndNFY.cep,'') +  CHAR(13)+CHAR(10) +
	--		----'Telephone Number: ' + isnull((Isnull(ComNFY.Prefixo,'') + '-' + Isnull(ComNFY.Num_Fone,'')),'') 
	--		--[Notify]
			
	--	from vwHouse_Exp HOU With(Nolock)
	--	left join Localidade DST on DST.Cd_Local = HOU.Cd_Dst
	--	left join pedido_ship PS on PS.Num_Proc = HOU.NUM_PROC
	--	left Join Produto_Cliente PC With(Nolock) on PC.cd_prod=PS.cd_produto
	--	left join Pedido_Ship_Container PSC  With(nolock) on PS.Cd_pedido = PSC.Cd_Pedido and PS.cd_produto=PSC.cd_produto and PS.Item = PSC.Item and PS.Lote = PSC.Lote and PS.Num_Proc=PSC.Num_Proc		
	--	left Join Pedido_DET PD With(Nolock) on PS.cd_produto=PD.cd_produto and PS.cd_pedido=PD.cd_pedido and PS.Item = PD.Item and PS.Lote = PD.Lote	
	--	left Join Pedido  PED With(Nolock) on PED.cd_pedido=PS.cd_pedido
	
	--	--left Join Pessoa SHP on HOU.Cd_Export = SHP.Cd_Pes
	--	--left Join Endereco EndSHP on HOU.Cd_Export = EndSHP.Cd_Pes and EndSHP.cd_Tp_end='COM'
	--	--Left Join Comunicacao ComSHP with(nolock) on EndSHP.cd_pes=ComSHP.cd_pes AND ComSHP.CD_TP_COM='TC1'
	--	--left Join Pessoa CSN on HOU.cd_consig = CSN.Cd_Pes
	--	--left Join Endereco EndCSN on HOU.cd_consig = EndCSN.Cd_Pes and EndCSN.Cd_Tp_End ='COM'
	--	--Left Join Comunicacao ComCSN with(nolock) on CSN.cd_pes=ComCSN.cd_pes AND ComCSN.CD_TP_COM='TC1'
	--	--left Join Pessoa NFY on HOU.Cd_Notify = NFY.Cd_Pes
	--	--left Join Endereco EndNFY on HOU.Cd_Notify = EndNFY.Cd_Pes and EndNFY.Cd_Tp_End ='COM'
	--	--Left Join Comunicacao ComNFY with(nolock) on NFY.cd_pes=ComNFY.cd_pes AND ComNFY.CD_TP_COM='TC1'

	--	left Join Pessoa Agente  With(Nolock) on HOU.cd_Agente = Agente.Cd_Pes
	--	left Join Tipo_Embalagem TE With(Nolock) on cast(TE.cd_tp_embal as varchar(30))=PD.cd_tp_embal
	--	left join vwContainer CC With(Nolock) on CC.num_proc = HOU.num_proc
	--WHERE
	--	HOU.NUM_PROC=@Num_Proc
			
		--and DST.Cd_Pais = 'US'
		--group by
		--	SHP.Nome_Raz_Soc,EndSHP.Rua,EndSHP.numero,EndSHP.Compl_end,EndSHP.Cidade,EndSHP.uf,EndSHP.Cd_Pais,
		--	EndSHP.cep,ComSHP.Prefixo,ComSHP.Num_Fone,CSN.Nome_Raz_Soc,EndCSN.Rua,EndCSN.numero,EndCSN.Compl_end,
		--	EndCSN.Cidade,EndCSN.uf,EndCSN.Cd_Pais,EndCSN.cep,ComCSN.Prefixo,ComCSN.Num_Fone,NFY.Nome_Raz_Soc,
		--	EndNFY.Rua,EndNFY.numero,EndNFY.Compl_end,EndNFY.Cidade,EndNFY.uf,EndNFY.Cd_Pais,EndNFY.cep,
		--	ComNFY.Prefixo,ComNFY.Num_Fone,PS.Qty,PD.peso_bruto_tot,PD.peso_liquido_tot,replace(ltrim(rtrim(Produto_descr )),char(160),''),
		--	HOU.NUM_PROC
	


GO
