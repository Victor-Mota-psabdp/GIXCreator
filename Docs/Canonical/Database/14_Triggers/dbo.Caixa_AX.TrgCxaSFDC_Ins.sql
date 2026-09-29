SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TRIGGER [dbo].[TrgCxaSFDC_Ins] ON [dbo].[Caixa_AX] For Insert 

AS 
BEGIN
	
Declare		@Num_Proc	Varchar(16)
Declare		@Cd_Tp_Tx	Varchar(3)
Declare		@DC	char(1)
Declare		@IC			bigint

Select @Num_Proc=Num_Proc from inserted
Select @Cd_Tp_Tx=Cd_Tp_Tx from inserted
Select @DC=DC from inserted

set @IC = (select IC from  vwCta_cTe CC  where CC.Num_Proc_HIA = @Num_Proc  and CC.cd_tp_tx = @Cd_Tp_Tx and cc.DC_HIA = @dc)


if @Num_Proc is not null and @IC is not NULL
	begin
		insert Exchange_Cta_cte(Num_Proc,IC,Tipo_Oper,Dt_Ins,Cd_Tp_Tx,DC)
		select @Num_Proc,@IC,'I',GETDATE(),@Cd_Tp_Tx,@DC
	end

END




GO
ALTER TABLE [dbo].[Caixa_AX] ENABLE TRIGGER [TrgCxaSFDC_Ins]
GO
