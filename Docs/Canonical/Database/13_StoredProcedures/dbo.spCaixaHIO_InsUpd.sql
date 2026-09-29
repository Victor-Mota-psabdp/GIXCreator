SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE       procedure [dbo].[spCaixaHIO_InsUpd]

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
			Num_Proc_HIO, Cd_Tp_Tx, DC_HIO
		FROM
			Caixa_Hou_Imp_Out

		WHERE
			Num_Proc_HIO=@Processo
		AND
			Cd_Tp_Tx=@Taxa
		AND
			DC_HIO=@DC
		)


	BEGIN
		UPDATE
			Caixa_Hou_Imp_Out
		SET
			Num_Lcto = @Lcto,
			Vlr_Ref_HIO = @Valor,
			Cd_Tp_Par = @TipoPAR,
			Par_Moeda_HIO = @ParMoeda,
			Vlr_Pgto_Rcto_HIO = @ValorTotal,
			Dt_Pgto_Rcto_HIO = @Data,
			Num_Rcb_HIO = @NumRP,
			Dt_Conv_HIO = @Data
		WHERE
			Num_Proc_HIO=@Processo
		AND
			Cd_Tp_Tx=@Taxa
		AND
			DC_HIO=@DC
	END
	ELSE
	--Adicionado o return 0 pra nao inserir pgto div novos - 07/02/14 - Cadu
		--return 0
		INSERT
			Caixa_Hou_Imp_Out(
				Num_Proc_HIO,
				Cd_Tp_Tx,
				DC_HIO,
				Num_Lcto,
				Vlr_Ref_HIO,
				Cd_Tp_Par,
				Par_Moeda_HIO,
				Vlr_Pgto_Rcto_HIO,
				Dt_Pgto_Rcto_HIO,
				Num_Rcb_HIO,
				Dt_Conv_HIO
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
