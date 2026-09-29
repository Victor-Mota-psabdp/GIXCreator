SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--sp_help Tipo_Embalagem
create procedure [dbo].[spATL_Tipo_Embalagem_Del]
(
	@Cd_Tp_Embal	varchar(3)
)
as
	UPDATE Tipo_Embalagem SET ATIVO= 'N' where Cd_Tp_Embal=@Cd_Tp_Embal
GO
