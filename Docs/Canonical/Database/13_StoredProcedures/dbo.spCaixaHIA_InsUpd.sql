SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE       procedure [dbo].[spCaixaHIA_InsUpd]

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
			Num_Proc_HIA, Cd_Tp_Tx, DC_HIA
		FROM
			Caixa_Hou_Imp_Aer

		WHERE
			Num_Proc_HIA=@Processo
		AND
			Cd_Tp_Tx=@Taxa
		AND
			DC_HIA=@DC
		)


	BEGIN
		UPDATE
			Caixa_Hou_Imp_Aer
		SET
			Num_Lcto = @Lcto,
			Vlr_Ref_HIA = @Valor,
			Cd_Tp_Par = @TipoPAR,
			Par_Moeda_HIA = @ParMoeda,
			Vlr_Pgto_Rcto_HIA = @ValorTotal,
			Dt_Pgto_Rcto_HIA = @Data,
			Num_Rcb_HIA = @NumRP,
			Dt_Conv_HIA = @Data
		WHERE
			Num_Proc_HIA=@Processo
		AND
			Cd_Tp_Tx=@Taxa
		AND
			DC_HIA=@DC
	END
	ELSE
	--Adicionado o return 0 pra nao inserir pgto div novos - 07/02/14 - Cadu
		--return 0
		INSERT
			Caixa_Hou_Imp_Aer(
				Num_Proc_HIA,
				Cd_Tp_Tx,
				DC_HIA,
				Num_Lcto,
				Vlr_Ref_HIA,
				Cd_Tp_Par,
				Par_Moeda_HIA,
				Vlr_Pgto_Rcto_HIA,
				Dt_Pgto_Rcto_HIA,
				Num_Rcb_HIA,
				Dt_Conv_HIA
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
