SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE        procedure [dbo].[spCaixaHIM_InsUpd]

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
			Num_Proc_HIM, Cd_Tp_Tx, DC_HIM
		FROM
			Caixa_Hou_Imp_Mar

		WHERE
			Num_Proc_HIM=@Processo
		AND
			Cd_Tp_Tx=@Taxa
		AND
			DC_HIM=@DC
		)


	BEGIN
		UPDATE
			Caixa_Hou_Imp_Mar
		SET
			Num_Lcto = @Lcto,
			Vlr_Ref_HIM = @Valor,
			Cd_Tp_Par = @TipoPAR,
			Par_Moeda_HIM = @ParMoeda,
			Vlr_Pgto_Rcto_HIM = @ValorTotal,
			Dt_Pgto_Rcto_HIM = @Data,
			Num_Rcb_HIM = @NumRP,
			Dt_Conv_HIM = @Data
		WHERE
			Num_Proc_HIM=@Processo
		AND
			Cd_Tp_Tx=@Taxa
		AND
			DC_HIM=@DC
	END
	ELSE
	--Adicionado o return 0 pra nao inserir pgto div novos - 07/02/14 - Cadu
		--return 0
		INSERT
			Caixa_Hou_Imp_Mar(
				Num_Proc_HIM,
				Cd_Tp_Tx,
				DC_HIM,
				Num_Lcto,
				Vlr_Ref_HIM,
				Cd_Tp_Par,
				Par_Moeda_HIM,
				Vlr_Pgto_Rcto_HIM,
				Dt_Pgto_Rcto_HIM,
				Num_Rcb_HIM,
				Dt_Conv_HIM
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
