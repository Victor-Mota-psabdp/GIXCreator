SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE  Procedure spSmartNecessidadeLI_Sel
	@Num_proc Varchar(16)
	
AS

select 
	( case 	campo_dados
		 When 2 then 'N'
		 else 'Y'
	  End
	) Campo
		
 from 
	campo_processo 
where 
	id_campo=5
	and num_proc=@num_proc
GO
