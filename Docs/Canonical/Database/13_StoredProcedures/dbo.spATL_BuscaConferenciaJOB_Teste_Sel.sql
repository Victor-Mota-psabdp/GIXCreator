SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE procedure [dbo].[spATL_BuscaConferenciaJOB_Teste_Sel]
(
	@Num_Proc varchar(16),
	@Tipo varchar(50)
)
as

/*
========================================================================================================================= 
HISTORY CHANGE (From most recent to less recent)

. Date (YYYY/MM/DD):	2020/11/11 
. Ticket:				100-236919 - GSS - Billing authorization screen enhancement
. Business:				Eliene Alves Barbosa Oliveira (eliene.oliveira@bdpint.com) 
. Dept:					Transportation 
. Quality:				Rosangela Santos (rosangela.santos@bdpint.com)
. Developer:			Alessandra Suzuki Mariano (alessandra.mariano@bdpint.com)
. Developer review:		
------------------------------------------------------------------------------------------------------------------------- 
--11/11/06 - cadu and (TX.CD_AX_Resultado <> '000.1' or TX.Cd_AX_Repasse <> '000.1')
--spATL_BuscaConferenciaJOB_Sel 'EMSCH202005001BR','ReceitaR'
--13-7-2017 -custos - cadu
========================================================================================================================= 
EXECUTION EXAMPLES  

exec spATL_BuscaConferenciaJOB_Teste_Sel 'iamte201910005br','ReceitaR'

exec spATL_BuscaConferenciaJOB_Teste_Sel 'iamte201910005br','ReceitaC'

exec spATL_BuscaConferenciaJOB_Teste_Sel 'EAATL202103001BR','ResultadoR'

exec spATL_BuscaConferenciaJOB_Teste_Sel 'EAATL202103001BR','ResultadoC'

exec spATL_BuscaConferenciaJOB_Teste_Sel 'EAATL202103001BR','AX'

exec spATL_BuscaConferenciaJOB_Teste_Sel 'iamte201910005br','CUSTO'

=========================================================================================================================
*/ 


if @Tipo = 'ReceitaR'
	Begin
		select 
		TX.Nome_Tp_Tx				[Taxa]
		,I.DC						[D/C]
		,I.Moeda					[Moeda]
		, dbo.valor(I.Valor,I.DC)	[Valor]
		, CONVERT(decimal(18,2), dbo.valor(I.Valor*I.Paridade,I.DC) ) [Valor(REL)] 
		,apelido					[Creditor / Debitor]
		from AX_Doc_Item I (nolock)
		join Tipo_Taxa_AX TA (nolock) 
			on I.Cd_Tp_TX = TA.Cd_Charge_AX 
			and (I.Account_Number = TA.CC_Receita 
			or I.Cd_Tp_TX = '900.1')
		join Tipo_Taxa TX (nolock) 
			on I.cd_tp_Tx_ATL = TX.Cd_Tp_Tx
		--left join caixa_AX CX (nolock) on I.Num_Proc = CX.Num_Proc and I.DC = CX.DC and I.cd_tp_Tx_ATL = CX.Cd_Tp_Tx
		join vwAXDocs X (nolock)  
			on X.id_AX = I.ID_AX 
			and I.Num_Proc = X.Num_Proc 
			and I.cd_tp_tx_ATL = X.Cd_tp_Tx_ATL and I.DC = X.DC 
		--Alessandra 17/11/2020
		left join vwcta_cte CTA on cta.Num_Proc_HIA = X.Num_Proc  and CTA.cd_tp_tx  = X.Cd_tp_Tx_ATL  and i.dc = cta.dc_hia
		left join pessoa on cta.cd_cred_dev_hia = cd_pes
			--Alessandra 17/11/2020 - colocado o .1 e .2
		where I.Num_Proc = @Num_Proc and I.Cd_Tp_TX like '%.1'  --and  DocumentNum is  NULL
		and I.Valor <> 0
		option (hash join)
	End

