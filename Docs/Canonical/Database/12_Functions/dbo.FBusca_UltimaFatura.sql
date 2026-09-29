SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--Cadu - Incluido o status=1 09/03/15
CREATE function [dbo].[FBusca_UltimaFatura](
	@Num_proc varchar(16),
	@DC varchar(1),
	@Cd_Tp_tx varchar(3)
)returns varchar(50)
AS
Begin

declare @UltimaFatura varchar(50)

Set @UltimaFatura = (Select max(FatCod) from item_Fat FAT with(nolock) where FAT.Num_Proc = @Num_proc and FAT.cd_tp_tx = @Cd_Tp_tx and FAT.DC = @DC and FAT.FatCod in (select fatcod from fatura with(nolock) where fatcod=fat.fatcod and fatstatus<>'0'))

if @UltimaFatura is NULL
	Begin
		Set @UltimaFatura =  (Convert(varchar(50),( select 
			ID 
		from 
			Sol_Pgto_Cta_Cte_Item SolI with(nolock)
		where SOLI.Num_Proc = @Num_proc and SOLI.Cd_Tp_Tx = @Cd_Tp_tx and  SOLI.DC = @DC  and SOLI.ID in (select ID from Sol_Pgto_Cta_Cte SOL with(nolock) where SOL.ID =SOLI.ID and Status_Aprovacao = 'A' and Status = 1))))
	End 
return @UltimaFatura
End


GO
