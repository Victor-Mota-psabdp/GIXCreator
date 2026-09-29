SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE Procedure [dbo].[spATL_Tipo_DocAnexos_Sel]--''
	
	@Processo	VarChar(16)

AS	
	select 
	RIGHT('000' + convert(varchar(3),ID_DC),3) + '-' + Nome_DC 
	from 
		Tipo_Doc_Cliente
	where 
		Doc_Anexo='S' and House = 'S' 
		and ID_DC not in
		(select ID_DC from Doc_Anexos 
		where num_proc = @Processo)
	order by id_dc
			
		
		




GO
