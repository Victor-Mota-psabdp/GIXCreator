SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE         procedure [dbo].[spCaixaMEM_InsUpd]

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
			Num_Proc_MEM, Cd_Tp_Tx, DC_MEM
		FROM
			Caixa_Mas_Exp_Mar

		WHERE
			Num_Proc_MEM=@Processo
		AND
			Cd_Tp_Tx=@Taxa
		AND
			DC_MEM=@DC
		)


	BEGIN
		UPDATE
			Caixa_Mas_Exp_Mar
		SET
			Num_Lcto = @Lcto,
			Vlr_Ref_MEM = @Valor,
			Cd_Tp_Par = @TipoPAR,
			Par_Moeda_MEM = @ParMoeda,
			Vlr_Pgto_Rcto_MEM = @ValorTotal,
			Dt_Pgto_Rcto_MEM = @Data,
			Num_Rcb_MEM = @NumRP,
			Dt_Conv_MEM = @Data
		WHERE
			Num_Proc_MEM=@Processo
		AND
			Cd_Tp_Tx=@Taxa
		AND
			DC_MEM=@DC
	END
	ELSE
	--Adicionado o return 0 pra nao inserir pgto div novos - 07/02/14 - Cadu
		--return 0
		INSERT
			Caixa_Mas_Exp_Mar(
				Num_Proc_MEM,
				Cd_Tp_Tx,
				DC_MEM,
				Num_Lcto,
				Vlr_Ref_MEM,
				Cd_Tp_Par,
				Par_Moeda_MEM,
				Vlr_Pgto_Rcto_MEM,
				Dt_Pgto_Rcto_MEM,
				Num_Rcb_MEM,
				Dt_Conv_MEM
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
