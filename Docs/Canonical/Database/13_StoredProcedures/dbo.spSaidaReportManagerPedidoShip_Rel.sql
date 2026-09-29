SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE Procedure [dbo].[spSaidaReportManagerPedidoShip_Rel]--'IMCSR201409051BR'
	@Num_Proc	Varchar(16)
as

--NAO COLOCAR DN VALIDA - ANDERSON 26/04/2012

--if @Num_Proc <> 'IMCSR20081124001'
--	BEGIN
--		Select 
--			Cd_Tipo Tipo_Ordem,PS.Num_Proc Job, cd_Proc_cliente ProductID, left(Produto_Descr,200) Produto_Descr, Upper(UOM) UOM, NCM, SUM(ps.qty) QTY,UC.Nome_usuario RespoPO,
--			 Value_Center_Descr ValueCenter,Business_Descr Business,DL_Chegada PO_req,sum(peso_liquido_tot)NetWeight,sum(peso_bruto_tot)GrossWeight,
--			PP.cd_planta Planta_Exp,ISNULL(cast(Planta as varchar(50)),cast(CS.CD_PLANTA as varchar(50))) Planta_Imp,PO_GRP,business_group_descr Busines_Group,Null ITO_Especialista, '' DeliveryNote
--		From
--			Pedido_Ship PS With(nolock)
--			Join Pedido_Det PDD With(nolock) on PDD.cd_pedido=PS.cd_pedido and PDD.cd_produto=PS.cd_produto and PDD.item=ps.item and pdd.lote=ps.lote
--			Join Produto_Cliente PC With(nolock) on PC.cd_prod=PS.cd_produto
--			Left Join Pedido PD With(nolock) on PD.cd_pedido=PS.cd_pedido
--			Left Join DE_PARA_PRODUTO DPC With(nolock) on cd_proc_cliente=GMID
--			Left Join Usuario_Cliente UC With(nolock) on UC.cd_usuario=PO_Responsible and UC.cd_cliente=cd_grupo
--			LEft Join Pessoa_LLP PP With(nolock) on pp.cd_pes=cd_seller
--			LEft Join Pessoa_LLP CS With(nolock) on CS.cd_pes=CD_BUYER
--		Where
--			ps.num_proc=@Num_Proc
--		Group by 
--			PS.Num_Proc, cd_Proc_cliente, Produto_Descr, UOM, NCM,UC.Nome_usuario ,
--			Value_Center_Descr ,Business_Descr ,DL_Chegada,cd_tipo,CS.CD_PLANTA,PP.cd_planta,planta ,PO_GRP	,business_group_descr,
--			ITO_Especialista
--	END
--ELSE
--	BEGIN
		Select 
			Cd_Tipo Tipo_Ordem,PS.Num_Proc Job, cd_Proc_cliente ProductID, left(Produto_Descr,200) Produto_Descr, Upper(UOM) UOM, NCM, SUM(ps.qty) QTY,UC.Nome_usuario RespoPO,
			 Value_Center_Descr ValueCenter,Business_Descr Business,DL_Chegada PO_req,
			 (case when Peso_UOM = 'LB' then sum(peso_liquido_tot) * 0.4536 else	
				sum(peso_liquido_tot) end)		NetWeight,
					 
			--sum(peso_liquido_tot)NetWeight,
			 
			(case when Peso_UOM = 'LB' then	sum(peso_bruto_tot) * 0.4536 else
				sum(peso_bruto_tot)	end) GrossWeight,
				
			 --sum(peso_bruto_tot)GrossWeight,
			PP.cd_planta Planta_Exp,ISNULL(cast(Planta as varchar(50)),cast(CS.CD_PLANTA as varchar(50))) Planta_Imp,PO_GRP,business_group_descr Busines_Group,Null ITO_Especialista, '' DeliveryNote
		From
			Pedido_Ship PS With(nolock)
			Join Pedido_Det PDD With(nolock) on PDD.cd_pedido=PS.cd_pedido and PDD.cd_produto=PS.cd_produto and PDD.item=ps.item and pdd.lote=ps.lote
			Join Produto_Cliente PC With(nolock) on PC.cd_prod=PS.cd_produto
			Left Join Pedido PD With(nolock) on PD.cd_pedido=PS.cd_pedido
			Left Join DE_PARA_PRODUTO DPC With(nolock) on PC.cd_Proc_Cliente=DPC.GMID and PC.cd_Cliente = DPC.Cd_Cliente
			Left Join Usuario_Cliente UC With(nolock) on UC.cd_usuario=PO_Responsible and UC.cd_cliente=cd_grupo
			LEft Join Pessoa_LLP PP With(nolock) on pp.cd_pes=cd_seller
			LEft Join Pessoa_LLP CS With(nolock) on CS.cd_pes=CD_BUYER
		Where
			ps.num_proc= @Num_Proc
		Group by 
			PS.Num_Proc, cd_Proc_cliente, Produto_Descr, UOM, NCM,UC.Nome_usuario ,
			Value_Center_Descr ,Business_Descr ,DL_Chegada,cd_tipo,CS.CD_PLANTA,PP.cd_planta,planta ,PO_GRP	,business_group_descr,
			ITO_Especialista,Peso_UOM 
	--END




















GO
