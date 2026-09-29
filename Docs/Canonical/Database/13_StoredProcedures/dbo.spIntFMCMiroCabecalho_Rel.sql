SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[spIntFMCMiroCabecalho_Rel]
		@Num_PRoc	Varchar(16),
		@Tipo		Varchar(1),
		@ID_Miro	int
--spIntFMCMiroCabecalho_Rel 'IMFMC20090302301'
as	
Declare @FreteDI float
Declare @Invoice Varchar(10)

Set @FreteDI=0
Set @FreteDI=Isnull((select sum(vlr_item_Custo) from custo_cliente where num_proc=@num_proc and cd_tp_Tx in ('YDI','XDU')),0)

if @id_miro=5073 
	Begin
		Set @Invoice='01263'
	End
Else
	Begin
		Set @Invoice=null
	End
	
--	i = fatura
--s = seguro
--t = impostos
--r = impostos_recuperaveis 
--f = complementar
--K - ICMS - CHB 2

SELECT 
		dt_envio, 
		--dbo.fBusca_TipoDocCliente('N',hou.num_proc_him,1) Nota_Fiscal,		
		dbo.fBusca_TipoDocCliente('N',hou.num_proc_him,1) + '-' + 
		dbo.fBusca_Pedido_Ship_Item(hou.num_proc_him) + '-' +
		(Case when Miro.ID_Evento = 'S' then '1'
			else 
			(Case when Miro.ID_Evento = 'T' then '2'
				else
				(Case when Miro.ID_Evento = 'C' then '3'
					else
					(Case when Miro.ID_Evento = 'R' then '4'
						else  
						(Case when Miro.ID_Evento = 'F' then '5'
							else  
							(Case when Miro.ID_Evento = 'K' then '6'
							else  
						(Case when Miro.ID_Evento = 'I' then '0'			
		End)End)End)End)End)End) End) Nota_Fiscal,					
		
		
		sum(vlr_item_custo) Valor,
		di.numero_po_him DI_Number,hou.num_proc_him, convert(float,[dbo].[fBusca_CampoCliente](hou.num_proc_him,31)) paridade,
		Sum(vlr_item_custo*Isnull(Prc_Inss,0)) INSS, isnull(@Invoice,dbo.fBusca_TipoDocCliente('N',hou.num_proc_him,2)) Invoice_Fornecedor,
		@FreteDI FreteDI, ISNULL(atd_lim,getdate()) Dt_Base

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
	Join LLP_Imp_Mar L with(nolock) on L.Num_Proc_Lim=CC.Num_Proc 
	
where	
	cc.num_proc=@num_proc and PC.tipo=@tipo and miro.id_miro=@id_miro
group by 
	dbo.fBusca_PO_NumPedido(hou.num_proc_him,3) ,
	dbo.fBusca_PO_NumPedido(hou.num_proc_him,5),
	dt_envio,hou.num_proc_him,di.numero_po_him ,
	ISNULL(atd_lim,getdate()),
	Miro.ID_Evento


union all


SELECT 
		dt_envio, 
		--dbo.fBusca_TipoDocCliente('N',hou.num_proc_hia,1) Nota_Fiscal,
		dbo.fBusca_TipoDocCliente('N',hou.Num_Proc_HIA,1) + '-' + 
		dbo.fBusca_Pedido_Ship_Item(hou.Num_Proc_HIA) + '-' +
		(Case when Miro.ID_Evento = 'S' then '1'
			else 
			(Case when Miro.ID_Evento = 'T' then '2'
				else
				(Case when Miro.ID_Evento = 'C' then '3'
					else
					(Case when Miro.ID_Evento = 'R' then '4'
						else  
						(Case when Miro.ID_Evento = 'F' then '5'
							else  
							(Case when Miro.ID_Evento = 'K' then '6'
							else  
						(Case when Miro.ID_Evento = 'I' then '0'			
		End)End)End)End)End)End) End) Nota_Fiscal,		
		
		
		
		sum(vlr_item_custo) Valor,
		di.numero_po_hia DI_Number,hou.num_proc_hia, convert(float,[dbo].[fBusca_CampoCliente](hou.num_proc_hia,31)) paridade,
		Sum(vlr_item_custo*Isnull(Prc_Inss,0)) INSS,  dbo.fBusca_TipoDocCliente('N',hou.num_proc_hia,2) Invoice_Fornecedor,
		@FreteDI FreteDI, ISNULL(atd_lia,getdate()) Dt_Base

