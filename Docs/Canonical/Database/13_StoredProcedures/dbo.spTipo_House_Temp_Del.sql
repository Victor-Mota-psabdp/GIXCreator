SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- ATL_INT.dbo.[Tipo_House_Temp]
--sp_help Tipo_House_Temp
CREATE PROCEDURE [dbo].[spTipo_House_Temp_Del]
(
	@Id_TP_House_Temp	bigint
)

AS

Begin Transaction

if not exists(select Id_TP_House_Temp from ATL_INT.dbo.[Tipo_House_Temp] 
	where Id_TP_House_Temp= @Id_TP_House_Temp)
BEGIN
	update ATL_INT.dbo.[Tipo_House_Temp] set Ativo = 0	where 	Id_TP_House_Temp= @Id_TP_House_Temp
END

	IF @@Error <> 0
		BEGIN
			ROLLBACK TRANSACTION
			RETURN -1
		END

Commit Transaction 


GO
