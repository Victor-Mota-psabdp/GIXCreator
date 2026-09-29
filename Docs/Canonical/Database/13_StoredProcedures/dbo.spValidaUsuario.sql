SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--spValidaUsuario 'AO','desat','TI','ReportXLSCadastro'
CREATE procedure [dbo].[spValidaUsuario]
(
	@cd_usuario varchar(50), @Senha varchar(50), @cd_nivel varchar(3), @NameSpace varchar(150)
)
AS
select 
	U.nome_usuario, U.cd_usuario, V.versao 
from 
	usuario U, versao_c# V
where 
	U.cd_usuario=@cd_usuario
	 and V.namespace = @NameSpace 
	 and ck_ativo=1 
	 and senha=@Senha 
	 and U.cd_nivel=@cd_nivel


	insert versao_c# values(100,'ReportXLSCadastro',getdate(),'AO')



GO
