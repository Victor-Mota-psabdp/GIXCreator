SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--incluido vazio no ref_ctb qdo cria taxa nova - 27-01-2014
--incluido salvar o Tipo_Prod_Code  - 10/03/2015 - CADU
--[spTipoTaxa_InsUpd] 'XDT','Demurrage - CHB','Demurrage - CHB','N','H','N','N','XDT','T','N','S','B',NULL,NULL,NULL,'S','admin'
CREATE     procedure [dbo].[spTipoTaxa_InsUpd]
	@Codigo		varchar(3),
	@Nome		varchar(50),
	@NomeIng	varchar(50),
	@IVA		char(1),
	@Rateio		char(1),
	@Profit		char(1),
	@Desativa	char(1),
	@Oficial	varchar(3),
	@TipoTaxa	char(1),
	@NF			char(1),
	@Tipo_DC	char(1),
	@Cd_cta_ctb_atv	varchar	(13),
	@Cd_cta_ctb_pas	varchar	(13),
	@Rentabilidade char(1),
	@cd_ax_resultado varchar(5),
	@cd_ax_repasse varchar(5),
	@Repasse_TX	char(1),
	@Cd_Usuario varchar(6),
	@Tipo_Prod_Code char(1),
	@IRRF_Tx char(1)
	
AS

Begin Transaction

	IF @Oficial = '' set @Oficial=null
	Declare @Tp_Oper_Tx char(1)
	Declare @LOG_Desativa char(1)

	If  exists (select cd_tp_tx from tipo_taxa where cd_tp_tx = @codigo)
		Begin
			set @LOG_Desativa = (select Desat_Tx from tipo_taxa where cd_tp_tx = @codigo)
			print @LOG_Desativa
			print @Desativa
			Set @Tp_Oper_Tx = 'A'
			If @LOG_Desativa = 'N' and @Desativa = 'S'
				Begin
					Set @Tp_Oper_Tx = 'D'
				End
			
			Update
				tipo_taxa
			Set
				Cd_Tp_Tx = @Codigo,
				Nome_Tp_Tx = @Nome,
				Nome_tp_tx_Ing = @NomeIng,
				--Ref_Ctb_tx = @Codigo,
				CPMF_Tx = @IVA,
				Rateio_Tx = @Rateio,
				Pft_Aer = @Profit,
				Desat_Tx = @Desativa,
				Cd_Tp_Tx_Ofc = @Oficial,
				ND_tx = @TipoTaxa,
				NF = @NF,
				Tipo_DC = @Tipo_DC,
				Cd_cta_ctb_atv = @Cd_cta_ctb_atv,
				Cd_cta_ctb_pas = @Cd_cta_ctb_pas,
				Rentabilidade = @Rentabilidade,
				cd_ax_Resultado = @cd_ax_Resultado,
				cd_ax_Repasse = @cd_ax_Repasse,
				Repasse_TX = @Repasse_TX,
				Tipo_Prod_Code = @Tipo_Prod_Code,
				IRRF_Tx = @IRRF_Tx				
			Where
				Cd_Tp_Tx = @Codigo
			
		End
	Else
		Begin
			Insert
			Tipo_taxa
			(
				Cd_Tp_Tx,	
				Nome_Tp_Tx,		
				Nome_tp_tx_Ing,
				Ref_Ctb_Tx,
				CPMF_Tx,
				Rateio_Tx,
				Pft_Aer,
				Desat_Tx,
				Cd_Tp_Tx_Ofc,
				ND_tx,
				IRRF_Tx,
				MEA_Tx,
				MEM_Tx,
				MIA_Tx,
				MIM_Tx,
				HEA_Tx,
				HEM_Tx,
				HIA_Tx,
				HIM_Tx,
				Pft_Mar,
				NF,
				Tipo_DC,
				Cd_cta_ctb_atv,
				Cd_cta_ctb_pas,	
				Rentabilidade,
				cd_ax_Resultado,
				cd_ax_Repasse,
				Repasse_TX,
				Tipo_Prod_Code
				
			)
			Values
			(
				@Codigo,		
				@Nome,		
				@NomeIng,
				'',	
				@IVA,		
				@Rateio,		
				@Profit,		
				@Desativa,		
				@Oficial,	
				@TipoTaxa,
				@IRRF_Tx,
				'N',
				'N',
				'N',
				'N',
				'N',
				'N',
				'N',
				'N',
				'N',
				@NF,
				@Tipo_DC,
				@Cd_cta_ctb_atv,
				@Cd_cta_ctb_pas,
				@Rentabilidade,
				@cd_ax_resultado,
				@cd_ax_repasse,
				@Repasse_TX,
				@Tipo_Prod_Code
			)
			Set @Tp_Oper_Tx = 'I'
		End
--LOG
			Insert
			LOG_Tipo_taxa
			(
				Dt_Ins_Tx,
				Cd_Usuario,
				Tp_Oper_Tx,
				Cd_Tp_Tx,	
				Nome_Tp_Tx,		
				Nome_tp_tx_Ing,
				Ref_Ctb_Tx,
				CPMF_Tx,
				Rateio_Tx,
				Pft_Aer,
				Desat_Tx,
				Cd_Tp_Tx_Ofc,
				ND_tx,
				IRRF_Tx,
				MEA_Tx,
				MEM_Tx,
				MIA_Tx,
				MIM_Tx,
				HEA_Tx,
				HEM_Tx,
				HIA_Tx,
				HIM_Tx,
				Pft_Mar,
				NF,
				Tipo_DC,
				Cd_cta_ctb_atv,
				Cd_cta_ctb_pas,	
				Rentabilidade,
				cd_ax_resultado,
				cd_ax_repasse,
				Isent_CPMF,
				Repasse_TX,
				Tipo_Prod_Code
				
			)
			Values
			(
				getdate(),
				@Cd_Usuario,
				@Tp_Oper_Tx,
				@Codigo,		
				@Nome,		
				@NomeIng,
				'',	
				@IVA,		
				@Rateio,		
				@Profit,		
				@Desativa,		
				@Oficial,	
				@TipoTaxa,
				@IRRF_Tx,
				'N',
				'N',
				'N',
				'N',
				'N',
				'N',
				'N',
				'N',
				'N',
				@NF,
				@Tipo_DC,
				@Cd_cta_ctb_atv,
				@Cd_cta_ctb_pas,
				@Rentabilidade,
				@cd_ax_resultado,
				@cd_ax_repasse,
				'N',
				@Repasse_TX,
				@Tipo_Prod_Code
				
			)
	IF @@ERROR <> 0
		BEGIN
			RETURN -1
		END
Commit Transaction



GO
