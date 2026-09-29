SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--select * from Sol_Pgto_Cta_Cte_Item where Num_Proc = 'EMARC201801014BR' and Cd_Tp_Tx = 'XPK'
--select * from vwAXDocs where Num_Proc = 'EMARC201801014BR' and cd_tp_tx_Atl = 'XPK'
--select * from vwFaturas_CHB_Validas where Num_Proc = 'EMARC201801014BR' and cd_tp_tx = 'XPK'
--cadu- 16/04/2018 - incluido o dc no vwFaturas_CHB_Validas
CREATE procedure [dbo].[spSolPgtoCtaCteItem_Sel]-- '8103547'
(
	@ID bigint
)
as
Declare @Status varchar(20)
set @Status = 'Saved'
	select 
		@Status [Status],
		SP.ID_Item [ID Item],
		SP.Num_Proc [Process References],		
		SP.Cd_Tp_Tx [Charge Code],
		TT.Nome_Tp_Tx [Charge Name],
		SP.DC [D/C],
		(Case when SP.Cd_Tp_Moeda = 'REL' then 'BRL' else
			SP.Cd_Tp_Moeda end) [Currency Code],
		TM.Nome_Tp_Moeda [Currency Name],
		SP.Vlr_Ref [Value (Org. Currency)],
		SP.Cd_Tp_Par [Exchange Code],
		TP.Nome_Tp_Par [Exchange Name],
		SP.Par_Moeda [Exchange Rate],
		SP.Vlr_Pgto_Rcto [Value Total],
		SP.Num_Proc_Master [Master]	,
		S.Num_Registro [Num_Registro],		
		ID_AX			[ID_AX],
		CHB.FatCod		[Invoice],
		cast(TS.ID_Status as varchar(10))+ ' - ' + TS.Status_Descricao [Status Job]
	from Sol_Pgto_Cta_Cte_Item SP with(nolock)
		join Tipo_Taxa TT with(nolock) on SP.Cd_Tp_Tx = TT.Cd_Tp_Tx
		join Tipo_Moeda TM with(nolock) on SP.Cd_Tp_Moeda = TM.Cd_Tp_Moeda
		join Tipo_Paridade TP with(nolock) on SP.Cd_Tp_Par = TP.Cd_Tp_Par
		join Sol_Pgto_Cta_Cte S with(nolock) on S.ID = SP.ID
		Left join vwAXDocs AX with(nolock) on SP.Num_Proc = AX.Num_proc  and SP.cd_tp_tx = AX.Cd_Tp_Tx_ATL and SP.DC = ax.dc
		left join vwFaturas_CHB_Validas CHB with(nolock) on SP.Num_Proc = CHB.Num_proc  and SP.cd_tp_tx = CHB.Cd_Tp_Tx and SP.DC = CHB.dc
		left join vwClienteALLJOBS V with(nolock) on V.num_proc = SP.Num_Proc
		Left join Tipo_Status_Processo TS with(nolock) on ts.ID_Status = V.ID_Status
	where 
		SP.ID = @ID
	order by ID_Item
	
		


GO
