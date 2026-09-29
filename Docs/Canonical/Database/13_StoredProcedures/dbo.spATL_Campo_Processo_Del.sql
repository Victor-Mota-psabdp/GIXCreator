SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[spATL_Campo_Processo_Del]
(	
	@Num_Proc		VarChar(16),
	@Descr_Campo	varchar(30)
)	
AS

BEGIN TRANSACTION

	Declare @ID_Campo int
	Declare @Cd_Pes_Grupo varchar(10)
	
	set @Cd_Pes_Grupo = (select Cd_Pes_Grupo from vwClienteALLJOBS V with(nolock) 
			join Pessoa_LLP LLP on LLP.Cd_Pes = V.cd_cliente	
		where V.num_proc = @Num_Proc)
		
	set @ID_Campo = (select ID_Campo from Tipo_Campo_Cliente with(nolock) 
	where Descr_Campo=@Descr_Campo and (Cd_Pes_Grupo=@Cd_Pes_Grupo or cd_pes_grupo='10017'))

	if exists (select Campo_Dados from Campo_Processo with(nolock) 
		where Id_Campo=@Id_Campo and Num_Proc=@Num_Proc)	
		BEGIN
			DELETE
				Campo_Processo
			WHERE
				Id_Campo=@Id_Campo and Num_Proc=@Num_Proc
		END
		

IF @@Error <> 0
	BEGIN
		ROLLBACK TRANSACTION
		RETURN -1
	END


COMMIT TRANSACTION






GO
