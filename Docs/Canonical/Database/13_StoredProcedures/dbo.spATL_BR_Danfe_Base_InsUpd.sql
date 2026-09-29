SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[spATL_BR_Danfe_Base_InsUpd]
(
	@Id_Danfe	int,
	@cNF		Varchar(30),
	@indPag		Varchar(10),
	@serie		Varchar(10),
	@nNF		Varchar(20),
	@dEmis		Datetime,
	@dSaiEnt	Datetime,
	@tpNF		int,
	@cDV		int,
	@finNFE		int,
	@Num_Proc	Varchar(16),
	@infCompl	Varchar(4000),
	@cUF		int,
	@dtEnvio	Datetime,
	@dtCancel	Datetime,
	@JustCancel	varchar(200),
	@nNFRef		varchar(20),
	@dtEnvioEsc	Datetime,
	@Num_Pedido	varchar(100),
	@chNFe		varchar(100),
	@dhRecbto	Datetime,
	@nProt		varchar(100),
	@dt_Alerta	Datetime,
	@Nome_Arquivo varchar(200)

)
AS

BEGIN
--Exceção(try/CATCH)
--Transação
--sp_help Danfe_Base
	BEGIN TRY			
		if @Id_Danfe is null
			Begin
				Set @Id_Danfe=(select  Isnull(max(id_danfe),0)+1 from ATL_BR.dbo.Danfe_Base)					
				Insert into ATL_BR.dbo.Danfe_Base
				(
					Id_Danfe,cNF,indPag	,serie,nNF,dEmis,dSaiEnt,tpNF,cDV,finNFE,Num_Proc,infCompl,cUF,
					dtEnvio,dtCancel,JustCancel,nNFRef,dtEnvioEsc,Num_Pedido,chNFe,dhRecbto,nProt,dt_Alerta,
					Nome_Arquivo
				)
				Values
				(
					@Id_Danfe,@cNF,@indPag,@serie,@nNF,@dEmis,@dSaiEnt,@tpNF,@cDV,@finNFE,@Num_Proc,@infCompl,@cUF,
					@dtEnvio,@dtCancel,@JustCancel,@nNFRef,@dtEnvioEsc,@Num_Pedido,@chNFe,@dhRecbto,@nProt,@dt_Alerta,
					@Nome_Arquivo
				)
			End
		Else
			BEGIN
				Update
					ATL_BR.dbo.Danfe_Base
				SET
					--Id_Danfe=@Id_Danfe,
					--cNF=@cNF,
					--indPag=@indPag,
					--serie=@serie,
					--nNF=@nNF,
					--dEmis=@dEmis,
					--dSaiEnt=@dSaiEnt,
					--tpNF=@tpNF,
					--cDV=@cDV,
					--finNFE=@finNFE,
					Num_Proc=@Num_Proc,
					--infCompl=@infCompl,
					--cUF=@cUF,
					--dtEnvio=@dtEnvio,
					--dtCancel=@dtCancel,
					--JustCancel=@JustCancel,
					--nNFRef=@nNFRef,
					--dtEnvioEsc=@dtEnvioEsc,
					--Num_Pedido=@Num_Pedido,
					--chNFe=@chNFe,
					--dhRecbto=@dhRecbto,
					--nProt=@nProt,
					--dt_Alerta=@dt_Alerta,
					Nome_Arquivo = @Nome_Arquivo
				Where
					id_danfe=@id_danfe
			END		
			
		Select @Id_Danfe as Retorno;

		COMMIT TRAN
	END TRY

	BEGIN CATCH
		ROLLBACK TRAN
		SELECT ERROR_MESSAGE() as Retorno;

	END CATCH	

END

GO
