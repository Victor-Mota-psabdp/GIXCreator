SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--sp_help Tipo_Remessa_Boleto
CREATE procedure [dbo].[spATL_Tipo_Remessa_Boleto_Del]
(
	@Id_Tp_Remessa BIGINT
)
as
	if exists(select Id_Tp_Remessa from Tipo_Remessa_Boleto where Id_Tp_Remessa= @Id_Tp_Remessa)
	BEGIN
		UPDATE Tipo_Remessa_Boleto SET ATIVO= 0 where Id_Tp_Remessa= @Id_Tp_Remessa
	END

GO
