SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


--alter table ATL_INT.dbo.JSON_FComex_JobReferences_Line add [Situacao] [varchar](200) NULL

CREATE procedure [dbo].[spATL_JSON_FComex_JobReferences_Line_Upd]
(
	@Id_Processo [bigint],
	@Processo [varchar](200),
	@Num_Proc [varchar](200),	
	@Situacao  [varchar](200) NULL
)

AS
BEGIN TRANSACTION;
--Exceção(try/CATCH)
--Transação
--sp_help JSON_FComex_JobReferences

		IF exists(select  Id_Processo from ATL_INT.dbo.JSON_FComex_JobReferences_Line where Num_Proc = @Num_Proc)
			Begin
				Update
					ATL_INT.dbo.JSON_FComex_JobReferences_Line
				Set	
					[Dt_Ins_Atl] = Getdate(),
					[Situacao] =@Situacao
				Where
					Num_Proc = @Num_Proc	
			End	
		else IF exists(select  Id_Processo from ATL_INT.dbo.JSON_FComex_JobReferences_Line where Id_Processo = @Id_Processo)
			Begin
				Update
					ATL_INT.dbo.JSON_FComex_JobReferences_Line
				Set	
					[Dt_Ins_Atl] = Getdate(),
					[Situacao] =@Situacao
				Where
					Id_Processo = @Id_Processo	
			End	

if @@error <> 0
		Begin

			RollBack Transaction
			return 0
		End

Commit Transaction

GO
