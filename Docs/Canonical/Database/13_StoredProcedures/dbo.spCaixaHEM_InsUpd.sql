SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE        procedure [dbo].[spCaixaHEM_InsUpd]

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
			Num_Proc_HEM, Cd_Tp_Tx, DC_HEM
		FROM
			Caixa_Hou_Exp_Mar

		WHERE
			Num_Proc_HEM=@Processo
		AND
			Cd_Tp_Tx=@Taxa
		AND
			DC_HEM=@DC
		)


	BEGIN
		UPDATE
			Caixa_Hou_Exp_Mar
		SET
			Num_Lcto = @Lcto,
			Vlr_Ref_HEM = @Valor,
			Cd_Tp_Par = @TipoPAR,
			Par_Moeda_HEM = @ParMoeda,
			Vlr_Pgto_Rcto_HEM = @ValorTotal,
			Dt_Pgto_Rcto_HEM = @Data,
			Num_Rcb_HEM = @NumRP,
			Dt_Conv_HEM = @Data
		WHERE
			Num_Proc_HEM=@Processo
		AND
			Cd_Tp_Tx=@Taxa
		AND
			DC_HEM=@DC
	END
	ELSE
	--Adicionado o return 0 pra nao inserir pgto div novos - 07/02/14 - Cadu
		--return 0
		INSERT
			Caixa_Hou_Exp_Mar(
				Num_Proc_HEM,
				Cd_Tp_Tx,
				DC_HEM,
				Num_Lcto,
				Vlr_Ref_HEM,
				Cd_Tp_Par,
				Par_Moeda_HEM,
				Vlr_Pgto_Rcto_HEM,
				Dt_Pgto_Rcto_HEM,
				Num_Rcb_HEM,
				Dt_Conv_HEM
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