FROM
	custo_cliente CC
	Join Fmc_Miro Miro on Miro.id_miro=cc.num_nf_custo
	Join House_imp_aer hou on hou.num_proc_hia=cc.num_proc
--	Join IntFMC_Plano_Contas PC on miro.id_evento=pc.id_evento and PC.cd_tp_tx=cc.cd_tp_Tx and cd_pes=cd_Export_him
	Join FMC_Plano_Contas_V2 PC on pc.cd_Tp_tx=cc.cd_tp_tx and miro.id_evento=pc.id_evento
	Join Tipo_Taxa TT on TT.cd_tp_tx=cc.cd_tp_Tx
--	Join Pedido_ship PS on Ps.num_proc=num_proc_hia and ps.cd_produto=cc.cd_produto
--	Join Pedido PD on PD.cd_pedido=PS.cd_pedido
--	Left Join Nota_Cliente NC on num_proc_him=NC.num_proc
	Left Join PO_HIA DI on DI.num_proc_hiA=hou.num_proc_hia and DI.id_dc=5
	Join LLP_Imp_aer L with(nolock) on L.Num_Proc_LiA=CC.Num_Proc 

where	
	cc.num_proc=@num_proc and PC.tipo=@tipo and miro.id_miro=@id_miro
group by 
	dbo.fBusca_PO_NumPedido(hou.num_proc_hia,3) ,
	dbo.fBusca_PO_NumPedido(hou.num_proc_hia,5),
	dt_envio,hou.num_proc_hia,di.numero_po_hia,
	ISNULL(atd_lia,getdate()) ,
	Miro.ID_Evento 



union


SELECT 
		dt_envio, 
		--dbo.fBusca_TipoDocCliente('N',hou.num_proc_hio,1) Nota_Fiscal,
		dbo.fBusca_TipoDocCliente('N',hou.Num_Proc_HIO,1) + '-' + 
		dbo.fBusca_Pedido_Ship_Item(hou.Num_Proc_HIO) + '-' +
		(Case when Miro.ID_Evento = 'S' then '1'
			else 
			(Case when Miro.ID_Evento = 'T' then '2'
				else
				(Case when Miro.ID_Evento = 'C' then '3'
					else
					(Case when Miro.ID_Evento = 'R' then '4'
						else  
						(Case when Miro.ID_Evento = 'F' then '5'
							else  
							(Case when Miro.ID_Evento = 'K' then '6'
							else  
						(Case when Miro.ID_Evento = 'I' then '0'			
		End)End)End)End)End)End) End) Nota_Fiscal,		
		
		
		sum(vlr_item_custo) Valor,
		di.numero_po_hio DI_Number,hou.num_proc_hio, convert(float,[dbo].[fBusca_CampoCliente](hou.num_proc_hio,31)) paridade,
		Sum(vlr_item_custo*Isnull(Prc_Inss,0)) INSS,  dbo.fBusca_TipoDocCliente('N',hou.num_proc_hio,2) Invoice_Fornecedor,
		@FreteDI FreteDI,  ISNULL(atd_liO,getdate()) Dt_Base

FROM
	custo_cliente CC
	Join Fmc_Miro Miro on Miro.id_miro=cc.num_nf_custo
	Join House_imp_out hou on hou.num_proc_hio=cc.num_proc
	Join FMC_Plano_Contas_V2 PC on pc.cd_Tp_tx=cc.cd_tp_tx and miro.id_evento=pc.id_evento
	Join Tipo_Taxa TT on TT.cd_tp_tx=cc.cd_tp_Tx
--	Join Pedido_ship PS on Ps.num_proc=num_proc_hio and ps.cd_produto=cc.cd_produto
--	Join Pedido PD on PD.cd_pedido=PS.cd_pedido
--	Left Join Nota_Cliente NC on num_proc_him=NC.num_proc
	Left Join PO_HIo DI on DI.num_proc_hio=hou.num_proc_hio and DI.id_dc=5
	Join LLP_Imp_Out L with(nolock) on L.Num_Proc_Lio=CC.Num_Proc 
	
