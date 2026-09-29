SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--sp_help Boleto_Instrucao_Cobranca
CREATE PROCEDURE [dbo].[spATL_Boleto_Instrucao_Cobranca_InsUpd]
(
	@Cd_Instrucao	varchar(2),
	@Nome_Instrucao varchar(100),
	@Cd_Banco		varchar(3),
	@Ativo			BIT,
	@Cd_Usuario		VARCHAR(6),
	@Dt_Ins			DATETIME
)

AS

Begin Transaction

	If  exists (select Cd_Instrucao from Boleto_Instrucao_Cobranca where Cd_Instrucao=@Cd_Instrucao)
		Begin
			Update
				Boleto_Instrucao_Cobranca
			Set
				Nome_Instrucao=@Nome_Instrucao,
				Cd_Banco = @Cd_Banco,
				Ativo = @Ativo,
				Cd_Usuario=@Cd_Usuario,
				Dt_Ins	 = @Dt_Ins				
			Where
				Cd_Instrucao=@Cd_Instrucao
		End
	Else
		Begin
			Insert Boleto_Instrucao_Cobranca
				(Cd_Instrucao,Nome_Instrucao,Cd_Banco,Ativo,Cd_Usuario,Dt_Ins)
			Values
				(@Cd_Instrucao,@Nome_Instrucao,@Cd_Banco,@Ativo,@Cd_Usuario,GETDATE())
		End

Commit Transaction

GO
