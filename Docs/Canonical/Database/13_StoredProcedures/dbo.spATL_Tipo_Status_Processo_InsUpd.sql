SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--sp_help Tipo_Status_Processo
create  procedure  [dbo].[spATL_Tipo_Status_Processo_InsUpd]
(
	@ID_Status				int,
	@Status_Descricao		Varchar(30),
	@Ativo					Varchar(1),
	@CtaCte_IUD				Varchar(3),
	@Financeiro_IUD			Varchar(3),
	@Faturamento_IUD		Varchar(3),
	@Job_IUD				Varchar(3),
	@Historico_IUD			Varchar(3),
	@Status_Descricao_Ingles	Varchar(60),
	@Ordem					int
	
)

as
	if not exists (select ID_Status from Tipo_Status_Processo where ID_Status=@ID_Status)
		Begin
			Set @ID_Status =(Select Isnull(max(ID_Status),0) + 1 from Tipo_Status_Processo)
			Insert Into
				Tipo_Status_Processo
				(
					ID_Status,Status_Descricao,Ativo,CtaCte_IUD,Financeiro_IUD,Faturamento_IUD,
					Job_IUD,Historico_IUD,Status_Descricao_Ingles,Ordem
				)
			Values
				(
					@ID_Status,@Status_Descricao,@Ativo,@CtaCte_IUD,@Financeiro_IUD,@Faturamento_IUD,
					@Job_IUD,@Historico_IUD,@Status_Descricao_Ingles,@Ordem
				)
		End
	Else
	    Begin		
			Update
				Tipo_Status_Processo
			Set
				Status_Descricao = @Status_Descricao,
				Ativo = @Ativo,
				CtaCte_IUD = @CtaCte_IUD,
				Financeiro_IUD = @Financeiro_IUD,
				Faturamento_IUD = @Faturamento_IUD,
				Job_IUD = @Job_IUD,
				Historico_IUD = @Historico_IUD,
				Status_Descricao_Ingles = @Status_Descricao_Ingles,
				Ordem = @Ordem
			Where
				ID_Status = @ID_Status				
		End

	

IF @@Error <> 0
	BEGIN
		ROLLBACK TRANSACTION
		RETURN -1
	END

GO
