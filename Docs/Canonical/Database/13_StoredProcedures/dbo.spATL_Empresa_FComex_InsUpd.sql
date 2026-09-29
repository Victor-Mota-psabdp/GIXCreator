SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


create Procedure [dbo].[spATL_Empresa_FComex_InsUpd]
   	@Id_Empresa [bigint],
	@Nome_Empresa [varchar](200),
	@Login [varchar](100),
	@Password [varchar](100),
	@Tipo_Login   bit,
	@Ativo [bit]
AS
Begin Transaction
		begin 
				If  exists (select Id_Empresa from ATL_INT.dbo.Empresa_FComex where Id_Empresa = @Id_Empresa)
					Begin
						Update
							ATL_INT.dbo.Empresa_FComex set 
							[Nome_Empresa]=@Nome_Empresa,
							[Login]   = @Login,
							[Password] = @Password,
							[Tipo_Login] = @Tipo_Login, 
							Ativo = @Ativo
						Where
							Id_Empresa = @Id_Empresa 
					End
				Else
					Begin	
						Insert into 
							  ATL_INT.dbo.Empresa_FComex 
								  (
									Id_Empresa,
									Nome_Empresa,
									[Login], 
									[Password], 
                                    tipo_login, 
									Ativo,
									Dt_Ins
								  )
								Values	
								(
									@Id_Empresa,
									@Nome_Empresa,
									@Login,
									@Password,
									@Tipo_Login,
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
