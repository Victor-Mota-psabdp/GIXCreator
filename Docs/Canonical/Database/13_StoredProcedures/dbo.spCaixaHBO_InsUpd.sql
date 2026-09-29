SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE  procedure [dbo].[spCaixaHBO_InsUpd]

	@Processo	varchar(16),
	@Taxa		varchar(3),
	@DC		char(1),
	@Lcto		varchar(12),
	@Valor		decimal(10,2),
	@TipoPAR	varchar(3),
	@ParMoeda	decimal(10,6),
	@ValorTotal	decimal(10,2),
	@Data		varchar(10),
	@NumRP		varchar(12)

AS

Begin Transaction

	IF  exists(
		SELECT
			Num_Proc_HBO, Cd_Tp_Tx, DC_HBO
		FROM
			Caixa_Hou_BDP_OUT

		WHERE
			Num_Proc_HBO=@Processo
		AND
			Cd_Tp_Tx=@Taxa
		AND
			DC_HBO=@DC
		)


	BEGIN
		UPDATE
			Caixa_Hou_BDP_OUT
		SET
			Num_Lcto = @Lcto,
			Vlr_Ref_HBO = @Valor,
			Cd_Tp_Par = @TipoPAR,
			Par_Moeda_HBO = @ParMoeda,
			Vlr_Pgto_Rcto_HBO = @ValorTotal,
			Dt_Pgto_Rcto_HBO = @Data,
			Num_Rcb_HBO = @NumRP,
			Dt_Conv_HBO = @Data
		WHERE
			Num_Proc_HBO=@Processo
		AND
			Cd_Tp_Tx=@Taxa
		AND
			DC_HBO=@DC
	END
	ELSE
	--Adicionado o return 0 pra nao inserir pgto div novos - 07/02/14 - Cadu
		--return 0
		INSERT
			Caixa_Hou_BDP_OUT(
				Num_Proc_HBO,
				Cd_Tp_Tx,
				DC_HBO,
				Num_Lcto,
				Vlr_Ref_HBO,
				Cd_Tp_Par,
				Par_Moeda_HBO,
				Vlr_Pgto_Rcto_HBO,
				Dt_Pgto_Rcto_HBO,
				Num_Rcb_HBO,
				Dt_Conv_HBO
				)
		Values
			(
				@Processo,
				@Taxa,
				@DC,
				@Lcto,
				@Valor,
				@TipoPAR,
				@ParMoeda,
				@ValorTotal,
				@Data,
				@NumRP,
				@Data
			)
	

Commit Transaction











GO
