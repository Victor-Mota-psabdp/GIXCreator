SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE procedure [dbo].[spSolPgtoAutoriza_Upd]
(
	@ID bigint,
	@Cd_Usuario varchar(6),
	@Tipo char(1)
)
as

Begin
	Update Sol_Pgto_Cta_Cte 
		set Status_Aprovacao = @Tipo, 
		Dt_Aprovacao = GETDATE(), 
		Cd_Gerente = @Cd_Usuario
	where ID = @ID
end

begin
	Insert into [dbo].[Log_Sol_Pgto_Cta_Cte_Autorizacao]
	([ID],[Status_Aprovacao],[Dt_Aprovacao],[Cd_Gerente])
	values
	(@ID,@Tipo,GETDATE(),@Cd_Usuario)	
End
GO