if @Tipo = 'ReceitaC'
	Begin
		select TX.Nome_Tp_Tx [Taxa]
		,I.DC[D/C],I.Moeda
		, dbo.valor(I.Valor,I.DC) [Valor]
		,CONVERT(decimal(18,2)
		,dbo.valor( I.Valor*I.Paridade,I.DC)) [Valor(REL)]
		,apelido					[Creditor / Debitor]
		from AX_Doc_Item I (nolock)
		join Tipo_Taxa_AX TA (nolock) on I.Cd_Tp_TX = TA.Cd_Charge_AX and I.Account_Number = TA.CC_Custo
		join Tipo_Taxa TX (nolock) on I.cd_tp_Tx_ATL = TX.Cd_Tp_Tx
		--join caixa_AX CX (nolock) on I.Num_Proc = CX.Num_Proc and I.DC = CX.DC and I.cd_tp_Tx_ATL = CX.Cd_Tp_Tx
		join vwAXDocs X (nolock)  on X.id_AX = I.ID_AX and I.Num_Proc = X.Num_Proc and I.cd_tp_tx_ATL = X.Cd_tp_Tx_ATL and I.DC = X.DC 
		--Alessandra 17/11/2020
		left join vwcta_cte CTA (nolock) on cta.Num_Proc_HIA = X.Num_Proc  and CTA.cd_tp_tx  = X.Cd_tp_Tx_ATL and i.dc = cta.dc_hia
		left join pessoa (nolock) on cta.cd_cred_dev_hia = cd_pes
		--Alessandra 17/11/2020 - colocado o .1 e .2
		where I.Num_Proc = @Num_Proc /*and  DocumentNum is   NULL */  and I.Cd_Tp_TX like '%.1' and I.Cd_Tp_TX <> '900.1'
		and I.Valor <> 0	

		union all

		select 
			TX.Nome_Tp_Tx [Taxa]
			,I.DC[D/C],I.Moeda
			, dbo.valor(I.Valor,I.DC) [Valor]
			,CONVERT(decimal(18,2)
			,dbo.valor( I.Valor*I.Paridade,I.DC)) [Valor(REL)]
			,apelido					[Creditor / Debitor]
			from AX_Doc_Item I (nolock)
			join Tipo_Taxa_AX TA (nolock) on I.Cd_Tp_TX = TA.Cd_Charge_AX and I.Account_Number = TA.CC_Custo
			join Tipo_Taxa TX (nolock) on I.cd_tp_Tx_ATL = TX.Cd_Tp_Tx			
			--join vwAXDocs X (nolock)  on X.id_AX = I.ID_AX and I.Num_Proc = X.Num_Proc and I.cd_tp_tx_ATL = X.Cd_tp_Tx_ATL and I.DC = X.DC 
			join vwcta_cte CTA (nolock) on cta.Num_Proc_HIA = I.Num_Proc_master  and CTA.cd_tp_tx  = I.Cd_tp_Tx_ATL and cta.dc_hia = i.dc
			join pessoa (nolock) on cta.cd_cred_dev_hia = cd_pes		
		where 
			I.Num_Proc = @Num_Proc
			and I.Cd_Tp_TX like '%.1' and I.Cd_Tp_TX <> '900.1'
			and I.Valor <> 0
		option (hash join)
		
	End
	
if @Tipo = 'ResultadoR'
	Begin
		select TX.Nome_Tp_Tx [Taxa]
		,I.DC[D/C]
		,I.Moeda
		, dbo.valor(I.Valor,I.DC) [Valor]
		,CONVERT(decimal(18,2)
		,dbo.valor( I.Valor*I.Paridade,I.DC)) [Valor(REL)] 
		,apelido					[Creditor / Debitor]
		from AX_Doc_Item I (nolock)
		join Tipo_Taxa_AX TA (nolock) on I.Cd_Tp_TX = TA.Cd_Charge_AX and I.Account_Number = TA.CC_Receita
		join Tipo_Taxa TX (nolock) on I.cd_tp_Tx_ATL = TX.Cd_Tp_Tx
		--join caixa_AX CX (nolock) on I.Num_Proc = CX.Num_Proc and I.DC = CX.DC and I.cd_tp_Tx_ATL = CX.Cd_Tp_Tx
		join vwAXDocs X (nolock)  on X.id_AX = I.ID_AX and I.Num_Proc = X.Num_Proc and I.cd_tp_tx_ATL = X.Cd_tp_Tx_ATL and I.DC = X.DC 
		
		--Alessandra 17/11/2020
		left join vwcta_cte CTA on cta.Num_Proc_HIA = X.Num_Proc  and CTA.cd_tp_tx  = X.Cd_tp_Tx_ATL and i.dc = cta.dc_hia
		left join pessoa on cta.cd_cred_dev_hia = cd_pes
		--Alessandra 17/11/2020 - colocado o .1 e .2
		where I.Num_Proc = @Num_Proc and  I.Cd_Tp_TX like '%.2' --and  DocumentNum is not  NULL
		and I.Valor <> 0
		option (hash join)
	End

