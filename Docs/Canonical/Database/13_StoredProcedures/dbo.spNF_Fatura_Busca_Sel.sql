SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[spNF_Fatura_Busca_Sel]--'IMCSR201202144BRA'

	@FatCod varchar(17)
as

SET NOCOUNT ON	
	
	Declare @Fatura Table
		(
			Num_proc	varchar(16),
			Cd_tp_Tx	Varchar(3),
			DC			Varchar(1)			
		)
	Begin 		
		Insert @Fatura			
			Select (case when len(i.fatcod)= 15 then left(i.fatcod,14) else	left(i.fatcod,16) end),	
			cd_tp_Tx,dc from item_fat I				
				Join Fatura F on F.fatcod=i.fatcod 
			where
				i.fatcod = @FatCod 
				and fatstatus =1
	End		

	select
		numero_fat
	from nf_fatura_item  CC	
		Join @Fatura FAt on fat.num_proc=cc.num_proc and cc.cd_tp_Tx=FAt.cd_tp_tx and cc.dc=fat.dc    
		join nf_fatura NF on NF.id = CC.id and NF.Cd_Status <> 2 	
	--where	
	--NF.Cd_Status = 0	
	

GO
