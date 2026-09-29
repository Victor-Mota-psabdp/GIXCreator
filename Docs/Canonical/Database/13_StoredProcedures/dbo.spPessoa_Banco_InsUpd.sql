SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spPessoa_Banco_InsUpd]

			@cd_pes 			varchar(10),
			@ID_Item 			int,
			@Nome_tp_banco		varchar(50),
			@Cd_Banco			varchar(50),
			@Cd_Agencia			varchar(50),
			@Conta_Corrente		varchar(50),
			@Nome_Usuario		varchar(100)
AS

Begin Transaction
	
	declare @Id_Tp_Banco as int
	set @Id_Tp_Banco = (select Id_Tp_Banco from tipo_banco where Nome_tp_banco= @Nome_tp_banco)
	
	declare @cd_usuario as varchar(6)
	set @cd_usuario = (select cd_usuario from Usuario where Nome_Usuario= @Nome_Usuario)
	
	if not exists(Select ID_ITEM from Pessoa_Banco where ID_ITEM=@ID_Item and cd_pes = @cd_pes)
		Begin
			Declare @New_ID_Item bigint
			Set @New_ID_Item = (Select ISNULL(max(ID_Item),0)+1 from Pessoa_Banco where cd_pes = @cd_pes)
			insert into 
				Pessoa_Banco
					(Cd_Pes,Id_Tp_Banco,Id_Item,Cd_Banco,Cd_Agencia,Conta_Corrente,Ativo,dt_ins,Cd_Usuario)
			values
					(@cd_pes,@Id_Tp_Banco,@New_ID_Item,@Cd_Banco,@Cd_Agencia,@Conta_Corrente,1,getdate(),@cd_usuario)
		end
	else
	Begin
		Update Pessoa_Banco 
			set
				Id_Tp_Banco = @Id_Tp_Banco,
				Cd_Banco = @Cd_Banco,
				Cd_Agencia = @Cd_Agencia,
				Conta_Corrente = @Conta_Corrente,
				Cd_Usuario = @cd_usuario
			where 
				ID_Item=@ID_Item and cd_pes = @cd_pes
	End
	
commit Transaction












GO