if @Tipo = 'ResultadoC'
	Begin
		select 
		TX.Nome_Tp_Tx [Taxa]
		,I.DC[D/C]
		,I.Moeda
		,dbo.valor( I.Valor,I.DC) [Valor]
		,CONVERT(decimal(18,2)
		,dbo.valor( I.Valor*I.Paridade,I.DC)) [Valor(REL)] 
		,apelido					[Creditor / Debitor]
		from AX_Doc_Item I (nolock)
		join Tipo_Taxa_AX TA (nolock) on I.Cd_Tp_TX = TA.Cd_Charge_AX and I.Account_Number = TA.CC_Custo
		join Tipo_Taxa TX (nolock) on I.cd_tp_Tx_ATL = TX.Cd_Tp_Tx
		--join caixa_AX CX (nolock) on I.Num_Proc = CX.Num_Proc and I.DC = CX.DC and I.cd_tp_Tx_ATL = CX.Cd_Tp_Tx
		join vwAXDocs X (nolock)  on X.id_AX = I.ID_AX and I.Num_Proc = X.Num_Proc and I.cd_tp_tx_ATL = X.Cd_tp_Tx_ATL and I.DC = X.DC 
		
		--Alessandra 17/11/2020
		left join vwcta_cte CTA (nolock) on cta.Num_Proc_HIA = X.Num_Proc  and CTA.cd_tp_tx  = X.Cd_tp_Tx_ATL and i.dc = cta.dc_hia
		left join pessoa (nolock) on cta.cd_cred_dev_hia = cd_pes
		--Alessandra 17/11/2020 - colocado o .1 e .2
		where I.Num_Proc = @Num_Proc and  I.Cd_Tp_TX like '%.2' ----and  DocumentNum is not  NULL
		and I.Valor <> 0

		union all

		select 
			TX.Nome_Tp_Tx [Taxa]
			,I.DC[D/C]
			,I.Moeda
			,dbo.valor( I.Valor,I.DC) [Valor]
			,CONVERT(decimal(18,2)
			,dbo.valor( I.Valor*I.Paridade,I.DC)) [Valor(REL)] 
			,apelido					[Creditor / Debitor]
		from AX_Doc_Item I (nolock)
			join Tipo_Taxa_AX TA (nolock) on I.Cd_Tp_TX = TA.Cd_Charge_AX and I.Account_Number = TA.CC_Custo
			join Tipo_Taxa TX (nolock) on I.cd_tp_Tx_ATL = TX.Cd_Tp_Tx
			--join vwAXDocs X (nolock)  on X.id_AX = I.ID_AX and I.Num_Proc = X.Num_Proc and I.cd_tp_tx_ATL = X.Cd_tp_Tx_ATL and I.DC = X.DC 		
			join vwcta_cte CTA (nolock) on cta.Num_Proc_HIA = I.Num_Proc_master  and CTA.cd_tp_tx  = I.Cd_tp_Tx_ATL and i.dc = cta.dc_hia	
			join pessoa P (nolock) on cta.cd_cred_dev_hia = P.cd_pes			
		where 
			I.Num_Proc = @Num_Proc
			and  I.Cd_Tp_TX like '%.2'
			and I.Valor <> 0
		option (hash join)
	End
	
if @Tipo = 'AX'
	Begin
		select  
		TX.Nome_Tp_Tx [Taxa]
		,I.DC_HIA [D/C]
		,I.Cd_Tp_Moeda [Moeda]
		,dbo.valor( I.Vlr_Org_HIA,I.DC_Hia) [Valor]
		,CONVERT(decimal(18,2)
		,dbo.valor( I.Vlr_Org_HIA*dbo.VerParidade(I.Dt_Ins_Hia,cd_Tp_Moeda,'OFC'),I.DC_HIA)) [Valor(REL)] 
		,apelido					[Creditor / Debitor]
		from vwcta_Cte I
		join Tipo_Taxa TX (nolock) on I.cd_tp_Tx = TX.Cd_Tp_Tx
				left join vwAXDocs X (nolock)  on I.Num_Proc_Hia = X.Num_Proc and I.Cd_Tp_Tx = X.Cd_tp_Tx_ATL and I.DC_HIA = X.DC 
		
		--Alessandra 17/11/2020
		--left join vwcta_cte CTA on cta.Num_Proc_HIA = X.Num_Proc  and CTA.cd_tp_tx  = X.Cd_tp_Tx_ATL 
		left join pessoa on i.cd_cred_dev_hia = cd_pes
		where 
			I.Num_Proc_HIA = @Num_Proc and X.id_Ax is null	
			and (TX.CD_AX_Resultado <> '000.1' or TX.Cd_AX_Repasse <> '000.1')
		option (hash join)
	End
	
if @Tipo = 'CUSTO'
	Begin	
		SELECT 			
			--P.Num_pedido [PO], PC.Cd_Proc_Cliente [Id Prod], PC.Produto_Descr [Product Description], 
			TT.Nome_Tp_Tx [Taxa], CC.Vlr_Item_Custo [Valor] , CC.Prestacao [Invoicing]
		FROM 
			Custo_Cliente CC (nolock)
			Join Pedido P (nolock) on P.Cd_pedido = CC.Cd_Pedido
			Join Produto_Cliente PC (nolock) on PC.cd_prod=CC.cd_produto
			Join Tipo_Taxa	TT (nolock) on TT.Cd_Tp_Tx=CC.Cd_Tp_Tx			
		where 
			CC.Num_Proc=@Num_Proc
		option (hash join)

	End
GO
