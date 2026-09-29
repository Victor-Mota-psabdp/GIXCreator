SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create Procedure [dbo].[spATL_Empresa_FComex_GraphQL_Sel]
(		@Id_Empresa [bigint],
		@Id_Tipo    [bigint],
		@Tipo		varchar(1)
)
as
/* GraphQl das Empresas 
   A GraphQL por empresas e tipo ativas ou não   
   B GraphQL unica por empresa e id e ativas  
*/
if @Tipo ='A'
			BEGIN
			   select 
					a.[Id_Empresa],
					a.[Id_Tipo],
					a.[GraphQL],
					a.[Ativo],
					a.[Dt_Ins],
					b.[Nome_Empresa]
				from ATL_INT.dbo.Empresa_FComex_GraphQL a
				join ATL_INT.dbo.Empresa_FComex b
				     on b.Id_Empresa = a.Id_Empresa
				where a.Id_Empresa = @Id_Empresa
				and   a.Id_Tipo = @Id_Tipo
 		   END
Else
	if @Tipo ='B'
		BEGIN
			   select 
					a.[Id_Empresa],
					a.[Id_Tipo],
					a.[GraphQL],
					a.[Ativo],
					a.[Dt_Ins],
					b.[Nome_Empresa]
				from ATL_INT.dbo.Empresa_FComex_GraphQL a
				join ATL_INT.dbo.Empresa_FComex b
				     on b.Id_Empresa = a.Id_Empresa
				where a.Id_Empresa = @Id_Empresa
				and   a.Id_Tipo = @Id_Tipo
				and   a.Ativo = 1	
		END

GO