where	
	cc.num_proc=@num_proc and PC.tipo=@tipo and miro.id_miro=@id_miro
group by 
	dbo.fBusca_PO_NumPedido(hou.num_proc_hio,3) ,
	dbo.fBusca_PO_NumPedido(hou.num_proc_hio,5),
	dt_envio,hou.num_proc_hio,di.numero_po_hio ,
	  ISNULL(atd_liO,getdate()),
	  Miro.ID_Evento 


























---- dbo].[spBuscaPorcentagem_Pedido]
----			@Num_Proc Char(16),
----			@Item	Varchar(10),
----			@Num_Pedido Varchar(30)


----[spIntFMCMiroCabecalho_Rel_teste] 'IMFMC201112041BR','1',45
--ALTER Procedure [dbo].[spIntFMCMiroCabecalho_Rel]
--		@Num_PRoc	Varchar(16),
--		@Tipo		Varchar(1),
--		@ID_Miro	int
----spIntFMCMiroCabecalho_Rel 'IMFMC20090302301'
--as	
--Declare @FreteDI float
--Declare @Invoice Varchar(10)

--Set @FreteDI=0
--Set @FreteDI=Isnull((select sum(vlr_item_Custo) from custo_cliente where num_proc=@num_proc 
--and cd_tp_Tx in ('YDI','XDU')),0)

--if @id_miro=5073 
--	Begin
--		Set @Invoice='01263'
--	End
--Else
--	Begin
--		Set @Invoice=null
--	End

--SELECT 
--		dt_envio, dbo.fBusca_TipoDocCliente('N',hou.num_proc_him,1) Nota_Fiscal,
--		sum(vlr_item_custo) Valor,
--		di.numero_po_him DI_Number,hou.num_proc_him, convert(float,[dbo].[fBusca_CampoCliente](hou.num_proc_him,31)) paridade,
--		Sum(vlr_item_custo*Isnull(Prc_Inss,0)) INSS, isnull(@Invoice,dbo.fBusca_TipoDocCliente('N',hou.num_proc_him,2)) Invoice_Fornecedor,
--		@FreteDI FreteDI, ISNULL(atd_lim,getdate()) Dt_Base

--FROM
--	custo_cliente CC
--	Join Fmc_Miro Miro on Miro.id_miro=cc.num_nf_custo
--	Join House_imp_mar hou on hou.num_proc_him=cc.num_proc
----	Join IntFMC_Plano_Contas PC on miro.id_evento=pc.id_evento and PC.cd_tp_tx=cc.cd_tp_Tx and cd_pes=cd_Export_him
--	Join FMC_Plano_Contas_V2 PC on pc.cd_Tp_tx=cc.cd_tp_tx and miro.id_evento=pc.id_evento
--	Join Tipo_Taxa TT on TT.cd_tp_tx=cc.cd_tp_Tx
----	Join Pedido_ship PS on Ps.num_proc=num_proc_him and ps.cd_produto=cc.cd_produto
----	Join Pedido PD on PD.cd_pedido=PS.cd_pedido
----	Left Join Nota_Cliente NC on num_proc_him=NC.num_proc
--	Left Join PO_HIM DI on DI.num_proc_him=hou.num_proc_him and DI.id_dc=5
--	Join LLP_Imp_Mar L with(nolock) on L.Num_Proc_Lim=CC.Num_Proc 	
--where	
--	cc.num_proc=@num_proc and PC.tipo=@tipo and miro.id_miro=@id_miro
--group by 
--	dbo.fBusca_PO_NumPedido(hou.num_proc_him,3) ,
--	dbo.fBusca_PO_NumPedido(hou.num_proc_him,5),
--	dt_envio,hou.num_proc_him,di.numero_po_him ,
--	ISNULL(atd_lim,getdate())


--union all


