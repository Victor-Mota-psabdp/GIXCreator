SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--sp_help Cta_Ctb
CREATE PROCEDURE [dbo].[spATL_Cta_Ctb_InsUpd]
(	
	@Cd_Cta_Ctb varchar(13),
	@Cd_Cta_Ctb_Red varchar(5),
	@Nome_Cta_Ctb varchar(60),
	@Nome_Cta_Ctb_Red varchar(30),
	@Ck_Lanc char(1),
	@Ck_CC char(1),
	@Ck_Ativo char(1)
)

AS

Begin Transaction

	If  exists (select Cd_Cta_Ctb from Cta_Ctb where Cd_Cta_Ctb=@Cd_Cta_Ctb)
		Begin
			Update
				Cta_Ctb
			Set
				Cd_Cta_Ctb=@Cd_Cta_Ctb,
				Cd_Cta_Ctb_Red=@Cd_Cta_Ctb_Red,
				Nome_Cta_Ctb=@Nome_Cta_Ctb,
				Nome_Cta_Ctb_Red=@Nome_Cta_Ctb_Red,
				--Ref_Ctb=@Ref_Ctb,
				Ck_Lanc=@Ck_Lanc,
				--Ck_CM=@Ck_CM,
				--Ck_Red=@Ck_Red,
				Ck_CC=@Ck_CC,
				--Ck_Conv=@Ck_Conv,
				--Ck_Conc=@Ck_Conc,
				Ck_Ativo=@Ck_Ativo
				--Ck_Plano_06=@Ck_Plano_06,
				--cd_FluxodeCaixa=@cd_FluxodeCaixa
			Where
				Cd_Cta_Ctb=@Cd_Cta_Ctb
		End
	Else
		Insert
			CTA_CTB(Cd_CTA_CTB,Cd_Cta_Ctb_Red,Nome_CTA_CTB,Nome_CTA_CTB_Red,Ck_Lanc,Ck_CC,Ck_Ativo,
				Ref_Ctb,Ck_CM,Ck_Red,Ck_Conv,Ck_Conc,Ck_Plano_06)
		Values
			(
				@Cd_Cta_Ctb,@Cd_Cta_Ctb_Red,@Nome_Cta_Ctb,@Nome_Cta_Ctb_Red,@Ck_Lanc,@Ck_CC,@Ck_Ativo,
				'GRL','N','N','N','N','N')
	

Commit Transaction

GO
