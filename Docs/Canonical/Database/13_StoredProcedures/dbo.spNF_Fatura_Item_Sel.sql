SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE procedure [dbo].[spNF_Fatura_Item_Sel]
	@ID			int,
	@cd_site	char(1)
as

SET NOCOUNT ON	

	Declare @Fatura Table
		(
			Num_proc	varchar(16),
			Cd_tp_Tx	Varchar(3),
			DC			Varchar(1),
			fatcod		varchar(17)	
		)
	Begin 		
		Insert @Fatura			
			Select (case when len(i.fatcod)= 15 then left(i.fatcod,14) else	left(i.fatcod,16) end),	
			cd_tp_Tx,dc,I.fatcod from item_fat I With(nolock)			
				Join Fatura F With(nolock) on F.fatcod=i.fatcod 
			where
				fatdtEmissao >='01-01-2013' and fatstatus =1
	End	

Select 
	NFI.Num_Proc Processo, 
	TT.Nome_tp_tx Taxa, 
	NFI.DC DC, 
	TM.Nome_tp_moeda Moeda,
	NFI.VLR_ORG Vlr_Org, 
	NFI.Nota_Fiscal, 
	NFI.Ref_Acesso,
	NFI.Vlr_RS Vlr_Pgto,
	NFI.Paridade Par,
	NFI.Vlr_Iva IVA,
	NFI.ONF,
	NFI.RTX,
	fat.fatcod Invoice,
	TN.cd_servico,
	TN.Item_lei,
	TN.CNAE,
	TN.Descricao
from NF_Fatura_Item NFI with (nolock)
	join NF_Fatura NF with (nolock) on  NF.ID = NFI.ID
	join Tipo_taxa TT with (nolock) on  TT.cd_tp_tx = NFI.cd_tp_tx
	join Tipo_moeda TM with (nolock) on TM.cd_tp_moeda = NFI.cd_tp_moeda
	Left Join @Fatura FAT on FAT.num_proc=NFI.Num_Proc and FAT.cd_tp_Tx=NFI.cd_tp_tx and FAT.dc=NFI.DC
	left join Tipo_taxaXTipo_NF_Doc_Register TN With(nolock) on TN.cd_tp_tx = NFI.cd_tp_tx and TN.cd_site = @cd_site
where 
	NFI.ID = @ID

	
	

GO
