SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[spATL_BuscaConferenciaJOB_Caixa_Sel]--'EMFMC201602003BR','ReceitaR'
(
	@Num_Proc varchar(16),
	@Tipo varchar(50)
)
as


if @Tipo = 'ReceitaR'
	Begin
		select TX.Nome_Tp_Tx [Taxa],I.DC[D/C],I.Moeda, dbo.valor(I.Valor,I.DC) [Valor], 
			CONVERT(decimal(18,2), dbo.valor(I.Valor*I.Paridade,I.DC) ) [Valor(REL)] ,
			CX.Num_Lcto
		from AX_Doc_Item I with(nolock)
			join Tipo_Taxa_AX TA with(nolock) on I.Cd_Tp_TX = TA.Cd_Charge_AX and (I.Account_Number = TA.CC_Receita  or I.Cd_Tp_TX = '900.1')
			join Tipo_Taxa TX with(nolock) on I.cd_tp_Tx_ATL = TX.Cd_Tp_Tx
			left join vwcxas CX with(nolock) on I.Num_Proc = CX.Num_Proc_HIA and I.DC = CX.DC_HIA and I.cd_tp_Tx_ATL = CX.Cd_Tp_Tx
			join vwAXDocs X with(nolock)  on X.id_AX = I.ID_AX and I.Num_Proc = X.Num_Proc and I.cd_tp_tx_ATL = X.Cd_tp_Tx_ATL and I.DC = X.DC 
		where
			I.Num_Proc = @Num_Proc and  DocumentNum is  NULL
	End

if @Tipo = 'ReceitaC'
	Begin
		select 
			TX.Nome_Tp_Tx [Taxa],I.DC[D/C],I.Moeda, dbo.valor(I.Valor,I.DC) [Valor],
			CONVERT(decimal(18,2),dbo.valor( I.Valor*I.Paridade,I.DC)) [Valor(REL)],
			CX.Num_Lcto
		from AX_Doc_Item I with(nolock)
			join Tipo_Taxa_AX TA with(nolock) on I.Cd_Tp_TX = TA.Cd_Charge_AX and I.Account_Number = TA.CC_Custo
			join Tipo_Taxa TX with(nolock) on I.cd_tp_Tx_ATL = TX.Cd_Tp_Tx
			left join vwcxas CX with(nolock) on I.Num_Proc = CX.Num_Proc_HIA and I.DC = CX.DC_HIA and I.cd_tp_Tx_ATL = CX.Cd_Tp_Tx
			join vwAXDocs X with(nolock)  on X.id_AX = I.ID_AX and I.Num_Proc = X.Num_Proc and I.cd_tp_tx_ATL = X.Cd_tp_Tx_ATL and I.DC = X.DC 
		where 
			I.Num_Proc = @Num_Proc and  DocumentNum is   NULL  and I.Cd_Tp_TX <> '900.1'
	End
	
if @Tipo = 'ResultadoR'
	Begin
		select 
			TX.Nome_Tp_Tx [Taxa],I.DC[D/C],I.Moeda, dbo.valor(I.Valor,I.DC) [Valor],
			CONVERT(decimal(18,2),dbo.valor( I.Valor*I.Paridade,I.DC)) [Valor(REL)],
			CX.Num_Lcto			
		from AX_Doc_Item I with(nolock)
			join Tipo_Taxa_AX TA with(nolock) on I.Cd_Tp_TX = TA.Cd_Charge_AX and I.Account_Number = TA.CC_Receita
			join Tipo_Taxa TX with(nolock) on I.cd_tp_Tx_ATL = TX.Cd_Tp_Tx
			left join vwcxas CX with(nolock) on I.Num_Proc = CX.Num_Proc_HIA and I.DC = CX.DC_HIA and I.cd_tp_Tx_ATL = CX.Cd_Tp_Tx
			join vwAXDocs X with(nolock)  on X.id_AX = I.ID_AX and I.Num_Proc = X.Num_Proc and I.cd_tp_tx_ATL = X.Cd_tp_Tx_ATL and I.DC = X.DC 
		where 
			I.Num_Proc = @Num_Proc and  DocumentNum is not  NULL
	End

if @Tipo = 'ResultadoC'
	Begin
		select 
			TX.Nome_Tp_Tx [Taxa],I.DC[D/C],I.Moeda,dbo.valor( I.Valor,I.DC) [Valor],
			CONVERT(decimal(18,2),dbo.valor( I.Valor*I.Paridade,I.DC)) [Valor(REL)] ,
			CX.Num_Lcto
		from AX_Doc_Item I with(nolock)
			join Tipo_Taxa_AX TA with(nolock) on I.Cd_Tp_TX = TA.Cd_Charge_AX and I.Account_Number = TA.CC_Custo
			join Tipo_Taxa TX with(nolock) on I.cd_tp_Tx_ATL = TX.Cd_Tp_Tx
			left join vwcxas CX with(nolock) on I.Num_Proc = CX.Num_Proc_HIA and I.DC = CX.DC_HIA and I.cd_tp_Tx_ATL = CX.Cd_Tp_Tx
			join vwAXDocs X with(nolock)  on X.id_AX = I.ID_AX and I.Num_Proc = X.Num_Proc and I.cd_tp_tx_ATL = X.Cd_tp_Tx_ATL and I.DC = X.DC 
		where 
			I.Num_Proc = @Num_Proc and  DocumentNum is not  NULL
	End
	
if @Tipo = 'AX'
	Begin
		select 
			TX.Nome_Tp_Tx [Taxa],I.DC_HIA [D/C],I.Cd_Tp_Moeda [Moeda],dbo.valor( I.Vlr_Org_HIA,I.DC_Hia) [Valor],
			CONVERT(decimal(18,2),dbo.valor( I.Vlr_Org_HIA*dbo.VerParidade(I.Dt_Ins_Hia,cd_Tp_Moeda,'OFC'),I.DC_HIA)) [Valor(REL)],
			'' Num_Lcto
		 from vwcta_Cte I
			join Tipo_Taxa TX with(nolock) on I.cd_tp_Tx = TX.Cd_Tp_Tx
			left join vwAXDocs X with(nolock)  on I.Num_Proc_Hia = X.Num_Proc and I.Cd_Tp_Tx = X.Cd_tp_Tx_ATL and I.DC_HIA = X.DC 
		where 
			I.Num_Proc_HIA = @Num_Proc and X.id_Ax is null	
	End
GO
