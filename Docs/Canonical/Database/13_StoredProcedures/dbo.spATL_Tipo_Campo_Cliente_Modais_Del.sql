SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--select * from Tipo_Campo_Cliente_Modais
--sp_help Tipo_Campo_Cliente_Modais
CREATE Procedure [dbo].[spATL_Tipo_Campo_Cliente_Modais_Del]--'','','B'
(	
	@Id_Campo		Int
)
as	

	BEGIN
		IF EXISTS(SELECT ID_CAMPO FROM Tipo_Campo_Cliente_Modais where Id_Campo = @Id_Campo )
			BEGIN
				delete Tipo_Campo_Cliente_Modais where Id_Campo = @Id_Campo 
			end
			
	End

GO
