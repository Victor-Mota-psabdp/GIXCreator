SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--select * from Pais where Cd_Pais = 'DO'
--alter table [dbo].[Pais] add [Nome_Pais_PT] [varchar](100) NULL
--update pais set nome_pais_pt = 'ESTADOS UNIDOS'  where Cd_Pais = 'US'
--update pais set nome_pais_pt = 'CORÉIA, REPÚBLICA DA'  where Cd_Pais = 'KR'
--update pais set nome_pais_pt = 'ALGÉRIA'  where Cd_Pais = 'DZ'
--update pais set nome_pais_pt = 'PAÍSES BAIXOS'  where Cd_Pais = 'NL'

CREATE Procedure [dbo].[spPais_Portugues_Upd]

		@Cd_Pais 			varchar(2),
		@Nome_Pais_PT		Varchar(100)

as

	update [Pais] set [Nome_Pais_PT] = @Nome_Pais_PT where Cd_Pais = @Cd_Pais












GO
