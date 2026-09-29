SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

Create procedure [dbo].[spATL_BR_procEventoNFeEventoInfEvento_InsUpd]
(
	@Id			int,
	@cOrgao		int,
	@tpAmb		int,
	@CNPJ		varchar(20),
	@chNFe		varchar(100),
	@dhEvento	datetime,
	@tpEvento	varchar(20),
	@nSeqEvento	int,
	@verEvento	decimal(18,2)

)
AS

BEGIN
--Exceção(try/CATCH)
--Transação
--sp_help procEventoNFeEventoInfEvento
	BEGIN TRY			
		if not exists(select Id from ATL_BR.dbo.procEventoNFeEventoInfEvento where Id = @Id)	
			Begin								
				Insert into ATL_BR.dbo.procEventoNFeEventoInfEvento
				(
					Id,cOrgao,tpAmb,CNPJ,chNFe,dhEvento,tpEvento,nSeqEvento,verEvento
				)
				Values
				(
					@Id,@cOrgao,@tpAmb,@CNPJ,@chNFe,@dhEvento,@tpEvento,@nSeqEvento,@verEvento
				)
			End
		Else
			BEGIN
				Update
					ATL_BR.dbo.procEventoNFeEventoInfEvento
				SET
					cOrgao=@cOrgao,		
					tpAmb = @tpAmb,
					CNPJ=@CNPJ,		
					chNFe = @chNFe,
					dhEvento=@dhEvento,		
					tpEvento = @tpEvento,
					nSeqEvento=@nSeqEvento,		
					verEvento = @verEvento
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
