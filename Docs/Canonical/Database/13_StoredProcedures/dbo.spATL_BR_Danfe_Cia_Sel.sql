SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--[dbo].[spATL_BR_Danfe_Cia_Sel] null,null,'35220153877627000949550020000267331011410124','E',null,'P'

CREATE Procedure [dbo].[spATL_BR_Danfe_Cia_Sel]
(
	@Id_Danfe	int	,
	@serie		Varchar(10),
	@nNF		Varchar(100),
	@TipoDC		ChAR(1),
	@CNPJ		VARCHAR(14),
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
--sp_help ATL_BR.dbo.Danfe_Cia
if @Tipo = 'A' or @Tipo = 'B'
	Begin
		select
			DC.Id_Danfe,
			DC.Tipo,DC.CNPJ,DC.xNome,DC.xFant,DC.xLgr,DC.nro,DC.xCpl,DC.xBairro,DC.cMun,
			DC.xMun,DC.UF,DC.CEP,DC.cPais,DC.xPais,DC.fone,DC.IE,DC.IEST,DC.IM
			,DB.Nome_arquivo, DB.Num_Proc,DB.nNF
		from 
			ATL_BR.dbo.Danfe_Base DB with(nolock)
			Join ATL_BR.dbo.Danfe_CIA DC on DC.id_danfe=DB.id_danfe --and tipo='E' 
		Where
			DB.Id_Danfe = @Id_Danfe
	End


if @Tipo = 'C' or @Tipo = 'D'
	Begin
		select
			DC.Id_Danfe,
			DC.Tipo,DC.CNPJ,DC.xNome,DC.xFant,DC.xLgr,DC.nro,DC.xCpl,DC.xBairro,DC.cMun,
			DC.xMun,DC.UF,DC.CEP,DC.cPais,DC.xPais,DC.fone,DC.IE,DC.IEST,DC.IM
			,DB.Nome_arquivo, DB.Num_Proc,DB.nNF
		from 
			ATL_BR.dbo.Danfe_Base DB with(nolock)
			Join ATL_BR.dbo.Danfe_CIA DC on DC.id_danfe=DB.id_danfe --and tipo='E' 
		Where
			DB.nNF=@nNF and tipo=@TipoDC
	End
	
if @Tipo = 'N' or @Tipo = 'O'
	Begin
		select
			DC.Id_Danfe,
			DC.Tipo,DC.CNPJ,DC.xNome,DC.xFant,DC.xLgr,DC.nro,DC.xCpl,DC.xBairro,DC.cMun,
			DC.xMun,DC.UF,DC.CEP,DC.cPais,DC.xPais,DC.fone,DC.IE,DC.IEST,DC.IM
			,DB.Nome_arquivo, DB.Num_Proc,DB.nNF
		from 
			ATL_BR.dbo.Danfe_Base DB with(nolock)
			Join ATL_BR.dbo.Danfe_CIA DC on DC.id_danfe=DB.id_danfe --and tipo='E' 
		Where
			DB.nNF=@nNF and DB.serie=@serie
			and CNPJ=@CNPJ and tipo=@TipoDC
	End


--used to find the JOB using the protocol field
if @Tipo = 'P' 
	Begin
		select
			DC.Id_Danfe,
			DC.Tipo,DC.CNPJ,DC.xNome,DC.xFant,DC.xLgr,DC.nro,DC.xCpl,DC.xBairro,DC.cMun,
			DC.xMun,DC.UF,DC.CEP,DC.cPais,DC.xPais,DC.fone,DC.IE,DC.IEST,DC.IM
			,DB.Nome_arquivo, DB.Num_Proc,DB.nNF
		from 
			ATL_BR.dbo.Danfe_Base DB with(nolock)
			Join ATL_BR.dbo.Danfe_CIA DC on DC.id_danfe=DB.id_danfe --and tipo='E' 
		Where
			(DB.nProt=@nNF or DB.chNFe=@nNF)			
			and tipo=@TipoDC
	End
	

	

GO
