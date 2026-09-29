SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--select * from fatura_draft

CREATE Procedure [dbo].[spFaturaBDP_Carrega_Taxas_Sel]--'IMATL201406001BR_DA','D'
		@FatCod 	VarChar(19)	,
		@Tipo		char(1) --D-  Draft ou O - Original

AS
	if @Tipo = 'O'
		BEGIN
			select 
				Nome_tp_tx
				, Vlr_RS
				, TM.Nome_tp_moeda Moeda
				, Vlr_Org valor
				, isnull(Paridade,1) Paridade 
				, FatVendorInvoiceNumber  --Alessandra 19/05/2021 - AX10
				, DC --Alessandra 19/05/2021 - AX10
			From Item_fat ITEM
				Join Tipo_Taxa TT on TT.cd_tp_tx = ITEM.cd_tp_tx
				join Fatura FAT on ITEM.FatCod = FAT.FatCod
				Join Tipo_moeda TM on ITEM.cd_tp_moeda = TM.cd_tp_moeda
			Where ITEM.FatCod = @FatCod
		END
	ELSE
		BEGIN
			select 
				Nome_tp_tx
				, Vlr_RS
				, TM.Nome_tp_moeda Moeda
				, Vlr_Org valor
				, isnull(Paridade,1) Paridade 
				, null as FatVendorInvoiceNumber --Alessandra 19/05/2021 - AX10
				, DC --Alessandra 19/05/2021 - AX10
			From Item_fat_Draft ITEM
				Join Tipo_Taxa TT on TT.cd_tp_tx = ITEM.cd_tp_tx
				join Fatura_Draft FAT on ITEM.FatCod = FAT.FatCod
				Join Tipo_moeda TM on ITEM.cd_tp_moeda = TM.cd_tp_moeda
			Where ITEM.FatCod =@FatCod
		END
		
GO
