SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE procedure [dbo].[spSispag_InsUpd]	

	@tipoPgto		varchar(2),
	@formadePgto	varchar(2),
	@num_cta_cte	varchar(7),	
	@lotet			varchar(15) OUTPUT


AS

	Begin Transaction	

	Declare @Lote varchar(15)
	Declare @int as int	

	Set @Int=(Select isnull(max(left(lote,4))+1,1) from Sispag where convert(nchar(10),dt_sispag,103) = convert(nchar(10),getdate(),103))	
	Set @Lote= Replace(convert(nchar(10),getdate(),103),'/','')
	Set @Lote=right('0000'+Cast(@int as VarChar),4)  + left(@lote,4)
	
		BEGIN
			INSERT
				Sispag(
					Lote,cd_banco,TipoOperacao,TipoPagamento,FormaPagamento,LayoutLote,Empresa_Inscricao,Inscricao_Numero,
					Id_Lancamento,Agencia,Conta,cd_pes,LoteFinalidade,HistoricodeCC,Ocorrencias,dt_sispag					
					)
			Values
				(
					@Lote,'341', 'C',@tipoPgto,@formadePgto,'040','2','03706460000128',
					'0000','2000',@num_cta_cte,'10017',null,null,null,getdate()
				)			
		END		
	
		set @lotet = @Lote

	IF @@Error <> 0
		BEGIN
			ROLLBACK TRANSACTION
			RETURN -1
		END
Commit Transaction










GO
