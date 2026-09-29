SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE procedure [dbo].[spLogRecCtaCte_InsUpd]--'MA2009120006', 'LB2000080001'

	@num_lcto_mov		varchar(12),
	@num_lcto_rec		varchar(12),
	@Tp_Oper_rec		char(1),
	@Usuario			varchar(30)

AS

Begin Transaction	
	Declare @Cd_Usuario  varchar(6)

	Set @Cd_Usuario = (Select cd_usuario from Usuario where nome_usuario = @Usuario)
	Insert Into 
		Log_rec_cta_cte
		(Data_Rec,Cd_Usuario,Tp_Oper_Rec,num_lcto_mov, num_lcto_rec)
	Values 
		(getdate(),@Cd_Usuario,@TP_Oper_Rec,@num_lcto_mov, @num_lcto_rec)

	If @@RowCount <> 1 
		Begin 
			RollBack Transaction 
			Return -1 
		End 	
Commit Transaction







GO
