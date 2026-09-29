SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[spLog_Pais_Sel]
(
	@Cd_Pais		VARCHAR(2),		
	@Tipo			char(1)
)
AS

if @Tipo = 'A' 
	BEGIN
		Select 
			P.ID_Log				[Log ID],
			P.Dt_Alter				[Log Date],
			P.Tp_Oper				[Log Type Code],
			ALT.Nome_Tp_Log_Oper	[Log Type Name],

			P.Cd_Pais				[Country Code],
			P.Nome_Pais				[Country Name],
			P.FORM_A				[FORM_A],
			P.Nome_Pais_PT			[Country Name PT],
			P.Paraiso_Fiscal		[Paraiso_Fiscal],
			P.HTS					[HTS],	 
			P.Proibido				[Prohibited],
			P.Bloqueado				[Blocked],
			P.Cd_Pais_IBGE			[IBGE],
			P.Cd_M49				[M49],
			P.Cd_Usuario			[User Code],	 
			us.Nome_Usuario			[User Name],			
			P.Ativo					[Enabled]
		
		from Log_Pais P with(nolock)
		left join Usuario     US    on US.Cd_Usuario = P.Cd_Usuario
		left join Tipo_Log_Oper	Alt	with(nolock) on Alt.Cd_Tp_Log_Oper = P.Tp_Oper
		
		order by 
			P.Dt_Alter
	END

if @Tipo = 'C' 
	BEGIN
		Select 
			P.ID_Log				[Log ID],
			P.Dt_Alter				[Log Date],
			P.Tp_Oper				[Log Type Code],
			ALT.Nome_Tp_Log_Oper	[Log Type Name],

			P.Cd_Pais				[Country Code],
			P.Nome_Pais				[Country Name],
			P.FORM_A				[FORM_A],
			P.Nome_Pais_PT			[Country Name PT],
			P.Paraiso_Fiscal		[Paraiso_Fiscal],
			P.HTS					[HTS],	 
			P.Proibido				[Prohibited],
			P.Bloqueado				[Blocked],
			P.Cd_Pais_IBGE			[IBGE],
			P.Cd_M49				[M49],
			P.Cd_Usuario			[User Code],	 
			us.Nome_Usuario			[User Name],			
			P.Ativo					[Enabled]
		
		from Log_Pais P with(nolock)
		left join Usuario     US    on US.Cd_Usuario = P.Cd_Usuario
		left join Tipo_Log_Oper	Alt	with(nolock) on Alt.Cd_Tp_Log_Oper = P.Tp_Oper

		Where
			P.Cd_Pais = @Cd_Pais
		order by 
			P.Dt_Alter
	END

	if @Tipo = 'N' 
	BEGIN
		Select 
			P.ID_Log				[Log ID],
			P.Dt_Alter				[Log Date],
			P.Tp_Oper				[Log Type Code],
			ALT.Nome_Tp_Log_Oper	[Log Type Name],

			P.Cd_Pais				[Country Code],
			P.Nome_Pais				[Country Name],
			P.FORM_A				[FORM_A],
			P.Nome_Pais_PT			[Country Name PT],
			P.Paraiso_Fiscal		[Paraiso_Fiscal],
			P.HTS					[HTS],	 
			P.Proibido				[Prohibited],
			P.Bloqueado				[Blocked],
			P.Cd_Pais_IBGE			[IBGE],
			P.Cd_M49				[M49],
			P.Cd_Usuario			[User Code],	 
			us.Nome_Usuario			[User Name],			
			P.Ativo					[Enabled]
		
		from Log_Pais P with(nolock)
		left join Usuario     US    on US.Cd_Usuario = P.Cd_Usuario
		left join Tipo_Log_Oper	Alt	with(nolock) on Alt.Cd_Tp_Log_Oper = P.Tp_Oper

		where P.Cd_Pais = ''
			
	END




GO
