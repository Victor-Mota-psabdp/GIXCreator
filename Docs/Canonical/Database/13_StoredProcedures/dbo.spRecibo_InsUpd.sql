SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[spRecibo_InsUpd]

	@ID				bigint,
	@Apelido		varchar(20),
	@Num_Proc		varchar(16),
	@Fatura			varchar(17),
	@Dt_Recibo		datetime,
	@Usuario		varchar(30),
	@Total			decimal(18,2),	
	@New_ID			bigint output

as

	Declare @Cd_usuario		varchar(6)
	Declare @Cd_Cred_Dev	varchar(10)	
	set @Cd_usuario = (Select Cd_usuario from Usuario where Nome_Usuario = @Usuario)
	set @Cd_Cred_Dev = (Select Cd_pes from Pessoa where Apelido = @Apelido)

If @ID is NULL or @ID =''
	Begin
	set @New_ID=(Select ISNULL(MAX(ID),0)  from Recibo) + 1
	
		insert into Recibo
		(
			ID,Cd_Cred_Dev,Num_Proc,Fatura,Dt_Recibo,Cd_Usuario,Total
		)
		values
		(
			@New_ID,@Cd_Cred_Dev,@Num_Proc,@Fatura,GETDATE(),@Cd_usuario,@Total
		)
	End
--else
--	Begin
--		update 
--			Recibo 
--		set
			
--		where 
--			ID = @ID
		
--	End
GO
