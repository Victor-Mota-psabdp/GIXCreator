SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

Create Procedure [dbo].[spATL_FComex_Grupo_Nao_Processar_Sel]
(        
		@Cd_Grupo    varchar(3),
		@Cd_Tp_Modal varchar(2),
		@Id_Empresa [bigint],
		@Tipo		varchar(1)
)
as
/* Empresas 
   A todas os grupos ativos ou não cadastrados    
   B Grupo , modal, empresa  e ativo     
*/
if @Tipo ='A'
			BEGIN
			   select
			        gnp.Cd_Grupo       [Cd Grupo],
					gnp.Cd_Tp_Modal    [Cd Tp Modal],
					e.Id_Empresa       [Id Empresa],
					e.Nome_Empresa     [Nome Empresa],
					u.cd_usuario       [Cd Usuario],
					u.nome_usuario     [Nome Usuario],
					gnp.Ativo          [Ativo],
					gnp.Dt_Ins         [Dt Inclusao] 
				from  ATL_INT.dbo.FComex_Grupo_Nao_Processar gnp with(nolock) 
				join  ATL_INT.dbo.Empresa_FComex e with(nolock) 
				on gnp.id_empresa = e.Id_empresa
				join Usuario u with(nolock)	on gnp.CD_USUARIO = u.Cd_Usuario
		   END
Else
	if @Tipo ='B'
		BEGIN
			   select
			        gnp.Cd_Grupo       [Cd Grupo],
					gnp.Cd_Tp_Modal    [Cd Tp Modal],
					e.Id_Empresa       [Id Empresa],
					e.Nome_Empresa     [Nome Empresa],
					u.cd_usuario       [Cd Usuario],
					u.nome_usuario     [Nome Usuario],
					gnp.Ativo          [Ativo],
					gnp.Dt_Ins         [Dt Inclusao] 
				from  ATL_INT.dbo.FComex_Grupo_Nao_Processar gnp with(nolock) 
				join  ATL_INT.dbo.Empresa_FComex e with(nolock) 
				on gnp.id_empresa = e.Id_empresa
				join Usuario u with(nolock)	on gnp.CD_USUARIO = u.Cd_Usuario
			where gnp.Cd_Grupo = @Cd_Grupo 
			And   gnp.Cd_Tp_Modal = @Cd_Tp_Modal 
			And   gnp.Id_Empresa = @Id_Empresa 
			and   gnp.Ativo = 1	
		END

GO
