SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


create procedure [dbo].[spControleFatura_Periodo_CampoProcessos_InsUpdDel]
(
	@Tipo char(1), --	I = Insert ,  D = Delete
	@processo varchar(16),
	@id_campo int,
	@periodo int,	
	@cd_usuario varchar(10)
	
)
AS

Begin Transaction	

	IF @Tipo = 'I' 
		Begin
			if NOT exists(select * from campo_processo where id_campo = @id_campo and num_proc = @processo)
				Begin
					Insert into campo_processo
					Values(@processo,@id_campo,@periodo,getdate(),@cd_usuario)
				End
			else
				Update
					campo_processo
				Set
					campo_dados = @periodo,
					dt_ins = getdate(),
					cd_usuario = @cd_usuario				
				Where
					id_campo = @id_campo and num_proc = @processo		
					
		End	


	IF @Tipo = 'D'
		Begin
			DELETE campo_processo
			where id_campo = @id_campo and num_proc = @processo
		End

Commit Transaction


GO
