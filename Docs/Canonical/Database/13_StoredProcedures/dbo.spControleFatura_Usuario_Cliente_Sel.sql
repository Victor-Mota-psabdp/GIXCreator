SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE Procedure [dbo].[spControleFatura_Usuario_Cliente_Sel]

	 
as 
	select distinct 
		nome_usuario 
		from usuario_cliente 
	where ativo = 'S' 
	and cd_usuario not in('+','010') 
	and nome_usuario is not null order by 1
GO
