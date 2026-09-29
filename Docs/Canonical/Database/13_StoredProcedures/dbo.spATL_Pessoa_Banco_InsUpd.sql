SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--sp_help Pessoa_Banco
Create procedure [dbo].[spATL_Pessoa_Banco_InsUpd]
(
	@Id_Pes_Banco		Int,
	@cd_pes 			varchar(10),
	@ID_Item 			int,
	@Id_Tp_Banco		Int,
	@Cd_Banco			varchar(50),
	@Cd_Agencia			varchar(50),
	@Conta_Corrente		varchar(50),
	@Cd_Usuario			varchar(10),
	@Dt_Ins				datetime,
	@Ativo				bit
)
as


Begin Transaction

if not exists(Select id_pes_banco from Pessoa_Banco where ID_ITEM=@ID_Item and cd_pes = @cd_pes)
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
		Update 
			Pessoa_Banco 
		set
			Id_Tp_Banco = @Id_Tp_Banco,
			Cd_Banco = @Cd_Banco,
			Cd_Agencia = @Cd_Agencia,
			Conta_Corrente = @Conta_Corrente,
			Cd_Usuario = @cd_usuario,
			Ativo = @Ativo
		where 
			ID_Item=@ID_Item and cd_pes = @cd_pes
	End

Commit Transaction
						
						


GO
