SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/* Antonio 03-03-2026 - Gravar o tipo de nota fiscal que esta no FAZCOMEX para comprar com o JSON  
exec spATL_FComex_Tipo_Nota_Fiscal_InsUpd 0,1,'NF Importação','ATL',1
exec spATL_FComex_Tipo_Nota_Fiscal_InsUpd 0,2,'NF Importação','ATL',1
*/

Create Procedure [dbo].[spATL_FComex_Tipo_Nota_Fiscal_InsUpd]
	@Id [int],
	@Id_Empresa [bigint],
	@Descricao [varchar](50),
	@CD_USUARIO [varchar](6),
	@Ativo [bit]
AS

Begin Transaction
		begin 
			If  (select count(*) from ATL_INT.dbo.FComex_Tipo_Nota_Fiscal 
			     where id = @id 
				 and   id_empresa = @Id_Empresa) > 0 
	 				Begin
			  			Update
						ATL_INT.dbo.FComex_Tipo_Nota_Fiscal  set 
						Descricao = @Descricao ,
						CD_USUARIO =@CD_USUARIO,
						Ativo = @Ativo
						where id=@Id
						and   Id_Empresa = @Id_Empresa
					end 
			else 
				begin
					insert into ATL_INT.dbo.FComex_Tipo_Nota_Fiscal 
								(Id_Empresa,
								Descricao,
								Cd_Usuario,
								Ativo,
								Dt_Ins) 
					values  
								(@Id_Empresa,
								@Descricao,
								@CD_USUARIO,
								@Ativo,
								GetDate())
				end 
		End

	if @@error <> 0
		Begin

			RollBack Transaction
			return 0
		End

Commit Transaction
GO
