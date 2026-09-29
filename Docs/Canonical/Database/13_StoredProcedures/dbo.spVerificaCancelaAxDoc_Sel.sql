SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--spVerificaCancelaAxDoc_Teste_Sel 'IMLVS201411018BR', 'Armazenagem 1 - CHB',  'D'
--Cadu - Incluido o status=1 09/03/15 e verificar se tem sol pagto

CREATE procedure [dbo].[spVerificaCancelaAxDoc_Sel](
	@Num_Proc as varchar(16),
	@Nome_Tp_Tx as varchar(50),
	@DC	as varchar(1)
)
as
	
Declare @Cd_Tp_Tx as varchar(3)
Declare @UltimaFatura varchar(50)

Set @Cd_Tp_Tx = (Select Cd_Tp_Tx from Tipo_Taxa with(nolock) where nome_tp_tx = @Nome_Tp_Tx)

Set @UltimaFatura = (Select max(FatCod) Fatura from item_Fat FAT where FAT.Num_Proc = @Num_Proc and FAT.cd_tp_tx = @Cd_Tp_Tx  and FAT.DC = @DC and FAT.FatCod in (select fatcod from fatura where fatcod=fat.fatcod and fatstatus='1'))
	
if @UltimaFatura is NULL
	Begin
		Set @UltimaFatura = 
		(Convert(varchar(50),(select ID from vwSolPgtoCtaCteAprovadas SOLI where SOLI.Num_Proc = @Num_Proc and SOLI.Cd_Tp_Tx =@Cd_Tp_Tx  and  SOLI.DC = @DC)))		
	End
 
select @UltimaFatura  as Fatura



--Declare @Cd_Tp_Tx as varchar(3)

-- Set @Cd_Tp_Tx = (Select Cd_Tp_Tx from Tipo_Taxa with(nolock) where nome_tp_tx = @Nome_Tp_Tx)

--Select 
--	max(FatCod) Fatura
--from 
--	item_Fat FAT 
--where 
--	FAT.Num_Proc = @Num_Proc and FAT.cd_tp_tx = @Cd_Tp_Tx and FAT.DC = @DC and FAT.FatCod in (select fatcod from fatura where fatcod=fat.fatcod and fatstatus='1')
	
GO
