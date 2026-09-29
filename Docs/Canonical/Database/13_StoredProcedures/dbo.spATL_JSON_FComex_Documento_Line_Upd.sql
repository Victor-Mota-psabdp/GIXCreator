SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--alter table ATL_INT.dbo.JSON_FComex_Documento_Line add [Message] [varchar](2000) NULL
--ALTER TABLE ATL_INT.dbo.JSON_FComex_Documento_Line ADD [ID] [bigint] IDENTITY NOT NULL
CREATE procedure [dbo].[spATL_JSON_FComex_Documento_Line_Upd]

	@Id_Processo [bigint],
	@Id_Item     [bigint],	
    @Message	 [varchar](2000) NULL,
   	@Dt_Ins_Atl  datetime
AS
Begin Transaction
--Exceção(try/CATCH)
--Transação
--sp_help ATL_INT.dbo.JSON_FComex_Documento_Line

	BEGIN 
		IF exists(select Id_Processo from ATL_INT.dbo.JSON_FComex_Documento_Line where Id_Processo = @Id_Processo and Id_Item =@Id_Item)
			Begin
				Update
					ATL_INT.dbo.JSON_FComex_Documento_Line
				Set	
                    [Message] =  @Message,
					[Dt_Ins_Atl] = @Dt_Ins_Atl,
					[File] = NULL
				Where
					Id_Processo = @Id_Processo 	and Id_Item=@Id_Item
			End
		
    END 
if @@error <> 0
		Begin

			RollBack Transaction
			return 0
		End
Commit Transaction
GO
