SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--sp_Help E_Mix_Consulta
CREATE procedure [dbo].[spATL_E_Mix_Consulta_Del]
(
	@Id_Consulta_Tipo	int,	
	@Num_Proc			varchar(16)
)
as
	if @Id_Consulta_Tipo = 31
	BEGIN
		If exists (select id_consulta_tipo from E_Mix_Consulta where id_consulta_tipo = @Id_Consulta_Tipo and Num_Proc = @Num_Proc)
			BEGIN
				delete E_Mix_Consulta where id_consulta_tipo = @Id_Consulta_Tipo and Num_Proc = @Num_Proc
			END
	END

GO
