SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE          procedure [dbo].[spCaixaMIM_InsUpd]

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
			Num_Proc_MIM, Cd_Tp_Tx, DC_MIM
		FROM
			Caixa_Mas_Imp_Mar

		WHERE
			Num_Proc_MIM=@Processo
		AND
			Cd_Tp_Tx=@Taxa
		AND
			DC_MIM=@DC
		)


	BEGIN
		UPDATE
			Caixa_Mas_Imp_Mar
		SET
			Num_Lcto = @Lcto,
			Vlr_Ref_MIM = @Valor,
			Cd_Tp_Par = @TipoPAR,
			Par_Moeda_MIM = @ParMoeda,
			Vlr_Pgto_Rcto_MIM = @ValorTotal,
			Dt_Pgto_Rcto_MIM = @Data,
			Num_Rcb_MIM = @NumRP,
			Dt_Conv_MIM = @Data
		WHERE
			Num_Proc_MIM=@Processo
		AND
			Cd_Tp_Tx=@Taxa
		AND
			DC_MIM=@DC
	END
	ELSE
	--Adicionado o return 0 pra nao inserir pgto div novos - 07/02/14 - Cadu
		--return 0
		INSERT
			Caixa_Mas_Imp_Mar(
				Num_Proc_MIM,
				Cd_Tp_Tx,
				DC_MIM,
				Num_Lcto,
				Vlr_Ref_MIM,
				Cd_Tp_Par,
				Par_Moeda_MIM,
				Vlr_Pgto_Rcto_MIM,
				Dt_Pgto_Rcto_MIM,
				Num_Rcb_MIM,
				Dt_Conv_MIM
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
