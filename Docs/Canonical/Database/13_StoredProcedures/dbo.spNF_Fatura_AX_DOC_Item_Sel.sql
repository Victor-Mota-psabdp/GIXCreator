SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[spNF_Fatura_AX_DOC_Item_Sel]--'EAOXT201308003BRF'
	@FATCOD	Varchar(17)	
as	

SET NOCOUNT ON

--Declare @Fatura Table
--		(
--			Num_proc	varchar(16),
--			Cd_tp_Tx	Varchar(3),
--			DC			Varchar(1)			
--		)
--	Begin 		
--		Insert @Fatura	
			
--			Select (case when len(i.fatcod)= 15 then left(i.fatcod,14) else	left(i.fatcod,16) end),	
--			cd_tp_Tx,dc from item_fat I with(nolock)				
--				Join Fatura F with(nolock) on F.fatcod=i.fatcod 
--			where
--				F.fatcod = @FATCOD
--				and fatstatus =1
--	End		

select  
	distinct IA.Numero Nota_fiscal,IA.Ref_Accesso_Arg Codigo,IA.num_proc Num_Proc,CC.DocumentNum
from 
	ax_doc_item CC	with(nolock)
	Join vwFaturasValidas FAt with(nolock) on fat.num_proc=cc.num_proc and cc.cd_tp_Tx_Atl=FAt.cd_tp_tx and cc.dc=fat.dc
	Join vwFaturasValidasArg IA with(nolock) on fat.num_proc=IA.num_proc and IA.cd_tp_Tx=FAt.cd_tp_tx and IA.dc=fat.dc	
	--Join fatura_Arg_det IA on fat.num_proc=IA.num_proc and IA.cd_tp_Tx=FAt.cd_tp_tx and IA.dc=fat.dc	
	--Join fatura_Arg FA on IA.id_Fat=FA.id_Fat
where
	FatCod = @FATCOD
--FA.Status <>2
--and left(IA.num_proc,5) <> 'IAREM'
GO
