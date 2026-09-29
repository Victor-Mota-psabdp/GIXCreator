SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--[spATLINT_JSON_Oxiteno_PurchaseOrderJOB_Sel] NULL, NULL, NULL,'I'
CREATE procedure [dbo].[spATLINT_JSON_Oxiteno_PurchaseOrderJOB_Sel]
(
	@ID_PurchaseOrderJOB	bigint,
	@ref_processo			varchar(200),	
	@ref_oxiteno			varchar(200),
	@Tipo					char(1)
)
as

--sp_help ATL_INT.dbo.JSON_Oxiteno_PurchaseOrderJOB

if @Tipo = 'A' or @Tipo = 'B'
	Begin
		select 		
			J.ID_purchaseOrderJOB [Internal Code],
			J.ref_processo,
			J.id_despachante,
			J.ref_oxiteno,
			J.num_master,
			J.num_house,
			J.num_di,
			J.modal,
			J.canal_di,
			J.origem,
			J.destino,
			J.moeda,
			J.valor_conhec,
			J.peso_bruto,
			J.peso_liquido,
			J.tx_cambial_di,
			J.paridade,
			J.armazem,
			J.vrt_ii,
			J.vrt_pis,
			J.vrt_cofins,
			J.vrt_icms,
			J.vrt_ipi,
			J.vrt_antidumping,
			J.vrt_siscomex,
			J.vrt_afrmm,
			J.total_prestacao,			
			J.Dt_Ins,
			J.Dt_Sent,
			J.Message,
			
			V.cd_cliente	[Client Code],
			P.Apelido		[Client name],
			P.Num_CPF_CNPJ  [Client CNPJ],
			G.Cd_Pes					[Group Code],
			G.Apelido					[Group Name]
		from 
			ATL_INT.dbo.JSON_Oxiteno_PurchaseOrderJOB J with(nolock)		
			LEFT join ATLANTIS.dbo.vwClienteALLJOBS V with (nolock) on V.Num_Proc = J.ref_processo
			LEFT join ATLANTIS.dbo.Pessoa P with (nolock) on V.cd_cliente = P.Cd_Pes		
			LEFT JOIN ATLANTIS.dbo.pessoa_llp llp with (nolock) on llp.Cd_Pes = V.cd_cliente
			--LEFT join ATLANTIS.dbo.Pedido_Ship PS with (nolock) on V.Num_Proc = PS.Num_Proc	
			join ATLANTIS.dbo.Pessoa G with(nolock) on G.cd_pes = 'P21128'	
	End

if @Tipo = 'C' or @Tipo = 'D'
	Begin
		select 		
			J.ID_purchaseOrderJOB [Internal Code],
			J.ref_processo,
			J.id_despachante,
			J.ref_oxiteno,
			J.num_master,
			J.num_house,
			J.num_di,
			J.modal,
			J.canal_di,
			J.origem,
			J.destino,
			J.moeda,
			J.valor_conhec,
			J.peso_bruto,
			J.peso_liquido,
			J.tx_cambial_di,
			J.paridade,
			J.armazem,
			J.vrt_ii,
			J.vrt_pis,
			J.vrt_cofins,
			J.vrt_icms,
			J.vrt_ipi,
			J.vrt_antidumping,
			J.vrt_siscomex,
			J.vrt_afrmm,
			J.total_prestacao,			
			J.Dt_Ins,
			J.Dt_Sent,
			J.Message,
			
			V.cd_cliente	[Client Code],
			P.Apelido		[Client name],
			P.Num_CPF_CNPJ  [Client CNPJ],
			G.Cd_Pes					[Group Code],
			G.Apelido					[Group Name]
		from 
			ATL_INT.dbo.JSON_Oxiteno_PurchaseOrderJOB J with(nolock)		
			LEFT join ATLANTIS.dbo.vwClienteALLJOBS V with (nolock) on V.Num_Proc = J.ref_processo
			LEFT join ATLANTIS.dbo.Pessoa P with (nolock) on V.cd_cliente = P.Cd_Pes		
			LEFT JOIN ATLANTIS.dbo.pessoa_llp llp with (nolock) on llp.Cd_Pes = V.cd_cliente
			--LEFT join ATLANTIS.dbo.Pedido_Ship PS with (nolock) on V.Num_Proc = PS.Num_Proc	
			join ATLANTIS.dbo.Pessoa G with(nolock) on G.cd_pes = 'P21128'	
		where 
			J.ID_purchaseOrderJOB = @ID_PurchaseOrderJOB
	End

