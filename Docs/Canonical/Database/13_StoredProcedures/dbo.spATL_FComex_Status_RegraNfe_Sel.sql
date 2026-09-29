SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create Procedure [dbo].[spATL_FComex_Status_RegraNfe_Sel]
(		
		@Id_Status int,
		--@Id_Empresa [bigint],
		@Descricao varchar(50),
		@Tipo		varchar(1)
)
as
/* Empresas 
   A todas os tipos status das notas ativas ou não   
   B tipo status de nota unica por id e empresa somente ativas   
   C tipo status de nota por id empresa e o descrição (situação) somente ativas 
   	   
exec    spATL_FComex_Status_RegraNfe_Sel 0, 0,'','A'
exec    spATL_FComex_Status_RegraNfe_Sel 0, 1,'','B'
exec    spATL_FComex_Status_RegraNfe_Sel 0, 2,'','B'
exec    spATL_FComex_Status_RegraNfe_Sel 0, 1,'Em Elaboração','C'
exec    spATL_FComex_Status_RegraNfe_Sel 0, 2,'NFe Emitida','C'

*/
if @Tipo ='A'
			BEGIN
			   select 
					S.Id_Status      [Id],					
					S.Descricao      [Situacao],
					U.cd_usuario       [Cd Usuario],
					U.nome_Usuario     [Nome Usuario],
					S.Ativo          [Ativo],
					S.Dt_Ins         [Dt Inclusao] 
				from  ATL_INT.dbo.FComex_Status_RegraNfe S with(nolock) 
				--join  ATL_INT.dbo.Empresa_FComex e with(nolock) on snf.id_empresa = e.Id_empresa 
				join Usuario u with(nolock) on U.CD_USUARIO = S.Cd_Usuario
 		   END
--Else
--	if @Tipo ='B'
--		BEGIN
--			   select 
--					snf.Id             [Id],
--					snf.Id_Empresa     [Id Empresa],
--					e.Nome_Empresa     [Nome Empresa],
--					snf.Descricao      [Situacao],
--					u.cd_usuario       [Cd Usuario],
--					u.nome_Usuario     [Nome Usuario],
--					snf.Ativo          [Ativo],
--					snf.Dt_Ins         [Dt Inclusao] 
--				from  ATL_INT.dbo.FComex_Status_RegraNfe snf with(nolock) 
--				join  ATL_INT.dbo.Empresa_FComex e with(nolock)
--				on snf.id_empresa = e.Id_empresa 
--				join Usuario u with(nolock) 
--				on snf.CD_USUARIO = u.Cd_Usuario
--			where e.Id_Empresa = @Id_Empresa
--			and   snf.Id_Empresa = e.Id_Empresa
--			and   snf.Ativo = 1	
--		END
--	if @Tipo ='C'
--		BEGIN
--              select 
--					snf.Id             [Id],
--					snf.Id_Empresa     [Id Empresa],
--					e.Nome_Empresa     [Nome Empresa],
--					snf.Descricao      [Situacao],
--					u.cd_usuario       [Cd Usuario],
--					u.nome_Usuario     [Nome Usuario],
--					snf.Ativo          [Ativo],
--					snf.Dt_Ins         [Dt Inclusao] 
--				from  ATL_INT.dbo.FComex_Status_RegraNfe snf with(nolock) 
--				join  ATL_INT.dbo.Empresa_FComex e with(nolock)
--				on snf.id_empresa = e.Id_empresa 
--				join Usuario u with(nolock) 
--				on snf.CD_USUARIO = u.Cd_Usuario
--			where snf.Id_Empresa = @Id_Empresa
--			and   snf.Id_Empresa = e.Id_Empresa
--            and   snf.Descricao = @Descricao  
--			and   snf.Ativo = 1	
--		END
	if @Tipo ='D'
		BEGIN
              select 
					Id_Status [Id Status],
					Descricao [Descricao],
					CD_USUARIO [Usuario],
					Ativo [Ativo],
					Dt_Ins [Dt Criacao]					
				from ATL_INT.DBO.FComex_Status_RegraNfe
				where Id_Status = @Id_Status
				and Ativo = 1
		END

GO
