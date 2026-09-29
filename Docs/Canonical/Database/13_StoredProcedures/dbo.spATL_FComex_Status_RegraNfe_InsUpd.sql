SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Antonio 03-03-2026 - Gravar a Situação da emissão da nota fiscal que esta no FAZCOMEX 
   para comprar com o JSON 
   exec spATL_FComex_Status_RegraNfe_InsUpd 0,1,'Em Elaboração','ATL',1
   exec spATL_FComex_Status_RegraNfe_InsUpd 0,2,'NFe Emitida','ATL',1
*/

Create Procedure [dbo].[spATL_FComex_Status_RegraNfe_InsUpd]
	@Id_Status [int],	
	@Descricao [varchar](50),
	@CD_USUARIO [varchar](6),
	@Ativo [bit]
AS

Begin Transaction
		begin 
			If  exists (select * from ATL_INT.dbo.FComex_Status_RegraNfe where Id_Status = @Id_Status)
	 				Begin
			  			Update
						ATL_INT.dbo.FComex_Status_RegraNfe  set 
						Descricao = @Descricao ,
						CD_USUARIO =@CD_USUARIO,
						Ativo = @Ativo
						where Id_Status = @Id_Status
					end 
			else 
				begin
					insert into ATL_INT.dbo.FComex_Status_RegraNfe 
								(
								Descricao,
								Cd_Usuario,
								Ativo,
								Dt_Ins) 
					values  
								(
								@Descricao,
								@CD_USUARIO,
								@Ativo,
								getdate())
				end 
		End

	if @@error <> 0
		Begin

			RollBack Transaction
			return 0
		End

Commit Transaction
GO
