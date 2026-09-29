SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



CREATE Procedure [dbo].[spRManagerv2Datas_Sel] 
	@Num_Proc	Varchar(16)
as

Declare @DataSyncro Datetime

Declare @DemurrageHistoric  Varchar(500)
Declare @DemurragePeriod	Varchar(20)
Declare @WarehousePeriod	Varchar(20)


if left(@Num_Proc,2)='IM'
	Begin
		Set @DataSyncro = (select top 1 data_envio from nota_cliente with(nolock) where num_proc=@Num_Proc)
		Set @DemurrageHistoric = (select top 1 campo_dados from campo_processo with(nolock) where num_proc=@Num_Proc and id_Campo=105)
		Set @DemurragePeriod=(select top 1 campo_dados from campo_processo with(nolock) where num_proc=@Num_Proc and id_Campo=102)
		Set @WarehousePeriod=(select top 1 campo_dados from campo_processo with(nolock) where num_proc=@Num_Proc and id_Campo=118)
	End

select 
	@Num_Proc Num_Proc, @DataSyncro Synchro_Date, [dbo].[fBusca_Tarefa](@Num_Proc,115)  DANFE1Approval1Date,
	@DemurrageHistoric Demurrage1Historic,@DemurragePeriod Demurrage1Period,@WarehousePeriod Warehouse1Period



GO
