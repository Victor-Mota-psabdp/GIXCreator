SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO





CREATE Procedure [dbo].[spEmbarquesemTransito_Grace] 

AS

	SELECT 
		Num_Pedido Num_PO,Num_Proc_Lim Job,Nome_Raz_Soc,Org.nome_local Origem, DST.nome_local Destino,ETA_LIM ETA,cd_proc_cliente Codigo_Produto,
		Produto_Descr,Vlr_Total_Item,(dbo.FBusca_AliqProd(cd_prod,'II')/100) II,
		(dbo.FBusca_AliqProd(cd_prod,'IPI')/100) IPI,
		(dbo.FBusca_AliqProd(cd_prod,'ICM')/100) ICMS,
		(dbo.FBusca_AliqProd(cd_prod,'PIS')/100) PIS,
		(dbo.FBusca_AliqProd(cd_prod,'COF')/100) Cofins,
		ATD_LIM ATD,
		Upper(Incoterm) Incoterm,
		Upper(p.cd_tp_moeda) Cd_TP_moeda,
		dbo.VerParidade(convert(varchar(10),getdate(),103),P.cd_tp_moeda,'IMM') Paridade,
		datepart(wk,eta_lim+7) Semana,
		pd.vlr_Frete valor_frete,
		PS.Qty
	FROM 
		LLP_IMP_MAR
		Join Pedido_Ship PS on PS.num_proc=num_proc_lim
		Join Pedido_Det PD on PD.cd_pedido=PS.cd_pedido and ps.cd_produto=pd.cd_produto and ps.item=pd.item and ps.lote=pd.lote
		Join House_Imp_Mar HOU on Hou.num_proc_him=num_proc_lim
		Join Localidade Org on org.cd_local=cd_org_him
		Join Localidade Dst on dst.cd_local=cd_dst_him
		Join Pessoa PP on PP.cd_pes=cd_export_him
		Join Produto_Cliente PC on PC.cd_prod=PS.cd_produto
		Join Pedido P on P.cd_pedido=PS.cd_pedido
	WHERE
		right(left(NUM_PROC_LIM,5),3) in ('GCP','MPT')
		--AND ETA_LIM >=GETDATE()
		AND ATD_LIM IS NOT NULL
		AND dbo.fbusca_tarefa(Num_Proc_LIM, 13) is null

GO
