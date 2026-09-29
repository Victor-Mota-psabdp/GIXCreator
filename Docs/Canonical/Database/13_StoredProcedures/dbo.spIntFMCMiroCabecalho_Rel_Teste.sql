SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO










-- dbo].[spBuscaPorcentagem_Pedido]
--			@Num_Proc Char(16),
--			@Item	Varchar(10),
--			@Num_Pedido Varchar(30)


--[spIntFMCMiroCabecalho_Rel_teste] 'IMFMC201112041BR','1',45



CREATE Procedure [dbo].[spIntFMCMiroCabecalho_Rel_Teste]
		@Num_PRoc	Varchar(16),
		@Tipo		Varchar(1),
		@ID_Miro	int
--spIntFMCMiroCabecalho_Rel 'IMFMC20090302301'
as	
Declare @FreteDI float

Set @FreteDI=0
Set @FreteDI=Isnull((select sum(vlr_item_Custo) from custo_cliente where num_proc=@num_proc and cd_tp_Tx='YDI'),0)

SELECT 
		dt_envio, dbo.fBusca_TipoDocCliente('N',hou.num_proc_him,1) Nota_Fiscal,
		sum(vlr_item_custo) Valor,
		di.numero_po_him DI_Number,hou.num_proc_him, convert(float,[dbo].[fBusca_CampoCliente](hou.num_proc_him,31)) paridade,
		Sum(vlr_item_custo*Isnull(Prc_Inss,0)) INSS, dbo.fBusca_TipoDocCliente('N',hou.num_proc_him,2) Invoice_Fornecedor,
		@FreteDI FreteDI

FROM
	custo_cliente CC
	Join Fmc_Miro Miro on Miro.id_miro=cc.num_nf_custo
	Join House_imp_mar hou on hou.num_proc_him=cc.num_proc
--	Join IntFMC_Plano_Contas PC on miro.id_evento=pc.id_evento and PC.cd_tp_tx=cc.cd_tp_Tx and cd_pes=cd_Export_him
	Join FMC_Plano_Contas_V2 PC on pc.cd_Tp_tx=cc.cd_tp_tx and miro.id_evento=pc.id_evento
	Join Tipo_Taxa TT on TT.cd_tp_tx=cc.cd_tp_Tx
--	Join Pedido_ship PS on Ps.num_proc=num_proc_him and ps.cd_produto=cc.cd_produto
--	Join Pedido PD on PD.cd_pedido=PS.cd_pedido
--	Left Join Nota_Cliente NC on num_proc_him=NC.num_proc
	Left Join PO_HIM DI on DI.num_proc_him=hou.num_proc_him and DI.id_dc=5
	
where	
	cc.num_proc=@num_proc and PC.tipo=@tipo and miro.id_miro=@id_miro
group by 
	dbo.fBusca_PO_NumPedido(hou.num_proc_him,3) ,
	dbo.fBusca_PO_NumPedido(hou.num_proc_him,5),
	dt_envio,hou.num_proc_him,di.numero_po_him 


union


SELECT 
		dt_envio, dbo.fBusca_TipoDocCliente('N',hou.num_proc_hia,1) Nota_Fiscal,
		sum(vlr_item_custo) Valor,
		di.numero_po_hia DI_Number,hou.num_proc_hia, convert(float,[dbo].[fBusca_CampoCliente](hou.num_proc_hia,31)) paridade,
		Sum(vlr_item_custo*Isnull(Prc_Inss,0)) INSS,  dbo.fBusca_TipoDocCliente('N',hou.num_proc_hia,2) Invoice_Fornecedor,
		@FreteDI FreteDI

FROM
	custo_cliente CC
	Join Fmc_Miro Miro on Miro.id_miro=cc.num_nf_custo
	Join House_imp_aer hou on hou.num_proc_hia=cc.num_proc
--	Join IntFMC_Plano_Contas PC on miro.id_evento=pc.id_evento and PC.cd_tp_tx=cc.cd_tp_Tx and cd_pes=cd_Export_him
	Join FMC_Plano_Contas_V2 PC on pc.cd_Tp_tx=cc.cd_tp_tx and miro.id_evento=pc.id_evento
	Join Tipo_Taxa TT on TT.cd_tp_tx=cc.cd_tp_Tx
	Join Pedido_ship PS on Ps.num_proc=num_proc_hia and ps.cd_produto=cc.cd_produto
	Join Pedido PD on PD.cd_pedido=PS.cd_pedido
--	Left Join Nota_Cliente NC on num_proc_him=NC.num_proc
	Left Join PO_HIA DI on DI.num_proc_hiA=hou.num_proc_hia and DI.id_dc=5
	
where	
	cc.num_proc=@num_proc and PC.tipo=@tipo and miro.id_miro=@id_miro
group by 
	dbo.fBusca_PO_NumPedido(hou.num_proc_hia,3) ,
	dbo.fBusca_PO_NumPedido(hou.num_proc_hia,5),
	dt_envio,hou.num_proc_hia,di.numero_po_hia 



union


SELECT 
		dt_envio, dbo.fBusca_TipoDocCliente('N',hou.num_proc_hio,1) Nota_Fiscal,
		sum(vlr_item_custo) Valor,
		di.numero_po_hio DI_Number,hou.num_proc_hio, convert(float,[dbo].[fBusca_CampoCliente](hou.num_proc_hio,31)) paridade,
		Sum(vlr_item_custo*Isnull(Prc_Inss,0)) INSS,  dbo.fBusca_TipoDocCliente('N',hou.num_proc_hio,2) Invoice_Fornecedor,
		@FreteDI FreteDI

FROM
	custo_cliente CC
	Join Fmc_Miro Miro on Miro.id_miro=cc.num_nf_custo
	Join House_imp_out hou on hou.num_proc_hio=cc.num_proc
	Join FMC_Plano_Contas_V2 PC on pc.cd_Tp_tx=cc.cd_tp_tx and miro.id_evento=pc.id_evento
	Join Tipo_Taxa TT on TT.cd_tp_tx=cc.cd_tp_Tx
	Join Pedido_ship PS on Ps.num_proc=num_proc_hio and ps.cd_produto=cc.cd_produto
	Join Pedido PD on PD.cd_pedido=PS.cd_pedido
--	Left Join Nota_Cliente NC on num_proc_him=NC.num_proc
	Left Join PO_HIo DI on DI.num_proc_hio=hou.num_proc_hio and DI.id_dc=5
	
where	
	cc.num_proc=@num_proc and PC.tipo=@tipo and miro.id_miro=@id_miro
group by 
	dbo.fBusca_PO_NumPedido(hou.num_proc_hio,3) ,
	dbo.fBusca_PO_NumPedido(hou.num_proc_hio,5),
	dt_envio,hou.num_proc_hio,di.numero_po_hio 



















GO
