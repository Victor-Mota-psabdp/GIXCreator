SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO









CREATE        procedure [dbo].[spCaixaHEA_InsUpd]

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
			Num_Proc_HEA, Cd_Tp_Tx, DC_HEA
		FROM
			Caixa_Hou_Exp_Aer

		WHERE
			Num_Proc_HEA=@Processo
		AND
			Cd_Tp_Tx=@Taxa
		AND
			DC_HEA=@DC
		)


	BEGIN
		UPDATE
			Caixa_Hou_Exp_Aer
		SET
			Num_Lcto = @Lcto,
			Vlr_Ref_HEA = @Valor,
			Cd_Tp_Par = @TipoPAR,
			Par_Moeda_HEA = @ParMoeda,
			Vlr_Pgto_Rcto_HEA = @ValorTotal,
			Dt_Pgto_Rcto_HEA = @Data,
			Num_Rcb_HEA = @NumRP,
			Dt_Conv_HEA = @Data
		WHERE
			Num_Proc_HEA=@Processo
		AND
			Cd_Tp_Tx=@Taxa
		AND
			DC_HEA=@DC
	END
	ELSE
		INSERT
			Caixa_Hou_Exp_Aer(
				Num_Proc_HEA,
				Cd_Tp_Tx,
				DC_HEA,
				Num_Lcto,
				Vlr_Ref_HEA,
				Cd_Tp_Par,
				Par_Moeda_HEA,
				Vlr_Pgto_Rcto_HEA,
				Dt_Pgto_Rcto_HEA,
				Num_Rcb_HEA,
				Dt_Conv_HEA
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
