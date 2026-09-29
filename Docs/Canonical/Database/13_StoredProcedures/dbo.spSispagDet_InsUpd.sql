SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE procedure [dbo].[spSispagDet_InsUpd]
	
	@Lotet			varchar(15),
	@cd_banco		varchar(3),
	@cd_agencia		varchar(5),
	@conta			varchar(12),
	@cd_pes			varchar(10),	
	@la				varchar(20),
	@dt_pgto		datetime,
	@valor			decimal(10,2)
	
AS

	Begin Transaction	

	Declare @Lote varchar(5)
	Declare @int as int		

	Set @Int=(Select isnull(max(right(loteseq,5))+1,1) from Sispag_Det where Lote = @Lotet)	
	Set @Lote=right('0000'+Cast(@int as VarChar),5) 	
	
		BEGIN
			INSERT
				Sispag_Det(
					Lote,LoteSeq,segmento,tipoMovimento,Banco,Agencia,Conta,cd_pes,la,
					DT_Pgto,Tipo_Moeda,ValorPgto,ItauNumero,DT_Efetiva,valorEfetivo,FinalidadeDetalhe,NumeroDocumento,
					NumeroInscricao,FinalidadeDoc,FinalidadeTed,Aviso,OCorrencias					
					)
			Values
				(
					@Lotet,@Lote, 'A','000',@cd_banco,@cd_agencia,@conta,@cd_pes,@la,
					@dt_pgto,'REA',@valor,null,null,null,null,null,
					null,null,null,null,null
				)			
		END			

	IF @@Error <> 0
		BEGIN
			ROLLBACK TRANSACTION
			RETURN -1
		END
Commit Transaction










GO
