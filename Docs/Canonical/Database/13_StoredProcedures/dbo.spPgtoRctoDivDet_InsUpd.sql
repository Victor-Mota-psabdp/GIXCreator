SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE      procedure [dbo].[spPgtoRctoDivDet_InsUpd]

	@NumLanc	varchar(12),
	@CdCtb		varchar(13),
	@CC		varchar(20),
	@DC		char(1),
	@Valor		decimal(10,2),
	@Hist		varchar(3),
	@Compl		varchar(2000),
	@NF		varchar(20),
	@Emissao	varchar(10),
	@Valor_IVA	float,
	@Porc_IVA	float,
	@Retencao	float

AS

Begin Transaction

	IF  exists(
		SELECT
			Num_Lcto_Div, Cd_Cta_Ctb, Cd_Centro_Custo, DC_Item
		FROM
			Pgto_Rcto_Div_Det

		WHERE
			Num_Lcto_Div=@NumLanc
		AND
			Cd_Cta_Ctb=@CdCtb
		AND
			Cd_Centro_Custo=@CC
		AND
			DC_Item = @DC
		AND
			Num_NF = @NF
	)


	BEGIN
		UPDATE
			Pgto_Rcto_Div_Det
		SET
			DC_Item = @DC,
			Vlr_Item = @Valor,
			Cd_Hist_Pdr = @Hist,
			Compl_Hist = @Compl,
			Num_NF = @NF,
			Dt_Emissao = @Emissao
		WHERE
			Num_Lcto_Div=@NumLanc
		AND
			Cd_Cta_Ctb=@CdCtb
		AND
			Cd_Centro_Custo=@CC
		AND 
			DC_Item = @DC
		AND
			Num_NF = @NF
	END
	ELSE
	--Adicionado o return 0 pra nao inserir pgto div novos - 07/02/14 - Cadu
		return 0
	--	INSERT
	--		Pgto_Rcto_Div_Det(
	--			Num_Lcto_Div,
	--			Cd_CTA_CTB,
	--			Cd_Centro_Custo,
	--			DC_Item,
	--			Vlr_Item,
	--			Cd_Hist_Pdr,
	--			Compl_Hist,
	--			Num_NF,
	--			Dt_Emissao
	--			)
	--	Values
	--		(
	--			@NumLanc,
	--			@CdCtb,
	--			@CC,
	--			@DC,
	--			@Valor,
	--			@Hist,
	--			@Compl,
	--			@NF,
	--			@Emissao
	--		)
	

Commit Transaction









GO
