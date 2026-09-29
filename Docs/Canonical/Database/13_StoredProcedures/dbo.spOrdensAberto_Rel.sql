SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


--spOrdensAberto_Rel 'GRUPO Consagro','2012-05-01','2012-12-31'



CREATE Procedure [dbo].[spOrdensAberto_Rel]
	@Grupo varchar(20),
	@DtInicial datetime,
	@DtFinal datetime
AS
	declare @cd_pes_grupo varchar(10)
	Set @cd_pes_grupo = (select top 1 Cd_Pes from pessoa where apelido=@Grupo)

	SELECT 
		Num_Pedido Num_PO,Num_Proc_Lim Job,PP.Nome_Raz_Soc [Exportador],Org.nome_local Origem, 
		DST.nome_local Destino,ETD_LIM ETD,ETA_LIM ETA,cd_proc_cliente Codigo_Produto,
		Produto_Descr,ncm [NCM],Upper(Incoterm) Incoterm,Vlr_Total_Item,Upper(p.cd_tp_moeda) Moeda,
		(dbo.FBusca_AliqProd(cd_prod,'II')/100*Vlr_Total_Item)	[II - Valor],
		(dbo.FBusca_AliqProd(cd_prod,'IPI')/100)*Vlr_Total_Item [IPI - Valor] ,
		(dbo.FBusca_AliqProd(cd_prod,'ICM')/100)*Vlr_Total_Item [ICMS - Valor],
		(dbo.FBusca_AliqProd(cd_prod,'PIS')/100)*Vlr_Total_Item [PIS - Valor],
		(dbo.FBusca_AliqProd(cd_prod,'COF')/100)*Vlr_Total_Item [Cofins - Valor],				
		pd.vlr_Frete [Frete Valor],
		dbo.VerParidade(convert(varchar(10),getdate(),103),P.cd_tp_moeda,'IMM') Paridade,
		(
			(dbo.FBusca_AliqProd(cd_prod,'II')/100*Vlr_Total_Item)+(dbo.FBusca_AliqProd(cd_prod,'IPI')/100)*Vlr_Total_Item +
			(dbo.FBusca_AliqProd(cd_prod,'ICM')/100)*Vlr_Total_Item + (dbo.FBusca_AliqProd(cd_prod,'PIS')/100)*Vlr_Total_Item +
			(dbo.FBusca_AliqProd(cd_prod,'COF')/100)*Vlr_Total_Item 
		) * dbo.VerParidade(convert(varchar(10),getdate(),103),P.cd_tp_moeda,'IMM')*1.2 [Adiantamento Value],
		--'Semana :' + cast(datepart(wk,eta_lim+7) as varchar(2)) + '/2011' Semana
		'Semana :' + cast(datepart(wk,eta_lim+7) as varchar(2)) + '/' + convert(varchar,year(getdate())) Semana
	FROM 
		LLP_IMP_MAR with(nolock)
		Join Pedido_Ship PS with(nolock) on PS.num_proc=num_proc_lim
		Join Pedido_Det PD with(nolock) on PD.cd_pedido=PS.cd_pedido and ps.cd_produto=pd.cd_produto and ps.item=pd.item and ps.lote=pd.lote
		Join Pedido P with(nolock) on P.cd_pedido=PS.cd_pedido and P.cd_grupo = @cd_pes_grupo
		Join House_Imp_Mar HOU with(nolock) on Hou.num_proc_him=num_proc_lim
		Join Localidade Org with(nolock) on org.cd_local=cd_org_him
		Join Localidade Dst with(nolock) on dst.cd_local=cd_dst_him
		Join Pessoa PP with(nolock) on PP.cd_pes=cd_export_him
		Join Produto_Cliente PC with(nolock) on PC.cd_prod=PS.cd_produto
		Left Join Tarefas_Processos TP with(nolock) on tp.num_proc=num_proc_lim and id_task=4
	WHERE
	
		ETA_LIM between @DtInicial and @DtFinal
		and dt_conclusao is null
	
	UNION ALL

	SELECT 
		Num_Pedido Num_PO,Num_Proc_Lia Job,PP.Nome_Raz_Soc [Exportador],Org.nome_local Origem, 
		DST.nome_local Destino,ETD_LIA ETD,ETA_LIA ETA,cd_proc_cliente Codigo_Produto,
		Produto_Descr,ncm [NCM],Upper(Incoterm) Incoterm,Vlr_Total_Item,Upper(p.cd_tp_moeda) Moeda,
		(dbo.FBusca_AliqProd(cd_prod,'II')/100*Vlr_Total_Item)	[II - Valor],
		(dbo.FBusca_AliqProd(cd_prod,'IPI')/100)*Vlr_Total_Item [IPI - Valor] ,
		(dbo.FBusca_AliqProd(cd_prod,'ICM')/100)*Vlr_Total_Item [ICMS - Valor],
		(dbo.FBusca_AliqProd(cd_prod,'PIS')/100)*Vlr_Total_Item [PIS - Valor],
		(dbo.FBusca_AliqProd(cd_prod,'COF')/100)*Vlr_Total_Item [Cofins - Valor],				
		pd.vlr_Frete [Frete Valor],
		dbo.VerParidade(convert(varchar(10),getdate(),103),P.cd_tp_moeda,'IMM') Paridade,
		(
			(dbo.FBusca_AliqProd(cd_prod,'II')/100*Vlr_Total_Item)+(dbo.FBusca_AliqProd(cd_prod,'IPI')/100)*Vlr_Total_Item +
			(dbo.FBusca_AliqProd(cd_prod,'ICM')/100)*Vlr_Total_Item + (dbo.FBusca_AliqProd(cd_prod,'PIS')/100)*Vlr_Total_Item +
			(dbo.FBusca_AliqProd(cd_prod,'COF')/100)*Vlr_Total_Item 
		) * dbo.VerParidade(convert(varchar(10),getdate(),103),P.cd_tp_moeda,'IMM')*1.2 [Adiantamento Value],
		'Semana :' + cast(datepart(wk,eta_lia+7) as varchar(2))+ '/' + convert(varchar,year(getdate())) Semana
	FROM 
		LLP_IMP_AER with(nolock)
		Join Pedido_Ship PS with(nolock) on PS.num_proc=num_proc_lia
		Join Pedido_Det PD with(nolock) on PD.cd_pedido=PS.cd_pedido and ps.cd_produto=pd.cd_produto and ps.item=pd.item and ps.lote=pd.lote
		Join Pedido P with(nolock) on P.cd_pedido=PS.cd_pedido and P.cd_grupo = @cd_pes_grupo
		Join House_Imp_Aer HOU with(nolock) on Hou.num_proc_hia=num_proc_lia
		Join Localidade Org with(nolock) on org.cd_local=cd_org_hia
		Join Localidade Dst with(nolock) on dst.cd_local=cd_dst_hia
		Join Pessoa PP with(nolock) on PP.cd_pes=cd_export_hia
		Join Produto_Cliente PC with(nolock) on PC.cd_prod=PS.cd_produto
		Left Join Tarefas_Processos TP with(nolock) on tp.num_proc=num_proc_lia and id_task=4
	WHERE
		
		ETA_LIA between @DtInicial and @DtFinal
		and dt_conclusao is null

	UNION ALL

	SELECT 
		Num_Pedido Num_PO,Num_Proc_Lio Job,PP.Nome_Raz_Soc [Exportador],Org.nome_local Origem, 
		DST.nome_local Destino,ETD_LIO ETD,ETA_LIO ETA,cd_proc_cliente Codigo_Produto,
		Produto_Descr,ncm [NCM],Upper(Incoterm) Incoterm,Vlr_Total_Item,Upper(p.cd_tp_moeda) Moeda,
		(dbo.FBusca_AliqProd(cd_prod,'II')/100*Vlr_Total_Item)	[II - Valor],
		(dbo.FBusca_AliqProd(cd_prod,'IPI')/100)*Vlr_Total_Item [IPI - Valor] ,
		(dbo.FBusca_AliqProd(cd_prod,'ICM')/100)*Vlr_Total_Item [ICMS - Valor],
		(dbo.FBusca_AliqProd(cd_prod,'PIS')/100)*Vlr_Total_Item [PIS - Valor],
		(dbo.FBusca_AliqProd(cd_prod,'COF')/100)*Vlr_Total_Item [Cofins - Valor],				
		pd.vlr_Frete [Frete Valor],
		dbo.VerParidade(convert(varchar(10),getdate(),103),P.cd_tp_moeda,'IMM') Paridade,
		(
			(dbo.FBusca_AliqProd(cd_prod,'II')/100*Vlr_Total_Item)+(dbo.FBusca_AliqProd(cd_prod,'IPI')/100)*Vlr_Total_Item +
			(dbo.FBusca_AliqProd(cd_prod,'ICM')/100)*Vlr_Total_Item + (dbo.FBusca_AliqProd(cd_prod,'PIS')/100)*Vlr_Total_Item +
			(dbo.FBusca_AliqProd(cd_prod,'COF')/100)*Vlr_Total_Item 
		) * dbo.VerParidade(convert(varchar(10),getdate(),103),P.cd_tp_moeda,'IMM')*1.2 [Adiantamento Value],
		'Semana :' + cast(datepart(wk,eta_lio+7) as varchar(2)) + '/' + convert(varchar,year(getdate())) Semana
	FROM 
		LLP_IMP_OUT with(nolock)
		Join Pedido_Ship PS with(nolock) on PS.num_proc=num_proc_lio
		Join Pedido_Det PD with(nolock) on PD.cd_pedido=PS.cd_pedido and ps.cd_produto=pd.cd_produto and ps.item=pd.item and ps.lote=pd.lote
		Join Pedido P with(nolock) on P.cd_pedido=PS.cd_pedido and P.cd_grupo = @cd_pes_grupo
		Join House_Imp_out HOU with(nolock) on Hou.num_proc_hio=num_proc_lio
		Join Localidade Org with(nolock) on org.cd_local=cd_org_hio
		Join Localidade Dst with(nolock) on dst.cd_local=cd_dst_hio
		Join Pessoa PP with(nolock) on PP.cd_pes=cd_export_hio
		Join Produto_Cliente PC with(nolock) on PC.cd_prod=PS.cd_produto
		Left Join Tarefas_Processos TP with(nolock) on tp.num_proc=num_proc_lio and id_task=4
	WHERE
		
		ETA_LIO between @DtInicial and @DtFinal
		and dt_conclusao is null

option(hash join)
GO
