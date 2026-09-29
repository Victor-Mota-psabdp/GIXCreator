SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[spATL_Sol_Pgto_Cta_Cte_Item_Sel]--'IAATL201909003BR','','','A'
(
	@ID			bigint,
	@Num_Proc	VarChar(16),
	@Cd_tp_tx	varchar(3),
	@DC			varchar(1),
	@Tipo		char(1)
)

AS

if @Tipo = 'A' or @Tipo = 'B'
	Begin
		SELECT
			'Saved'								[Status],
			SP.Num_Proc							[JOB],
			SP.ID_Item							[ID Item],		
			SP.Cd_Tp_Tx							[Charge Type Code],
			TT.Nome_Tp_Tx						[Charge Type Name],			
			SP.DC								[D/C Code],
			TDC.Descricao_TP_DC					[D/C Name],
			S.Cd_Cred_Dev						[Creditor/Debitor Code],
			PS.Apelido							[Creditor/Debitor Name],
			--(Case when SP.Cd_Tp_Moeda = 'REL' then 'BRL' else SP.Cd_Tp_Moeda end) [Currency Code],
			SP.Cd_Tp_Moeda						[Currency Code],
			TM.Nome_Tp_moeda					[Currency Name],
			SP.Vlr_Ref							[Value],
			SP.Cd_Tp_Par						[Exchange Code],
			TP.Nome_Tp_Par						[Exchange Name],
			SP.Par_Moeda						[Exchange Rates],
			SP.Vlr_Pgto_Rcto					[Value Total],			
			SP.Num_Proc_Master					[Master],
			ID_AX								[ID_AX],
			CHB.FatCod							[Invoice],
			cast(TS.ID_Status as varchar(10))+ ' - ' + TS.Status_Descricao [Status Job]	
		
		FROM Sol_Pgto_Cta_Cte_Item	SP with(nolock) 
			join Sol_Pgto_Cta_Cte S with(nolock) on S.ID = SP.ID
			left Join Tipo_Taxa		TT with(nolock) on SP.cd_tp_tx = TT.cd_tp_tx
			left join Tipo_Moeda	TM with(nolock) on SP.cd_tp_moeda = TM.cd_tp_moeda
			left join Tipo_Paridade TP with(nolock) on SP.Cd_Tp_Par = TP.Cd_Tp_Par
			left join Tipo_dc		TDC with(nolock) on SP.DC = TDC.Cd_Tp_DC
			left join Pessoa		PS with(nolock) on S.Cd_Cred_Dev = PS.cd_pes
			left join vwCXAS CXA with(nolock)  on	SP.num_proc	= CXA.num_proc_hia and SP.cd_tp_tx	= CXA.cd_tp_tx and	SP.dc	= CXA.dc_hia
			Left join vwAXDocs AX with(nolock)  on SP.Num_proc = AX.Num_proc  and SP.cd_tp_tx = AX.Cd_Tp_Tx_ATL and SP.dc = ax.dc
			--left join vwFaturasValidas vw on SP.Num_Proc = vw.num_proc and SP.DC = vw.dc and SP.cd_tp_tx = vw.cd_tp_tx
			left join vwFaturas_CHB_Validas CHB with(nolock) on SP.Num_Proc = CHB.Num_proc  and SP.cd_tp_tx = CHB.Cd_Tp_Tx and SP.DC = CHB.dc
			left join vwClienteALLJOBS V with(nolock) on V.num_proc = SP.Num_Proc
			Left join Tipo_Status_Processo TS with(nolock) on ts.ID_Status = V.ID_Status
		WHERE 
			SP.ID = @ID	
		ORDER BY
			1, 2 desc
	End

if @Tipo = 'C' or @Tipo = 'D'
	Begin
		SELECT
			'Saved'								[Status],
			SP.Num_Proc							[JOB],
			SP.ID_Item							[ID Item],		
			SP.Cd_Tp_Tx							[Charge Type Code],
			TT.Nome_Tp_Tx						[Charge Type Name],			
			SP.DC								[D/C Code],
			TDC.Descricao_TP_DC					[D/C Name],
			S.Cd_Cred_Dev						[Creditor/Debitor Code],
			PS.Apelido							[Creditor/Debitor Name],
			--(Case when SP.Cd_Tp_Moeda = 'REL' then 'BRL' else SP.Cd_Tp_Moeda end) [Currency Code],
			SP.Cd_Tp_Moeda						[Currency Code],
			TM.Nome_Tp_moeda					[Currency Name],
			SP.Vlr_Ref							[Value],
			SP.Cd_Tp_Par						[Exchange Code],
			TP.Nome_Tp_Par						[Exchange Name],
			SP.Par_Moeda						[Exchange Rates],
			SP.Vlr_Pgto_Rcto					[Value Total],			
			SP.Num_Proc_Master					[Master],
			ID_AX								[ID_AX],
			CHB.FatCod							[Invoice],
			cast(TS.ID_Status as varchar(10))+ ' - ' + TS.Status_Descricao [Status Job]	
		
		FROM Sol_Pgto_Cta_Cte_Item	SP with(nolock) 
			join Sol_Pgto_Cta_Cte S with(nolock) on S.ID = SP.ID
			left Join Tipo_Taxa		TT with(nolock) on SP.cd_tp_tx = TT.cd_tp_tx
			left join Tipo_Moeda	TM with(nolock) on SP.cd_tp_moeda = TM.cd_tp_moeda
			left join Tipo_Paridade TP with(nolock) on SP.Cd_Tp_Par = TP.Cd_Tp_Par
			left join Tipo_dc		TDC with(nolock) on SP.DC = TDC.Cd_Tp_DC
			left join Pessoa		PS with(nolock) on S.Cd_Cred_Dev = PS.cd_pes
			left join vwCXAS CXA with(nolock)  on	SP.num_proc	= CXA.num_proc_hia and SP.cd_tp_tx	= CXA.cd_tp_tx and	SP.dc	= CXA.dc_hia
			Left join vwAXDocs AX with(nolock)  on SP.Num_proc = AX.Num_proc  and SP.cd_tp_tx = AX.Cd_Tp_Tx_ATL and SP.dc = ax.dc
			--left join vwFaturasValidas vw on SP.Num_Proc = vw.num_proc and SP.DC = vw.dc and SP.cd_tp_tx = vw.cd_tp_tx
			left join vwFaturas_CHB_Validas CHB with(nolock) on SP.Num_Proc = CHB.Num_proc  and SP.cd_tp_tx = CHB.Cd_Tp_Tx and SP.DC = CHB.dc
			left join vwClienteALLJOBS V with(nolock) on V.num_proc = SP.Num_Proc
			Left join Tipo_Status_Processo TS with(nolock) on ts.ID_Status = V.ID_Status
		WHERE 
			SP.num_proc = @Num_Proc and 
			SP.Cd_tp_tx = @Cd_tp_tx and
			SP.dc = @DC
		ORDER BY
			1, 2 desc
		
	End




GO
