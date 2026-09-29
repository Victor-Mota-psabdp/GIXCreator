SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE procedure [dbo].[spATL_BR_procEventoNFeEvento_InsUpd]
(
	@Id			int,
	@versao		Varchar(30),	
	@Num_Proc	Varchar(16),
	@nNF		Varchar(20),
	@dt_ins		Datetime,
	@Nome_Arquivo varchar(200)
)
AS

BEGIN
--Exceção(try/CATCH)
--Transação
--sp_help procEventoNFeEvento
	BEGIN TRY			
		
		set @Id = (select Id from ATL_BR.dbo.procEventoNFeEvento where Num_Proc = @Num_Proc and nNF = @nNF)	

		if @Id is null
			Begin
				Set @Id=(select  Isnull(max(Id),0)+1 from ATL_BR.dbo.procEventoNFeEvento)					
				Insert into ATL_BR.dbo.procEventoNFeEvento
				(
					Id,versao,Num_Proc,Nome_Arquivo,nNF
				)
				Values
				(
					@Id,@versao,@Num_Proc,@Nome_Arquivo,@nNF
				)
			End
		Else
			BEGIN
				Update
					ATL_BR.dbo.procEventoNFeEvento
				SET					
					Nome_Arquivo = @Nome_Arquivo					
				Where
					Id=@Id
			END		
			
		Select @Id as Retorno;

		COMMIT TRAN
	END TRY

	BEGIN CATCH
		ROLLBACK TRAN
		SELECT ERROR_MESSAGE() as Retorno;

	END CATCH	

END

GO
