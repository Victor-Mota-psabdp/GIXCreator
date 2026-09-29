SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE TRIGGER [dbo].[TrgCtaCteSFDCMEM_Del] ON [dbo].[Cta_Cte_Mas_Exp_Mar] For Delete 

AS 
BEGIN
	
Declare	@Num_Proc	Varchar(16)
Declare	@IC			bigint
Declare	@Cd_Tp_Tx	Varchar(3)
Declare	@DC			Varchar(1)

Select 
	@Num_Proc=Num_Proc_MEM,
	@Cd_Tp_Tx = Cd_Tp_Tx,
	@DC = DC_MEM,
	@IC=IC
from 
	DELETED

if @Num_Proc is not null
	begin
		insert Exchange_Cta_cte(Num_Proc,IC,Tipo_Oper,Dt_Ins,Cd_Tp_Tx,DC)
		select @Num_Proc,@IC,'D',GETDATE(),@Cd_Tp_Tx,@DC
	end
	
END


GO
ALTER TABLE [dbo].[Cta_Cte_Mas_Exp_Mar] ENABLE TRIGGER [TrgCtaCteSFDCMEM_Del]
GO
