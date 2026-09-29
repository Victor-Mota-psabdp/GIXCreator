SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREaTE procedure [dbo].[spATL_NCM_InsUpd] --'1','EMCSR2008100501','01011100'

	@NCM			char(8),
	@Descricao_NCM	varchar(400),
	@Alterado		char(1),
	@Vencimento		datetime,
	@usuario		varchar(100),
	@Excecao		varchar(400)

AS

BEGIN TRANSACTION
	
Declare @Tp_Oper_NCM char(1)
Declare @Id_NCM Int 
Declare @cd_usuario varchar(6)
set @Id_NCM = (select Id_NCM from NCM where ncm = @NCM)
set @cd_usuario = (select cd_usuario from Usuario where Nome_Usuario = @usuario)

	if @Id_NCM is not null
		BEGIN
			UPDATE
				NCM
			SET
				Descricao_NCM = @Descricao_NCM,
				Alterado = @Alterado,
				Vencimento = @Vencimento,
				cd_usuario = @cd_usuario,
				excecao = @Excecao
			WHERE
				Id_NCM = @Id_NCM
				
			Set @Tp_Oper_NCM = 'A'
		END
	ELSE
		BEGIN		
		
			SET @Id_NCM=(select(max(id_ncm))+1 id_ncm from NCM)
			INSERT INTO NCM 
				(Id_NCM,NCM,Descricao_NCM,Alterado,Vencimento,Cd_Usuario, DT_INS,Excecao)				
			VALUES
				(@Id_NCM,@NCM,@Descricao_NCM,@Alterado,@Vencimento,@cd_usuario,GETDATE(),@Excecao)
				
			Set @Tp_Oper_NCM = 'I'
		END

	insert into [LOG_NCM]
		(Dt_Ins_NCM,Cd_Usuario_NCM,Tp_Oper_NCM,Id_NCM,NCM,Descricao_NCM,Alterado,Vencimento,cd_usuario,DT_INS,Excecao)
	Values
		(GETDATE(),@cd_usuario,@Tp_Oper_NCM, @Id_NCM,@NCM,@Descricao_NCM,@Alterado,@Vencimento,@cd_usuario,GETDATE(),@Excecao)
		
IF @@Error <> 0
	BEGIN
		ROLLBACK TRANSACTION
		RETURN -1
	END

COMMIT TRANSACTION
	








GO
