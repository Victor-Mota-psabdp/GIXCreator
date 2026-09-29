SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE procedure [dbo].[spATLDN_Pessoa_Sel]
(
	@Cd_Pes		VarChar(10),
	@Apelido	VarChar(20),
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

F - Need to know where is used and if is necessary
*/
--sp_help Pessoa

if @Tipo = 'A'
	Begin
		SELECT 
			Cd_Pes				[Code],
			Apelido				[Company Name],
			Nome_Raz_Soc		[Complete Name],
			P.Num_CPF_CNPJ		[CNPJ_CPF], 
			P.Num_RG_IE			[IE], 
			P.Cd_Tp_Ativ		[Type Of Activity Code],
            TA.Nome_Tp_Ativ		[Type Of Activity Name],			
			P.Cd_Tp_Grupo		[Group Type Code], 		
			TG.Nome_Tp_Grupo	[Group Type Name], 
			P.Cd_Usuario		[User Code],
			US.Nome_Usuario		[User Name], 
			P.Dt_Cad			[Insert Date], 
            (CASE WHEN Desat_Pes = 'N' THEN CONVERT(Bit, 1) ELSE CONVERT(Bit, 0) END) AS Disable, 
			P.Obs_Pes			[Notes], 
			P.Num_Insc_Munic	[IM], 
            P.GLOBAL_ENTITY_ID  [Global Entity ID]

			--P.Cd_Tp_Classe		[Class Type Code],
			--TC.Nome_Tp_Classe	[Class Type Name],
			--P.Cd_Cta_Ctb		[Cta Ctb Code],	
			--CTA.Nome_Cta_Ctb	[Cta Ctb Name],
			--P.Cd_Tp_Pes			[Person Type Code],
			--P.Dupl_Cta_Master	[Dupl_Cta_Master],
			--P.Email				[Email],
			--P.PgtoRcto			[PgtoRcto],
			--P.GIX_HT_Customer	[GIX_HT_Customer]
		FROM dbo.Pessoa P WITH (nolock) 
			LEFT OUTER JOIN dbo.Tipo_Atividade AS TA WITH (nolock) ON P.Cd_Tp_Ativ = TA.Cd_Tp_Ativ 
			LEFT OUTER JOIN dbo.Tipo_Grupo AS TG WITH (nolock) ON P.Cd_Tp_Grupo = TG.Cd_Tp_Grupo 
			LEFT OUTER JOIN	dbo.Usuario AS US WITH (nolock) ON P.Cd_Usuario = US.Cd_Usuario

			--LEFT OUTER JOIN dbo.Tipo_Classe AS TC WITH (nolock) ON P.Cd_Tp_Classe = TC.Cd_Tp_Classe 
			--LEFT OUTER JOIN	dbo.Cta_Ctb AS CTA WITH (nolock) ON P.Cd_Cta_Ctb = CTA.Cd_Cta_Ctb
			
	ENd
	
if @Tipo = 'B'
	Begin
		SELECT 
			Cd_Pes				[Code],
			Apelido				[Company Name],
			Nome_Raz_Soc		[Complete Name],
			P.Num_CPF_CNPJ		[CNPJ_CPF], 
			P.Num_RG_IE			[IE], 
			P.Cd_Tp_Ativ		[Type Of Activity Code],
            TA.Nome_Tp_Ativ		[Type Of Activity Name],			
			P.Cd_Tp_Grupo		[Group Type Code], 		
			TG.Nome_Tp_Grupo	[Group Type Name], 
			P.Cd_Usuario		[User Code],
			US.Nome_Usuario		[User Name], 
			P.Dt_Cad			[Insert Date], 
            (CASE WHEN Desat_Pes = 'N' THEN CONVERT(Bit, 1) ELSE CONVERT(Bit, 0) END) AS Disable, 
			P.Obs_Pes			[Notes], 
			P.Num_Insc_Munic	[IM], 
            P.GLOBAL_ENTITY_ID  [Global Entity ID]
		FROM dbo.Pessoa P WITH (nolock) 
			LEFT OUTER JOIN dbo.Tipo_Atividade AS TA WITH (nolock) ON P.Cd_Tp_Ativ = TA.Cd_Tp_Ativ 
			LEFT OUTER JOIN dbo.Tipo_Grupo AS TG WITH (nolock) ON P.Cd_Tp_Grupo = TG.Cd_Tp_Grupo 
			LEFT OUTER JOIN	dbo.Usuario AS US WITH (nolock) ON P.Cd_Usuario = US.Cd_Usuario
		where 
			Desat_Pes = 'N'
	End

if @Tipo = 'C' 
	Begin	
		SELECT 
			Cd_Pes				[Code],
			Apelido				[Company Name],
			Nome_Raz_Soc		[Complete Name],
			P.Num_CPF_CNPJ		[CNPJ_CPF], 
			P.Num_RG_IE			[IE], 
			P.Cd_Tp_Ativ		[Type Of Activity Code],
            TA.Nome_Tp_Ativ		[Type Of Activity Name],			
			P.Cd_Tp_Grupo		[Group Type Code], 		
			TG.Nome_Tp_Grupo	[Group Type Name], 
			P.Cd_Usuario		[User Code],
			US.Nome_Usuario		[User Name], 
			P.Dt_Cad			[Insert Date], 
            (CASE WHEN Desat_Pes = 'N' THEN CONVERT(Bit, 1) ELSE CONVERT(Bit, 0) END) AS Disable, 
			P.Obs_Pes			[Notes], 
			P.Num_Insc_Munic	[IM], 
            P.GLOBAL_ENTITY_ID  [Global Entity ID]
		FROM dbo.Pessoa P WITH (nolock) 
			LEFT OUTER JOIN dbo.Tipo_Atividade AS TA WITH (nolock) ON P.Cd_Tp_Ativ = TA.Cd_Tp_Ativ 
			LEFT OUTER JOIN dbo.Tipo_Grupo AS TG WITH (nolock) ON P.Cd_Tp_Grupo = TG.Cd_Tp_Grupo 
			LEFT OUTER JOIN	dbo.Usuario AS US WITH (nolock) ON P.Cd_Usuario = US.Cd_Usuario
		where 
			Cd_Pes = @Cd_Pes
	End
		
if @Tipo = 'D'
	Begin
		SELECT 
			Cd_Pes				[Code],
			Apelido				[Company Name],
			Nome_Raz_Soc		[Complete Name],
			P.Num_CPF_CNPJ		[CNPJ_CPF], 
			P.Num_RG_IE			[IE], 
			P.Cd_Tp_Ativ		[Type Of Activity Code],
            TA.Nome_Tp_Ativ		[Type Of Activity Name],			
			P.Cd_Tp_Grupo		[Group Type Code], 		
			TG.Nome_Tp_Grupo	[Group Type Name], 
			P.Cd_Usuario		[User Code],
			US.Nome_Usuario		[User Name], 
			P.Dt_Cad			[Insert Date], 
            (CASE WHEN Desat_Pes = 'N' THEN CONVERT(Bit, 1) ELSE CONVERT(Bit, 0) END) AS Disable, 
			P.Obs_Pes			[Notes], 
			P.Num_Insc_Munic	[IM], 
            P.GLOBAL_ENTITY_ID  [Global Entity ID]
		FROM dbo.Pessoa P WITH (nolock) 
			LEFT OUTER JOIN dbo.Tipo_Atividade AS TA WITH (nolock) ON P.Cd_Tp_Ativ = TA.Cd_Tp_Ativ 
			LEFT OUTER JOIN dbo.Tipo_Grupo AS TG WITH (nolock) ON P.Cd_Tp_Grupo = TG.Cd_Tp_Grupo 
			LEFT OUTER JOIN	dbo.Usuario AS US WITH (nolock) ON P.Cd_Usuario = US.Cd_Usuario
		where 
			Cd_Pes = @Cd_Pes and Desat_Pes = 'N'
	End	
	
if @Tipo = 'N' 
	Begin
		SELECT 
			Cd_Pes				[Code],
			Apelido				[Company Name],
			Nome_Raz_Soc		[Complete Name],
			P.Num_CPF_CNPJ		[CNPJ_CPF], 
			P.Num_RG_IE			[IE], 
			P.Cd_Tp_Ativ		[Type Of Activity Code],
            TA.Nome_Tp_Ativ		[Type Of Activity Name],			
			P.Cd_Tp_Grupo		[Group Type Code], 		
			TG.Nome_Tp_Grupo	[Group Type Name], 
			P.Cd_Usuario		[User Code],
			US.Nome_Usuario		[User Name], 
			P.Dt_Cad			[Insert Date], 
            (CASE WHEN Desat_Pes = 'N' THEN CONVERT(Bit, 1) ELSE CONVERT(Bit, 0) END) AS Disable, 
			P.Obs_Pes			[Notes], 
			P.Num_Insc_Munic	[IM], 
            P.GLOBAL_ENTITY_ID  [Global Entity ID]
		FROM dbo.Pessoa P WITH (nolock) 
			LEFT OUTER JOIN dbo.Tipo_Atividade AS TA WITH (nolock) ON P.Cd_Tp_Ativ = TA.Cd_Tp_Ativ 
			LEFT OUTER JOIN dbo.Tipo_Grupo AS TG WITH (nolock) ON P.Cd_Tp_Grupo = TG.Cd_Tp_Grupo 
			LEFT OUTER JOIN	dbo.Usuario AS US WITH (nolock) ON P.Cd_Usuario = US.Cd_Usuario
		where 
			Apelido = @Apelido
	End	
	
if @Tipo = 'O'
	Begin
		SELECT 
			Cd_Pes				[Code],
			Apelido				[Company Name],
			Nome_Raz_Soc		[Complete Name],
			P.Num_CPF_CNPJ		[CNPJ_CPF], 
			P.Num_RG_IE			[IE], 
			P.Cd_Tp_Ativ		[Type Of Activity Code],
            TA.Nome_Tp_Ativ		[Type Of Activity Name],			
			P.Cd_Tp_Grupo		[Group Type Code], 		
			TG.Nome_Tp_Grupo	[Group Type Name], 
			P.Cd_Usuario		[User Code],
			US.Nome_Usuario		[User Name], 
			P.Dt_Cad			[Insert Date], 
            (CASE WHEN Desat_Pes = 'N' THEN CONVERT(Bit, 1) ELSE CONVERT(Bit, 0) END) AS Disable, 
			P.Obs_Pes			[Notes], 
			P.Num_Insc_Munic	[IM], 
            P.GLOBAL_ENTITY_ID  [Global Entity ID]
		FROM dbo.Pessoa P WITH (nolock) 
			LEFT OUTER JOIN dbo.Tipo_Atividade AS TA WITH (nolock) ON P.Cd_Tp_Ativ = TA.Cd_Tp_Ativ 
			LEFT OUTER JOIN dbo.Tipo_Grupo AS TG WITH (nolock) ON P.Cd_Tp_Grupo = TG.Cd_Tp_Grupo 
			LEFT OUTER JOIN	dbo.Usuario AS US WITH (nolock) ON P.Cd_Usuario = US.Cd_Usuario
		where 
			Apelido = @Apelido and Desat_Pes = 'N'
	End	
	
if @Tipo = 'Z' --or @Tipo = 'O'
	Begin
		SELECT 
			Cd_Pes				[Code],
			Apelido				[Company Name],
			Nome_Raz_Soc		[Complete Name],
			P.Num_CPF_CNPJ		[CNPJ_CPF], 
			P.Num_RG_IE			[IE], 
			P.Cd_Tp_Ativ		[Type Of Activity Code],
            TA.Nome_Tp_Ativ		[Type Of Activity Name],			
			P.Cd_Tp_Grupo		[Group Type Code], 		
			TG.Nome_Tp_Grupo	[Group Type Name], 
			P.Cd_Usuario		[User Code],
			US.Nome_Usuario		[User Name], 
			P.Dt_Cad			[Insert Date], 
            (CASE WHEN Desat_Pes = 'N' THEN CONVERT(Bit, 1) ELSE CONVERT(Bit, 0) END) AS Disable, 
			P.Obs_Pes			[Notes], 
			P.Num_Insc_Munic	[IM], 
            P.GLOBAL_ENTITY_ID  [Global Entity ID]
		FROM dbo.Pessoa P WITH (nolock) 
			LEFT OUTER JOIN dbo.Tipo_Atividade AS TA WITH (nolock) ON P.Cd_Tp_Ativ = TA.Cd_Tp_Ativ 
			LEFT OUTER JOIN dbo.Tipo_Grupo AS TG WITH (nolock) ON P.Cd_Tp_Grupo = TG.Cd_Tp_Grupo 
			LEFT OUTER JOIN	dbo.Usuario AS US WITH (nolock) ON P.Cd_Usuario = US.Cd_Usuario
		where 
			Apelido = @Apelido and Cd_Pes <> isnull(@Cd_Pes,'') --cadu 2026-03-24 incluido o isnull
	End

if @Tipo = 'G'
	Begin	
		SELECT 
			Cd_Pes				[Code],
			Apelido				[Company Name],
			Nome_Raz_Soc		[Complete Name],
			P.Num_CPF_CNPJ		[CNPJ_CPF], 
			P.Num_RG_IE			[IE], 
			P.Cd_Tp_Ativ		[Type Of Activity Code],
            TA.Nome_Tp_Ativ		[Type Of Activity Name],			
			P.Cd_Tp_Grupo		[Group Type Code], 		
			TG.Nome_Tp_Grupo	[Group Type Name], 
			P.Cd_Usuario		[User Code],
			US.Nome_Usuario		[User Name], 
			P.Dt_Cad			[Insert Date], 
            (CASE WHEN Desat_Pes = 'N' THEN CONVERT(Bit, 1) ELSE CONVERT(Bit, 0) END) AS Disable, 
			P.Obs_Pes			[Notes], 
			P.Num_Insc_Munic	[IM], 
            P.GLOBAL_ENTITY_ID  [Global Entity ID]
		FROM dbo.Pessoa P WITH (nolock) 
			LEFT OUTER JOIN dbo.Tipo_Atividade AS TA WITH (nolock) ON P.Cd_Tp_Ativ = TA.Cd_Tp_Ativ 
			LEFT OUTER JOIN dbo.Tipo_Grupo AS TG WITH (nolock) ON P.Cd_Tp_Grupo = TG.Cd_Tp_Grupo 
			LEFT OUTER JOIN	dbo.Usuario AS US WITH (nolock) ON P.Cd_Usuario = US.Cd_Usuario
			LEFT OUTER JOIN dbo.Grupo G on G.Cd_Pes_Grupo = P.Cd_Pes
		Where
			P.Cd_Pes = @Cd_Pes and P.Desat_Pes = 'N'
			and G.Grupo is null
	end
	
if @Tipo = 'H'
	Begin	
		--Select 
		--	PP.Cd_Pes [Code],
		--	PP.Apelido [Company Name],
		--	PP.Nome_Raz_Soc [Complete Name]
		--from
		--	Pessoa PP
		--	left join Grupo G on G.Cd_Pes_Grupo = PP.Cd_Pes
		--Where
		--	PP.Apelido = @Apelido and PP.Desat_Pes = 'N'
		--	and G.Grupo is null

		SELECT 
			Cd_Pes				[Code],
			Apelido				[Company Name],
			Nome_Raz_Soc		[Complete Name],
			P.Num_CPF_CNPJ		[CNPJ_CPF], 
			P.Num_RG_IE			[IE], 
			P.Cd_Tp_Ativ		[Type Of Activity Code],
            TA.Nome_Tp_Ativ		[Type Of Activity Name],			
			P.Cd_Tp_Grupo		[Group Type Code], 		
			TG.Nome_Tp_Grupo	[Group Type Name], 
			P.Cd_Usuario		[User Code],
			US.Nome_Usuario		[User Name], 
			P.Dt_Cad			[Insert Date], 
            (CASE WHEN Desat_Pes = 'N' THEN CONVERT(Bit, 1) ELSE CONVERT(Bit, 0) END) AS Disable, 
			P.Obs_Pes			[Notes], 
			P.Num_Insc_Munic	[IM], 
            P.GLOBAL_ENTITY_ID  [Global Entity ID]
		FROM dbo.Pessoa P WITH (nolock) 
			LEFT OUTER JOIN dbo.Tipo_Atividade AS TA WITH (nolock) ON P.Cd_Tp_Ativ = TA.Cd_Tp_Ativ 
			LEFT OUTER JOIN dbo.Tipo_Grupo AS TG WITH (nolock) ON P.Cd_Tp_Grupo = TG.Cd_Tp_Grupo 
			LEFT OUTER JOIN	dbo.Usuario AS US WITH (nolock) ON P.Cd_Usuario = US.Cd_Usuario
			LEFT OUTER JOIN dbo.Grupo G on G.Cd_Pes_Grupo = P.Cd_Pes
		Where
			P.Apelido = @Apelido and P.Desat_Pes = 'N'
			and G.Grupo is null
	end



--F and W included by Leandro to ATL WEB
if @Tipo = 'F'
	Begin
		Select 
			Apelido [Company Name]
		from
			Pessoa with(nolock)
		order by 1
	End
	

--if @Tipo = 'W'
--	Begin
--		SELECT 
--			Cd_Pes				[Code],
--			Apelido				[Company Name],
--			Nome_Raz_Soc		[Complete Name],
--			P.Num_CPF_CNPJ		[CNPJ_CPF], 
--			P.Num_RG_IE			[IE], 
--			P.Cd_Tp_Ativ		[Type Of Activity Code],
--            TA.Nome_Tp_Ativ		[Type Of Activity Name],			
--			P.Cd_Tp_Grupo		[Group Type Code], 		
--			TG.Nome_Tp_Grupo	[Group Type Name], 
--			P.Cd_Usuario		[User Code],
--			US.Nome_Usuario		[User Name], 
--			P.Dt_Cad			[Insert Date], 
--            --(CASE WHEN Desat_Pes = 'N' THEN CONVERT(Bit, 1) ELSE CONVERT(Bit, 0) END) AS Disable, 
--			P.Desat_Pes			[Disable],
--			P.Obs_Pes			[Notes], 
--			P.Num_Insc_Munic	[IM], 
--            P.GLOBAL_ENTITY_ID  [Global Entity ID]
--		FROM dbo.Pessoa P WITH (nolock) 
--			LEFT OUTER JOIN dbo.Tipo_Atividade AS TA WITH (nolock) ON P.Cd_Tp_Ativ = TA.Cd_Tp_Ativ 
--			LEFT OUTER JOIN dbo.Tipo_Grupo AS TG WITH (nolock) ON P.Cd_Tp_Grupo = TG.Cd_Tp_Grupo 
--			LEFT OUTER JOIN	dbo.Usuario AS US WITH (nolock) ON P.Cd_Usuario = US.Cd_Usuario
--		--where 
--		--	Apelido = @Apelido
--	End
if @Tipo = 'W'
	Begin
		SELECT 
			Cd_Pes				[Code],
			Apelido				[Company Name],
			Nome_Raz_Soc		[Complete Name],
			P.Num_CPF_CNPJ		[CNPJ_CPF], 
			P.Num_RG_IE			[IE], 
			P.Cd_Tp_Ativ		[Type Of Activity Code],
            TA.Nome_Tp_Ativ		[Type Of Activity Name],			
			P.Cd_Tp_Grupo		[Group Type Code], 		
			TG.Nome_Tp_Grupo	[Group Type Name], 
			P.Cd_Usuario		[User Code],
			US.Nome_Usuario		[User Name], 
			P.Dt_Cad			[Insert Date], 
            P.Desat_Pes			[Disable], 
			P.Obs_Pes			[Notes], 
			P.Num_Insc_Munic	[IM], 
            P.GLOBAL_ENTITY_ID  [Global Entity ID]

			--P.Cd_Tp_Classe		[Class Type Code],
			--TC.Nome_Tp_Classe	[Class Type Name],
			--P.Cd_Cta_Ctb		[Cta Ctb Code],	
			--CTA.Nome_Cta_Ctb	[Cta Ctb Name],
			--P.Cd_Tp_Pes			[Person Type Code],
			--P.Dupl_Cta_Master	[Dupl_Cta_Master],
			--P.Email				[Email],
			--P.PgtoRcto			[PgtoRcto],
			--P.GIX_HT_Customer	[GIX_HT_Customer]
		FROM dbo.Pessoa P WITH (nolock) 
			LEFT OUTER JOIN dbo.Tipo_Atividade AS TA WITH (nolock) ON P.Cd_Tp_Ativ = TA.Cd_Tp_Ativ 
			LEFT OUTER JOIN dbo.Tipo_Grupo AS TG WITH (nolock) ON P.Cd_Tp_Grupo = TG.Cd_Tp_Grupo 
			LEFT OUTER JOIN	dbo.Usuario AS US WITH (nolock) ON P.Cd_Usuario = US.Cd_Usuario

			--LEFT OUTER JOIN dbo.Tipo_Classe AS TC WITH (nolock) ON P.Cd_Tp_Classe = TC.Cd_Tp_Classe 
			--LEFT OUTER JOIN	dbo.Cta_Ctb AS CTA WITH (nolock) ON P.Cd_Cta_Ctb = CTA.Cd_Cta_Ctb

			where 
			Apelido like '%OXITENO%'
			and Desat_Pes = 'N'
	ENd
if @Tipo = 'P' -- Pais Proibido // Leandro 23/09
Begin
		SELECT 
			PP.Cd_Pes				[Code],
			Apelido				[Company Name],
			Nome_Raz_Soc		[Complete Name],
			PP.Num_CPF_CNPJ		[CNPJ_CPF], 
			PP.Num_RG_IE			[IE], 
			PP.Cd_Tp_Ativ		[Type Of Activity Code],
            TA.Nome_Tp_Ativ		[Type Of Activity Name],			
			PP.Cd_Tp_Grupo		[Group Type Code], 		
			TG.Nome_Tp_Grupo	[Group Type Name], 
			P.Cd_Usuario		[User Code],
			US.Nome_Usuario		[User Name], 
			PP.Dt_Cad			[Insert Date], 
            (CASE WHEN Desat_Pes = 'N' THEN CONVERT(Bit, 1) ELSE CONVERT(Bit, 0) END) AS Disable, 
			PP.Obs_Pes			[Notes], 
			PP.Num_Insc_Munic	[IM], 
            PP.GLOBAL_ENTITY_ID  [Global Entity ID]
		FROM dbo.Pessoa PP WITH (nolock) 
			JOIN				dbo.Endereco		AS ED WITH (nolock)	ON ED.Cd_Pes = PP.Cd_Pes AND Cd_Tp_End = 'COM'
			JOIN				dbo.Pais			AS	P WITH (nolock) ON P.Cd_Pais = ED.CD_pais 
			LEFT OUTER JOIN		dbo.Tipo_Atividade	AS TA WITH (nolock) ON PP.Cd_Tp_Ativ = TA.Cd_Tp_Ativ 
			LEFT OUTER JOIN		dbo.Tipo_Grupo		AS TG WITH (nolock) ON PP.Cd_Tp_Grupo = TG.Cd_Tp_Grupo 
			LEFT OUTER JOIN		dbo.Usuario			AS US WITH (nolock) ON PP.Cd_Usuario = US.Cd_Usuario
			

		WHERE 
		PP.Apelido = @Apelido
		and PP.Desat_Pes = 'N'
		and P.Proibido = 1 
		and P.Ativo= 1
	ENd							
			

if @Tipo = 'Y' -- Pais Proibido // Leandro 23/09
Begin
		SELECT 
			PP.Cd_Pes				[Code],
			Apelido					[Company Name],
			Nome_Raz_Soc			[Complete Name],
			PP.Num_CPF_CNPJ			[CNPJ_CPF], 
			PP.Num_RG_IE			[IE], 
			PP.Cd_Tp_Ativ			[Type Of Activity Code],
            TA.Nome_Tp_Ativ			[Type Of Activity Name],			
			PP.Cd_Tp_Grupo			[Group Type Code], 		
			TG.Nome_Tp_Grupo		[Group Type Name], 
			P.Cd_Usuario			[User Code],
			US.Nome_Usuario			[User Name], 
			PP.Dt_Cad				[Insert Date], 
            (CASE WHEN Desat_Pes = 'N' THEN CONVERT(Bit, 1) ELSE CONVERT(Bit, 0) END) AS Disable, 
			PP.Obs_Pes				[Notes], 
			PP.Num_Insc_Munic		[IM], 
            PP.GLOBAL_ENTITY_ID		[Global Entity ID],
			P.Proibido				[Proibido]
		FROM dbo.Pessoa PP WITH (nolock) 
			JOIN				dbo.Endereco		AS ED WITH (nolock)	ON ED.Cd_Pes = PP.Cd_Pes AND Cd_Tp_End = 'COM'
			JOIN				dbo.Pais			AS	P WITH (nolock) ON P.Cd_Pais = ED.CD_pais 
			LEFT OUTER JOIN		dbo.Tipo_Atividade	AS TA WITH (nolock) ON PP.Cd_Tp_Ativ = TA.Cd_Tp_Ativ 
			LEFT OUTER JOIN		dbo.Tipo_Grupo		AS TG WITH (nolock) ON PP.Cd_Tp_Grupo = TG.Cd_Tp_Grupo 
			LEFT OUTER JOIN		dbo.Usuario			AS US WITH (nolock) ON PP.Cd_Usuario = US.Cd_Usuario
			

		WHERE 
		PP.Cd_Pes = @Cd_Pes
		and PP.Desat_Pes = 'N'
		and P.Proibido = 1 
		and P.Ativo= 1
	ENd	




/*02112024

ALTER procedure [dbo].[spATLDN_Pessoa_Sel]
(
	@Cd_Pes		VarChar(10),
	@Apelido	VarChar(20),
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

F - Need to know where is used and if is necessary
*/
--sp_help Pessoa

if @Tipo = 'A'
	Begin
		SELECT 
			Cd_Pes				[Code],
			Apelido				[Company Name],
			Nome_Raz_Soc		[Complete Name],
			P.Num_CPF_CNPJ		[CNPJ_CPF], 
			P.Num_RG_IE			[IE], 
			P.Cd_Tp_Ativ		[Type Of Activity Code],
            TA.Nome_Tp_Ativ		[Type Of Activity Name],			
			P.Cd_Tp_Grupo		[Group Type Code], 		
			TG.Nome_Tp_Grupo	[Group Type Name], 
			P.Cd_Usuario		[User Code],
			US.Nome_Usuario		[User Name], 
			P.Dt_Cad			[Insert Date], 
            (CASE WHEN Desat_Pes = 'N' THEN CONVERT(Bit, 1) ELSE CONVERT(Bit, 0) END) AS Disable, 
			P.Obs_Pes			[Notes], 
			P.Num_Insc_Munic	[IM], 
            P.GLOBAL_ENTITY_ID  [Global Entity ID]

			--P.Cd_Tp_Classe		[Class Type Code],
			--TC.Nome_Tp_Classe	[Class Type Name],
			--P.Cd_Cta_Ctb		[Cta Ctb Code],	
			--CTA.Nome_Cta_Ctb	[Cta Ctb Name],
			--P.Cd_Tp_Pes			[Person Type Code],
			--P.Dupl_Cta_Master	[Dupl_Cta_Master],
			--P.Email				[Email],
			--P.PgtoRcto			[PgtoRcto],
			--P.GIX_HT_Customer	[GIX_HT_Customer]
		FROM dbo.Pessoa P WITH (nolock) 
			LEFT OUTER JOIN dbo.Tipo_Atividade AS TA WITH (nolock) ON P.Cd_Tp_Ativ = TA.Cd_Tp_Ativ 
			LEFT OUTER JOIN dbo.Tipo_Grupo AS TG WITH (nolock) ON P.Cd_Tp_Grupo = TG.Cd_Tp_Grupo 
			LEFT OUTER JOIN	dbo.Usuario AS US WITH (nolock) ON P.Cd_Usuario = US.Cd_Usuario

			--LEFT OUTER JOIN dbo.Tipo_Classe AS TC WITH (nolock) ON P.Cd_Tp_Classe = TC.Cd_Tp_Classe 
			--LEFT OUTER JOIN	dbo.Cta_Ctb AS CTA WITH (nolock) ON P.Cd_Cta_Ctb = CTA.Cd_Cta_Ctb
			
	ENd
	
if @Tipo = 'B'
	Begin
		SELECT 
			Cd_Pes				[Code],
			Apelido				[Company Name],
			Nome_Raz_Soc		[Complete Name],
			P.Num_CPF_CNPJ		[CNPJ_CPF], 
			P.Num_RG_IE			[IE], 
			P.Cd_Tp_Ativ		[Type Of Activity Code],
            TA.Nome_Tp_Ativ		[Type Of Activity Name],			
			P.Cd_Tp_Grupo		[Group Type Code], 		
			TG.Nome_Tp_Grupo	[Group Type Name], 
			P.Cd_Usuario		[User Code],
			US.Nome_Usuario		[User Name], 
			P.Dt_Cad			[Insert Date], 
            (CASE WHEN Desat_Pes = 'N' THEN CONVERT(Bit, 1) ELSE CONVERT(Bit, 0) END) AS Disable, 
			P.Obs_Pes			[Notes], 
			P.Num_Insc_Munic	[IM], 
            P.GLOBAL_ENTITY_ID  [Global Entity ID]
		FROM dbo.Pessoa P WITH (nolock) 
			LEFT OUTER JOIN dbo.Tipo_Atividade AS TA WITH (nolock) ON P.Cd_Tp_Ativ = TA.Cd_Tp_Ativ 
			LEFT OUTER JOIN dbo.Tipo_Grupo AS TG WITH (nolock) ON P.Cd_Tp_Grupo = TG.Cd_Tp_Grupo 
			LEFT OUTER JOIN	dbo.Usuario AS US WITH (nolock) ON P.Cd_Usuario = US.Cd_Usuario
		where 
			Desat_Pes = 'N'
	End

if @Tipo = 'C' 
	Begin	
		SELECT 
			Cd_Pes				[Code],
			Apelido				[Company Name],
			Nome_Raz_Soc		[Complete Name],
			P.Num_CPF_CNPJ		[CNPJ_CPF], 
			P.Num_RG_IE			[IE], 
			P.Cd_Tp_Ativ		[Type Of Activity Code],
            TA.Nome_Tp_Ativ		[Type Of Activity Name],			
			P.Cd_Tp_Grupo		[Group Type Code], 		
			TG.Nome_Tp_Grupo	[Group Type Name], 
			P.Cd_Usuario		[User Code],
			US.Nome_Usuario		[User Name], 
			P.Dt_Cad			[Insert Date], 
            (CASE WHEN Desat_Pes = 'N' THEN CONVERT(Bit, 1) ELSE CONVERT(Bit, 0) END) AS Disable, 
			P.Obs_Pes			[Notes], 
			P.Num_Insc_Munic	[IM], 
            P.GLOBAL_ENTITY_ID  [Global Entity ID]
		FROM dbo.Pessoa P WITH (nolock) 
			LEFT OUTER JOIN dbo.Tipo_Atividade AS TA WITH (nolock) ON P.Cd_Tp_Ativ = TA.Cd_Tp_Ativ 
			LEFT OUTER JOIN dbo.Tipo_Grupo AS TG WITH (nolock) ON P.Cd_Tp_Grupo = TG.Cd_Tp_Grupo 
			LEFT OUTER JOIN	dbo.Usuario AS US WITH (nolock) ON P.Cd_Usuario = US.Cd_Usuario
		where 
			Cd_Pes = @Cd_Pes
	End
		
if @Tipo = 'D'
	Begin
		SELECT 
			Cd_Pes				[Code],
			Apelido				[Company Name],
			Nome_Raz_Soc		[Complete Name],
			P.Num_CPF_CNPJ		[CNPJ_CPF], 
			P.Num_RG_IE			[IE], 
			P.Cd_Tp_Ativ		[Type Of Activity Code],
            TA.Nome_Tp_Ativ		[Type Of Activity Name],			
			P.Cd_Tp_Grupo		[Group Type Code], 		
			TG.Nome_Tp_Grupo	[Group Type Name], 
			P.Cd_Usuario		[User Code],
			US.Nome_Usuario		[User Name], 
			P.Dt_Cad			[Insert Date], 
            (CASE WHEN Desat_Pes = 'N' THEN CONVERT(Bit, 1) ELSE CONVERT(Bit, 0) END) AS Disable, 
			P.Obs_Pes			[Notes], 
			P.Num_Insc_Munic	[IM], 
            P.GLOBAL_ENTITY_ID  [Global Entity ID]
		FROM dbo.Pessoa P WITH (nolock) 
			LEFT OUTER JOIN dbo.Tipo_Atividade AS TA WITH (nolock) ON P.Cd_Tp_Ativ = TA.Cd_Tp_Ativ 
			LEFT OUTER JOIN dbo.Tipo_Grupo AS TG WITH (nolock) ON P.Cd_Tp_Grupo = TG.Cd_Tp_Grupo 
			LEFT OUTER JOIN	dbo.Usuario AS US WITH (nolock) ON P.Cd_Usuario = US.Cd_Usuario
		where 
			Cd_Pes = @Cd_Pes and Desat_Pes = 'N'
	End	
	
if @Tipo = 'N' 
	Begin
		SELECT 
			Cd_Pes				[Code],
			Apelido				[Company Name],
			Nome_Raz_Soc		[Complete Name],
			P.Num_CPF_CNPJ		[CNPJ_CPF], 
			P.Num_RG_IE			[IE], 
			P.Cd_Tp_Ativ		[Type Of Activity Code],
            TA.Nome_Tp_Ativ		[Type Of Activity Name],			
			P.Cd_Tp_Grupo		[Group Type Code], 		
			TG.Nome_Tp_Grupo	[Group Type Name], 
			P.Cd_Usuario		[User Code],
			US.Nome_Usuario		[User Name], 
			P.Dt_Cad			[Insert Date], 
            (CASE WHEN Desat_Pes = 'N' THEN CONVERT(Bit, 1) ELSE CONVERT(Bit, 0) END) AS Disable, 
			P.Obs_Pes			[Notes], 
			P.Num_Insc_Munic	[IM], 
            P.GLOBAL_ENTITY_ID  [Global Entity ID]
		FROM dbo.Pessoa P WITH (nolock) 
			LEFT OUTER JOIN dbo.Tipo_Atividade AS TA WITH (nolock) ON P.Cd_Tp_Ativ = TA.Cd_Tp_Ativ 
			LEFT OUTER JOIN dbo.Tipo_Grupo AS TG WITH (nolock) ON P.Cd_Tp_Grupo = TG.Cd_Tp_Grupo 
			LEFT OUTER JOIN	dbo.Usuario AS US WITH (nolock) ON P.Cd_Usuario = US.Cd_Usuario
		where 
			Apelido = @Apelido
	End	
	
if @Tipo = 'O'
	Begin
		SELECT 
			Cd_Pes				[Code],
			Apelido				[Company Name],
			Nome_Raz_Soc		[Complete Name],
			P.Num_CPF_CNPJ		[CNPJ_CPF], 
			P.Num_RG_IE			[IE], 
			P.Cd_Tp_Ativ		[Type Of Activity Code],
            TA.Nome_Tp_Ativ		[Type Of Activity Name],			
			P.Cd_Tp_Grupo		[Group Type Code], 		
			TG.Nome_Tp_Grupo	[Group Type Name], 
			P.Cd_Usuario		[User Code],
			US.Nome_Usuario		[User Name], 
			P.Dt_Cad			[Insert Date], 
            (CASE WHEN Desat_Pes = 'N' THEN CONVERT(Bit, 1) ELSE CONVERT(Bit, 0) END) AS Disable, 
			P.Obs_Pes			[Notes], 
			P.Num_Insc_Munic	[IM], 
            P.GLOBAL_ENTITY_ID  [Global Entity ID]
		FROM dbo.Pessoa P WITH (nolock) 
			LEFT OUTER JOIN dbo.Tipo_Atividade AS TA WITH (nolock) ON P.Cd_Tp_Ativ = TA.Cd_Tp_Ativ 
			LEFT OUTER JOIN dbo.Tipo_Grupo AS TG WITH (nolock) ON P.Cd_Tp_Grupo = TG.Cd_Tp_Grupo 
			LEFT OUTER JOIN	dbo.Usuario AS US WITH (nolock) ON P.Cd_Usuario = US.Cd_Usuario
		where 
			Apelido = @Apelido and Desat_Pes = 'N'
	End	
	
if @Tipo = 'Z' --or @Tipo = 'O'
	Begin
		SELECT 
			Cd_Pes				[Code],
			Apelido				[Company Name],
			Nome_Raz_Soc		[Complete Name],
			P.Num_CPF_CNPJ		[CNPJ_CPF], 
			P.Num_RG_IE			[IE], 
			P.Cd_Tp_Ativ		[Type Of Activity Code],
            TA.Nome_Tp_Ativ		[Type Of Activity Name],			
			P.Cd_Tp_Grupo		[Group Type Code], 		
			TG.Nome_Tp_Grupo	[Group Type Name], 
			P.Cd_Usuario		[User Code],
			US.Nome_Usuario		[User Name], 
			P.Dt_Cad			[Insert Date], 
            (CASE WHEN Desat_Pes = 'N' THEN CONVERT(Bit, 1) ELSE CONVERT(Bit, 0) END) AS Disable, 
			P.Obs_Pes			[Notes], 
			P.Num_Insc_Munic	[IM], 
            P.GLOBAL_ENTITY_ID  [Global Entity ID]
		FROM dbo.Pessoa P WITH (nolock) 
			LEFT OUTER JOIN dbo.Tipo_Atividade AS TA WITH (nolock) ON P.Cd_Tp_Ativ = TA.Cd_Tp_Ativ 
			LEFT OUTER JOIN dbo.Tipo_Grupo AS TG WITH (nolock) ON P.Cd_Tp_Grupo = TG.Cd_Tp_Grupo 
			LEFT OUTER JOIN	dbo.Usuario AS US WITH (nolock) ON P.Cd_Usuario = US.Cd_Usuario
		where 
			Apelido = @Apelido and Cd_Pes <> @Cd_Pes
	End

if @Tipo = 'G'
	Begin	
		SELECT 
			Cd_Pes				[Code],
			Apelido				[Company Name],
			Nome_Raz_Soc		[Complete Name],
			P.Num_CPF_CNPJ		[CNPJ_CPF], 
			P.Num_RG_IE			[IE], 
			P.Cd_Tp_Ativ		[Type Of Activity Code],
            TA.Nome_Tp_Ativ		[Type Of Activity Name],			
			P.Cd_Tp_Grupo		[Group Type Code], 		
			TG.Nome_Tp_Grupo	[Group Type Name], 
			P.Cd_Usuario		[User Code],
			US.Nome_Usuario		[User Name], 
			P.Dt_Cad			[Insert Date], 
            (CASE WHEN Desat_Pes = 'N' THEN CONVERT(Bit, 1) ELSE CONVERT(Bit, 0) END) AS Disable, 
			P.Obs_Pes			[Notes], 
			P.Num_Insc_Munic	[IM], 
            P.GLOBAL_ENTITY_ID  [Global Entity ID]
		FROM dbo.Pessoa P WITH (nolock) 
			LEFT OUTER JOIN dbo.Tipo_Atividade AS TA WITH (nolock) ON P.Cd_Tp_Ativ = TA.Cd_Tp_Ativ 
			LEFT OUTER JOIN dbo.Tipo_Grupo AS TG WITH (nolock) ON P.Cd_Tp_Grupo = TG.Cd_Tp_Grupo 
			LEFT OUTER JOIN	dbo.Usuario AS US WITH (nolock) ON P.Cd_Usuario = US.Cd_Usuario
			LEFT OUTER JOIN dbo.Grupo G on G.Cd_Pes_Grupo = P.Cd_Pes
		Where
			P.Cd_Pes = @Cd_Pes and P.Desat_Pes = 'N'
			and G.Grupo is null
	end
	
if @Tipo = 'H'
	Begin	
		--Select 
		--	PP.Cd_Pes [Code],
		--	PP.Apelido [Company Name],
		--	PP.Nome_Raz_Soc [Complete Name]
		--from
		--	Pessoa PP
		--	left join Grupo G on G.Cd_Pes_Grupo = PP.Cd_Pes
		--Where
		--	PP.Apelido = @Apelido and PP.Desat_Pes = 'N'
		--	and G.Grupo is null

		SELECT 
			Cd_Pes				[Code],
			Apelido				[Company Name],
			Nome_Raz_Soc		[Complete Name],
			P.Num_CPF_CNPJ		[CNPJ_CPF], 
			P.Num_RG_IE			[IE], 
			P.Cd_Tp_Ativ		[Type Of Activity Code],
            TA.Nome_Tp_Ativ		[Type Of Activity Name],			
			P.Cd_Tp_Grupo		[Group Type Code], 		
			TG.Nome_Tp_Grupo	[Group Type Name], 
			P.Cd_Usuario		[User Code],
			US.Nome_Usuario		[User Name], 
			P.Dt_Cad			[Insert Date], 
            (CASE WHEN Desat_Pes = 'N' THEN CONVERT(Bit, 1) ELSE CONVERT(Bit, 0) END) AS Disable, 
			P.Obs_Pes			[Notes], 
			P.Num_Insc_Munic	[IM], 
            P.GLOBAL_ENTITY_ID  [Global Entity ID]
		FROM dbo.Pessoa P WITH (nolock) 
			LEFT OUTER JOIN dbo.Tipo_Atividade AS TA WITH (nolock) ON P.Cd_Tp_Ativ = TA.Cd_Tp_Ativ 
			LEFT OUTER JOIN dbo.Tipo_Grupo AS TG WITH (nolock) ON P.Cd_Tp_Grupo = TG.Cd_Tp_Grupo 
			LEFT OUTER JOIN	dbo.Usuario AS US WITH (nolock) ON P.Cd_Usuario = US.Cd_Usuario
			LEFT OUTER JOIN dbo.Grupo G on G.Cd_Pes_Grupo = P.Cd_Pes
		Where
			P.Apelido = @Apelido and P.Desat_Pes = 'N'
			and G.Grupo is null
	end


if @Tipo = 'F'
	Begin
		Select 
			Apelido [Company Name]
		from
			Pessoa with(nolock)
		where 
			Desat_Pes = 'N'
		order by 1
	End
	

	

	*/
GO
