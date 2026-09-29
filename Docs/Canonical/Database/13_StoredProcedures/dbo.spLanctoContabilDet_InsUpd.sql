SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE procedure [dbo].[spLanctoContabilDet_InsUpd]

	@NumLanc	varchar(15),
	@CdCtb		varchar(15),
	@CC			varchar(20),
	@DC			char(1),
	@Valor		float,
	@Hist		varchar(3),
	@Compl		varchar(2000),
	@NF			varchar(20),
	@Emissao	datetime,
	@Valor_IVA	float,
	@Porc_IVA	float,
	@Retencao	float

AS

Begin Transaction

	IF  exists(	SELECT * FROM Lancto_Contabil_Det WHERE	Num_Lcto=@NumLanc AND Cd_Cta_Ctb=@CdCtb	AND	Cd_Centro_Custo=@CC	AND	DC_Item = @DC AND Num_NF = @NF)
		BEGIN
			UPDATE
				Lancto_Contabil_Det
			SET
				DC_Item		= @DC,
				Vlr_Item	= @Valor,
				Cd_Hist_Pdr = @Hist,
				Compl_Hist	= @Compl,
				Num_NF		= @NF,
				Dt_Emissao	= @Emissao,
				Porcentagem_IVA = @Porc_IVA, 
				Vlr_IVA		= @Valor_IVA, 
				Retencao	= @Retencao
			WHERE
				Num_Lcto=@NumLanc AND Cd_Cta_Ctb=@CdCtb AND	Cd_Centro_Custo=@CC	AND DC_Item = @DC AND Num_NF = @NF
		END
	ELSE
		INSERT
			Lancto_Contabil_Det(
				Num_Lcto,
				Cd_CTA_CTB,
				Cd_Centro_Custo,
				DC_Item,
				Vlr_Item,
				Cd_Hist_Pdr,
				Compl_Hist,
				Num_NF,
				Dt_Emissao,
				Porcentagem_IVA,
				Vlr_IVA,
				Retencao
				)
		Values
			(
				@NumLanc,
				@CdCtb,
				@CC,
				@DC,
				@Valor,
				@Hist,
				@Compl,
				@NF,
				@Emissao,
				@Porc_IVA,
				@Valor_IVA,
				@Retencao
			)
	

Commit Transaction











GO
