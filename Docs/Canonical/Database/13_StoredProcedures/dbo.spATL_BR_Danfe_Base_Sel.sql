SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[spATL_BR_Danfe_Base_Sel]
(
	@Id_Danfe	int,
	@serie		Varchar(10),
	@nNF		Varchar(20),
	@Num_Proc	Varchar(16),
	@Tipo		char(1)
)
as

/*
A, /// Todos os registros - Existentes
B, /// Todos os registros - Ativos
C, /// Busca pelo Codigo - Existentes
D, /// Busca pelo Codigo - Ativos
N, /// Busca pelo Nome - Existentes
O /// Busca pelo Nome - Ativos
*/
--sp_help ATL_BR.dbo.Danfe_Base
if @Tipo = 'A' or @Tipo = 'B'
	Begin
		select
			DB.Id_Danfe,DB.cNF,DB.indPag,DB.serie,DB.nNF,DB.dEmis,DB.dSaiEnt,DB.tpNF,DB.cDV,DB.finNFE,DB.Num_Proc,
			DB.infCompl,DB.cUF,DB.dtEnvio,DB.dtCancel,DB.JustCancel,DB.nNFRef,DB.dtEnvioEsc,DB.Num_Pedido,DB.chNFe,
			DB.dhRecbto,DB.nProt,DB.dt_Alerta		
		from 
			ATL_BR.dbo.Danfe_Base DB with(nolock) 
		Where
			DB.Id_Danfe = @Id_Danfe
	End


if @Tipo = 'C' or @Tipo = 'D'
	Begin
		select
			DB.Id_Danfe,DB.cNF,DB.indPag,DB.serie,DB.nNF,DB.dEmis,DB.dSaiEnt,DB.tpNF,DB.cDV,DB.finNFE,DB.Num_Proc,
			DB.infCompl,DB.cUF,DB.dtEnvio,DB.dtCancel,DB.JustCancel,DB.nNFRef,DB.dtEnvioEsc,DB.Num_Pedido,DB.chNFe,
			DB.dhRecbto,DB.nProt,DB.dt_Alerta		
		from 
			ATL_BR.dbo.Danfe_Base DB with(nolock) 
		Where
			DB.nNF = @nNF and DB.serie = @serie
	End
	
if @Tipo = 'N' or @Tipo = 'O'
	Begin
		select
			DB.Id_Danfe,DB.cNF,DB.indPag,DB.serie,DB.nNF,DB.dEmis,DB.dSaiEnt,DB.tpNF,DB.cDV,DB.finNFE,DB.Num_Proc,
			DB.infCompl,DB.cUF,DB.dtEnvio,DB.dtCancel,DB.JustCancel,DB.nNFRef,DB.dtEnvioEsc,DB.Num_Pedido,DB.chNFe,
			DB.dhRecbto,DB.nProt,DB.dt_Alerta		
		from 
			ATL_BR.dbo.Danfe_Base DB with(nolock) 
		Where
			DB.Num_Proc = @Num_Proc
	End
	

	

GO
