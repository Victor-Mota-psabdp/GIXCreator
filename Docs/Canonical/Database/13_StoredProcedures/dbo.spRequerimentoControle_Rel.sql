SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



--30-06-2008
--Week 27
--Criação - Claudio

CREATE Procedure [dbo].[spRequerimentoControle_Rel]

as

	select
		(Dt_Vencimento_Req - 30)	Solic_Novos,
		PC.Produto_Descr			Produto,
		PC.cd_Proc_Cliente			GMID,
		Numero_Requerimento			Num_Req,
		P.cd_modal					Transporte,
		Quant_Req					Qtd,
		UoM_Req						UN,
		sum(PD.QTY) 				Qtd_Alocada,
		--VB						Saldo,
		Dt_Req						Entr_Req,
		Dt_Vencimento_Req			Vencimento
	from 
		Requerimento RQ
		left Join Produto_Cliente PC on RQ.Id_Produto = PC.Cd_Prod and cd_cliente = 1
		Left Join Pedido_Det PD on RQ.ID_Produto = PD.cd_produto and RQ.Numero_Requerimento = PD.Requerimento
		Left Join Pedido P	on PD.Cd_Pedido = P.Cd_Pedido
	Group by
		PC.Produto_Descr,
		PC.cd_Proc_Cliente,
		Numero_Requerimento,
		cd_modal,
		Quant_Req,
		UoM_Req,
		Dt_Req,
		Dt_Vencimento_Req
	Order by
		Dt_Vencimento_Req



GO
