SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE procedure [dbo].[spATL_BR_procEventoNFeRetEventoInfEvento_InsUpd]
(
	@Id				int,
	@tpAmb			int,
	@verAplic		varchar(20),
	@cOrgao			int,	
	@cStat			int,
	@xMotivo		varchar(100),
	@chNFe			varchar(100),
	@tpEvento		varchar(20),
	@xEvento		varchar(100),
	@nSeqEvento		int,
	@dhRegEvento	datetime,
	@nProt			varchar(100)
)
AS

BEGIN
--Exceção(try/CATCH)
--Transação
--sp_help procEventoNFeRetEventoInfEvento
	BEGIN TRY			
		if not exists(select Id from ATL_BR.dbo.procEventoNFeRetEventoInfEvento where Id = @Id)	
			Begin								
				Insert into ATL_BR.dbo.procEventoNFeRetEventoInfEvento
				(
					Id,tpAmb,verAplic,cOrgao,cStat,xMotivo,chNFe,tpEvento,xEvento,nSeqEvento,dhRegEvento,nProt
				)
				Values
				(
					@Id,@tpAmb,@verAplic,@cOrgao,@cStat,@xMotivo,@chNFe,@tpEvento,@xEvento,@nSeqEvento,@dhRegEvento,@nProt
				)
			End
		Else
			BEGIN
				Update
					ATL_BR.dbo.procEventoNFeRetEventoInfEvento
				SET
					tpAmb = @tpAmb,
					verAplic=@verAplic,
					cOrgao=@cOrgao,		
					cStat=@cStat,
					xMotivo=@xMotivo,	
					chNFe = @chNFe,
					tpEvento = @tpEvento,
					xEvento=@xEvento,
					nSeqEvento=@nSeqEvento,	
					dhRegEvento=@dhRegEvento,						
					nProt = @nProt
				Where
					Id=@Id
			END		
			
		Select @Id as Retorno;

		COMMIT TRAN
	END TRY

	BEGIN CATCH
		ROLLBACK TRAN
		SELECT ERROR_MESSAGE() as Retorno;

	END CATCH	

END

GO
