SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--select * from pessoa_LLP where Cd_Pes_Grupo = 'P000031844'
--[spATLDN_Pessoa_LLP_Sel] '','56900',NULL,'P'

--select * from pessoa_LLP where Cd_Pes in (
--select cd_seller from Pedido where cd_buyer = 'P000015092'
--and cd_grupo = 'P000031844')
--select * from pessoa_LLP where Cd_Pes = 'P000032296'
--select * from pessoa_LLP where Cd_Pes = 'P000037931'
CREATE procedure [dbo].[spATLDN_Pessoa_LLP_Sel]
(
	@Cd_Pes			VarChar(10),
	@Apelido		VarChar(20),
	@Cd_Pes_Grupo	VarChar(20),
	@Tipo			char(1)
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

if @Tipo = 'A'
	Begin
		Select 
			LLP.Cd_Pes				[Code],
			P.Apelido				[Company Name],
			P.Nome_Raz_Soc			[Complete Name],
			LLP.Cd_Planta			[Plant Code],
			LLP.Planta_Nome			[Plant Name],
			LLP.Cd_Pes_Grupo		[Group Code],
			LLP.Cd_Vendor			[Vendor Code],						
			LLP.RGLNumber			[RGLNumber],
			LLP.InvoiceGRP			[InvoiceGRP],
			G.Grupo					[Group Internal Code],
			PG.Apelido				[Group Name]
		from
			Pessoa_LLP LLP with(nolock)
			JOIN Pessoa P ON P.Cd_Pes = LLP.Cd_Pes
			JOIN Grupo G ON G.Cd_Pes_Grupo = LLP.Cd_Pes_Grupo
			LEFT JOIN Pessoa PG on PG.Cd_Pes = G.Cd_Pes_Grupo
	ENd

if @Tipo = 'B'
	Begin
		Select 
			LLP.Cd_Pes				[Code],
			P.Apelido				[Company Name],
			P.Nome_Raz_Soc			[Complete Name],
			LLP.Cd_Planta			[Plant Code],
			LLP.Planta_Nome			[Plant Name],
			LLP.Cd_Pes_Grupo		[Group Code],
			LLP.Cd_Vendor			[Vendor Code],						
			LLP.RGLNumber			[RGLNumber],
			LLP.InvoiceGRP			[InvoiceGRP],
			G.Grupo					[Group Internal Code],
			PG.Apelido				[Group Name]
		from
			Pessoa_LLP LLP with(nolock)
			JOIN Pessoa P ON P.Cd_Pes = LLP.Cd_Pes
			JOIN Grupo G ON G.Cd_Pes_Grupo = LLP.Cd_Pes_Grupo
			LEFT JOIN Pessoa PG on PG.Cd_Pes = G.Cd_Pes_Grupo
		where 
			P.Desat_Pes = 'N'
	End

if @Tipo = 'C' 
	Begin
		Select 
			LLP.Cd_Pes				[Code],
			P.Apelido				[Company Name],
			P.Nome_Raz_Soc			[Complete Name],
			LLP.Cd_Planta			[Plant Code],
			LLP.Planta_Nome			[Plant Name],
			LLP.Cd_Pes_Grupo		[Group Code],
			LLP.Cd_Vendor			[Vendor Code],						
			LLP.RGLNumber			[RGLNumber],
			LLP.InvoiceGRP			[InvoiceGRP],
			G.Grupo					[Group Internal Code],
			PG.Apelido				[Group Name]
		from
			Pessoa_LLP LLP with(nolock)
			JOIN Pessoa P ON P.Cd_Pes = LLP.Cd_Pes
			JOIN Grupo G ON G.Cd_Pes_Grupo = LLP.Cd_Pes_Grupo
			LEFT JOIN Pessoa PG on PG.Cd_Pes = G.Cd_Pes_Grupo
		where 
			LLP.Cd_Pes = @Cd_Pes
	End	

if @Tipo = 'D'
	Begin
		Select 
			LLP.Cd_Pes				[Code],
			P.Apelido				[Company Name],
			P.Nome_Raz_Soc			[Complete Name],
			LLP.Cd_Planta			[Plant Code],
			LLP.Planta_Nome			[Plant Name],
			LLP.Cd_Pes_Grupo		[Group Code],
			LLP.Cd_Vendor			[Vendor Code],						
			LLP.RGLNumber			[RGLNumber],
			LLP.InvoiceGRP			[InvoiceGRP],
			G.Grupo					[Group Internal Code],
			PG.Apelido				[Group Name]
		from
			Pessoa_LLP LLP with(nolock)
			JOIN Pessoa P ON P.Cd_Pes = LLP.Cd_Pes
			JOIN Grupo G ON G.Cd_Pes_Grupo = LLP.Cd_Pes_Grupo
			LEFT JOIN Pessoa PG on PG.Cd_Pes = G.Cd_Pes_Grupo
		where 
			LLP.Cd_Pes = @Cd_Pes and P.Desat_Pes = 'N'
	End	
	
if @Tipo = 'N' 
	Begin
	Select 
			LLP.Cd_Pes				[Code],
			P.Apelido				[Company Name],
			P.Nome_Raz_Soc			[Complete Name],
			LLP.Cd_Planta			[Plant Code],
			LLP.Planta_Nome			[Plant Name],
			LLP.Cd_Pes_Grupo		[Group Code],
			LLP.Cd_Vendor			[Vendor Code],						
			LLP.RGLNumber			[RGLNumber],
			LLP.InvoiceGRP			[InvoiceGRP],
			G.Grupo					[Group Internal Code],
			PG.Apelido				[Group Name]
		from
			Pessoa_LLP LLP with(nolock)
			JOIN Pessoa P ON P.Cd_Pes = LLP.Cd_Pes
			JOIN Grupo G ON G.Cd_Pes_Grupo = LLP.Cd_Pes_Grupo
			LEFT JOIN Pessoa PG on PG.Cd_Pes = G.Cd_Pes_Grupo
		where 
			P.Apelido = @Apelido
	End	

if @Tipo = 'O' 
	Begin
		Select 
			LLP.Cd_Pes				[Code],
			P.Apelido				[Company Name],
			P.Nome_Raz_Soc			[Complete Name],
			LLP.Cd_Planta			[Plant Code],
			LLP.Planta_Nome			[Plant Name],
			LLP.Cd_Pes_Grupo		[Group Code],
			LLP.Cd_Vendor			[Vendor Code],						
			LLP.RGLNumber			[RGLNumber],
			LLP.InvoiceGRP			[InvoiceGRP],
			G.Grupo					[Group Internal Code],
			PG.Apelido				[Group Name]
		from
			Pessoa_LLP LLP with(nolock)
			JOIN Pessoa P ON P.Cd_Pes = LLP.Cd_Pes
			JOIN Grupo G ON G.Cd_Pes_Grupo = LLP.Cd_Pes_Grupo
			LEFT JOIN Pessoa PG on PG.Cd_Pes = G.Cd_Pes_Grupo
		where 
			P.Apelido = @Apelido and LLP.Cd_Pes_Grupo  = @Cd_Pes_Grupo
	End	

if @Tipo = 'P' 
	Begin
		Select 
			LLP.Cd_Pes				[Code],
			P.Apelido				[Company Name],
			P.Nome_Raz_Soc			[Complete Name],
			LLP.Cd_Planta			[Plant Code],
			LLP.Planta_Nome			[Plant Name],
			LLP.Cd_Pes_Grupo		[Group Code],
			LLP.Cd_Vendor			[Vendor Code],						
			LLP.RGLNumber			[RGLNumber],
			LLP.InvoiceGRP			[InvoiceGRP],
			G.Grupo					[Group Internal Code],
			PG.Apelido				[Group Name]
		from
			Pessoa_LLP LLP with(nolock)
			JOIN Pessoa P ON P.Cd_Pes = LLP.Cd_Pes
			JOIN Grupo G ON G.Cd_Pes_Grupo = LLP.Cd_Pes_Grupo
			LEFT JOIN Pessoa PG on PG.Cd_Pes = G.Cd_Pes_Grupo
		where 
			(LLP.Cd_Vendor = @Apelido or LLP.Cd_Planta = @Apelido)
	End	

if @Tipo = 'Q' 
	Begin
		Select 
			LLP.Cd_Pes				[Code],
			P.Apelido				[Company Name],
			P.Nome_Raz_Soc			[Complete Name],
			LLP.Cd_Planta			[Plant Code],
			LLP.Planta_Nome			[Plant Name],
			LLP.Cd_Pes_Grupo		[Group Code],
			LLP.Cd_Vendor			[Vendor Code],						
			LLP.RGLNumber			[RGLNumber],
			LLP.InvoiceGRP			[InvoiceGRP],
			G.Grupo					[Group Internal Code],
			PG.Apelido				[Group Name]
		from
			Pessoa_LLP LLP with(nolock)
			JOIN Pessoa P ON P.Cd_Pes = LLP.Cd_Pes
			JOIN Grupo G ON G.Cd_Pes_Grupo = LLP.Cd_Pes_Grupo
			LEFT JOIN Pessoa PG on PG.Cd_Pes = G.Cd_Pes_Grupo
		where 
			(LLP.Cd_Vendor = @Apelido or LLP.Cd_Planta = @Apelido)
			and LLP.Cd_Pes_Grupo  = @Cd_Pes_Grupo
	End	

--achar o cliente e o grupo pelo cnpj se tiver grupo amarrado
if @Tipo = 'G'
	Begin
		Select top 1
			LLP.Cd_Pes				[Code],
			P.Apelido				[Company Name],
			P.Nome_Raz_Soc			[Complete Name],
			LLP.Cd_Planta			[Plant Code],
			LLP.Planta_Nome			[Plant Name],
			LLP.Cd_Pes_Grupo		[Group Code],
			LLP.Cd_Vendor			[Vendor Code],						
			LLP.RGLNumber			[RGLNumber],
			LLP.InvoiceGRP			[InvoiceGRP],
			G.Grupo					[Group Internal Code],
			PG.Apelido				[Group Name]
		from
			Pessoa_LLP LLP with(nolock)
			JOIN Pessoa P ON P.Cd_Pes = LLP.Cd_Pes
			JOIN Grupo G ON G.Cd_Pes_Grupo = LLP.Cd_Pes_Grupo
			LEFT JOIN Pessoa PG on PG.Cd_Pes = G.Cd_Pes_Grupo
		where 
			replace(P.Num_CPF_CNPJ,'-','') = @Apelido and P.Desat_Pes = 'N'
			and PG.Apelido is not null
	End	

	
	 --strSQL = "select PL.cd_pes_grupo Cod, Smart_IMP from Pessoa_LLP PL With(nolock) " & _
  --  "join pessoa P With(nolock) on P.cd_pes=PL.cd_pes " & _
  --  "join Grupo G With(nolock) on G.cd_Pes_Grupo=PL.Cd_Pes_Grupo " & _
  --  "where apelido ='" & strApelido & "'"
	
--if @Tipo = 'O'
--	Begin
--		Select 
--			Cd_Pes [Code],
--			Apelido [Company Name],
--			Nome_Raz_Soc [Complete Name]
--		from
--			Pessoa_LLP with(nolock)
--		where Apelido = @Apelido and Desat_Pes = 'N'
--	End	
	
--if @Tipo = 'Z' --or @Tipo = 'O'
--	Begin
--		Select 
--			Cd_Pes [Code],
--			Apelido [Company Name],
--			Nome_Raz_Soc [Complete Name]
--		from
--			Pessoa_LLP with(nolock)
--		where Apelido = @Apelido and Cd_Pes <> @Cd_Pes
--	End
	
--if @Tipo = 'F'
--	Begin
--		Select 
--			Apelido [Company Name]
--		from
--			Pessoa_LLP with(nolock)
--		where 
--			Desat_Pes = 'N'
--		order by 1
--	End
	

	

	
GO
