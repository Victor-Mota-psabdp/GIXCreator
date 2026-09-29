SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[spTipo_Doc_Cliente_DocAnexos_By_JOB_Sel]--'IMOXT202104030BR'
(
	@num_proc as Varchar(16)	
)
as
select ID_DC, Nome_DC from Tipo_Doc_Cliente where Doc_Anexo='S'  and House = 'S' 
and ID_DC not in (select ID_DC from Doc_Anexos where num_proc = @num_proc)
and isnull(Multiplos,'N')='N' 
union all
select ID_DC, Nome_DC from Tipo_Doc_Cliente where Multiplos='S' 
order by 1


GO
