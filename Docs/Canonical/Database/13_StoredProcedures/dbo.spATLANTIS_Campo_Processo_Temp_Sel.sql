SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--SP_HELP Campo_Processo_Temp
CREATE Procedure [dbo].[spATLANTIS_Campo_Processo_Temp_Sel]--'2'
(
	@ID	BIGINT
)

as
	select ID,ID_House_Temp,ID_Req,Intl_Reference,Num_Proc,			
			Id_Campo,Name_Id_Campo,Campo_Dados,cd_usuario,Dt_Insert
	from Campo_Processo_Temp
	where
		ID = @ID

GO
