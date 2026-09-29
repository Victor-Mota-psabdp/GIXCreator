SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create Procedure [dbo].[spATL_FComex_Tipo_Nota_Fiscal_Sel]
(
		@Id_Empresa [bigint],
		@Descricao varchar(50),
		@Tipo		varchar(1)
)
as
/* Antonio 03-03-2026 selecionar a Empresas X Tipo de Notas Fiscais   
   A todas os tipos de notas ativas ou não   
   B tipo de nota unica por id somente ativas e pro empresa   
   C tipo de nota por id empresa ,sitsuação da nota (descricao) somente ativas 

exec    spATL_FComex_Tipo_Nota_Fiscal_Sel  0,'','A'
exec    spATL_FComex_Tipo_Nota_Fiscal_Sel  1,'','B'
exec    spATL_FComex_Tipo_Nota_Fiscal_Sel  2,'','B'
exec    spATL_FComex_Tipo_Nota_Fiscal_Sel  1,'NF Importação','C'
exec    spATL_FComex_Tipo_Nota_Fiscal_Sel  2,'NF Importação','C'

*/
if @Tipo ='A'
			BEGIN
			   select 
					tnf.Id             [Id],
					tnf.Id_Empresa     [Id Empresa],
					e.Nome_Empresa     [Nome Empresa],
					tnf.Descricao      [Situacao],
					u.cd_usuario       [Cd Usuario],
					u.nome_Usuario     [Nome Usuario],
					tnf.Ativo          [Ativo],
					tnf.Dt_Ins         [Dt Inclusao] 
				from  ATL_INT.dbo.FComex_Tipo_Nota_Fiscal tnf with(nolock) 
				join  ATL_INT.dbo.Empresa_FComex e with(nolock)
				on tnf.id_empresa = e.Id_empresa 
				join Usuario u with(nolock) 
				on tnf.CD_USUARIO = u.Cd_Usuario
 		   END
Else
	if @Tipo ='B'
		BEGIN
			   select 
					tnf.Id             [Id],
					tnf.Id_Empresa     [Id Empresa],
					e.Nome_Empresa     [Nome Empresa],
					u.cd_usuario       [Cd Usuario],
					u.nome_Usuario     [Nome Usuario],
					tnf.Descricao      [Situacao],
					tnf.Ativo          [Ativo],
					tnf.Dt_Ins         [Dt Inclusao] 
				from  ATL_INT.dbo.FComex_Tipo_Nota_Fiscal tnf with(nolock) 
				join  ATL_INT.dbo.Empresa_FComex e with(nolock)
				on tnf.id_empresa = e.Id_empresa 
				join Usuario u with(nolock) 
				on tnf.CD_USUARIO = u.Cd_Usuario
			where e.Id_Empresa = @Id_Empresa
			and   tnf.Id_Empresa = e.Id_Empresa
			and   tnf.Ativo = 1
		END
	if @Tipo ='C'
		BEGIN
              select 
					tnf.Id             [Id],
					tnf.Id_Empresa     [Id Empresa],
					e.Nome_Empresa     [Nome Empresa],
					tnf.Descricao      [Situacao],
					u.cd_usuario       [Cd Usuario],
					u.nome_Usuario     [Nome Usuario],
					tnf.Ativo          [Ativo],
					tnf.Dt_Ins         [Dt Inclusao] 
				from  ATL_INT.dbo.FComex_Tipo_Nota_Fiscal tnf with(nolock) 
				join  ATL_INT.dbo.Empresa_FComex e with(nolock)
				on tnf.id_empresa = e.Id_empresa 
				join Usuario u with(nolock) 
				on tnf.CD_USUARIO = u.Cd_Usuario
			where e.Id_Empresa = @Id_Empresa
			and   tnf.Id_Empresa = e.Id_Empresa
			and   tnf.Descricao = @Descricao 
			and   tnf.Ativo = 1
		END

GO
