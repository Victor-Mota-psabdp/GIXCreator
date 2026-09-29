SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


Create Procedure spJobJanela_InsUpd

		@Janela_Descricao	Varchar(50),
		@Num_Proc			Varchar(16),
		@DataInicio			Datetime,
		@DataFinal			Datetime
as
Begin Transaction
		Declare @ID_Janela	Int
		Set @Id_Janela=(select id_janela from Tipo_Janela where Janela_Descricao=@Janela_Descricao)

		if not exists(select id_janela from janela_processos where id_janela=@id_Janela and num_proc=@num_proc)
			Begin
				Insert into
						Janela_Processos
							(
								ID_Janela,
								Num_Proc,
								DataInicio,
								DataFinal
							)
					Values
							(
								@ID_Janela,
								@Num_Proc,
								@DataInicio,
								@DataFinal
							)
			End
	ELSe
			BEGIN
				Update
					Janela_Processos
				Set
					DataInicio=@DataInicio,
					DataFinal=@DataFinal
				Where
					ID_Janela=@ID_Janela and
					num_proc=@num_proc
			End
	if @@Error <> 0
			Begin
				Rollback Transaction
				Return -1
			End
Commit Transaction


GO
