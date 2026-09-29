SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[spATL_Tipo_Banco_InsUpd]
(
	@Id_Tp_Banco		Int,
    @Nome_Tp_Banco		varchar(50),
    @Nome_Full_Banco	varchar(200),
	@Ativo				bit,
    @Cd_Usuario			varchar(6),
	@Dt_ins				Datetime
    
)
    
AS


Begin Transaction

	if exists (select id_tp_banco from Tipo_Banco where id_tp_banco = @id_tp_banco)
		Begin
			Update
					Tipo_Banco
				Set				        
					nome_tp_banco = @Nome_Tp_Banco,
					Nome_full_banco = @Nome_Full_Banco,
					Dt_Ins = GETDATE(),
					Cd_Usuario = @Cd_Usuario,
					Ativo = @Ativo
				Where
					id_tp_banco = @Id_Tp_Banco
		End
	Else
		Insert into Tipo_Banco
			(nome_tp_banco,Nome_full_banco,Cd_Usuario,dt_ins, Ativo)
		values
			(@Nome_Tp_Banco,@Nome_Full_Banco,@Cd_Usuario,GETDATE(),@Ativo)
	

Commit Transaction


	
		

GO