--SELECT 
--		dt_envio, dbo.fBusca_TipoDocCliente('N',hou.num_proc_hia,1) Nota_Fiscal,
--		sum(vlr_item_custo) Valor,
--		di.numero_po_hia DI_Number,hou.num_proc_hia, convert(float,[dbo].[fBusca_CampoCliente](hou.num_proc_hia,31)) paridade,
--		Sum(vlr_item_custo*Isnull(Prc_Inss,0)) INSS,  dbo.fBusca_TipoDocCliente('N',hou.num_proc_hia,2) Invoice_Fornecedor,
--		@FreteDI FreteDI, ISNULL(atd_lia,getdate()) Dt_Base

--FROM
--	custo_cliente CC
--	Join Fmc_Miro Miro on Miro.id_miro=cc.num_nf_custo
--	Join House_imp_aer hou on hou.num_proc_hia=cc.num_proc
----	Join IntFMC_Plano_Contas PC on miro.id_evento=pc.id_evento and PC.cd_tp_tx=cc.cd_tp_Tx and cd_pes=cd_Export_him
--	Join FMC_Plano_Contas_V2 PC on pc.cd_Tp_tx=cc.cd_tp_tx and miro.id_evento=pc.id_evento
--	Join Tipo_Taxa TT on TT.cd_tp_tx=cc.cd_tp_Tx
----	Join Pedido_ship PS on Ps.num_proc=num_proc_hia and ps.cd_produto=cc.cd_produto
----	Join Pedido PD on PD.cd_pedido=PS.cd_pedido
----	Left Join Nota_Cliente NC on num_proc_him=NC.num_proc
--	Left Join PO_HIA DI on DI.num_proc_hiA=hou.num_proc_hia and DI.id_dc=5
--	Join LLP_Imp_aer L with(nolock) on L.Num_Proc_LiA=CC.Num_Proc 

--where	
--	cc.num_proc=@num_proc and PC.tipo=@tipo and miro.id_miro=@id_miro
--group by 
--	dbo.fBusca_PO_NumPedido(hou.num_proc_hia,3) ,
--	dbo.fBusca_PO_NumPedido(hou.num_proc_hia,5),
--	dt_envio,hou.num_proc_hia,di.numero_po_hia,
--	ISNULL(atd_lia,getdate())  



--union


--SELECT 
--		dt_envio, dbo.fBusca_TipoDocCliente('N',hou.num_proc_hio,1) Nota_Fiscal,
--		sum(vlr_item_custo) Valor,
--		di.numero_po_hio DI_Number,hou.num_proc_hio, convert(float,[dbo].[fBusca_CampoCliente](hou.num_proc_hio,31)) paridade,
--		Sum(vlr_item_custo*Isnull(Prc_Inss,0)) INSS,  dbo.fBusca_TipoDocCliente('N',hou.num_proc_hio,2) Invoice_Fornecedor,
--		@FreteDI FreteDI,  ISNULL(atd_liO,getdate()) Dt_Base

--FROM
--	custo_cliente CC
--	Join Fmc_Miro Miro on Miro.id_miro=cc.num_nf_custo
--	Join House_imp_out hou on hou.num_proc_hio=cc.num_proc
--	Join FMC_Plano_Contas_V2 PC on pc.cd_Tp_tx=cc.cd_tp_tx and miro.id_evento=pc.id_evento
--	Join Tipo_Taxa TT on TT.cd_tp_tx=cc.cd_tp_Tx
----	Join Pedido_ship PS on Ps.num_proc=num_proc_hio and ps.cd_produto=cc.cd_produto
----	Join Pedido PD on PD.cd_pedido=PS.cd_pedido
----	Left Join Nota_Cliente NC on num_proc_him=NC.num_proc
--	Left Join PO_HIo DI on DI.num_proc_hio=hou.num_proc_hio and DI.id_dc=5
--	Join LLP_Imp_Out L with(nolock) on L.Num_Proc_Lio=CC.Num_Proc 
	
--where	
--	cc.num_proc=@num_proc and PC.tipo=@tipo and miro.id_miro=@id_miro
--group by 
--	dbo.fBusca_PO_NumPedido(hou.num_proc_hio,3) ,
--	dbo.fBusca_PO_NumPedido(hou.num_proc_hio,5),
--	dt_envio,hou.num_proc_hio,di.numero_po_hio ,
--	  ISNULL(atd_liO,getdate()) 




















GO
