SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE Procedure [dbo].[spIntFMCMiroCabecalhoDEBITOSISCOMEX_Rel] 
		@Num_PRoc	Varchar(16),
		@Tipo		Varchar(1),
		@id_evento	Varchar(1),
		@id_miro	int
--spIntFMCMiroCabecalhoDEBITOSISCOMEX_Rel 'IMFMT20090600601','3'
as

if upper(@id_evento) <> 'K'
	begin
		SElect iSNULL(sum(iSNULL(vlr_item_custo,0)),0) Valor From Custo_Cliente CC 
			Join Fmc_Miro Miro on Miro.id_miro=cc.num_nf_custo

		Join Custo_Processo CPP on cc.num_proc=cpp.num_proc and cc.cd_tp_Tx=cpp.cd_tp_Tx	
			Join FMC_Plano_Contas_v2 PC on miro.id_evento=pc.id_evento and PC.cd_tp_tx=cc.cd_tp_Tx 
			Join Tipo_Taxa TT on TT.cd_tp_tx=cc.cd_tp_Tx
		where	
			cc.num_proc=@num_proc and tipo=@tipo and miro.id_miro=@id_miro
	end
ELSE if upper(@id_evento) = 'K'
	BEGIN
		SElect iSNULL(sum(iSNULL(vlr_item_custo,0)),0) Valor From Custo_Cliente CC 
			Join Fmc_Miro Miro on Miro.id_miro=cc.num_nf_custo
			Join FMC_Plano_Contas_v2 PC on miro.id_evento=pc.id_evento and PC.cd_tp_tx=cc.cd_tp_Tx 
			Join Tipo_Taxa TT on TT.cd_tp_tx=cc.cd_tp_Tx
		where	
			cc.num_proc=@num_proc and tipo=@tipo and miro.id_miro=@id_miro
			
			
	END	


--SElect iSNULL(sum(iSNULL(vlr_item_custo,0)),0) Valor From Custo_Cliente CC 
--	Join Fmc_Miro Miro on Miro.id_miro=cc.num_nf_custo

--Join Custo_Processo CPP on cc.num_proc=cpp.num_proc and cc.cd_tp_Tx=cpp.cd_tp_Tx	
--	Join FMC_Plano_Contas_v2 PC on miro.id_evento=pc.id_evento and PC.cd_tp_tx=cc.cd_tp_Tx 
--	Join Tipo_Taxa TT on TT.cd_tp_tx=cc.cd_tp_Tx
--where	
--	cc.num_proc=@num_proc and tipo=@tipo and miro.id_miro=@id_miro
----	and nome_tp_tx not like 'AFRMM%'



