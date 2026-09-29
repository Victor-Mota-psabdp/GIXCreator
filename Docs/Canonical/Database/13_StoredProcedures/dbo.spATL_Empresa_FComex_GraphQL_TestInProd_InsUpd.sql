SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE Procedure [dbo].[spATL_Empresa_FComex_GraphQL_TestInProd_InsUpd]
   	@Id_Empresa [bigint],
   	@Id_Tipo [bigint],
	@GraphQL [varchar](MAX),
	@Ativo [bit]
AS
Begin Transaction
		begin 
				If  exists (select Id_Empresa from ATL_INT.dbo.Empresa_FComex_GraphQL_TestInProd 
				            where Id_Empresa = @Id_Empresa and Id_Tipo = @Id_Tipo)
					Begin
						Update
							atl_int.dbo.Empresa_FComex_GraphQL_TestInProd set 
							[GraphQL]=@GraphQL,
							[Ativo] = @Ativo
						Where Id_Empresa = @Id_Empresa 
                        And   Id_Tipo = @Id_Tipo
					End
				Else
					Begin	
						Insert into 
							  atl_int.dbo.Empresa_FComex_GraphQL_TestInProd
								  (
									Id_Empresa,
									Id_Tipo,
									GraphQL, 
									Ativo,
									Dt_Ins
								  )
								Values	
								(
									@Id_Empresa,
									@Id_Tipo,
									@GraphQL,
									@Ativo,
									getdate()
								)
					End
		end 
if @@error <> 0
		Begin
			RollBack Transaction
			return 0
		End
Commit Transaction

GO
