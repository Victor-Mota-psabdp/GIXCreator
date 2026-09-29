SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--sp_Help E_MIX_XML
CREATE procedure [dbo].[spATL_E_MIX_XML_Del]
(
	@Id_Consulta_Tipo	int,	
	@Num_Proc			varchar(16)
)
as
	if @Id_Consulta_Tipo = 31
	BEGIN
		If exists (select id_consulta_tipo from E_MIX_XML where id_consulta_tipo = @Id_Consulta_Tipo and Num_Proc = @Num_Proc)
			BEGIN
				delete E_MIX_XML where id_consulta_tipo = @Id_Consulta_Tipo and Num_Proc = @Num_Proc
			END
	END

GO
