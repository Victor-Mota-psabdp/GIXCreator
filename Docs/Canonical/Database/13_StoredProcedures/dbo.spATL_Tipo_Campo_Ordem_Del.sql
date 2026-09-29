SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--select * from Tipo_Campo_Ordem
--sp_help Tipo_Campo_Ordem
CREATE Procedure [dbo].[spATL_Tipo_Campo_Ordem_Del]--'','','B'
(
	@Id_Campo			int,
	@Cd_Pes_Grupo		varchar(10),	
	@Descr_Campo		VarChar(30)
	
)
as
	

	BEGIN
		delete Tipo_Campo_Ordem where Id_Campo =@Id_Campo 
		--and (cd_pes_grupo='10017' or cd_pes_grupo=@Cd_Pes_Grupo) 
		and cd_pes_grupo=@Cd_Pes_Grupo
		and Descr_Campo = @Descr_Campo
	End
	   	 

GO
