SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

Create Procedure spInsCtaCtb_InsUpd

				@Cd_Cta_Ctb			Varchar(13),
				@Cd_Cta_Ctb_Red		Varchar(5),
				@Nome_Cta_Ctb		Varchar(60),
				@Nome_Cta_Ctb_Red	Varchar(30),
				@Ref_Ctb			Varchar(3),
				@Ck_Lanc			char(1),
				@Ck_CM				char(1),
				@Ck_Red				char(1),
				@Ck_CC				char(1),
				@Ck_Conv			char(1),
				@Ck_Conc			char(1),
				@Ck_Ativo			char(1),
				@Ck_Plano_06		char(1)
AS
Begin
	Begin Transaction
		if not exists(select * from cta_ctb where cd_cta_ctb=@cd_cta_ctb)
			Begin
				INSERT INTO
					CTA_CTB
						(
							Cd_Cta_Ctb,
							Cd_Cta_Ctb_Red,
							Nome_Cta_Ctb,
							Nome_Cta_Ctb_Red,
							Ref_Ctb,
							Ck_Lanc,
							Ck_CM,
							Ck_Red,
							Ck_CC,
							Ck_Conv,
							Ck_Conc,
							Ck_Ativo,
							Ck_Plano_06
							)
					Values
						(
							@Cd_Cta_Ctb,
							@Cd_Cta_Ctb_Red,
							@Nome_Cta_Ctb,
							@Nome_Cta_Ctb_Red,
							@Ref_Ctb,
							@Ck_Lanc,
							@Ck_CM,
							@Ck_Red,
							@Ck_CC,
							@Ck_Conv,
							@Ck_Conc,
							@Ck_Ativo,
							@Ck_Plano_06
							)

		end
	else
			BEGIN
					UPDATE
						CTA_cTB
					SET
						Cd_Cta_Ctb_ReD=@Cd_Cta_Ctb_Red,
						Nome_Cta_Ctb=@Nome_Cta_Ctb,
						Nome_Cta_Ctb_Red=@Nome_Cta_Ctb_Red,
						Ref_Ctb=@Ref_Ctb,
						Ck_Lanc=@Ck_Lanc,
						Ck_CM=@Ck_CM,
						Ck_Red=@Ck_CM,
						Ck_CC=@Ck_CC,
						Ck_Conv=@Ck_Conv,
						Ck_Conc=@Ck_Conc,
						Ck_Ativo=@Ck_Ativo,
						Ck_Plano_06=@Ck_Plano_06
					WHERE
						Cd_Cta_Ctb = @cd_Cta_Ctb
			END

		if @@error <> 0
			Begin
				rollback transaction
				return -1
			End
	Commit transaction
END
GO