if @Tipo = 'N' or @Tipo = 'O'
	Begin
		select 		
			J.ID_purchaseOrderJOB [Internal Code],
			J.ref_processo,
			J.id_despachante,
			J.ref_oxiteno,
			J.num_master,
			J.num_house,
			J.num_di,
			J.modal,
			J.canal_di,
			J.origem,
			J.destino,
			J.moeda,
			J.valor_conhec,
			J.peso_bruto,
			J.peso_liquido,
			J.tx_cambial_di,
			J.paridade,
			J.armazem,
			J.vrt_ii,
			J.vrt_pis,
			J.vrt_cofins,
			J.vrt_icms,
			J.vrt_ipi,
			J.vrt_antidumping,
			J.vrt_siscomex,
			J.vrt_afrmm,
			J.total_prestacao,			
			J.Dt_Ins,
			J.Dt_Sent,
			J.Message,
			
			V.cd_cliente	[Client Code],
			P.Apelido		[Client name],
			P.Num_CPF_CNPJ  [Client CNPJ],
			G.Cd_Pes					[Group Code],
			G.Apelido					[Group Name]
		from 
			ATL_INT.dbo.JSON_Oxiteno_PurchaseOrderJOB J with(nolock)		
			LEFT join ATLANTIS.dbo.vwClienteALLJOBS V with (nolock) on V.Num_Proc = J.ref_processo
			LEFT join ATLANTIS.dbo.Pessoa P with (nolock) on V.cd_cliente = P.Cd_Pes		
			LEFT JOIN ATLANTIS.dbo.pessoa_llp llp with (nolock) on llp.Cd_Pes = V.cd_cliente
			--LEFT join ATLANTIS.dbo.Pedido_Ship PS with (nolock) on V.Num_Proc = PS.Num_Proc	
			join ATLANTIS.dbo.Pessoa G with(nolock) on G.cd_pes = 'P21128'		
		where 
			J.ref_oxiteno = @ref_oxiteno
	End

if @Tipo = 'P'
	Begin
		select 		
			J.ID_purchaseOrderJOB [Internal Code],
			J.ref_processo,
			J.id_despachante,
			J.ref_oxiteno,
			J.num_master,
			J.num_house,
			J.num_di,
			J.modal,
			J.canal_di,
			J.origem,
			J.destino,
			J.moeda,
			J.valor_conhec,
			J.peso_bruto,
			J.peso_liquido,
			J.tx_cambial_di,
			J.paridade,
			J.armazem,
			J.vrt_ii,
			J.vrt_pis,
			J.vrt_cofins,
			J.vrt_icms,
			J.vrt_ipi,
			J.vrt_antidumping,
			J.vrt_siscomex,
			J.vrt_afrmm,
			J.total_prestacao,			
			J.Dt_Ins,
			J.Dt_Sent,
			J.Message,
			
			V.cd_cliente	[Client Code],
			P.Apelido		[Client name],
			P.Num_CPF_CNPJ  [Client CNPJ],
			G.Cd_Pes					[Group Code],
			G.Apelido					[Group Name]
		from 
			ATL_INT.dbo.JSON_Oxiteno_PurchaseOrderJOB J with(nolock)		
			LEFT join ATLANTIS.dbo.vwClienteALLJOBS V with (nolock) on V.Num_Proc = J.ref_processo
			LEFT join ATLANTIS.dbo.Pessoa P with (nolock) on V.cd_cliente = P.Cd_Pes		
			LEFT JOIN ATLANTIS.dbo.pessoa_llp llp with (nolock) on llp.Cd_Pes = V.cd_cliente
			--LEFT join ATLANTIS.dbo.Pedido_Ship PS with (nolock) on V.Num_Proc = PS.Num_Proc	
			join ATLANTIS.dbo.Pessoa G with(nolock) on G.cd_pes = 'P21128'	
		Where
			J.Dt_Sent is null
			--and Dt_INS < getdate() -5
		Order by 
			1
	
	End


