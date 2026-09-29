SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[spLanctoContabil_InsUpd]

	@Num_Lcto	varchar(15),
	@Cd_Cta_Ctb	varchar(15),
	@DC			char(1),
	@Dt_Lcto	datetime,
	@Forma_Pgto_Rcto varchar(15),
	@Num_Doc	varchar(15),
--	@Num_DA		varchar(15),
	@Vlr_Doc	float,
	@Cred_Dev	varchar(30),
	@Dt_Vcto	datetime,
	@NewLcto	VarChar(15) OUTPUT

AS

Begin Transaction

	declare @cd_pes varchar(10)
	Set @cd_pes= (select top 1 Cd_Pes from pessoa where apelido=@Cred_Dev)

	if @Num_Lcto is null

		BEGIN

			Declare @Int as int
		
			Set @NewLcto='CB'+CAST(year(getdate()) AS Varchar(4))+right('0'+cast(month(getdate()) as VarChar),2)
			Set @Int=(Select isnull(max(right(Num_Lcto,4)),0) from Lancto_Contabil where left(Num_Lcto,8)=@NewLcto)			
			Set @Int=@Int+1
			Set @NewLcto=@NewLcto+right('000'+Cast(@Int as VarChar),4)
		
			Insert into	Lancto_Contabil(
				Num_Lcto,
				Cd_Cta_Ctb,
				DC,
				Dt_Lcto,
				Forma_Pgto_Rcto,
				Num_Doc,
--				Num_DA,
				Vlr_Doc,
				Cd_Pes,
				Dt_Vcto
				)
			Values
				(
				@NewLcto,
				@Cd_Cta_Ctb,
				@DC,
				@Dt_Lcto,
				@Forma_Pgto_Rcto,
				@Num_Doc,
--				@Num_DA,
				@Vlr_Doc,
				@Cd_Pes,
				@Dt_Vcto
				)
		END
	ELSE
		BEGIN
			UPDATE
				Lancto_Contabil
			Set
				Cd_Cta_Ctb	= @Cd_Cta_Ctb,
				DC			= @DC,
				Dt_Lcto		= @Dt_Lcto,
				Forma_Pgto_Rcto = @Forma_Pgto_Rcto,
				Num_Doc		= @Num_Doc,
--				Num_DA		= @Num_DA,
				Vlr_Doc		= @Vlr_Doc,
				Cd_Pes		= @Cd_Pes,
				Dt_Vcto		= @Dt_Vcto
			Where
				Num_Lcto = @Num_Lcto
		END

		IF @@Error <> 0
			BEGIN
				ROLLBACK TRANSACTION
				RETURN -1
			END


		Select @NewLcto

Commit Transaction
GO
