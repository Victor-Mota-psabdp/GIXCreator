SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--sp_help LLP_ARG
CREATE PROCEDURE [dbo].[spATL_LLP_ARG_InsUpd]
(
	@Num_Proc			varchar	(16),
	@Cd_Adua_Saida		varchar	(3),
	@Cd_Adua_Registro	varchar	(3),
	@Forma_Pgto			varchar	(50),
	@Condic_Pgto		varchar	(30),
	@Banco				varchar	(30),
	@Coefic_Exp			float,
	@Reemb_Exp			float,
	@Comissao			float,
	@Royalties			float,
	@Imp_Nat			char	(1),
	@Imp_Temp			char	(1),
	@Consolidacao		datetime,
	@ETA_BuenosAires	datetime,

	@Paridade_Oper		float,
	@Tipo_Dest			varchar	(30),
	@Cd_Pes_Agente_ATA	varchar	(10),
	@Vcto_Invoice		datetime,
	@Consig_CtaCte		varchar	(50)
)

AS


BEGIN TRANSACTION

	If exists(select Num_Proc from LLP_ARG where Num_Proc = @Num_Proc)
		Begin
			Update LLP_ARG
				Set
					Cd_Adua_Saida	=@Cd_Adua_Saida,
					Cd_Adua_Registro=@Cd_Adua_Registro,
					Forma_Pgto		=@Forma_Pgto,
					Condic_Pgto		=@Condic_Pgto,
					Banco			=@Banco,
					Coefic_Exp		=@Coefic_Exp,
					Reemb_Exp		=@Reemb_Exp,
					Comissao		=@Comissao,
					Royalties		=@Royalties,
					Imp_Nat			=@Imp_Nat,
					Imp_Temp		=@Imp_Temp,
					Consolidacao	=@Consolidacao,
					ETA_BuenosAires	=@ETA_BuenosAires,

					Paridade_Oper	=@Paridade_Oper,
					Tipo_Dest		=@Tipo_Dest,
					Cd_Pes_Agente_ATA=@Cd_Pes_Agente_ATA,
					Vcto_Invoice	=@Vcto_Invoice,
					Consig_CtaCte	=@Consig_CtaCte
				Where
					Num_Proc		=@Num_Proc
		End
	Else
		Begin
			Insert Into LLP_ARG
				(
					Num_Proc,Cd_Adua_Saida,Cd_Adua_Registro,Forma_Pgto,Condic_Pgto,Banco,
					Coefic_Exp,Reemb_Exp,Comissao,Royalties,Imp_Nat,Imp_Temp,Consolidacao,
					ETA_BuenosAires,Paridade_Oper,Tipo_Dest,Cd_Pes_Agente_ATA,Vcto_Invoice,Consig_CtaCte
				)
				Values
				(
					@Num_Proc,@Cd_Adua_Saida,@Cd_Adua_Registro,@Forma_Pgto,@Condic_Pgto,@Banco,
					@Coefic_Exp,@Reemb_Exp,@Comissao,@Royalties,@Imp_Nat,@Imp_Temp,@Consolidacao,
					@ETA_BuenosAires,@Paridade_Oper,@Tipo_Dest,@Cd_Pes_Agente_ATA,@Vcto_Invoice,@Consig_CtaCte
				)
			End

	IF @@Error <> 0
		BEGIN
			ROLLBACK TRANSACTION
			RETURN -1
		END

Commit Transaction 



GO
