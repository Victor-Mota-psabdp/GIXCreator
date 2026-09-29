SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[vwATLDN_Tipo_Doc_Cliente_Sel]
AS
select
	right('000' + Convert(varchar(3),ID_DC),3) [Code],
	Nome_DC				[Nome],
	Nome_DC				[Doc Type Name],
	Smart_Doc			[Smart Doc],
	DMS_Code			[DMS Code],
	Data_Obrigatoria	[Required Date],
	Numero_Obrigatorio	[Required Number],
	Doc_Anexo			[Attached Document],
	Replica				[Replica],
	House				[House],
	Historico			[Historic],
	GenericReference	[GenericReference],
	Data_Habilita		[Data_Habilita],
	Numero_Habilita		[Numero_Habilita],
	Multiplos			[Multiplos]
from 
	Tipo_Doc_Cliente with(nolock)

--select
--	right('000' + Convert(varchar(3),ID_DC),3) [Code],
--	Nome_DC				[Nome],
--	Nome_DC				[Doc Type Name],
--	Smart_Doc			[Smart Doc],
--	DMS_Code			[DMS Code],
--	Data_Obrigatoria	[Required Date],
--	Numero_Obrigatorio	[Required Number],
--	Doc_Anexo			[Attached Document],
--	Replica				[Replica],
--	House				[House],
--	Historico			[Historic]
----GenericReference
----Data_Habilita
----Numero_Habilita
--from 
--	Tipo_Doc_Cliente with(nolock)
	
	
--SELECT     [Code], [Nome],[Smart Doc],[DMS Code],[Data Obrigatoria],[Numero Obrigatorio],[Doc Anexo],[Replica],[House]
--FROM         (SELECT 
--				right('000' + Convert(varchar(3),ID_DC),3) [Code], 
--				Nome_DC [Nome],
--				Smart_Doc [Smart Doc],
--				Data_Obrigatoria [Data Obrigatoria],
--				Numero_Obrigatorio [Numero Obrigatorio],
--				Doc_Anexo [Doc Anexo],
--				Replica [Replica],
--				House [House],
--				DMS_Code [DMS Code]
--               FROM          dbo.Tipo_Doc_Cliente 
--              ) AS Alias

GO
