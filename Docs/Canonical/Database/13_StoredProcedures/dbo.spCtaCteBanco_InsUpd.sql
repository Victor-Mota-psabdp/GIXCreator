SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO





Create  procedure [dbo].[spCtaCteBanco_InsUpd]

	@Conta		varchar(20),
	@Banco		varchar(3),
	@Agencia	varchar(5),
	@Titular	varchar(50),
	@CContabil	varchar(13),
	@OBS		varchar(2000) 

AS



Begin Transaction

	If  exists (select Num_Cta_Cte from CTA_CTE where Num_Cta_Cte=@Conta)
	Begin
		Update
			CTA_CTE
		Set
			Cd_Banco = @Banco,
			Cd_Agencia = @Agencia,
			Titular =@Titular,
			Cd_Cta_Ctb=@CContabil,
			Obs_Cta_Cte=@OBS
		Where
			Num_Cta_Cte = @Conta
	End
	Else
		Insert
		CTA_CTE(
			Num_Cta_Cte,
			Cd_Banco,
			Cd_Agencia,
			Titular,
			Cd_Cta_Ctb,
			Obs_Cta_Cte
			)
		Values
			(
			@Conta,
			@Banco,
			@Agencia,
			@Titular,
			@CContabil,
			@OBS
			)
	

Commit Transaction







GO
