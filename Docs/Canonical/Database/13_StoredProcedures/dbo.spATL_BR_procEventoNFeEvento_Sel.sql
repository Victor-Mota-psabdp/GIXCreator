SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[spATL_BR_procEventoNFeEvento_Sel]
(
	@Id			int	,
	@chNFe		Varchar(100),
	@Num_Proc	Varchar(100),
	@nNF		Varchar(100),
	@Tipo		char(1)
)
as

--sp_help [procEventoNFeEvento]
--sp_help [procEventoNFeEventoInfEvento]
--sp_help [procEventoNFeEventoInfEventoDetEvento]
if @Tipo = 'A' or @Tipo = 'B'
	Begin
		select
			P.Id,P.versao,P.Num_Proc,P.dt_ins,P.Nome_Arquivo,P.nNF,
			E.cOrgao,E.tpAmb,E.CNPJ,E.chNFe,E.dhEvento,E.tpEvento,E.nSeqEvento,E.verEvento,
			D.descEvento,D.nProt,D.xJust,D.xCorrecao,D.xCondUso,
			R.tpAmb,R.verAplic,R.cOrgao,R.cStat,R.xMotivo,R.chNFe,R.tpEvento,R.xEvento,R.nSeqEvento,R.dhRegEvento,R.nProt
		from 
			ATL_BR.dbo.procEventoNFeEvento P with(nolock)
			Join ATL_BR.dbo.procEventoNFeEventoInfEvento E on P.Id=E.Id
			Join ATL_BR.dbo.procEventoNFeEventoInfEventoDetEvento D on P.Id=D.Id
			left Join ATL_BR.dbo.procEventoNFeRetEventoInfEvento R on P.Id=R.Id			
		Where
			P.Id = @Id
	End


if @Tipo = 'C' or @Tipo = 'D'
	Begin
		select
			P.Id,P.versao,P.Num_Proc,P.dt_ins,P.Nome_Arquivo,P.nNF,
			E.cOrgao,E.tpAmb,E.CNPJ,E.chNFe,E.dhEvento,E.tpEvento,E.nSeqEvento,E.verEvento,
			D.descEvento,D.nProt,D.xJust,D.xCorrecao,D.xCondUso,
			R.tpAmb,R.verAplic,R.cOrgao,R.cStat,R.xMotivo,R.chNFe,R.tpEvento,R.xEvento,R.nSeqEvento,R.dhRegEvento,R.nProt
		from 
			ATL_BR.dbo.procEventoNFeEvento P with(nolock)
			Join ATL_BR.dbo.procEventoNFeEventoInfEvento E on P.Id=E.Id
			Join ATL_BR.dbo.procEventoNFeEventoInfEventoDetEvento D on P.Id=D.Id
			left Join ATL_BR.dbo.procEventoNFeRetEventoInfEvento R on P.Id=R.Id		
		Where
			E.chNFe =@chNFe
	End
	
if @Tipo = 'N' or @Tipo = 'O'
	Begin
		select
			P.Id,P.versao,P.Num_Proc,P.dt_ins,P.Nome_Arquivo,
			E.cOrgao,E.tpAmb,E.CNPJ,E.chNFe,E.dhEvento,E.tpEvento,E.nSeqEvento,E.verEvento,
			D.descEvento,D.nProt,D.xJust,D.xCorrecao,D.xCondUso,
			R.tpAmb,R.verAplic,R.cOrgao,R.cStat,R.xMotivo,R.chNFe,R.tpEvento,R.xEvento,R.nSeqEvento,R.dhRegEvento,R.nProt
		from 
			ATL_BR.dbo.procEventoNFeEvento P with(nolock)
			Join ATL_BR.dbo.procEventoNFeEventoInfEvento E on P.Id=E.Id
			Join ATL_BR.dbo.procEventoNFeEventoInfEventoDetEvento D on P.Id=D.Id
			left Join ATL_BR.dbo.procEventoNFeRetEventoInfEvento R on P.Id=R.Id		
		Where
			P.Num_Proc=@Num_Proc and nNF = @nNF
	End
	

	

GO
