SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TRIGGER [dbo].[TrgCtaCteSFDCAXDOCITEM_Ins] ON [dbo].[AX_Doc_Item] For Insert 

AS 
BEGIN
	
Declare		@Num_Proc	Varchar(16)
Declare		@Cd_Tp_Tx_ATL	Varchar(3)
Declare		@DC	char(3)
Declare		@IC			bigint

Select @Num_Proc=Num_Proc from inserted
Select @Cd_Tp_Tx_ATL=Cd_Tp_Tx_ATL from inserted
Select @DC=DC from inserted

set @IC = (select IC from  vwCta_cTe CC  where CC.Num_Proc_HIA = @Num_Proc  and CC.cd_tp_tx = @Cd_Tp_Tx_ATL and cc.DC_HIA = @dc)


if @Num_Proc is not null and @IC is not NULL
	begin
		--insert Exchange_Cta_cte
		--select @Num_Proc,@IC,'I',GETDATE(),NULL,NULL
		insert Exchange_Cta_cte(Num_Proc,IC,Tipo_Oper,Dt_Ins,Cd_Tp_Tx,DC)
		select @Num_Proc,@IC,'I',GETDATE(),@Cd_Tp_Tx_ATL,@DC
	end

else
	begin
	insert LOG_IC_AX
	select @Num_Proc,@Cd_Tp_Tx_ATL,@dc
	End
END




GO
ALTER TABLE [dbo].[AX_Doc_Item] ENABLE TRIGGER [TrgCtaCteSFDCAXDOCITEM_Ins]
GO
