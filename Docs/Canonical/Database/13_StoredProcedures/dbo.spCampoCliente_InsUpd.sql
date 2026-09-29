SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE procedure [dbo].[spCampoCliente_InsUpd]

@Num_Proc		varchar(16),
@Campo			varchar(30),
@Campo_Dados	varchar(500)


as
Begin Transaction

	Declare @ID int
	set	@ID = (select distinct id_campo from Tipo_Campo_Cliente where descr_campo = @Campo )
	if exists(select * from Campo_Processo where num_proc = @Num_Proc and id_campo = @ID)
		begin
			Update
				Campo_Processo
			set
				campo_Dados = @Campo_Dados
			where
				num_proc = @Num_Proc and id_campo = @ID
		end
	else
		begin
			insert into 
				Campo_Processo (Num_Proc, id_Campo, Campo_Dados)
			values
				(@Num_Proc, @ID, @Campo_Dados)
		end
		
		IF @@Error <> 0
					BEGIN
						ROLLBACK TRANSACTION
						RETURN -1
					END


		COMMIT TRANSACTION
		

GO
