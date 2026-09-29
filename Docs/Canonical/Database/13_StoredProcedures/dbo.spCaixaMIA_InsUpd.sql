SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE          procedure [dbo].[spCaixaMIA_InsUpd]

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
			Num_Proc_MIA, Cd_Tp_Tx, DC_MIA
		FROM
			Caixa_Mas_Imp_Aer

		WHERE
			Num_Proc_MIA=@Processo
		AND
			Cd_Tp_Tx=@Taxa
		AND
			DC_MIA=@DC
		)


	BEGIN
		UPDATE
			Caixa_Mas_Imp_Aer
		SET
			Num_Lcto = @Lcto,
			Vlr_Ref_MIA = @Valor,
			Cd_Tp_Par = @TipoPAR,
			Par_Moeda_MIA = @ParMoeda,
			Vlr_Pgto_Rcto_MIA = @ValorTotal,
			Dt_Pgto_Rcto_MIA = @Data,
			Num_Rcb_MIA = @NumRP,
			Dt_Conv_MIA = @Data
		WHERE
			Num_Proc_MIA=@Processo
		AND
			Cd_Tp_Tx=@Taxa
		AND
			DC_MIA=@DC
	END
	ELSE
	--Adicionado o return 0 pra nao inserir pgto div novos - 07/02/14 - Cadu
		--return 0
		INSERT
			Caixa_Mas_Imp_Aer(
				Num_Proc_MIA,
				Cd_Tp_Tx,
				DC_MIA,
				Num_Lcto,
				Vlr_Ref_MIA,
				Cd_Tp_Par,
				Par_Moeda_MIA,
				Vlr_Pgto_Rcto_MIA,
				Dt_Pgto_Rcto_MIA,
				Num_Rcb_MIA,
				Dt_Conv_MIA
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
