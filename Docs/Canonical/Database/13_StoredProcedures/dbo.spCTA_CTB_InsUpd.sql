SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE    procedure [dbo].[spCTA_CTB_InsUpd]

	@Codigo varchar(13),
	@CodReduzido varchar(5),
	@Nome varchar(60),
	@NomeRed varchar(30),
	@Lanc char(1),
	@CCusto char(1),
	@Ativo char(1)

AS

Begin Transaction

	If  exists (select Cd_CTA_CTB from CTA_CTB where Cd_CTA_CTB=@Codigo)
	Begin
		Update
			CTA_CTB
		Set
			Cd_CTA_CTB=@Codigo,
			Cd_Cta_Ctb_Red = @CodReduzido,
			Nome_CTA_CTB=@Nome,
			Nome_CTA_CTB_Red=@NomeRed,
			Ck_Lanc=@Lanc,
			Ck_CC=@CCusto,
			Ck_Ativo=@Ativo
		Where
			Cd_CTA_CTB=@Codigo
	End
	Else
		Insert
			CTA_CTB(
				Cd_CTA_CTB,
				Cd_Cta_Ctb_Red,
				Nome_CTA_CTB,
				Nome_CTA_CTB_Red,
				Ck_Lanc,
				Ck_CC,
				Ck_Ativo,
				Ref_Ctb,
				Ck_CM,
				Ck_Red,
				Ck_Conv,
				Ck_Conc,
				Ck_Plano_06
				)
		Values
			(
				@Codigo,
				@CodReduzido,
				@Nome,
				@NomeRed,
				@Lanc,
				@CCusto,
				@Ativo,
				'GRL','N','N','N','N','N'

			)
Commit Transaction





GO
