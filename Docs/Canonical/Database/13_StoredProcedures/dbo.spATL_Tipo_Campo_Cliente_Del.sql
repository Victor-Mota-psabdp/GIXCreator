SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--spATL_Tipo_Campo_Cliente_Sel
--spATL_Tipo_Campo_Cliente_InsUpd
--select * from Tipo_Campo_Cliente
--sp_help Tipo_Campo_Cliente
CREATE Procedure [dbo].[spATL_Tipo_Campo_Cliente_Del]--'','','B'
(
	--@Grupo			VarChar(20),
	--@Descr_campo	VarChar(30)
	@Id_Campo		Int,
	@Cd_Pes_Grupo	VarChar(10),
	@Descr_campo	VarChar(30)
	
)
as
	

	BEGIN
		delete tipo_campo_cliente where Descr_Campo =@Descr_campo 
			and (cd_pes_grupo='10017' 
			or cd_pes_grupo =@Cd_Pes_Grupo)
		--=(select cd_pes from pessoa where apelido=@Grupo))
	End

GO
