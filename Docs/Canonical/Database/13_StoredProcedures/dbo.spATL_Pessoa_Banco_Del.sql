SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--sp_help Pessoa_Banco
Create procedure [dbo].[spATL_Pessoa_Banco_Del]
(
	@Cd_Pes			varchar(10),
	@Id_Tp_Banco	int,
	@ID_Item		int
)
as
if exists(select id_pes_banco from Pessoa_Banco where Cd_Pes = @Cd_Pes and ID_Item = @ID_Item )
BEGIN
	delete
		Pessoa_Banco 
	where 
		Cd_Pes = @Cd_Pes and ID_Item = @ID_Item 
END



						
						


GO
