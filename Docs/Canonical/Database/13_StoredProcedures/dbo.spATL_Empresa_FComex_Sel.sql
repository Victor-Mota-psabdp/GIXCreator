SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create Procedure [dbo].[spATL_Empresa_FComex_Sel]
(		@Id_Empresa [bigint],
		@Login      [varchar](100),
		@Tipo_Login bit, 
		@Tipo		varchar(1)
)
as
/* Empresas 
   A todas as empresas ativas ou não   
   B empresa unica por id somente ativas com o tipo de login  
   C empresa unica por id somente ativas 
*/
if @Tipo ='A'
			BEGIN
			   select 
					[Id_Empresa],
					[Nome_Empresa],
					[Login],
					[Password],
					[Tipo_Login],
					[Ativo],
					[Dt_Ins]
				from ATL_INT.dbo.Empresa_FComex
 		   END
Else
	if @Tipo ='B'
		BEGIN
             select 
					[Id_Empresa],
					[Nome_Empresa],
					[Login],
					[Password],
					[Tipo_Login],
					[Ativo],
					[Dt_Ins]
			from ATL_INT.dbo.Empresa_FComex
			where Id_Empresa = @Id_Empresa 
			and   Tipo_Login = @Tipo_Login
			and Ativo = 1	
		END
	if @Tipo ='C'
		BEGIN
             select 
					[Id_Empresa],
					[Nome_Empresa],
					[Login],
					[Password],
					[Tipo_Login],
					[Ativo],
					[Dt_Ins]
			from ATL_INT.dbo.Empresa_FComex
			where Tipo_Login = @Tipo_Login
			and Ativo  = 1 
		END

GO
