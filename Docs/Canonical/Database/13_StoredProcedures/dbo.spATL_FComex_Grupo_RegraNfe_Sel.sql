SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create Procedure [dbo].[spATL_FComex_Grupo_RegraNfe_Sel]
(        
		@Id_Regra [bigint],
		@Id_Empresa [bigint],
        @CNPJ       varchar(08), 
		@Tipo		varchar(1)
)
as
/* Empresas 
   A todas os grupos ativos ou não de notas fiscais ativo ou não   
   B Grupo unico de nota fiscal por empresa com nota fiscal ativa    
   C Grupo Unico de Nota Fiscal, por CNPJ e empresa ativo     
*/
if @Tipo ='A'
			BEGIN
			   select
			        fgr.Id_Regra       [Id Regra],
					fgr.Id_Empresa     [Id Empresa],
					e.Nome_Empresa     [Nome Empresa],
					fgr.CNPJ	       [CNPJ],
					fsr.Id_Status      [Id Status],
					fsr.Descricao      [Situacao],
					u.cd_usuario       [Cd Usuario],
					u.nome_usuario     [Nome Usuario],
					fgr.Ativo          [Ativo],
					fgr.Dt_Ins         [Dt Inclusao] 
				from  ATL_INT.dbo.FComex_Grupo_RegraNfe fgr with(nolock) 
				join  ATL_INT.dbo.FComex_Status_RegraNfe fsr with(nolock) on fsr.Id_Status = fgr.Id_Status
				join  ATL_INT.dbo.Empresa_FComex e with(nolock) on fgr.id_empresa = e.Id_empresa
				join Usuario u with(nolock)	on fgr.CD_USUARIO = u.Cd_Usuario
		   END
Else
	if @Tipo ='B'
		BEGIN
		   select 
			        fgr.Id_Regra       [Id Regra],
					fgr.Id_Empresa     [Id Empresa],
					e.Nome_Empresa     [Nome Empresa],
					fgr.CNPJ	       [CNPJ],
					fsr.Id_Status      [Id Status],
					fsr.Descricao      [Situacao],
					u.cd_usuario       [Cd Usuario],
					u.nome_usuario     [Nome Usuario],
					fgr.Ativo          [Ativo],
					fgr.Dt_Ins         [Dt Inclusao] 
				from  ATL_INT.dbo.FComex_Grupo_RegraNfe fgr with(nolock) 
				join  ATL_INT.dbo.FComex_Status_RegraNfe fsr with(nolock) on  fsr.Id_status = fgr.Id_Status
				join  ATL_INT.dbo.Empresa_FComex e with(nolock) on fgr.id_empresa = e.Id_empresa
				join Usuario u with(nolock)	on fgr.CD_USUARIO = u.Cd_Usuario
			where fgr.Id_Empresa = @Id_Empresa 
			and   fgr.Ativo = 1	
		END
if @Tipo ='C'
		BEGIN
		   select 
			        fgr.Id_Regra       [Id Regra],
					fgr.Id_Empresa     [Id Empresa],
					e.Nome_Empresa     [Nome Empresa],
					fgr.CNPJ	       [CNPJ],
					fsr.Id_Status      [Id Status],
					fsr.Descricao      [Situacao],
					u.cd_usuario       [Cd Usuario],
					u.nome_usuario     [Nome Usuario],
					fgr.Ativo          [Ativo],
					fgr.Dt_Ins         [Dt Inclusao] 
				from  ATL_INT.dbo.FComex_Grupo_RegraNfe fgr with(nolock) 
				join  ATL_INT.dbo.FComex_Status_RegraNfe fsr with(nolock) on fsr.Id_status = fgr.Id_Status
				join  ATL_INT.dbo.Empresa_FComex e with(nolock)	on fgr.id_empresa = e.Id_empresa
				join Usuario u with(nolock) on fgr.CD_USUARIO = u.Cd_Usuario
			where fgr.Id_Empresa = @Id_Empresa
			and   fgr.CNPJ = @CNPJ 
			and   fgr.Ativo = 1	
		END

GO
