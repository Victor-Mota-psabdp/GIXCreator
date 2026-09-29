SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--SP_HELP Tipo_Taxa
CREATE PROCEDURE [dbo].[spATL_Tipo_Taxa_InsUpd]
(
	@Cd_Tp_Tx			varchar(3),
	@Nome_Tp_Tx			varchar(50),
	@Nome_Tp_Tx_Ing		varchar(50),
	@CPMF_Tx			char(1),
	@Rateio_Tx			char(1),
	@Pft_Aer			char(1),
	@Desat_Tx			char(1),
	@Cd_Tp_Tx_Ofc		varchar(3),
	@ND_Tx				char(1),
	@NF					char(1),
	@Tipo_DC			char(1),
	@Cd_cta_ctb_atv		varchar	(13),
	@Cd_cta_ctb_pas		varchar	(13),
	@Rentabilidade		char(1),
	@cd_ax_resultado	varchar(5),
	@cd_ax_repasse		varchar(5),
	@Repasse_TX			char(1),
	@Cd_Usuario			varchar(6),
	@Tipo_Prod_Code		char(1),
	@IRRF_Tx			char(1)
)	
AS

Begin Transaction

	IF @Cd_Tp_Tx_Ofc = '' set @Cd_Tp_Tx_Ofc=null
	Declare @Tp_Oper_Tx char(1)
	Declare @LOG_Desativa char(1)

	If  exists (select cd_tp_tx from tipo_taxa where cd_tp_tx = @Cd_Tp_Tx)
		Begin
			set @LOG_Desativa = (select Desat_Tx from tipo_taxa where cd_tp_tx = @Cd_Tp_Tx)
			print @LOG_Desativa
			print @Desat_Tx
			Set @Tp_Oper_Tx = 'A'
			If @LOG_Desativa = 'N' and @Desat_Tx = 'S'
				Begin
					Set @Tp_Oper_Tx = 'D'
				End
			
			Update
				tipo_taxa
			Set
				Cd_Tp_Tx = @Cd_Tp_Tx,
				Nome_Tp_Tx = @Nome_Tp_Tx,
				Nome_tp_tx_Ing = @Nome_Tp_Tx_Ing,
				--Ref_Ctb_tx = @Cd_Tp_Tx,
				CPMF_Tx = @CPMF_Tx,
				Rateio_Tx = @Rateio_Tx,
				Pft_Aer = @Pft_Aer,
				Desat_Tx = @Desat_Tx,
				Cd_Tp_Tx_Ofc = @Cd_Tp_Tx_Ofc,
				ND_tx = @ND_Tx,
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
				Cd_Tp_Tx = @Cd_Tp_Tx
			
		End
	Else
		Begin
			Insert
			Tipo_taxa
			(
				Cd_Tp_Tx,Nome_Tp_Tx,Nome_tp_tx_Ing,Ref_Ctb_Tx,CPMF_Tx,Rateio_Tx,Pft_Aer,Desat_Tx,Cd_Tp_Tx_Ofc,ND_tx,
				IRRF_Tx,MEA_Tx,MEM_Tx,MIA_Tx,MIM_Tx,HEA_Tx,HEM_Tx,HIA_Tx,HIM_Tx,Pft_Mar,NF,Tipo_DC,Cd_cta_ctb_atv,Cd_cta_ctb_pas,	
				Rentabilidade,cd_ax_Resultado,cd_ax_Repasse,Repasse_TX,Tipo_Prod_Code				
			)
			Values
			(
				@Cd_Tp_Tx,@Nome_Tp_Tx,@Nome_Tp_Tx_Ing,'',@CPMF_Tx,@Rateio_Tx,@Pft_Aer,@Desat_Tx,@Cd_Tp_Tx_Ofc,@ND_Tx,
				@IRRF_Tx,'N','N','N','N','N','N','N','N','N',@NF,@Tipo_DC,@Cd_cta_ctb_atv,@Cd_cta_ctb_pas,
				@Rentabilidade,@cd_ax_resultado,@cd_ax_repasse,@Repasse_TX,@Tipo_Prod_Code
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
				@Cd_Tp_Tx,		
				@Nome_Tp_Tx,		
				@Nome_Tp_Tx_Ing,
				'',	
				@CPMF_Tx,		
				@Rateio_Tx,		
				@Pft_Aer,		
				@Desat_Tx,		
				@Cd_Tp_Tx_Ofc,	
				@ND_Tx,
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
