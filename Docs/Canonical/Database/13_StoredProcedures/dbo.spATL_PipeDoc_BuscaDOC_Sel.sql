SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE  Procedure spATL_PipeDoc_BuscaDOC_Sel  --'EMSTB201205008BR','IMARG201203175AR'

		@Num_Proc Varchar(16),
		@Num_Proc_Org	Varchar(16)

AS

Select 
	upper(@Num_Proc_Org) + '_' + Smart_DOC + '.PDF' Doc,upper(Nome_Arquivo) Nome_Arquivo,DA.ID_DC
From
	Doc_Anexos DA
	Join Tipo_Doc_Cliente TC on TC.id_dc=DA.id_Dc
Where
	Num_Proc=@Num_Proc and TC.ID_DC in (20,2,11)



GO
