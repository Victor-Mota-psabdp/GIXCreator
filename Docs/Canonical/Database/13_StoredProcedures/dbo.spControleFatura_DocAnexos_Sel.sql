SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE	Procedure [dbo].[spControleFatura_DocAnexos_Sel]--'IMATL201109009BR' 
	
	@Processo	VarChar(16)

AS	

	Select
		right('000' + convert(varchar(3),Item_Doc),3) [Item],
		TD.Nome_DC [Type DOC],
		convert(varchar(12),Dt_Envio,103) [Sent Date],
		Nome_Arquivo [File],
		'Saved'	[Status]		
 	from 
		Doc_Anexos DA  With(nolock)
		Join Tipo_Doc_Cliente TD with(nolock) on TD.Id_DC = DA.Id_DC

	where 
		Num_Proc=@Processo

	order by 1




GO
