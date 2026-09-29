SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE TRIGGER [dbo].[TrgCtaCteSFDCIA_Ins] ON [dbo].[Cta_Cte_Hou_Imp_Aer] For Insert 

AS 
BEGIN
	
Declare	@Num_Proc	Varchar(16)
Declare	@IC			bigint
Declare	@Cd_Tp_Tx	Varchar(3)
Declare	@DC			Varchar(1)

Select 
	@Num_Proc=Num_Proc_HIA,
	@Cd_Tp_Tx = Cd_Tp_Tx,
	@DC = DC_HIA,
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
ALTER TABLE [dbo].[Cta_Cte_Hou_Imp_Aer] ENABLE TRIGGER [TrgCtaCteSFDCIA_Ins]
GO
