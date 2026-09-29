SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE Procedure [dbo].[spATL_Tipo_Doc_Cliente_Sel]

AS	
	select 
		RIGHT('000' + convert(varchar(3),ID_DC),3) + '-' + Nome_DC [Documents  -  Mandatory:],
		convert(bit,0) [YES],convert(bit,0) [NO]
	from 
		Tipo_Doc_Cliente
	where 
		Doc_Anexo='S' and House = 'S'		
	order by id_dc
	
/*
ALTER Procedure [dbo].[spATL_Tipo_Doc_Cliente_Sel]

AS	
	select 
	RIGHT('000' + convert(varchar(3),ID_DC),3) + '-' + Nome_DC 
	from 
		Tipo_Doc_Cliente
	where 
		Doc_Anexo='S' and House = 'S'		
	order by id_dc
*/
GO
