SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE TRIGGER [dbo].[TrgCtaCteSFDCBO_Ins] ON [dbo].[Cta_Cte_HOU_BDP_OUT] For Insert 

AS 
BEGIN
	
Declare	@Num_Proc	Varchar(16)
Declare	@IC			bigint
Declare	@Cd_Tp_Tx	Varchar(3)
Declare	@DC			Varchar(1)

Select 
	@Num_Proc=Num_Proc_HBO,
	@Cd_Tp_Tx = Cd_Tp_Tx,
	@DC = DC_HBO,
	@IC=IC
from 
	INSERTED

if @Num_Proc is not null
	begin
		insert Exchange_Cta_cte(Num_Proc,IC,Tipo_Oper,Dt_Ins,Cd_Tp_Tx,DC)
		select @Num_Proc,@IC,'I',GETDATE(),@Cd_Tp_Tx,@DC
	end
	
END


GO
ALTER TABLE [dbo].[Cta_Cte_HOU_BDP_OUT] DISABLE TRIGGER [TrgCtaCteSFDCBO_Ins]
GO
