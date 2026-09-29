SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE      procedure [dbo].[spCaixaMEA_InsUpd]

	@Processo	varchar(14),
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
			Num_Proc_MEA, Cd_Tp_Tx, DC_MEA
		FROM
			Caixa_Mas_Exp_Aer

		WHERE
			Num_Proc_MEA=@Processo
		AND
			Cd_Tp_Tx=@Taxa
		AND
			DC_MEA=@DC
		)


	BEGIN
		UPDATE
			Caixa_Mas_Exp_Aer
		SET
			Num_Lcto = @Lcto,
			Vlr_Ref_MEA = @Valor,
			Cd_Tp_Par = @TipoPAR,
			Par_Moeda_MEA = @ParMoeda,
			Vlr_Pgto_Rcto_MEA = @ValorTotal,
			Dt_Pgto_Rcto_MEA = @Data,
			Num_Rcb_MEA = @NumRP,
			Dt_Conv_MEA = @Data
		WHERE
			Num_Proc_MEA=@Processo
		AND
			Cd_Tp_Tx=@Taxa
		AND
			DC_MEA=@DC
	END
	ELSE
	--Adicionado o return 0 pra nao inserir pgto div novos - 07/02/14 - Cadu
		--return 0
		INSERT
			Caixa_Mas_Exp_Aer(
				Num_Proc_MEA,
				Cd_Tp_Tx,
				DC_MEA,
				Num_Lcto,
				Vlr_Ref_MEA,
				Cd_Tp_Par,
				Par_Moeda_MEA,
				Vlr_Pgto_Rcto_MEA,
				Dt_Pgto_Rcto_MEA,
				Num_Rcb_MEA,
				Dt_Conv_MEA
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
