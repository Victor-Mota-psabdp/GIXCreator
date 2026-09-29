SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[spREView_Sel]--'EMOXT201702255BR'
(
	@Num_Proc varchar(16)
)
as

select distinct 
	Num_Proc		JOB,
	left(Nome_Arquivo,12)	RE,	
	[Status],
	Nome_Arquivo	[Nome_Arquivo]
from Doc_Anexos_Emix
where 
	Num_Proc = @Num_Proc 	
	
	
--union all

--select 
--	Num_Proc_HEA JOB,
--	Numero_PO_HEA	RE,
--	replace(replace(Numero_PO_HEA,'/',''),'-','')+ '.pdf' [Nome_Arquivo]		
--from PO_HEA		
--where 
--	Num_Proc_HEA = @Num_Proc 
--	and ID_DC = 4
	
--union all

--select 
--	Num_Proc_HEO JOB,
--	Numero_PO_HEO	RE,
--	replace(replace(Numero_PO_HEO,'/',''),'-','')+ '.pdf' [Nome_Arquivo]		
--from PO_HEo		
--where 
--	Num_Proc_HEO = @Num_Proc 
--	and ID_DC = 4
	
	




GO