/*
SELECT 
		dt_envio, Isnull(nota_fiscal,
		dbo.fBusca_TipoDocCliente('N',hou.num_proc_him,10)) Nota_Fiscal,
		num_pedido,sum(vlr_item_custo*[dbo].[spBuscaPorcentagem_Pedido](hou.num_proc_him,ps.item,num_pedido)) Valor,
		di.numero_po_him DI_Number,hou.num_proc_him
FROM
	custo_cliente CC
	Join Fmc_Miro Miro on Miro.id_miro=cc.num_nf_custo
	Join House_imp_mar hou on hou.num_proc_him=cc.num_proc
--	Join IntFMC_Plano_Contas PC on miro.id_evento=pc.id_evento and PC.cd_tp_tx=cc.cd_tp_Tx and cd_pes=cd_Export_him
	Join FMC_Plano_Contas_v2 PC on miro.id_evento=pc.id_evento and PC.cd_tp_tx=cc.cd_tp_Tx 
	Join Tipo_Taxa TT on TT.cd_tp_tx=cc.cd_tp_Tx
	Join Pedido_ship PS on Ps.num_proc=num_proc_him and ps.cd_produto=cc.cd_produto and ps.cd_pedido=CC.cd_pedido
	Join Pedido PD on PD.cd_pedido=PS.cd_pedido
	Left Join Nota_Cliente NC on num_proc_him=NC.num_proc
	Left Join PO_HIM DI on DI.num_proc_him=hou.num_proc_him and DI.id_dc=5
	Join Custo_Processo CPP on cc.num_proc=cpp.num_proc and cc.cd_tp_Tx=cpp.cd_tp_Tx	
where	
	cc.num_proc=@num_proc and tipo=@tipo and miro.id_miro=@id_miro
	and nome_tp_tx not like 'AFRMM%'
group by 
	num_pedido,dbo.fBusca_PO_NumPedido(hou.num_proc_him,10) ,
	nc.nota_fiscal,dbo.fBusca_PO_NumPedido(hou.num_proc_him,5),
	dt_envio,hou.num_proc_him,di.numero_po_him 

UNION

SELECT 
		dt_envio, Isnull(nota_fiscal,
		dbo.fBusca_TipoDocCliente('N',hou.num_proc_hia,10)) Nota_Fiscal,
		num_pedido,sum(vlr_item_custo*[dbo].[spBuscaPorcentagem_Pedido](hou.num_proc_hia,ps.item,num_pedido)) Valor,
		di.numero_po_hia DI_Number,hou.num_proc_hia
FROM
	custo_cliente CC
	Join Fmc_Miro Miro on Miro.id_miro=cc.num_nf_custo
	Join House_imp_aer hou on hou.num_proc_hia=cc.num_proc
--	Join IntFMC_Plano_Contas PC on miro.id_evento=pc.id_evento and PC.cd_tp_tx=cc.cd_tp_Tx and cd_pes=cd_Export_him
	Join FMC_Plano_Contas_v2 PC on miro.id_evento=pc.id_evento and PC.cd_tp_tx=cc.cd_tp_Tx 
	Join Tipo_Taxa TT on TT.cd_tp_tx=cc.cd_tp_Tx
	Join Pedido_ship PS on Ps.num_proc=num_proc_hia and ps.cd_produto=cc.cd_produto and ps.cd_pedido=CC.cd_pedido
	Join Pedido PD on PD.cd_pedido=PS.cd_pedido
	Left Join Nota_Cliente NC on num_proc_hia=NC.num_proc
	Left Join PO_HIA DI on DI.num_proc_hia=hou.num_proc_hia and DI.id_dc=5
	Join Custo_Processo CPP on cc.num_proc=cpp.num_proc and cc.cd_tp_Tx=cpp.cd_tp_Tx	
where	
	cc.num_proc=@num_proc and tipo=@tipo and miro.id_miro=@id_miro 	and nome_tp_tx not like 'AFRMM%'

group by 
	num_pedido,dbo.fBusca_PO_NumPedido(hou.num_proc_hia,10) ,
	nc.nota_fiscal,dbo.fBusca_PO_NumPedido(hou.num_proc_hia,5),
	dt_envio,hou.num_proc_hia,di.numero_po_hia 



Union 


SELECT 
		dt_envio, Isnull(nota_fiscal,
		dbo.fBusca_TipoDocCliente('N',hou.num_proc_hio,10)) Nota_Fiscal,
		num_pedido,sum(vlr_item_custo*[dbo].[spBuscaPorcentagem_Pedido](hou.num_proc_hio,ps.item,num_pedido)) Valor,
		di.numero_po_hio DI_Number,hou.num_proc_hio
FROM
	custo_cliente CC
	Join Fmc_Miro Miro on Miro.id_miro=cc.num_nf_custo
	Join House_imp_out hou on hou.num_proc_hio=cc.num_proc
--	Join IntFMC_Plano_Contas PC on miro.id_evento=pc.id_evento and PC.cd_tp_tx=cc.cd_tp_Tx and cd_pes=cd_Export_him
	Join FMC_Plano_Contas_v2 PC on miro.id_evento=pc.id_evento and PC.cd_tp_tx=cc.cd_tp_Tx 
	Join Tipo_Taxa TT on TT.cd_tp_tx=cc.cd_tp_Tx
	Join Pedido_ship PS on Ps.num_proc=num_proc_hio and ps.cd_produto=cc.cd_produto and ps.cd_pedido=CC.cd_pedido
	Join Pedido PD on PD.cd_pedido=PS.cd_pedido 
	Left Join Nota_Cliente NC on num_proc_hio=NC.num_proc
	Left Join PO_HIO DI on DI.num_proc_hio=hou.num_proc_hio and DI.id_dc=5
	Join Custo_Processo CPP on cc.num_proc=cpp.num_proc and cc.cd_tp_Tx=cpp.cd_tp_Tx	
where	
	cc.num_proc=@num_proc and tipo=@tipo and miro.id_miro=@id_miro 	and nome_tp_tx not like 'AFRMM%'

group by 
	num_pedido,dbo.fBusca_PO_NumPedido(hou.num_proc_hio,10) ,
	nc.nota_fiscal,dbo.fBusca_PO_NumPedido(hou.num_proc_hio,5),
	dt_envio,hou.num_proc_hio,di.numero_po_hio 














*/



GO
