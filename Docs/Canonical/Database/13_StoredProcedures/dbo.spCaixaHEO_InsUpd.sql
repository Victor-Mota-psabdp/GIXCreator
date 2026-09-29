SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE        procedure [dbo].[spCaixaHEO_InsUpd]

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
			Num_Proc_HEO, Cd_Tp_Tx, DC_HEO
		FROM
			Caixa_Hou_Exp_Out

		WHERE
			Num_Proc_HEO=@Processo
		AND
			Cd_Tp_Tx=@Taxa
		AND
			DC_HEO=@DC
		)


	BEGIN
		UPDATE
			Caixa_Hou_Exp_Out
		SET
			Num_Lcto = @Lcto,
			Vlr_Ref_HEO = @Valor,
			Cd_Tp_Par = @TipoPAR,
			Par_Moeda_HEO = @ParMoeda,
			Vlr_Pgto_Rcto_HEO = @ValorTotal,
			Dt_Pgto_Rcto_HEO = @Data,
			Num_Rcb_HEO = @NumRP,
			Dt_Conv_HEO = @Data
		WHERE
			Num_Proc_HEO=@Processo
		AND
			Cd_Tp_Tx=@Taxa
		AND
			DC_HEO=@DC
	END
	ELSE
	--Adicionado o return 0 pra nao inserir pgto div novos - 07/02/14 - Cadu
		--return 0
		INSERT
			Caixa_Hou_Exp_Out(
				Num_Proc_HEO,
				Cd_Tp_Tx,
				DC_HEO,
				Num_Lcto,
				Vlr_Ref_HEO,
				Cd_Tp_Par,
				Par_Moeda_HEO,
				Vlr_Pgto_Rcto_HEO,
				Dt_Pgto_Rcto_HEO,
				Num_Rcb_HEO,
				Dt_Conv_HEO
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
