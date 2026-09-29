SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE Procedure [dbo].[spATLDN_ParidadeAutomatica_InsUpd] 

	@Cd_tp_Moeda	Varchar(3),
	@Dt_Par	Varchar(10)

AS
Begin Transaction
if exists(Select cd_tp_moeda from tipo_moeda where cd_tp_moeda = @cd_tp_moeda)
	BEGIN
		--Apagar registros atuais
		--Delete paridade where cd_tp_moeda=@cd_tp_moeda and Dt_par=@data_paridade and cd_tp_par <> 'OFC'
		Delete paridade where cd_tp_moeda=@cd_tp_moeda and Dt_par=@Dt_Par and cd_tp_par not in ('OFC','XXX')

		--Inserir novas paridades
		Insert paridade
		select Dt_Par,cd_tp_moeda,TP.cd_tp_par,cast((par_Moeda*parametro) as Decimal(10,4)) from paridade PAR
			Join Tipo_Paridade TP on TP.cd_tp_par <> PAR.cd_tp_par
		Where
			dt_par=@Dt_Par and cd_tp_moeda=@cd_tp_moeda and PAR.cd_tp_par='OFC'
			--and tp.cd_tp_par not in ('AFR','PHL')
			and tp.cd_tp_par not in ('AFR','PHL','XXX')

		IF @@Error <> 0
			BEGIN
				ROLLBACK TRANSACTION
				RETURN -1

		END
	END

Commit Transaction 




GO
