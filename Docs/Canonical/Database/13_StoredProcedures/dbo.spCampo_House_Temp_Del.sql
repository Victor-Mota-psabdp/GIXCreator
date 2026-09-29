SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--sp_help Campo_House_Temp
CREATE procedure [dbo].[spCampo_House_Temp_Del]
(
		@ID_TP_House_Temp	bigint,
		@Id_Campo			int
)
as
if exists(select @ID_Campo from ATL_INT.dbo.Campo_House_Temp where ID_Campo= @ID_Campo AND ID_TP_House_Temp = @ID_TP_House_Temp)
	begin
		update ATL_INT.dbo.Campo_House_Temp set [Enabled] = 0 WHERE ID_Campo = @ID_Campo AND ID_TP_House_Temp = @ID_TP_House_Temp
	end

GO
