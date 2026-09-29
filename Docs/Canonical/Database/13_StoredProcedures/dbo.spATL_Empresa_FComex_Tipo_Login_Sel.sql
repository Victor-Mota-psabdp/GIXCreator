SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create Procedure [dbo].[spATL_Empresa_FComex_Tipo_Login_Sel]
(		@Id_Tipo    [bigint],
		@ds_Tipo    varchar(2000),
		@Tipo		varchar(1)
)
as
/* Empresas 
   A todos os tipos de logins ativas somente    
   B tipo unico por id somente ativas   
*/
if @Tipo ='A'
			BEGIN
			   select 
					[Id_Tipo],
					[Ds_tipo],
					[Ativo],
					[Dt_Ins]
				from ATL_INT.dbo.Empresa_FComex_Tipo_Login
				where Ativo = 1	
 		   END
Else
	if @Tipo ='B'
		BEGIN
             select 
					[Id_Tipo],
					[Ds_tipo],
					[Ativo],
					[Dt_Ins]
			from ATL_INT.dbo.Empresa_FComex_Tipo_Login
			where Id_Tipo = @Id_Tipo 
			and Ativo = 1	
		END

GO
