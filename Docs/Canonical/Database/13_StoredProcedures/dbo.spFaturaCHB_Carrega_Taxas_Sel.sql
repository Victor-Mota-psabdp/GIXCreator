SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE Procedure [dbo].[spFaturaCHB_Carrega_Taxas_Sel]--'IMATL201406001BR_DA','D'
		@FatCod 	VarChar(19)	,
		@Tipo		char(1) --D-  Draft ou O - Original

AS
	if @Tipo = 'O'
		BEGIN
			select 'Saved',
			'X',
			I.Num_Proc,
			Nome_tp_tx,
			I.DC,
			TM.Nome_tp_moeda Moeda,
			I.Vlr_Org,
			I.Paridade,
			--(case when I.DC = 'D' then I.Vlr_RS * -1 else I.Vlr_RS end),
			Vlr_RS,			
			CC.Num_NF_HIA NF, 
			CC.Ref_Acesso_NF_HIA [Site],
			Repasse_TX,
			''Emissao,
			isnull(CXA.Vlr_Pgto_Rcto_HIA,S.Vlr_Pgto_Rcto),
			ISNULL(CXA.Num_Lcto,S.ID)
			From vwFaturasValidas I
				Join Tipo_Taxa TT with (nolock)on TT.cd_tp_tx = I.cd_tp_tx				
				Join Tipo_moeda TM with (nolock)on I.cd_tp_moeda = TM.cd_tp_moeda
				left join vwcta_Cte CC with (nolock)on I.Num_Proc	= CC.Num_Proc_HIA and I.cd_tp_tx = CC.cd_tp_tx and I.DC = CC.DC_HIA
				Left join vwCXAS CXA with (nolock)on I.Num_Proc	= CXA.Num_Proc_HIA and I.cd_tp_tx = CXA.cd_tp_tx and I.DC = CXA.DC_HIA and num_lcto <> 'PROVISÓRIO'
				Left join vwSolPgtoCtaCteAprovadas S with (nolock)on I.Num_Proc = S.Num_proc  and I.cd_tp_tx = S.Cd_Tp_Tx and i.DC = S.dc					
			Where I.FatCod = @FatCod
		END
	ELSE
		BEGIN
			select 'Saved','X',ITEM.Num_Proc,Nome_tp_tx,Item.DC,TM.Nome_tp_moeda Moeda,Item.Vlr_Org,
			Item.Paridade,
			(case when ITEM.DC = 'D' then ITEM.Vlr_RS * -1 else ITEM.Vlr_RS end),
			--'' ONF,
			'' [Numero NF],
			''[Site],
			''RTX,
			''Emissao,
			''Vlr_Pgto,
			''Ref
			From Item_fat_Draft ITEM
				Join Tipo_Taxa TT on TT.cd_tp_tx = ITEM.cd_tp_tx
				join Fatura_Draft FAT on ITEM.FatCod = FAT.FatCod
				Join Tipo_moeda TM on ITEM.cd_tp_moeda = TM.cd_tp_moeda
			Where ITEM.FatCod =@FatCod
		END
		
        
GO