if @Tipo = 'Q'
	Begin
		select distinct	
			NULL [Internal Code],
			HOU.Num_Proc ref_processo,
			NULL id_despachante,
			NULL ref_oxiteno,
			NULL num_master,
			NULL num_house,
			NULL num_di,
			NULL modal,
			NULL canal_di,
			NULL origem,
			NULL destino,
			NULL moeda,
			NULL valor_conhec,
			NULL peso_bruto,
			NULL peso_liquido,
			NULL tx_cambial_di,
			NULL paridade,
			NULL armazem,
			NULL vrt_ii,
			NULL vrt_pis,
			NULL vrt_cofins,
			NULL vrt_icms,
			NULL vrt_ipi,
			NULL vrt_antidumping,
			NULL vrt_siscomex,
			NULL vrt_afrmm,
			NULL total_prestacao,			
			NULL Dt_Ins,
			NULL Dt_Sent,
			NULL Message,			
			HOU.cd_consig	[Client Code],
			P.Apelido		[Client name],
			P.Num_CPF_CNPJ  [Client CNPJ],
			G.Cd_Pes		[Group Code],
			G.Apelido		[Group Name]
		from ATLANTIS.dbo.vwHouse_Imp HOU with(nolock)				
			--join ATLANTIS.dbo.Exchange EXC with(nolock) on HOU.NUm_proc COLLATE DATABASE_DEFAULT = EXC.ExcProcesso  COLLATE DATABASE_DEFAULT	
			join ATLANTIS.dbo.Pessoa P with (nolock) on HOU.cd_consig = P.Cd_Pes	
			join ATLANTIS.dbo.Pessoa_LLP LLP with(nolock) on LLP.cd_pes = HOU.cd_consig and LLP.cd_pes_grupo = 'P21128'
			left join ATLANTIS.dbo.Pessoa G with(nolock) on G.cd_pes = LLP.cd_pes_grupo
		Where
			Convert(Datetime,HOU.Dt_Emis,103) > '2022-11-01'
			--and HOU.num_proc not in ('IMOXT202207039BR')
			--and EXC.ExcDataAlt > getdate() -3
			
	End

--if @Tipo = 'X'
--	Begin
--		select 
--			USO.ID_PurchaseOrderJOB [Internal Code],
--			PO.Numero_PO + '/' + convert(varchar(4),year(PO.Data_PO))	ref_oxiteno,
--			HOU.VIAGEM			numero_viagem,
--			HOU.VESSEL			navio,
--			HOU.ETD				etd,
--			HOU.ETA				eta,
--			HOU.Num_Proc			[JOB],			
--			USO.dt_ins			[Insert Date],
--			USO.Dt_Sent			[Sent Date],
--			HOU.Booking_Number
--		from vwHouse_Imp HOU with(nolock)
--			join vwPO_Imp PO with(nolock) on PO.NUm_proc = HOU.Num_Proc
--			left join ATL_INT.dbo.JSON_Oxiteno_PurchaseOrderJOB USO with(nolock) on USO.NUm_proc = HOU.Num_Proc			
--			join Exchange EXC with(nolock) on HOU.NUm_proc COLLATE DATABASE_DEFAULT = EXC.ExcProcesso  COLLATE DATABASE_DEFAULT	
--			join Pessoa_LLP LLP with(nolock) on LLP.cd_pes = HOU.cd_consig and cd_pes_grupo = 'P21128'
--		Where
--			--HOU.num_proc = 'IMOXT201707049BR' and
--			EXC.ExcDataAlt > getdate() -1
--			--and HOU.Booking_Number is not null	
--			and PO.Numero_PO is not null
--	End	

if @Tipo = 'I'--usada na tela do Integrated Received
	Begin
		select 		
			J.ID_purchaseOrderJOB [Internal Code],
			J.ref_processo,
			J.id_despachante,
			J.ref_oxiteno,
			J.num_master,
			J.num_house,
			J.num_di,
			J.modal,
			J.canal_di,
			J.origem,
			J.destino,
			J.moeda,
			J.valor_conhec,
			J.peso_bruto,
			J.peso_liquido,
			J.tx_cambial_di,
			J.paridade,
			J.armazem,
			J.vrt_ii,
			J.vrt_pis,
			J.vrt_cofins,
			J.vrt_icms,
			J.vrt_ipi,
			J.vrt_antidumping,
			J.vrt_siscomex,
			J.vrt_afrmm,
			J.total_prestacao,			
			J.Dt_Ins,
			J.Dt_Sent,
			J.Message,
			
			V.cd_cliente	[Client Code],
			P.Apelido		[Client name],
			P.Num_CPF_CNPJ  [Client CNPJ],
			G.Cd_Pes					[Group Code],
			G.Apelido					[Group Name]
		from 
			ATL_INT.dbo.JSON_Oxiteno_PurchaseOrderJOB J with(nolock)		
			LEFT join ATLANTIS.dbo.vwClienteALLJOBS V with (nolock) on V.Num_Proc = J.ref_processo
			LEFT join ATLANTIS.dbo.Pessoa P with (nolock) on V.cd_cliente = P.Cd_Pes		
			LEFT JOIN ATLANTIS.dbo.pessoa_llp llp with (nolock) on llp.Cd_Pes = V.cd_cliente
			--LEFT join ATLANTIS.dbo.Pedido_Ship PS with (nolock) on V.Num_Proc = PS.Num_Proc	
			join ATLANTIS.dbo.Pessoa G with(nolock) on G.cd_pes = 'P21128'	
		Where
			J.Dt_Ins > getdate() -1
	
	End



GO
