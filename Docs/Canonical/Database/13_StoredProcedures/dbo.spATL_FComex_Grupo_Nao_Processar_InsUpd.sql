SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Antonio 04-05-2026 -  Gravar Grupo, modal e empresa para comprar 
   se é para processar o job ou não 
*/

create  Procedure [dbo].[spATL_FComex_Grupo_Nao_Processar_InsUpd]
	@Cd_Grupo    varchar(3),
	@Cd_Tp_Modal varchar(2),
	@Id_Empresa [bigint],
	@CD_USUARIO [varchar](10),
	@Ativo [bit]
AS

Begin Transaction
		begin 
			If exists (select * from ATL_INT.dbo.FComex_Grupo_Nao_Processar
			where Cd_Grupo =@Cd_Grupo
			and   Cd_Tp_Modal = @Cd_Tp_Modal
			and   Id_Empresa = @Id_Empresa)
				 
	 				Begin
			  			Update
						ATL_INT.dbo.FComex_Grupo_Nao_Processar set 
						CD_USUARIO = @CD_USUARIO,
						Ativo = @Ativo
						where Cd_Grupo = @Cd_Grupo
						and   Cd_Tp_Modal = @Cd_Tp_Modal
						and   Id_Empresa = @Id_Empresa
					end 
			else 
				begin
					insert into ATL_INT.dbo.FComex_Grupo_Nao_Processar  
				  			   (Cd_Grupo,
								Cd_Tp_Modal,
								Cd_Usuario,
								Id_Empresa,
								Ativo,
								Dt_Ins) 
					values  
								(@Cd_Grupo,
								@Cd_Tp_Modal,
								@Cd_Usuario,
								@Id_Empresa,
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
