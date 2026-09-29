SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[spATL_ExtratoEmix_Rel]
	@datainicial varchar(10),
	@datafinal	Varchar(10)
AS


select 
	Nome_Consulta_Tipo [Tipo Consulta],valor [Número],num_proc [Job] ,
	dt_ins [Data]
	
from E_Mix_Consulta C with(nolock)
	Join E_Mix_Consulta_Tipo T with(nolock) on T.ID_consulta_tipo=C.id_consulta_tipo 

Where 
	convert(Datetime, convert(varchar(10),dt_ins,103),103) between @datainicial and @datafinal 
	
OPTION(HASH JOIN)
GO
