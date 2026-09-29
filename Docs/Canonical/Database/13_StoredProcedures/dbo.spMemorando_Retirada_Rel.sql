SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--SELECT * from vwHouse_Imp WHERE Num_Proc = 'IMLAN201707002BR'
--[spMemorando_Retirada_Rel] 'IMLAN201707002BR'
CREATE Procedure [dbo].[spMemorando_Retirada_Rel]--'IMLAN201707002BR'
(
	@Num_Proc	varchar(16)
)
As		

select 
	UPPER(AR.Nome_Armador)			Nome_Armador,
	JOB.MAWB						[ReservaHBL],
	'BDP SOUTH AMERICA LTDA'		[Importador],
	ISNULL(JOB.VESSEL,'') + ' / ' + 	ISNULL(JOB.Viagem,'')	[Navio]	
from vwHouse_Imp JOB with(nolock)
	LEFT JOIN Armador AR ON AR.Cd_Armador = JOB.Cd_Armador
where
	JOB.Num_Proc = @Num_Proc
	

GO
